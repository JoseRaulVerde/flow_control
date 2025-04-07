import 'package:flow_control/utils/form_styles.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

final log = Logger();

//  Modal de muestra de lista de razones de pausa
Future<String?> showReasonsModalList(BuildContext context, String title, List<String> list) async {
  String? selectedButton;
  final TextEditingController controller = TextEditingController();

  return await showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: FractionallySizedBox(
              heightFactor: 0.7,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: list.length + 1, // Lista + campo de texto
                      itemBuilder: (_, index) {
                        if (index < list.length) {
                          return ListTile(
                            title: Text(list[index]),
                            tileColor: selectedButton == list[index] ? Colors.blue[200] : null,
                            onTap: () {
                              setState(() {
                                selectedButton = list[index];
                                controller.clear(); // Limpia el campo si seleccionas una opción
                              });
                            },
                          );
                        } else {
                          // Último ítem: el campo de texto
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Otra razón:"),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: controller,
                                  decoration: FormStyles.getInputDecoration(label: "Informar la razón"),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedButton = value.isNotEmpty ? value : null;
                                    });
                                  },
                                  onTap: () {
                                    // Limpia la selección si empieza a escribir
                                    setState(() {
                                      selectedButton = controller.text;
                                    });
                                  },
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all( CustomColors().blueButton)
                        ),
                        onPressed: selectedButton != null && selectedButton!.isNotEmpty
                            ? () {

                                Navigator.pop(context, selectedButton);
                              }
                            : null,
                        child: Text("Confirmar motivo", style: FormStyles.getTextStyleTitle(font: 18, color: Colors.white),),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}