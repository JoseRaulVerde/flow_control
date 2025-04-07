import 'package:flow_control/provider/product_provider.dart';
import 'package:flow_control/provider/timer_provider.dart';
import 'package:flow_control/utils/form_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TimerWidget extends StatelessWidget {
  const TimerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductsProvider>(context);
    String getCurrentEventName() {
      return productProvider.events?.currentEvent?.nameEvent ?? '';
    }

    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              Text(
                "Evento en curso: ",
                style: FormStyles.getTextStyleTitle(
                  font: 16,
                  color: Colors.blueGrey,
                ),
              ),
              Text(
                getCurrentEventName(),
                style: FormStyles.getTextStyle(font: 18, color: Colors.blue),
              ),
            ],
          ),
        ),
        Consumer<TimerProvider>(
          builder: (context, timerProvider, child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTimerBox(timerProvider.elapsed.inHours, "Horas"),
                const SizedBox(width: 5),
                _buildTimerBox(
                  timerProvider.elapsed.inMinutes.remainder(60),
                  "Minutos",
                ),
                const SizedBox(width: 5),
                _buildTimerBox(
                  timerProvider.elapsed.inSeconds.remainder(60),
                  "Segundos",
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildTimerBox(int value, String label) {
    return Column(
      children: [
        Container(
          height: 50,
          width: 70,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey[300],
          ),
          child: Text(
            value.toString().padLeft(2, '0'),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
