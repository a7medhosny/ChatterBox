import 'dart:async';

import 'package:chatter_box/core/routing/routes.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
     Timer(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacementNamed(Routes.loginScreen);
    });
    return Scaffold(
      body: Center(child: Text('ChatterBox',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24),),),
    );
  }
}