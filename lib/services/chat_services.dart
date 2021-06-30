import 'package:flutter/material.dart';
import 'package:realtimechat/global/enviroment.dart';
import 'package:realtimechat/models/mensajes_response.dart';
import 'package:realtimechat/models/usuarios.dart';
import 'package:http/http.dart' as http;
import 'package:realtimechat/services/auth_services.dart';

class ChatService with ChangeNotifier {
  late Usuario usuarioPara;

  Future<List<Mensaje>> getchat(String usuarioId) async {
    final res = await http
        .get(Uri.parse('${Enviroment.apiUrl}/mensajes/${usuarioId}'), headers: {
      'Content-Type': 'application/json',
      'x-token': await AuthServices.getToken()
    });

    final mensajesResponse = mensajesResponseFromJson(res.body);

    return mensajesResponse.mensajes;
  }
}
