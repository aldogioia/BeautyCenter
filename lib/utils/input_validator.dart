import '../utils/strings.dart';

class InputValidator {

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty ||
        !RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(
            value)) {
      return Strings.invalidEmail;
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty ||
        !RegExp(r'^(?=.*\d).{8,}$').hasMatch(
            value)) {
      return Strings.invalidPassword;
    }
    return null;
  }

  static String? validateToken(String? value) {
    if (value == null || value.isEmpty ||
        !RegExp(r'^\d{5}$').hasMatch(
            value)) {
      return "Il token è composto da 5 numeri"; //todo Strings.invalidToken
    }
    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty ||
        !RegExp(r'^\d{10}$').hasMatch(value)) {
      return Strings.invalidNumber;
    }
    return null;
  }

  static String? _validateNameOrSurname(String? value, String errorText) {
    if (value == null || value.length < 3 || value.length > 50) {
      return errorText;
    }
    return null;
  }

  static String? validateName(String? value) => _validateNameOrSurname(value, Strings.invalidName);

  static String? validateSurname(String? value) => _validateNameOrSurname(value, Strings.invalidSurname);
}