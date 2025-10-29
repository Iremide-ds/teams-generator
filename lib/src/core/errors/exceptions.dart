abstract class AppException<T> implements Exception {
  const AppException({required this.data, required this.message});

  final T? data;
  final String message;
}

final class AuthException extends AppException {
  const AuthException({super.data, super.message = "An error occurred!"});

  @override
  String toString() {
    return message;
  }
}
