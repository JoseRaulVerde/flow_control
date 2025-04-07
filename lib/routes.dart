import 'package:flow_control/screens/bottom_nav_screen.dart';
import 'package:flutter/material.dart';
import 'package:flow_control/screens/login_screen.dart';


class AppRoutes {
  static const String login = '/login';
  static const String home = '/home';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case home:
       final args = settings.arguments as int?;
        return MaterialPageRoute(
          builder: (_) => BottomNavScreen(initialIndex: args ?? 0),
        );
      default:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
    }
  }
}