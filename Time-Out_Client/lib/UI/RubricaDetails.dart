import 'package:flutter/material.dart';
import 'package:timeoutflutter/UI/ArticoloWidget.dart';
import 'package:timeoutflutter/UI/CircularIconButton.dart';
import 'package:timeoutflutter/UI/GlobalState.dart';
import 'package:timeoutflutter/UI/Top.dart';
import 'package:timeoutflutter/model/Constant.dart';
import 'package:timeoutflutter/model/ModelFacade.dart';
import 'package:timeoutflutter/model/objects/Articolo_Home.dart';

class RubricaDetails extends StatelessWidget {
  final String nome;
  static const String rubricaRoute ="rubrica";

  const RubricaDetails (this.nome, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Column(
        children: [
          Flexible(
            flex: 1,
            child: Top(),
          ),
          Flexible(
            flex: 2,
            child: rubricaBottom(nome)
          )
          ]
        )
    );
  }
}

class rubricaBottom extends StatefulWidget {
  final String nome;

  const rubricaBottom(this.nome, {Key? key}) : super(key: key);

  @override
  _rubricaBottomState createState() => _rubricaBottomState(nome);
}

class _rubricaBottomState extends GlobalState<rubricaBottom> {
  final String nome;
  List<Articolo_Home> posts=List.empty(growable: true);
  List<Articolo_Home> iniziale=List.empty(growable: true);
  int currentPage=0;
  int numero=0;

  _rubricaBottomState(this.nome);

  @override
  Widget build(BuildContext context) {
    return Column(
        children:[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Text("Tutti gli articoli della rubrica "+nome, style: TextStyle(fontFamily: "charcoal", color:Colors.white, )),
          ),
          Flexible(
              child: iniziale.isEmpty? Text("Non ci sono articoli di questa rubrica",style: TextStyle(fontFamily: "charcoal", color: Colors.white),textAlign: TextAlign.center,)
                  : GridView.count(
                crossAxisCount: 4,
                children:
                posts.map( (Articolo_Home art) {
                  return ArticoloWidget(art);
                }).toList(),
                mainAxisSpacing: 20.0,
                crossAxisSpacing: 20.0,
                scrollDirection: Axis.vertical,
              )
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircularIconButton(
                  onPress: () {
                    posts.length>=numero?null:
                    moreResults();
                  },
                  background: posts.length>=numero?Colors.grey:Colors.green,
                  iconColor: Colors.black,
                  icon: Icons.expand_more_rounded,
                ),
              ])
        ]
    );
  }

  void initState(){
    ModelFacade.sharedInstance.loadNumArticoliByRubrica(nome).then((value) => numero=value);
      ModelFacade.sharedInstance.loadArticoliByRubrica(nome,page:currentPage).then((value) => setState(() {
        posts=value;
        iniziale=posts;}) );
    if(ModelFacade.sharedInstance.appState.existsValue(Constants.STATE_USER))
      ModelFacade.sharedInstance.loadSalvati(ModelFacade.sharedInstance.appState.getValue(Constants.STATE_USER).userName);
    super.initState();
  }

  void moreResults(){
    currentPage++;
    ModelFacade.sharedInstance.loadArticoliByRubrica(nome,page: currentPage).then((value) => setState(() {
      posts.addAll(value);
      ModelFacade.sharedInstance.appState.updateValue(Constants.STATE_POSTS_HOME+"_"+nome, posts);
    }));
  }

  @override
  void refreshState() {
    List<Articolo_Home> articoli=ModelFacade.sharedInstance.appState.getValue(Constants.STATE_POSTS_HOME+"_"+nome);
    setState((){
    });
  }
}

