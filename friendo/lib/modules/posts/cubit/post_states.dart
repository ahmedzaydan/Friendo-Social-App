abstract class PostStates {}

class PostInitialState extends PostStates {}

// Create post states
class CreatePostLoadingState extends PostStates {}

class CreatePostSuccessState extends PostStates {}

class CreatePostErrorState extends PostStates {
  final String error;

  CreatePostErrorState(this.error);
}

class AddPostImageState extends PostStates {}

class RemovePostImageState extends PostStates {}

/// Get posts states
class GetPostsInfoLoadingState extends PostStates {}

class GetPostsInfoSuccessState extends PostStates {}

class GetPostsInfoErrorState extends PostStates {
  final String error;

  GetPostsInfoErrorState(this.error);
}



class GetAuthorsErrorState extends PostStates {
  final String error;

  GetAuthorsErrorState(this.error);
}

/// Toggle like states
class ToggleLikeSuccessState extends PostStates {}

class ToggleLikeErrorState extends PostStates {
  final String error;

  ToggleLikeErrorState(this.error);
}

/// Post likes states
class GetPostLikesSuccessState extends PostStates {}

class GetPostLikesErrorState extends PostStates {
  final String error;

  GetPostLikesErrorState(this.error);
}



/// Post comments states
class CreateCommentSuccessState extends PostStates {}

class CreateCommentErrorState extends PostStates {
  final String error;

  CreateCommentErrorState(this.error);
}

class GetPostCommentsSuccessState extends PostStates {}
class GetPostCommentsErrorState extends PostStates {
  final String error;

  GetPostCommentsErrorState(this.error);
}

/// Edit post states
// class EditPostSuccessState extends PostStates {}

// class EditPostErrorState extends PostStates {
//   final String error;

//   EditPostErrorState(this.error);
// }

/// Update posts states
class UpdatePostModelSuccessState extends PostStates {}

class UpdatePostModelErrorState extends PostStates {
  final String error;

  UpdatePostModelErrorState(this.error);
}

class CheckKeyboardVisibilityState extends PostStates {}