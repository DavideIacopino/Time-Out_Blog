import 'package:flutter/material.dart';
import 'package:timeoutflutter/UI/CircularIconButton.dart';
import 'package:timeoutflutter/UI/GlobalState.dart';
import 'package:timeoutflutter/UI/InputAutocomplete.dart';
import 'package:timeoutflutter/UI/InputField.dart';
import 'package:timeoutflutter/model/ModelFacade.dart';
import 'package:timeoutflutter/model/objects/Rubrica.dart';

class NuovoArticoloForm extends StatefulWidget {
  final Function onSubmit;
  List<Rubrica> rubriche_list=List.empty(growable: true);

  NuovoArticoloForm({required this.rubriche_list, required this.onSubmit, Key? key}) : super(key: key);

  _NuovoArticoloFormState createState() =>
      _NuovoArticoloFormState(this.onSubmit);
}

  class _NuovoArticoloFormState extends GlobalState<NuovoArticoloForm>{
    final Function onSubmit;

    Rubrica? _rubrica;
    String? _testo;
    String? _topic;
    String? _img;
    List<String>? _tags=List.empty(growable: true);

    TextEditingController? _autocompleteNomeRubricaController=TextEditingController();
    TextEditingController? _inputFieldTestoController = TextEditingController();
    TextEditingController? _inputFieldTagsController = TextEditingController();
    TextEditingController? _topicTextController = TextEditingController();
    TextEditingController? _inputFieldImgController = TextEditingController();

    _NuovoArticoloFormState(this.onSubmit);
    List<Rubrica> rubriche_list=List.empty(growable: true);

  @override
  Widget build(BuildContext context) {
    return Flexible(
        child:Container(
          height: 400,
          child: SingleChildScrollView(scrollDirection: Axis.vertical,
            child:Container(
              height:400,
            child:Column(
            mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text ("NUOVO ARTICOLO", style: TextStyle(fontFamily: "charcoal", color: Colors.white)),
            Flexible(
              child: InputAutocomplete(
                labelText: "Rubrica",
                controller: _autocompleteNomeRubricaController!,
                onSuggestion: (String pattern) {
                  List<Rubrica> suggestions=List.from(rubriche_list);
                  for ( Rubrica element in rubriche_list ) {
                    if (pattern != null && pattern != "" && !element.nome.toLowerCase().contains(pattern.toLowerCase()))
                      suggestions.remove(element);
                  }
                  return suggestions;
                },
                onSelect: (suggestion) {
                  _autocompleteNomeRubricaController!.text = suggestion.toString();
                  _rubrica=suggestion as Rubrica?;
                },
              ),
              flex: 1,
            ),
            Flexible(
              child: InputField(
                labelText: "Argomento",
                controller: _topicTextController!,
                onChanged: (String value) {
                  _topic = value;
                },
              ),
              flex: 1,
            ),
            Flexible( child:InputField(
              colorBorder: Colors.green,
              labelText: "Testo",
              controller: _inputFieldTestoController!,
              onChanged: (String value) {
                _testo = value;
              },
            ),
              flex: 1,
            ),
            Flexible(
              child:InputField(
                colorBorder: Colors.green,
                labelText: "Lista di tags: scrivi il tag e premi invio per aggiungerlo alla lista",
                controller: _inputFieldTagsController!,
                onSubmit: (String value){
                  _tags!.add(value);
                  _inputFieldTagsController!.clear();
                  setState((){});
                  },
                ),
                flex: 1,
                ),
            Flexible(
              flex: 1,
                child: Text("Tag già aggiunti: "+_tags.toString(),
                    style: TextStyle(color: Colors.white, fontSize: 12.0, fontStyle: FontStyle.italic)
                )
            ),
            Flexible( child:InputField(
              colorBorder: Colors.green,
              labelText: "Immagine",
              controller: _inputFieldImgController!,
              onChanged: (String value) {
                _img = value;
              },
            ),
              flex: 1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children:[
                CircularIconButton(
                  onPress: () {
                    cleanInput();
                  },
                  background: Colors.green,
                  iconColor: Colors.black,
                  icon: Icons.delete_rounded,
                ),
                CircularIconButton(
                  onPress: () {
                    if(_img!=null)
                      _img="/"+_img!;
                    onSubmit(_rubrica, _topic, _testo, _tags, DateTime.now(), _img);
                    cleanInput();
                  },
                  background: Colors.green,
                  iconColor: Colors.black,
                  icon: Icons.arrow_forward,
                ),
              ]
            ),
          ]
        ),
      )
    )));
  }

    void cleanInput() {
      _topicTextController!.clear();
      _inputFieldTestoController!.clear();
      _tags=List.empty(growable: true);
      _inputFieldImgController!.clear();
      _inputFieldTagsController!.clear();
      _autocompleteNomeRubricaController!.clear();
      setState((){
        _rubrica=null;
        _testo=null;
        _img=null;
        _topic=null;
      });
    }

      @override
  void refreshState() {
        setState(() {});
      }

    @override
    void initState() {
      cleanInput();
      rubriche_list= ModelFacade.sharedInstance.appState.getValue("RUBRICHE");
      super.initState();
    }
  }
