import 'package:flutter/material.dart';
import 'package:schedule_mirea/methods_provider.dart';
import 'package:schedule_mirea/ui/settings_page/day_notification_field.dart';
import 'package:schedule_mirea/ui/settings_page/group_settings_field.dart';

import '../consts.dart';
import 'settings_page_state.dart';
import 'time_notification_field.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
    MethodsProvider.get().settingsPageController.init();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Параметры',
            style: TextStyle(
              color: kTextColor,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        titleSpacing: 0,
        toolbarHeight: 100,
        elevation: 0,
      ),
      body: StreamBuilder<SettingsPageState?>(
        stream: MethodsProvider.get().settingsPageState.stream,
        builder: (context, snapshot) {
          if (snapshot.data == null || snapshot.data!.loaded) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView(children: [
            GroupSettingsField(state: snapshot.data!),
            const SizedBox(height: 24),
            DayNotificationField(state: snapshot.data!),
            const SizedBox(height: 24),
            TimeNotificationField(state: snapshot.data!),
          ]);
        },
      ),
    );
  }
}
