import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:maps_flutter/constants/constants.dart';

class CountryCodeWebServices {
  late Dio dio;
  CountryCodeWebServices() {
    BaseOptions baseOptions = BaseOptions(
      baseUrl: ApiConstants.countryBaseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 25),
      receiveDataWhenStatusError: true,
    );
    dio = Dio(baseOptions);
  }

  Future<List<dynamic>> getCountriesCode() async {
    try {
      Response response = await dio.get(
          '75f6183458db8c453306f93521e93d37/raw/f77e7598a8503f1f70528ae1cbf9f66755698a16');
      debugPrint(response.data);
      //fix the error :type 'String' is not a subtype of type 'FutureOr<List<dynamic>>'
      //so this error caused because this method  is returning a String instead of a List<dynamic> as expected. This could be caused by the fact that the response.data property is returning a JSON string instead of a parsed JSON object.
      //so fix this by : final decodedData = jsonDecode(response.data);  return List<dynamic>.from(decodedData);
      //or by this code below
      final decodedData = jsonDecode(response.data);
      return decodedData;
    } catch (error) {
      debugPrint('Error Occured : ${error.toString()}');
      return [];
    }
  }
}
