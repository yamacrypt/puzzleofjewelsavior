import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_puzzle/InterfaceWidget.dart';
import 'package:flutter_puzzle/gallery_bloc.dart';
import 'package:flutter_puzzle/page/CatergorySelectPage.dart';
import 'package:flutter_puzzle/page/GamePage.dart';
import 'package:flutter_puzzle/page/SelectPage.dart';
import 'package:flutter_puzzle/page/TitlePage.dart';
import 'package:flutter_puzzle/page/splash_screen.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'DataModel/DataBaseModel.dart';
import 'DataBase.dart';
import 'FileUtils.dart';
import 'ImagePosInformation.dart';
import 'downloader.dart';
import 'imagestore.dart';
void main() async{

  runApp(App());
  SystemChrome.setEnabledSystemUIOverlays([]);
  //[SystemUiOverlay.bottom,SystemUiOverlay.top]
  var downloader=Downloader();
  downloader.init();
 /* final SharedPreferences prefs = await SharedPreferences.getInstance();
  bool initialized =prefs.getBool('initialized')??false;
  if(initialized==false) {
    await AppInit().doTask();
    prefs.setBool('initialized', true);
  }*/

}

class AppInit{
  static AppInit _ap;
  AppInit._();
  factory AppInit(){
    if(_ap==null)
      _ap=AppInit._();
    return _ap;
  }
  doTask() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool initialized =prefs.getBool('initialized')??false;
    if(initialized==true)
      return ;
    var statedb= DBProvider(DBName.state);
    await statedb.reset();
    await Future.forEach( ImageCategory.values,(category) async{

      // var a=await statedb.getAll();
      /*  List<StageState> assetlist=[];
      dynamic res1=await loadJsonAsset("images/characters/charadata.json",CategorytoString(category));
       for(var key in res1.keys){
         var value=res1[key];
         var state = StageState(
             pictureName: key, characterName: value, category: category,unlock: 1,clear: 0);
         //await statedb.insert(state);
         assetlist.add(state);
       }*/
      var store=ImagePathStore();
      var assetlist=await store.getPath_List(category);
      var categoryfolder=await getFilePath(category.toString().split('.').last);
      /*if(Directory(categoryfolder ).existsSync()==false) {
          new Directory(categoryfolder).create(recursive: true);
        }*/


      // String folder=await getFilePath();
      //String jsonpath=folder+"charadata.json";
      List<StageState> ls=[];
      dynamic res=await loadJsonAsset("images/characters/allcharadata.json",CategorytoString(category));
      /*for(int i;i<res.length;i++){
        var state = StageState(
            pictureName: res[i][0], characterName: value, category: category);
        ls.add(state);
      }*/
      /* await Future.wait(
          res.forEach(await (key,value)=> () async{
            var state = StageState(
                pictureName: key, characterName: value, category: category);
            await statedb.insert(state);
          })
      );*/
      /* await res.forEach( (key,value)=> () {
        var state = StageState(
            pictureName: key, characterName: value, category: category);
        ls.add(state)
      }
      await statedb.insert(state);
      );*/
      for(var key in res.keys){
        var value=res[key];
        var state = StageState(
            pictureName: key, characterName: value, category: category,unlock: 0,clear: 0);
        await statedb.insert(state);
      }
      await Future.forEach(assetlist, (element) async {
        var path= categoryfolder+"/"+element.path.split("/").last;
        if(File(path).existsSync()==false){
          await File(path).create(recursive: true);
          ByteData data=await rootBundle.load(element.path);
          File(path).writeAsBytesSync(data.buffer?.asUint8List());

        }
        await  statedb.update_unlock(element.path.split("/").last.split(".").first);
      });
    });
    prefs.setBool('initialized', true);
  }
  Future<dynamic> loadJsonAsset(String path,String childdir) async {
    String loadData = await rootBundle.loadString(path);
    final jsonResponse = json.decode(loadData);
    jsonResponse[childdir];
    return jsonResponse[childdir];
    //jsonResponse.forEach((key,value) => _data = _data + '$key: $value \x0A');
  }
}




class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Future _initFuture = AppInit().doTask();
    return
      MaterialApp(
          title: "puzzle",
          theme: ThemeData.light(),
          home:FutureBuilder(
                        future: _initFuture,
                  builder: (context, snapshot){
                  if (snapshot.connectionState == ConnectionState.done){
                  return CategorySelectPage();
                  } else {
                  return SplashScreen();
                  }
                        }//TitlePage()
          )

        // HomePage2(),

        //backgroundColor:  Image.asset("images/bacjground.jpg"),
      );
  }
}
