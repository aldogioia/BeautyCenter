import 'package:beauty_center_frontend/handler/SnackBarHandler.dart';
import 'package:beauty_center_frontend/widget/CustomButton.dart';
import 'package:beauty_center_frontend/widget/CustomTextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/Strings.dart';

class DeletePopUp extends ConsumerStatefulWidget {
  const DeletePopUp({
    super.key,
    required this.article,
    required this.entityToDelete,
    required this.onDelete
  });

  final String article;
  final String entityToDelete;
  final Future<MapEntry<bool, String>> Function() onDelete;

  @override
  ConsumerState<DeletePopUp> createState() => _DeletePopUpState();
}

class _DeletePopUpState extends ConsumerState<DeletePopUp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _controller = TextEditingController();

  String? _validate() {
    if(_controller.text != "${Strings.delete.toLowerCase()} ${widget.entityToDelete}"){
      return "${Strings.write} \"${Strings.delete.toLowerCase()} ${widget.entityToDelete}\"";
    }
    return null;
  }

  Future<void> _submitForm() async {
    if(_formKey.currentState?.validate() ?? false){
      final navigator = Navigator.of(context);
      final result = await widget.onDelete();

      if(result.key) navigator.pop();
      SnackBarHandler.instance.showMessage(message: result.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(40)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              border: Border.all(color: Theme.of(context).inputDecorationTheme.border!.borderSide.color)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${Strings.want_to_delete} ${widget.article} ${widget.entityToDelete}?",
                  style: Theme.of(context).textTheme.labelMedium,
                ),

                const SizedBox(height: 10),

                Form(
                  key: _formKey,
                  child: CustomTextField(
                    hintText: "${Strings.write} \"${Strings.delete.toLowerCase()} ${widget.entityToDelete}\"",
                    controller: _controller,
                    validator: (value) => _validate(),
                  )
                )
              ]
            )
          ),

          const SizedBox(height: 25),

          CustomButton(
            background: Theme.of(context).colorScheme.error.withOpacity(0.8),
            onPressed: () async => await _submitForm(),
            text: Strings.delete
          )
        ]
      )
    );
  }
}

