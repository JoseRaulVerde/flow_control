import 'package:flow_control/hooks/use_user_actions.dart';
import 'package:flow_control/modals/alert_message.dart';
import 'package:flow_control/routes.dart';
import 'package:flow_control/services/provider/user_actions_service.dart';
import 'package:flow_control/utils/form_styles.dart';
import 'package:flow_control/widgets/loading_check.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';

class ScanningCode extends StatefulWidget {
  final FocusNode focusNode;

  const ScanningCode({super.key, required this.focusNode});

  @override
  State<ScanningCode> createState() => _ScanningCodeState();
}

class _ScanningCodeState extends State<ScanningCode> {
  final TextEditingController _barcodeController = TextEditingController();
  final Logger log = Logger();
  bool _isLoading = false;
  late UserActionsService userActions;

  @override
  void initState() {
    super.initState();
    userActions = useUserActions(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(widget.focusNode);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(widget.focusNode);
    });
  }

  Future<void> _handleLogin(String code) async {
    log.f(code);
    setState(() {
      _isLoading = true;
    });
    final error = await userActions.loginByCode(code);
    if (error == null && mounted) {
      FocusScope.of(context).unfocus(); // Cierra teclado si estaba activo
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else if (mounted) {
      showAlertModal(context, error ?? 'Ocurrió un error inesperado');
    }

    setState(() {
      _barcodeController.clear();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(horizontal: 24),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Escanea el código QR',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                  TextField(
                    showCursor: false,
                    obscureText: true,
                    focusNode: widget.focusNode,
                    keyboardType: TextInputType.none,
                    decoration: FormStyles.getInputDecoration(
                      label: "Escanea", 
                    ),
                    onSubmitted: (value) =>{ 
                      setState(() {
                      _barcodeController.clear();
                      }),
                      _handleLogin(value.trim())
                    },
                  ),
                _isLoading ?
                LoadingCheck(message: 'Buscando Usuario', icon: Icon(Icons.search), loading: _isLoading)
                : 
                SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}