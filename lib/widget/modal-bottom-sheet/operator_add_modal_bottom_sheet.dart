import 'dart:io';

import 'package:beauty_center_frontend/handler/snack_bar_handler.dart';
import 'package:beauty_center_frontend/provider/operator_provider.dart';
import 'package:beauty_center_frontend/widget/CustomImagePicker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../security/input_validator.dart';
import '../../model/SummaryServiceDto.dart';
import '../../utils/strings.dart';
import '../custom_service_wrap.dart';

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
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
      );

      final result = await ref.read(operatorProvider.notifier).createOperator(
        name: _nameController.text,
        surname: _surnameController.text,
        email: _emailController.text,
        image: _image,
        services: _selectedServices
      );

      navigator.pop();

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
                                  Strings.operator,
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

                          Form(
                              key: _formKey,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
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

                                    TextFormField(
                                      controller: _nameController,
                                      decoration: InputDecoration(labelText: Strings.name),
                                      keyboardType: TextInputType.name,
                                      validator: (value) => InputValidator.validateName(value),
                                      onChanged: (value) => _checkCanAdd(),
                                    ),

                                    const SizedBox(height: 10),

                                    TextFormField(
                                      controller: _surnameController,
                                      decoration: InputDecoration(labelText: Strings.surname),
                                      keyboardType: TextInputType.name,
                                      validator: (value) => InputValidator.validateSurname(value),
                                      onChanged: (value) => _checkCanAdd(),
                                    ),

                                    const SizedBox(height: 10),

                                    TextFormField(
                                      controller: _emailController,
                                      decoration: InputDecoration(labelText: Strings.email),
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
}
