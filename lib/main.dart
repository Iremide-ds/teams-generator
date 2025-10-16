import 'dart:async';

import 'package:flutter/material.dart';
import 'package:teams_gen/src/app.dart';
import 'package:teams_gen/src/core/config/theme.dart';
import 'package:teams_gen/src/shared/util/app_logger.dart';

void main() {
  runZonedGuarded(
    () {
      WidgetsFlutterBinding.ensureInitialized();

      runApp(const MyApp());
    },
    (error, stack) {
      AppLogger().fatalError(error, stack);
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Teams generator',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: const MyHomePage(),
    );
  }
}
