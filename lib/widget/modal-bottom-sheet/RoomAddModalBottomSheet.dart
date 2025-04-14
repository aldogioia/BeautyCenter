import 'package:beauty_center_frontend/security/input_validator.dart';
import 'package:beauty_center_frontend/handler/snack_bar_handler.dart';
import 'package:beauty_center_frontend/model/SummaryServiceDto.dart';
import 'package:beauty_center_frontend/provider/room_provider.dart';
import 'package:beauty_center_frontend/widget/CustomServiceWrap.dart';
import 'package:beauty_center_frontend/widget/CustomTextField.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/strings.dart';
import '../CustomButton.dart';

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
  Widget build(BuildContext context) {
    return Column(
      children: [
        Form(
          key: _formKey,
          child: CustomTextField(
            labelText: Strings.name,
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

        if(_canAdd) ...[
          const SizedBox(height: 25),

          CustomButton(
            onPressed: () async => await _submitForm(),
            text: Strings.add
          )
        ]
      ]
    );
  }
}
