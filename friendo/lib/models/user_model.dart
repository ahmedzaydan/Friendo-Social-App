class UserModel {
  String? username;
  String? uid;
  String? email;
  String? phone;
  bool? isEmailVerified;
  UserModel({
    this.username,
    required this.uid,
    this.email,
    this.phone,
  });

  UserModel.fromJson({
    required Map<String, dynamic> json,
  }) {
    username = json['username'];
    uid = json['uid'];
    email = json['email'];
    phone = json['phone'];
    isEmailVerified = json['isEmailVerified'];
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'uid': uid,
      'email': email,
      'phone': phone,
      'isEmailVerified': false,
    };
  }
}
