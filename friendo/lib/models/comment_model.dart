class CommentModel {
  String commentId = '';
  String postId = '';
  String comment = '';
  String publishDate = '';
  String authorId = '';
  int likesCount = 0;

  CommentModel({
    required this.commentId,
    required this.postId,
    required this.comment,
    required this.publishDate,
    required this.authorId,
    this.likesCount = 0,
  });

  CommentModel.fromJson({
    required Map<String, dynamic> json,
  }) {
    commentId = json['commentId'] as String;
    postId = json['postId'] as String;
    comment = json['comment'] as String;
    publishDate = json['publishDate'] as String;
    authorId = json['authorId'] as String;
    likesCount = json['likesCount'] as int;
  }

  Map<String, dynamic> toMap() {
    return {
      'commentId': commentId,
      'postId': postId,
      'comment': comment,
      'publishDate': publishDate,
      'authorId': authorId,
      'likesCount': likesCount,
    };
  }
}
