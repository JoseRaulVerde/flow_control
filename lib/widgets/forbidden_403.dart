import 'package:flow_control/utils/form_styles.dart';
import 'package:flutter/material.dart';

class Forbidden403 extends StatelessWidget {
  const Forbidden403({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Text(
                        "403",
                        style: FormStyles.getTextStyle(font: 120, color: CustomColors().greyBackground)
                      ),
                      Transform.rotate(
                        angle: .4,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(171, 68, 137, 255),
                            borderRadius: BorderRadius.circular(5)
                          ),
                          child: Text(
                            "Página no autorizada",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No cuentas con los permisos necesarios para accessar todos los datos. Contacta con tu administrador de TI',
                    textAlign: TextAlign.center,
                    style: FormStyles.getTextStyle(font: 16, color: Colors.black)
                  ),
                ],
              ),
            ),
          ),
        ),
      );
  }
}