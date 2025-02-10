/*
 * @ Author: Chung Nguyen Thanh <chunhthanhde.dev@gmail.com>
 * @ Created: 2024-12-22 09:33:20
 * @ Message: 🎯 Happy coding and Have a nice day! 🌤️
 */

import 'package:json_annotation/json_annotation.dart';

class StringAsDoubleConverter implements JsonConverter<double, Object> {
  const StringAsDoubleConverter();

  @override
  Object toJson(double object) {
    return object;
  }

  @override
  double fromJson(Object json) {
    if (json is String) {
      return double.parse(json);
    } else if (json is double) {
      return json;
    }

    throw Exception("Unable to parse $json to double");
  }
}
