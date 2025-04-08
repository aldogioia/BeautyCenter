import 'package:beauty_center_frontend/security/InputValidator.dart';
import 'package:beauty_center_frontend/handler/SnackBarHandler.dart';
import 'package:beauty_center_frontend/model/CustomerDto.dart';
import 'package:beauty_center_frontend/model/UpdateCustomerDto.dart';
import 'package:beauty_center_frontend/provider/CustomerProvider.dart';
import 'package:beauty_center_frontend/widget/CustomButton.dart';
import 'package:beauty_center_frontend/widget/CustomTextField.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/Strings.dart';

class CustomerUpdateModalBottomSheet extends ConsumerStatefulWidget {
  const CustomerUpdateModalBottomSheet({
    super.key,
    required this.customerDto
  });

  final CustomerDto customerDto;

  @override
  ConsumerState<CustomerUpdateModalBottomSheet> createState() => _CustomerUpdateModalBottomSheetState();
}

class _CustomerUpdateModalBottomSheetState extends ConsumerState<CustomerUpdateModalBottomSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telephoneNumberController = TextEditingController();

  bool _isUpdated = false;

  void _checkUpdate(){
    setState(() {
      _isUpdated = _emailController.text != widget.customerDto.email ||
          _telephoneNumberController.text != widget.customerDto.phoneNumber.toString();
    });
  }

  Future<void> _submitForm() async {
    if(_formKey.currentState?.validate() ?? false) {
      final customer = widget.customerDto;
      final updateCustomerDto = UpdateCustomerDto(
        id: customer.id,
        name: customer.name,
        surname: customer.surname,
        email: _emailController.text,
        phoneNumber: double.parse(_telephoneNumberController.text)
      );

      String result = await ref.read(customerProvider.notifier).updateCustomer(updateCustomerDto: updateCustomerDto);
      SnackBarHandler.instance.showMessage(message: result);
    }
  }

  @override
  void initState() {
    _emailController.text = widget.customerDto.email;
    _telephoneNumberController.text = widget.customerDto.phoneNumber.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Form(
          key: _formKey,
          child: Column(
              children: [
                CustomTextField(
                  enabled: false,
                  labelText: Strings.name,
                  initialValue: widget.customerDto.name,
                ),

                const SizedBox(height: 10),

                CustomTextField(
                  enabled: false,
                  labelText: Strings.surname,
                  initialValue: widget.customerDto.surname,
                ),

                const SizedBox(height: 10),

                CustomTextField(
                  labelText: Strings.mobile_phone,
                  keyboardType: TextInputType.phone,
                  validator: (value) => InputValidator.validatePhoneNumber(value),
                  onChanged: (value) => _checkUpdate(),
                  controller: _telephoneNumberController,
                ),

                const SizedBox(height: 10),

                CustomTextField(
                  labelText: Strings.email,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) => _checkUpdate(),
                  validator: (value) => InputValidator.validateEmail(value),
                  controller: _emailController,
                )
              ]
          )
        ),

        if(_isUpdated)
          ...[
            const SizedBox(height: 25),

            CustomButton(
              onPressed: () async => await _submitForm(),
              text: Strings.update
            )
          ]
      ]
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _telephoneNumberController.dispose();
    super.dispose();
  }
}
