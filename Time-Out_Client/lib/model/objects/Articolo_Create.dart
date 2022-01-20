import 'package:timeoutflutter/model/objects/Rubrica.dart';

class Articolo_Create{
  final String topic;
  final Rubrica rubrica;
  final String testo;
  final String immagine;
  final DateTime data;
  final List<String> tags;

  Articolo_Create({required this.topic, required this.rubrica,
    required this.testo, required this.immagine, required this.data,
    required this.tags,
  });

  Map<String,dynamic> toJson() => {
    'rubrica':rubrica,
    'topic':topic,
    'testo':testo,
    'data':data.millisecondsSinceEpoch,
    'img':immagine,
    'tags':tags
  };
}