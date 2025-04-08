import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Category.dart';
import '../../utils/Strings.dart';
import '../../widget/CustomChip.dart';
import '../../widget/modal-bottom-sheet/CustomModalBottomSheet.dart';
import '../../widget/modal-bottom-sheet/OperatorAddModalBottomSheet.dart';
import '../../widget/modal-bottom-sheet/RoomAddModalBottomSheet.dart';
import '../../widget/modal-bottom-sheet/ServiceAddModalBottomSheet.dart';
import '../OperatorsScreen.dart';
import '../RoomsScreen.dart';
import '../ServicesScreen.dart';
import '../UsersScreen.dart';

class EntitiesManagementScreen extends StatefulWidget {
  const EntitiesManagementScreen({super.key});

  @override
  State<EntitiesManagementScreen> createState() => _EntitiesManagementScreenState();
}

class _EntitiesManagementScreenState extends State<EntitiesManagementScreen> {
  Category _selectedCategory = Category.Servizi;

  List<Widget> _buildCategoryRow(){
    List<Widget> widgets = [const SizedBox(width: 20)];
    int length = Category.values.length;

    for(int i = 0; i < length; i++){
      Category category = Category.values[i];
      widgets.add(CustomChip(
        onTap: () {
          if(_selectedCategory != category) setState(() => _selectedCategory = category);
        },
        isSelected: category == _selectedCategory,
        text: category.name,
      ));

      if(i < length - 1) widgets.add(const SizedBox(width: 10));
    }

    widgets.add(const SizedBox(width: 20));
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
        slivers: [
          SliverPersistentHeader(
              pinned: true,
              delegate: _HeaderDelegate(_buildCategoryRow())
          ),

          SliverToBoxAdapter(child: const SizedBox(height: 25)),

          switch(_selectedCategory){
            Category.Servizi => ServicesScreen(),

            Category.Stanze => RoomsScreen(),

            Category.Operatori => OperatorsScreen(),

            Category.Utenti => UsersScreen(),
          },

          SliverToBoxAdapter(child: const SizedBox(height: 80))
        ]
    );
  }
}


class _HeaderDelegate extends SliverPersistentHeaderDelegate {
  final List<Widget> categoryRow;

  _HeaderDelegate(this.categoryRow);

  @override
  double get minExtent => 220;
  @override
  double get maxExtent => 220;

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

                    PopupMenuButton(
                      itemBuilder: (context) => [
                        PopupMenuItem(
                            onTap: () => CustomModalBottomSheet.show(context: context, child: ServiceAddModalBottomSheet()),
                            child: Text(Strings.add_service, style: Theme.of(context).textTheme.labelMedium)
                        ),
                        PopupMenuItem(
                            onTap: () => CustomModalBottomSheet.show(context: context, child: OperatorAddModalBottomSheet()),
                            child: Text(Strings.add_operator, style: Theme.of(context).textTheme.labelMedium)
                        ),
                        PopupMenuItem(
                            onTap: () => CustomModalBottomSheet.show(context: context, child: RoomAddModalBottomSheet()),
                            child: Text(Strings.add_room, style: Theme.of(context).textTheme.labelMedium)
                        )
                      ],
                      child: Icon(Icons.add, size: 24),
                    )
                  ]
              )
          ),

          const SizedBox(height: 25),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: categoryRow),
          )
        ]
    );
  }

  @override
  bool shouldRebuild(covariant _HeaderDelegate oldDelegate) {
    return oldDelegate.categoryRow != categoryRow;
  }
}
