import 'package:flutter/material.dart';
import 'package:timeoutflutter/UI/Top.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatelessWidget{
  static const String aboutRoute="About";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Column(
        children: [
          Top(),
          Padding(
            padding: EdgeInsets.all(30.0),
            child: Text("Nata nel 2019, Time-Out cerca di coniugare l'esperienza fantacalcistica con i dettami tattici basilari, per permettere a tutti di sfruttare al meglio il proprio... time-out!",
                  textAlign: TextAlign.left, style: TextStyle(color:Colors.white, fontSize: 18.0)),
          ),
          Padding(padding: EdgeInsets.all(30.0),
            child: TextButton(onPressed: () async {
              await launch("https://www.facebook.com/timeoutita");},
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Icon(
                      Icons.facebook,
                      color: Colors.blue,
                    ),
                  ),
                  Text("Seguici su Facebook", style: TextStyle(color:Colors.blue, fontSize: 18.0,)),
                ]
              )
            ),
          ),
          Padding(padding: EdgeInsets.all(30.0),
            child: TextButton(onPressed: () async {
              await launch("https://www.instagram.com/timeout_ita/");},
                child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Icon(
                          Icons.photo_camera,
                          color: Colors.pinkAccent,
                        ),
                      ),
                      Text("Seguici su Instagram", style: TextStyle(color:Colors.pinkAccent, fontSize: 18.0,)),
                    ]
                )
            ),
          ),
          Padding(padding: EdgeInsets.all(30.0),
            child: TextButton(onPressed: () async {
              await launch("mailto:timeoutfanta@gmail.com");},
                child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Icon(
                          Icons.email_outlined,
                          color: Colors.green,
                        ),
                      ),
                      Text("Contattaci via mail", style: TextStyle(color:Colors.green, fontSize: 18.0,)),
                    ]
                )
            ),
          )
        ],
      )
    );
  }

}