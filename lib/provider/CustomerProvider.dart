import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../api/CustomerService.dart';
import '../model/CustomerDto.dart';
import '../model/UpdateCustomerDto.dart';
import '../utils/Strings.dart';

part 'CustomerProvider.g.dart';


class CustomerProviderData {
  final List<CustomerDto> customers;

  CustomerProviderData({List<CustomerDto>? customers}) : customers = customers ?? [];

  factory CustomerProviderData.empty() {
    return CustomerProviderData(
        customers: []
    );
  }

  CustomerProviderData copyWith({List<CustomerDto>? customers}) {
    return CustomerProviderData(customers: customers ?? this.customers);
  }
}



@riverpod
class Customer extends _$Customer {
  final CustomerService _customerService = CustomerService();

  @override
  CustomerProviderData build(){
    return CustomerProviderData.empty();
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
  
  
  Future<String> updateCustomer({required UpdateCustomerDto updateCustomerDto}) async {
    final response = await _customerService.updateCustomer(updateCustomerDto: updateCustomerDto);

    if(response == null) return Strings.connection_error;
    if(response.statusCode == 204){
      state = state.copyWith(
        customers: state.customers.map((dto){
          if(dto.id == updateCustomerDto.id) {
            return dto.copyWith(
              name: updateCustomerDto.name,
              surname: updateCustomerDto.surname,
              email: updateCustomerDto.email,
              phoneNumber: updateCustomerDto.phoneNumber
            );
          }
          return dto;
        }).toList()
      );
      return Strings.customer_updated_successfully;
    }
    return (response.data as Map<String, dynamic>)['message'];
  }
}