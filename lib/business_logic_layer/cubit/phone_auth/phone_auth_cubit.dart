import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'phone_auth_state.dart';

class PhoneAuthCubit extends Cubit<PhoneAuthState> {
  late String verificationId;

  PhoneAuthCubit() : super(PhoneAuthInitial());

//function called when phone number is submitted
  Future<void> onPhoneNumberSubmit(String phoneNumber) async {
    emit(LoadingState());
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      //time taken to recieve sms message
      timeout: const Duration(seconds: 15),
      //When the SMS code is delivered to the device, Android will automatically verify the SMS code without requiring the user to manually input the code
      verificationCompleted: onVerificationCompleted,
      //If Firebase returns an error, for example for an incorrect phone number or if the SMS quota for the project has exceeded,
      verificationFailed: onVerificationFailed,
      //Handle when a code has been sent to the device from Firebase, used to prompt users to enter the code.
      codeSent: codeSent,
      //Handle a timeout of when automatic SMS code handling fails.
      // this handler will be called if the device has not automatically resolved an SMS message within a certain timeframe. Once the timeframe has passed, the device will no longer attempt to resolve any incoming messages.
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  void onVerificationCompleted(PhoneAuthCredential credential) async {
    debugPrint('Verification Completed !!');
    emit(PhoneNumberSubmittedState());
    signIn(credential);
  }

  void onVerificationFailed(FirebaseAuthException error) {
    debugPrint('Verification Failed : ${error.toString()}');
    emit(ErrorOccuredState(errorMsg: error.toString()));
  }

  void codeSent(String verificationId, int? resendToken) {
    this.verificationId = verificationId;
    debugPrint('verification ID : ${this.verificationId}');
    emit(PhoneNumberSubmittedState());

    //TODO: Make the possibilty to resend code
  }

  void codeAutoRetrievalTimeout(String verificationId) {
    debugPrint('codeAutoRetrievalTimeout !!');
  }

  void signIn(PhoneAuthCredential credential) async {
    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      emit(PhoneOtpVerifiedState());
    } catch (error) {
      debugPrint(error.toString());
      emit(ErrorOccuredState(errorMsg: error.toString()));
    }
  }

  //function called when code is submitted and entered manually by user

  Future<void> onPhoneOtpSubmit(String smsCode) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: smsCode);
    signIn(credential);
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  User getLoggedUser() {
    User firebaseUser = FirebaseAuth.instance.currentUser!;
    return firebaseUser;
  }
}
