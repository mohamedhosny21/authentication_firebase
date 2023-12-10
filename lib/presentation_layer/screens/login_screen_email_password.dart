import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:awesome_icons/awesome_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maps_flutter/business_logic_layer/cubit/email&password/cubit/email_password_auth_cubit.dart';
import 'package:maps_flutter/presentation_layer/widgets/build_loading_indicator_widget.dart';
import 'package:maps_flutter/presentation_layer/widgets/signin_providers_button_widget.dart';

import '../widgets/button_widget.dart';
import '../widgets/textformfield_widget.dart';

class LoginWithEmailAndPasswordScreen extends StatefulWidget {
  const LoginWithEmailAndPasswordScreen({super.key});

  @override
  State<LoginWithEmailAndPasswordScreen> createState() =>
      _LoginWithEmailAndPasswordScreenState();
}

class _LoginWithEmailAndPasswordScreenState
    extends State<LoginWithEmailAndPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late String email;

  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Screen'),
      ),
      body: SafeArea(
          child: BlocListener<EmailPasswordAuthCubit, EmailPasswordAuthState>(
        listenWhen: (previous, current) {
          return previous != current;
        },
        listener: (context, state) {
          if (state is LoadingState) {
            showCircularProgressIndicator(context);
          } else if (state is EmailNotVerifiedState) {
            AwesomeDialog(
                    context: context,
                    dialogType: DialogType.warning,
                    title: 'Your account isn\'t verified yet',
                    desc: 'Please verify your account to login',
                    descTextStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    btnOkText: 'Send Email Verification',
                    btnOkOnPress: () {
                      BlocProvider.of<EmailPasswordAuthCubit>(context)
                          .sendEmailVerification(
                              email, _passwordController.text);
                    },
                    showCloseIcon: true)
                .show();
          } else if (state is LoginAccountFailedState) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error,
                  color: Colors.red,
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Text(
                  state.errorMsg,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            )));
          } else if (state is LoginAccountSuccessState) {
            Navigator.pop(context);
            Navigator.pushNamedAndRemoveUntil(
                context, '/map_screen', (route) => false);
          } else if (state is LoginVerificationEmailSentSuccess) {
            AwesomeDialog(
                    context: context,
                    desc: state.successMsg,
                    descTextStyle: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16.0),
                    dialogType: DialogType.success,
                    btnOkOnPress: () {
                      Navigator.pushReplacementNamed(
                          context, '/login_screen_email_password');
                    },
                    showCloseIcon: true)
                .show();
          } else if (state is LoginVerificationEmailSentFailed) {
            AwesomeDialog(
                    context: context,
                    desc: state.errorMsg,
                    descTextStyle: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16.0),
                    dialogType: DialogType.error,
                    btnCancelOnPress: () {},
                    showCloseIcon: true)
                .show();
          } else if (state is SignInWithProviderSuccess) {
            Navigator.pushReplacementNamed(context, '/map_screen');
          } else if (state is SignInWithProviderFailed) {
            Navigator.maybePop(context);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error,
                  color: Colors.red,
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Text(
                  state.errorMsg,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            )));
          }
        },
        child: Container(
          padding: const EdgeInsetsDirectional.all(20.0),
          margin: const EdgeInsetsDirectional.all(20.0),
          child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Text(
                    'Please Login if you have an account !',
                    style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 25.0),
                  ),
                  const SizedBox(
                    height: 40.0,
                  ),
                  buildTextFormField(
                      textEditingController: _emailController,
                      textInputType: TextInputType.emailAddress,
                      autoFocus: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'This field is required';
                        }
                        return null;
                      },
                      onSaved: (emailValue) {
                        email = emailValue!;
                      },
                      label: const Text(
                        'Please Enter Your Email',
                        style: TextStyle(fontSize: 15),
                      ),
                      hintText: 'Example@gmail.com',
                      prefixIcon: Icons.email),
                  const SizedBox(
                    height: 30.0,
                  ),
                  buildTextFormField(
                    textEditingController: _passwordController,
                    textInputType: TextInputType.visiblePassword,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'This field is required';
                      }
                      return null;
                    },
                    label: const Text(
                      'Please Enter Your Password',
                      style: TextStyle(fontSize: 15),
                    ),
                    prefixIcon: Icons.lock,
                    suffixIcon:
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                    obscureText: _obscureText,
                    suffixPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/reset_password');
                      },
                      child: const Text(
                        'forgot password ?',
                        textAlign: TextAlign.start,
                      )),
                  Center(
                    child: BuildButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          BlocProvider.of<EmailPasswordAuthCubit>(context)
                              .signInUserAccount(
                                  email, _passwordController.text);
                        }
                      },
                      text: const Text('Login'),
                      color: Colors.blue,
                      width: 200.0,
                      height: 50.0,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Have no account yet ?',
                        style: TextStyle(color: Colors.grey),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, '/signup_screen');
                          },
                          child: const Text(
                            'Sign Up',
                          ))
                    ],
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  buildSignInButtonProvider(
                    color: Colors.red,
                    textStyleColor: Colors.black,
                    icon: FontAwesomeIcons.google,
                    text: 'Sign In with Google',
                    onTap: () {
                      BlocProvider.of<EmailPasswordAuthCubit>(context)
                          .signInWithGoogle();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      )),
    );
  }
}
