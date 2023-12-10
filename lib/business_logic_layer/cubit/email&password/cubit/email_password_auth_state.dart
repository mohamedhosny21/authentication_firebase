part of 'email_password_auth_cubit.dart';

sealed class EmailPasswordAuthState {}

final class EmailPasswordAuthInitial extends EmailPasswordAuthState {}

class LoadingState extends EmailPasswordAuthState {}

class OnCreateAccountSuccessState extends EmailPasswordAuthState {}

class OnCreateAccountFailedState extends EmailPasswordAuthState {
  final String errorMsg;

  OnCreateAccountFailedState({required this.errorMsg});
}

class LoginAccountSuccessState extends EmailPasswordAuthState {}

class LoginAccountFailedState extends EmailPasswordAuthState {
  final String errorMsg;

  LoginAccountFailedState({required this.errorMsg});
}

class ResetPasswordSuccessState extends EmailPasswordAuthState {}

class ResetPasswordFailedState extends EmailPasswordAuthState {
  final String errorMsg;

  ResetPasswordFailedState({required this.errorMsg});
}

class EmailVerifiedState extends EmailPasswordAuthState {}

class EmailNotVerifiedState extends EmailPasswordAuthState {}

class LoginVerificationEmailSentSuccess extends EmailPasswordAuthState {
  final String successMsg;

  LoginVerificationEmailSentSuccess({required this.successMsg});
}

class LoginVerificationEmailSentFailed extends EmailPasswordAuthState {
  final String errorMsg;

  LoginVerificationEmailSentFailed({required this.errorMsg});
}

class SignInWithProviderSuccess extends EmailPasswordAuthState {}

class SignInWithProviderFailed extends EmailPasswordAuthState {
  final String errorMsg;

  SignInWithProviderFailed({required this.errorMsg});
}
