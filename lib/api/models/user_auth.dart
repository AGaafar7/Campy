class User {
  String name;
  String email;
  String password;
  String kudos;

  User({
    required this.name,
    required this.email,
    required this.password,
    required this.kudos,
  });
  Map<String, dynamic> toMap() {
    return {'name': name, 'email': email, 'password': password, 'kudos': kudos};
  }

  factory User.fromMap(Map<String, dynamic> json) {
    return User(
      name: json['name'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      kudos: json['kudos'] as String,
    );
  }
}
