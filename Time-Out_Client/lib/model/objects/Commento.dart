class Commento {
  final String testo;
  final String username;

  Commento({required this.testo, required this.username});

  factory Commento.fromJson(dynamic json) => Commento(
    testo: json['testo'],
    username: json['utente']['username']
  );

}
