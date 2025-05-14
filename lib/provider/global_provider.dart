
import 'package:beauty_center_frontend/provider/booking_provider.dart';
import 'package:beauty_center_frontend/provider/customer_provider.dart';
import 'package:beauty_center_frontend/provider/operator_provider.dart';
import 'package:beauty_center_frontend/provider/room_provider.dart';
import 'package:beauty_center_frontend/security/secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/SummaryOperatorDto.dart';
import '../model/enumerators/role.dart';
import 'service_provider.dart';

final appInitProvider = FutureProvider<void>((ref) async {
  await ref.read(serviceProvider.notifier).getAllServices();
  await ref.read(operatorProvider.notifier).getAllOperators();
  await ref.read(roomProvider.notifier).getAllRooms();
  await ref.read(customerProvider.notifier).getAllRooms();


  Role role = ref.read(operatorProvider).role;
  String? userId = await SecureStorage.getUserId();

  if(role == Role.ROLE_OPERATOR && userId != null) {
    await ref.read(operatorProvider.notifier).loadCurrentOperator(operatorId: userId);
    final currentOperator = ref.read(operatorProvider).currentOperator;
    if(currentOperator != null){
      ref.read(bookingProvider.notifier).updateSelectedOperator(
          operator: SummaryOperatorDto(
              id: currentOperator.id,
              name: currentOperator.name,
              surname: currentOperator.surname,
              imgUrl: currentOperator.imgUrl
          )
      );
    }
    ref.read(bookingProvider.notifier).getOperatorBookings(date: DateTime.now());
    // todo get schedule
  } else if(role == Role.ROLE_ADMIN) {
    final operators = ref.read(operatorProvider).operators;
    if (operators.isNotEmpty) {
      final operator = operators[0];
      ref.read(bookingProvider.notifier).updateSelectedOperator(
        operator: SummaryOperatorDto(
            id: operator.id,
            name: operator.name,
            surname: operator.surname,
            imgUrl: operator.imgUrl
        )
      );
      ref.read(bookingProvider.notifier).getOperatorBookings(date: DateTime.now());
    }

    // todo get schedule
  }
});