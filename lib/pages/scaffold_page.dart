import 'package:edone_customer/pages/service_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/global_provider.dart';
import '../utils/strings.dart';
import 'booking_page.dart';

class ScaffoldPage extends ConsumerStatefulWidget {
  const ScaffoldPage({super.key});

  @override
  ConsumerState<ScaffoldPage> createState() => _ScaffoldPageState();
}

class _ScaffoldPageState extends ConsumerState<ScaffoldPage> {
  int _selectedIndex = 0;

  List<Widget> get _pages => [
    ServicePage(),
    BookingPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(appInitProvider);
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text(Strings.hello),
            Text(
              "Aldo",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.account_circle),
            tooltip: 'Profilo',
            onPressed: () {
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: Strings.services,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: Strings.bookings,
          ),
        ],
      ),
    );
  }
}
