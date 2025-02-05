import 'package:chatter_box/core/services/auth_service.dart';
import 'package:chatter_box/core/services/database_service.dart';
import 'package:chatter_box/features/auth/data/repo/auth_repo.dart';
import 'package:chatter_box/features/auth/logic/cubit/auth_cubit.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

void setup() {
  // تسجيل AuthService كمصدر للخدمات المتعلقة بالمصادقة
  getIt.registerLazySingleton<AuthService>(() => AuthService());
  getIt.registerLazySingleton<DatabaseService>(() => DatabaseService());

  // تسجيل AuthRepo والذي يعتمد على AuthService
  getIt.registerLazySingleton<AuthRepo>(() => AuthRepo(
      authService: getIt<AuthService>(),
      databaseService: getIt<DatabaseService>()));

  // تسجيل AuthCubit لإدارة حالة المصادقة
  getIt
      .registerFactory<AuthCubit>(() => AuthCubit(authRepo: getIt<AuthRepo>()));
}
