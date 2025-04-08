import 'package:beauty_center_frontend/model/SummaryOperatorDto.dart';
import 'package:beauty_center_frontend/provider/BookingProvider.dart';
import 'package:beauty_center_frontend/widget/BookingWidget.dart';
import 'package:beauty_center_frontend/widget/modal-bottom-sheet/BookingFilterModalBottomSheet.dart';
import 'package:beauty_center_frontend/widget/modal-bottom-sheet/CustomModalBottomSheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/BookingDto.dart';
import '../../model/OperatorDto.dart';
import '../../provider/OperatorProvider.dart';
import '../../utils/DateUtil.dart';
import '../../utils/Strings.dart';

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
                          style: Theme.of(context).textTheme.displayMedium?.copyWith(fontWeight: FontWeight.w500),
                        ),

                        Text(
                          "${_selectedOperator!.name} ${_selectedOperator!.surname}",
                          style: Theme.of(context).textTheme.displayMedium,
                        ),
                      ]
                  ),

                  const SizedBox(height: 25),

                  Text(
                    Strings.not_booking_for_the_selected_operator,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(overflow: TextOverflow.visible),
                  ),
                ]
            )
        )
    );
  }

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final operators = ref.read(operatorProvider).operators;
      if (operators.isNotEmpty) {
        final operator = operators[0];
         _selectedOperator = SummaryOperatorDto(
            id: operator.id,
            name: operator.name,
            surname: operator.surname,
            imgUrl: operator.imgUrl
          );
         ref.read(bookingProvider.notifier).getOperatorBookings(operatorId: operator.id, date: _selectedDate);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<BookingDto> operatorBookings = ref.watch(bookingProvider).operatorBookings;

    return CustomScrollView(
        slivers: [
          SliverPersistentHeader(
              pinned: true,
              delegate: _HeaderDelegate(
                onSelect: (DateTime date , OperatorDto operator){
                  setState(() {
                    _selectedDate = date;
                    _selectedOperator = SummaryOperatorDto(
                        id: operator.id,
                        name: operator.name,
                        surname: operator.surname,
                        imgUrl: operator.imgUrl
                    );
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
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(fontWeight: FontWeight.w600),
                      ),

                      Text(
                        "${_selectedOperator!.name} ${_selectedOperator!.surname} il ${_selectedDate.day} ${DateUtil.getItalianMonthName(month: _selectedDate.month)}",
                        style: Theme.of(context).textTheme.displayMedium,
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
                    return Column(
                      children: [
                        BookingWidget(booking: operatorBookings[index]),

                        if(index != operatorBookings.length - 1) const SizedBox(height: 25)
                      ]
                    );
                  }
                )
              )
            ]
          ] else ...[
            Text(
              Strings.no_operators_found,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(overflow: TextOverflow.visible),
            )
          ],

          SliverToBoxAdapter(child: const SizedBox(height: 80))
        ]
    );
  }
}



class _HeaderDelegate extends SliverPersistentHeaderDelegate {
  _HeaderDelegate({required this.onSelect});

  final void Function(DateTime, OperatorDto) onSelect;

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
                      Text(Strings.hello, style: headlineLarge),

                      // todo prendere il nome dal backend
                      Text("Nome", style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: Theme.of(context).colorScheme.primary)),
                    ]),

                    GestureDetector(
                        onTap: () {
                          CustomModalBottomSheet.show(
                            child: BookingFilterModalBottomSheet(onSelect: onSelect),
                            context: context
                          );
                        },
                        child:  Icon(Icons.filter_list_outlined, size: 24)   // todo da cambiare,
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