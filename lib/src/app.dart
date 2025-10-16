import 'package:flutter/material.dart';
import 'package:teams_gen/src/core/config/router.dart';
import 'package:teams_gen/src/core/config/theme.dart';

final appNavigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Teams generator',

      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,

      navigatorKey: appNavigatorKey,
      onGenerateRoute: appRouteBuilder,
    );
  }
}
