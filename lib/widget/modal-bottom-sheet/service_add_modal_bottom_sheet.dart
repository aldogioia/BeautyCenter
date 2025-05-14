import 'dart:io';

import 'package:beauty_center_frontend/security/input_validator.dart';
import 'package:beauty_center_frontend/handler/snack_bar_handler.dart';
import 'package:beauty_center_frontend/provider/service_provider.dart';
import 'package:beauty_center_frontend/widget/CustomImagePicker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/strings.dart';

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
    return ConstrainedBox(
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                    ),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  Strings.service,
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
                              children: [
                                Form(
                                    key: _formKey,
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: [
                                          CustomImagePicker(
                                              onImagePick: (image) {
                                                _image = image;
                                                _checkCanAdd();
                                              },
                                              height: 150
                                          ),

                                          const SizedBox(height: 25),

                                          TextFormField(
                                            decoration: InputDecoration(labelText: Strings.name),
                                            validator: (value) => InputValidator.validateServiceName(value),
                                            onChanged: (value) => _checkCanAdd(),
                                            controller: _nameController,
                                          ),

                                          const SizedBox(height: 10),

                                          TextFormField(
                                            decoration: InputDecoration(labelText: Strings.price_in_euro),
                                            controller: _priceController,
                                            keyboardType: TextInputType.number,
                                            onChanged: (value) => _checkCanAdd(),
                                            validator: (value) => InputValidator.validateServicePrice(value),
                                          ),

                                          const SizedBox(height: 10),

                                          TextFormField(
                                            decoration: InputDecoration(labelText: Strings.duration_in_minutes),
                                            controller: _durationController,
                                            keyboardType: TextInputType.number,
                                            onChanged: (value) => _checkCanAdd(),
                                            validator: (value) => InputValidator.validateServiceDuration(value),
                                          )
                                        ]
                                    )
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
}
