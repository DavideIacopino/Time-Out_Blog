import 'package:flutter/material.dart';
import 'package:timeoutflutter/UI/ArticoloWidget.dart';
import 'package:timeoutflutter/UI/GlobalState.dart';
import 'package:timeoutflutter/UI/Top.dart';
import 'package:timeoutflutter/model/Constant.dart';
import 'package:timeoutflutter/model/ModelFacade.dart';
import 'package:timeoutflutter/model/objects/Articolo_Home.dart';

class Home extends StatelessWidget{
  static const String homeRoute ="Home";

  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Flexible(
                  flex: 1,
                  child: Top(),
                ),
                Flexible(
                  flex: 2,
                  child: _homeBottom(),
                )
                ]
          )
    );
  }
}

class _homeBottom extends StatefulWidget{
  _homeBottom({Key? key}): super(key: key);

  _homeBottomState createState(){
    return _homeBottomState();
  }

}

class _homeBottomState extends GlobalState<_homeBottom>{
  List<Articolo_Home> posts=List.empty(growable: true);
  List<Articolo_Home> iniziale=List.empty(growable: true);

  @override
  Widget build(BuildContext context) {
    return Column(
      children:[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Text("ULTIME USCITE", style: TextStyle(fontFamily: "charcoal", color:Colors.white, )),
          ),
        Flexible(
            child: iniziale.isEmpty? Text("Non ci sono articoli",style: TextStyle(fontFamily: "charcoal", color: Colors.white),textAlign: TextAlign.center,)
            :GridView.count(
              crossAxisCount: 4,
              children:
              posts.map( (Articolo_Home art) {
                  return ArticoloWidget(art);
              }).toList(),
              mainAxisSpacing: 20.0,
              crossAxisSpacing: 20.0,
              scrollDirection: Axis.vertical,
          )
        )
        ]
      );
  }

  void initState(){
      ModelFacade.sharedInstance.loadArticoli().then((value) => setState(() {
        posts=value;
        iniziale=posts;}) );
      if(ModelFacade.sharedInstance.appState.existsValue(Constants.STATE_USER))
        ModelFacade.sharedInstance.loadSalvati(ModelFacade.sharedInstance.appState.getValue(Constants.STATE_USER).userName);
      super.initState();
  }

  @override
  void refreshState() {
    List<Articolo_Home> articoli=ModelFacade.sharedInstance.appState.getValue(Constants.STATE_POSTS_HOME);
    setState((){
      posts=articoli;
    });
  }

}