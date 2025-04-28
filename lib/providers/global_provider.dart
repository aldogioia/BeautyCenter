import 'package:edone_customer/providers/service_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'booking_provider.dart';

final appInitProvider = FutureProvider<void>((ref) async {
  await ref.read(serviceProvider.notifier).getAllServices();
  await ref.read(bookingProvider.notifier).getAllBookings();
});
