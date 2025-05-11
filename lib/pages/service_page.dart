import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

import '../navigation/navigator.dart';
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
        children: [
          Column(
            spacing: 16,
              children: [
                const SizedBox(height: 32),
                Lottie.asset(
                  'assets/lottie/no_items.json',
                  height: 200
                ),
                const Text(Strings.noServices)
              ]
          )
        ],
      ) :
      ListView.separated(
        itemCount: services.length + 1,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          if (index == 0) {
            return SizedBox(height: 32);
          }
          final service = services[index - 1];
          return GestureDetector(
            onTap: () {
              NavigatorService.navigatorKey.currentState?.pushNamed(
                '/booking',
                arguments: Map<String, dynamic>.from({
                  'serviceId': service.id,
                  'serviceImage': service.imgUrl
                })
              );
            },
            child: ServiceItem(service: service),
          );
        },
      ),
    );
  }
}
