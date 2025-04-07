import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class TimerProvider extends ChangeNotifier {
  bool _timerRunning = false;
  Duration _elapsed = Duration.zero;
  final log = Logger();

  bool get isRunning => _timerRunning;
  Duration get elapsed => _elapsed;

  void updateElapsed(Duration duration) {
    _elapsed = duration;
    notifyListeners();
  }
  void resetElapsed() {
    _elapsed = Duration.zero;
    notifyListeners();
  }

  void setRunning(bool running) {
    _timerRunning = running;
    // notifyListeners();
  }

  void reset() {
    log.d("entra a 2do reset");
    _elapsed = Duration.zero;
    // _timerRunning = false; // Asegúrate de tener esto
    notifyListeners();
  }
}