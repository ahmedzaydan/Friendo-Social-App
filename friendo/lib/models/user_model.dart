class UserModel {
  String? uId;
  String? username;
  String? email;
  bool? isEmailVerified;
  String? phone;
  String? profileImage;
  String? coverImage;
  String? bio;
  String? deviceToken;
  UserModel({
    required this.uId,
    required this.deviceToken,
    required this.username,
    this.email,
    this.phone,
    this.profileImage,
    this.coverImage,
    this.bio,
    this.isEmailVerified = false,
  });

  UserModel.fromJson({
    required Map<String, dynamic> json,
  }) {
    uId = json['uId'];
    deviceToken = json['deviceToken'];
    username = json['username'];
    email = json['email'];
    isEmailVerified = json['isEmailVerified'];
    phone = json['phone'];
    profileImage = json['profileImage'];
    coverImage = json['coverImage'];
    bio = json['bio'];
  }

  Map<String, dynamic> toMap() {
    return {
      'uId': uId,
      'deviceToken': deviceToken,
      'username': username,
      'email': email,
      'isEmailVerified': isEmailVerified,
      'phone': phone,
      'profileImage': profileImage,
      'coverImage': coverImage,
      'bio': bio,
    };
  }
}
