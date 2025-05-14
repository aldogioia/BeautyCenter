import 'package:beauty_center_frontend/provider/global_provider.dart';
import 'package:beauty_center_frontend/provider/operator_provider.dart';
import 'package:beauty_center_frontend/screen/main_screen/booking_screen.dart';
import 'package:beauty_center_frontend/screen/main_screen/entities_management_screen.dart';
import 'package:beauty_center_frontend/screen/main_screen/schedule_screen.dart';
import 'package:beauty_center_frontend/screen/main_screen/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/enumerators/role.dart';

class MainScaffold extends ConsumerStatefulWidget {
  const MainScaffold({super.key});

  @override
  ConsumerState<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends ConsumerState<MainScaffold> {

  final List<Widget> _pages = [
    EntitiesManagementScreen(),
    BookingScreen(),
    ScheduleScreen(),
    SettingsScreen()
  ];

  final List<Widget> _operatorPages = [
    BookingScreen(),
    ScheduleScreen(),
    SettingsScreen()
  ];

  int _currentIndex = 0;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(appInitProvider.future);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final role = ref.watch(operatorProvider).role;

    return Scaffold(
      body:  role == Role.ROLE_ADMIN ? _pages[_currentIndex] : _operatorPages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          if(role == Role.ROLE_ADMIN) ...[
            BottomNavigationBarItem(
                icon: Icon(Icons.brush),
                label: "gestione"
            )
          ],

          BottomNavigationBarItem(
            icon: Icon(Icons.checklist_rounded),
            label: "prenotazioni"
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.accessibility_sharp),
            label: "turni"
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: "impostazioni"
          )
        ]
      )
    );
  }
}




