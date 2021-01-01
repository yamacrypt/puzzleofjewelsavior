import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui show instantiateImageCodec, Codec, Image;
import 'dart:ui';
import 'dart:io' as io;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_puzzle/ImagePosInformation.dart';
import 'package:flutter_puzzle/imagestore.dart';
import 'package:flutter_puzzle/magic/ImageNode.dart';

class PuzzleMagic {
  ui.Image image;
  ui.Image backimage;
  double eachWidth;
  double eachHeight;
  Size screenSize;
  double baseX;
  double baseY;

  int level;
  double eachBitmapWidth;
  double eachBitmapHeight;
  Future<ui.Image> init(String path, int level,[String backpath]) async {

    if(backpath!=null){
      backimage= await getImage(backpath);
    }
    else{
      backimage=null;
    }
    image= await getImage(path,true);//.then((value) => image=value);
    //screenSize = size;
    this.level = level;
    eachWidth = ImgPosInfo.drawingwidth / level;
    ImgPosInfo.AspectRatio(image.height /image.width);
    eachHeight= ImgPosInfo.drawingheight /level ;
    baseX = ImgPosInfo.baseX;//screenSize.width * 0.1;
    baseY = ImgPosInfo.baseY;//(screenSize.height - screenSize.width) * 0.5;

    eachBitmapWidth = (image.width / level);
    eachBitmapHeight = (image.height / level);
    return image;
  }

  Future<ui.Image> getImage(String path,[bool local=false]) async {
    //ui.Image res;
    ui.Codec codec;
    if(local){
      codec  = await ui.instantiateImageCodec(io.File(path).readAsBytesSync()) ;
    }
    else {
      ByteData data = await rootBundle.load(path);
      codec = await ui.instantiateImageCodec(
          data.buffer.asUint8List());
    }
    FrameInfo frameInfo = await codec.getNextFrame();
    //*res = frameInfo.image;
    return frameInfo.image;
  }

  List<ImageNode> doTask() {
    List<ImageNode> list = [];
    for (int j = 0; j < level; j++) {
      for (int i = 0; i < level; i++) {
        if (j * level + i < level * level - 1) {
          ImageNode node = ImageNode();
          node.rect = getOkRectF(i, j);
          node.index = j * level + i;
          makeBitmap(node);
          list.add(node);
        }
        /*else{
          ImageNode node = ImageNode();
          node.rect = getOkRectF(i, j);
          node.index = j * level + i;
          makeBitmap(node);
         list.add(node);
        }*/

      }
    }

    return list;
  }
  ImageNode getLastPiece(){
    int i=level-1;
    int j=i;
    ImageNode node = ImageNode();
    node.rect = getOkRectF(i, j);
    node.index = j * level + i;
    makeBitmap(node);
    return node;
  }

  Rect getOkRectF(int i, int j) {
    return Rect.fromLTWH(
        baseX + eachWidth * i, baseY + eachHeight * j, eachWidth, eachHeight);
  }

  void makeBitmap(ImageNode node,[bool drawing = true]) async {
    int i = node.getXIndex(level);
    int j = node.getYIndex(level);

    Rect rect = getShapeRect(i, j, eachBitmapWidth,eachBitmapHeight);
    rect = rect.shift(
        Offset(eachBitmapWidth.toDouble() * i, eachBitmapHeight.toDouble() * j));

    PictureRecorder recorder = PictureRecorder();
    double ww = eachBitmapWidth.toDouble();
    double hh = eachBitmapHeight.toDouble();
    Canvas canvas = Canvas(recorder, Rect.fromLTWH(0.0, 0.0, ww, hh));

    Rect rect2 = Rect.fromLTRB(0.0, 0.0, rect.width, rect.height);

    Paint paint = Paint();
    if(drawing) {
      if(backimage!=null)
      canvas.drawImageRect(backimage, rect, rect2, paint);
      canvas.drawImageRect(image, rect, rect2, paint);
    }
   node.image = await recorder.endRecording().toImage(ww.floor(), hh.floor());// as ui.Image;
    node.rect = getOkRectF(i, j);
  }

  Rect getShapeRect(int i, int j, double width,double height) {
    return Rect.fromLTRB(0.0, 0.0, width, height);
  }
}
