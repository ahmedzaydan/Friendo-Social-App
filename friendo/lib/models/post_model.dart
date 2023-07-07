class PostModel {
  String? postId;
  String? authorId;
  String? publishDate;
  String content = '';
  String image = '';
  List<String> tags = [];
  int likesCount = 0;
  int commentsCount = 0;

  PostModel({
    required this.postId,
    required this.authorId,
    required this.publishDate,
    this.content = '',
    this.image = '',
    this.tags = const [],
    this.likesCount = 0,
    this.commentsCount = 0,
  });

  PostModel.fromJson({
    required Map<String, dynamic> json,
  }) {
    postId = json['postId'] as String;
    authorId = json['authorId'] as String;
    publishDate = json['publishDate'] as String;
    content = json['content'] as String;
    image = json['image'] as String;
    tags = (json['tags'] as List<dynamic>).cast<String>();
    likesCount = json['likesCount'] as int;
    commentsCount = json['commentsCount'] as int;
  }

  Map<String, dynamic> toMap() {
    return {
      'postId': postId,
      'authorId': authorId,
      'publishDate': publishDate,
      'content': content,
      'image': image,
      'tags': tags,
      'likesCount': likesCount,
      'commentsCount': commentsCount,
    };
  }
}
