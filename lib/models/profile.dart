class Profile {
  final String name;
  final String email;
  final String avatarUrl;

  Profile({required this.name, required this.email, required this.avatarUrl});

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      name: json['name'],
      email: json['email'],
      avatarUrl: json['avatarUrl'],
    );
  }
}
