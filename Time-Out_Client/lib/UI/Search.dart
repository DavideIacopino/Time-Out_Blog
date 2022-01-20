import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timeoutflutter/UI/CircularIconButton.dart';
import 'package:timeoutflutter/UI/GlobalState.dart';
import 'package:timeoutflutter/UI/InputAutocomplete.dart';
import 'package:timeoutflutter/UI/InputField.dart';
import 'package:timeoutflutter/UI/RubricaDetails.dart';
import 'package:timeoutflutter/UI/SearchResults.dart';
import 'package:timeoutflutter/UI/Top.dart';
import 'package:timeoutflutter/model/Constant.dart';
import 'package:timeoutflutter/model/ModelFacade.dart';
import 'package:timeoutflutter/model/objects/Articolo_Home.dart';
import 'package:timeoutflutter/model/objects/Rubrica.dart';

enum Method {
  advancedSearch,
  loadArticoli
}

class Search extends StatefulWidget {
  static const String searchRoute ="search";
  List<Rubrica> rubriche_list=List.empty(growable: true);

  Search(this.rubriche_list, {Key? key}) : super(key: key);
  
  @override
  _SearchState createState() => _SearchState(rubriche_list);
}

class _SearchState extends GlobalState<Search> {
  List<Rubrica> rubriche_list=List.empty(growable: true);

  List<Articolo_Home> results=List.empty(growable: true);

  String? _nomeRubrica;
  String? _topic;
  String? _startDate;
  String? _endDate;
  List<String>? _tags=List.empty(growable: true);
  DateTime? _dataPartenza;
  DateTime? _dataFine;

  TextEditingController _autocompleteNomeRubricaController=TextEditingController();
  TextEditingController _startDateTextController = TextEditingController();
  TextEditingController _endDateTextController = TextEditingController();
  TextEditingController _topicTextController = TextEditingController();
  TextEditingController _tagsTextController = TextEditingController();

  bool isNotPressed=true;

  _SearchState(this.rubriche_list);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
            child: Top(),
            flex: 1,
          ),
          Column(
                mainAxisSize:MainAxisSize.min ,
                children: [
                  Flexible(
                    child: InputAutocomplete(
                      labelText: "Rubrica",
                      controller: _autocompleteNomeRubricaController,
                      onSuggestion: (String pattern) {
                        List<Rubrica> suggestions=List.from(rubriche_list);
                        for ( Rubrica element in rubriche_list ) {
                          if (pattern != null && pattern != "" && !element.nome.toLowerCase().contains(pattern.toLowerCase()))
                            suggestions.remove(element);
                        }
                        return suggestions;
                        },
                        onSelect: (suggestion) {
                        _autocompleteNomeRubricaController.text = suggestion.toString();
                        _nomeRubrica = suggestion.toString();
                        },
                      ),
                  ),
                  Flexible(
                    child: InputField(
                      labelText: "Argomento",
                      controller: _topicTextController,
                      onChanged: (String value) {
                        _topic = value;
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10.0),
                    child: TextButton(
                      style: ButtonStyle(
                          overlayColor: MaterialStateProperty.all<Color>(Colors.green),
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.white)),
                      child: const Text ("Ricerca avanzata", style: TextStyle(fontFamily: "charcoal")),
                      onPressed: () {
                        setState(() {
                          isNotPressed=!isNotPressed;
                        });
                      },
                    ),
                  ),
                  AnimatedContainer(
                      height: isNotPressed? 0:250,
                      width: isNotPressed? 0:1000,
                      duration: Duration(seconds:1, milliseconds: 500),
                      child: Column(
                          children: [
                            Flexible( child: InputField(
                      colorBorder: isNotPressed? Colors.black:Colors.green,
                      labelText: "Lista di tags: scrivi il tag e premi invio per aggiungerlo alla lista",
                      controller: _tagsTextController,
                      onSubmit: (String value){
                        _tags!.add(value);
                        _tagsTextController.clear();
                        setState((){});
                      },
                    ),
                  ),
                  Flexible(
                    child: Text("Tag già aggiunti: "+_tags.toString(),
                      style: TextStyle(color: Colors.white, fontSize: 12.0, fontStyle: FontStyle.italic)
                    )
                  ),
                  Flexible(
                    child: InputField(
                      colorBorder: isNotPressed? Colors.black:Colors.green,
                      labelText: "A partire da: (formato data DD-MM-YYYY)",
                        controller: _startDateTextController,
                        onChanged: (value){
                          _startDate=value;
                        },
                    ),
                  ),
                  Flexible(
                    child: InputField(
                      colorBorder: isNotPressed? Colors.black:Colors.green,
                      labelText: "Fino a: (formato data DD-MM-YYYY)",
                      controller: _endDateTextController,
                      onChanged: (value){
                        _endDate=value;
                      },
                    ),
                  ),
          ]
        )
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
                          loadSearch();
                        },
                      background: Colors.green,
                      iconColor: Colors.black,
                      icon: Icons.search_rounded,
                      ),
                      ]
                  ),
                ]
              ),
        ]
      )
    );
  }

  void initState(){
    ModelFacade.sharedInstance.appState.removeValue(Constants.STATE_SEARCH_RESULT);
    cleanInput();
    super.initState();
  }

  void dispose() {
    super.dispose();
    ModelFacade.sharedInstance.appState.removeValue(Constants.STATE_SEARCH_RESULT);
  }

  @override
  void refreshState() {
    results = ModelFacade.sharedInstance.appState.getValue(Constants.STATE_SEARCH_RESULT);
    setState(() {});
  }

  void cleanInput(){
    _nomeRubrica=null;
    _autocompleteNomeRubricaController.clear();
    _topic=null;
    _topicTextController.clear();
    _tags=List.empty(growable: true);
    _tagsTextController.clear();
    _startDate=null;
    _startDateTextController.clear();
    _endDate=null;
    _endDateTextController.clear();
    setState(() {
      results=List.empty(growable: true);
    });
  }

  void loadSearch() {
    if(_nomeRubrica==null && _startDate==null && _endDate==null && ( _tags== null || _tags!.isEmpty) && _topic==null) {
      ModelFacade.sharedInstance.loadArticoli(fromSearch: true).then(
              (value) =>
              setState(() {
                results = value;
                if(results!=null && results.isNotEmpty) {
                  Map<String, dynamic> reqResp = new Map();
                  reqResp['method'] = Method.loadArticoli;
                  reqResp['results'] = results;
                  Map<String, dynamic> params = new Map();
                  params['fromSearch'] = true;
                  reqResp['request'] = params;
                  Navigator.pushNamed(
                      context, SearchResults.resultsRoute, arguments: reqResp);
                }else{
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(duration:  Duration(seconds: 5),
                    content: Text("Non ci sono risultati che soddisfano la ricerca",
                    style: TextStyle(color: Colors.black),),
                    backgroundColor: Colors.green));
                }
              }));
              }
    if(_nomeRubrica!=null && _startDate==null && _endDate==null && ( _tags== null || _tags!.isEmpty) && (_topic==null || _topic=="")) {
      Navigator.pushNamed(context, RubricaDetails.rubricaRoute, arguments: _nomeRubrica as String);
    }
    if(_startDate!=null) {
      RegExp r = RegExp("(0[1-9]|[12][0-9]|3[01])-(0[1-9]|1[012])-[0-9]{4}");
      if (r.hasMatch(_startDate!)) {
        List<String> data = _startDate!.split("-");
        _dataPartenza = DateTime(
            int.parse(data[2])-1900, int.parse(data[1]), int.parse(data[0]));
      }
      else {
        _dataPartenza = null;
        SnackBar sb = SnackBar(duration: Duration(seconds: 5),
            content: Text("Errore formato data di partenza",
              style: TextStyle(color: Colors.black),),
            backgroundColor: Colors.red);
        ScaffoldMessenger.of(context).showSnackBar(sb);
        return;
      }
    }
      if(_endDate!=null) {
        RegExp r = RegExp("(0[1-9]|[12][0-9]|3[01])-(0[1-9]|1[012])-[0-9]{4}");
        if (r.hasMatch(_endDate!)) {
          List<String> data = _endDate!.split("-");
          _dataFine = DateTime(
              int.parse(data[2])-1900, int.parse(data[1]), int.parse(data[0]));
        }
        else {
          _dataFine = null;
          SnackBar sb = SnackBar(duration: Duration(seconds: 5),
              content: Text("Errore formato data di fine",
                style: TextStyle(color: Colors.black),),
              backgroundColor: Colors.red);
          ScaffoldMessenger.of(context).showSnackBar(sb);
          return;
        }
      }
        if (_dataFine != null && _dataPartenza != null &&
            _dataFine!.isBefore(_dataPartenza!)) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(duration: Duration(seconds: 5),
                  content: Text("Errore data di fine precede data di partenza",
                style: TextStyle(color: Colors.black),),
                  backgroundColor: Colors.red));
          return;

        }
        //ricerca avanzata
    Map<String, dynamic> params=new Map();
    if(_nomeRubrica!=null && _nomeRubrica!="")
      params['rubrica']=_nomeRubrica!;
    if(_topic!=null && _topic!="")
      params['topic']=_topic!;
    if(_tags!=null && _tags!.isNotEmpty)
      params['tags']=_tags!;
    if(_dataPartenza!=null) {
      params['d'] =_dataPartenza!.day.toString();
      params['m'] =_dataPartenza!.month.toString();
      params['y'] =_dataPartenza!.year.toString();
    }
    if(_dataFine!=null){
      params['ed']=_dataFine!.day.toString();
      params['em']=_dataFine!.month.toString();
      params['ey']=_dataFine!.year.toString();
    }
    ModelFacade.sharedInstance.advancedSearch(params).then((value) => setState((){
      results=value;
      if(results!=null && results.isNotEmpty){
        Map<String,dynamic> reqResp=new Map();
        reqResp['method']=Method.advancedSearch;
        reqResp['results']=results;
        reqResp['request']=params;
        Navigator.pushNamed(context, SearchResults.resultsRoute, arguments: reqResp);
      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(duration:  Duration(seconds: 5),
                content: Text("Non ci sono risultati che soddisfano la ricerca",
                  style: TextStyle(color: Colors.black),),
                backgroundColor: Colors.green));
      }
    }));
  }
}