import 'package:chatter_box/core/DI/get_it.dart';
import 'package:chatter_box/core/routing/routes.dart';
import 'package:chatter_box/features/auth/data/models/user_model.dart';
import 'package:chatter_box/features/auth/logic/cubit/auth_cubit.dart';
import 'package:chatter_box/features/auth/presention/screens/login_screen.dart';
import 'package:chatter_box/features/auth/presention/screens/register_screen.dart';
import 'package:chatter_box/features/chat/logic/cubit/chat_cubit.dart';
import 'package:chatter_box/features/chat/presention/screens/chat_screen.dart';
import 'package:chatter_box/features/home/logic/cubit/home_cubit.dart';
import 'package:chatter_box/features/home/presention/screens/home_screen.dart';
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
          ),
        );
      case Routes.registerScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider<AuthCubit>(
            create: (context) =>
                getIt<AuthCubit>(), // استخدام GetIt لإنشاء AuthCubit
            child: RegisterScreen(),
          ),
        );
      case Routes.homeScreen:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => getIt<HomeCubit>(),
                  child: HomeScreen(),
                ));
      case Routes.chatScreen:
        final user = settings.arguments as UserModel;
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: getIt<ChatCubit>(), // استخدام نفس الكيوبت بدل إعادة إنشائه
            child: ChatScreen(user: user),
          ),
        );
    }
    return null;
  }
}
