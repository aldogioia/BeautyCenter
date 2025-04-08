import 'package:beauty_center_frontend/screen/main_screen/BookingScreen.dart';
import 'package:beauty_center_frontend/screen/main_screen/EntitiesManagementScreen.dart';
import 'package:beauty_center_frontend/screen/main_screen/ScheduleScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainScaffold extends ConsumerStatefulWidget {
  const MainScaffold({super.key});

  @override
  ConsumerState<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends ConsumerState<MainScaffold> {

  final List<Widget> _pages = [
    EntitiesManagementScreen(),
    BookingScreen(),
    ScheduleScreen()
  ];

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Theme.of(context).colorScheme.primary,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.brush),
            label: "gestione"   // todo
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.checklist_rounded),
            label: "prenotazioni"     // todo
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.accessibility_sharp),
            label: "turni"      // todo
          )    // todo cambiare icona,
        ]
      ),
    );
  }
}




