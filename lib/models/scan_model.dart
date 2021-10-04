import 'dart:convert';

ScanModel scanModelFromJson(String str) => ScanModel.fromJson(json.decode(str));

String scanModelToJson(ScanModel data) => json.encode(data.toJson());

class ScanModel {
  int? id;
  String? tipe;
  String value;

  ScanModel({
    this.id,
    this.tipe,
    required this.value,
  }) {
    if (this.value.contains('http')) {
      this.tipe = 'http';
    } else {
      this.tipe = 'geo';
    }
  }

  factory ScanModel.fromJson(Map<String, dynamic> json) => new ScanModel(
        id: json["id"],
        tipe: json["tipe"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "tipe": tipe,
        "value": value,
      };
}
