part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final UserModel user;

  AuthSuccess({required this.user});
}

class AuthFailure extends AuthState {
  final String error;

  AuthFailure({required this.error});

}