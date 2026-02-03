import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iman_mate_mobile_app/features/authentication/controller/authentication_controller.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Trigger the auth check when screen loads
    // We use Future.microtask to ensure provider is ready if needed, mostly safe directly too
    Future.microtask(() => 
      ref.read(authenticationControllerProvider.notifier).checkAuth()
    );
  }

  @override
  Widget build(BuildContext context) {
    // Listen for state changes to perform navigation
    ref.listen<AuthStatus>(authenticationControllerProvider, (previous, next) {
      if (next == AuthStatus.authenticated) {
        Navigator.of(context).pushReplacementNamed('home');
      } else if (next == AuthStatus.unauthenticated) {
        Navigator.of(context).pushReplacementNamed('login');
      }
    });

    return Scaffold(
      body: Center(
        child: SpinKitFadingCircle(
          color: Theme.of(context).colorScheme.primary,
          size: 90.w,
        ),
      ),
    );
  }
}
