import 'dart:io';
import 'package:btl_ptttm/app/model/traffic.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';

class SqfliteDatabase {
  static final SqfliteDatabase _singleton = SqfliteDatabase._internal();
  // đảm bảo chỉ db trong toàn ứng dụng
  factory SqfliteDatabase() {
    return _singleton;
  }
  SqfliteDatabase._internal();

  late Database db;

  Future initDb() async {
    final dbPath = await getDatabasesPath();
    // lay ten database trong duong dan
    final path = join(dbPath, "database.db");
    final exist = await databaseExists(path);
    if (!exist) {
      // try {
      //   // nếu chưa có db thì nó tự tạo
      //   await Directory(dirname(path)).create(recursive: true);
      // } catch (_) {}

      ByteData data = await rootBundle.load(join("assets", "database.db"));
      // chuyển sang 8 bit

      List<int> bytes =
          data.buffer.asInt8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes, flush: true);
    }
    db = await openDatabase(path);
  }

  Future insertTrafficData(Traffic traffic) async {
    String insertQuery = '''
      INSERT INTO history (name, link, x, y, width, height)
      VALUES (
        '${traffic.name}',
        '${traffic.link}',
        '${traffic.x}',
        '${traffic.y}',
        '${traffic.width}',
        '${traffic.height}'
      );
    ''';

    await db.rawInsert(insertQuery);
  }

  Future<List<Traffic>> fetchAllData() async {
    var squerry = 'SELECT  *  FROM history ';
    final List<Map<String, dynamic>> queryResult = await db.rawQuery(squerry);
    return queryResult.map((e) => Traffic.fromJson(e)).toList();
  }

  Future<void> deleteTrafficByLink(String link) async {
    await db.delete('history', where: 'link = ?', whereArgs: [link]);
  }
}
