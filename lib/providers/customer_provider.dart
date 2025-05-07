import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../api/customer_service.dart';
import '../model/customer_dto.dart';
import '../navigation/navigator.dart';
import '../utils/Strings.dart';
import '../utils/secure_storage.dart';

part 'customer_provider.g.dart';

class CustomerProviderState {
  CustomerDto customer;

  CustomerProviderState({
    CustomerDto? customer,
  }) : customer = customer ?? CustomerDto.empty();

  factory CustomerProviderState.empty() {
    return CustomerProviderState(
      customer: CustomerDto.empty(),
    );
  }

  CustomerProviderState copyWith({CustomerDto? customer}) {
    return CustomerProviderState(customer: customer ?? this.customer);
  }
}

@riverpod
class Customer extends _$Customer{
  final CustomerService _customerService = CustomerService();

  @override
  CustomerProviderState build() {
    ref.keepAlive();
    return CustomerProviderState.empty();
  }

  Future<String> getCustomer() async {
    final response = await _customerService.getCustomer();

    if (response == null) return Strings.connectionError;

    if (response.statusCode == 200) {
      state = state.copyWith(
        customer: CustomerDto.fromJson(response.data),
      );
      return "";
    }

    return (response.data as Map<String, dynamic>)['message'];
  }

  Future<String> updateCustomer({
    required String name,
    required String surname,
    required String phoneNumber,
    required String email,
  }) async {
    final response = await _customerService.updateCustomer(
      name: name,
      surname: surname,
      phoneNumber: phoneNumber,
      email: email,
    );

    if (response == null) return Strings.connectionError;

    if (response.statusCode == 204) {
      state = state.copyWith(
        customer: state.customer.copyWith(
          name: name,
          surname: surname,
          phoneNumber: phoneNumber,
          email: email,
        ),
      );
      return "";
    }

    return (response.data as Map<String, dynamic>)['message'];
  }

  Future<String> deleteCustomer() async {
    final response = await _customerService.deleteCustomer();

    if (response == null) return Strings.connectionError;

    if (response.statusCode == 204) {
      await SecureStorage.clearAll();
      NavigatorService.navigatorKey.currentState?.pushNamedAndRemoveUntil("/sign-in", (route) => false,);
      return "";
    }

    return (response.data as Map<String, dynamic>)['message'];
  }
}