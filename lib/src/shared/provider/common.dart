import 'package:flutter_riverpod/flutter_riverpod.dart';

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
