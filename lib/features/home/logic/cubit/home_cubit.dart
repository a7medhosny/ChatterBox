import 'package:bloc/bloc.dart';
import 'package:chatter_box/features/auth/data/models/user_model.dart';
import 'package:chatter_box/features/home/data/repo/home_repo.dart';
import 'package:meta/meta.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepo homeRepo;

  HomeCubit({required this.homeRepo}) : super(HomeInitial());

  Future<void> getUsersExceptCurrent() async {
    emit(HomeLoading());

    try {
      final users = await homeRepo.getUsersExceptCurrent();
      emit(HomeLoaded(users));
    } catch (e) {
      emit(HomeError("Oops!,please try again later"));
    }
  }

  Future<void> createNewChat(String uid1, String uid2) async {
    try {
      await homeRepo.createNewChat(uid1, uid2);
    } catch (e) {
      // print("Error with craete chat $e");
    }
  }
}
