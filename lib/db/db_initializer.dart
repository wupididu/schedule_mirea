import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'db.dart';

class DBInitializer {
  final DB _db;

  DBInitializer(this._db);

  Future<void> init() => _db.init();

  Future<void> dispose() => _db.dispose();
}

final dbInitializer = Provider((ref) => DBInitializer(ref.watch(dbProvider)));
