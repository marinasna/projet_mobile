import 'package:flutter/material.dart';
import 'package:formation_flutter/l10n/app_localizations.dart';
import 'package:formation_flutter/res/app_colors.dart';
import 'package:formation_flutter/res/app_theme_extension.dart';
import 'package:formation_flutter/screens/homepage/homepage_screen.dart';
import 'package:formation_flutter/screens/product/product_page.dart';
import 'package:formation_flutter/screens/auth/login_page.dart';
import 'package:formation_flutter/screens/auth/register_page.dart';
import 'package:formation_flutter/states/auth_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider.value(
      value: _authProvider,
      child: const MyApp(),
    ),
  );
}

final AuthProvider _authProvider = AuthProvider();

GoRouter _router = GoRouter(
  initialLocation: '/',
  refreshListenable: _authProvider,
  redirect: (BuildContext context, GoRouterState state) {
    final bool isAuthenticated = _authProvider.isAuthenticated;
    final bool isAuthRoute = state.matchedLocation == '/login' || state.matchedLocation == '/register';

    if (!isAuthenticated && !isAuthRoute) {
      return '/login'; // Redirect to login if not authenticated and trying to access a protected route
    }

    if (isAuthenticated && isAuthRoute) {
      return '/'; // Redirect to home if authenticated and trying to access auth routes
    }

    return null; // No redirection needed
  },
  routes: [
    GoRoute(path: '/', builder: (_, _) => HomePage()),
    GoRoute(path: '/login', builder: (_, _) => const LoginPage()),
    GoRoute(path: '/register', builder: (_, _) => const RegisterPage()),
    GoRoute(
      path: '/product',
      builder: (_, GoRouterState state) =>
          ProductPage(barcode: state.extra as String),
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Open Food Facts',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        extensions: [OffThemeExtension.defaultValues()],
        fontFamily: 'Avenir',
        dividerTheme: DividerThemeData(color: AppColors.grey2, space: 1.0),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedItemColor: AppColors.blue,
          unselectedItemColor: AppColors.grey2,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
        ),
        navigationBarTheme: const NavigationBarThemeData(
          indicatorColor: AppColors.blue,
        ),
      ),
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
    );
  }
}
