import 'dart:typed_data';
import 'dart:ui';
import 'dart:ui' as ui show instantiateImageCodec, Codec, Image, TextStyle;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_puzzle/magic/ImageNode.dart';
import 'package:flutter_puzzle/magic/PuzzleMagic.dart';
import 'package:flutter_puzzle/page/GamePage.dart';

class ImageProcessing{
  static Future<ui.Image> getImage(String path) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    FrameInfo frameInfo = await codec.getNextFrame();
    ui.Image image = frameInfo.image;
    return image;
  }
}
class GamePainter extends CustomPainter  {
  Paint mypaint;
  Path path;
  final int level;
  final List<ImageNode> nodes;
  final ImageNode hitNode;
  final bool needdraw;
  final bool needindex;
  final double downX, downY, newX, newY;
  final List<ImageNode> hitNodeList;
  Direction direction;
  //bool setting;
  ImageNode backnode;
  GameState gamestate;
  ImageNode lastnode;
  GamePainter(
      this.nodes,
      this.level,
      this.hitNode,
      this.hitNodeList,
      this.direction,
      this.downX,
      this.downY,
      this.newX,
      this.newY,
      this.needdraw,
      [this.needindex=true]
     ) {
    mypaint = Paint();
    mypaint.style = PaintingStyle.stroke;
    mypaint.strokeWidth = 1.0;
    mypaint.color = Color(0xa0dddddd);

    path = Path();
  }

  @override
  Future<void> paint(Canvas canvas, Size size)  async {
    /*if(backnode!=null&&backnode.image!=null){
      Rect rect2 = Rect.fromLTRB(
          backnode.rect.left, backnode.rect.top, backnode.rect.right, backnode.rect.bottom);
      Rect srcRect = Rect.fromLTRB(0.0, 0.0, backnode.image.width.toDouble(),
          backnode.image.height.toDouble());
      canvas.drawImageRect(backnode.image, srcRect, rect2, Paint());
    }*/
    if (nodes != null) {
      for (int i = 0; i < nodes.length; ++i) {

        ImageNode node = nodes[i];
        if(node.image==null)
          break;
        Rect rect2 = Rect.fromLTRB(
            node.rect.left, node.rect.top, node.rect.right, node.rect.bottom);
        if (hitNodeList != null && hitNodeList.contains(node)) {
          if (direction == Direction.left || direction == Direction.right) {
            rect2 = node.rect.shift(Offset(newX - downX, 0.0));
          } else if (direction == Direction.top ||
              direction == Direction.bottom) {
            rect2 = node.rect.shift(Offset(0.0, newY - downY));
          }
        }
        Rect srcRect = Rect.fromLTRB(0.0, 0.0, node.image.width.toDouble(),
            node.image.height.toDouble());
        canvas.drawImageRect(nodes[i].image, srcRect, rect2, Paint());

      }
      //Future<ui.Image> getImage(String path) async {

     // canvas.drawImageRect(img, Rect.fromLTRB(36,119,108,191),Rect.fromLTRB(252,270.2,558,641), Paint());


      //canvas.drawLine( Offset(150,150),Offset(100,500) , Paint());
      ui.TextStyle ts= ui.TextStyle(
        color: Colors.black,
        shadows: <Shadow>[
          Shadow(
            offset: Offset(0.0, 0.0),
            blurRadius: 3.0,
            color: Colors.white,
          ),
         /* Shadow(
            offset: Offset(10.0, 10.0),
            blurRadius: 8.0,
            color: Color.fromARGB(125, 0, 0, 255),
          ),*/
        ],
      );
      for (int i = 0; i < nodes.length; ++i) {
        if(!needindex){
          break;
        }
        ImageNode node = nodes[i];
        ParagraphBuilder pb = ParagraphBuilder(ParagraphStyle(
          textAlign: TextAlign.center,
          fontWeight: FontWeight.w300,
          fontStyle: FontStyle.italic,
          fontSize: /*hitNode == node ? 35.0 :*/ 25.0,
        ));
        pb.pushStyle(ts);
        if (hitNode == node) {
          pb.pushStyle(ui.TextStyle(color: Color(0xff00ff00)));
        }
        pb.addText('${node.index + 1}');
        ParagraphConstraints pc = ParagraphConstraints(width: node.rect.width);
        Paragraph paragraph = pb.build()..layout(pc);

        Offset offset = Offset(node.rect.left-paragraph.width/2+paragraph.height/2,
            node.rect.top );
        if (hitNodeList != null && hitNodeList.contains(node)) {
          if (direction == Direction.left || direction == Direction.right) {
            offset = Offset(offset.dx + newX - downX, offset.dy);
          } else if (direction == Direction.top ||
              direction == Direction.bottom) {
            offset = Offset(offset.dx, offset.dy + newY - downY);
          }
        }
        var paint1 = Paint()
          ..color = Color(0x7fffffff)
          ..style = PaintingStyle.fill;

        Offset circle_offset=Offset(offset.dx+paragraph.width/2,offset.dy+ paragraph.height/2);
        canvas.drawCircle(circle_offset,  paragraph.height/2, paint1);
        canvas.drawParagraph(paragraph, offset);
       // canvas.drawLine( offset,Offset(100,500) , Paint());
      }
    }
    if(gamestate==GameState.complete&&lastnode.image!=null){
      Rect rect2 = Rect.fromLTRB(
          lastnode.rect.left, lastnode.rect.top, lastnode.rect.right, lastnode.rect.bottom);
      /* if (hitNodeList != null && hitNodeList.contains(lastnode)) {
        if (direction == Direction.left || direction == Direction.right) {
          rect2 = lastnode.rect.shift(Offset(newX - downX, 0.0));
        } else if (direction == Direction.top ||
            direction == Direction.bottom) {
          rect2 = lastnode.rect.shift(Offset(0.0, newY - downY));
        }
      }*/
      Rect srcRect = Rect.fromLTRB(0.0, 0.0, lastnode.image.width.toDouble(),
          lastnode.image.height.toDouble());
      canvas.drawImageRect(lastnode.image, srcRect, rect2, Paint());

    }
  }

  @override
  bool shouldRepaint(GamePainter oldDelegate) {
    return this.needdraw || oldDelegate.needdraw;
  }
}
