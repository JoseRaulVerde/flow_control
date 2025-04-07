import 'package:flow_control/models/event_timer.dart';
import 'package:flow_control/models/product.dart';
import 'package:flow_control/models/work_component.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class ProductsProvider extends ChangeNotifier {
  final log = Logger();
  
 List<Product> _Area = []; //  Mantiene los productos escaneados

  List<Product> get history => _Area; // Getter para acceder al historial


  void setHistory(List<Product> newHistory) {
    _Area = newHistory;
    notifyListeners(); // 🔥 Notifica a la UI cuando cambia
  }

  void clearHistory() {
    _Area.clear();
    notifyListeners();
  }
  WorkComponent? _component;

  WorkComponent? get component => _component; //getter para acceder al trabajo

  void setWokComponent(WorkComponent newWork){
    _component = newWork;
    notifyListeners();
  }

  void clearComponent() {
    _component = null; //  Borra el trabajo seleccionado
    notifyListeners(); // Notifica a la UI que se eliminó
  }

  EventTimer? _events;

  EventTimer? get events => _events; //getter para acceder al trabajo

  void setEventComponent(EventTimer newEvent){
    _events = newEvent;
    notifyListeners();
  }

  void clearEvent() {
    _events = null; //  Borra el trabajo seleccionado
    notifyListeners(); // Notifica a la UI que se eliminó
  }

  bool _isEventRunning = false;

  bool get isEventRunning => _isEventRunning;
  void setIsEventRunning(bool newTimer){
    _isEventRunning = newTimer;
  }

  void resetIsEventRunning (){
    _isEventRunning = false;
  }
}