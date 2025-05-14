import 'dart:io';

import 'package:beauty_center_frontend/api/service_service.dart';
import 'package:beauty_center_frontend/provider/operator_provider.dart';
import 'package:beauty_center_frontend/provider/room_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/ServiceDto.dart';
import '../utils/strings.dart';

part 'service_provider.g.dart';


class ServiceProviderData {
  final List<ServiceDto> services;

  ServiceProviderData({List<ServiceDto>? services}) : services = services ?? [];


  ServiceProviderData copyWith({List<ServiceDto>? services}) {
    return ServiceProviderData(services: services ?? this.services);
  }
}


@Riverpod(keepAlive: true)
class Service extends _$Service {
  final ServiceService _serviceService = ServiceService();

  @override
  ServiceProviderData build(){
    ref.keepAlive();
    return ServiceProviderData();
  }

  Future<String> getAllServices() async {
    final response = await _serviceService.getAllServices();
    if(response == null) return Strings.connection_error;
    if(response.statusCode == 200){
      state = state.copyWith(
        services: (response.data as List).map((json) => ServiceDto.fromJson(json)).toList()
      );
      return "";
    }
    return (response.data as Map<String, dynamic>)['message'];
  }


  Future<String> updateService({
    required String id,
    required String name,
    required int duration,
    required double price,
    required File? image
  }) async {
    final response =  await _serviceService.updateService(id: id, name: name, price: price, duration: duration, image: image);

    if(response == null) return Strings.connection_error;
    if(response.statusCode == 200) {
      state = state.copyWith(
          services: state.services.map((e) {
            if(e.id == id) {
              return e.copyWith(
                name: name,
                price: price,
                duration: duration,
                imgUrl: response.data
              );
            }
            return e;
          }).toList()
      );
      return Strings.service_updated_successfully;
    }
    return (response.data as Map<String, dynamic>)['message'];
  }


  Future<MapEntry<bool,String>> createService({
    required String name,
    required double price,
    required int duration,
    required File? image
  }) async {
    final response = await _serviceService.createService(name: name, price: price, duration: duration, image: image);

    if(response == null) return MapEntry(false, Strings.connection_error);
    if(response.statusCode == 201){
      final List<ServiceDto> newList = List.from(state.services);
      newList.add(ServiceDto.fromJson(response.data));

      state = state.copyWith(services: newList);

      return MapEntry(true, Strings.service_create_successfully);
    }
    return MapEntry(false, (response.data as Map<String, dynamic>)['message']);
  }


  Future<MapEntry<bool, String>> deleteService({required String serviceId}) async {
    final response = await _serviceService.deleteService(serviceId: serviceId);

    if(response == null) return MapEntry(false, Strings.connection_error);
    if(response.statusCode == 204){
      List<ServiceDto> newList = List.from(state.services);
      newList.removeWhere((e) => e.id == serviceId);

      // todo rimuovere i booking con il servizio eliminato

      state = state.copyWith(services: newList);
      ref.read(roomProvider.notifier).removeServiceFromRoom(serviceId: serviceId);
      ref.read(operatorProvider.notifier).removeServiceFromOperator(serviceId: serviceId);
      return MapEntry(true, Strings.service_delete_successfully);
    }
    return MapEntry(false, (response.data as Map<String, dynamic>)['message']);
  }


  void reset() {
    state = state.copyWith(services: []);
  }
}