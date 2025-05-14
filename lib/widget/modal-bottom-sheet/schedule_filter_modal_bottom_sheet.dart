import 'package:beauty_center_frontend/provider/schedule_exception_provider.dart';
import 'package:beauty_center_frontend/provider/standard_schedule_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../handler/snack_bar_handler.dart';
import '../../model/OperatorDto.dart';
import '../../model/SummaryOperatorDto.dart';
import '../../provider/operator_provider.dart';
import '../../utils/strings.dart';
import '../operator_widget.dart';

class ScheduleFilterModalBottomSheet extends ConsumerStatefulWidget {
  const ScheduleFilterModalBottomSheet({
    super.key,
    required this.onSelect,
    required this.screenIndex
  });

  final void Function(OperatorDto) onSelect;
  final int screenIndex;

  @override
  ConsumerState<ScheduleFilterModalBottomSheet> createState() => _ScheduleFilterModalBottomSheetState();
}

class _ScheduleFilterModalBottomSheetState extends ConsumerState<ScheduleFilterModalBottomSheet> {
  OperatorDto? _selectedOperator;


  Future<void> _setFilter() async {
    final navigator = Navigator.of(context);
    final MapEntry<bool, String> result;
    final MapEntry<bool, String> result2;

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
    );

    result = await ref.read(standardScheduleProvider.notifier).getOperatorStandardSchedules(operatorId: _selectedOperator!.id);
    result2 = await ref.read(scheduleExceptionProvider.notifier).getOperatorSchedulesException(operatorId: _selectedOperator!.id);

    navigator.pop();

    if(result.key && result2.key) {
      navigator.pop();
      widget.onSelect(_selectedOperator!);
    }
    else {
      SnackBarHandler.instance.showMessage(message: result.value);
      // todo vedere come gestire l'errore per result2
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<OperatorDto> operators = ref.watch(operatorProvider).operators;

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
                                    Strings.select_operator,
                                    style: Theme.of(context).textTheme.bodyLarge,
                                  ),


                                  if(_selectedOperator != null)...[
                                    GestureDetector(
                                        onTap: () async => await _setFilter(),
                                        child: Text(
                                          Strings.select_filter,
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
                                Padding(
                                    padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20),
                                    child: SizedBox(
                                      height: 140,
                                      child: ListView.separated(
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context, index) {
                                            if(index == operators.length) return const SizedBox(width: 10);

                                            final operator = operators[index];
                                            final summaryDto = SummaryOperatorDto(
                                                id: operator.id,
                                                name: operator.name,
                                                surname: operator.surname,
                                                imgUrl: operator.imgUrl
                                            );
                                            return OperatorWidget(
                                                isSelected: _selectedOperator != null && _selectedOperator!.id == operator.id,
                                                operator: summaryDto,
                                                onTap: () => setState(() {
                                                  _selectedOperator = operator;
                                                })
                                            );
                                          },
                                          separatorBuilder: (context, index) => const SizedBox(width: 10),
                                          itemCount: operators.length + 1
                                      ),
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
}
