abstract class LoginDTO {
  const LoginDTO({required this.email, required this.password});

  final String email;
  final String password;
}

class FirebaseAuthDTO extends LoginDTO {
  const FirebaseAuthDTO({required super.email, required super.password});
}
