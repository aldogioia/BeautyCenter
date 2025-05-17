import 'package:beauty_center_frontend/provider/tool_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../handler/snack_bar_handler.dart';
import '../../model/tool_dto.dart';
import '../../security/input_validator.dart';
import '../../utils/Strings.dart';

class ToolUpdateModalBottomSheet extends ConsumerStatefulWidget {
  const ToolUpdateModalBottomSheet({
    super.key,
    required this.toolDto
  });

  final ToolDto toolDto;

  @override
  ConsumerState<ToolUpdateModalBottomSheet> createState() => _ToolUpdateModalBottomSheetState();
}

class _ToolUpdateModalBottomSheetState extends ConsumerState<ToolUpdateModalBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _availabilityController;

  bool _isUpdated = false;


  void _checkIsUpdated(){
    setState(() {
      _isUpdated = _nameController.text != widget.toolDto.name ||
          _availabilityController.text != widget.toolDto.availability.toString();
    });
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

      final result = await ref.read(toolProvider.notifier).updateTool(
        id: widget.toolDto.id,
        name: _nameController.text,
        availability: int.parse(_availabilityController.text)
      );

      navigator.pop();

      SnackBarHandler.instance.showMessage(message: result.value);
    }
  }


  @override
  void initState() {
    _nameController = TextEditingController(text: widget.toolDto.name);
    _availabilityController = TextEditingController(text: widget.toolDto.availability.toString());
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
                                    Strings.tool,
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
                                        onChanged: (value) => _checkIsUpdated(),
                                        controller: _nameController,
                                      ),

                                      TextFormField(
                                        decoration: InputDecoration(labelText: Strings.availability),
                                        onChanged: (value) => _checkIsUpdated(),
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


  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _availabilityController.dispose();
  }
}
