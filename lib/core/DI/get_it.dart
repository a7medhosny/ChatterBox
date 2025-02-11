import 'package:chatter_box/core/services/auth_service.dart';
import 'package:chatter_box/core/services/database_service.dart';
import 'package:chatter_box/core/services/notification_service.dart';
import 'package:chatter_box/features/auth/data/repo/auth_repo.dart';
import 'package:chatter_box/features/auth/logic/cubit/auth_cubit.dart';
import 'package:chatter_box/features/chat/data/repo/chat_repo.dart';
import 'package:chatter_box/features/chat/logic/cubit/chat_cubit.dart';
import 'package:chatter_box/features/home/data/repo/home_repo.dart';
import 'package:chatter_box/features/home/logic/cubit/home_cubit.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

void setup() {
  // تسجيل AuthService كمصدر للخدمات المتعلقة بالمصادقة
  getIt.registerLazySingleton<AuthService>(() => AuthService());
  getIt.registerLazySingleton<DatabaseService>(() => DatabaseService());
  getIt.registerLazySingleton<NotificationService>(() => NotificationService());

  // تسجيل AuthRepo والذي يعتمد على AuthService
  getIt.registerLazySingleton<AuthRepo>(() => AuthRepo(
      authService: getIt<AuthService>(),
      databaseService: getIt<DatabaseService>(),
      notificationService: getIt<NotificationService>()));

  // تسجيل AuthCubit لإدارة حالة المصادقة
  getIt
      .registerFactory<AuthCubit>(() => AuthCubit(authRepo: getIt<AuthRepo>()));

  getIt.registerLazySingleton<HomeRepo>(
      () => HomeRepo(databaseService: getIt<DatabaseService>()));
  getIt
      .registerFactory<HomeCubit>(() => HomeCubit(homeRepo: getIt<HomeRepo>()));

  getIt.registerLazySingleton<ChatRepo>(
      () => ChatRepo(databaseService: getIt<DatabaseService>(), notificationService:getIt<NotificationService>() ));
  getIt.registerLazySingleton<ChatCubit>(() => ChatCubit(getIt<ChatRepo>()));
}
