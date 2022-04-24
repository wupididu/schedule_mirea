import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../db/db.dart';

/// Этот контроллер является оберткой надо базой данных
///
/// Этот предоставляет два метода: [getGroups] и [deleteGroup]. Так же он сам проверяет проинициализирована ли [DB] и ждет иниццализации
///
class GroupController {
  final DB _db;

  GroupController(this._db);

  Future<List<String>> getGroups() async {
    await _db.initialized;

    final groups = await _db.getGroups();

    return groups.map((e) => e.groupCode).toList();
  }

  Future<void> deleteGroup(String groupCode) async {
    await _db.initialized;

    await _db.deleteGroup(groupCode);
  }
}

final groupControllerProvider =
    Provider((ref) => GroupController(ref.watch(dbProvider)));
