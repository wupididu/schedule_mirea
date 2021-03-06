import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:schedule_mirea/ui/settings_page/settings_page_state.dart';

import '../../methods_provider.dart';
import '../consts.dart';

class GroupSettingsField extends StatefulWidget {
  final SettingsPageState state;
  const GroupSettingsField({Key? key, required this.state}) : super(key: key);

  @override
  State<GroupSettingsField> createState() => _GroupSettingsFieldState();
}

class _GroupSettingsFieldState extends State<GroupSettingsField> {
  SettingsPageState get state => widget.state;
  late final TextEditingController groupFieldController =
      TextEditingController();
  String buttonText = 'Отменить';

  @override
  void initState() {
    super.initState();
    groupFieldController.addListener(() {
      if (groupFieldController.text.isEmpty) {
        setState(() {
          buttonText = 'Отменить';
        });
      } else {
        setState(() {
          buttonText = 'Сохранить изменения';
        });
      }
    });
  }

  @override
  void dispose() {
    groupFieldController.dispose();
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
              Text(
                widget.state.selectedGroupCode == null
                    ? 'Введи наименование группы:'
                    : 'Выбрано наименование группы:',
                style: const TextStyle(
                  color: kTextColor,
                  fontSize: 10,
                ),
              ),
              const SizedBox(width: 1),
              if (widget.state.selectedGroupCode != null)
                Text(
                  widget.state.selectedGroupCode!,
                  style: const TextStyle(
                    color: kAccentColor,
                    fontSize: 12,
                  ),
                ),
              if (widget.state.selectedGroupCode != null)
                IconButton(
                  onPressed: () {
                    MethodsProvider.get()
                        .settingsPageController
                        .updateGroupCode(widget.state.selectedGroupCode!);
                  },
                  icon: const Icon(
                    Icons.update_outlined,
                    color: kAccentColor,
                  ),
                )
            ],
          ),
          if (state.groupCodeChangeMode)
            TextFormField(
              controller: groupFieldController,
              style: const TextStyle(
                fontSize: 16,
                color: kTextColor,
              ),
              inputFormatters: [
                Formatter(),
              ],
              decoration: InputDecoration(
                errorText: state.groupCodeError,
                hintText: 'Например: ИВБО-02-19',
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
              if (state.groupCodeChangeMode) {
                if (groupFieldController.text.isEmpty) {
                  MethodsProvider.get()
                      .settingsPageController
                      .turnChangeModeGroupCode(false);
                  return;
                }
                final groupCode = groupFieldController.value.text;
                MethodsProvider.get()
                    .settingsPageController
                    .updateGroupCode(groupCode.toUpperCase());
              } else {
                MethodsProvider.get()
                    .settingsPageController
                    .turnChangeModeGroupCode(true);
              }
              groupFieldController.clear();
            },
            child: Text(
              state.groupCodeChangeMode ? buttonText : 'Изменить',
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            height: 100,
            color: kSecondaryColor,
            child: ListView(
              children: state.loadedGroupCode
                  .map(
                    (e) => TextButton(
                      onPressed: () {
                        MethodsProvider.get()
                            .settingsPageController
                            .getLoadedGroup(e);
                      },
                      child: Row(
                        children: [
                          Expanded(
                            child: Center(
                              child: Text(
                                e,
                                style: const TextStyle(color: kAccentColor),
                              ),
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                _showDeleteDialog(e);
                              },
                              icon: const Icon(
                                Icons.delete_outline,
                                color: kTextColor,
                              ))
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(String groupCode) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text(
              'Вы действительно хотите удалить группу? Это сотрет все связанные с ним данные!!!',
              style: TextStyle(color: kTextColor),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    MethodsProvider.get().settingsPageController.deleteGroup(groupCode);
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Да',
                    style: TextStyle(color: kAccentColor),
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Нет',
                    style: TextStyle(color: kAccentColor),
                  ))
            ],
            actionsAlignment: MainAxisAlignment.spaceAround,
          ));
}

class Formatter extends TextInputFormatter {
  final groupMask = '0000-00-00';

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final result = StringBuffer();
    var text =
        newValue.text.replaceAll('-', '').replaceAll(' ', '').toUpperCase();
    if (text.length > 1 && oldValue.text.length > newValue.text.length) {
      text = text.substring(0, text.length);
    }
    var readPosition = 0;
    for (var i = 0; i < groupMask.length; i++) {
      if (readPosition > text.length - 1) {
        break;
      }
      var curSymbol = groupMask[i];
      if (isZeroSymbol(curSymbol)) {
        curSymbol = text[readPosition];
        readPosition++;
      }
      result.write(curSymbol);
    }
    final textResult = result.toString();
    return TextEditingValue(
      text: textResult,
      selection: TextSelection.collapsed(
        offset: textResult.length,
      ),
    );
  }

  bool isZeroSymbol(String symbol) => symbol == "0";
}
