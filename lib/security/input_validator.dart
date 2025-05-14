
import 'package:beauty_center_frontend/utils/strings.dart';
import 'package:flutter/material.dart';

class InputValidator {
  static String? _validateServiceOrRoomName(String? value, String errorText) {
    if (value == null || value.isEmpty || value.length > 50) {
      return errorText;
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty ||
        !RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(
            value)) {
      return Strings.insert_a_valid_email_address_error;
    }
    return null;
  }



  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty || !RegExp(r'^(?=.*\d).{8,}$').hasMatch(value)) {
      return Strings.invalid_password_error;
    }
    return null;
  }


  // customer

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty ||
        !RegExp(r'^\d{10}$').hasMatch(value)) {
      return Strings.invalid_phone_number_error;
    }
    return null;
  }


  // service

  static String? validateServiceName(String? value) => _validateServiceOrRoomName(value, Strings.invalid_service_name);

  static String? validateServiceDuration(String? value) {
    if (value == null || value.isEmpty || !RegExp(r'^\d+$').hasMatch(value)) {
      return Strings.invalid_duration;
    }

    int? duration = int.tryParse(value);
    if (duration == null || duration <= 1) {
      return Strings.invalid_duration;
    }

    return null;
  }

  static String? validateServicePrice(String? value) {
    if (value == null || value.isEmpty || !RegExp(r'^\d+(\.\d+)?$').hasMatch(value)) {
      return Strings.invalid_price;
    }

    double? price = double.tryParse(value);

    if (price == null || price <= 1) {
      return Strings.invalid_price;
    }

    return null;
  }


  // room

  static String? validateRoomName(String? value) => _validateServiceOrRoomName(value, Strings.invalid_room_name);


  // users

  static String? _validateNameOrSurname(String? value, String errorText) {
    if (value == null || value.length < 3 || value.length > 50) {
      return errorText;
    }
    return null;
  }

  static String? validateName(String? value) => _validateNameOrSurname(value, Strings.invalid_name);

  static String? validateSurname(String? value) => _validateNameOrSurname(value, Strings.invalid_surname);

  static String? validateResetPasswordCode(String? value) {
    if (value == null || value.isEmpty || !RegExp(r'^\d{5}$').hasMatch(value)) {
      return Strings.code_verify_validation_error;
    }
    return null;
  }

  static bool validateStartAndEndScheduleTime({required TimeOfDay? start, required TimeOfDay? end}) {
    if (start == null && end == null) return true;
    if (start != null && end != null) return !start.isAfter(end);
    return false;
  }
}