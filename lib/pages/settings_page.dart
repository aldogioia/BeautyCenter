import 'package:edone_customer/providers/booking_provider.dart';
import 'package:edone_customer/utils/Strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../navigation/navigator.dart';
import '../providers/auth_provider.dart';
import '../providers/customer_provider.dart';
import '../providers/operator_provider.dart';
import '../providers/service_provider.dart';
import '../handler/snack_bar_handler.dart';
import '../utils/secure_storage.dart';
import 'modal/confirm_modal.dart';
import 'modal/notifications_modal.dart';

class SettingsPage extends ConsumerStatefulWidget{
  const SettingsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingsPageState();

}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  bool _notificationsEnabled = true;

  Future<void> _signOut() async {
    final result = await ref.read(authProvider.notifier).signOut();
    if (result.isNotEmpty) {
      SnackBarHandler.instance.showMessage(message: result);
    } else {
      _clearProviders();
    }
  }

  Future<void> _deleteAccount() async {
    final result = await ref.read(customerProvider.notifier).deleteCustomer();
    if (result.isNotEmpty) {
      SnackBarHandler.instance.showMessage(message: result);
    } else {
      _clearProviders();
    }
  }

  Future<void> _loadNotificationPref() async {
    final enabled = await SecureStorage.getNotificationsEnabled();
    setState(() {
      _notificationsEnabled = enabled;
    });
  }

  void _onToggle(bool value) async {
    setState(() {
      _notificationsEnabled = value;
    });
    await SecureStorage.setNotificationsEnabled(value);
  }

  void _clearProviders(){
    ref.read(customerProvider.notifier).reset();
    ref.read(operatorProvider.notifier).reset();
    ref.read(serviceProvider.notifier).reset();
    ref.read(bookingProvider.notifier).reset();
  }

  @override
  void initState() {
    super.initState();
    _loadNotificationPref();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(top: 24, bottom: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 32,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16,
            children: [
              Opacity(
                  opacity: 0.5,
                  child: Text(Strings.details, style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ))
              ),
              settingsItem(() {
                NavigatorService.navigatorKey.currentState?.pushNamed("/personal-data");
              }, Strings.personalData, icon: FontAwesomeIcons.angleRight, icon2: FontAwesomeIcons.solidCircleUser),
              settingsItem(() {
                NavigatorService.navigatorKey.currentState?.pushNamed("/update-password");
              }, "Cambia Password", icon: FontAwesomeIcons.angleRight, icon2: FontAwesomeIcons.key),
              settingsItem(() {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  isDismissible: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  builder: (context) => SingleChildScrollView(
                      padding: EdgeInsets.only(top: 16, left: 16, right: 16, bottom: MediaQuery.of(context).viewInsets.bottom + 16),
                      child: NotificationsModal(
                        value: _notificationsEnabled,
                        onChanged: _onToggle,
                      )
                  ),
                );
              }, Strings.notification, icon2: FontAwesomeIcons.solidBell),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16,
            children: [
              Opacity(
                  opacity: 0.5,
                  child: Text("Contatti", style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ))
              ),
              settingsItem(() => {}, Strings.mobilePhone, icon2: FontAwesomeIcons.mobile),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16,
            children: [
              Opacity(
                opacity: 0.5,
                child: Text(Strings.resources, style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ))
              ),
              settingsItem(() => {}, Strings.facebook, icon: FontAwesomeIcons.arrowUpRightFromSquare),
              settingsItem(() => {}, Strings.instagram, icon: FontAwesomeIcons.arrowUpRightFromSquare),
              //settingsItem(() => {}, Strings.tiktok, icon: FontAwesomeIcons.arrowUpRightFromSquare),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16,
            children: [
              Opacity(
                opacity: 0.5,
                child: Text(Strings.access, style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ))
              ),
              settingsItem(() {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  builder: (context) => SingleChildScrollView(
                      padding: EdgeInsets.only(top: 16, left: 16, right: 16, bottom: MediaQuery.of(context).viewInsets.bottom + 16),
                      child: ConfirmModal(
                          text1: "Si, voglio Uscire",
                          text2:  "No, resto acnora un pò",
                          icon: FontAwesomeIcons.rightFromBracket,
                          onConfirm: () => _signOut(),
                          onCancel: () => Navigator.pop(context)
                      )
                  ),
                );
              }, Strings.signOut, icon2: FontAwesomeIcons.rightFromBracket, alert: true),
              settingsItem(() {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  builder: (context) => SingleChildScrollView(
                      padding: EdgeInsets.only(top: 16, left: 16, right: 16, bottom: MediaQuery.of(context).viewInsets.bottom + 16),
                      child: ConfirmModal(
                          text1: "Si, voglio Eliminare l'account",
                          text2:  "No, era solo un pensiero intrusivo",
                          icon: FontAwesomeIcons.solidTrashCan,
                          onConfirm: () => _deleteAccount(),
                          onCancel: () => Navigator.pop(context)
                      )
                  ),
                );
              }, Strings.deleteAccount, icon2: FontAwesomeIcons.solidTrashCan, alert: true),
            ],
          ),
        ],
      )
    );
  }

  Widget settingsItem(void Function() function, String text, {IconData? icon, IconData? icon2, bool alert = false}){
    return GestureDetector(
        onTap: function,
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 8,
                  children: [
                    if (icon2 != null) FaIcon(
                        icon2, size: 24,
                        color: alert ? Colors.red : null
                    ),
                    Text(
                      text,
                      style: TextStyle(
                        fontWeight: FontWeight.w700 ,
                        color: alert ? Colors.red : null
                      )
                    ),
                  ]
                ),
                if (icon != null) FaIcon(icon, size: 16, color: alert ? Colors.red: null)
              ]
          ),
        )
    );
  }
}
