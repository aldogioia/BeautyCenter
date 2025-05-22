import 'package:edone_customer/pages/service_page.dart';
import 'package:edone_customer/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
    SettingsPage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  String _getTitle(){
    return switch(_selectedIndex) {
      0 => Strings.services,
      1 => Strings.bookings,
      2=> Strings.settings,
      int() => "Errore",
    };
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
        title: Text(_getTitle(), style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        currentIndex: _selectedIndex,
        selectedFontSize: 12,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.spa),
            label: Strings.services,
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.bookBookmark),
            label: Strings.bookings,
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.gear),
            label: Strings.settings,
          ),
        ],
      ),
    );
  }
}
