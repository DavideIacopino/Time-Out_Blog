import 'package:timeoutflutter/model/objects/Commento.dart';

class Articolo_Home{
  final int id;
  final String topic;
  final String nomeRubrica;
  final String testo;
  final String? immagine;
  final DateTime data;
  final List<String> tags;
  final List<Commento> commenti;

  Articolo_Home({ required this.id, required this.topic, required this.nomeRubrica,
    required this.testo, this.immagine, required this.data,
    required this.tags,
    required this.commenti
  });

  factory Articolo_Home.fromJson(dynamic json) {
    var com = json['commenti'].map((e) => Commento.fromJson(e)).toList();
    var t = json['tags'].map((e) => e.toString()).toList();
    DateTime d = DateTime.fromMillisecondsSinceEpoch(json['data']);
    return Articolo_Home(
        id: json['id'],
        topic: json['topic'],
        nomeRubrica: json['rubrica']['nome'],
        testo: json['testo'],
        immagine: json['img'],
        data: d,
        tags: new List<String>.from(t),
        commenti: new List<Commento>.from(com)
    );
  }
}
