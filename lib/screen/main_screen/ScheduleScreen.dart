import 'package:flutter/material.dart';

import '../../utils/Strings.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPersistentHeader(
          pinned: true,
          delegate: _HeaderDelegate()
        ),

        SliverToBoxAdapter(child: const SizedBox(height: 25)),

        // todo

        SliverToBoxAdapter(child: const SizedBox(height: 80))
      ]
    );
  }
}


class _HeaderDelegate extends SliverPersistentHeaderDelegate {
  _HeaderDelegate();

  @override
  double get minExtent => 150;
  @override
  double get maxExtent => 150;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Column(
        children: [
          const SizedBox(height: 80),

          Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      Text(Strings.hello, style: Theme.of(context).textTheme.headlineLarge),

                      // todo prendere il nome dal backend
                      Text("Nome", style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: Theme.of(context).colorScheme.primary)),
                    ]),

                    GestureDetector(
                        onTap: () {}, //todo
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
