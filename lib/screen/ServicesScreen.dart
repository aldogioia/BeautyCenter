import 'package:beauty_center_frontend/provider/service_provider.dart';
import 'package:beauty_center_frontend/widget/CustomTextField.dart';
import 'package:beauty_center_frontend/widget/ServiceWidget.dart';
import 'package:beauty_center_frontend/widget/modal-bottom-sheet/CustomModalBottomSheet.dart';
import 'package:beauty_center_frontend/widget/modal-bottom-sheet/ServiceUpdateModalBottomSheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/strings.dart';
import '../widget/CustomDialog.dart';
import '../widget/DeletePopUp.dart';

class ServicesScreen extends ConsumerStatefulWidget {
  const ServicesScreen({super.key});

  @override
  ConsumerState<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends ConsumerState<ServicesScreen> {
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final services = ref.watch(serviceProvider.select((state) => state.services));

    return SliverList.separated(
      itemBuilder: (context, index) {
        if(index == 0) {
          return Column(
              children: [
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: CustomTextField(
                      hintText: Strings.search,
                      prefixIcon: Icons.search,
                      controller: _searchController,
                      onChanged: (value){},     // todo search servizi
                    )
                ),

                const SizedBox(height: 15)
              ]
          );
        }
        final service = services[index - 1];
        return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ServiceWidget(
              serviceDto: service,
              onTap: () {
                CustomModalBottomSheet.show(
                  child: ServiceUpdateModalBottomSheet(serviceDto: service),
                  context: context
                );
              },
              onLongPress: () {
                CustomDialog.show(
                  child: DeletePopUp(
                      article: "il",
                      entityToDelete: Strings.service,
                      onDelete: () async {
                        return await ref.read(serviceProvider.notifier).deleteService(serviceId: service.id);
                      }
                  ),
                  context: context
                );
              },
            )
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemCount: services.length + 1,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

