import 'dart:io';

import 'package:beauty_center_frontend/handler/snack_bar_handler.dart';
import 'package:beauty_center_frontend/model/summary_tool_dto.dart';
import 'package:beauty_center_frontend/widget/custom_tool_wrap.dart';
import 'package:beauty_center_frontend/widget/service_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
  List<SummaryToolDto> _selectedTools = [];


  void _onChipTap({required List<SummaryToolDto> tools}){
    _selectedTools = List.from(tools);
    _checkUpdate();
  }


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
          || _image != null
          || !listEquals(_selectedTools, widget.serviceDto.tools);
    });
  }

  Future<void> _submitForm() async {
    if(_formKey.currentState?.validate() ?? false){
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

      String result = await ref.read(serviceProvider.notifier).updateService(
        id: widget.serviceDto.id,
        name: _serviceNameController.text,
        duration: int.tryParse(_serviceDurationController.text) ?? 0,
        price: double.tryParse(_servicePriceController.text) ?? 0,
        image: _image,
        tools: _selectedTools
      );

      navigator.pop();

      SnackBarHandler.instance.showMessage(message: result);
    }
  }

  @override
  void initState() {
    _selectedTools = List.from(widget.serviceDto.tools);
    _serviceNameController.text = widget.serviceDto.name;
    _servicePriceController.text = widget.serviceDto.price.toStringAsFixed(2);
    _serviceDurationController.text = widget.serviceDto.duration.toStringAsFixed(0);
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
                                        onTap: () async => await _submitForm(),
                                        child: Text(
                                          Strings.update,
                                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.primary),
                                        )
                                    )
                                  ]
                                ]
                            ),

                            const SizedBox(height: 25),

                            Form(
                                key: _formKey,
                                child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      ServiceWidget(
                                        image: _image,
                                        serviceDto: widget.serviceDto,
                                        onChangeImage: () async => await _pickImage(),
                                      ),

                                      const SizedBox(height: 25),

                                      TextFormField(
                                        decoration: InputDecoration(labelText: Strings.name),
                                        controller: _serviceNameController,
                                        onChanged: (value) => _checkUpdate(),
                                        validator: (value) => InputValidator.validateServiceName(value),
                                      ),

                                      const SizedBox(height: 10),

                                      TextFormField(
                                        decoration: InputDecoration(labelText: Strings.price_in_euro),
                                        controller: _servicePriceController,
                                        keyboardType: TextInputType.number,
                                        onChanged: (value) => _checkUpdate(),
                                        validator: (value) => InputValidator.validateServicePrice(value),
                                      ),

                                      const SizedBox(height: 10),

                                      TextFormField(
                                        decoration: InputDecoration(labelText: Strings.duration_in_minutes),
                                        controller: _serviceDurationController,
                                        keyboardType: TextInputType.number,
                                        onChanged: (value) => _checkUpdate(),
                                        validator: (value) => InputValidator.validateServiceDuration(value),
                                      ),

                                      const SizedBox(height: 25),

                                      Text(Strings.tools, style: Theme.of(context).inputDecorationTheme.labelStyle),

                                      const SizedBox(height: 10),

                                      CustomToolWrap(
                                        onChipTap: (tools) => _onChipTap(tools: tools),
                                        initialTools: _selectedTools
                                      )
                                    ]
                                )
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
    _serviceNameController.dispose();
    _serviceDurationController.dispose();
    _servicePriceController.dispose();
    _selectedTools = List.from(widget.serviceDto.tools);
  }
}
