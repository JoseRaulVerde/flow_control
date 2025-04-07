class Event {
  final String nameEvent;
  final DateTime startEvent;
  final DateTime? endEvent;

  Event({
    required this.nameEvent,
    required this.startEvent,
    this.endEvent,
  });
}

class EventTimer {
  Event? currentEvent;
  Event? previousEvent;

  EventTimer({
    this.currentEvent,
    this.previousEvent,
  });
}