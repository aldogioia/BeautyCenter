import 'package:beauty_center_frontend/security/input_validator.dart';
import 'package:beauty_center_frontend/handler/snack_bar_handler.dart';
import 'package:beauty_center_frontend/model/summary_service_dto.dart';
import 'package:beauty_center_frontend/provider/room_provider.dart';
import 'package:beauty_center_frontend/widget/custom_service_wrap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/strings.dart';

class RoomAddModalBottomSheet extends ConsumerStatefulWidget {
  const RoomAddModalBottomSheet({super.key});

  @override
  ConsumerState<RoomAddModalBottomSheet> createState() => _RoomAddModalBottomSheetState();
}

class _RoomAddModalBottomSheetState extends ConsumerState<RoomAddModalBottomSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();

  bool _canAdd = false;
  List<SummaryServiceDto> _selectedServices = [];

  void _checkCanAdd() => setState(() => _canAdd = _nameController.text != "");

  void _onChipTap({required List<SummaryServiceDto> services}){
    _selectedServices = List.from(services);
    _checkCanAdd();
  }

  Future<void> _submitForm() async {
    if(_formKey.currentState?.validate() ?? false){
      final navigator = Navigator.of(context);
      final result = await ref.read(roomProvider.notifier).createRoom(
        name: _nameController.text,
        services: _selectedServices
      );

      if(result.key) navigator.pop();
      SnackBarHandler.instance.showMessage(message: result.value);
    }
  }


  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
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

                                if(_canAdd)...[
                                  GestureDetector(
                                      onTap: () async => await _submitForm(),
                                      child: Text(
                                        Strings.save,
                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.primary),
                                      )
                                  )
                                ]
                              ]
                          ),

                          const SizedBox(height: 25),

                          Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Form(
                                    key: _formKey,
                                    child: TextFormField(
                                      decoration: InputDecoration(labelText: Strings.name),
                                      controller: _nameController,
                                      validator: (value) => InputValidator.validateRoomName(value),
                                      onChanged: (value) => _checkCanAdd(),
                                    )
                                ),

                                const SizedBox(height: 25),

                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(Strings.services, style: Theme.of(context).inputDecorationTheme.labelStyle),
                                ),

                                const SizedBox(height: 10),

                                CustomServiceWrap(
                                    onChipTap: (services) => _onChipTap(services: services),
                                    initialServices: _selectedServices
                                ),
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
}
