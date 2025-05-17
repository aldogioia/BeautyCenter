import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../api/customer_service.dart';
import '../model/customer_dto.dart';
import '../utils/strings.dart';

part 'customer_provider.g.dart';


class CustomerProviderData {
  final List<CustomerDto> customers;

  CustomerProviderData({List<CustomerDto>? customers}) : customers = customers ?? [];

  CustomerProviderData copyWith({List<CustomerDto>? customers}) {
    return CustomerProviderData(customers: customers ?? this.customers);
  }
}



@Riverpod(keepAlive: true)
class Customer extends _$Customer {
  final CustomerService _customerService = CustomerService();

  @override
  CustomerProviderData build(){
    return CustomerProviderData();
  }

  Future<String> getAllRooms() async {
    final response = await _customerService.getAllCustomers();
    if(response == null) return Strings.connection_error;
    if(response.statusCode == 200){
      state = state.copyWith(
          customers: (response.data as List).map((json) => CustomerDto.fromJson(json)).toList()
      );
      return "";
    }
    return (response.data as Map<String, dynamic>)['message'];
  }
  
  
  Future<String> updateCustomer({
    required String id,
    required String name,
    required String surname,
    required String phoneNumber
  }) async {
    final response = await _customerService.updateCustomer(
      id: id,
      name: name,
      surname: surname,
      phoneNumber: phoneNumber
    );

    if(response == null) return Strings.connection_error;
    if(response.statusCode == 204){
      state = state.copyWith(
        customers: state.customers.map((dto){
          if(dto.id == id) {
            return dto.copyWith(
              name: name,
              surname: surname,
              phoneNumber: phoneNumber
            );
          }
          return dto;
        }).toList()
      );
      return Strings.customer_updated_successfully;
    }
    return (response.data as Map<String, dynamic>)['message'];
  }

  void reset() {
    state = state.copyWith(customers: []);
  }
}