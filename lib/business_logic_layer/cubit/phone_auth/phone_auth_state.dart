part of 'phone_auth_cubit.dart';

@immutable
abstract class PhoneAuthState {}

class PhoneAuthInitial extends PhoneAuthState {}

class LoadingState extends PhoneAuthState {}

class ErrorOccuredState extends PhoneAuthState {
  final String errorMsg;

  ErrorOccuredState({required this.errorMsg});
}

class PhoneNumberSubmittedState extends PhoneAuthState {}

class PhoneOtpVerifiedState extends PhoneAuthState {}
