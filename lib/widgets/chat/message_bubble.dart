import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  MessageBubble(this.message, this.userId, this.isMe, {this.key});

  final String message;
  final String userId;
  final bool isMe;
  final Key key;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: isMe ? Colors.grey[300] : Theme.of(context).accentColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
              bottomLeft: !isMe ? Radius.circular(0) : Radius.circular(12),
              bottomRight: isMe ? Radius.circular(0) : Radius.circular(12),
            ),
          ),
          width: 140,
          padding: EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 16,
          ),
          margin: EdgeInsets.symmetric(
            vertical: 4,
            horizontal: 8,
          ),
          child: Column(
            crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              FutureBuilder(
                //collection은 Future타입이지만, document는 아니라서, get()을 붙여주어 Future타입으로 만들어 줌.
                future: Firestore.instance.collection('users').document(userId).get(),
                builder: (ctx, snapshot) {
                  if(snapshot.connectionState == ConnectionState.waiting) {
                    return Text(' ');
                  }
                  return Text(snapshot.data['username'],
                    style: TextStyle(
                      color: isMe
                          ? Colors.black
                          : Theme.of(context).accentTextTheme.title.color,
                    ),
                  );
                },
              ),
              Text(
                message,
                style: TextStyle(
                  color: isMe
                      ? Colors.black
                      : Theme.of(context).accentTextTheme.title.color,
                ),
                textAlign: isMe? TextAlign.end : TextAlign.start,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
