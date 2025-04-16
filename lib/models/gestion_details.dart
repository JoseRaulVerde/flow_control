class GestionDetails {
  final int id;
  final String code;
  final String name;
  final String desc;
  final String color;
  final String createdAt;
  final String updatedAt;

  GestionDetails({
    required this.id,
    required this.code,
    required this.name,
    required this.desc,
    required this.color,
    required this.createdAt,
    required this.updatedAt,
  });

  factory GestionDetails.fromJson(Map<String, dynamic> json) {
    return GestionDetails(
      id: json['id'],
      code: json['codigo'] ?? '',
      name: json['nombre'] ?? '',
      desc: json['descripcion'] ?? '',
      color: json['color'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'codigo': code,
      'nombre': name,
      'descripcion': desc,
      'color': color,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}