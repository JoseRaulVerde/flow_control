import 'package:flow_control/models/event_timer.dart';
import 'package:flow_control/models/product.dart';
import 'package:flow_control/models/work_component.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class ProductsProvider extends ChangeNotifier {
  final log = Logger();
  
  List<Product> products1 = [
    Product(
      fabricationNote: "fabrasicationNote1", 
      client: "cliasent1", 
      name: "namase1", 
      color: "color1", 
      type: "type1", 
      image: "https://www.tiendasfrogs.com.mx/13272-large_default/PLAYERA-HOMBRE-ALGODON--SF-PARACHUTES.jpg",
      total: "300",
      currentAmount: "20",
      rest: "280",
    )
  ];

  List<Product> products2 = [
    Product(
      fabricationNote: "fabricationNotase2", 
      client: "clieasnt2", 
      name: "namase2", 
      color: "color2", 
      type: "type2", 
      image: "https://www.tiendasfrogs.com.mx/13192-large_default/PLAYERA-BASICA-ALGODON--SF-OLD-STYLE-HAWAII.jpg",
      total: "100",
      currentAmount: "60",
      rest: "40",
    )
  ];
  List<Product> products3 = [
    Product(
      fabricationNote: "fabricatiowednNasote2", 
      client: "clasesdnt2", 
      name: "namsasde2", 
      color: "colassdor2", 
      type: "typsde2", 
      image: "https://www.tiendasfrogs.com.mx/13192-large_default/PLAYERA-BASICA-ALGODON--SF-OLD-STYLE-HAWAII.jpg",
      total: "120",
      currentAmount: "80",
      rest: "40",
    )
  ];

 List<Product> _history = []; //  Mantiene los productos escaneados

  List<Product> get history => _history; // Getter para acceder al historial


  void setHistory(List<Product> newHistory) {
    _history = newHistory;
    notifyListeners(); // 🔥 Notifica a la UI cuando cambia
  }

  void clearHistory() {
    _history.clear();
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