import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gradle_mate/providers/theme_provider.dart';
import 'package:gradle_mate/ui/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'providers/compatibility_provider.dart';
import 'ui/CompatibilityCheckerPage.dart';
import 'ui/serch_by_gradle.dart';

final GoRouter _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => HomeScreen(),
    ),
    GoRoute(
      path: '/gradle',
      builder: (context, state) => const GradleLookupPage(),
    ),
    GoRoute(
      path: '/full-checker',
      builder: (context, state) => const FullCompatibilityPage(),
    ),
  ],
);

void main() async{
  await dotenv.load(fileName: ".env");
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => CompatibilityProvider()),
      ],
      child: const CompatibilityCheckerApp(),
    ),
  );
}

class CompatibilityCheckerApp extends StatelessWidget {
  const CompatibilityCheckerApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Compatibility Checker',
          theme: ThemeData.from(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.teal,
              brightness: themeProvider.brightness,
            ),
          ),
          routerConfig: _router,
        );
      },
    );
  }
}
