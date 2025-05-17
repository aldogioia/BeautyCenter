import 'package:beauty_center_frontend/provider/tool_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../handler/snack_bar_handler.dart';
import '../../security/input_validator.dart';
import '../../utils/Strings.dart';

class ToolAddModalBottomSheet extends ConsumerStatefulWidget {
  const ToolAddModalBottomSheet({super.key});

  @override
  ConsumerState<ToolAddModalBottomSheet> createState() => _ToolAddModalBottomSheetState();
}

class _ToolAddModalBottomSheetState extends ConsumerState<ToolAddModalBottomSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _availabilityController = TextEditingController();

  bool _canAdd = false;

  void _checkCanAdd() => setState(() => _canAdd = _nameController.text != "" && _availabilityController.text != "");


  Future<void> _submitForm() async {
    if(_formKey.currentState?.validate() ?? false){
      final navigator = Navigator.of(context);
      final result = await ref.read(toolProvider.notifier).createTool(
          name: _nameController.text,
          availability: int.parse(_availabilityController.text)
      );

      if(result.key) navigator.pop();
      SnackBarHandler.instance.showMessage(message: result.value);
    }
  }


  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _availabilityController.dispose();
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
                                    Strings.tool,
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
                                    spacing: 10,
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      TextFormField(
                                        validator: (value) => InputValidator.validateToolName(value),
                                        decoration: InputDecoration(labelText: Strings.tool),
                                        onChanged: (value) => _checkCanAdd(),
                                        controller: _nameController,
                                      ),

                                      TextFormField(
                                        decoration: InputDecoration(labelText: Strings.availability),
                                        onChanged: (value) => _checkCanAdd(),
                                        validator: (value) => InputValidator.validateToolAvailability(value),
                                        keyboardType: TextInputType.number,
                                        controller: _availabilityController,
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
}
