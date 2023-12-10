import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maps_flutter/business_logic_layer/cubit/email&password/cubit/email_password_auth_cubit.dart';
import 'package:maps_flutter/presentation_layer/widgets/build_loading_indicator_widget.dart';
import 'package:maps_flutter/presentation_layer/widgets/button_widget.dart';
import 'package:maps_flutter/presentation_layer/widgets/password_textfield_widget.dart';
import 'package:maps_flutter/presentation_layer/widgets/textformfield_widget.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({
    super.key,
  });

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _fullNameController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late String fullName;

  late String email;
  double _strength = 0;
  late String _password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('SignUp Screen'),
        ),
        body: SafeArea(
          child: BlocListener<EmailPasswordAuthCubit, EmailPasswordAuthState>(
            listenWhen: (previous, current) {
              return previous != current;
            },
            listener: (context, state) {
              if (state is LoadingState) {
                showCircularProgressIndicator(context);
              } else if (state is OnCreateAccountFailedState) {
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
              } else if (state is OnCreateAccountSuccessState) {
                Navigator.pop(context);
                AwesomeDialog(
                  context: context,
                  title: 'Sign Up Success',
                  dialogType: DialogType.success,
                  desc:
                      'A verification email has been sent to $email , please check your inbox to verify your account !',
                  btnOkOnPress: () {
                    Navigator.pushReplacementNamed(
                        context, '/login_screen_email_password');
                  },
                ).show();
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
                        'Please Sign Up To Create Your Account',
                        style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      buildTextFormField(
                          textEditingController: _fullNameController,
                          textInputType: TextInputType.name,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'This field is required';
                            }
                            return null;
                          },
                          autoFocus: true,
                          onSaved: (fullnameValue) {
                            fullName = fullnameValue!;
                          },
                          label: const Text(
                            'Please Enter Your Full Name',
                            style: TextStyle(fontSize: 15),
                          ),
                          prefixIcon: Icons.person),
                      const SizedBox(
                        height: 20.0,
                      ),
                      buildTextFormField(
                          textEditingController: _emailController,
                          textInputType: TextInputType.emailAddress,
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
                        height: 20.0,
                      ),
                      BuildPasswordFormFieldWithChecker(
                        //the value of the updated strength in  BuildPasswordFormFieldWithChecker widget will be assign to _strength
                        onStrengthChanged: (strength) {
                          setState(() {
                            _strength = strength;
                          });
                        },
                        getPassword: (password) {
                          setState(() {
                            _password = password;
                          });
                        },
                      ),
                      Center(
                        child: BuildButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate() &&
                                _strength >= 0.5) {
                              _formKey.currentState!.save();
                              BlocProvider.of<EmailPasswordAuthCubit>(context)
                                  .signUpUserAccount(
                                      email, _password, fullName);
                            }
                          },
                          text: const Text('Sign Up'),
                          color: Colors.blue,
                          width: 200.0,
                          height: 50.0,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Already have an account ?',
                            style: TextStyle(color: Colors.grey),
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                    context, '/login_screen_email_password');
                              },
                              child: const Text(
                                'Login',
                              ))
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
