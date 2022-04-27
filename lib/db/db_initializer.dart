import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'db.dart';


/// Это обертка над [DB] для инициализации, чтобы на верхних слоях не иметь
/// прямого доступа к модификации данных в БД кроме мтодов [init] и [dispose]
class DBInitializer {
  final DB _db;

  DBInitializer(this._db);

  Future<void> init() => _db.init();

  Future<void> dispose() => _db.dispose();
}

final dbInitializer = Provider((ref) => DBInitializer(ref.watch(dbProvider)));
