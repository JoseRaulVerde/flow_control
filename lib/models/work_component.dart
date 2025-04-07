class WorkComponent {
  final String code;
  final String title;
  final String subtitle;
  final String category;

  WorkComponent({
    required this.code,
    required this.title,
    required this.subtitle,
    required this.category,
  });


  factory WorkComponent.fromJson(Map<String, dynamic> json) {
    return WorkComponent(
      title: json["ItemCode"] ,
      subtitle: json["ItemName"],
      category: json["ItemName"],
      code: json["ItemName"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "ItemCode": title,
      "ItemName": subtitle,
      "Code": code,
      "Category": category,
    };
  }
}