import 'package:edone_customer/model/service_dto.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../api/service_service.dart';
import '../utils/Strings.dart';

part 'service_provider.g.dart';

class ServiceProviderState{
  List<ServiceDto> services;

  ServiceProviderState({
    List<ServiceDto>? services
  }) : services = services ?? [];

  factory ServiceProviderState.empty() {
    return ServiceProviderState(
      services: []
    );
  }

  ServiceProviderState copyWith({List<ServiceDto>? services}) {
    return ServiceProviderState(services: services ?? this.services);
  }
}

@riverpod
class Service extends _$Service {
  final ServiceService _serviceService = ServiceService();

  @override
  ServiceProviderState build(){
    ref.keepAlive();
    return ServiceProviderState.empty();
  }

  Future<String> getAllServices() async {
    final response = await _serviceService.getAllServices();

    if(response == null) return Strings.connectionError;

    if(response.statusCode == 200){
      if(response.data.isEmpty) return Strings.noServices;

      state = state.copyWith(
        services: (response.data as List).map((json) => ServiceDto.fromJson(json)).toList()
      );
      return "";
    }
    return (response.data as Map<String, dynamic>)['message'];
  }
}
