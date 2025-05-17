import 'package:beauty_center_frontend/provider/tool_provider.dart';
import 'package:beauty_center_frontend/widget/modal-bottom-sheet/tool_update_modal_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';

import '../handler/snack_bar_handler.dart';
import '../utils/Strings.dart';
import '../widget/modal-bottom-sheet/delete_modal_bottom_sheet.dart';
import '../widget/row_item.dart';

class ToolScreen extends ConsumerStatefulWidget {
  const ToolScreen({super.key});

  @override
  ConsumerState<ToolScreen> createState() => _ToolScreenState();
}

class _ToolScreenState extends ConsumerState<ToolScreen> {
  String _searchText = "";


  Future<void> _onDelete({required String id}) async {
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

    final result = await ref.read(toolProvider.notifier).deleteTool(id: id);

    navigator.pop();

    if(result.key) navigator.pop(true);
    SnackBarHandler.instance.showMessage(message: result.value);
  }


  @override
  Widget build(BuildContext context) {
    final tools = ref.watch(toolProvider).tools;
    final filteredTools = _searchText.isEmpty
        ? tools
        : tools.where((t) => t.name.contains(_searchText)).toList();

    if(filteredTools.isEmpty){
      return SliverFillRemaining(
          child: Column(
              spacing: 16,
              children: [
                const SizedBox(height: 32),
                Lottie.asset(
                    'assets/lottie/no_items.json',
                    height: 200
                ),
                Center(child: Text(Strings.no_tool_founded, textAlign: TextAlign.center,))
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
                            prefixIcon: Icon(FontAwesomeIcons.magnifyingGlass),
                          ),
                          onChanged: (value){
                            setState(() => _searchText = value.toLowerCase());
                          }
                      )
                  ),

                  const SizedBox(height: 15)
                ]
            );
          }
          final tool = filteredTools[index - 1];
          return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),

              child: Dismissible(
                  key: Key(tool.id),
                  background: Container(
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(left: 20),
                      child: CircleAvatar(
                        backgroundColor: Colors.red,
                        child: Icon(FontAwesomeIcons.trash, color: Colors.white),
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
                          onTap: () async => await _onDelete(id: tool.id),
                        )
                    );

                    return result ?? false;
                  },
                  child: RowItem(
                      icon: FontAwesomeIcons.spa, // todo non so se va bene
                      text: tool.name,
                      onTap: () {
                        showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            transitionAnimationController: AnimationController(
                                vsync: Navigator.of(context),
                                duration: Duration(milliseconds: 500)
                            ),
                            builder: (context) => ToolUpdateModalBottomSheet(toolDto: tool)
                        );
                      }
                  )
              )
          );
        },
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemCount: filteredTools.length + 1
    );
  }
}
