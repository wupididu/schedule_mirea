import 'package:flutter/material.dart';

import '../../methods_provider.dart';
import '../consts.dart';
import 'settings_page_state.dart';

class TimeNotificationField extends StatefulWidget {
  final SettingsPageState state;
  const TimeNotificationField({Key? key, required this.state})
      : super(key: key);

  @override
  State<TimeNotificationField> createState() => _TimeNotificationFieldState();
}

class _TimeNotificationFieldState extends State<TimeNotificationField> {
  SettingsPageState get state => widget.state;
  late final TextEditingController fieldController = TextEditingController();
  String buttonText = '';

  @override
  void initState() {
    super.initState();
    fieldController.addListener(() {
      if (fieldController.text.isEmpty) {
        setState(() {
          buttonText = 'Отменить';
        });
      } else {
        setState(() {
          buttonText = 'Сохранить';
        });
      }
    });
  }

  @override
  void dispose() {
    fieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          Row(
            children: [
              const Text(
                'Во сколько оповещать о дедлайне: ',
                style: TextStyle(
                  color: kTextColor,
                  fontSize: 10,
                ),
              ),
              const SizedBox(width: 1),
              Text(
                widget.state.selectedTimeOfNotification.format(context),
                style: const TextStyle(
                  color: kAccentColor,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: kAccentColor,
                fixedSize: const Size(110, 30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                )),
            onPressed: () async {
              final time = await showTimePicker(
                context: context,
                initialTime: state.selectedTimeOfNotification,
                builder: (context, child) => Theme(
                  data: ThemeData(
                    colorScheme: const ColorScheme.light().copyWith(
                      primary: kPrimaryColor,
                    ),
                  ),
                  child: child!,
                ),
              );
              if (time == null) {
                return;
              }
              await MethodsProvider.get()
                  .settingsPageController
                  .updateTimeNotification(time);
            },
            child: const Text(
              'Изменить',
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
