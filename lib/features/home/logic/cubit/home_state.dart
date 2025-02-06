part of 'home_cubit.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<UserModel> users;
  HomeLoaded(this.users);
}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}
