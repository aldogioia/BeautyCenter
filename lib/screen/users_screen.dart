import 'package:beauty_center_frontend/provider/customer_provider.dart';
import 'package:beauty_center_frontend/widget/row_item.dart';
import 'package:beauty_center_frontend/widget/modal-bottom-sheet/customer_update_modal_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/strings.dart';

class UsersScreen extends ConsumerStatefulWidget {
  const UsersScreen({super.key});

  @override
  ConsumerState<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends ConsumerState<UsersScreen> {
  String _searchText = "";

  @override
  Widget build(BuildContext context) {
    final customers = ref.watch(customerProvider.select((state) => state.customers));
    final filteredCustomers = _searchText.isEmpty
        ? customers
        : customers.where((c){
          final fullName = "${c.name}${c.surname}".toLowerCase();
          final reversedFullName = "${c.surname}${c.name}".toLowerCase();
          return fullName.contains(_searchText) || reversedFullName.contains(_searchText);
    }).toList();

    if(customers.isEmpty) {
      return SliverFillRemaining(child: Center(child: Text(Strings.no_customer)));
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
                          setState(() => _searchText = value.replaceAll(" ", "").toLowerCase());
                        },
                      )
                  ),

                  const SizedBox(height: 15)
                ]
            );
          }
          final customer = filteredCustomers[index - 1];
          return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child:  RowItem(
                icon: Icons.account_circle_outlined,
                text: "${customer.name} ${customer.surname}",
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      transitionAnimationController: AnimationController(
                          vsync: Navigator.of(context),
                          duration: Duration(milliseconds: 750)
                      ),
                      builder: (context) => CustomerUpdateModalBottomSheet(customerDto: customer)
                  );
                }
              )
          );
        },
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemCount:  filteredCustomers.length + 1
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
