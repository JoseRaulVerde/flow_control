class User {
  final int id;
  final String userName;
  final String? image;
  final String email;
  final String lastName;
  final String name;

  User({required this.email,required  this.lastName,required  this.name, required this.id, required this.userName, this.image });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"],
      userName: json["username"] ,
      image: json["profile_photo_url"],
      email: json["email"],
      lastName: json["apellido"],
      name: json["nombre"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "userName": userName,
      // "profile_photo_url": image,
      "email": email,
      "apellido": lastName,
      "nombre": name,
    };
  }
}