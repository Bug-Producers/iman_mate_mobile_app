import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iman_mate_mobile_app/features/authentication/presentation/providers/authentication_controller.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    Navigator.pushReplacementNamed(context, 'home');
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
