import 'package:beauty_center_frontend/handler/snack_bar_handler.dart';
import 'package:beauty_center_frontend/provider/auth_provider.dart';
import 'package:beauty_center_frontend/provider/operator_provider.dart';
import 'package:beauty_center_frontend/widget/modal-bottom-sheet/delete_modal_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
                                            Icon(Icons.manage_accounts_rounded, color: Theme.of(context).primaryColor),
                                            Text(Strings.personal_data)
                                          ]
                                      )
                                  )
                              )
                            ],

                            // todo serve controllare che role != Role.Empty ?
                            Padding(
                                padding: const EdgeInsets.all(10),
                                child: GestureDetector(
                                    onTap: (){},    // todo
                                    child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        spacing: 10,
                                        children: [
                                          Icon(Icons.notifications_none_rounded, color: Theme.of(context).primaryColor),
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
                                              duration: Duration(milliseconds: 750)
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
                                          Icon(Icons.logout, color: Colors.red),
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
