import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:realtimechat/helper/mostrar-alerta.dart';
import 'package:realtimechat/services/auth_services.dart';
import 'package:realtimechat/widgtes/btn_azul.dart';

import 'package:realtimechat/widgtes/custom_input.dart';
import 'package:realtimechat/widgtes/labels.dart';
import 'package:realtimechat/widgtes/logo.dart';

class RegisterPage extends StatelessWidget {
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
                  titulo: 'Registro',
                ),
                _Form(),
                Labels(
                  titulo: 'Tienes una cuenta?',
                  subTitulo: 'Ingresa ahora',
                  ruta: 'login',
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
  final nombreCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final authServices = Provider.of<AuthServices>(context);
    return Container(
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          CustomInput(
            icon: Icons.perm_identity,
            placeHolder: 'Nombre',
            texEditController: nombreCtrl,
          ),
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
              text: 'Crear cuenta',
              onPressed: () {
                if (authServices.autenticando) {
                  return null;
                } else {
                  getRegister(authServices);
                }
              })
        ],
      ),
    );
  }

  getRegister(AuthServices authServices) async {
    FocusScope.of(context).unfocus();

    final resgiterOk = await authServices.register(nombreCtrl.text.trim(),
        emailCtrl.text.trim(), passwordCtrl.text.trim());

    if (resgiterOk == true) {
      //anevag
      Navigator.pushReplacementNamed(context, 'usuarios');
    } else {
      //mostrar alerta
      mostrarAlert(context, 'Registro incorrecto', resgiterOk);
    }
  }
}
