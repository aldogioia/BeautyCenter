import 'package:beauty_center_frontend/model/SummaryServiceDto.dart';
import 'package:beauty_center_frontend/provider/ServiceProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/ServiceDto.dart';
import 'CustomChip.dart';

class CustomServiceWrap extends ConsumerStatefulWidget {
  const CustomServiceWrap({
    super.key,
    required this.onChipTap,
    required this.initialServices
  });

  final void Function(List<SummaryServiceDto>) onChipTap;
  final List<SummaryServiceDto> initialServices;

  @override
  ConsumerState<CustomServiceWrap> createState() => _CustomServiceWrapState();
}

class _CustomServiceWrapState extends ConsumerState<CustomServiceWrap> {
  List<SummaryServiceDto> _selectedServices = [];

  void _onChipTap({required ServiceDto serviceDto}){
    setState(() {
      int index = _selectedServices.indexWhere((e) => e.id == serviceDto.id);

      if(index == -1) {
        _selectedServices.add(SummaryServiceDto(id: serviceDto.id, name: serviceDto.name));
      } else {
        _selectedServices.removeAt(index);
      }

      widget.onChipTap;
    });
  }


  @override
  void initState() {
    _selectedServices = List.from(widget.initialServices);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final services = ref.watch(serviceProvider.select((state) => state.services));

    return Wrap(
        spacing: 10,
        runSpacing: 10,
        children: services.map((service) {
          return CustomChip(
            text: service.name,
            onTap: () => _onChipTap(serviceDto: service),
            isSelected: _selectedServices.any((e) => e.id == service.id),
          );
        }).toList()
    );
  }
}

