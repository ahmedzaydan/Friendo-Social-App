abstract class FriendoStates {}

class FriendoInitialState extends FriendoStates {}

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
