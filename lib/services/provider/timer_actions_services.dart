import 'package:flutter/scheduler.dart';
import 'package:flow_control/provider/timer_provider.dart';
import 'package:logger/logger.dart';

class TimerActionsService {
  final TimerProvider timerProvider;
  late final Ticker _ticker;
  final log = Logger();

  TimerActionsService(this.timerProvider) {
    _ticker = Ticker(_onTick);
  }

  void _onTick(Duration elapsed) {
    // solo actualiza si han pasado segundos completos
    if (elapsed.inSeconds != timerProvider.elapsed.inSeconds) {
      timerProvider.updateElapsed(elapsed);
    }
  }

  // Inicio de temporizador
  void start() {
    log.i("entra a start");
    if (!timerProvider.isRunning) {
      _ticker.start();
      timerProvider.setRunning(true);
    }else{
      _ticker.stop();
      timerProvider.reset();
      _ticker.start();
    }
  }

  // Pausa de Temporizador   
  void stop() {
    if (timerProvider.isRunning) {
      _ticker.stop();
      timerProvider.setRunning(false);
    }
  }

  // Borrado de temporizador y guardado en ceros 00:00:00
  void deleteTimer() {
    _ticker.stop();
    timerProvider.reset();
  }

  // Reinicio de temporizador y continua corriendo
  void reset() {
    log.i("entra a reset:");

    _ticker.stop();
    timerProvider.reset();

    _ticker.start();
  }

  
}