import 'package:chatter_box/core/DI/get_it.dart';
import 'package:chatter_box/core/helpers/helper.dart';
import 'package:chatter_box/core/services/auth_service.dart';
import 'package:chatter_box/features/auth/data/models/user_model.dart';
import 'package:chatter_box/features/chat/data/models/chat_model.dart';
import 'package:chatter_box/features/chat/data/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  DatabaseService() {
    setUpCollectionReference();
  }
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  CollectionReference? _usersCollection;
  CollectionReference? _chatCollection;
  void setUpCollectionReference() {
    _usersCollection = _firebaseFirestore.collection('users');
    _chatCollection = _firebaseFirestore.collection('chat');
  }

  Future<void> addUser(UserModel user) async {
    try {
      await _usersCollection!.doc(user.uid).set(user.toJson());
      // print("User Added Successfully!");
    } catch (e) {
      // print("Error adding user: $e");
      throw Exception(e.toString());
    }
  }

  Future<List<QueryDocumentSnapshot<Object?>>> getUsersExceptCurrent() async {
    try {
      String currentUserId = getIt.get<AuthService>().user!.uid;

      QuerySnapshot querySnapshot = await _usersCollection!
          .where('uid', isNotEqualTo: currentUserId) // استبعاد المستخدم الحالي
          .get();

      return querySnapshot.docs;
    } catch (e) {
      // print("Error getting users: $e");
      throw Exception(e.toString());
    }
  }

  Future<bool> checkChatExists(String chatId) async {
    // String chatId = generateChatId(uid1, uid2);
    final result = await _chatCollection!.doc(chatId).get();
    
      return result.exists;
  }

  Future<void> createNewChat(String uid1, String uid2) async {
    String chatId = generateChatId(uid1, uid2);
    bool result = await checkChatExists(chatId);
    if (!result) {
      final docRef = _chatCollection!.doc(chatId);
      final Chat chat =
          Chat(id: chatId, participants: [uid1, uid2], messages: []);
      try {
        await docRef.set(chat.toJson());
      } catch (e) {
        throw Exception(e.toString());
      }
    }
  }

  Future<void> sendChatMessage(uid1, uid2, Message message) async {
    final String chatId = generateChatId(uid1, uid2);

    try {
      await _chatCollection!.doc(chatId).update({
        "messages": FieldValue.arrayUnion([message.toJson()])
      });
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<Chat> getChatData(String uid1, String uid2) async {
    try {
      final String chatId = generateChatId(uid1, uid2);

      QuerySnapshot querySnapshot =
          await _chatCollection!.where('id', isEqualTo: chatId).get();
      List<Chat> chats = querySnapshot.docs
          .map((doc) => Chat.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      return chats[0];
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
