import 'package:flutter/material.dart';
import 'package:timeoutflutter/UI/ArticoloWidget.dart';
import 'package:timeoutflutter/UI/CircularIconButton.dart';
import 'package:timeoutflutter/UI/GlobalState.dart';
import 'package:timeoutflutter/UI/LoginButton.dart';
import 'package:timeoutflutter/UI/NuovoArticoloForm.dart';
import 'package:timeoutflutter/UI/Top.dart';
import 'package:timeoutflutter/model/Constant.dart';
import 'package:timeoutflutter/model/ModelFacade.dart';
import 'package:timeoutflutter/model/objects/Articolo_Home.dart';
import 'package:timeoutflutter/model/objects/LogInResult.dart';
import 'package:timeoutflutter/model/objects/Rubrica.dart';
import 'package:timeoutflutter/model/objects/User.dart';
import 'package:url_launcher/url_launcher.dart';

class PersonalSection extends StatefulWidget {
  static const String PSRoute ="personalSection";

  const PersonalSection({Key? key}) : super(key: key);

  @override
  _PersonalSectionState createState() => _PersonalSectionState();
}

class _PersonalSectionState extends GlobalState<PersonalSection> {
  User? utente;
  int currentPage=0;
  int numero=0;
  bool ciSonoSalvati=false;
  List<Articolo_Home> salvati=List.empty(growable: true);


void moreResults() {
    currentPage++;
    ModelFacade.sharedInstance.loadSalvati(utente!.userName, page: currentPage).then((value) => setState((){
      salvati.addAll(value);
      if(salvati.length<numero)
        ciSonoSalvati=true;
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [ Flexible(
            child: Top(),
            flex: 1,),
            (utente==null)?login():
              Flexible(
                flex:2,
              child:SingleChildScrollView(
              scrollDirection: Axis.vertical,
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                  children:[ salvati.isEmpty ?
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text("non hai salvato alcun articolo",style: TextStyle(fontFamily: "charcoal", color: Colors.white),textAlign: TextAlign.center,))
                    : GridView.count(
                  crossAxisCount: 4,
                  children:
                  salvati.map( (Articolo_Home art) {
                    return ArticoloWidget(art);
                  }).toList(),
                  mainAxisSpacing: 20.0,
                  crossAxisSpacing: 20.0,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                ),
                ciSonoSalvati?Container()
                    :Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CircularIconButton(
                        onPress: () {
                          salvati.length>=numero?null:
                          moreResults();
                        },
                        background: salvati.length>=numero?Colors.grey:Colors.green,
                        iconColor: Colors.black,
                        icon: Icons.expand_more_rounded,
                      ),
                    ]),
                Container(
                  height: 100,
                  child: logout(),
                ),
                utente!.role=="Editor"? nuovoArticolo(): new Container(),
              ]
                )
              )
              )
          ]
        )
      );
    }

    Widget login(){
      return LogInButton(
          textOuterButton: "Login",
          onSubmit: (String username, String password) async {
            setState((){});
            if (username == null || username == "" || password == null || password == "" ){
              SnackBar sb = SnackBar(duration: Duration(seconds: 5),
                  content: Text("Attenzione: tutti i campi sono obbligatori",
                    style: TextStyle(color: Colors.black),),
                  backgroundColor: Colors.red);
              ScaffoldMessenger.of(context).showSnackBar(sb);
              return;
            }
            LogInResult? result;
            await ModelFacade.sharedInstance.logIn(username, password).then(
                    (value) => {
                      result=value});
            if ( result == LogInResult.logged ) {
              utente=ModelFacade.sharedInstance.appState.getValue(Constants.STATE_USER);
              ModelFacade.sharedInstance.loadSalvati(utente!.userName).then((value) => setState((){
                salvati=value;
                if(salvati.isNotEmpty)
                  ciSonoSalvati=true;
              }));
            }
            else if ( result == LogInResult.error_wrong_credentials ) {
              SnackBar sb = SnackBar(duration: Duration(seconds: 5),
                  content: Text("Username o password errati",
                    style: TextStyle(color: Colors.black),),
                  backgroundColor: Colors.red);
              ScaffoldMessenger.of(context).showSnackBar(sb);
              return;
            }
            else if ( result == LogInResult.error_not_fully_setupped ) {
              await launch(Constants.LINK_FIRST_SETUP_PASSWORD);
            }
            else{
              SnackBar sb = SnackBar(duration: Duration(seconds: 5),
                  content: Text("C'è stato un errore",
                    style: TextStyle(color: Colors.black),),
                  backgroundColor: Colors.red);
              ScaffoldMessenger.of(context).showSnackBar(sb);
            }
          }
      );
    }

  void initState(){
    if(ModelFacade.sharedInstance.appState.existsValue(Constants.STATE_USER)) {
      utente=ModelFacade.sharedInstance.appState.getValue(Constants.STATE_USER);
      ModelFacade.sharedInstance.loadNumArticoliSalvati(utente!.userName).then((value)=>numero=value);
      ModelFacade.sharedInstance.loadSalvati(utente!.userName).then((value) => setState((){
        salvati=value;
        if(salvati!=null && salvati.isNotEmpty)
          ciSonoSalvati=true;
      }));
    }
    super.initState();
  }

  @override
  void refreshState() {}

  Widget logout() {
    return Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
      children:[
        Container(
          margin: EdgeInsets.all(10.0),
          child: TextButton(
          style: ButtonStyle(backgroundColor:MaterialStateProperty.all<Color>(Colors.green) ,
              overlayColor: MaterialStateProperty.all<Color>(Colors.green),
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white)),
                child: const Text ("LOGOUT", style: TextStyle(fontFamily: "charcoal")),
                onPressed: () {
            ModelFacade.sharedInstance.logOut();
            setState((){
              utente=null;
              ciSonoSalvati=false;
              salvati=List.empty(growable: true);
              ModelFacade.sharedInstance.appState.removeValue(Constants.STATE_USER);
            });},
              ),
    ),
      ]
      )
      );
  }

  Widget nuovoArticolo(){
    return NuovoArticoloForm(rubriche_list: ModelFacade.sharedInstance.appState.getValue("RUBRICHE"),
              onSubmit: (Rubrica rubrica, String topic, String testo, List<String> tags, DateTime data, String img) async {
                if (rubrica == null || topic == null || topic == "" || testo == null || testo == "") {
                  SnackBar sb = SnackBar(duration: Duration(seconds: 5),
                      content: Text(
                        "Attenzione: riempire i campi rubrica, argomento e testo",
                        style: TextStyle(color: Colors.black),),
                      backgroundColor: Colors.red);
                  ScaffoldMessenger.of(context).showSnackBar(sb);
                  return;
                }
                await ModelFacade.sharedInstance.nuovoArticolo(
                    rubrica, topic, testo, tags, data, img).then(
                        (value) =>
                    {
                      print(value)});
                  ModelFacade.sharedInstance.loadArticoli();
              }
   );
  }
}