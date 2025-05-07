import 'package:edone_customer/utils/Strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_provider.dart';
import '../providers/customer_provider.dart';
import '../utils/snack_bar.dart';
import 'custom_widgets/confirm_modal.dart';
import 'custom_widgets/customer_info.dart';
import 'custom_widgets/notifications_modal.dart';

class SettingsPage extends ConsumerStatefulWidget{
  const SettingsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingsPageState();

}

class _SettingsPageState extends ConsumerState<SettingsPage> {

  Future<void> _signOut() async {
    final response = await ref.read(authProvider.notifier).signOut();
    if (response.isNotEmpty) {
      SnackBarHandler.instance.showMessage(message: response);
    }
  }

 Future<void> _deleteAccount() async {
    final response = await ref.read(customerProvider.notifier).deleteCustomer();
    if (response.isNotEmpty) {
      SnackBarHandler.instance.showMessage(message: response);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 32,
      children: [
        SizedBox(height: 32),
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
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                isDismissible: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                builder: (context) => SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: CustomerInfo()
                ),
              );
            }, Strings.personalData, Icons.arrow_forward_ios, icon2: Icons.account_circle_rounded),
            settingsItem(() {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                isDismissible: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                builder: (context) => SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: NotificationsModal(
                    value: false,
                    onChanged: (value) {
                      //TODO
                    },
                  )
                ),
              );
            }, Strings.notification, Icons.arrow_forward_ios, icon2: Icons.notifications_rounded),
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
            settingsItem(() => {}, Strings.facebook, Icons.open_in_new_rounded),
            settingsItem(() => {}, Strings.instagram, Icons.open_in_new_rounded),
            settingsItem(() => {}, Strings.tiktok, Icons.open_in_new_rounded),
          ],
        ),
        Column(
          spacing: 16,
          children: [
            settingsItem(() {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                builder: (context) => SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: ConfirmModal(
                    text1: "Si, voglio Uscire",
                    text2:  "No, resto acnora un pò",
                    icon: Icons.logout_rounded,
                    onConfirm: () => _signOut(),
                    onCancel: () => Navigator.pop(context)
                  )
                ),
              );
            }, Strings.signOut, Icons.logout_rounded, alert: true),
            settingsItem(() {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                builder: (context) => SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: ConfirmModal(
                        text1: "Si, voglio Eliminare l'account",
                        text2:  "No, era solo un pensiero intrusivo",
                        icon: Icons.delete_rounded,
                        onConfirm: () => _deleteAccount(),
                        onCancel: () => Navigator.pop(context)
                    )
                ),
              );
            }, Strings.deleteAccount, Icons.delete_rounded, alert: true),
          ],
        ),
      ],
    );
  }

  Widget settingsItem(void Function() function, String text, IconData icon, {IconData? icon2, bool alert = false}){
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
                    if (icon2 != null) Icon(
                        icon2, size: 24,
                        color: alert ? Colors.red : Theme.of(context).colorScheme.primary
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
                Icon(icon, size: 16, color: alert ? Colors.red: null)
              ]
          ),
        )
    );
  }
}
