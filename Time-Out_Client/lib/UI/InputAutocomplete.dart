import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';


class InputAutocomplete extends StatelessWidget {
  final String labelText;
  final bool typeable;
  final FutureOr<Iterable<Object>> Function(String) onSuggestion;
  final Function(Object?) onSelect;
  final TextEditingController controller;


  const InputAutocomplete({Key? key, required this.labelText, required this.controller,
    required this.onSuggestion, required this.onSelect, this.typeable = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: TypeAheadField(
        textFieldConfiguration: TextFieldConfiguration(
          style: TextStyle(color: Colors.white),
          inputFormatters: [
            typeable ? FilteringTextInputFormatter.allow(RegExp(r'.')) : FilteringTextInputFormatter.allow(RegExp(r'^$')),
          ],
          cursorColor: Colors.white,
          autofocus: false,
          controller: controller,
          decoration: InputDecoration(
            fillColor: Colors.white,
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide(
                  color: Colors.green,
                )
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide(
                color: Colors.green,
              ),
            ),
            labelText: labelText,
            labelStyle: TextStyle(
              color: Colors.green,
            ),
          ),
        ),
        suggestionsCallback: onSuggestion,
        itemBuilder: (context, suggestion) {
          return ListTile(
            title: Text(suggestion.toString()),
          );
        },
        onSuggestionSelected: onSelect,
      ),
    );
  }
}