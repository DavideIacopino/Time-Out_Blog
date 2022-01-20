import 'package:flutter/material.dart';
import 'package:timeoutflutter/UI/About.dart';
import 'package:timeoutflutter/UI/ArticoloDetails.dart';
import 'package:timeoutflutter/UI/Home.dart';
import 'package:timeoutflutter/UI/PersonalSection.dart';
import 'package:timeoutflutter/UI/Registration.dart';
import 'package:timeoutflutter/UI/RubricaDetails.dart';
import 'package:timeoutflutter/UI/Search.dart';
import 'package:timeoutflutter/UI/SearchResults.dart';
import 'package:timeoutflutter/model/objects/Articolo_Home.dart';
import 'package:timeoutflutter/model/objects/Rubrica.dart';

class AppRouter{

  static Route<dynamic> generatedRoute(RouteSettings settings){
    switch (settings.name){
      case Home.homeRoute:
        return MaterialPageRoute(
          builder: (_) => Home());
      case RubricaDetails.rubricaRoute:
        return MaterialPageRoute(
          builder: (_) => RubricaDetails(settings.arguments as String));
      case About.aboutRoute:
        return MaterialPageRoute(
            builder: (_) => About());
      case PersonalSection.PSRoute:
        return MaterialPageRoute(
            builder: (_) => PersonalSection());
      case Registration.registrationRoute:
        return MaterialPageRoute(
            builder: (_) => Registration());
      case ArticoloDetails.articoloRoute:
        return MaterialPageRoute(
          builder: (_) => ArticoloDetails(settings.arguments as Articolo_Home));
      case Search.searchRoute:
        return MaterialPageRoute(
            builder: (_) => Search(settings.arguments as List<Rubrica>));
      case SearchResults.resultsRoute:
        return MaterialPageRoute(
            builder: (_) => SearchResults(settings.arguments as Map<String, dynamic>));
    }
    return MaterialPageRoute(
        builder: (_) => Home()
    );
  }
}