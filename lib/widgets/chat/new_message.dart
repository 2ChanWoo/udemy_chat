import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewMessage extends StatefulWidget {
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = new TextEditingController();
  var _enteredMessage = '';
  int i = 0;
  //메세지 전송하는 함수. 파베DB에 메세지를 보낸다.
  void _sendMessage() async {
    FocusScope.of(context).unfocus();
    var user = await FirebaseAuth.instance.currentUser();
    final userData =
        await Firestore.instance.collection('users').document(user.uid).get();
//    Firestore.instance.collection('chat').add({
//      'text': _enteredMessage,
//      'createdAt': Timestamp.now(), // Timestamp : cloud_firestore 함수.
//      'userId': user.uid,
//      'username': userData['username'],
//      'userImage' : userData['image_url'],
//    });

                  //document는 돼도 컬렉션 이름을 원래 없던걸루해서 새로 만드는건 안되넹..
    Firestore.instance.collection('chat').document('한글').setData({
      'text': _enteredMessage,
      'createdAt': Timestamp.now(), // Timestamp : cloud_firestore 함수.
      'userId': user.uid,
      'username': userData['username'],
      'userImage' : userData['image_url'],
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'Send a message...'),
              onChanged: (value) {
                setState(() {
                  _enteredMessage = value;
                });
              },
            ),
          ),
          IconButton(
            color: Theme.of(context).primaryColor,
            icon: Icon(
              Icons.send,
            ),
            onPressed: _enteredMessage.trim().isEmpty ? null : _sendMessage,
          )
        ],
      ),
    );
  }
}
