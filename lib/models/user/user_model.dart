import 'dart:typed_data';

import 'package:string_validator/string_validator.dart';

class User {
  int? id;
  String? username;
  String? nama;
  String? hp;
  String? email;
  String? alamat1;
  String? alamat2;
  String? propinsiId;
  String? propinsiDesc;
  String? jnskel;
  String? token;
  String? userCabang;
  bool hasDownline;
  Uint8List? foto;
  String userType;
  String cstType;

  User({
    this.id,
    this.username,
    this.nama,
    this.hp,
    this.email,
    this.alamat1,
    this.alamat2,
    this.propinsiId,
    this.propinsiDesc,
    this.jnskel,
    this.token,
    this.userCabang,
    this.hasDownline = false,
    this.foto,
    this.userType = '',
    this.cstType = '',
  });

  factory User.fromDatabaseJson(Map<String, dynamic> data) => User(
        id: data['id'],
        username: data['username'],
        nama: data['nama'],
        hp: data['hp'],
        email: data['email'],
        alamat1: data['alamat1'] ?? '',
        alamat2: data['alamat2'] ?? '',
        propinsiId: data['propinsiId'] ?? '',
        propinsiDesc: data['propinsiDesc'] ?? '',
        jnskel: data['jnskel'] ?? '',
        userCabang: data['userCabang'] ?? '',
        hasDownline: toBoolean(data['hasDownline'].toString(), false),
        foto: data['foto'] ?? '',
        token: data['token'],
        userType: data['userType'] ?? '',
        cstType: data['cstType'] ?? '',
      );

  Map<String, dynamic> toDatabaseJson() => {
        "id": id,
        "username": username,
        "nama": nama,
        "hp": hp,
        "email": email,
        "alamat1": alamat1,
        "alamat2": alamat2,
        "propinsiId": propinsiId,
        "propinsiDesc": propinsiDesc,
        "jnskel": jnskel,
        "userCabang": userCabang,
        "hasDownline": hasDownline ? 1 : 0,
        "token": token,
        "foto": foto,
        "userType": userType,
        "cstType": cstType,
      };
}
