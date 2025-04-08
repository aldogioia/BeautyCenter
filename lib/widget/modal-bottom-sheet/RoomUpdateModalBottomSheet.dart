import 'package:beauty_center_frontend/model/SummaryServiceDto.dart';
import 'package:beauty_center_frontend/provider/RoomProvider.dart';
import 'package:beauty_center_frontend/widget/CustomButton.dart';
import 'package:beauty_center_frontend/widget/CustomServiceWrap.dart';
import 'package:beauty_center_frontend/widget/CustomTextField.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../handler/SnackBarHandler.dart';
import '../../model/RoomDto.dart';
import '../../utils/Strings.dart';

class RoomUpdateModalBottomSheet extends ConsumerStatefulWidget {
  const RoomUpdateModalBottomSheet({
    super.key,
    required this.roomDto
  });

  final RoomDto roomDto;

  @override
  ConsumerState<RoomUpdateModalBottomSheet> createState() => _RoomUpdateModalBottomSheetState();
}

class _RoomUpdateModalBottomSheetState extends ConsumerState<RoomUpdateModalBottomSheet> {
  bool _isUpdated = false;
  List<SummaryServiceDto> _selectedServices = [];


  void _onChipTap({required List<SummaryServiceDto> services}){
    _selectedServices = List.from(services);
    setState(() => _isUpdated = !listEquals(_selectedServices, widget.roomDto.services));
  }

  Future<void> _update() async {
    final roomDto = widget.roomDto.copyWith(services: _selectedServices);

    String result = await ref.read(roomProvider.notifier).updateRoom(roomDto: roomDto);
    SnackBarHandler.instance.showMessage(message: result);
  }


  @override
  void initState() {
    _selectedServices = List.from(widget.roomDto.services);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomTextField(
          enabled: false,
          labelText: Strings.room,
          initialValue: widget.roomDto.name,
        ),

        const SizedBox(height: 25),

        Text(Strings.services, style: Theme.of(context).inputDecorationTheme.labelStyle),

        const SizedBox(height: 10),

        CustomServiceWrap(
          onChipTap: (services) => _onChipTap(services: services),
          initialServices: _selectedServices
        ),

        if(_isUpdated) ...[
          const SizedBox(height: 25),

          CustomButton(
              onPressed: () async => await _update(),
              text: Strings.update
          )
        ]
      ]
    );
  }

  @override
  void dispose() {
    super.dispose();
    _selectedServices = List.from(widget.roomDto.services);
  }
}
