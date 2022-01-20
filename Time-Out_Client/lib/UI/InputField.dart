import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class InputField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool? multiline;
  final bool? enabled;
  final bool? isPassword;
  final bool? isUsername;
  final Color? colorBorder;
  final Function(String)? onChanged;
  final Function(String)? onSubmit;
  final Function()? onTap;
  final int? maxLength;
  final TextAlign? textAlign;
  final TextInputType? keyboardType;

  const InputField({Key? key, required this.labelText, required this.controller,
    this.onChanged, this.onSubmit, this.onTap, this.keyboardType,
    this.multiline, this.colorBorder, this.textAlign, this.maxLength, this.isPassword = false, this.isUsername = false,
    this.enabled = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: TextField(
          enabled: enabled,
          maxLength: maxLength,
          obscureText: isPassword!,
          textAlign: this.textAlign != null ? this.textAlign! : TextAlign.left,
          maxLines: multiline != null && multiline == true ? null : 1,
          keyboardType: keyboardType,
          inputFormatters: keyboardType == TextInputType.number ? <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          ] : null,
          onChanged: onChanged,
          onSubmitted: onSubmit,
          onTap: onTap,
          controller: controller,
          cursorColor: Colors.white,
          style: TextStyle(height: 1.0, color: Colors.white),
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
                borderRadius: new BorderRadius.circular(30.0),
                borderSide: BorderSide(
                  color: colorBorder==null? Colors.green:colorBorder!,
                )
            ),
            enabledBorder: new OutlineInputBorder(
              borderRadius: new BorderRadius.circular(30.0),
              borderSide: BorderSide(
                color:  colorBorder==null? Colors.green:colorBorder!,
              ),
            ),
            labelText: labelText,
            labelStyle: TextStyle(
              color: Colors.green,
            ),
          )
      ),
    );
  }

}