import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final appLoadingState = NotifierProvider(() => LoadingState());

final class LoadingState extends Notifier<AppLoadingState> {
  @override
  AppLoadingState build() {
    return AppLoadingState.idle;
  }

  bool get isLoading => state == AppLoadingState.busy;

  void toBusy() => state = AppLoadingState.busy;

  void toIdle() => state = AppLoadingState.idle;
}

enum AppLoadingState { idle, busy }

final supabaseInstance = Provider((ref) => Supabase.instance.client);
