abstract class PostStates {}

class PostInitialState extends PostStates {}

class CreatePostLoadingState extends PostStates {}

class CreatePostSuccessState extends PostStates {}

class CreatePostErrorState extends PostStates {
  final String error;

  CreatePostErrorState(this.error);
}

class AddPostImageState extends PostStates {}

class RemovePostImageState extends PostStates {}

class ToggleLikeErrorState extends PostStates {
  final String error;

  ToggleLikeErrorState(this.error);
}

class UpdatePostErrorState extends PostStates {
  final String error;

  UpdatePostErrorState(this.error);
}
class DeletePostErrorState extends PostStates {
  final String error;

  DeletePostErrorState(this.error);
}
class CreateCommentErrorState extends PostStates {
  final String error;

  CreateCommentErrorState(this.error);
}

class UpdateCommentErrorState extends PostStates {
  final String error;

  UpdateCommentErrorState(this.error);
}

class DeleteCommentErrorState extends PostStates {
  final String error;

  DeleteCommentErrorState(this.error);
}
