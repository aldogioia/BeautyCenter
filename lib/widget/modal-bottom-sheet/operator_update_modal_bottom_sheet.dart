import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../handler/snack_bar_handler.dart';
import '../../model/OperatorDto.dart';
import '../../model/SummaryServiceDto.dart';
import '../../provider/operator_provider.dart';
import '../../security/input_validator.dart';
import '../../utils/strings.dart';
import '../custom_service_wrap.dart';


class OperatorUpdateModalBottomSheet extends ConsumerStatefulWidget {
  const OperatorUpdateModalBottomSheet({
    super.key,
    required this.operatorDto,
    this.fromSettings = false
  });

  final OperatorDto operatorDto;
  final bool fromSettings;

  @override
  ConsumerState<OperatorUpdateModalBottomSheet> createState() => _OperatorUpdateModalBottomSheetState();
}

class _OperatorUpdateModalBottomSheetState extends ConsumerState<OperatorUpdateModalBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _surnameController;
  late TextEditingController _emailController;

  bool _isUpdated = false;
  List<SummaryServiceDto> _selectedServices = [];

  final picker = ImagePicker();
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
      _isUpdated =  !listEquals(_selectedServices, widget.operatorDto.services) ||
          _image != null ||
          _nameController.text != widget.operatorDto.name ||
          _surnameController.text != widget.operatorDto.surname ||
          _emailController.text != widget.operatorDto.email;
    });
  }

  void _onChipTap({required List<SummaryServiceDto> services}){
    _selectedServices = List.from(services);
    _checkUpdate();
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

      String result = await ref.read(operatorProvider.notifier).updateOperator(
          id: widget.operatorDto.id,
          name: _nameController.text,
          surname: _surnameController.text,
          email: _emailController.text,
          services: _selectedServices,
          image: _image
      );

      navigator.pop();

      SnackBarHandler.instance.showMessage(message: result);
    }

  }

  @override
  void initState() {
    _selectedServices = List.from(widget.operatorDto.services);
    _nameController = TextEditingController(text: widget.operatorDto.name);
    _surnameController = TextEditingController(text: widget.operatorDto.surname);
    _emailController = TextEditingController(text: widget.operatorDto.email);
    super.initState();
  }


  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _emailController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    Widget imageWidget;
    if(_image == null){
      imageWidget = Image.network(
        widget.operatorDto.imgUrl,
        width: 200,
        height: 200,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            color: Colors.grey,
            width: 200,
            height: 200,
            alignment: Alignment.center,
            child: const CircularProgressIndicator(),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
              color: Colors.grey,
              width: 200,
              height: 200,
              alignment: Alignment.center,
              child: const Icon(Icons.image_not_supported)
          );
        },
      );
    } else {
      imageWidget = Image.file(
        _image!,
        fit: BoxFit.cover,
        width: 200,
        height: 200,
      );
    }

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
                                children: [
                                  AbsorbPointer(
                                    absorbing: widget.fromSettings,
                                    child: Center(
                                        child: ClipRRect(
                                            borderRadius: BorderRadius.circular(30),
                                            child: Stack(
                                                alignment: Alignment.bottomCenter,
                                                children: [
                                                  imageWidget,
                                                  Positioned(
                                                      bottom: 5,
                                                      right: 5,
                                                      child: GestureDetector(
                                                          onTap: () async => await _pickImage(),
                                                          child: CircleAvatar(
                                                            child: Icon(Icons.change_circle_rounded, size: 16),
                                                          )
                                                      )
                                                  )

                                                ]
                                            )
                                        )
                                    )
                                  ),

                                  const SizedBox(height: 10),

                                  Form(
                                    key: _formKey,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextFormField(
                                          decoration: InputDecoration(labelText: Strings.name),
                                          validator: (value) => InputValidator.validateName(value),
                                          onChanged: (value) => _checkUpdate(),
                                          controller: _nameController,
                                        ),

                                        const SizedBox(height: 10),

                                        TextFormField(
                                          decoration: InputDecoration(labelText: Strings.surname),
                                          validator: (value) => InputValidator.validateSurname(value),
                                          onChanged: (value) => _checkUpdate(),
                                          controller: _surnameController,
                                        ),

                                        const SizedBox(height: 10),

                                        TextFormField(
                                          decoration: InputDecoration(labelText: Strings.email),
                                          validator: (value) => InputValidator.validateEmail(value),
                                          onChanged: (value) => _checkUpdate(),
                                          controller: _emailController,
                                        ),

                                        const SizedBox(height: 25),

                                        Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(Strings.services, style: Theme.of(context).inputDecorationTheme.labelStyle)
                                        )
                                      ]
                                    )
                                  ),

                                  const SizedBox(height: 10),

                                  AbsorbPointer(
                                    absorbing: widget.fromSettings,
                                    child: CustomServiceWrap(
                                        onChipTap: (services) => _onChipTap(services: services),
                                        initialServices: _selectedServices
                                    )
                                  )
                                ]
                            )
                          ]
                      )
                  )
              )
            )
        )
    );
  }
}
