abstract class AuthStates {}

class AuthInitialState extends AuthStates {}

// Login states
class LoginLoadingState extends AuthStates {}

class LoginSuccessState extends AuthStates {
  final String uid;

  LoginSuccessState(this.uid);
}

class LoginErrorState extends AuthStates {
  final String error;

  LoginErrorState(this.error);
}

// Verify email states
class VerifyEmailSuccessState extends AuthStates {}

class VerifyEmailErrorState extends AuthStates {
  final String error;

  VerifyEmailErrorState(this.error);
}

// Register states
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

// Create user states
class CreateUserSuccessState extends AuthStates {}

class CreateUserErrorState extends AuthStates {
  final String error;

  CreateUserErrorState(this.error);
}

// Logout states
class LogoutLoadingState extends AuthStates {}

class LogoutSuccessState extends AuthStates {}

class LogoutErrorState extends AuthStates {
  final String error;

  LogoutErrorState(this.error);
}
