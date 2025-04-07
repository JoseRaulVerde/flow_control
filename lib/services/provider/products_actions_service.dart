import 'package:flow_control/models/event_timer.dart';
import 'package:flow_control/models/work_component.dart';
import 'package:flutter/material.dart';
import 'package:flow_control/models/product.dart';
import 'package:flow_control/provider/product_provider.dart';
import 'package:logger/logger.dart';

class ProductsActionsService extends ChangeNotifier {
  final ProductsProvider productProvider;
  final log = Logger();

  ProductsActionsService(this.productProvider);


  // Método para agregar un producto al historial
  void addToHistory(Product product) {
  if (!productProvider.history.any((p) =>
      p.name == product.name && p.fabricationNote == product.fabricationNote)) {
    productProvider.history.add(product);
    productProvider.notifyListeners(); 
  } else {
  }
}

  // Método para limpiar el historial
  void clearHistory() {
    productProvider.history.clear();
    productProvider.clearComponent();
    productProvider.clearEvent();
    productProvider.resetIsEventRunning();
    productProvider.notifyListeners();
  }

  // Método para eliminar un producto del historial
  void deleteProduct(int index) {
    if (index >= 0 && index < productProvider.history.length) {
      productProvider.history.removeAt(index);
      productProvider.notifyListeners();
    }
  }

  void deleteProductsConfirmed(){
    productProvider.history.removeWhere((product) => product.confirmed == true);
    if(productProvider.history.isEmpty){
      productProvider.clearComponent();
      productProvider.resetIsEventRunning();
    }
    productProvider.notifyListeners();
  }

  // Metodo para seleccionar trabajo a realizar
  void addWorkComponent(WorkComponent addWork) {
    productProvider.setWokComponent(addWork); // Se usa el método correcto
    productProvider.notifyListeners();
  }

  void deleteWorkComponent() {
    productProvider.clearComponent(); // Borrar trabajo
    productProvider.notifyListeners();
  }

  //guardar productos generados 
  void addProductGenerated (int index, String amount ){
    productProvider.history[index].generated = amount;
    productProvider.notifyListeners();
  }

  // Finalizacion de producto 
  void confirmedProductHander (int index){
    productProvider.history[index].confirmed = true;
    //enviar a la base de datos
    productProvider.notifyListeners();
  }

  // Guardar ultimo evento 
  void addEvent(String name) {
    final now = DateTime.now();
    final newEvent = Event(nameEvent: name, startEvent: now);
    Event? previous;

   if (productProvider.events?.currentEvent != null) {
      final current = productProvider.events!.currentEvent!;
      previous = Event(
        nameEvent: current.nameEvent,
        startEvent: current.startEvent,
        endEvent: now,
      );
    }
    productProvider.setIsEventRunning(true);

    productProvider.setEventComponent(
      EventTimer(
        currentEvent: newEvent,
        previousEvent: previous // guarda el anterior
      ),
    );

    // Aquí podrías hacer un POST a la API si quieres registrar el inicio
    log.f("Nuevo evento iniciado: ${newEvent.nameEvent} a las ${newEvent.startEvent}");
    productProvider.notifyListeners();
  }

  // Guarda el final del evento 
  void addLastEvent() {
    final currentTime = DateTime.now();

    if (productProvider.events != null) {
      final current = productProvider.events!.currentEvent;

      final finishedEvent = Event(
        nameEvent: current!.nameEvent,
        startEvent: current.startEvent,
        endEvent: currentTime,
      );
      productProvider.setIsEventRunning(false); // revision y ajuste de modal 
      final stopEvent = Event(nameEvent: "Detener(${current.nameEvent})", startEvent: currentTime);

      productProvider.setEventComponent(
        EventTimer(
          currentEvent: stopEvent,
          previousEvent: finishedEvent,
        ),
      );

      // Aquí podrías hacer un POST a la API si quieres registrar el cierre
      log.f("Evento finalizado: ${finishedEvent.nameEvent} de ${finishedEvent.startEvent} a ${finishedEvent.endEvent}");
    }
    productProvider.notifyListeners();
  }
}