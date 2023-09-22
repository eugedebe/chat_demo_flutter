class User {
  bool online;
  String email;
  String name;
  String uid;
  User({
    required this.online,
    required this.email,
    required this.name,
    required this.uid,
  });

  factory User.fromJson(Map<String, dynamic> userJson) {
    return User(
      email: userJson['email'],
      uid: userJson['uid'],
      name: userJson['name'],
      online: true,
    );
  }
}
