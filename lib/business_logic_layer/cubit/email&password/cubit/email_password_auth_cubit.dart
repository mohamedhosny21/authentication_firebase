import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

part 'email_password_auth_state.dart';

class EmailPasswordAuthCubit extends Cubit<EmailPasswordAuthState> {
  EmailPasswordAuthCubit() : super(EmailPasswordAuthInitial());

  Future<void> signUpUserAccount(
      String email, String password, String fullName) async {
    emit(LoadingState());
    try {
      FirebaseApp tempApp = await Firebase.initializeApp(
          name: 'temporaryregister', options: Firebase.app().options);
      final UserCredential credential = await FirebaseAuth.instanceFor(
              app:
                  tempApp) //used instance for to make the user not logged in when the account is created
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      //send email verification
      await credential.user?.sendEmailVerification();

      emit(OnCreateAccountSuccessState());
      debugPrint('$credential');

      await credential.user!.updateDisplayName(fullName);
    }
    //handle the specified errors

    on FirebaseAuthException catch (error) {
      if (error.code == 'weak-password') {
        emit(OnCreateAccountFailedState(
            errorMsg: 'Error : The Password is too weak'));

        debugPrint('Error : The Password is too weak');
      } else if (error.code == 'email-already-in-use') {
        emit(OnCreateAccountFailedState(
            errorMsg: 'Error : The Account already exists for that email'));

        debugPrint('Error : The Account already exists for that email');
      }
    } //any other errors different from the specified above
    catch (e) {
      debugPrint('Error : ${e.toString()}');
      emit(OnCreateAccountFailedState(errorMsg: e.toString()));
    }
  }

  void signInUserAccount(String email, String password) async {
    emit(LoadingState());
    try {
      final UserCredential credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (credential.user != null) {
        if (credential.user!.emailVerified == true) {
          emit(EmailVerifiedState());
          Timer(const Duration(seconds: 1), () {
            emit(LoginAccountSuccessState());
          });
          debugPrint('$credential');
        } else {
          emit(LoginAccountFailedState(
              errorMsg: 'Your account isn\'t verified yet ! '));
          Timer(const Duration(seconds: 1), () {
            emit(EmailNotVerifiedState());
          });

          signOut();
        }
      }
    } //handle the specified errors
    on FirebaseAuthException catch (error) {
      if (error.code == 'user-not-found') {
        emit(LoginAccountFailedState(
            errorMsg: 'Error : No User found for that email'));
        debugPrint('No User found for that email');
      } else if (error.code == 'wrong-password') {
        emit(LoginAccountFailedState(
            errorMsg: 'Error : Wrong password provided for that user.'));
        debugPrint('Wrong password provided for that user.');
      }
    } catch (e) {
      debugPrint(e.toString());
      emit(LoginAccountFailedState(errorMsg: e.toString()));
    }
  }

  void signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  User getLloggedUser() {
    User firebaseUser = FirebaseAuth.instance.currentUser!;
    return firebaseUser;
  }

  void resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      emit(ResetPasswordSuccessState());
    } on FirebaseException catch (error) {
      emit(ResetPasswordFailedState(errorMsg: error.toString()));

      debugPrint(error.toString());
    } catch (e) {
      emit(ResetPasswordFailedState(errorMsg: 'Error Something Wrong'));
      debugPrint(e.toString());
    }
  }

  void sendEmailVerification(String email, String password) async {
    final UserCredential user = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    try {
      user.user?.sendEmailVerification();
      if (user.user?.sendEmailVerification() != null) {
        emit(LoginVerificationEmailSentSuccess(
            successMsg:
                'A verification email has been sent to $email successfully'));

        debugPrint('A verification email has been sent to $email successfully');
      } else {
        emit(LoginVerificationEmailSentFailed(
            errorMsg: 'No verification email sent !!'));
        debugPrint('No verification email sent !!');
      }
    } catch (error) {
      emit(LoginVerificationEmailSentFailed(
          errorMsg: 'Error sending email verification: ${error.toString()}'));
      debugPrint('Error sending email verification: ${error.toString()}');
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      emit(LoadingState());
      await GoogleSignIn()
          .signOut(); // Sign out the current user (if any) before signing in with a new account
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      //obtain auth details from the request(email , password)
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      //create an new credential for the user(as we signup it creates a new credential)
      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);
      debugPrint('$credential');
      emit(SignInWithProviderSuccess());
      //once the user signed in return his credential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (error) {
      debugPrint(error.toString());
      emit(SignInWithProviderFailed(errorMsg: 'Error : Sign in Failed!'));
      return null;
    }
  }
}
