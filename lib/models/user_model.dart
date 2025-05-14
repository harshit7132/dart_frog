class User {
  final String email;
  final String hashedPassword;
  final String role;

  User({
    required this.email,
    required this.hashedPassword,
    required this.role,
  });
}
