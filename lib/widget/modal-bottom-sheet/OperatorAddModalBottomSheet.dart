import 'dart:io';

import 'package:beauty_center_frontend/handler/snack_bar_handler.dart';
import 'package:beauty_center_frontend/provider/operator_provider.dart';
import 'package:beauty_center_frontend/widget/CustomImagePicker.dart';
import 'package:beauty_center_frontend/widget/CustomTextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../security/input_validator.dart';
import '../../model/SummaryServiceDto.dart';
import '../../utils/strings.dart';
import '../CustomButton.dart';
import '../CustomServiceWrap.dart';

class OperatorAddModalBottomSheet extends ConsumerStatefulWidget {
  const OperatorAddModalBottomSheet({super.key});

  @override
  ConsumerState<OperatorAddModalBottomSheet> createState() => _OperatorAddModalBottomSheetState();
}

class _OperatorAddModalBottomSheetState extends ConsumerState<OperatorAddModalBottomSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  List<SummaryServiceDto> _selectedServices = [];
  bool _canAdd = false;
  File? _image;

  void _checkCanAdd(){
    setState(() {
      _canAdd = _nameController.text != "" && _surnameController.text != "" && _emailController.text != ""
          && _image != null;
    });
  }

  void _onChipTap({required List<SummaryServiceDto> services}){
    _selectedServices = List.from(services);
    _checkCanAdd();
  }

  Future<void> _submitForm() async {
    if(_formKey.currentState?.validate() ?? false){
      final navigator = Navigator.of(context);
      final result = await ref.read(operatorProvider.notifier).createOperator(
        name: _nameController.text,
        surname: _surnameController.text,
        email: _emailController.text,
        image: _image,
        services: _selectedServices
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomImagePicker(
            height: 150,
            width: 150,
            onImagePick: (image) {
              _image = image;
              _checkCanAdd();
            }
          ),

          const SizedBox(height: 25),

          CustomTextField(
            controller: _nameController,
            labelText: Strings.name,
            keyboardType: TextInputType.name,
            validator: (value) => InputValidator.validateName(value),
            onChanged: (value) => _checkCanAdd(),
          ),

          const SizedBox(height: 10),

          CustomTextField(
            controller: _surnameController,
            labelText: Strings.surname,
            keyboardType: TextInputType.name,
            validator: (value) => InputValidator.validateSurname(value),
            onChanged: (value) => _checkCanAdd(),
          ),

          const SizedBox(height: 10),

          CustomTextField(
            controller: _emailController,
            labelText: Strings.email,
            keyboardType: TextInputType.emailAddress,
            validator: (value) => InputValidator.validateEmail(value),
            onChanged: (value) => _checkCanAdd(),
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
      )
    );
  }
}
