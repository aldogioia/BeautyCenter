import 'package:beauty_center_frontend/handler/snack_bar_handler.dart';
import 'package:beauty_center_frontend/provider/auth_provider.dart';
import 'package:beauty_center_frontend/provider/operator_provider.dart';
import 'package:beauty_center_frontend/security/secure_storage.dart';
import 'package:beauty_center_frontend/widget/modal-bottom-sheet/delete_modal_bottom_sheet.dart';
import 'package:beauty_center_frontend/widget/modal-bottom-sheet/notification_modal_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../model/enumerators/role.dart';
import '../../utils/strings.dart';
import '../../widget/modal-bottom-sheet/operator_update_modal_bottom_sheet.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          spacing: 32,
          children: [
            SizedBox(height: 80),

            Text(Strings.settings, style: Theme.of(context).textTheme.headlineMedium),

            SingleChildScrollView(
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          spacing: 8,
                          children: [
                            Text(Strings.account),

                            if(ref.read(operatorProvider).role == Role.ROLE_OPERATOR && ref.read(operatorProvider).currentOperator != null) ...[
                              Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: GestureDetector(
                                      onTap: (){
                                        showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            transitionAnimationController: AnimationController(
                                                vsync: Navigator.of(context),
                                                duration: Duration(milliseconds: 750)
                                            ),
                                            builder: (context) => OperatorUpdateModalBottomSheet(
                                              operatorDto: ref.read(operatorProvider).currentOperator!,
                                              fromSettings: true,
                                            )
                                        );
                                      },
                                      child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          spacing: 10,
                                          children: [
                                            Icon(FontAwesomeIcons.circleUser, color: Theme.of(context).colorScheme.primary),
                                            Text(Strings.personal_data)
                                          ]
                                      )
                                  )
                              )
                            ],

                            Padding(
                                padding: const EdgeInsets.all(10),
                                child: GestureDetector(
                                    onTap: () async {
                                      final bool enabled = await SecureStorage.getNotificationsEnabled();
                                      print("NOTIFICA INIZIALE: $enabled");

                                      showModal(bool value) => showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          transitionAnimationController: AnimationController(
                                              vsync: Navigator.of(context),
                                              duration: Duration(milliseconds: 500)
                                          ),
                                          builder: (context) {
                                            return NotificationModalBottomSheet(
                                              enabled: value,
                                            );
                                          }
                                      );

                                      showModal(enabled);

                                    },
                                    child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        spacing: 10,
                                        children: [
                                          Icon(FontAwesomeIcons.bell, color: Theme.of(context).colorScheme.primary),
                                          Text(Strings.notifications)
                                        ]
                                    )
                                )
                            )
                          ]
                      ),

                      Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          spacing: 8,
                          children: [
                            Text(Strings.access),

                            Padding(
                                padding: const EdgeInsets.all(10),
                                child: GestureDetector(
                                    onTap: () async {
                                      showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          transitionAnimationController: AnimationController(
                                              vsync: Navigator.of(context),
                                              duration: Duration(milliseconds: 500)
                                          ),
                                          builder: (context) => DeleteModalBottomSheet(
                                            text: Strings.exit,
                                            onTap: () async {
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

                                              final result = await ref.read(authProvider.notifier).logout();

                                              navigator.pop();

                                              if(result != "") {
                                                SnackBarHandler.instance.showMessage(message: result);
                                              } else {
                                                navigator.pushNamedAndRemoveUntil(
                                                    "/start_screen", (Route<dynamic> route) => false
                                                );
                                              }
                                            }
                                          )
                                      );
                                    },
                                    child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        spacing: 10,
                                        children: [
                                          Icon(FontAwesomeIcons.rightFromBracket, color: Colors.red),
                                          Text(Strings.exit, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.red))
                                        ]
                                    )
                                )
                            ),
                          ]
                      )
                    ]
                )
            ),

            SizedBox(height: 80)
          ]
      ),
    );
  }
}
