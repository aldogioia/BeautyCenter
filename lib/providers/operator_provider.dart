import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../api/operator_service.dart';
import '../model/operator_dto.dart';
import '../utils/Strings.dart';

part 'operator_provider.g.dart';


class OperatorProviderState {
  final List<OperatorDto> operators;
  final List<String> availableTimes;

  OperatorProviderState({
    List<OperatorDto>? operators, List<String>? availableTimes
  }) : operators = operators ?? [], availableTimes = availableTimes ?? [];

  factory OperatorProviderState.empty() {
    return OperatorProviderState(
      operators: [],
      availableTimes: []
    );
  }

  OperatorProviderState copyWith({List<OperatorDto>? operators, List<String>? availableTimes}) {
    return OperatorProviderState(operators: operators ?? this.operators, availableTimes: availableTimes ?? this.availableTimes);
  }
}


@riverpod
class Operator extends _$Operator {
  final OperatorService _operatorService = OperatorService();

  @override
  OperatorProviderState build(){
    ref.keepAlive();
    return OperatorProviderState.empty();
  }

  Future<String> getAllOperators(String serviceId) async {
    final response = await _operatorService.getAllOperators(serviceId);

    if (response == null) return Strings.connectionError;

    if (response.statusCode == 200) {

      if (response.data.isEmpty) return Strings.noOperators;

      state = state.copyWith(
        operators: (response.data as List).map((json) => OperatorDto.fromJson(json)).toList()
      );

      return "";
    }
    return (response.data as Map<String, dynamic>)['message'];
  }

  Future<String> getAvailableTimes({
    required String operatorId,
    required String serviceId,
    required DateTime date
  }) async {
    final formattedDate = DateFormat('yyyy-MM-dd').format(date);

    final response = await _operatorService.getAvailableTimes(operatorId, serviceId, formattedDate);

    if (response == null) {
      return Strings.connectionError;
    }

    if (response.statusCode == 200) {
      final data = response.data as List;

      if (data.isEmpty) {
        return Strings.noOperators;
      }

      state = state.copyWith(
        availableTimes: data.map((json) => json.toString()).toList(),
      );

      return "";
    }
    return (response.data as Map<String, dynamic>)['message'];
  }

  void clearTimes() {
    state = state.copyWith(
      availableTimes: []
    );
  }

  void reset() {
    state = state.copyWith(
      operators: [],
      availableTimes: []
    );
  }
}