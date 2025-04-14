import 'package:beauty_center_frontend/provider/customer_provider.dart';
import 'package:beauty_center_frontend/widget/RowItem.dart';
import 'package:beauty_center_frontend/widget/modal-bottom-sheet/CustomModalBottomSheet.dart';
import 'package:beauty_center_frontend/widget/modal-bottom-sheet/CustomerUpdateModalBottomSheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/strings.dart';
import '../widget/CustomTextField.dart';

class UsersScreen extends ConsumerStatefulWidget {
  const UsersScreen({super.key});

  @override
  ConsumerState<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends ConsumerState<UsersScreen> {
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final customers = ref.watch(customerProvider.select((state) => state.customers));

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
          final customer = customers[index - 1];
          return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child:  RowItem(
                icon: Icons.account_circle_outlined,
                text: "${customer.name} ${customer.surname}",
                onTap: () => CustomModalBottomSheet.show(
                  child: CustomerUpdateModalBottomSheet(customerDto: customer),
                  context: context
                )
              )
          );
        },
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemCount:  customers.length + 1
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
