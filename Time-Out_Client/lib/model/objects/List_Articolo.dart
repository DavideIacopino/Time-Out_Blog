import 'package:timeoutflutter/model/objects/Articolo_Home.dart';

class List_Articolo{
  List<Articolo_Home> articoli;

  List_Articolo({required this.articoli});

  factory List_Articolo.fromJson(List<dynamic> json){
    List<Articolo_Home> articoli=json.map((e) => Articolo_Home.fromJson(e)).toList();
    return new List_Articolo(articoli: articoli);
  }
}