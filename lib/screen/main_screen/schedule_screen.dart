import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:beauty_center_frontend/model/day_of_week.dart';
import 'package:beauty_center_frontend/model/schedule_exceptions_dto.dart';
import 'package:beauty_center_frontend/provider/schedule_exception_provider.dart';
import 'package:beauty_center_frontend/widget/modal-bottom-sheet/schedule_exceptions_modal_bottom_sheet.dart';
import 'package:beauty_center_frontend/widget/modal-bottom-sheet/schedule_filter_modal_bottom_sheet.dart';
import 'package:beauty_center_frontend/widget/schedule_exceptions_widget.dart';
import 'package:beauty_center_frontend/widget/schedule_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

import '../../handler/snack_bar_handler.dart';
import '../../model/summary_operator_dto.dart';
import '../../model/enumerators/role.dart';
import '../../model/standard_schedule_dto.dart';
import '../../provider/operator_provider.dart';
import '../../provider/standard_schedule_provider.dart';
import '../../utils/strings.dart';
import '../../widget/modal-bottom-sheet/delete_modal_bottom_sheet.dart';

class ScheduleScreen extends ConsumerStatefulWidget {
  const ScheduleScreen({super.key});

  @override
  ConsumerState<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends ConsumerState<ScheduleScreen> {
  int _selectedIndex = 0;
  SummaryOperatorDto? _selectedOperator;


  Future<void> _onDelete({required String scheduleId}) async {
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

    final result = await ref.read(scheduleExceptionProvider.notifier).deleteScheduleException(scheduleId: scheduleId);

    navigator.pop();

    if(result.key) navigator.pop(true);
    SnackBarHandler.instance.showMessage(message: result.value);
  }


  Widget _buildScheduleWidget({required ScheduleExceptionsDto schedule}){
    if(ref.read(operatorProvider).role == Role.ROLE_ADMIN) {
      return Dismissible(
        key: Key(schedule.id),
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
                duration: Duration(milliseconds: 500),
              ),
              builder: (context) => DeleteModalBottomSheet(
                onTap: () async => await _onDelete(scheduleId: schedule.id),
              )
          );

          return result ?? false;
        },
        child: ScheduleExceptionsWidget(schedule: schedule),
      );
    } else {
      return ScheduleExceptionsWidget(schedule: schedule);
    }
  }


  @override
  Widget build(BuildContext context) {
    final Color primary = Theme.of(context).colorScheme.primary.withAlpha((255 * 0.25).toInt());

    final operatorStandardSchedules = ref.watch(standardScheduleProvider).operatorStandardSchedules;
    final operatorScheduleExceptions = ref.watch(scheduleExceptionProvider).operatorScheduleException;

    final role = ref.read(operatorProvider).role;

    _selectedOperator = ref.watch(scheduleExceptionProvider).selectedOperator;


    return Stack(
      children: [
        CustomScrollView(
            slivers: [
              SliverPersistentHeader(
                  pinned: true,
                  delegate: _HeaderDelegate(
                    title: _selectedIndex == 0 ? Strings.schedules : Strings.schedule_exception,
                    screenIndex: _selectedIndex,
                    role: role
                  )
              ),

              SliverToBoxAdapter(child: const SizedBox(height: 25)),

              SliverToBoxAdapter(
                  child: Center(
                    child: AnimatedToggleSwitch<int>.size(
                        current: _selectedIndex,
                        onChanged: (index) => setState(() => _selectedIndex = index),
                        spacing: 8.0,
                        indicatorSize: Size.fromWidth(120),
                        iconList: [
                          Text(Strings.schedules),
                          Text(Strings.changes)
                        ],
                        style: ToggleStyle(
                          backgroundColor: Colors.transparent,
                          borderColor: primary,
                          indicatorColor: primary,
                          borderRadius: BorderRadius.circular(22),
                          indicatorBorderRadius: BorderRadius.circular(20),
                        ),
                        values: [0, 1]
                    ),
                  )
              ),

              SliverToBoxAdapter(child: const SizedBox(height: 25)),

              if(_selectedOperator != null && ref.read(operatorProvider).role == Role.ROLE_ADMIN) ...[
                SliverToBoxAdapter(
                    child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                            children: [
                              Text("${Strings.filter_for}: "),

                              Text("${_selectedOperator!.name} ${_selectedOperator!.surname}",)
                            ]
                        )
                    )
                ),
              ] else if(_selectedOperator == null) ...[
                SliverToBoxAdapter(
                  child: Column(
                      spacing: 16,
                      children: [
                        const SizedBox(height: 32),
                        Lottie.asset(
                            'assets/lottie/no_items.json',
                            height: 200
                        ),
                        const Text(
                          Strings.no_operators_found,
                          textAlign: TextAlign.center,
                        )
                      ]
                  )
                )
              ],

              if(_selectedOperator != null && _selectedIndex == 0) ...[
                SliverToBoxAdapter(child: const SizedBox(height: 25)),

                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                          childCount: DayOfWeek.values.length,
                          (context, index) {
                            final matches = operatorStandardSchedules.where(
                                  (dto) => dto.day == DayOfWeek.values[index],
                            );

                            final StandardScheduleDto? schedule = matches.isNotEmpty ? matches.first : null;
                            return Column(
                                children: [
                                  AbsorbPointer(
                                    absorbing: ref.read(operatorProvider).role == Role.ROLE_OPERATOR,
                                    child: ScheduleWidget(
                                      schedule: schedule,
                                      isNewSchedule: schedule == null,
                                      day: schedule != null ? null : DayOfWeek.values[index],
                                      operatorId: _selectedOperator!.id,
                                    )
                                  ),
                                  if(index != DayOfWeek.values.length - 1) const SizedBox(height: 30)
                                ]
                            );
                          }
                      )
                  ),
                )

              ] else if(_selectedOperator != null) ...[
                if(operatorScheduleExceptions.isEmpty) ...[
                  SliverFillRemaining(
                    child: Column(
                        spacing: 16,
                        children: [
                          const SizedBox(height: 32),
                          Lottie.asset(
                              'assets/lottie/no_items.json',
                              height: 200
                          ),
                          Center(child: Text(Strings.operator_does_not_have_schedule_exceptions, textAlign: TextAlign.center,)),
                        ]
                    )
                  )
                ] else ...[
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                            childCount: operatorScheduleExceptions.length,
                            (context, index) {

                              final schedule = operatorScheduleExceptions[index];
                              return Column(
                                  children: [
                                    _buildScheduleWidget(schedule: schedule),
                                    if(index != DayOfWeek.values.length - 1) const SizedBox(height: 30)
                                  ]
                              );
                            }
                        )
                    )
                  )
                ]
              ],

              SliverToBoxAdapter(child: const SizedBox(height: 80))
            ]
        ),

        Visibility(
          visible: !(_selectedIndex == 0 && ref.read(operatorProvider).role == Role.ROLE_ADMIN),
          child: Positioned(
            bottom: 20,
            right: 20,
            child:  FloatingActionButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
              onPressed: () {
                if(_selectedIndex == 1 && _selectedOperator != null && ref.read(operatorProvider).role == Role.ROLE_ADMIN){
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      transitionAnimationController: AnimationController(
                          vsync: Navigator.of(context),
                          duration: Duration(milliseconds: 500)
                      ),
                      builder: (context) => ScheduleExceptionsModalBottomSheet(operatorId: _selectedOperator!.id)
                  );
                } else if (ref.read(operatorProvider).role == Role.ROLE_OPERATOR) {
                  Navigator.pushNamed(context, "/book");
                }
              },
              child: Icon(Icons.add)
            )
          )
        )
      ]
    );
  }
}


class _HeaderDelegate extends SliverPersistentHeaderDelegate {
  _HeaderDelegate({
    required this.screenIndex,
    required this.role,
    required this.title
  });

  final int screenIndex;
  final String title;
  final Role role;

  @override
  double get minExtent => 150;
  @override
  double get maxExtent => 150;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: Column(
          children: [
            const SizedBox(height: 80),

            Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 10),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [
                        Text(title, style: Theme.of(context).textTheme.headlineLarge),
                      ]),

                      if(role == Role.ROLE_ADMIN) ...[
                        GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  transitionAnimationController: AnimationController(
                                      vsync: Navigator.of(context),
                                      duration: Duration(milliseconds: 750)
                                  ),
                                  builder: (context) => ScheduleFilterModalBottomSheet(
                                    screenIndex: screenIndex,
                                  )
                              );
                            },
                            child:  Icon(Icons.filter_list_outlined, size: 24)
                        )
                      ]
                    ]
                )
            )
          ]
      )
    );
  }

  @override
  bool shouldRebuild(covariant _HeaderDelegate oldDelegate) {
    return false;
  }
}
