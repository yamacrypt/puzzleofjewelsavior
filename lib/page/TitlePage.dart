import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_puzzle/filepathController.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'dart:async';
import '../InterfaceWidget.dart';
import 'CatergorySelectPage.dart';

class TitlePage extends StatelessWidget{
  //bool exit_check=false;
  void ExitPopup(BuildContext context){
    Alert(
      context: context,
      onWillPopActive: true,
      // type: AlertType.warning,
      title: "ゲームを終了しますか？",
      //desc: "Flutter is more awesome with RFlutter Alert.",
      content:Column( children:[
        DialogButton(
          child: Text(
            "Exit",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            //exit(0);
            Navigator.pop(context);
          },
          color: Color.fromRGBO(0, 179, 134, 1.0),
        ),
        DialogButton(
          child: Text(
            "Rate App",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          color:Color.fromRGBO(116, 116, 191, 1.0),
        ),
        DialogButton(
          child: Text(
            "Other Apps",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          color:  Color.fromRGBO(52, 138, 199, 1.0),
        )
      ]),
    ).show();
  }
  Future<bool> _onWillPop() async{
    ExitPopup(con);
    return true;
  }
  BuildContext con;
  @override
  Widget build(BuildContext context) {
    con=context;
    // TODO: implement build
    return  WillPopScope(
        onWillPop: _onWillPop,
        child:Scaffold(
        body:InterfaceWidget.Background(
            child:
            Positioned(
                top: 20,bottom: 0,right: 0,left: 0,
                child:Column(
                  children: [
                    Expanded(
                        flex:1,
                        child:Container(
                          alignment: Alignment.centerRight,
                          child: RawMaterialButton(
                            onPressed: () {ExitPopup(context);},
                            elevation: 2.0,
                            fillColor: Colors.red,
                            child:  Icon(
                                Icons.clear,
                                color: Colors.white,
                            ),
                            //padding: EdgeInsets.all(15.0),
                            shape: CircleBorder(),
                          )
                        )),
                    Expanded(
                      flex: 5,
                      child: Container(
                        child:Text("パズルゲーム"),
                        alignment: Alignment.center,
                      )
                    ),
                    Expanded(
                        flex: 3,
                        child: Container(
                          alignment: Alignment.center,
                          child:Column(
                            children: [

                                Container(
                                  //padding: EdgeInsets.all(10),
                                  child:SizedBox(
                                   // width: ,
                                  child:RaisedButton(
                                  child: Text("New Game"),
                                  onPressed: (){
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context)=>
                                            CategorySelectPage())
                                    );
                                  },

                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                  )

                              ),
                              Container(
                                    //padding: EdgeInsets.all(10),
                                    child:RaisedButton(
                                    child: Text("Load Game"),
                                    onPressed: () {  },
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                  )
                                 )
                              ,
                              /*Expanded(
                                  child:RaisedButton(
                                    child: Text("Gallery"),
                                    onPressed: () {  },
                                  )
                              ),*/
                            ],
                          ),
                        ))
                  ],
                )
            ))
        )
    );
  }

}
