import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_theme.dart';
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = ref.watch(appThemeProvider.notifier);

    return Scaffold(
      backgroundColor: themeNotifier.bgColor(),
      body: Center(
        child: SpinKitFadingCircle(
          color: themeNotifier.primaryColor(),
          size: 90.w,
        ),
      ),
    );
  }
}
