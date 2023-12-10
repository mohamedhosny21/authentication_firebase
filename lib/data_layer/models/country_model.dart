class CountryCodeModel {
  final String? name;
  final String? dialCode;
  late final String code;

  CountryCodeModel({this.name, this.dialCode, required this.code});

  factory CountryCodeModel.fromJson(Map<String, dynamic> json) {
    return CountryCodeModel(
      name: json['name'],
      dialCode: json['dial_code'],
      code: json['code'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['dial_code'] = dialCode;
    data['code'] = code;
    return data;
  }
}
