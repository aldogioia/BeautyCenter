import 'dart:io';

import 'package:beauty_center_frontend/widget/CustomTextField.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../handler/snack_bar_handler.dart';
import '../../model/OperatorDto.dart';
import '../../model/SummaryServiceDto.dart';
import '../../provider/operator_provider.dart';
import '../../utils/strings.dart';
import '../CustomButton.dart';
import '../CustomServiceWrap.dart';

class OperatorUpdateModalBottomSheet extends ConsumerStatefulWidget {
  const OperatorUpdateModalBottomSheet({
    super.key,
    required this.operatorDto
  });

  final OperatorDto operatorDto;

  @override
  ConsumerState<OperatorUpdateModalBottomSheet> createState() => _OperatorUpdateModalBottomSheetState();
}

class _OperatorUpdateModalBottomSheetState extends ConsumerState<OperatorUpdateModalBottomSheet> {
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
      _isUpdated =  !listEquals(_selectedServices, widget.operatorDto.services) || _image != null;
    });
  }

  void _onChipTap({required List<SummaryServiceDto> services}){
    _selectedServices = List.from(services);
    _checkUpdate();
  }

  Future<void> _update() async {
    String result = await ref.read(operatorProvider.notifier).updateOperator(
      id: widget.operatorDto.id,
      name:widget.operatorDto.name,
      surname: widget.operatorDto.surname,
      email: widget.operatorDto.email,
      services: _selectedServices,
      image: _image
    );
    SnackBarHandler.instance.showMessage(message: result);
  }

  @override
  void initState() {
    _selectedServices = List.from(widget.operatorDto.services);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 200,
          height: 200,
          padding: const EdgeInsets.all(10),
          alignment: Alignment.bottomRight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            image: DecorationImage(
              image: _image == null
                  ? AssetImage(widget.operatorDto.imgUrl)    // todo usare imageNetwork
                  : FileImage(_image!),
              fit: BoxFit.cover
            )
          ),
          child: GestureDetector(
            onTap: () async => await _pickImage(),
            child: CircleAvatar(
              child: Icon(Icons.change_circle_rounded, size: 16),
            )
          )
        ),

        const SizedBox(height: 10),

        CustomTextField(
          enabled: false,
          labelText: Strings.name,
          initialValue: widget.operatorDto.name,
        ),

        const SizedBox(height: 10),

        CustomTextField(
          enabled: false,
          labelText: Strings.surname,
          initialValue: widget.operatorDto.surname,
        ),

        const SizedBox(height: 10),

        CustomTextField(
          enabled: false,
          labelText: Strings.email,
          initialValue: widget.operatorDto.email,
        ),

        const SizedBox(height: 25),

        Align(
          alignment: Alignment.centerLeft,
          child: Text(Strings.services, style: Theme.of(context).inputDecorationTheme.labelStyle)
        ),

        const SizedBox(height: 10),

        CustomServiceWrap(
          onChipTap: (services) => _onChipTap(services: services),
          initialServices: _selectedServices
        ),

        if(_isUpdated) ...[
          const SizedBox(height: 25),

          CustomButton(
              onPressed: () async => await _update(),
              text: Strings.update
          )
        ]
      ]
    );
  }
}
