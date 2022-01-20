class Rubrica{
  final String nome;
  final int id;

  Rubrica({required this.id, required this.nome});

  factory Rubrica.fromJson(Map<String, dynamic> json) =>Rubrica(id:json['id'],nome: json['nome']);

  Map<String, dynamic> toJson() => {
    'id':id,
    'nome':nome
  };

  String toString(){
    return this.nome;
  }
}