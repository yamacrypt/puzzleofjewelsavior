import 'dart:ui';

import 'package:flutter/cupertino.dart';

class ImgPosInfo{
static Size _screenSize=Size.zero;

static Size get screenSize => _screenSize;
  static double _baseX,_baseY;
static double _Aspectratio=4/3;

//static double get Aspectratio => _Aspectratio;

  static  AspectRatio(double val){
  _Aspectratio=val;
  drawingheight=drawingwidth* _Aspectratio;
}
static double drawingwidth,drawingheight;
static set ScreenSize(Size size){
_screenSize=size;
drawingwidth=size.width*(7/8);
//drawingheight=drawingwidth* Aspectratio;

_baseX=size.width*(1/16);
_baseY = (_screenSize.height - _screenSize.width) * 0.5;

}
static double get baseX{
return _baseX;
}
//screenSize.width * 0.1;
static double get baseY{
return _baseY;
}
}