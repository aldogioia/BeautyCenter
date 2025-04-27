import 'package:edone_customer/providers/service_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appInitProvider = FutureProvider<void>((ref) async {
  await ref.read(serviceProvider.notifier).getAllServices();
});
