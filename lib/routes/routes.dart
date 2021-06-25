import 'package:flutter/material.dart';
import 'package:realtimechat/pages/chat_page.dart';
import 'package:realtimechat/pages/loadin_page.dart';
import 'package:realtimechat/pages/login_page.dart';
import 'package:realtimechat/pages/register_page.dart';
import 'package:realtimechat/pages/usuarios_page.dart';

final Map<String, Widget Function(BuildContext)> appRoutes = {
  'usuarios': (_) => UsuariosPage(),
  'chat': (_) => ChatPage(),
  'login': (_) => LoginPage(),
  'register': (_) => RegisterPage(),
  'loading': (_) => LoadingPage(),
};
