
import 'package:beauty_center_frontend/provider/room_provider.dart';
import 'package:beauty_center_frontend/widget/row_item.dart';
import 'package:beauty_center_frontend/widget/modal-bottom-sheet/room_update_modal_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';

import '../handler/snack_bar_handler.dart';
import '../utils/strings.dart';
import '../widget/modal-bottom-sheet/delete_modal_bottom_sheet.dart';

class RoomsScreen extends ConsumerStatefulWidget {
  const RoomsScreen({super.key});

  @override
  ConsumerState<RoomsScreen> createState() => _RoomsScreenState();
}

class _RoomsScreenState extends ConsumerState<RoomsScreen> {
  String _searchText = "";


  Future<void> _onDelete({required String roomId}) async {
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

    final result = await ref.read(roomProvider.notifier).deleteRoom(roomId: roomId);

    navigator.pop();

    if(result.key) navigator.pop(true);
    SnackBarHandler.instance.showMessage(message: result.value);
  }


  @override
  Widget build(BuildContext context) {
    final rooms = ref.watch(roomProvider.select((state) => state.rooms));
    final filteredRooms = _searchText.isEmpty
        ? rooms
        : rooms.where((r) => r.name.toLowerCase().contains(_searchText)).toList();

    if(filteredRooms.isEmpty) {
      return SliverFillRemaining(
        child: Column(
            spacing: 16,
            children: [
              const SizedBox(height: 32),
              Lottie.asset(
                  'assets/lottie/no_items.json',
                  height: 200
              ),
              Center(child: Text(Strings.no_room_founded, textAlign: TextAlign.center,))
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
          final room = filteredRooms[index - 1];
          return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Dismissible(
                key: Key(room.id),
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
                        onTap: () async => await _onDelete(roomId: room.id),
                      )
                  );

                  return result ?? false;
                },
                  child: RowItem(
                  icon: FontAwesomeIcons.store,
                  text: room.name,
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      transitionAnimationController: AnimationController(
                        vsync: Navigator.of(context),
                        duration: Duration(milliseconds: 500)
                      ),
                      builder: (context) => RoomUpdateModalBottomSheet(roomDto: room)
                    );
                  }
                )
              )
          );
        },
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemCount: filteredRooms.length + 1
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
