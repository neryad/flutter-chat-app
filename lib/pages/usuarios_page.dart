import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:realtimechat/models/usuarios.dart';
import 'package:realtimechat/services/auth_services.dart';
import 'package:realtimechat/services/chat_services.dart';
import 'package:realtimechat/services/socket_service.dart';
import 'package:realtimechat/services/usuarios_services.dart';

class UsuariosPage extends StatefulWidget {
  @override
  _UsuariosPageState createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  final usarioServices = UsuarioService();
  List<Usuario> usuarios = [];
  @override
  void initState() {
    this._cargarUsurios();
    super.initState();
  }

  // final usuarios = [
  //   Usuario(uid: '1', name: 'Eduardo', email: 'katiro@gamil.com', online: true),
  //   Usuario(uid: '2', name: 'Caixto', email: 'Ulloa@gamil.com', online: true),
  //   Usuario(uid: '3', name: 'Dayern', email: 'gomez@gamil.com', online: true),
  //   Usuario(uid: '4', name: 'Necio', email: 'neio@gamil.com', online: false),
  // ];
  @override
  Widget build(BuildContext context) {
    final authServices = Provider.of<AuthServices>(context);
    final socketServices = Provider.of<SocketService>(context);
    final usuario = authServices.usuario;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            usuario.name!,
            style: TextStyle(color: Colors.black),
          ),
          elevation: 1,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.black,
            ),
            onPressed: () {
              socketServices.disconnect();
              Navigator.pushReplacementNamed(context, 'login');
              AuthServices.deleteToken();
            },
          ),
          actions: [
            Container(
              margin: EdgeInsets.only(right: 10),
              child: (socketServices.serverStatus == ServerStatus.Online)
                  ? Icon(
                      Icons.check_circle,
                      color: Colors.blue,
                    )
                  : Icon(
                      Icons.offline_bolt,
                      color: Colors.red,
                    ),
            )
          ],
        ),
        body: SmartRefresher(
          controller: _refreshController,
          enablePullDown: true,
          onRefresh: _cargarUsurios,
          header: WaterDropHeader(
            complete: Icon(
              Icons.check,
              color: Colors.blue[400],
            ),
            waterDropColor: Colors.blue[400]!,
          ),
          child: _listViewUsuarios(),
        ));
  }

  ListView _listViewUsuarios() {
    return ListView.separated(
        physics: BouncingScrollPhysics(),
        itemBuilder: (_, i) => _usuariosListTitle(usuarios[i]),
        separatorBuilder: (_, i) => Divider(),
        itemCount: usuarios.length);
  }

  ListTile _usuariosListTitle(Usuario usuario) {
    return ListTile(
      title: Text(usuario.name!),
      subtitle: Text(usuario.email!),
      leading: CircleAvatar(
        child: Text(usuario.name!.substring(0, 2)),
      ),
      trailing: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
            color: usuario.online! ? Colors.green[300] : Colors.red,
            borderRadius: BorderRadius.circular(100)),
      ),
      onTap: () {
        final chatService = Provider.of<ChatService>(context, listen: false);
        chatService.usuarioPara = usuario;
        Navigator.pushNamed(context, 'chat');
      },
    );
  }

  _cargarUsurios() async {
    this.usuarios = await usarioServices.getUsuarios();
    setState(() {});
    // monitor network fetch
    //await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }
}
