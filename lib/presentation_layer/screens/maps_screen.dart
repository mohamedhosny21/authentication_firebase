import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maps_flutter/business_logic_layer/cubit/phone_auth/phone_auth_cubit.dart';

class MapsScreen extends StatelessWidget {
  const MapsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            BlocProvider.of<PhoneAuthCubit>(context).signOut();
            Navigator.pushNamedAndRemoveUntil(
                context, '/login_screen_email_password', (route) => false);
          },
          child: const Text('LogOut'),
        ),
      ),
    );
  }
}
