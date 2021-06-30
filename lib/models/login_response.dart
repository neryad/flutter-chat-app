// To parse this JSON data, do
//
//    final loginResponse = loginResponseFromJson(jsonString);

import 'dart:convert';

import 'package:realtimechat/models/usuarios.dart';

LoginResponse loginResponseFromJson(String str) =>
    LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  LoginResponse({
    this.ok,
    this.msg,
    required this.usuario,
    this.token,
  });

  bool? ok;
  String? msg;
  Usuario usuario;
  String? token;

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        //TODO arreglar el json de usuario a usuario
        ok: json["ok"],
        msg: json["msg"],
        usuario: Usuario.fromJson(json["usuario"]),
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "msg": msg,
        "usuario": usuario.toJson(),
        "token": token,
      };
}
