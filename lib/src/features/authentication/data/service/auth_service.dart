import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teams_gen/src/core/errors/exceptions.dart';
import 'package:teams_gen/src/features/authentication/data/model/login.dart';
import 'package:teams_gen/src/shared/util/app_logger.dart';
import 'package:teams_gen/src/shared/util/wrappers.dart';

abstract interface class AuthService<T> {
  Future<Result<T, AuthException>> login(LoginDTO data);
  Future<Result<T, AuthException>> signUp(LoginDTO data);
}

final authService = Provider<AuthService<UserCredential>>(
  (ref) => const FirebaseAuthService(),
);

final class FirebaseAuthService implements AuthService<UserCredential> {
  const FirebaseAuthService();

  FirebaseAuth get _firebaseAuth => FirebaseAuth.instance;

  @override
  Future<Result<UserCredential, AuthException>> login(LoginDTO data) {
    return Future(() async {
      try {
        final authResult = await _firebaseAuth.signInWithEmailAndPassword(
          email: data.email,
          password: data.password,
        );

        return Result.success(authResult);
      } on FirebaseAuthException catch (e) {
        AppLogger().error('${e.code} (${e.message})', 'FirebaseAuthService');

        if (e.code == 'user-not-found') {
          return await signUp(data);
        }

        final error = switch (e.code) {
          'invalid-email' => AuthException(
            message: 'The email address is malformed.',
          ),
          'user-disabled' => AuthException(
            message: 'This user has been disabled.',
          ),

          'wrong-password' => AuthException(
            message: 'Wrong password provided for that user.',
          ),
          'too-many-requests' => AuthException(
            message: 'Too many attempts. Try again later.',
          ),
          'network-request-failed' => AuthException(
            message: 'Network error. Check your connection.',
          ),
          String() => AuthException(
            message: e.message ?? 'Authentication error',
          ),
        };

        return Result.error(error);
      } catch (e, t) {
        AppLogger().fatalError(e, t, 'FirebaseAuthService');

        return Result.error(AuthException(data: e));
      }
    });
  }

  @override
  Future<Result<UserCredential, AuthException>> signUp(LoginDTO data) {
    return Future(() async {
      try {
        final authResult = await _firebaseAuth.createUserWithEmailAndPassword(
          email: data.email,
          password: data.password,
        );

        return Result.success(authResult);
      } on FirebaseAuthException catch (e) {
        AppLogger().error('${e.code} (${e.message})', 'FirebaseAuthService');

        final error = switch (e.code) {
          'email-already-in-use' => AuthException(
            message: 'The email address is already in use by another account.',
          ),
          'weak-password' => AuthException(
            message: 'The password provided is too weak.',
          ),
          'invalid-email' => AuthException(
            message: 'The email address is malformed.',
          ),
          'network-request-failed' => AuthException(
            message: 'Network error. Check your connection.',
          ),
          'too-many-requests' => AuthException(
            message: 'Too many attempts. Try again later.',
          ),
          String() => AuthException(
            message: e.message ?? 'Authentication error',
          ),
        };

        return Result.error(error);
      } catch (e, t) {
        AppLogger().fatalError(e, t, 'FirebaseAuthService');

        return Result.error(AuthException(data: e));
      }
    });
  }
}
