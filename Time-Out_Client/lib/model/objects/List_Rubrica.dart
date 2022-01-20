import 'package:timeoutflutter/model/objects/Rubrica.dart';
class List_Rubrica{
  final List<Rubrica> rubriche;

  List_Rubrica({required this.rubriche});

  factory List_Rubrica.fromJson(List<dynamic> json){
    List<Rubrica> rubriche=json.map((i) => Rubrica.fromJson(i)).toList();
    return new List_Rubrica(rubriche: rubriche);
  }
}