import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:maps_flutter/presentation_layer/widgets/build_loading_indicator_widget.dart';

import '../../business_logic_layer/cubit/phone_auth/phone_auth_cubit.dart';
import '../widgets/button_widget.dart';

// ignore: must_be_immutable
class LoginScreenPhoneAuth extends StatelessWidget {
  LoginScreenPhoneAuth({super.key});

  final TextEditingController phoneController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late PhoneNumber phoneNumber;

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
              Navigator.pop(context);
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
                      IntlPhoneField(
                        autofocus: true,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter your Phone Number',
                            hintStyle: TextStyle(letterSpacing: 0.0)),
                        initialCountryCode: 'EG',
                        keyboardType: TextInputType.phone,
                        onSaved: (newValue) {
                          phoneNumber = newValue!;
                        },
                        style: const TextStyle(letterSpacing: 3.0),
                      ),
                      BuildButton(
                        onPressed: () {
                          showCircularProgressIndicator(context);

                          //to save the current state
                          _formKey.currentState!.save();
                          BlocProvider.of<PhoneAuthCubit>(context)
                              .onPhoneNumberSubmit(phoneNumber.completeNumber);
                        },
                        text: const Text(
                          'Next',
                          style: TextStyle(color: Colors.white, fontSize: 20.0),
                        ),
                        color: Colors.black,
                        width: 110,
                        height: 50,
                      )
                    ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
