// database_service.dart
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
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<QueryDocumentSnapshot<Object?>>> getUsersExceptCurrent() async {
    try {
      String currentUserId = getIt.get<AuthService>().user!.uid;
      QuerySnapshot querySnapshot = await _usersCollection!
          .where('uid', isNotEqualTo: currentUserId)
          .get();
      return querySnapshot.docs;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<bool> checkChatExists(String chatId) async {
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
      await _chatCollection!
          .doc(chatId)
          .collection('messages')
          .add(message.toJson());
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Stream<QuerySnapshot> getChatMessagesStream(String chatId) {
    return _chatCollection!
        .doc(chatId)
        .collection('messages')
        .orderBy('sentAt', descending: true)
        .snapshots();
  }

  Stream<Map<String,dynamic>?> getLastMessage(String chatId) {
    return _chatCollection!
        .doc(chatId)
        .collection('messages')
        .orderBy('sentAt', descending: true)
        .limit(1)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        return {'content':snapshot.docs.first['content'] as String,'senderID':snapshot.docs.first['senderID']};
      }
      return null;
    });
  }
}
