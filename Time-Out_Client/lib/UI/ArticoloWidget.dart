import 'package:flutter/material.dart';
import 'package:timeoutflutter/UI/ArticoloDetails.dart';
import 'package:timeoutflutter/UI/GlobalState.dart';
import 'package:timeoutflutter/model/Constant.dart';
import 'package:timeoutflutter/model/ModelFacade.dart';
import 'package:timeoutflutter/model/objects/Articolo_Home.dart';
import 'package:timeoutflutter/model/objects/User.dart';

class ArticoloWidget extends StatefulWidget {
  final Articolo_Home articolo;

  ArticoloWidget(this.articolo, {Key? key}) : super(key: key);

  @override
  _ArticoloState createState() {
    return _ArticoloState(articolo);
  }
}

  class _ArticoloState extends GlobalState<ArticoloWidget>{
    Articolo_Home articolo;
    late bool salvato=false;

    _ArticoloState(this.articolo);


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20.0),
      child:Card(
        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween ,
          children: <Widget>[
            FittedBox(
              fit: BoxFit.contain,
              child: TextButton(
                style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all<Color>(Colors.green),
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white)),
                onPressed: () {_goToArticolo();},
                child: Text(articolo.nomeRubrica+": "+ articolo.topic, textAlign: TextAlign.center,),
              ),
            ),
            Flexible(
              flex: 1,
              child:
              Hero(
                tag: 'img'+articolo.id.toString(),
                child: (articolo.immagine==null) ? Image.asset('images/logo.png', ) : Image.asset('images'+ articolo.immagine!,),
              )
            ),
            FittedBox(
                fit: BoxFit.contain,
                child: Row(
                  children: <Widget>[
                    TextButton(
                      child: const Text('Leggi tutto'),
                      style: ButtonStyle(
                          overlayColor: MaterialStateProperty.all<Color>(Colors.green),
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.white)),
                      onPressed: () {_goToArticolo();},
                    ),
                    TextButton(
                      style: ButtonStyle(
                          overlayColor: MaterialStateProperty.all<Color>(Colors.green),
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.white)),
                      child: _autenticato() && salvato? Text('Rimuovi dai preferiti') : Text('Salva nei preferiti'),
                      onPressed: () {
                        _autenticato()? salvato ? rimuovi(articolo) : salva(articolo) : null;
                      },
                    ),
                  ],
                )
            ),
          ],
        ),
      ),
    );
  }

  void _goToArticolo(){
    Navigator.pushNamed(context, ArticoloDetails.articoloRoute, arguments: articolo);
  }

  @override
  void refreshState() {
    if(_autenticato()){
      User user=ModelFacade.sharedInstance.appState.getValue(Constants.STATE_USER);
      ModelFacade.sharedInstance.isSaved(articolo).then(
              (result) =>
          result ? setState(() {
            salvato = true;
          }) : setState(() {
            salvato = false;
          }));
    }
  }

  bool _autenticato(){
    return ModelFacade.sharedInstance.appState.existsValue(Constants.STATE_USER)&&ModelFacade.sharedInstance.appState.getValue(Constants.STATE_USER)!=null;
  }

  void initState() {
    super.initState();
    if(_autenticato()){
      User user=ModelFacade.sharedInstance.appState.getValue(Constants.STATE_USER);
      ModelFacade.sharedInstance.isSaved(articolo).then(
              (result) =>
          result ? setState(() {
            salvato = true;
          }) : setState(() {
            salvato = false;
          }));
    }
  }

  void salva(Articolo_Home articolo) {
    ModelFacade.sharedInstance.salvaArticolo(ModelFacade.sharedInstance.appState.getValue(Constants.STATE_USER).userName, articolo.id);
    List<Articolo_Home> articoli=List.empty(growable:true);
    setState((){
      if(ModelFacade.sharedInstance.appState.existsValue(Constants.SALVATI))
        articoli = ModelFacade.sharedInstance.appState.getValue(Constants.SALVATI);
      else
        ModelFacade.sharedInstance.loadSalvati(ModelFacade.sharedInstance.appState.getValue(Constants.STATE_USER).userName).then((value) => articoli=value);
      articoli.add(articolo);
    });
  }

  void rimuovi(Articolo_Home articolo) {
    ModelFacade.sharedInstance.removeArticolo(ModelFacade.sharedInstance.appState.getValue(Constants.STATE_USER).userName, articolo.id);
    setState((){
      List<Articolo_Home> articoli = ModelFacade.sharedInstance.appState.getValue(Constants.SALVATI);
      articoli.remove(articolo);
    });
  }

}