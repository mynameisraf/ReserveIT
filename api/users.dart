// To parse this JSON data, do
//
//     final reserveIT = reserveITFromJson(jsonString);

import 'dart:convert';

ReserveIT reserveITFromJson(String str) =>
    ReserveIT.fromJson(json.decode(str));

String reserveITToJson(ReserveIT data) => json.encode(data.toJson());

class ReserveIT {
  ReserveIT({
    required this.data,
  });

  final List<ReserveITStation> data;

  factory ReserveIT.fromJson(Map<String, dynamic> json) => ReserveIT(
        data: List<ReserveITStation>.from(
            json["data"].map((x) => ReserveITStation.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class ReserveITStation {
  ReserveITStation({
    required this.id,
    required this.pcName,
    required this.zone,
    required this.cpu,
    required this.gpu,
    required this.ram,
    required this.monitor,
    required this.peripherals,
    required this.rate,
    required this.isAvailable,
    required this.games,
  });

  final int id;
  final String pcName;
  final String zone;
  final String cpu;
  final String gpu;
  final String ram;
  final String monitor;
  final String peripherals;
  final String rate;
  final bool isAvailable;
  final List<String> games;

  factory ReserveITStation.fromJson(Map<String, dynamic> json) =>
      ReserveITStation(
        id: json["id"],
        pcName: json["pcName"],
        zone: json["zone"],
        cpu: json["cpu"],
        gpu: json["gpu"],
        ram: json["ram"],
        monitor: json["monitor"],
        peripherals: json["peripherals"],
        rate: json["rate"],
        isAvailable: json["isAvailable"],
        games: List<String>.from(json["games"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "pcName": pcName,
        "zone": zone,
        "cpu": cpu,
        "gpu": gpu,
        "ram": ram,
        "monitor": monitor,
        "peripherals": peripherals,
        "rate": rate,
        "isAvailable": isAvailable,
        "games": List<dynamic>.from(games.map((x) => x)),
      };
}
