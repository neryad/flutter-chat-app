import 'package:realtimechat/global/enviroment.dart';
import 'package:realtimechat/models/usuarios.dart';
import 'package:http/http.dart' as http;
import 'package:realtimechat/models/usuarios_response.dart';
import 'package:realtimechat/services/auth_services.dart';

class UsuarioService {
  Future<List<Usuario>> getUsuarios() async {
    try {
      final resp = await http.get(Uri.parse('${Enviroment.apiUrl}/usuarios'),
          headers: {
            'Content-type': 'application/json',
            'x-token': await AuthServices.getToken()
          });

      final usuariosRes = usuarioResponseFromJson(resp.body);

      return usuariosRes.usuarios;
    } catch (e) {
      return [];
    }
  }
}
