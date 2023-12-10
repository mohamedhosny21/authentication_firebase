import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maps_flutter/business_logic_layer/cubit/email&password/cubit/email_password_auth_cubit.dart';
import 'package:maps_flutter/presentation_layer/widgets/button_widget.dart';
import 'package:maps_flutter/presentation_layer/widgets/textformfield_widget.dart';

// ignore: must_be_immutable
class ResetPassword extends StatelessWidget {
  ResetPassword({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey();

  late String _email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
      ),
      body: Form(
          key: _formKey,
          child: Container(
            padding: const EdgeInsetsDirectional.all(20.0),
            margin: const EdgeInsetsDirectional.all(20.0),
            child: BlocListener<EmailPasswordAuthCubit, EmailPasswordAuthState>(
              listenWhen: (previous, current) {
                return previous != current;
              },
              listener: (context, state) {
                if (state is ResetPasswordSuccessState) {
                  AwesomeDialog(
                          context: context,
                          title: 'Link has been sent successfully',
                          btnOkOnPress: () {
                            Navigator.pushReplacementNamed(
                                context, '/login_screen_email_password');
                          },
                          dialogType: DialogType.success,
                          desc:
                              'Link has been sent to $_email , Please check your email inbox to reset password !')
                      .show();
                } else if (state is ResetPasswordFailedState) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(state.errorMsg)));
                }
              },
              child: ListView(
                children: [
                  const Text(
                    'Please Enter Your Email To Reset Your Password',
                    style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0),
                  ),
                  const SizedBox(
                    height: 50.0,
                  ),
                  buildTextFormField(
                    textInputType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'This field is required !';
                      } else {
                        return null;
                      }
                    },
                    label: const Text('Please Enter your Email'),
                    prefixIcon: Icons.email,
                    hintText: 'Example@gmail.com',
                    onSaved: (value) {
                      _email = value!;
                    },
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  BuildButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          BlocProvider.of<EmailPasswordAuthCubit>(context)
                              .resetPassword(_email);
                        } else {
                          return;
                        }
                      },
                      text: const Text('Submit'),
                      color: Colors.blue)
                ],
              ),
            ),
          )),
    );
  }
}
