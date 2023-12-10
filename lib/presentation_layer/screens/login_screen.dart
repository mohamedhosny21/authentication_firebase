import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maps_flutter/business_logic_layer/cubit/phone_auth/phone_auth_cubit.dart';
import 'package:maps_flutter/presentation_layer/widgets/button_widget.dart';
import 'package:maps_flutter/presentation_layer/widgets/country_code_drop_down_button_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
  }

  final TextEditingController phoneController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late String phoneNumber;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocListener<PhoneAuthCubit, PhoneAuthState>(
          listenWhen: (previous, current) {
            return previous != current;
          },
          listener: (context, state) {
            if (state is LoadingState) {
              const Center(
                  child: CircularProgressIndicator(
                color: Colors.black,
              ));
            } else if (state is PhoneNumberSubmittedState) {
              Navigator.pushNamed(context, '/otp_screen',
                  arguments: phoneNumber);
            } else if (state is ErrorOccuredState) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(state.errorMsg),
                duration: const Duration(seconds: 3),
              ));
            }
          },
          child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: _formKey,
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: 40.0, vertical: 50.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'What is your phone number ?',
                      style: TextStyle(
                          fontSize: 25.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 50.0,
                    ),
                    const Text(
                      'Please enter your phone number to verify your account',
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                    const SizedBox(
                      height: 100.0,
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Container(
                              padding:
                                  const EdgeInsetsDirectional.only(start: 5.0),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(6.0))),
                              child: const CountryCodeDropDownButton()),
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                          flex: 3,
                          child: Container(
                            padding:
                                const EdgeInsetsDirectional.only(start: 5.0),
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey,
                                ),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(6.0))),
                            child: TextFormField(
                              style: const TextStyle(letterSpacing: 5.0),
                              autofocus: true,
                              controller: phoneController,
                              cursorColor: Colors.black,
                              keyboardType: TextInputType.phone,
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Enter Your Phone Number',
                                  hintStyle: TextStyle(letterSpacing: 0.0)),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your phone number !';
                                } else if (value.length < 11) {
                                  return 'Number of Digits are too short !';
                                } else if (value.length > 11) {
                                  return 'Number of Digits are too long !';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                phoneNumber = value!;
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 70.0,
                    ),
                    BuildButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          BlocProvider.of<PhoneAuthCubit>(context)
                              .onPhoneNumberSubmit(phoneNumber);
                        } else {
                          return;
                        }
                      },
                      text: const Text(
                        'Next',
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                      ),
                      color: Colors.black,
                      width: 110,
                      height: 50,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
