import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:qr_reader/models/scan_model.dart';
export 'package:qr_reader/models/scan_model.dart';

class DBProvider {
  static Database? _database;
  static final DBProvider db = DBProvider._();
  DBProvider._();

  Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await initDB();

    return _database;
  }

  Future<Database?> initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'ScansDB.db');
    print(path);

    // Database creation
    return await openDatabase(path, version: 2, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('''
        CREATE TABLE Scans(
          id INTEGER PRIMARY KEY,
          tipe TEXT,
          value TEXT
        )
      ''');
    });
  }

  Future<int> newScanRaw(ScanModel newScan) async {
    final id = newScan.id;
    final tipe = newScan.tipe;
    final value = newScan.value;

    // Verify DataBase
    final db = await database;

    // Insert new registry
    final res = await db!.rawInsert('''
      INSERT INTO Scans(id, tipe, value)
        VALUES( '$id', '$tipe', '$value')
    ''');
    return res;
  }

  Future<int> newScan(ScanModel newScan) async {
    final db = await database;
    final res = await db!.insert('Scans', newScan.toJson());
    return res;
  }

  Future<ScanModel> getScanById(int id) async {
    final db = await database;
    final res = await db!.query('Scans', where: 'id = ?', whereArgs: [id]);
    //return res!.isNotEmpty ? ScanModel.fromJson(res.first) : res = ;
    return ScanModel.fromJson(res.first);
  }

  Future<List<ScanModel>> getAllScans() async {
    final db = await database;
    final res = await db!.query('Scans');
    List<dynamic> list = res.isNotEmpty
        ? res.map((scan) => new ScanModel.fromJson(scan)).toList()
        : [];
    return List.castFrom<dynamic, ScanModel>(list);
  }

  Future<List<ScanModel>> getScanByTipe(String tipe) async {
    final db = await database;
    final res = await db!.query('Scans', where: 'tipe = ?', whereArgs: [tipe]);
    List<dynamic> list = res.isNotEmpty
        ? res.map((scan) => new ScanModel.fromJson(scan)).toList()
        : [];
    return List.castFrom<dynamic, ScanModel>(list);
  }

  Future<int> updateScan(ScanModel newScan) async {
    final db = await database;
    final res = db!.update('Scans', newScan.toJson(),
        where: 'id = ?', whereArgs: [newScan.id]);
    return res;
  }

  Future<int> deleteScan(int id) async {
    final db = await database;
    final res = db!.delete('Scans', where: 'id = ?', whereArgs: [id]);
    return res;
  }

  Future<int> deleteAllScan(int id) async {
    final db = await database;
    final res = db!.delete('Scans');
    return res;
  }
}
