import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:udemy_chat/screens/auth_screen.dart';
import 'package:udemy_chat/screens/chat_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlutterChat',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        backgroundColor: Colors.pink,
        accentColor: Colors.deepPurple,
        accentColorBrightness: Brightness.dark,
        buttonTheme: ButtonTheme.of(context).copyWith(
          buttonColor: Colors.pink,
          textTheme: ButtonTextTheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      home: StreamBuilder(
          stream: FirebaseAuth.instance.onAuthStateChanged,
          builder: (ctx, userSnapshot) {
            if (userSnapshot.hasData)
              {
                print('${userSnapshot.data.toString()}');
                return ChatScreen();}
            else
              return AuthScreen();
          }),
    );
  }
}
