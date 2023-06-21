abstract class FriendoStates {}

class FriendoInitialState extends FriendoStates {}

// Get user data states
class GetUserDataLoadingState extends FriendoStates {}

class GetUserDataSuccessState extends FriendoStates {}

class GetUserDataErrorState extends FriendoStates {
  final String error;

  GetUserDataErrorState(this.error);
}

class VerifyEmailSuccessState extends FriendoStates {}

class VerifyEmailErrorState extends FriendoStates {
  final String error;

  VerifyEmailErrorState(this.error);
}

// Logout states
class LogoutLoadingState extends FriendoStates {}

class LogoutSuccessState extends FriendoStates {}

class LogoutErrorState extends FriendoStates {
  final String error;

  LogoutErrorState(this.error);
}

class ChangeCurrentIndexState extends FriendoStates {}

class NewPostState extends FriendoStates {}

// Pick Image from device states
class PickImageSuccessState extends FriendoStates {}

class PickImageErrorState extends FriendoStates {}

// Upload Image to Firebase Storage states
class UploadImageSuccessState extends FriendoStates {}

class UploadImageErrorState extends FriendoStates {}

// Get download URL image states
class GetDownloadURLErrorState extends FriendoStates {}

// Update user data states
class UpdateUserDataSuccessState extends FriendoStates {}

class UpdateUserDataErrorState extends FriendoStates {
  final String error;

  UpdateUserDataErrorState(this.error);
}
