import 'package:edone_customer/pages/custom_widgets/booking_step.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/service_provider.dart';
import '../utils/Strings.dart';
import 'custom_widgets/service_item.dart';

class ServicePage extends ConsumerWidget {
  const ServicePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serviceState = ref.watch(serviceProvider);
    final services = serviceState.services;

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(serviceProvider.notifier).getAllServices();
      },
      child: services.isEmpty ?
      ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: const [
          Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Text(Strings.noServices)
            )
          )
        ],
      ) :
      ListView.separated(
        itemCount: services.length + 1,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                Strings.services,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            );
          }
          final service = services[index - 1];
          return GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                isDismissible: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                builder: (context) => SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: BookingStep(serviceId: service.id),
                ),
              );
            },
            child: ServiceItem(service: service),
          );
        },
      ),
    );
  }
}
