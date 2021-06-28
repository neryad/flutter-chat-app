import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:realtimechat/global/enviroment.dart';
import 'package:realtimechat/models/login_response.dart';
import 'package:realtimechat/models/usuarios.dart';

class AuthServices with ChangeNotifier {
  late Usuario usuario;
  bool _autenticando = false;
  final _storage = new FlutterSecureStorage();
  bool get autenticando => this._autenticando;
  set autenticando(bool valor) {
    this._autenticando = valor;
    notifyListeners();
  }

  //Getter toke staticos
  static Future<String> getToken() async {
    final _storage = new FlutterSecureStorage();
    final token = await _storage.read(key: 'token');
    return token!;
  }

  static Future<void> deleteToken() async {
    final _storage = new FlutterSecureStorage();
    await _storage.delete(key: 'token');
  }

  Future<bool> login(String email, String password) async {
    this.autenticando = true;

    final data = {'email': email, 'password': password};

    final res = await http.post(Uri.parse('${Enviroment.apiUrl}/login'),
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});
    //print(res.body);
    this.autenticando = false;
    if (res.statusCode == 200) {
      final loginRes = loginResponseFromJson(res.body);
      this.usuario = loginRes.userDb;
      await this._guardarToken(loginRes.token!);
      return true;
    } else {
      return false;
    }
  }

  Future register(String name, String email, String password) async {
    this.autenticando = true;

    final data = {'name': name, 'email': email, 'password': password};

    final res = await http.post(Uri.parse('${Enviroment.apiUrl}/login/new'),
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});
    //print(res.body);
    this.autenticando = false;
    if (res.statusCode == 200) {
      final registerRes = loginResponseFromJson(res.body);
      this.usuario = registerRes.userDb;
      await this._guardarToken(registerRes.token!);
      return true;
    } else {
      final resBody = jsonDecode(res.body);
      return resBody['msg'];
    }
  }

  Future<bool> isLoggedIn() async {
    //TODO verificar bien esto
    var token = await this._storage.read(key: 'token');

    if (token == null) {
      token = 'asdsd';
    }

    final res = await http.get(Uri.parse('${Enviroment.apiUrl}/login/renew'),
        headers: {'Content-Type': 'application/json', 'x-token': token});

    //print(res.body);
    this.autenticando = false;
    if (res.statusCode == 200) {
      final registerRes = loginResponseFromJson(res.body);
      this.usuario = registerRes.userDb;
      await this._guardarToken(registerRes.token!);
      return true;
    } else {
      this.logOut();
      return false;
    }
  }

  Future _guardarToken(String token) async {
    return await _storage.write(key: 'token', value: token);
  }

  Future logOut() async {
    await _storage.delete(key: 'token');
  }
}
