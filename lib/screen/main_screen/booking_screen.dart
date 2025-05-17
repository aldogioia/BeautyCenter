import 'package:beauty_center_frontend/model/summary_operator_dto.dart';
import 'package:beauty_center_frontend/provider/booking_provider.dart';
import 'package:beauty_center_frontend/widget/booking_widget.dart';
import 'package:beauty_center_frontend/widget/modal-bottom-sheet/booking_filter_modal_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

import '../../handler/snack_bar_handler.dart';
import '../../model/BookingDto.dart';
import '../../model/enumerators/role.dart';
import '../../provider/operator_provider.dart';
import '../../utils/date_util.dart';
import '../../utils/strings.dart';
import '../../widget/modal-bottom-sheet/delete_modal_bottom_sheet.dart';

class BookingScreen extends ConsumerStatefulWidget {
  const BookingScreen({super.key});

  @override
  ConsumerState<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends ConsumerState<BookingScreen> {

  SummaryOperatorDto? _selectedOperator;
  late DateTime _selectedDate;

  Widget _buildEmptyOperatorBookings(){
    return SliverToBoxAdapter(
        child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
                children: [
                  Row(
                      children: [
                        Text(
                          "${Strings.filter_for}: ",
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                        ),

                        Text(
                          "${_selectedOperator!.name} ${_selectedOperator!.surname}",
                        ),
                      ]
                  ),

                  const SizedBox(height: 25),

                  Column(
                      spacing: 16,
                      children: [
                        const SizedBox(height: 32),
                        Lottie.asset(
                            'assets/lottie/no_items.json',
                            height: 200
                        ),
                        const Text(Strings.not_booking_for_the_selected_operator, textAlign: TextAlign.center)
                      ]
                  )
                ]
            )
        )
    );
  }


  Future<void> _onDelete({required String bookingId}) async {
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

    final result = await ref.read(bookingProvider.notifier).deleteBooking(bookingId: bookingId);

    navigator.pop();

    if(result.key) navigator.pop();
    SnackBarHandler.instance.showMessage(message: result.value);
  }


  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final List<BookingDto> operatorBookings = ref.watch(bookingProvider).operatorBookings;
    _selectedOperator = ref.watch(bookingProvider).selectedOperator;

    return Stack(
      children: [
        CustomScrollView(
            slivers: [
              SliverPersistentHeader(
                  pinned: true,
                  delegate: _HeaderDelegate(
                      onSelect: (DateTime date){
                        setState(() {
                          _selectedDate = date;
                        });
                      })
              ),

              SliverToBoxAdapter(child: const SizedBox(height: 25)),

              if(_selectedOperator != null) ...[

                if(operatorBookings.isEmpty)_buildEmptyOperatorBookings()
                else ...[
                  SliverToBoxAdapter(
                      child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                              children: [
                                Text(
                                  "${Strings.filter_for}: ",
                                ),

                                Text(
                                  "${_selectedOperator!.name} ${_selectedOperator!.surname} il ${_selectedDate.day} ${DateUtil.getItalianMonthName(month: _selectedDate.month)}",
                                )
                              ]
                          )
                      )
                  ),

                  SliverToBoxAdapter(child: const SizedBox(height: 25)),

                  SliverList(
                      delegate: SliverChildBuilderDelegate(
                          childCount: operatorBookings.length,
                              (context, index) {
                            final booking =  operatorBookings[index];

                            return Column(
                                children: [
                                  Dismissible(
                                      key: Key(booking.id),
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
                                              onTap: () async => await _onDelete(bookingId: booking.id),
                                            )
                                        );

                                        return result ?? false;
                                      },
                                      child: BookingWidget(booking: booking)
                                  ),

                                  if(index != operatorBookings.length - 1) const SizedBox(height: 25)
                                ]
                            );
                          }
                      )
                  )
                ]
              ] else ...[
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
                  ),
                )
              ],

              SliverToBoxAdapter(child: const SizedBox(height: 80))
            ]
        ),

        Visibility(
            visible: ref.read(operatorProvider).role == Role.ROLE_OPERATOR,
            child: Positioned(
                bottom: 20,
                right: 20,
                child:  FloatingActionButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                    onPressed: () => Navigator.pushNamed(context, "/book"),
                    child: Icon(Icons.add)
                )
            )
        )
      ]
    );
  }
}



class _HeaderDelegate extends SliverPersistentHeaderDelegate {
  _HeaderDelegate({required this.onSelect});

  final void Function(DateTime) onSelect;

  @override
  double get minExtent => 150;
  @override
  double get maxExtent => 150;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final TextStyle? headlineLarge = Theme.of(context).textTheme.headlineLarge;

    return Column(
        children: [
          const SizedBox(height: 80),

          Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      Text(Strings.bookings, style: headlineLarge),
                    ]),

                    GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              transitionAnimationController: AnimationController(
                                  vsync: Navigator.of(context),
                                  duration: Duration(milliseconds: 750)
                              ),
                              builder: (context) => BookingFilterModalBottomSheet(onSelect: onSelect)
                          );
                        },
                        child:  Icon(Icons.filter_list_outlined, size: 24)
                    )

                  ]
              )
          )
        ]
    );
  }

  @override
  bool shouldRebuild(covariant _HeaderDelegate oldDelegate) {
    return false;
  }
}