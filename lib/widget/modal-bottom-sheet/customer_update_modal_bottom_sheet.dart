import 'package:beauty_center_frontend/security/input_validator.dart';
import 'package:beauty_center_frontend/handler/snack_bar_handler.dart';
import 'package:beauty_center_frontend/model/CustomerDto.dart';
import 'package:beauty_center_frontend/provider/customer_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/strings.dart';

class CustomerUpdateModalBottomSheet extends ConsumerStatefulWidget {
  const CustomerUpdateModalBottomSheet({
    super.key,
    required this.customerDto
  });

  final CustomerDto customerDto;

  @override
  ConsumerState<CustomerUpdateModalBottomSheet> createState() => _CustomerUpdateModalBottomSheetState();
}

// todo non va l'update dei customer
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

      String result = await ref.read(customerProvider.notifier).updateCustomer(
        id: widget.customerDto.id,
        name: widget.customerDto.name,
        surname: widget.customerDto.surname,
        email: _emailController.text,
        phoneNumber: _telephoneNumberController.text
      );

      navigator.pop();

      SnackBarHandler.instance.showMessage(message: result);
    }
  }

  @override
  void initState() {
    _emailController.text = widget.customerDto.email;
    _telephoneNumberController.text = widget.customerDto.phoneNumber;
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

                            Column(
                                children: [
                                  Form(
                                      key: _formKey,
                                      child: Column(
                                          children: [
                                            TextFormField(
                                              enabled: false,
                                              decoration: InputDecoration(labelText: Strings.name),
                                              initialValue: widget.customerDto.name,
                                            ),

                                            const SizedBox(height: 10),

                                            TextFormField(
                                              enabled: false,
                                              decoration: InputDecoration(labelText: Strings.surname),
                                              initialValue: widget.customerDto.surname,
                                            ),

                                            const SizedBox(height: 10),

                                            TextFormField(
                                              decoration: InputDecoration(labelText: Strings.mobile_phone),
                                              keyboardType: TextInputType.phone,
                                              validator: (value) => InputValidator.validatePhoneNumber(value),
                                              onChanged: (value) => _checkUpdate(),
                                              controller: _telephoneNumberController,
                                            ),

                                            const SizedBox(height: 10),

                                            TextFormField(
                                              decoration: InputDecoration(labelText: Strings.email),
                                              keyboardType: TextInputType.emailAddress,
                                              onChanged: (value) => _checkUpdate(),
                                              validator: (value) => InputValidator.validateEmail(value),
                                              controller: _emailController,
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

  @override
  void dispose() {
    _emailController.dispose();
    _telephoneNumberController.dispose();
    super.dispose();
  }
}
