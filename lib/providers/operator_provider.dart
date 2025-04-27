import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../api/operator_service.dart';
import '../model/OperatorDto.dart';
import '../utils/Strings.dart';

part 'operator_provider.g.dart';


class OperatorProviderState {
  final List<OperatorDto> operators;
  final List<DateTime> availableTimes;

  OperatorProviderState({
    List<OperatorDto>? operators, List<DateTime>? availableTimes
  }) : operators = operators ?? [], availableTimes = availableTimes ?? [];

  factory OperatorProviderState.empty() {
    return OperatorProviderState(
      operators: [],
      availableTimes: []
    );
  }

  OperatorProviderState copyWith({List<OperatorDto>? operators, List<DateTime>? availableTimes}) {
    return OperatorProviderState(operators: operators ?? operators, availableTimes: availableTimes ?? this.availableTimes);
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
    final response = await _operatorService.getAvailableTimes(operatorId, serviceId, date);

    if (response == null) {
      return Strings.connectionError;
    }

    if (response.statusCode == 200) {
      final data = response.data as List;

      if (data.isEmpty) {
        return Strings.noOperators;
      }

      List<DateTime> availableTimesList = data.map((json) => DateTime.parse(json)).toList();

      state = state.copyWith(
        availableTimes: availableTimesList,
      );

      return "";
    }
    return (response.data as Map<String, dynamic>)['message'];
  }
}