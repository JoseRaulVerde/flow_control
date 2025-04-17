import 'package:flow_control/models/gestion_details.dart';
import 'package:flow_control/models/options_settings.dart';

class SettingsInfo {
  final SelectedAreas selectedAreas;
  final OptionsSettings optionsSettings;

  SettingsInfo({
    required this.selectedAreas,
    required this.optionsSettings,
  });

  factory SettingsInfo.fromJson(Map<String, dynamic> json) {
    return SettingsInfo(
      selectedAreas: SelectedAreas.fromJson(json['areas'] ?? {}),
      optionsSettings: OptionsSettings.fromJson(json['options']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'areas': selectedAreas.toJson(),
      'options': optionsSettings.toJson(),
    };
  }
}


class SelectedAreas {
  final String? code;
  final GestionDetails? area;
  final GestionDetails? station;
  final GestionDetails? machine;

  SelectedAreas({
    this.code,
    this.area,
    this.station,
    this.machine,
  });

  factory SelectedAreas.fromJson(Map<String, dynamic> json) {
    return SelectedAreas(
      code: json['codigo'],
      area: json['area'] != null ? GestionDetails.fromJson(json['area']) : null,
      station: json['estacion'] != null ? GestionDetails.fromJson(json['estacion']) : null,
      machine: json['maquina'] != null ? GestionDetails.fromJson(json['maquina']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'codigo': code,
      'area': area,
      'estacion': station,
      'maquina': machine,
    };
  }
}