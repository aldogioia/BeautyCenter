import 'dart:io';

import 'package:beauty_center_frontend/security/InputValidator.dart';
import 'package:beauty_center_frontend/handler/SnackBarHandler.dart';
import 'package:beauty_center_frontend/provider/ServiceProvider.dart';
import 'package:beauty_center_frontend/widget/CustomButton.dart';
import 'package:beauty_center_frontend/widget/CustomImagePicker.dart';
import 'package:beauty_center_frontend/widget/CustomTextField.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/Strings.dart';

class ServiceAddModalBottomSheet extends ConsumerStatefulWidget {
  const ServiceAddModalBottomSheet({super.key});

  @override
  ConsumerState<ServiceAddModalBottomSheet> createState() => _ServiceAddModalBottomSheetState();
}

class _ServiceAddModalBottomSheetState extends ConsumerState<ServiceAddModalBottomSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();

  File? _image;
  bool _canAdd = false;

  void _checkCanAdd(){
    setState(() {
      _canAdd = _nameController.text != "" && _priceController.text != "" && _durationController.text != ""
          && _image != null;
    });
  }

  Future<void> _submitForm() async {
    final navigator = Navigator.of(context);
    if(_formKey.currentState?.validate() ?? false){
      final result = await ref.read(serviceProvider.notifier).createService(
        name: _nameController.text,
        price: double.tryParse(_priceController.text) ?? 0,
        duration: int.tryParse(_durationController.text) ?? 0,
        image: _image
      );

      if(result.key) navigator.pop();
      SnackBarHandler.instance.showMessage(message: result.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomImagePicker(
            onImagePick: (image) {
              _image = image;
              _checkCanAdd();
            },
            height: 150
          ),

          const SizedBox(height: 25),

          CustomTextField(
            labelText: Strings.name,
            validator: (value) => InputValidator.validateServiceName(value),
            onChanged: (value) => _checkCanAdd(),
            controller: _nameController,
          ),

          const SizedBox(height: 10),

          CustomTextField(
            labelText: Strings.price_in_euro,
            controller: _priceController,
            keyboardType: TextInputType.number,
            onChanged: (value) => _checkCanAdd(),
            validator: (value) => InputValidator.validateServicePrice(value),
          ),

          const SizedBox(height: 10),

          CustomTextField(
            labelText: Strings.duration_in_minutes,
            controller: _durationController,
            keyboardType: TextInputType.number,
            onChanged: (value) => _checkCanAdd(),
            validator: (value) => InputValidator.validateServiceDuration(value),
          ),

          if(_canAdd) ...[
            const SizedBox(height: 25),

            CustomButton(
              onPressed: () async => await _submitForm(),
              text: Strings.add
            )
          ]
        ]
      )
    );
  }
}
