import 'package:flutter/material.dart';
import 'package:timeoutflutter/UI/CircularIconButton.dart';
import 'package:timeoutflutter/UI/GlobalState.dart';
import 'package:timeoutflutter/UI/InputField.dart';
import 'package:timeoutflutter/UI/Registration.dart';
import 'package:timeoutflutter/model/Constant.dart';
import 'package:url_launcher/url_launcher.dart';

class LogInButton extends StatefulWidget {
  final String textOuterButton;
  final Function onSubmit;

  LogInButton({Key? key, required this.textOuterButton, required this.onSubmit}) : super(key: key);

  @override
  _LogInButton createState() => _LogInButton(this.textOuterButton, this.onSubmit);
}

class _LogInButton extends GlobalState<LogInButton> {
  final String textOuterButton;
  final Function onSubmit;

  TextEditingController? _inputFieldEmailController = TextEditingController();
  TextEditingController? _inputFieldPasswordController = TextEditingController();

  _LogInButton(this.textOuterButton, this.onSubmit);

  @override
  void initState() {
    super.initState();
  }

  @override
  void refreshState() {
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
     child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
              Flexible( child:InputField(
                colorBorder: Colors.green,
                labelText: "Username",
                controller: _inputFieldEmailController!,
                isUsername: true,
                onSubmit: (_) {
                  onSubmit(_inputFieldEmailController!.text, _inputFieldPasswordController!.text);
                },
              ),
                flex: 1,
              ),
              Flexible(child:InputField(
                colorBorder: Colors.green,
                labelText: "Password",
                controller: _inputFieldPasswordController!,
                isPassword: true,
                onSubmit: (_) {
                  onSubmit(_inputFieldEmailController!.text, _inputFieldPasswordController!.text);
                },
              ),
                flex: 1,
              ),
              Padding(child:CircularIconButton(
                icon: Icons.login_rounded,
                onPress: () {
                  onSubmit(_inputFieldEmailController!.text, _inputFieldPasswordController!.text);
                  _inputFieldPasswordController!.text = "";
                  },
                background: Colors.green,
                iconColor: Colors.black,
              ),
              padding: EdgeInsets.all(10.0),
              ),
            Padding(child:TextButton(
              style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all<Color>(Colors.green),
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white)),
              child: const Text ("password dimenticata", style: TextStyle(fontFamily: "charcoal")),
              onPressed: () async {
                await launch(Constants.LINK_RESET_PASSWORD);
              },),
              padding: EdgeInsets.all(10.0),
              ),
        Padding(child:TextButton(
          style: ButtonStyle(
              overlayColor: MaterialStateProperty.all<Color>(Colors.green),
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white)),
          child: const Text ("Registrati", style: TextStyle(fontFamily: "charcoal")),
          onPressed: () {
            Navigator.pushNamed(context, Registration.registrationRoute);
          },),
          padding: EdgeInsets.all(10.0),
        ),
            ],
          )
    );
  }
}