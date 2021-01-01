import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import 'DataModel/DataBaseModel.dart';

class insidepathController extends filepathController{
  List<String> _pathlist;

  @override
  Future<List<CharacterImageData>> getpath([String childdir]) async {
    var folder="images/characters/$childdir/";
    //String loadData =await rootBundle.loadString(folder+"charadata.json");
    JsonCodec jsonCodec=JsonCodec();
    // _pathlist=['$folder/f003.png','$folder/f037.png','$folder/f044.png','$folder/1_free.jpg','images/anime.png'];
    List<CharacterImageData> ls=[];
     dynamic res=await loadJsonAsset("images/characters/charadata.json",childdir);
        res.forEach((key,value)=>
            ls.add(CharacterImageData('$folder$key.png', value))

    );
    return ls;
  }

  insidepathController(){

  }

 /* @override
  List<String> getcharabackpath() {
    var folder="images/chara_background";
    _pathlist=['$folder/blue.png','$folder/red.png','$folder/yellow.png','$folder/none.png'];
   // List<CharacterImageData> res=[]
    return _pathlist;
  }*/

}
class externalpathController extends filepathController{
  String dirpath;
  List<String> _pathlist;
  Future<String> getFilePath([String filename=""]) async {
    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory(); // 1
    String appDocumentsPath = appDocumentsDirectory.path; // 2
    String filePath = '$appDocumentsPath/$filename'; // 3

    return filePath;
  }
  /*Future<dynamic> loadJsonFile(String path,String childdir) async {
   // String loadData = await rootBundle.loadString(path);
    final jsonResponse = json.decode(await File(path).readAsString());
    jsonResponse[childdir];
    return jsonResponse[childdir];
    //jsonResponse.forEach((key,value) => _data = _data + '$key: $value \x0A');
  }*/
  Future<List<CharacterImageData>>  getpath([String childdir]) async{
   String folder=await getFilePath();
   String jsonpath=folder+"charadata.json";
    List<CharacterImageData> ls=[];
    dynamic res=await loadJsonAsset("images/characters/allcharadata.json",childdir);
    res.forEach((key,value)=>
        ls.add(CharacterImageData('$folder$childdir/$key.png', value))

    );
    return ls;
  }
  _setpath() {
    // TODO: implement setpath
    //return null;
  }




}
abstract class filepathController{
  //List<String> _pathlist;
  Future<List<CharacterImageData>> getpath([String childdir]);
  Future<dynamic> loadJsonAsset(String path,String childdir) async {
    String loadData = await rootBundle.loadString(path);
    final jsonResponse = json.decode(loadData);
    jsonResponse[childdir];
    return jsonResponse[childdir];
    //jsonResponse.forEach((key,value) => _data = _data + '$key: $value \x0A');
  }
  //List<String> getcharabackpath();
  //List<String> _setpath();
}
