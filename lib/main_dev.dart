import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teams_gen/src/app.dart';
import 'package:teams_gen/src/core/config/observers.dart';
import 'package:teams_gen/src/shared/util/app_logger.dart';
import 'package:teams_gen/src/shared/util/init.dart';

void main() {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      await initFirebaseCore();

      runApp(
        const ProviderScope(observers: [RiverpodLogger()], child: MyApp()),
      );
    },
    (error, stack) {
      AppLogger().fatalError(error, stack);
    },
  );
}
