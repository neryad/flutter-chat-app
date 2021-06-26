import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:realtimechat/widgtes/chat_msg.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  List<ChatMessage> _messages = [
    // ChatMessage(texto: 'Hola mundo', uid: '123'),
    // ChatMessage(texto: 'Hola mundo como estas hoy?', uid: '123'),
    // ChatMessage(texto: 'Hola?', uid: '1234'),
    // ChatMessage(texto: 'No muy bien tengo unasola olla arriva ', uid: '1234')
  ];
  final _textCtrl = new TextEditingController();
  final _focusNode = new FocusNode();
  bool _estaEscribiendo = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Column(
          children: [
            CircleAvatar(
              child: Text(
                'Te',
                style: TextStyle(fontSize: 12),
              ),
              backgroundColor: Colors.blue[100],
              maxRadius: 14,
            ),
            SizedBox(
              height: 3,
            ),
            Text(
              'Melisa uno',
              style: TextStyle(color: Colors.black87, fontSize: 12),
            )
          ],
        ),
        centerTitle: true,
        elevation: 1,
      ),
      body: Container(
        child: Column(
          children: [
            Flexible(
                child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: _messages.length,
              itemBuilder: (_, i) => _messages[i],
              reverse: true,
            )),
            Divider(
              height: 1,
            ),
            Container(
              color: Colors.white,
              child: _inputChat(),
            )
          ],
        ),
      ),
    );
  }

  Widget _inputChat() {
    return SafeArea(
        child: Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Flexible(
            child: TextField(
              controller: _textCtrl,
              onSubmitted: _handlerSubmit,
              onChanged: (String texto) {
                setState(() {
                  if (texto.trim().length > 0) {
                    _estaEscribiendo = true;
                  } else {
                    _estaEscribiendo = false;
                  }
                });
              },
              decoration: InputDecoration.collapsed(hintText: "Enviar mensaje"),
              focusNode: _focusNode,
            ),
          ),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: Platform.isIOS
                  ? CupertinoButton(
                      child: Text('Enviar'),
                      onPressed: _estaEscribiendo
                          ? () => _handlerSubmit(_textCtrl.text.trim())
                          : null)
                  : Container(
                      margin: EdgeInsets.symmetric(horizontal: 4.0),
                      child: IconTheme(
                        data: IconThemeData(color: Colors.blue[400]),
                        child: IconButton(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            icon: Icon(Icons.send),
                            onPressed: _estaEscribiendo
                                ? () => _handlerSubmit(_textCtrl.text.trim())
                                : null),
                      ),
                    ))
        ],
      ),
    ));
  }

  _handlerSubmit(String texto) {
    if (texto.length == 0) {
      return;
    }
    //print(texto);
    _textCtrl.clear();
    _focusNode.requestFocus();

    final newMessage = new ChatMessage(
        texto: texto,
        uid: '123',
        animationController: AnimationController(
            vsync: this, duration: Duration(milliseconds: 200)));
    _messages.insert(0, newMessage);
    newMessage.animationController.forward();
    setState(() {
      _estaEscribiendo = false;
    });
  }

  @override
  void dispose() {
    //TODO : Off del caht
    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }
    super.dispose();
  }
}
