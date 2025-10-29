import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teams_gen/src/features/authentication/data/model/login.dart';
import 'package:teams_gen/src/features/authentication/data/service/auth_service.dart';

final authControllerProvider =
    AsyncNotifierProvider<AuthController, UserCredential?>(() {
      return AuthController();
    });

final class AuthController extends AsyncNotifier<UserCredential?> {
  @override
  FutureOr<UserCredential?> build() async {
    return null;
  }

  Future<void> login(LoginDTO data) async {
    state = const AsyncValue.loading();

    final result = await ref.read(authService).login(data);

    if (result.isSuccess) {
      state = AsyncValue.data(result.data!);
    } else {
      state = AsyncValue.error(result.error!, StackTrace.current);
    }
  }
}
