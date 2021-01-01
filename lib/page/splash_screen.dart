import 'package:flutter/material.dart';
import 'package:flutter_puzzle/InterfaceWidget.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: InterfaceWidget.Background(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(child:Text(
            "アプリの初期化処理中",
            style: TextStyle(
              //fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white
            ),
          ),),
          SizedBox(height: 20),
          CircularProgressIndicator()
        ],
      ))
    );
  }
}