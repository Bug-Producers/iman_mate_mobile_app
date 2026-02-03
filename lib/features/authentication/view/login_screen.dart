import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controller/authentication_controller.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            ref.read(authenticationControllerProvider.notifier).login().then((_) {
               Navigator.of(context).pushReplacementNamed('home');
            });
          },
          child: const Text('Login'),
        ),
      ),
    );
  }
}
