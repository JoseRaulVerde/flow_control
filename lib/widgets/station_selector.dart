import 'package:flow_control/modals/alert_message.dart';
import 'package:flow_control/modals/botton_message.dart';
import 'package:flow_control/models/options_settings.dart';
import 'package:flow_control/models/settings_info.dart';
import 'package:flow_control/services/api/settings_api_service.dart';
import 'package:flow_control/utils/form_styles.dart';
import 'package:flow_control/widgets/loading_check.dart';
import 'package:flutter/material.dart';
import 'package:flow_control/models/gestion_details.dart';

class StationSelectors extends StatefulWidget {
  final SelectedAreas selected;
  final OptionsSettings options;
  final List<dynamic> permissions;

  const StationSelectors({
    super.key,
    required this.selected,
    required this.options,
    required this.permissions,
  });

  @override
  State<StationSelectors> createState() => _StationSelectorsState();
}

class _StationSelectorsState extends State<StationSelectors> {
  List<GestionDetails> stations = [];
  List<GestionDetails> machines = [];
  GestionDetails? selectedArea;
  GestionDetails? selectedStation;
  GestionDetails? selectedMachine;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    stations = widget.options.stations;
    machines = widget.options.machines;
    selectedArea = widget.selected.area;
    selectedStation = widget.selected.station;
    selectedMachine = widget.selected.machine;
  }

  Future<void> searchStations(int areaId) async {
    setState(() => _isLoading = true);
    try {
      final result = await SettingsApiService().getStation(context, areaId);
      if (result != null) {
        setState(() {
          stations = result;
          selectedStation = null;
          machines = [];
          selectedMachine = null;
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
        showAlertModal(context, "No se encontraron estaciones");
      }
    } catch (e) {
      setState(() => _isLoading = false);
      showAlertModal(context, e.toString());
    }
  }

  Future<void> searchMachines(int stationId) async {
    setState(() => _isLoading = true);
    try {
      final result = await SettingsApiService().selectStation(
        context,
        stationId,
      );
      if (result != null) {
        setState(() {
          machines = result;
          selectedMachine = null;
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
        showAlertModal(context, "No se encontraron máquinas");
      }
    } catch (e) {
      setState(() => _isLoading = false);
      showAlertModal(context, e.toString());
    }
  }

  Future<void> selectMachine(int machineId) async {
    setState(() => _isLoading = true);
    try {
      final result = await SettingsApiService().selectMachine(
        context,
        machineId,
      );
      if (result != null) {
        setState(() => _isLoading = false);
        bottonMessage(
          context,
          "Maquina agregada correctamente",
          color: Colors.green,
        );
      } else {
        setState(() => _isLoading = false);
        showAlertModal(context, "No se encontraron máquinas");
      }
    } catch (e) {
      setState(() => _isLoading = false);
      showAlertModal(context, e.toString());
    }
  }

  Widget _stationsField({
    required String label,
    required GestionDetails? selectedValue,
    required List<GestionDetails> options,
    required void Function(GestionDetails?) onChanged,
  }) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          child: Text(
            label,
            style: FormStyles.getTextStyle(font: 16, color: Colors.black),
          ),
        ),
        DropdownButtonFormField<GestionDetails>(
          decoration: FormStyles.getInputDecoration(label: ''),
          value:
              options.where((item) => item.id == selectedValue?.id).isNotEmpty
                  ? options.firstWhere((item) => item.id == selectedValue!.id)
                  : null,
          items:
              options
                  .map(
                    (option) => DropdownMenuItem<GestionDetails>(
                      value: option,
                      child: Text(option.name),
                    ),
                  )
                  .toList(),
          onChanged: widget.permissions.contains('update') ? onChanged : null,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final areas = widget.options.areas;

    return Stack(
      children: [
        Column(
          spacing: 15,
          children: [
            _stationsField(
              label: 'Área:',
              selectedValue: selectedArea,
              options: areas,
              onChanged: (value) {
                if (value != null) {
                  setState(() => selectedArea = value);
                  searchStations(value.id);
                }
              },
            ),
            _stationsField(
              label: 'Estación:',
              selectedValue: selectedStation,
              options: stations,
              onChanged: (value) {
                if (value != null) {
                  setState(() => selectedStation = value);
                  searchMachines(value.id);
                }
              },
            ),
            _stationsField(
              label: 'Máquina:',
              selectedValue: selectedMachine,
              options: machines,
              onChanged: (value) {
                if (value != null) {
                  setState(() => selectedMachine = value);
                  selectMachine(value.id);
                }
              },
            ),
            Divider(),
          ],
        ),
        if (_isLoading)
          Positioned.fill(
            child: Card(
              elevation: 4,
              child: LoadingCheck(
                message: "espera un momento",
                icon: Icon(Icons.save),
                loading: _isLoading,
              ),
            ),
          ),
      ],
    );
  }
}
