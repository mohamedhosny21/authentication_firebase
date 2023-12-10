import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:maps_flutter/business_logic_layer/cubit/phone_auth/phone_auth_cubit.dart';
import 'package:maps_flutter/presentation_layer/widgets/build_loading_indicator_widget.dart';
import 'package:maps_flutter/presentation_layer/widgets/button_widget.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

// ignore: must_be_immutable
class OtpScreen extends StatelessWidget {
  final PhoneNumber phoneNumber;
  late String smsCode;
  OtpScreen({super.key, required this.phoneNumber});

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
            } else if (state is PhoneOtpVerifiedState) {
              Navigator.pushReplacementNamed(context, '/map_screen');
            } else if (state is ErrorOccuredState) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(state.errorMsg),
                duration: const Duration(seconds: 3),
              ));
              Navigator.pop(context);
            }
          },
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsetsDirectional.symmetric(
                  horizontal: 40.0, vertical: 50.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Verify your phone number ',
                    style: TextStyle(
                        fontSize: 25.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 50.0,
                  ),
                  RichText(
                    text: TextSpan(
                      text: 'Enter your 6 digits code numbers sent to',
                      style: const TextStyle(
                          fontSize: 25.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(
                            text: phoneNumber.completeNumber,
                            style: const TextStyle(
                                color: Colors.lightBlue, fontSize: 25.0))
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 50.0,
                  ),
                  buildPinCodeTextField(context),
                  const SizedBox(
                    height: 70.0,
                  ),
                  BuildButton(
                    onPressed: () {
                      showCircularProgressIndicator(context);
                      BlocProvider.of<PhoneAuthCubit>(context)
                          .onPhoneOtpSubmit(smsCode);
                    },
                    text: const Text(
                      'Verify',
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                    color: Colors.black,
                    width: 110,
                    height: 50,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildPinCodeTextField(BuildContext context) {
    return PinCodeTextField(
      appContext: context,
      length: 6,
      autoFocus: true,
      cursorColor: Colors.black,
      keyboardType: TextInputType.number,
      textStyle: const TextStyle(
        color: Colors.black,
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
      ),
      animationType: AnimationType.fade,
      pinTheme: PinTheme(
        activeColor: Colors.green,
        inactiveColor: Colors.red,
        activeFillColor: Colors.lightBlue,
        selectedColor: Colors.blue,
        borderRadius: BorderRadius.circular(6.0),
        fieldWidth: 40,
        fieldHeight: 50,
        shape: PinCodeFieldShape.box,
      ),
      onCompleted: (code) {
        smsCode = code;
        debugPrint(smsCode);
      },
    );
  }
}
