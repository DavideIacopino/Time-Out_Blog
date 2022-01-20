import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:timeoutflutter/UI/About.dart';
import 'package:timeoutflutter/UI/CircularIconButton.dart';
import 'package:timeoutflutter/UI/GlobalState.dart';
import 'package:timeoutflutter/UI/Home.dart';
import 'package:timeoutflutter/UI/PersonalSection.dart';
import 'package:timeoutflutter/UI/RubricaDetails.dart';
import 'package:timeoutflutter/UI/Search.dart';
import 'package:timeoutflutter/model/ModelFacade.dart';
import 'package:timeoutflutter/model/objects/Rubrica.dart';

class Top extends StatefulWidget{
  
  Top({Key? key}) : super(key:key);
  
  @override
  _TopState createState() {
    return _TopState();
  }
  
}

class _TopState extends GlobalState<Top>{
  List<Rubrica> rubriche_list=List.empty(growable: true);

  @override
  Widget build(BuildContext context) {
      return Container(
        padding: EdgeInsets.only(top: 0.0),
        height: 190.0,
        alignment: Alignment.topCenter,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16)),
          boxShadow: [BoxShadow(color:Colors.green, spreadRadius: 3),],
        ),
        child: Column(
            children: [
              Flexible(
                child: FractionallySizedBox (
                  alignment: Alignment.topCenter,
                  widthFactor: 1.0,
                  child: Image.asset('images/logo_home.png'),
                ),
                flex: 4,
              ),
              Flexible( //flex:1 quando non è specificato
                  child:Row (
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(child:Container(
                          margin: EdgeInsets.all(10.0),
                          child: TextButton(
                            style: ButtonStyle(
                                overlayColor: MaterialStateProperty.all<Color>(Colors.green),
                                foregroundColor: MaterialStateProperty.all<Color>(Colors.white)),
                            child: const Text ("HOME", style: TextStyle(fontFamily: "charcoal")),
                            onPressed: () {
                              Navigator.pushNamed(context, Home.homeRoute);
                            },
                          ),
                        )
                        ),
                        Expanded(child:Container(
                          margin: EdgeInsets.all(10.0),
                          child: TextButton(
                            style: ButtonStyle(
                                overlayColor: MaterialStateProperty.all<Color>(Colors.green),
                                foregroundColor: MaterialStateProperty.all<Color>(Colors.white)),
                            child: const Text ("CERCA", style: TextStyle(fontFamily: "charcoal")),
                            onPressed: () {
                              Navigator.pushNamed(context, Search.searchRoute, arguments: rubriche_list);
                            },
                          ),
                        )
                        ),
                        Expanded(child:Container(
                          margin: EdgeInsets.all(10.0),
                          child: TextButton(
                            style: ButtonStyle(
                                overlayColor: MaterialStateProperty.all<Color>(Colors.green),
                                foregroundColor: MaterialStateProperty.all<Color>(Colors.white)),
                            child: const Text ("CHI SIAMO", style: TextStyle(fontFamily: "charcoal")),
                            onPressed: () {
                              Navigator.pushNamed(context, About.aboutRoute);
                            },
                          ),
                        )),
                        Expanded(child:Container(
                          margin: EdgeInsets.all(10.0),
                          child: PopupMenuButton<String>(
                            color: Colors.green,
                            child: Text ("RUBRICHE", style: TextStyle(fontFamily: "charcoal", color: Colors.white)),
                            onSelected: _choiceAction,
                            itemBuilder: (BuildContext context){
                              return rubriche_list.map((Rubrica rubrica) {
                                return PopupMenuItem<String>(
                                  value: rubrica.nome,
                                  child: Text(rubrica.nome),
                                );
                              }).toList();
                            },
                          )
                        )
                      ),
                          Expanded(child:Container(
                          margin: EdgeInsets.all(10.0),
                          child: TextButton(
                            style: ButtonStyle(
                                overlayColor: MaterialStateProperty.all<Color>(Colors.green),
                                foregroundColor: MaterialStateProperty.all<Color>(Colors.white)),
                            child: const Text ("IL TUO TIMEOUT", style: TextStyle(fontFamily: "charcoal")),
                            onPressed: () {
                              areaPersonale();
                            },
                          ),
                        )
                        ),
                      Expanded(child:Container(
                            margin: EdgeInsets.all(3.0),
                            child:CircularIconButton(
                          onPress: () {
                            areaPersonale();
                            },
                          background: Colors.green,
                          iconColor: Colors.black,
                          icon: Icons.person,
                          )
                        )),
                      ]
                  )
              )
            ]
        )
    );
  }

  void _choiceAction(String choice){
    Navigator.pushNamed(context, RubricaDetails.rubricaRoute, arguments: choice);
  }

  @override
  void refreshState() {
      List<Rubrica> rubriche=ModelFacade.sharedInstance.appState.getValue("RUBRICHE");
      setState(() {
        rubriche_list=rubriche;
      });
  }

  void initState(){
    super.initState();
      ModelFacade.sharedInstance.loadRubriche().then((result) => setState(() {
        rubriche_list=result;})
      );
  }

  void areaPersonale() {
    Navigator.pushNamed(context, PersonalSection.PSRoute);
  }

}