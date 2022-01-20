import 'package:flutter/material.dart';
import 'package:timeoutflutter/UI/CircularIconButton.dart';
import 'package:timeoutflutter/UI/GlobalState.dart';
import 'package:timeoutflutter/UI/InputField.dart';
import 'package:timeoutflutter/UI/PersonalSection.dart';
import 'package:timeoutflutter/UI/Top.dart';
import 'package:timeoutflutter/model/ModelFacade.dart';

class Registration extends StatefulWidget {
  static const String registrationRoute="signup";
  const Registration({Key? key}) : super(key: key);

  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends GlobalState<Registration> {

  TextEditingController? _inputFieldEmailController = TextEditingController();
  TextEditingController? _inputFieldUsernameController = TextEditingController();

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
            Container(
              height: 400,
            margin:EdgeInsets.all(20.0),
            child: Column(
              children:[
                Flexible( child:InputField(
              colorBorder: Colors.green,
              labelText: "Username",
              controller: _inputFieldUsernameController!,
              isUsername: true,
              onSubmit: (_) {
                invia(_inputFieldUsernameController!.text, _inputFieldEmailController!.text);
              },
            ),
            ),
            Flexible( child:InputField(
              colorBorder: Colors.green,
              labelText: "Email",
              controller: _inputFieldEmailController!,
              isUsername: true,
              onSubmit: (_) {
                invia(_inputFieldUsernameController!.text, _inputFieldEmailController!.text);
              },
            ),
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children:[
                Padding(child: CircularIconButton(
                  onPress: () {
                    cleanInput();
                  },
                  background: Colors.green,
                  iconColor: Colors.black,
                  icon: Icons.delete_rounded,
                ),
                  padding: EdgeInsets.all(10.0),
                ),
                Padding(child:CircularIconButton(
                  icon: Icons.login_rounded,
                  onPress: () {
                    invia(_inputFieldUsernameController!.text, _inputFieldEmailController!.text);
                  },
                  background: Colors.green,
                  iconColor: Colors.black,
                ),
                  padding: EdgeInsets.all(10.0),
                ),
              ]
            )
            ])
            )
        ]
      )
    );
  }

  void invia(String username, String email) async {
    setState((){});
      if (username == "" || email==""){
      SnackBar sb = SnackBar(duration: Duration(seconds: 5),
          content: Text("Attenzione: tutti i campi sono obbligatori",
            style: TextStyle(color: Colors.black),),
          backgroundColor: Colors.red);
      ScaffoldMessenger.of(context).showSnackBar(sb);
      return;
    }
    await ModelFacade.sharedInstance.registrazione(username, email).then(
            (value) => Navigator.pushNamed(context, PersonalSection.PSRoute));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void refreshState() {
  }

  void cleanInput() {
    _inputFieldEmailController!.clear();
    _inputFieldUsernameController!.clear();
    setState((){
    });
  }
}
