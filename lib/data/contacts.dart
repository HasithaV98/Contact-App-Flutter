import 'dart:io';

class Contacts {
  //database id
  late int id;

  String name;
  String email;
  String phonenumber;
  bool inFavorite;
  File imageFile;

  Contacts({
    required this.email,
    required this.name,
    required this.phonenumber,
    this.inFavorite = false,
    required this.imageFile,
  });
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phoneNumber': phonenumber,
      'inFavorite': inFavorite ? 1 : 0,
      'imageFilePath': imageFile.path,
    };
  }

  static Contacts fromMap(Map<String, dynamic> map) {
    return Contacts(
      email: map['email'],
      name: map['name'],
      phonenumber: map['phonenumber'],
      inFavorite: map['inFavorite'] == 1 ? true : false,
      imageFile: map['imageFilePath'],
    );
  }
}
