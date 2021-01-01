import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'ImagePosInformation.dart';
import 'imagestore.dart';
import 'dart:io' as io;
class InterfaceColumn {
  InterfaceColumn({
    Key key,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    MainAxisSize mainAxisSize = MainAxisSize.max,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    TextDirection textDirection,
    VerticalDirection verticalDirection = VerticalDirection.down,
    TextBaseline textBaseline,
    List<Widget> children = const <Widget>[],
  });
}
class InterfaceWidget{
  static Color borderColor=Color.fromARGB(255, 85, 61, 41);
  static Widget Decoration({Widget child,bool top=false,bool  left=false,bool  right=false,bool bottom=false}){
    Border border_edge=Border.all(
      color: borderColor,
      width: 1,
    );
    BorderSide side=BorderSide(width: 1.0, color: borderColor);
    Border border=Border(
     top:top?side : BorderSide.none,
      left:left?side : BorderSide.none,
      right:right?side : BorderSide.none,
      bottom:bottom?side : BorderSide.none,

    );
    return Container(
        child: child,
        decoration: BoxDecoration(
        border: border,

    )
    );
  }
  /*static Widget Decoration({Flex child}){
    List<Widget> children=child.children;
    List<Widget> ls=[];
    Border border_edge=Border.all(
      color: Color.fromARGB(255, 85, 61, 41),
      width: 1,
    );
    Border border_center=Border(
      top: BorderSide(width: 1.0, color: Color.fromARGB(255, 85, 61, 41)),
      left: BorderSide(width: 1.0, color: Color.fromARGB(255, 85, 61, 41)),
      //right: BorderSide(width: 1.0, color: Color(0xFFFF000000)),
      bottom: BorderSide(width: 1.0, color:Color.fromARGB(255, 85, 61, 41)),
    );
    children.asMap().forEach((index,e) =>{
      index==children.length-1 ?

      ls.add(Container(
        child: e,
        decoration: BoxDecoration(
          border: border_edge,

          // borderRadius: BorderRadius.circular(12),
        ),
      )
      )

          :
      ls.add(Container(
        child: e,
        decoration: BoxDecoration(
          border: border_center,

          // borderRadius: BorderRadius.circular(12),
        ),
      )
      )

    });
    if(child.direction==Axis.horizontal)
      return Row(children: ls,);
    else if(child.direction==Axis.vertical){
      return Column(children: ls,);
    }
   // Flex res=Flex(children: ls,);
    return child;
  }*/

  static Widget Background({Widget child}){
    return Stack(
      fit: StackFit.expand,
      children: [
      Image.asset(
      'images/background.jpg',
      height: double.infinity,
      width: double.infinity,
      fit: BoxFit.fill,
    ),
        child,
        ],
    );
  }
  static Widget CompletedPicture(String path,[bool local=false]){
    return Positioned(
        top:ImgPosInfo.baseY,
        left: ImgPosInfo.baseX,
        //right: ImgPosInfo.baseX,
        child: local?
        Image.file(
          io.File(path),
          width: ImgPosInfo.drawingwidth,
          height: ImgPosInfo.drawingheight,
          //alignment: FractionalOffset.topCenter,
          fit: BoxFit.fill  ,
        )
            :Image.asset(
        path,
        width: ImgPosInfo.drawingwidth,
        height: ImgPosInfo.drawingheight,
        //alignment: FractionalOffset.topCenter,
        fit: BoxFit.fill  ,
    ));
  }
  static Widget InterfaceRow(
      {
  Key key,
  MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
  MainAxisSize mainAxisSize = MainAxisSize.max,
  CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
  TextDirection textDirection,
  VerticalDirection verticalDirection = VerticalDirection.down,
  TextBaseline textBaseline,
  List<Widget> children = const <Widget>[],
  expanded=true})
  {
    List<Widget> ls=[];
    Border border_edge=Border.all(
      color:borderColor,
      width: 1,
    );
    Border border_center=Border(
      top: BorderSide(width: 1.0, color:borderColor),
      left: BorderSide(width: 1.0, color: borderColor),
      //right: BorderSide(width: 1.0, color: Color(0xFFFF000000)),
      bottom: BorderSide(width: 1.0, color:borderColor),
    );
    children.asMap().forEach((index,e) =>{
      index==children.length-1 ?

        expanded?ls.add(Expanded(child:Container(
          child: e,
          decoration: BoxDecoration(
            border: border_edge,

            // borderRadius: BorderRadius.circular(12),
          ),
        ),)
        )
        :ls.add(Container(
          child: e,
          decoration: BoxDecoration(
            border: border_edge,

            // borderRadius: BorderRadius.circular(12),
          ),
        ),
        )
      :
        ls.add(Container(
          child: e,
          decoration: BoxDecoration(
            border: border_center,

            // borderRadius: BorderRadius.circular(12),
          ),
        )
        )

    });
    return Row(children: ls,);
  }

}
