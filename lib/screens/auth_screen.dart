import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:udemy_chat/widgets/auth/auth_form.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;

  void _submitAuthForm(
    //Future타입이 아닌데 async 가 되네??
    String email,
    String password,
    String username,
    File image,
    bool isLogin, //로그인 여부가 아니라, 로그인 모드인지, 회원가입 모드인지임.
    BuildContext ctx, //  스낵바 때문에 context 넘김.
  ) async {
    AuthResult authResult;

    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        //로그인모드
        authResult = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        //회원가입 모드
        //없으면 문서ID (authResult.user.uid)를 사로 만드는구나!
        authResult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        final ref = FirebaseStorage.instance
            .ref()
            .child('user_image')
            .child(authResult.user.uid + '.jpg');

        await ref.putFile(image).onComplete;

        final url = await ref.getDownloadURL();

        await Firestore.instance //위는 파베 Auth, 요거는 파베 DB~
            .collection('users')
            .document(authResult.user.uid)
            .setData({
          'username': username,
          'email': email,
          'image_url' : url,
        });
      }
      print('>>>>>>>>>>>>authResult : ${authResult.user.uid}');
    } on PlatformException catch (err) {
      var message = 'An error occurred, pelase check your credentials!';

      if (err.message != null) {
        message = err.message;
      }

      Scaffold.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      setState(() {
        _isLoading = false;
      });
//      print('print >>>> ${categorizeErrorCode(err.code)}');
      //강의 질문에 누가 올린건데 그냥 message도 충분히 설명 잘해주는데, 굳이 이걸 쓸 필요가 있을까 싶다.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(
        _submitAuthForm,
        _isLoading,
      ),
    );
  }
}

//https://www.udemy.com/course/learn-flutter-dart-to-build-ios-android-apps/learn/lecture/19510450#questions/11645808
// 질문명 : Display different error messages for different Firebase Auth error codes
//에서 가져옴. 쓸만해보이길래~
String categorizeErrorCode(String errorCode) {
  String errorMessage;
  switch (errorCode) {
    case "ERROR_INVALID_EMAIL":
      errorMessage = "Your email address appears to be malformed.";
      break;
    case "ERROR_INVALID_CREDENTIAL":
      errorMessage = "Your email address or password appears to be malformed.";
      break;
    case "ERROR_OPERATION_NOT_ALLOWED":
      errorMessage = "Anonymous accounts are disabled.";
      break;
    case "ERROR_WEAK_PASSWORD":
      errorMessage = "Your password is too weak.";
      break;
    case "ERROR_USER_DISABLED":
      errorMessage =
          "Your account has been disabled. Please contact the support.";
      break;
    case "ERROR_USER_NOT_FOUND":
      errorMessage =
          "Your account does no longer exist. Please contact the support.";
      break;
    case "ERROR_REQUIRES_RECENT_LOGIN":
      errorMessage =
          "Changing the password requires a recent sign-in. Please sign out and back in. Then try again.";
      break;
    case "ERROR_WRONG_PASSWORD":
      errorMessage = "The password is not correct. Please try again.";
      break;
    case "ERROR_WEAK_PASSWORD":
      errorMessage = "Your password is too weak.";
      break;
    case "ERROR_EMAIL_ALREADY_IN_USE":
      errorMessage = "This email is already in use by a different account.";
      break;
    case "ERROR_TOO_MANY_REQUESTS":
      errorMessage = "Too many requests. Try again later.";
      break;
    default:
      errorMessage = "An undefined error happened.";
  }
  return errorMessage;
}
