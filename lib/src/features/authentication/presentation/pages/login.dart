import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teams_gen/src/core/config/router.dart';
import 'package:teams_gen/src/features/authentication/data/model/login.dart';
import 'package:teams_gen/src/features/authentication/presentation/controller/auth_controller.dart';
import 'package:teams_gen/src/shared/extensions/buildcontext.dart';
import 'package:teams_gen/src/shared/provider/common.dart';
import 'package:teams_gen/src/shared/widgets/buttons.dart';
import 'package:teams_gen/src/shared/widgets/form_fields.dart';
import 'package:teams_gen/src/shared/widgets/scaffold.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      isLoading: ref.watch(appLoadingState),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  EmailTextFormField(
                    labelText: 'Email',
                    controller: _emailController,
                  ),
                  const SizedBox(height: 14),
                  PasswordTextFormField(
                    labelText: 'Password',
                    controller: _passwordController,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Proceed',
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  ref.read(appLoadingState.notifier).toBusy();

                  await ref
                      .read(authControllerProvider.notifier)
                      .login(
                        FirebaseAuthDTO(
                          email: _emailController.text,
                          password: _passwordController.text,
                        ),
                      );

                  ref.read(appLoadingState.notifier).toIdle();

                  if (context.mounted) {
                    final authController = ref.read(authControllerProvider);

                    if (authController.error != null) {
                      context.showErrorToast(authController.error!.toString());
                    } else {
                      context.replaceRoute(HomeRoute());
                    }
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
