abstract class FriendoStates {}

class FriendoInitialState extends FriendoStates {}

// Get user data states
class GetCurrentUserModelLoadingState extends FriendoStates {}

class GetCurrentUserModelSuccessState extends FriendoStates {}

class GetCurrentUserModelErrorState extends FriendoStates {
  final String error;

  GetCurrentUserModelErrorState(this.error);
}

class ChangeCurrentIndexState extends FriendoStates {}

class UploadImageLoadingState extends FriendoStates {}

// Pick Image from device states
class PickImageErrorState extends FriendoStates {}

// Put image in firebase storage state
class PutImageInStorageErrorState extends FriendoStates {}

// Get download URL image states
class GetDownloadURLErrorState extends FriendoStates {}

// Update image states
class UpdateImageLoadingState extends FriendoStates {}

class UpdateImageErrorState extends FriendoStates {}

// Update user data states (username, bio, phone)
class UpdateUserDataSuccessState extends FriendoStates {}

class UpdateUserDataErrorState extends FriendoStates {}

class NewPostScreenState extends FriendoStates {}
