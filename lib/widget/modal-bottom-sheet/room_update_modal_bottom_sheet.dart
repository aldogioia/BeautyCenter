import 'package:beauty_center_frontend/model/SummaryServiceDto.dart';
import 'package:beauty_center_frontend/provider/room_provider.dart';
import 'package:beauty_center_frontend/widget/custom_service_wrap.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../handler/snack_bar_handler.dart';
import '../../model/RoomDto.dart';
import '../../security/input_validator.dart';
import '../../utils/strings.dart';

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
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;

  bool _isUpdated = false;
  List<SummaryServiceDto> _selectedServices = [];


  void _onChipTap({required List<SummaryServiceDto> services}){
    _selectedServices = List.from(services);
    _checkIsUpdated();
  }

  Future<void> _update() async {
    if(_formKey.currentState?.validate() ?? false) {
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

      String result = await ref.read(roomProvider.notifier).updateRoom(
        id: widget.roomDto.id,
        services: _selectedServices,
        name: _nameController.text
      );

      navigator.pop();

      SnackBarHandler.instance.showMessage(message: result);
    }
  }


  void _checkIsUpdated(){
    setState(() {
      _isUpdated = !listEquals(_selectedServices, widget.roomDto.services) || _nameController.text != widget.roomDto.name;
    });
  }


  @override
  void initState() {
    _selectedServices = List.from(widget.roomDto.services);
    _nameController = TextEditingController(text: widget.roomDto.name);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
        child: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(15))
                      ),
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    Strings.room,
                                    style: Theme.of(context).textTheme.bodyLarge,
                                  ),

                                  if(_isUpdated)...[
                                    GestureDetector(
                                        onTap: () async => await _update(),
                                        child: Text(
                                          Strings.update,
                                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.primary),
                                        )
                                    )
                                  ]
                                ]
                            ),

                            const SizedBox(height: 25),

                            Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Form(
                                    key: _formKey,
                                    child: TextFormField(
                                      validator: (value) => InputValidator.validateRoomName(value),
                                      decoration: InputDecoration(labelText: Strings.room),
                                      onChanged: (value) => _checkIsUpdated(),
                                      controller: _nameController,
                                    ),
                                  ),

                                  const SizedBox(height: 25),

                                  Text(Strings.services, style: Theme.of(context).inputDecorationTheme.labelStyle),

                                  const SizedBox(height: 10),

                                  CustomServiceWrap(
                                      onChipTap: (services) => _onChipTap(services: services),
                                      initialServices: _selectedServices
                                  )
                                ]
                            )
                          ]
                      )
                  )
              ),
            )
        )
    );
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _selectedServices = List.from(widget.roomDto.services);
  }
}
