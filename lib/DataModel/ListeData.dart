import 'dart:io';

import 'package:flutter_puzzle/FileUtils.dart';
import 'package:path_provider/path_provider.dart';

import '../main.dart';
import 'DataBaseModel.dart';

class GalleryListData {
  const GalleryListData({
    this.title,
    this.picPath,
    this.darkPicPath,
    this.imgWidth,
    this.imgHeight,
    this.targetRouteName,
    this.cleared,
    this.stageState
  });
  static String _getroot;

 static from(StageState ele,String root){

   // var root=await getFilePath();
    return GalleryListData(
        title: ele.characterName,
        picPath: ele.getpath(root),
        darkPicPath:  ele.getpath(root),
        imgWidth: 600,
        imgHeight: 800,
        targetRouteName: "ButtonPage.routeName",
        cleared: ele.clear==1 ? true : false,
        stageState: ele);
  }
  final String title;
  final String picPath;
  final String darkPicPath;
  final double imgWidth;
  final double imgHeight;
  final String targetRouteName;
  final bool cleared;
  final StageState stageState;
}
