import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'features/auth/view/screens/login_screen.dart';
import 'features/auth/view/screens/register_screen.dart';
import 'features/home/view/screens/main_layout.dart';
import 'features/auth/viewmodels/token_provider.dart';
import 'features/auth/services/auth_local_service.dart';
import 'features/auth/viewmodels/auth_provider.dart';
import 'core/theme/app_theme.dart';
import 'features/prayer/models/prayer_models.dart';
import 'features/prayer/models/performance_models.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(UserLocationModelAdapter());
  Hive.registerAdapter(PrayerTimesModelAdapter());
  Hive.registerAdapter(PrayerStatusAdapter());
  Hive.registerAdapter(PrayerDayModelAdapter());
  Hive.registerAdapter(MonthlySummaryModelAdapter());
  Hive.registerAdapter(PrayerScoreConfigModelAdapter());

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(tokenProvider);

    final authState = ref.watch(authProvider);
    final themeMode = ref.watch(appThemeProvider);
    final themeNotifier = ref.read(appThemeProvider.notifier);
    
    // Initialize Prayer Features
    ref.watch(prayerInitProvider);
    ref.watch(prayerPeriodicCheckProvider);

    return ScreenUtilInit(
      designSize: const Size(400, 928),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: themeNotifier.lightTheme,
          darkTheme: themeNotifier.darkTheme,
          themeMode: themeMode,
          home: authState.when(
            data: (user) => user != null ? const MainLayout() : LoginScreen(),
            loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
            error: (_, __) => LoginScreen(),
          ),
          routes: {
            '/login': (context) => LoginScreen(),
            '/register': (context) => RegisterScreen(),
            '/home': (context) => const MainLayout(),
          },
        );
      },
    );
  }
}