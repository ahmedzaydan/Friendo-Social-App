abstract class AuthStates {}

class AuthInitialState extends AuthStates {}

class LoginLoadingState extends AuthStates {}

class LoginSuccessState extends AuthStates {
  final String uid;

  LoginSuccessState(this.uid);
}

class LoginErrorState extends AuthStates {
  final String error;

  LoginErrorState(this.error);
}
class RegisterLoadingState extends AuthStates {}

class RegisterSuccessState extends AuthStates {
  final String uid;

  RegisterSuccessState(this.uid);
}

class RegisterErrorState extends AuthStates {
  final String error;

  RegisterErrorState(this.error);
}

class ChangePasswordVisibilityState extends AuthStates {}

class CreateUserSuccessState extends AuthStates {}

class CreateUserErrorState extends AuthStates {
  final String error;

  CreateUserErrorState(this.error);
}
