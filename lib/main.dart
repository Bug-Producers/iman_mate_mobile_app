import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/auth/presentation/screens/register_screen.dart';
import 'features/home/view/screens/main_layout.dart';
import 'features/auth/presentation/token_provider.dart';
import 'features/auth/data/auth_local_service.dart';
import 'core/theme/app_theme.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/network/dio_client.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
   await Hive.initFlutter();
   await AuthLocalService.instance.init();
   
   final token = AuthLocalService.instance.token;
   if (token != null) {
     DioClient().setToken(token);
   }

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
    
    final themeMode = ref.watch(appThemeProvider);
    final themeNotifier = ref.read(appThemeProvider.notifier);
    
    final isLoggedIn = AuthLocalService.instance.isLoggedIn;

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
          initialRoute: isLoggedIn ? '/home' : '/login',
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