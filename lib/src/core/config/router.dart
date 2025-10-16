import 'package:flutter/material.dart';
import 'package:teams_gen/src/features/dashboard/presentation/pages/home.dart';
import 'package:teams_gen/src/features/splash/presentation/pages/splash.dart';
import 'package:teams_gen/src/shared/util/app_logger.dart';

Route<dynamic>? appRouteBuilder(RouteSettings settings) {
  final routes = <AppRoute>[RootRoute(), HomeRoute()];

  final path = settings.name;

  final logger = AppLogger();

  try {
    logger.debug('Looking for $path', 'Navigator');
    final existingRoute = routes.firstWhere((e) => e.path.path == path);

    logger.debug('Found $path', 'Navigator');

    return MaterialPageRoute(
      builder: (context) => existingRoute.builder(context, settings.arguments),
    );
  } catch (e, t) {
    logger.error('Can not navigate to $path');
    logger.fatalError(e, t, 'Navigation');
  }

  return null;
}

enum AppRoutePath {
  root('/'),
  home('/home');

  final String path;
  const AppRoutePath(this.path);
}

sealed class AppRoute<T extends Object?> {
  const AppRoute({
    required this.path,
    required this.data,
    required this.builder,
  });

  final AppRoutePath path;

  final T data;

  final Widget Function(BuildContext context, Object? args) builder;
}

final class RootRoute extends AppRoute {
  RootRoute()
    : super(
        path: AppRoutePath.root,
        data: null,
        builder: (context, args) {
          return const SPlashScreen();
        },
      );
}

final class HomeRoute extends AppRoute {
  HomeRoute()
    : super(
        path: AppRoutePath.home,
        data: null,
        builder: (context, args) {
          return const MyHomePage();
        },
      );
}
