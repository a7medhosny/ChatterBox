// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:chatter_box/features/auth/data/models/user_model.dart';
import 'package:chatter_box/features/auth/data/repo/auth_repo.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepo authRepo;

  AuthCubit({required this.authRepo}) : super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      final user = await authRepo.login(email: email, password: password);
      emit(user != null
          ? AuthSuccess(user: user)
          : AuthFailure(error: "Login failed."));
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }

  Future<void> register(String email, String password) async {
    emit(AuthLoading());
    try {
      final user = await authRepo.register(email: email, password: password);
      emit(user != null
          ? AuthSuccess(user: user)
          : AuthFailure(error: "Registration failed."));
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }

  Future<void> logout() async {
    try {
      // await authRepo.authService.logout();
      emit(AuthInitial());
    } catch (e) {
      emit(AuthFailure(error: "Logout failed."));
    }
  }

  Future<void> addUser(UserModel user) async {
      await authRepo.addUser(user);
  
  }
}
