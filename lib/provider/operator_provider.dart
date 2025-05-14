import 'dart:core';
import 'dart:io';

import 'package:beauty_center_frontend/api/operator_service.dart';
import 'package:beauty_center_frontend/model/OperatorDto.dart';
import 'package:beauty_center_frontend/model/SummaryOperatorDto.dart';
import 'package:beauty_center_frontend/model/SummaryServiceDto.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/enumerators/role.dart';
import '../utils/strings.dart';

part 'operator_provider.g.dart';

class OperatorProviderData {
  final List<OperatorDto> operators;
  final List<TimeOfDay> availableTimes;

  final Role role;
  final OperatorDto? currentOperator;

  OperatorProviderData({
    List<OperatorDto>? operators,
    List<TimeOfDay>? availableTimes,
    Role? role,
    this.currentOperator,
  }) :  operators = operators ?? [],
        availableTimes = availableTimes ?? [],
        role = role ?? Role.EMPTY;



  OperatorProviderData copyWith({
    List<OperatorDto>? operators,
    List<TimeOfDay>? availableTimes,
    Role? role,
    OperatorDto? operator
  }) {
    return OperatorProviderData(
      operators: operators ?? this.operators,
      availableTimes: availableTimes ?? this.availableTimes,
      role: role ?? this.role,
      currentOperator: operator ?? currentOperator
    );
  }
}


@Riverpod(keepAlive: true)
class Operator extends _$Operator {
  final OperatorService _operatorService = OperatorService();

  @override
  OperatorProviderData build(){
    ref.keepAlive();
    return OperatorProviderData();
  }

  Future<String> getAllOperators() async {
    final response = await _operatorService.getAllOperators();
    if(response == null) return Strings.connection_error;
    if(response.statusCode == 200){
      state = state.copyWith(
          operators: (response.data as List).map((json) => OperatorDto.fromJson(json)).toList()
      );
      return "";
    }
    return (response.data as Map<String, dynamic>)['message'];
  }


  Future<String> updateOperator({
    required String id,
    required String name,
    required String surname,
    required String email,
    required List<SummaryServiceDto> services,
    required File? image
  }) async {
    final response = await _operatorService.updateOperator(
      id: id,
      name: name,
      surname: surname,
      email: email,
      image: image,
      services: services.map((e) => e.id).toList()
    );

    if(response == null) return Strings.connection_error;
    if(response.statusCode == 200){
      state = state.copyWith(
        operators: state.operators.map((e){
          if(e.id == id) {
            return e.copyWith(id: id, name: name, surname: surname, email: email, services: services, imgUrl: response.data);
          }
          return e;
        }).toList()
      );
      return Strings.operator_updated_successfully;
    }
    return (response.data as Map<String, dynamic>)['message'];
  }


  Future<MapEntry<bool,String>> createOperator({
    required String name,
    required String surname,
    required String email,
    required File? image,
    required List<SummaryServiceDto> services
  }) async {
    final response = await _operatorService.createOperator(
      name: name,
      surname: surname,
      email: email,
      image: image,
      services: services.map((e) => e.id).toList()
    );

    if(response == null) return MapEntry(false, Strings.connection_error);
    if(response.statusCode == 201){
      final List<OperatorDto> newList = List.from(state.operators);
      newList.add(OperatorDto.fromJson(response.data));

      state = state.copyWith(operators: newList);

      return MapEntry(true, Strings.operator_create_successfully);
    }
    return MapEntry(false, (response.data as Map<String, dynamic>)['message']);
  }


  Future<MapEntry<bool, String>> deleteOperator({required String operatorId}) async {
    final response = await _operatorService.deleteOperator(operatorId: operatorId);

    if(response == null) return MapEntry(false, Strings.connection_error);
    if(response.statusCode == 204){
      List<OperatorDto> newList = List.from(state.operators);
      newList.removeWhere((e) => e.id == operatorId);

      // todo bisogna rimuovere le prenotazioni con quell'operatore

      state = state.copyWith(
          operators: newList
      );
      return MapEntry(true, Strings.operator_delete_successfully);
    }
    return MapEntry(false, (response.data as Map<String, dynamic>)['message']);
  }


  Future<MapEntry<bool, String>> getAvailableHours({
    required String operatorId,
    required DateTime date,
    required String serviceId
  }) async {
    final response = await _operatorService.getAvailableHours(operatorId: operatorId, date: date, serviceId: serviceId);

    if(response == null) return MapEntry(false, Strings.connection_error);
    if(response.statusCode == 200){
      if (response.statusCode == 200 && response.data is List) {
        final List<String> stringTimes = List<String>.from(response.data);

        final times = stringTimes.map((str) {
          final parts = str.split(":");
          return TimeOfDay(
            hour: int.parse(parts[0]),
            minute: int.parse(parts[1]),
          );
        }).toList();

        state = state.copyWith(availableTimes: times);
        return MapEntry(true, "");
      }
      return MapEntry(true, "");
    }
    return MapEntry(false, (response.data as Map<String, dynamic>)['message']);
  }


  Future<MapEntry<List<SummaryOperatorDto>?, String>> getOperatorsByService({required String serviceId}) async {
    final response = await _operatorService.getOperatorsByService(serviceId: serviceId);

    if(response == null) return MapEntry(null, Strings.connection_error);
    if(response.statusCode == 200){
      List<SummaryOperatorDto> operatorsList = List.from(
          response.data.map((data) => SummaryOperatorDto.fromJson(data))
      );
      return MapEntry(
        operatorsList,
        ""
      );
    }
    return MapEntry(null, (response.data as Map<String, dynamic>)['message']);
  }


  Future<String> loadCurrentOperator({required String operatorId}) async {
    final response = await _operatorService.getOperator(operatorId: operatorId);

    if(response == null) return Strings.connection_error;
    if(response.statusCode == 200) {
      state = state.copyWith(operator: OperatorDto.fromJson(response.data));
      return "";
    }
    return (response.data as Map<String, dynamic>)['message'];
  }


  void removeServiceFromOperator({required String serviceId}) {
    state = state.copyWith(
        operators: state.operators.map((operator) {
          final removedServices = operator.services;
          removedServices.removeWhere((service) => service.id == serviceId);

          return operator.copyWith(services: removedServices);
        }).toList()
    );
  }

  void setAdminRole(String role) {
    state = state.copyWith(role: Role.ROLE_ADMIN);
  }

  void setOperatorRole(String role) {
    state = state.copyWith(role: Role.ROLE_OPERATOR);
  }

  void reset() {
    state = state.copyWith(
      operators: [],
      availableTimes: [],
      role: Role.EMPTY,
      operator: OperatorDto.empty()
    );
  }
}