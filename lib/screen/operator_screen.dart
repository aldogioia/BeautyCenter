import 'package:beauty_center_frontend/handler/snack_bar_handler.dart';
import 'package:beauty_center_frontend/provider/operator_provider.dart';
import 'package:beauty_center_frontend/widget/modal-bottom-sheet/delete_modal_bottom_sheet.dart';
import 'package:beauty_center_frontend/widget/row_item.dart';
import 'package:beauty_center_frontend/widget/modal-bottom-sheet/operator_update_modal_bottom_sheet.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

import '../utils/strings.dart';

class OperatorsScreen extends ConsumerStatefulWidget {
  const OperatorsScreen({super.key});

  @override
  ConsumerState<OperatorsScreen> createState() => _OperatorsScreenState();
}

class _OperatorsScreenState extends ConsumerState<OperatorsScreen> {
  String _searchText = "";
  
  
  Future<void> _onDelete({required String operatorId}) async {
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

    final result = await ref.read(operatorProvider.notifier).deleteOperator(operatorId: operatorId);

    navigator.pop();
    
    if(result.key) navigator.pop(true);
    SnackBarHandler.instance.showMessage(message: result.value);
  }
  

  @override
  Widget build(BuildContext context) {
    final operators = ref.watch(operatorProvider.select((state) => state.operators));
    final filteredOperators = _searchText.isEmpty
        ? operators
        : operators.where((op) {
      final fullName = '${op.name}${op.surname}'.toLowerCase();
      final reversedFullName = "${op.surname}${op.name}".toLowerCase();
      return fullName.contains(_searchText) || reversedFullName.contains(_searchText);
    }).toList();


    if(filteredOperators.isEmpty) {
      return SliverFillRemaining(
        child: Column(
            spacing: 16,
            children: [
              const SizedBox(height: 32),
              Lottie.asset(
                  'assets/lottie/no_items.json',
                  height: 200
              ),
              Center(child: Text(Strings.no_operator_founded, textAlign: TextAlign.center,))
            ]
        )
      );
    }
    return SliverList.separated(
      itemBuilder: (context, index) {
        if(index == 0) {
          return Column(
              children: [
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: Strings.search,
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (value) {
                        setState(() => _searchText = value.replaceAll(" ", "").toLowerCase());
                      },
                    )
                ),

                const SizedBox(height: 15)
              ]
          );
        }
        final operator = filteredOperators[index - 1];
        return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Dismissible(
              key: Key(operator.id),
              background: Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(left: 20),
                child: CircleAvatar(
                  backgroundColor: Colors.red,
                  child: Icon(Icons.delete, color: Colors.white),
                )
              ),
              direction: DismissDirection.endToStart,
              confirmDismiss: (direction) async {
                final result = await showModalBottomSheet<bool>(
                  context: context,
                  isScrollControlled: true,
                  transitionAnimationController: AnimationController(
                    vsync: Navigator.of(context),
                    duration: Duration(milliseconds: 750),
                  ),
                  builder: (context) => DeleteModalBottomSheet(
                    onTap: () async => await _onDelete(operatorId: operator.id),
                  )
                );

                return result ?? false;
              },
              child: RowItem(
                text: "${operator.name} ${operator.surname}",
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    transitionAnimationController: AnimationController(
                      vsync: Navigator.of(context),
                      duration: Duration(milliseconds: 750)
                    ),
                    builder: (context) => OperatorUpdateModalBottomSheet(operatorDto: operator)
                  );
                },
                imgUrl: operator.imgUrl,
              )
            )
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemCount: filteredOperators.length + 1
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
