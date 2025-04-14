import 'dart:io';

import 'package:beauty_center_frontend/handler/snack_bar_handler.dart';
import 'package:beauty_center_frontend/widget/CustomButton.dart';
import 'package:beauty_center_frontend/widget/CustomTextField.dart';
import 'package:beauty_center_frontend/widget/ServiceWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../security/input_validator.dart';
import '../../model/ServiceDto.dart';
import '../../provider/service_provider.dart';
import '../../utils/strings.dart';

class ServiceUpdateModalBottomSheet extends ConsumerStatefulWidget {
  const ServiceUpdateModalBottomSheet({
    super.key,
    required this.serviceDto
  });

  final ServiceDto serviceDto;

  @override
  ConsumerState<ServiceUpdateModalBottomSheet> createState() => _ServiceUpdateModalBottomSheetState();
}

class _ServiceUpdateModalBottomSheetState extends ConsumerState<ServiceUpdateModalBottomSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final picker = ImagePicker();

  final TextEditingController _serviceNameController = TextEditingController();
  final TextEditingController _servicePriceController = TextEditingController();
  final TextEditingController _serviceDurationController = TextEditingController();

  bool _isUpdated = false;
  File? _image;


  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      _checkUpdate();
    }
  }

  void _checkUpdate(){
    setState(() {
      _isUpdated = _serviceNameController.text != widget.serviceDto.name
          || _servicePriceController.text != widget.serviceDto.price.toStringAsFixed(2)
          || _serviceDurationController.text != widget.serviceDto.duration.toStringAsFixed(0)
          || _image != null;
    });
  }

  Future<void> _submitForm() async {
    if(_formKey.currentState?.validate() ?? false){
      String result = await ref.read(serviceProvider.notifier).updateService(
        id: widget.serviceDto.id,
        name: _serviceNameController.text,
        duration: int.tryParse(_serviceDurationController.text) ?? 0,
        price: double.tryParse(_servicePriceController.text) ?? 0,
        image: _image
      );

      SnackBarHandler.instance.showMessage(message: result);
    }
  }

  @override
  void initState() {
    _serviceNameController.text = widget.serviceDto.name;
    _servicePriceController.text = widget.serviceDto.price.toStringAsFixed(2);
    _serviceDurationController.text = widget.serviceDto.duration.toStringAsFixed(0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ServiceWidget(
            image: _image,
            serviceDto: widget.serviceDto,
            onChangeImage: () async => await _pickImage(),
          ),

          const SizedBox(height: 25),

          CustomTextField(
            labelText: Strings.name,
            controller: _serviceNameController,
            onChanged: (value) => _checkUpdate(),
            validator: (value) => InputValidator.validateServiceName(value),
          ),

          const SizedBox(height: 10),

          CustomTextField(
            labelText: Strings.price_in_euro,
            controller: _servicePriceController,
            keyboardType: TextInputType.number,
            onChanged: (value) => _checkUpdate(),
            validator: (value) => InputValidator.validateServicePrice(value),
          ),

          const SizedBox(height: 10),

          CustomTextField(
            labelText: Strings.duration_in_minutes,
            controller: _serviceDurationController,
            keyboardType: TextInputType.number,
            onChanged: (value) => _checkUpdate(),
            validator: (value) => InputValidator.validateServiceDuration(value),
          ),

          if(_isUpdated) ...[
            const SizedBox(height: 25),

            CustomButton(
              onPressed: () async => await _submitForm(),
              text: Strings.update
            )
          ]
        ]
      )
    );
  }
}
