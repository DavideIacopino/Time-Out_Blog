import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:timeoutflutter/UI/CircularIconButton.dart';
import 'package:timeoutflutter/UI/GlobalState.dart';
import 'package:timeoutflutter/UI/InputField.dart';
import 'package:timeoutflutter/UI/Top.dart';
import 'package:timeoutflutter/model/Constant.dart';
import 'package:timeoutflutter/model/ModelFacade.dart';
import 'package:timeoutflutter/model/objects/Articolo_Home.dart';
import 'package:timeoutflutter/model/objects/Commento.dart';
import 'package:timeoutflutter/model/objects/User.dart';

class ArticoloDetails extends StatelessWidget {
  static const String articoloRoute="articolo";
  final Articolo_Home articolo;

  const ArticoloDetails(this.articolo, {Key? key}) : super(key: key);

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
              Container(
                child: CircularIconButton(
                  onPress: (){
                    Navigator.pop(context);
                  },
                  background: Colors.green,
                  iconColor: Colors.black,
                  icon: Icons.arrow_back_ios_rounded,
                ),
                margin: EdgeInsets.all(5.0),
                alignment: Alignment.centerLeft,
              ),
              Flexible(
                  flex: 2,
                  child: _articoloBottom(articolo)
              )
            ]
        )
    );
  }
}

class _articoloBottom extends StatelessWidget {
  final Articolo_Home articolo;

  const _articoloBottom(this.articolo, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(10.0,20.0,10.0, 10.0),
                padding: EdgeInsets.all(10.0),
                child: Text(articolo.nomeRubrica+": "+ articolo.topic, textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),),
              ),
              Container(
                child:Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:
                    articolo.tags.map((value) => Text("#"+value+"\t",
                        style: TextStyle(color: Colors.white, fontSize: 12.0, fontStyle: FontStyle.italic))).toList()
                ),
                margin: EdgeInsets.fromLTRB(10.0, 0, 10.0, 20.0),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10.0, 0, 10.0, 20.0),
                child: Text(articolo.data.day.toString()+"/"+articolo.data.month.toString()+"/"+articolo.data.year.toString(),
                    style: TextStyle(color: Colors.white, fontSize: 12.0, fontStyle: FontStyle.italic)),
              ),
              Container(
                  margin: EdgeInsets.all(20.0),
                  child: Row(
                      children:[
                        Flexible(
                            flex:2,
                            child:
                            Hero(
                              tag: 'img'+articolo.id.toString(),
                              child:(articolo.immagine==null) ? Image.asset('images/logo.png', ) : Image.asset('images'+ articolo.immagine!,),
                            )
                        ),
                        Flexible(
                            flex: 3,
                            child:Container(
                              width: 600.0,
                              margin: EdgeInsets.all(20.0) ,
                              padding: EdgeInsets.all(10.0),
                              child:Text(articolo.testo, textAlign: TextAlign.left, style: TextStyle(color:Colors.white),),
                            )
                        ),
                      ]
                  )
              ),
              Container(
                child:_Commenta(articolo),
                width: 600,
              ),
              Container(
                margin: EdgeInsets.all(20.0),
                padding: EdgeInsets.all(10.0),
                child: _CommentsList(articolo.commenti),
              ),
            ]
        )
    );
  }
}

class _Commenta extends StatefulWidget {
  final Articolo_Home articolo;

  const _Commenta(this.articolo, {Key? key}) : super(key: key);

  @override
  _CommentaState createState() {
    return _CommentaState(articolo);
  }
}
class _CommentaState extends GlobalState<_Commenta>{
  TextEditingController _inputFieldCommentaController=TextEditingController();
  String testo="";
  final Articolo_Home articolo;

  _CommentaState(this.articolo);

  @override
  Widget build(BuildContext context) {
    return
      Row(
          children:[
            Flexible(
                child:InputField(
                  colorBorder: Colors.green,
                  labelText: "Commenta",
                  controller: _inputFieldCommentaController,
                  isUsername: true,
                  onChanged: (String value) {
                    testo = value;
                  },
                )),
            CircularIconButton(
              background: Colors.green,
              iconColor: Colors.black,
              icon: Icons.arrow_forward,
              onPress: () {
                if(! ModelFacade.sharedInstance.appState.existsValue(Constants.STATE_USER)){
                  SnackBar sb = SnackBar(duration: Duration(seconds: 5),
                      content: Text("Per commentare devi prima aver fatto login",
                        style: TextStyle(color: Colors.black),),
                      backgroundColor: Colors.red);
                  ScaffoldMessenger.of(context).showSnackBar(sb);
                  return;
                }
                User u=ModelFacade.sharedInstance.appState.getValue(Constants.STATE_USER);
                bool result=false;
                ModelFacade.sharedInstance.commenta(testo, articolo.id, u.userName).then((value) =>
                result=value);
                if(result)
                  setState((){
                    ModelFacade.sharedInstance.loadArticoli().then((value) => ModelFacade.sharedInstance.appState.updateValue(Constants.STATE_POSTS_HOME, value));
                    Navigator.pop(context);
                    articolo.commenti.add(Commento(username: u.userName,testo: testo));
                    _inputFieldCommentaController.clear();
                    testo="";
                  });
              },
            )
          ]
      );
  }

  @override
  void refreshState() {
    setState((){
    });
  }
}

class _CommentsList extends StatelessWidget {
  final List<Commento> commenti;

  const _CommentsList(this.commenti, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(10.0),
        child: ExpansionTile(
            expandedAlignment: Alignment.centerLeft,
            iconColor: Colors.green,
            textColor: Colors.green,
            collapsedBackgroundColor: Colors.green,
            collapsedIconColor: Colors.green,
            leading: Icon(Icons.comment, color: Colors.green,),
            trailing: Text(commenti.length.toString()),
            title: Text("Commenti"),
            children: commenti.map((e) => _SingleComment(e)).toList()
        )
    );
  }
}

class _SingleComment extends StatelessWidget{
  final Commento commento;

  _SingleComment(this.commento, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(20.0),
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8)),
          //boxShadow: [BoxShadow(color:Colors.green, spreadRadius: 3),],
        ),
        child:
        Column(
          children: [
            Text(commento.username, style: TextStyle(color: Colors.green, fontSize: 12.0),),
            Text(commento.testo, textAlign: TextAlign.left, style: TextStyle(color: Colors.black, fontSize: 15.0),)
          ],
        )
    );
  }
}