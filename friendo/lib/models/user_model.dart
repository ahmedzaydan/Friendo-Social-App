class UserModel {
  String? uid;
  String? username;
  String? email;
  bool? isEmailVerified;
  String? phone;
  String? profileImage;
  String? coverImage;
  String? bio;

  UserModel({
    required this.uid,
    this.username,
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
    uid = json['uid'];
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
      'uid': uid,
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
