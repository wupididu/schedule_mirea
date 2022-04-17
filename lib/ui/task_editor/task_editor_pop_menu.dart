import 'package:flutter/material.dart';
import 'package:schedule_mirea/methods_provider.dart';
import 'package:schedule_mirea/ui/consts.dart';

class TaskEditorPopMenu extends StatelessWidget {
  const TaskEditorPopMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      offset: const Offset(0, 50),
      icon: Icon(
        Icons.menu,
        color: Theme.of(context).iconTheme.color,
      ),
      elevation: 0,
      color: kSecondaryColor,
      shape: RoundedRectangleBorder(
        side: BorderSide.none,
        borderRadius: BorderRadius.circular(20),
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
          onTap: () {
            MethodsProvider.get().taskEditorController.deleteTask();
            // TODO: после удаления поидее надо выйти из
          },
          child: Row(
            children: const [
              Icon(
                Icons.delete_outline,
                color: kTextColor,
              ),
              Text(
                'Удалить',
                style: TextStyle(color: kTextColor),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          onTap: () {
            MethodsProvider.get().taskEditorController.saveTask();
          },
          child: Row(
            children: const [
              Icon(
                Icons.save_outlined,
                color: kTextColor,
              ),
              Text(
                'Сохранить',
                style: TextStyle(color: kTextColor),
              ),
            ],
          ),
        )
      ],
    );
  }
}
