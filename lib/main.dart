import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maps_flutter/app_router.dart';
import 'package:maps_flutter/business_logic_layer/cubit/country_code/country_code_cubit.dart';
import 'package:maps_flutter/business_logic_layer/cubit/email&password/cubit/email_password_auth_cubit.dart';
import 'package:maps_flutter/business_logic_layer/cubit/phone_auth/phone_auth_cubit.dart';
import 'package:maps_flutter/data_layer/repository/country_repository.dart';
import 'package:maps_flutter/data_layer/webservices/country_webservices.dart';

late String initialRoute;
void main() async {
  //to ensure that firebase is dealing with flutter native code
  WidgetsFlutterBinding.ensureInitialized();
  //initializing firebase to help us in using its services like : auth,storage, others
  await Firebase.initializeApp();

  //check if the user logged in or logged out
  FirebaseAuth.instance.authStateChanges().listen((userState) {
    if (userState == null) {
      initialRoute = '/login_screen_email_password';
    } else {
      initialRoute = '/map_screen';
    }
  });
  runApp(MyApp(
    appRouter: AppRouter(),
  ));
}

class MyApp extends StatelessWidget {
  final AppRouter appRouter;
  final CountryCodeRepository countryCodeRepository =
      CountryCodeRepository(CountryCodeWebServices());
  MyApp({super.key, required this.appRouter});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => PhoneAuthCubit(),
        ),
        BlocProvider(
          create: (context) => CountryCodeCubit(countryCodeRepository),
        ),
        BlocProvider(create: (context) => EmailPasswordAuthCubit())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: initialRoute,
        onGenerateRoute: appRouter.generateRoute,
      ),
    );
  }
}
