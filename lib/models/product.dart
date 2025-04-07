
class Product {
  final String fabricationNote;
  final String client;
  final String name;
  final String color;
  final String type;
  final String image;
  final String total;
  final String currentAmount;
  final String rest;
  String? generated;
  bool confirmed = false; 


  Product( {
    required this.fabricationNote,
    required this.client,
    required this.name,
    required this.color,
    required this.type,
    required this.image,
    required this.total,
    required this.currentAmount,
    required this.rest,
    this.generated,
    this.confirmed = false,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      fabricationNote: json["ItemCode"] ,
      client: json["ItemName"],
      name: json["CodeBars"] ,
      color: json["ItmsGrpNam"],
      type: json["Price"],
      image: json["WhsCode"],
      total: json["Total"],
      currentAmount: json["CurrentAmount"],
      rest: json["RestAmount"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "ItemCode": fabricationNote,
      "ItemName": client,
      "CodeBars": name,
      "ItmsGrpNam": color,
      "Price": type.toString(),
      "WhsCode": image,
      "Total": total,
      "CurrentAmount": currentAmount,
      "RestAmount": rest,
    };
  }
}