import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maps_flutter/data_layer/repository/country_repository.dart';

import '../../../data_layer/models/country_model.dart';

part 'country_code_state.dart';

class CountryCodeCubit extends Cubit<CountryCodeState> {
  final CountryCodeRepository countryCodeRepository;
  CountryCodeCubit(this.countryCodeRepository) : super(CountryCodeInitial());

  void getCountriesCode() {
    emit(CountryCodeLoadingState());
    countryCodeRepository.getCountriesCode().then((value) {
      emit(CountryCodeLoadedState(countriesCode: value));
    }).catchError((error) {
      emit(CountryCodeErrorState(errorMsg: error.toString()));
      debugPrint(error.toString());
    });
  }
}
