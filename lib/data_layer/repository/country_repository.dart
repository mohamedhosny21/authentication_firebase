import 'package:maps_flutter/data_layer/models/country_model.dart';
import 'package:maps_flutter/data_layer/webservices/country_webservices.dart';

class CountryCodeRepository {
  final CountryCodeWebServices countryCodeWebServices;

  CountryCodeRepository(this.countryCodeWebServices);

  Future<List<CountryCodeModel>> getCountriesCode() async {
    final countriesCode = await countryCodeWebServices.getCountriesCode();

    return countriesCode
        .map((countrycode) => CountryCodeModel.fromJson(countrycode))
        .toList();
  }
}
