import 'dart:developer';
import 'dart:io' as io;
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';

import 'DataModel/DataBaseModel.dart';
import 'filepathController.dart';
enum ImageCategory{
  girl,boy,monster
}
class ImagePathStore{
  static Size _screenSize=Size.zero;
  static double _baseX,_baseY;
  static final double Aspectratio=4/3;
  static set ScreenSize(Size size){
     _screenSize=size;
     _baseX=size.width*(1/16);
     _baseY = (_screenSize.height - _screenSize.width) * 0.5;


  }
  static String unknownImagepath="images/unknown.png";
  static double get baseX{
     return _baseX;
}
  //screenSize.width * 0.1;
  static double get baseY{
    return _baseY;
  } //= (_screenSize.height - _screenSize.width) * 0.5;
  static String background_image_path="images/back2.png";
  //static List<String> path_list=['images/anime.png','images/1_free.jpg'] ;
 // String dirpath;
  /*ImagePathStore(this.directorypath){
  //  directorypath=path;
    files=_listofInsideFiles();
   //_listofFiles();
  }*/
  static filepathController _controller;
 setDirectoryPath(String dirpath){
    dirpath=dirpath;
  }
 ImagePathStore([bool local=false]){
   if(local) {
     _controller=externalpathController();
   }
   else{
    _controller=insidepathController();
   }
  // _controller=insidepathController();
  }
  Future<List<CharacterImageData>> getPath_List(ImageCategory category) async {
    switch(category){
      case ImageCategory.boy:return _getPath_List("boy");
      case ImageCategory.girl:return _getPath_List("girl");
      case ImageCategory.monster:return _getPath_List("monster");
      default :return _getPath_List("girl");
    }
  }
  Future<List<CharacterImageData>> _getPath_List(String path) async {
   //var controller1=insidepathController();
   //var controller2=externalpathController();
   //List<CharacterImageData> res=[...await controller1.getpath(path),...await controller2.getpath(path)];
  // res.addAll(await controller1.getpath(path));
  // res.addAll(await controller2.getpath(path));

   return _controller.getpath(path);
  }
  /*getGirlPath_List() {
    return _getPath_List("girl");
  }
  getBoyPath_List() {
    return _getPath_List("boy");
  }
  getMonsterPath_List() {
    return _getPath_List("monster");
  }*/
  /*getCharaBackground_PathList(){
   return _controller.getcharabackpath();
  }*/
  static List<String> getcharabackpath() {
    var folder="images/chara_background";
    var _pathlist=['$folder/blue.png','$folder/red.png','$folder/yellow.png','$folder/none.png'];
    return _pathlist;
  }
   List files = new List();
   List<String>_listofInsideFiles(){
    var folder="images/characters";
    List<String> path_list=['images/anime.png','$folder/f037.png','$folder/f044.png'];
   return  path_list;
  }
  void _listofFiles() async {

  //  directory = (await getApplicationDocumentsDirectory()).path;
    String directory = (await getApplicationDocumentsDirectory()).path;
    // Log.d(directory); _httpClient = HttpClient();
    var systemTempDir = Directory.systemTemp;
    directory=io.Directory.current.path;
    // List directory contents, recursing into sub-directories,
    log(directory);
    files = io.Directory("$directory").listSync() ;
    print(files.length);
    files.forEach((element) {log(element.toString());});
    files.map((e) => e.toString());
    /*setState(() {
     file = io.Directory("$directory/resume/").listSync();  //use your folder name insted of resume.
   });*/
  }
}
String CategorytoString(ImageCategory cg){
  return cg.toString().split(".").last;
}
ImageCategory StringtoCategory(String s) {
  switch (s) {
    case "girl":
      return ImageCategory.girl;
    case "monster" :
      return ImageCategory.monster;
    case "boy":
      return ImageCategory.boy;
    default:
      return ImageCategory.girl;
  }
}
