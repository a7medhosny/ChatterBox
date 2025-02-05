import 'package:chatter_box/core/DI/get_it.dart';
import 'package:chatter_box/core/services/auth_service.dart';
import 'package:chatter_box/features/auth/data/models/user_model.dart';
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
      print("User Added Successfully!");
    } catch (e) {
      print("Error adding user: $e");
      throw Exception(e.toString());
    }
  }

  Future<List<UserModel>> getUsersExceptCurrent() async {
    try {
      String currentUserId = getIt.get<AuthService>().user!.uid;

      QuerySnapshot querySnapshot = await _usersCollection!
          .where('uid', isNotEqualTo: currentUserId) // استبعاد المستخدم الحالي
          .get();

      return querySnapshot.docs
          .map((doc) => UserModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print("Error getting users: $e");
      throw Exception(e.toString());
    }
  }
}
