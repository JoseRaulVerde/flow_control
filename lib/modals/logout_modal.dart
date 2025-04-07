import 'package:flow_control/widgets/alert_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flow_control/modals/alert_message.dart';
import 'package:flow_control/provider/product_provider.dart';

// Modal de cerrado de sesion de usuario
Future<bool> showBackDialog(BuildContext context) async {
  final runningAction = Provider.of<ProductsProvider>(context, listen: false);

  if (!runningAction.isEventRunning) {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialogWidget(
        title: '¿Deseas cerrar sesión?', 
        textInfo: 'Si sales, tendrás que iniciar sesión nuevamente.',
        buttonFalse: 'cancelar', 
        buttonTrue: 'Cerrar sesión'),
    );
    if (result == true){
      Navigator.pushReplacementNamed(context, '/login');
      return true;
    }    
    return false;
  } else {
    showAlertModal(context, "Necesitas terminar el proceso");
    return false;
  }
}