
import 'package:beauty_center_frontend/provider/room_provider.dart';
import 'package:beauty_center_frontend/widget/row_item.dart';
import 'package:beauty_center_frontend/widget/modal-bottom-sheet/room_update_modal_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

    if(rooms.isEmpty) {
      return SliverFillRemaining(child: Center(child: Text(Strings.no_room_created)));
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
                          prefixIcon: Icon(Icons.search),
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
                        onTap: () async => await _onDelete(roomId: room.id),
                      )
                  );

                  return result ?? false;
                },
                  child: RowItem(
                  icon: Icons.storefront,
                  text: room.name,
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      transitionAnimationController: AnimationController(
                        vsync: Navigator.of(context),
                        duration: Duration(milliseconds: 750)
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
