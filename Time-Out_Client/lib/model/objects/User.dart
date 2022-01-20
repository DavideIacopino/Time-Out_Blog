class User {
  String userName;
  String email;
  String role;

  User({required this.userName, required this.email, required this.role});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userName: json['username'],
      email: json['email'],
      role: json['role'],
    );
  }

  Map<String, String> toJson() => {
    'username': userName,
    'email': email,
    'role':role
  };

  @override
  String toString() {
    return "username "+userName+", email "+email+", role "+role;
  }
}