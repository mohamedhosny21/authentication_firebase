part of 'country_code_cubit.dart';

abstract class CountryCodeState {}

class CountryCodeInitial extends CountryCodeState {}

class CountryCodeLoadingState extends CountryCodeState {}

class CountryCodeLoadedState extends CountryCodeState {
  final List<CountryCodeModel> countriesCode;

  CountryCodeLoadedState({required this.countriesCode});
}

class CountryCodeErrorState extends CountryCodeState {
  final String errorMsg;

  CountryCodeErrorState({required this.errorMsg});
}
