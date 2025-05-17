import 'package:beauty_center_frontend/provider/service_provider.dart';
import 'package:beauty_center_frontend/widget/service_widget.dart';
import 'package:beauty_center_frontend/widget/modal-bottom-sheet/service_update_modal_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';

import '../handler/snack_bar_handler.dart';
import '../utils/strings.dart';
import '../widget/modal-bottom-sheet/delete_modal_bottom_sheet.dart';

class ServicesScreen extends ConsumerStatefulWidget {
  const ServicesScreen({super.key});

  @override
  ConsumerState<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends ConsumerState<ServicesScreen> {
  String _searchText = "";


  Future<void> _onDelete({required String serviceId}) async {
    final navigator = Navigator.of(context);

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
    );

    final result = await ref.read(serviceProvider.notifier).deleteService(serviceId: serviceId);

    navigator.pop();

    if(result.key) navigator.pop(true);
    SnackBarHandler.instance.showMessage(message: result.value);
  }


  @override
  Widget build(BuildContext context) {
    final services = ref.watch(serviceProvider.select((state) => state.services));
    final filteredServices = _searchText.isEmpty
        ? services
        : services.where((s) => s.name.toLowerCase().contains(_searchText)).toList();

    if(filteredServices.isEmpty) {
      return SliverFillRemaining(
        child: Column(
            spacing: 16,
            children: [
              const SizedBox(height: 32),
              Lottie.asset(
                  'assets/lottie/no_items.json',
                  height: 200
              ),
              Center(child: Text(Strings.no_services_founded, textAlign: TextAlign.center,))
            ]
        )
      );
    }
    return SliverList.separated(
      itemBuilder: (context, index) {
        if(index == 0) {
          return Column(
              children: [
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: Strings.search,
                        prefixIcon: Icon(FontAwesomeIcons.magnifyingGlass)
                      ),
                      onChanged: (value){
                        setState(() => _searchText = value.toLowerCase());
                      },
                    )
                ),

                const SizedBox(height: 15)
              ]
          );
        }
        final service = filteredServices[index - 1];
        return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Dismissible(
              key: Key(service.id),
              background: Container(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(left: 20),
                  child: CircleAvatar(
                    backgroundColor: Colors.red,
                    child: Icon(FontAwesomeIcons.trash, color: Colors.white),
                  )
              ),
              direction: DismissDirection.endToStart,
              confirmDismiss: (direction) async {
                final result = await showModalBottomSheet<bool>(
                    context: context,
                    isScrollControlled: true,
                    transitionAnimationController: AnimationController(
                      vsync: Navigator.of(context),
                      duration: Duration(milliseconds: 750),
                    ),
                    builder: (context) => DeleteModalBottomSheet(
                      onTap: () async => await _onDelete(serviceId: service.id),
                    )
                );

                return result ?? false;
              },
              child: ServiceWidget(
              serviceDto: service,
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  transitionAnimationController: AnimationController(
                    vsync: Navigator.of(context),
                    duration: Duration(milliseconds: 750)
                  ),
                  builder: (context) => ServiceUpdateModalBottomSheet(serviceDto: service)
                );
              }
            )
          )
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemCount: filteredServices.length + 1,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

