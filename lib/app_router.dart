import 'package:flutter/material.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:maps_flutter/presentation_layer/screens/login_screen.dart';
import 'package:maps_flutter/presentation_layer/screens/login_screen_email_password.dart';
import 'package:maps_flutter/presentation_layer/screens/login_screen_phone_auth.dart';
import 'package:maps_flutter/presentation_layer/screens/maps_screen.dart';
import 'package:maps_flutter/presentation_layer/screens/otp_screen.dart';
import 'package:maps_flutter/presentation_layer/screens/reset_password_screen.dart';
import 'package:maps_flutter/presentation_layer/screens/signup_screen_email_password.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/login_screen':
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case '/login_screen_phone_auth':
        return MaterialPageRoute(builder: (_) => LoginScreenPhoneAuth());

      case '/login_screen_email_password':
        return MaterialPageRoute(
            builder: (_) => const LoginWithEmailAndPasswordScreen());

      case '/signup_screen':
        return MaterialPageRoute(builder: (_) => const SignupScreen());

      case '/reset_password':
        return MaterialPageRoute(builder: (_) => ResetPassword());

      case '/otp_screen':
        final phoneNumber = settings.arguments as PhoneNumber;
        return MaterialPageRoute(
            builder: (_) => OtpScreen(
                  phoneNumber: phoneNumber,
                ));

      case '/map_screen':
        return MaterialPageRoute(builder: (_) => const MapsScreen());
    }
    return null;
  }
}
