import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teams_gen/src/core/config/router.dart';
import 'package:teams_gen/src/shared/extensions/buildcontext.dart';
import 'package:teams_gen/src/shared/util/init.dart';
import 'package:teams_gen/src/shared/widgets/scaffold.dart';

class SPlashScreen extends ConsumerStatefulWidget {
  const SPlashScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SPlashScreenState();
}

class _SPlashScreenState extends ConsumerState<SPlashScreen> {
  @override
  void initState() {
    super.initState();

    _init();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(isLoading: true);
  }

  Future<void> _init() async {
    await initDB();

    if (mounted) {
      context.showInfoToast('Hello there!');

      context.replaceRoute(HomeRoute());
    }
  }
}
