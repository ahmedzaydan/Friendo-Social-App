abstract class ChatsStates {}

class ChatsInitialState extends ChatsStates {}

class ChatsLoadingState extends ChatsStates {}

class GetChatsSuccessState extends ChatsStates {}

class GetChatsErrorState extends ChatsStates {
  final String error;
  GetChatsErrorState(this.error);
}

class SendMessageSuccessState extends ChatsStates {}

class SendMessageErrorState extends ChatsStates {
  final String error;
  SendMessageErrorState(this.error);
}

class GetMessagesSuccessState extends ChatsStates {}
