import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:realtimechat/routes/routes.dart';
import 'package:realtimechat/services/auth_services.dart';
import 'package:realtimechat/services/chat_services.dart';
import 'package:realtimechat/services/socket_service.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthServices()),
        ChangeNotifierProvider(create: (_) => SocketService()),
        ChangeNotifierProvider(create: (_) => ChatService())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Chat App',
        initialRoute: 'loading',
        routes: appRoutes,
      ),
    );
  }
}
