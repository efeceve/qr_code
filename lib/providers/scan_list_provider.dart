import 'package:flutter/cupertino.dart';
import 'package:qr_reader/providers/db_provider.dart';

class ScanListProvider extends ChangeNotifier {
  List<ScanModel> scans = [];
  String selectedTipe = 'http';

  newScan(String value) async {
    final newScan = new ScanModel(value: value);
    final id = await DBProvider.db.newScan(newScan);
    // add the id from the database model
    newScan.id = id;
    if (this.selectedTipe == newScan.tipe) {
      this.scans.add(newScan);
      notifyListeners();
    }
  }
}
