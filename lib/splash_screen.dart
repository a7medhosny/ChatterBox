import 'dart:async';

import 'package:chatter_box/core/DI/get_it.dart';
import 'package:chatter_box/core/routing/routes.dart';
import 'package:chatter_box/core/services/auth_service.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String initialRoute = getIt.get<AuthService>().user != null
        ? Routes.homeScreen
        : Routes.loginScreen;
    Timer(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacementNamed(initialRoute);
    });
    return Scaffold(
      body: Center(
        child: Text(
          'ChatterBox',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
      ),
    );
  }
}
