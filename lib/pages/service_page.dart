import 'package:edone_customer/pages/custom_widgets/booking_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/service_provider.dart';
import '../utils/Strings.dart';
import 'custom_widgets/service_item.dart';

class ServicePage extends ConsumerWidget {
  const ServicePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final services = ref.watch(serviceProvider).services;

    if (services.isEmpty) {
      return const Center(child: Text(Strings.noServices));
    }

    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            itemCount: services.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final service = services[index];
              return GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    useSafeArea: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                    ),
                    isScrollControlled: true,
                    isDismissible: true,
                    builder: (context) => SingleChildScrollView(
                      child: BookingModal(serviceId: service.id),
                    ),
                  );

                },
                child: ServiceItem(service: service),
              );
            },
          ),
        ),
      ],
    );
  }
}