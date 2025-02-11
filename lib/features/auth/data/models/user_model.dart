class UserModel {
  String uid;
  String name;
  String token;
  UserModel({required this.uid, required this.name,required this.token});

  // تحويل بيانات الكائن إلى JSON عند إضافته لـ Firestore
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'token':token
    };
  }

  // استعادة البيانات من Firestore وتحويلها إلى كائن UserModel
  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      token: map['token'] ?? '',
    );
  }
}
