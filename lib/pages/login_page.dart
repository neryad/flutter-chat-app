import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:realtimechat/helper/mostrar-alerta.dart';
import 'package:realtimechat/services/auth_services.dart';
import 'package:realtimechat/services/socket_service.dart';
import 'package:realtimechat/widgtes/btn_azul.dart';

import 'package:realtimechat/widgtes/custom_input.dart';
import 'package:realtimechat/widgtes/labels.dart';
import 'package:realtimechat/widgtes/logo.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height * .9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Logo(
                  titulo: 'Messenger',
                ),
                _Form(),
                Labels(
                  titulo: 'No tienes cuenta?',
                  subTitulo: 'Crea una ahora',
                  ruta: 'register',
                ),
                Text(
                  'Terminos y condiciones de uso',
                  style: TextStyle(fontWeight: FontWeight.w200),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Form extends StatefulWidget {
  // _Form({Key? key}) : super(key: key);

  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final socketServices = Provider.of<SocketService>(context);
    final authServices = Provider.of<AuthServices>(context);
    return Container(
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          CustomInput(
            icon: Icons.mail_outline,
            placeHolder: 'Correo',
            keyboardType: TextInputType.emailAddress,
            texEditController: emailCtrl,
          ),
          CustomInput(
            icon: Icons.lock_outline,
            placeHolder: 'Calve',
            texEditController: passwordCtrl,
            isPassword: true,
          ),
          BtnAzul(
              text: 'Ingresar',
              onPressed: () {
                if (authServices.autenticando) {
                  return null;
                } else {
                  getLogin(authServices, socketServices);
                }
                // authServices.autenticando
                //     ? null
                //     : () async {
                //         print('sdfds');
                //         FocusScope.of(context).unfocus();

                //         final loginOk = await authServices.login(
                //             emailCtrl.text.trim(), passwordCtrl.text.trim());

                //         if (loginOk) {
                //           //anevag
                //           print('mmg');
                //         } else {
                //           //mostrar alerta
                //           mostrarAlert(context, 'Login incorrecto',
                //               'Revisar crendeciales');
                //         }
                // };
              })
        ],
      ),
    );
  }

  getLogin(AuthServices authServices, SocketService socketServices) async {
    FocusScope.of(context).unfocus();

    final loginOk = await authServices.login(
        emailCtrl.text.trim(), passwordCtrl.text.trim());

    if (loginOk) {
      socketServices.connect();
      Navigator.pushReplacementNamed(context, 'usuarios');
    } else {
      //mostrar alerta
      mostrarAlert(context, 'Login incorrecto', 'Revisar crendeciales');
    }
  }
}
