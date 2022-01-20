import 'package:flutter/material.dart';
import 'package:timeoutflutter/AppRouter.dart';

import 'UI/Home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  Widget build(BuildContext context) {
    return  MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Time-Out',
        theme: ThemeData(
            backgroundColor: Colors.black,
            primaryColor: Colors.green,
            buttonTheme: ButtonThemeData(
              buttonColor: Colors.green,
            )
        ),
          initialRoute: Home.homeRoute,
          onGenerateRoute: AppRouter.generatedRoute,
      );
  }
}