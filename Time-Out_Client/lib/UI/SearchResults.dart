import 'package:flutter/material.dart';
import 'package:timeoutflutter/UI/ArticoloWidget.dart';
import 'package:timeoutflutter/UI/GlobalState.dart';
import 'package:timeoutflutter/UI/Top.dart';
import 'package:timeoutflutter/model/objects/Articolo_Home.dart';
import 'package:timeoutflutter/UI/Search.dart';

class SearchResults extends StatefulWidget {
  static const String resultsRoute ="results";
  Map<String,dynamic> reqResp=new Map();

  SearchResults(this.reqResp, {Key? key}) : super(key: key);

  @override
  _SearchResultsState createState() {
    Map<String,dynamic> params=new Map();
    List<Articolo_Home> results=List.empty(growable: true);
    Method method=Method.advancedSearch;
    if(reqResp.containsKey("method"))
      method=reqResp["method"];
    if(reqResp.containsKey("results"))
      results=reqResp["results"];
    if(reqResp.containsKey("request"))
      params=reqResp['request'];
    return _SearchResultsState(results,params, method);
  }
}

class _SearchResultsState extends GlobalState<SearchResults> {
  Map<String,dynamic> params=new Map();
  List<Articolo_Home> results=List.empty(growable: true);
  Method method;

  _SearchResultsState(this.results, this.params, this.method);
  
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
          Flexible(
            child: mostraRisultati(),
            flex: 2,
          ),
          ]
      )
    );
  }

  Widget mostraRisultati() {
    return Container(
        margin: EdgeInsets.all(5.0) ,
        padding: EdgeInsets.all(5.0),
        child: (results==null || results.isEmpty) ? Text("Nessun risultato",style: TextStyle(fontFamily: "charcoal", color: Colors.white),textAlign: TextAlign.center,):
        GridView.count(
          crossAxisCount: 4,
          children:
          results.map( (Articolo_Home art) {
            return ArticoloWidget(art);
          }).toList(),
          mainAxisSpacing: 20.0,
          crossAxisSpacing: 20.0,
          scrollDirection: Axis.vertical,
        )
    );
  }
  
  @override
  void refreshState() {
    setState(() {});
  }
}
