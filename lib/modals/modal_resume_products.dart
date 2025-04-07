import 'package:flow_control/widgets/card_work_units.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

final log = Logger();

// Modal de Productos para finalizar produccion
Future<String?> showResultModal(BuildContext context) async {

  return await showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return CardWorkUnits();
    },
  );
}