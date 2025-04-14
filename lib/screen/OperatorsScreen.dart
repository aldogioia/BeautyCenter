import 'package:beauty_center_frontend/model/OperatorDto.dart';
import 'package:beauty_center_frontend/provider/operator_provider.dart';
import 'package:beauty_center_frontend/widget/CustomDialog.dart';
import 'package:beauty_center_frontend/widget/DeletePopUp.dart';
import 'package:beauty_center_frontend/widget/RowItem.dart';
import 'package:beauty_center_frontend/widget/modal-bottom-sheet/CustomModalBottomSheet.dart';
import 'package:beauty_center_frontend/widget/modal-bottom-sheet/OperatorUpdateModalBottomSheet.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/strings.dart';
import '../widget/CustomTextField.dart';

class OperatorsScreen extends ConsumerStatefulWidget {
  const OperatorsScreen({super.key});

  @override
  ConsumerState<OperatorsScreen> createState() => _OperatorsScreenState();
}

class _OperatorsScreenState extends ConsumerState<OperatorsScreen> {
  final _searchController = TextEditingController();

  void _showUpdateModalBottomSheet({required OperatorDto operator}){
    CustomModalBottomSheet.show(
      child: OperatorUpdateModalBottomSheet(operatorDto: operator),
      context: context
    );
  }

  @override
  Widget build(BuildContext context) {
    final operators = ref.watch(operatorProvider.select((state) => state.operators));


    return SliverList.separated(
      itemBuilder: (context, index) {
        if(index == 0) {
          return Column(
              children: [
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: CustomTextField(
                      hintText: Strings.search,
                      prefixIcon: Icons.search,
                      controller: _searchController,
                      onChanged: (value){},     // todo search operator
                    )
                ),

                const SizedBox(height: 15)
              ]
          );
        }
        final operator = operators[index - 1];
        return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: RowItem(
              text: "${operator.name} ${operator.surname}",
              onTap: () => _showUpdateModalBottomSheet(operator: operator),
              onLongPress: () {
                CustomDialog.show(
                  child: DeletePopUp(
                    article: "l'",
                    entityToDelete: Strings.operator,
                    onDelete: () async {
                      return await ref.read(operatorProvider.notifier).deleteOperator(operatorId: operator.id);
                    }
                  ),
                  context: context
                );
              },
              imgUrl: operator.imgUrl,
            )
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemCount: operators.length + 1
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
