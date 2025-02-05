class UserModel {
  String uid;
  String name;

  UserModel({required this.uid, required this.name});

  // تحويل بيانات الكائن إلى JSON عند إضافته لـ Firestore
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
    };
  }

  // استعادة البيانات من Firestore وتحويلها إلى كائن UserModel
  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
    );
  }
}
