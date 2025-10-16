import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teams_gen/src/app.dart';
import 'package:teams_gen/src/shared/util/app_logger.dart';

void main() {
  runZonedGuarded(
    () {
      WidgetsFlutterBinding.ensureInitialized();

      runApp(const ProviderScope(child: MyApp()));
    },
    (error, stack) {
      AppLogger().fatalError(error, stack);
    },
  );
}
