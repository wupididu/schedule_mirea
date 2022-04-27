import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../methods_provider.dart';
import '../consts.dart';
import 'settings_page_state.dart';

class DayNotificationField extends StatefulWidget {
  final SettingsPageState state;
  const DayNotificationField({Key? key, required this.state}) : super(key: key);

  @override
  State<DayNotificationField> createState() => _DayNotificationFieldState();
}

class _DayNotificationFieldState extends State<DayNotificationField> {
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
                'За сколько дней напомнить о дедлайне: ',
                style: TextStyle(
                  color: kTextColor,
                  fontSize: 10,
                ),
              ),
              const SizedBox(width: 1),
              Text(
                widget.state.selectedDayOfNotification.toString(),
                style: const TextStyle(
                  color: kAccentColor,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          if (state.dayOfNotificationChangeMode)
            TextFormField(
              controller: fieldController,
              style: const TextStyle(
                fontSize: 16,
                color: kTextColor,
              ),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                errorText: state.groupCodeError,
                hintText: 'Например: 3',
                hintStyle: const TextStyle(
                  color: kHintTextColor,
                ),
                filled: true,
                fillColor: kSecondaryColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: kAccentColor,
                fixedSize: const Size(110, 30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                )),
            onPressed: () {
              if (state.dayOfNotificationChangeMode) {
                if (fieldController.text.isEmpty) {
                  MethodsProvider.get()
                      .settingsPageController
                      .turnChangeModeDayNotification(false);
                  return;
                }
                final day = int.parse(fieldController.text);
                MethodsProvider.get()
                    .settingsPageController
                    .updateDayNotification(day);
              } else {
                MethodsProvider.get()
                    .settingsPageController
                    .turnChangeModeDayNotification(true);
              }
            },
            child: Text(
              state.dayOfNotificationChangeMode
                  ? buttonText
                  : 'Изменить',
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
