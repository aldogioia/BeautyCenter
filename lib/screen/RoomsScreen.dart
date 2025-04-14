
import 'package:beauty_center_frontend/provider/room_provider.dart';
import 'package:beauty_center_frontend/widget/RowItem.dart';
import 'package:beauty_center_frontend/widget/modal-bottom-sheet/CustomModalBottomSheet.dart';
import 'package:beauty_center_frontend/widget/modal-bottom-sheet/RoomUpdateModalBottomSheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/strings.dart';
import '../widget/CustomDialog.dart';
import '../widget/CustomTextField.dart';
import '../widget/DeletePopUp.dart';

class RoomsScreen extends ConsumerStatefulWidget {
  const RoomsScreen({super.key});

  @override
  ConsumerState<RoomsScreen> createState() => _RoomsScreenState();
}

class _RoomsScreenState extends ConsumerState<RoomsScreen> {
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final rooms = ref.watch(roomProvider.select((state) => state.rooms));

    return SliverList.separated(
        itemBuilder: (context, index) {
          if(index == 0) {
            return Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: CustomTextField(
                        hintText: Strings.search,
                        prefixIcon: Icons.search,
                        controller: _searchController,
                        onChanged: (value){},     // todo search room
                      )
                  ),

                  const SizedBox(height: 15)
                ]
            );
          }
          final room = rooms[index - 1];
          return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: RowItem(
                icon: Icons.storefront,
                text: room.name,
                onTap: () => CustomModalBottomSheet.show(child: RoomUpdateModalBottomSheet(roomDto: room), context: context),
                onLongPress: () {
                  CustomDialog.show(
                    child: DeletePopUp(
                      article: "la",
                      entityToDelete: Strings.room.toLowerCase(),
                      onDelete: () async {
                        return await ref.read(roomProvider.notifier).deleteRoom(roomId: room.id);
                      }
                    ),
                      context: context
                  );
                },
              )
          );
        },
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemCount: rooms.length + 1
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
