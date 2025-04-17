import 'package:flow_control/modals/alert_message.dart';
import 'package:flow_control/modals/botton_message.dart';
import 'package:flow_control/models/options_settings.dart';
import 'package:flow_control/models/settings_info.dart';
import 'package:flow_control/provider/user_provider.dart';
import 'package:flow_control/services/api/settings_api_service.dart';
import 'package:flow_control/utils/secure_storage/secure_storage_service.dart';
import 'package:flow_control/utils/form_styles.dart';
import 'package:flow_control/utils/validator.dart';
import 'package:flow_control/widgets/forbidden_403.dart';
import 'package:flow_control/widgets/station_selector.dart';
import 'package:flutter/material.dart';
import 'package:logger/web.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final log = Logger();
  late Future<String?> _apiKeyFuture;
  SelectedAreas? _selectedAreas;
  late OptionsSettings? _options;
  bool _isLoading = false;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _apiKeyFuture = SecureStorageService().readApiKey();
    _getSettings();
  }

  void _getSettings() async {
    try {
      setState(() { _isLoading = true; });
      final value = await SettingsApiService().getSettings(context);
      log.f(value);
      if (value != null) {
        if (!mounted) return;
        setState(() {
          _isLoaded = true;
          _selectedAreas = value.selectedAreas;
          _options = value.optionsSettings;
        });
      } else {
        if (!mounted) return;
        showAlertModal(context, 'No se encontraron configuraciones.');
      }
    } catch (error) {
      Validators.handleHttpException(context, error);
      log.e(error);
    }finally{
      setState(() {_isLoading = false;});
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    final String baseUrl = dotenv.env["BASIC_URL"].toString();

    if (user == null) {
      return const Center(child: Text('No hay usuario cargado.'));
    }else{
      log.d(user.permissions.toString());
    }

    if ( _isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                spacing: 20,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage('$baseUrl${user.image}'),
                  ),
                  const SizedBox(height: 16),
                  _buildTextField("Nombre", user.name),
                  _buildTextField("Apellido", user.lastName),
                  _buildTextField("Correo electrónico", user.email),
                  const Divider(),
                  (user.permissions.isNotEmpty ) ?
                  Column(
                    children: [
                  _apiKeyFuture.toString().isEmpty ?
                  Row(
                    spacing: 10,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.error, color: Colors.redAccent,),
                      Text(
                        'Llave de API no encontrada, favor de importar correctamente la llave',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  )
                  : Row(
                    spacing: 10,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      
                      Icon(Icons.check_circle, color: Colors.lightGreen,),
                      Text(
                        overflow: TextOverflow.ellipsis,
                          'Llave de API encontrada (${_selectedAreas?.code})',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  FilledButton.icon(
                    onPressed: 
                    user.permissions.contains('load')
                    ? () async {
                      final saveKey = await SecureStorageService().setApiKey();
                      if (saveKey) {
                        bottonMessage(context, 'Llave guardada con éxito');
                        setState(() {
                          _apiKeyFuture = SecureStorageService().readApiKey();
                        });
                      }
                    }
                    : null,
                    icon: Icon(Icons.key),
                    label: Text('Importar llave'),
                  ),
                  Divider(),
                  (user.permissions.contains('read') && _isLoaded ) ?
                  StationSelectors(selected: _selectedAreas!, options: _options!, permissions: user.permissions,)
                  :  Forbidden403()
                    ],
                  ):  Forbidden403()

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String value) {
    return TextField(
      readOnly: true,
      decoration: FormStyles.getInputDecoration(label: label),
      controller: TextEditingController(text: value),
    );
  }
}