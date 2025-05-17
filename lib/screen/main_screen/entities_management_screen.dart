import 'package:beauty_center_frontend/screen/tool_screen.dart';
import 'package:beauty_center_frontend/widget/modal-bottom-sheet/tool_add_modal_bottom_sheet.dart';
import 'package:flutter/material.dart';

import '../../category.dart';
import '../../utils/strings.dart';
import '../../widget/custom_chip.dart';
import '../../widget/modal-bottom-sheet/operator_add_modal_bottom_sheet.dart';
import '../../widget/modal-bottom-sheet/room_add_modal_bottom_sheet.dart';
import '../../widget/modal-bottom-sheet/service_add_modal_bottom_sheet.dart';
import '../operator_screen.dart';
import '../room_screen.dart';
import '../services_screen.dart';
import '../users_screen.dart';

class EntitiesManagementScreen extends StatefulWidget {
  const EntitiesManagementScreen({super.key});

  @override
  State<EntitiesManagementScreen> createState() => _EntitiesManagementScreenState();
}


// todo vedere come mai non va bene l'update del service


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
              delegate: _HeaderDelegate(_buildCategoryRow(), _selectedCategory)
          ),

          SliverToBoxAdapter(child: const SizedBox(height: 25)),

          switch(_selectedCategory){
            Category.Servizi => ServicesScreen(),

            Category.Stanze => RoomsScreen(),

            Category.Operatori => OperatorsScreen(),

            Category.Utenti => UsersScreen(),

            Category.Macchinari => ToolScreen(),
          },

          SliverToBoxAdapter(child: const SizedBox(height: 80))
        ]
    );
  }
}


class _HeaderDelegate extends SliverPersistentHeaderDelegate {
  final List<Widget> categoryRow;
  final Category selectedCategory;

  _HeaderDelegate(this.categoryRow, this.selectedCategory);

  @override
  double get minExtent => 220;
  @override
  double get maxExtent => 220;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    String title = switch(selectedCategory) {
      Category.Servizi => Strings.services,
      Category.Operatori => Strings.operators,
      Category.Stanze => Strings.rooms,
      Category.Utenti => Strings.customers,
      Category.Macchinari => Strings.tools
    };

    return Column(
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

                    PopupMenuButton(
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              transitionAnimationController: AnimationController(
                                vsync: Navigator.of(context),
                                duration: Duration(milliseconds: 500)
                              ),
                              builder: (context) => ServiceAddModalBottomSheet()
                            );
                          },
                          child: Text(Strings.add_service, style: Theme.of(context).textTheme.labelMedium)
                        ),
                        PopupMenuItem(
                            onTap: () {
                              showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  transitionAnimationController: AnimationController(
                                      vsync: Navigator.of(context),
                                      duration: Duration(milliseconds: 500)
                                  ),
                                  builder: (context) => OperatorAddModalBottomSheet()
                              );
                            },
                            child: Text(Strings.add_operator, style: Theme.of(context).textTheme.labelMedium)
                        ),
                        PopupMenuItem(
                            onTap: () {
                              showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  transitionAnimationController: AnimationController(
                                      vsync: Navigator.of(context),
                                      duration: Duration(milliseconds: 500)
                                  ),
                                  builder: (context) => RoomAddModalBottomSheet()
                              );
                            },
                            child: Text(Strings.add_room, style: Theme.of(context).textTheme.labelMedium)
                        ),
                        PopupMenuItem(
                            onTap: () {
                              showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  transitionAnimationController: AnimationController(
                                      vsync: Navigator.of(context),
                                      duration: Duration(milliseconds: 500)
                                  ),
                                  builder: (context) => ToolAddModalBottomSheet()
                              );
                            },
                          child: Text(Strings.add_tool, style: Theme.of(context).textTheme.labelMedium)
                        ),
                        PopupMenuItem(
                            onTap: () => Navigator.pushNamed(context, "/book"),
                            child: Text(Strings.book_service, style: Theme.of(context).textTheme.labelMedium)
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
