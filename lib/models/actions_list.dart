class ActionList {
  final String name;
  bool isRunning;

  ActionList({
    required this.name,
    this.isRunning = false,
  });

  factory ActionList.fromJson(Map<String, dynamic> json) {
    return ActionList(
      name: json["name"],
      isRunning: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "isRunning": isRunning,
    };
  }
}