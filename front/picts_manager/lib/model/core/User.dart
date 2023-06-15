class User {
  String userId;

  String username;

  String email;

  User({
    required this.userId,
    required this.username,
    required this.email,
  });

  factory User.empty() {
    return User(
      userId: "",
      username: "",
      email: "",
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json["userId"].toString(),
      username: json["username"].toString(),
      email: json["email"].toString(),
    );
  }
}
