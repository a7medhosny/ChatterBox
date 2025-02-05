import 'package:chatter_box/core/DI/get_it.dart';
import 'package:chatter_box/core/routing/routes.dart';
import 'package:chatter_box/features/auth/logic/cubit/auth_cubit.dart';
import 'package:chatter_box/features/auth/presention/screens/login_screen.dart';
import 'package:chatter_box/features/auth/presention/screens/register_screen.dart';
import 'package:chatter_box/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class AppRouter {
  static Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splashScreen:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case Routes.loginScreen:
        return MaterialPageRoute(
            builder: (_) => BlocProvider<AuthCubit>(
                  create: (context) =>
                      getIt<AuthCubit>(), // استخدام GetIt لإنشاء AuthCubit
                  child: LoginScreen(),
                ));
      case Routes.registerScreen:
        return MaterialPageRoute(
            builder: (_) => BlocProvider<AuthCubit>(
                  create: (context) =>
                      getIt<AuthCubit>(), // استخدام GetIt لإنشاء AuthCubit
                  child: RegisterScreen(),
                ));
    }
    return null;
  }
}
