import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../business_logic_layer/cubit/country_code/country_code_cubit.dart';
import '../../data_layer/models/country_model.dart';

class CountryCodeDropDownButton extends StatefulWidget {
  const CountryCodeDropDownButton({super.key});

  @override
  State<CountryCodeDropDownButton> createState() =>
      _CountryCodeDropDownButtonState();
}

class _CountryCodeDropDownButtonState extends State<CountryCodeDropDownButton> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<CountryCodeCubit>(context).getCountriesCode();
  }

  late List<CountryCodeModel> allCountriesCode;
  CountryCodeModel? buttonFormFieldValue;
  CountryCodeModel? _selectedValue;
  String? generateCountryFlag(CountryCodeModel? selectedValue) {
    String? countryCode = selectedValue?.code;

    final String? flag = countryCode?.toUpperCase().replaceAllMapped(
        RegExp(r'[A-Z]'),
        (match) => String.fromCharCode(match.group(0)!.codeUnitAt(0) + 127397));
    return flag;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CountryCodeCubit, CountryCodeState>(
      builder: (context, state) {
        if (state is CountryCodeLoadedState) {
          allCountriesCode = state.countriesCode;

          return DropdownButtonFormField(
            validator: (value) {
              if (value == null) {
                return 'Please select your country';
              }
              return null;
            },

            decoration: const InputDecoration(border: InputBorder.none),
            padding: const EdgeInsetsDirectional.fromSTEB(5.0, 5.0, 5.0, 8.0),
            menuMaxHeight: 200,
            hint: const Text(
              'Select your country',
              style: TextStyle(fontSize: 14.0, overflow: TextOverflow.visible),
            ),
            //i don't use value bec i use selectedItemBuilder
            // value: _selectedValue,
            dropdownColor: Colors.white,
            focusColor: Colors.grey,
            isExpanded: true,
            onSaved: (newValue) {
              buttonFormFieldValue = newValue;
            },
            selectedItemBuilder: (context) {
              return allCountriesCode
                  .map((countryCode) => DropdownMenuItem(
                          child: Text(
                        '${generateCountryFlag(_selectedValue)}'
                        '    '
                        '${countryCode.dialCode.toString()}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis),
                      )))
                  .toList();
            },
            items: allCountriesCode.map((countryCode) {
              return DropdownMenuItem<CountryCodeModel>(
                alignment: Alignment.centerLeft,
                value: countryCode,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      //this function take the object countryCode not _selectedValue bec when application started _selectedValue becomes null so a null flag will be created & when a new item is selected ,thr dropdowmmenuitem will show the same last flag created in all countries
                      '${generateCountryFlag(countryCode)}'
                      ' '
                      '${countryCode.name.toString()}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis),
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    Container(
                      color: Colors.grey,
                      height: 1.0,
                    )
                  ],
                ),
              );
            }).toList(),
            onChanged: (selectedValue) {
              setState(() {
                _selectedValue = (selectedValue);
                generateCountryFlag(selectedValue);
              });
            },
          );
        } else {
          return Container();
        }
      },
    );
  }
}
