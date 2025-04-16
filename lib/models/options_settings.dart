import 'package:flow_control/models/gestion_details.dart';

class OptionsSettings {
  final List<GestionDetails> areas;
  final List<GestionDetails> stations;
  final List<GestionDetails> machines;

  OptionsSettings({
    required this.areas,
    required this.stations,
    required this.machines,
  });

  factory OptionsSettings.fromJson(Map<String, dynamic> json) {
    return OptionsSettings(
      areas: List<GestionDetails>.from(
        (json['areas'] ?? []).map((item) => GestionDetails.fromJson(item)),
      ),
      stations: List<GestionDetails>.from(
        (json['estaciones'] ?? []).map((item) => GestionDetails.fromJson(item)),
      ),
      machines: List<GestionDetails>.from(
        (json['maquinas'] ?? []).map((item) => GestionDetails.fromJson(item)),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'areas': areas.map((e) => e.toJson()).toList(),
      'estaciones': stations.map((e) => e.toJson()).toList(),
      'maquinas': machines.map((e) => e.toJson()).toList(),
    };
  }
}