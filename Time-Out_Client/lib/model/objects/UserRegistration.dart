class UserRegistration {
  String userName;
  String email;
  String password;
  List<String> role;

  UserRegistration({required this.userName, required this.email, required this.role, required this.password});

  factory UserRegistration.fromJson(Map<String, dynamic> json) {
    var t = json['realmRoles'].map((e) => e.toString()).toList();
    return UserRegistration(
      password: json['password'],
      userName: json['username'],
      email: json['email'],
      role: new List<String>.from(t),
    );
  }

  Map<String, dynamic> toJson() => {
    'password':password,
    'username': userName,
    'email': email,
    'realmRoles':role,
    'enabled':true,
  };

}