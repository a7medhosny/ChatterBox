import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:chatter_box/core/DI/get_it.dart';
import 'package:chatter_box/core/helpers/helper.dart';
import 'package:chatter_box/core/services/auth_service.dart';
import 'package:chatter_box/features/auth/data/models/user_model.dart';
import 'package:chatter_box/features/home/data/repo/home_repo.dart';
import 'package:meta/meta.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepo homeRepo;
  Map<String, Stream<String?>> lastMessages = {};
  Map<String, bool> isRead = {};
  HomeCubit({required this.homeRepo}) : super(HomeInitial());
  List<UserModel> users = [];
  // Future<void> getUsersExceptCurrent() async {
  //   emit(HomeLoading());

  //   try {
  //     final users = await homeRepo.getUsersExceptCurrent();
  //     final userId = getIt.get<AuthService>().user!.uid;

  //     for (var user in users) {
  //       String chatId = generateChatId(userId, user.uid);
  //       // final lastMsg = await homeRepo
  //       //     .getLastMessage(chatId)
  //       //     .map(
  //       //       (data) => data?['content'] as String?, // استخراج النص فقط
  //       //     )
  //       //     .first;

  //       lastMessages[chatId] = homeRepo.getLastMessage(chatId).map(
  //             (data) => data?['content'] as String?,
  //           );
  //     }

  //     emit(HomeLoaded(users, lastMessages));
  //   } catch (e, stackTrace) {
  //     log("Error fetching users: $e", stackTrace: stackTrace);
  //     emit(HomeError("Oops!, please try again later"));
  //   }
  // }
  Future<void> getUsersExceptCurrent() async {
    emit(HomeLoading());

    try {
      users = await homeRepo.getUsersExceptCurrent();
      final userId = getIt.get<AuthService>().user!.uid;

      for (var user in users) {
        String chatId = generateChatId(userId, user.uid);

        lastMessages[chatId] = homeRepo.getLastMessage(chatId).map(
              (data) => data?['content'] as String?, // استخراج النص فقط
            );

        homeRepo.getLastMessage(chatId).listen((data) {
          final senderID = data?['senderID'] as String?;
          // التحقق مما إذا كان المستخدم الحالي هو المرسل أم لا
          if (senderID != null && senderID != userId) {
            isRead[chatId] = false; // رسالة جديدة لم تُقرأ
          } else {
            isRead[chatId] = true; // تم قراءة الرسالة أو لا يوجد رسالة جديدة
          }
 
        });
      }

      emit(HomeLoaded(users, lastMessages));
    } catch (e, stackTrace) {
      log("Error fetching users: $e", stackTrace: stackTrace);
      emit(HomeError("Oops!, please try again later"));
    }
  }

  void markChatAsRead(String chatId) {
    isRead[chatId] = true;
    emit(HomeLoaded(users, lastMessages)); // إعادة إرسال الحالة لتحديث الـ UI
  }

  Future<void> createNewChat(String uid1, String uid2) async {
    try {
      await homeRepo.createNewChat(uid1, uid2);
    } catch (e, stackTrace) {
      log("Error creating chat: $e", stackTrace: stackTrace);
    }
  }
}
