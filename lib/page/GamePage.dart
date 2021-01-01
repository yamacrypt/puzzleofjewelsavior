import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_puzzle/DataBase.dart';
import 'package:flutter_puzzle/DataModel/DataBaseModel.dart';
import 'package:flutter_puzzle/ImagePosInformation.dart';
import 'package:flutter_puzzle/InterfaceWidget.dart';
import 'package:flutter_puzzle/magic/GameEngine.dart';
import 'package:flutter_puzzle/magic/GamePainter.dart';
import 'package:flutter_puzzle/magic/ImageNode.dart';
import 'package:flutter_puzzle/magic/PuzzleMagic.dart';
import 'package:flutter_puzzle/main.dart';
import 'package:flutter_puzzle/page/CatergorySelectPage.dart';
import 'package:flutter_puzzle/page/GameSettingPage.dart';


import '../BackgroundMagic.dart';
import '../imagestore.dart';

class GamePage extends StatefulWidget {
  /*final Size size;
  final String imgPath;
  final int level;
  final int problem_index;
  final bool needindex;*/
  final GameInformation info;
 // GamePage(this.size, this.imgPath, this.level, this.problem_index,this.needindex);
  GamePage(this.info);
  @override
  State<StatefulWidget> createState() {
    return GamePageState(info);
  }
}

enum Direction { none, left, right, top, bottom }
enum GameState { loading, play, complete }

class GamePageState extends State<GamePage> with TickerProviderStateMixin {
  //var image;
  PuzzleMagic puzzleMagic;
  List<ImageNode> nodes;
  ImageNode lastnode;
  Animation<int> alpha;
  AnimationController controller;
  Map<int, ImageNode> nodeMap = Map();

  int level;
  String path;
  int problem_index;
  ImageNode hitNode;
  bool needindex;

  double downX, downY, newX, newY;
  int emptyIndex;
  Direction direction;
  bool needdraw = true;
  List<ImageNode> hitNodeList = [];
  final GameInformation info;
  GameState gameState = GameState.loading;
  ImageNode backnode;
  GamePageState(this.info) {
    path=info.data.picPath;
    level=info.level;
    needindex=info.needindex;
    problem_index=info.problem_index;
    String background=info.backpath;
    puzzleMagic = PuzzleMagic();
    emptyIndex = level * level - 1;
   // var background=store.getCharaBackground_PathList().first;
    puzzleMagic.init(path, level,background).then((val) {
      setState(() {
        nodes = puzzleMagic.doTask();
        lastnode=puzzleMagic.getLastPiece();
        GameEngine.makeRandom(nodes);
        setState(() {
          gameState = GameState.play;
        });
        showStartAnimation();
      });
    });
   /* BackgroundMagic background=BackgroundMagic();
    background.init(ImagePathStore.background_image_path,size).then((val){
      setState(()  {
        backnode = background
            .doTask().first;
      });
    });*/
  }
  int gamescore=0;
  void GameCompleted()async{
    final db=DBProvider(DBName.state);

    await db.update(info.data.stageState.copy(clear: 1));
    final db2=DBProvider(DBName.clear_levels);
    await db2.insert_update(
      ClearedLevel(level: level, pictureName: info.data.stageState.pictureName, score: gamescore)
    );
  }
  @override
  Widget build(BuildContext context) {
    if (gameState == GameState.loading) {
      return Center(
        child: Text('Loading'),
      );
    } /*else if (gameState == GameState.complete) {
      return Center(
          child: RaisedButton(
        child: Text('Restart'),
        onPressed: () {
          GameEngine.makeRandom(nodes);
          setState(() {
            gameState = GameState.play;
          });
          showStartAnimation();
        },
      ));
    }*/ else {
      return new Scaffold(
          body:
              InterfaceWidget.Background(
            child:Stack(
            children: <Widget>[
              InterfaceWidget.CompletedPicture( ImagePathStore.background_image_path),

             /* Positioned(
                top: 100,
                left: 25,

                child:Image.asset(
                  'images/frame.jpg',
                  height: 300,
                  width: 300,
                  fit: BoxFit.fill,
                ),
              ),*/
              gameBoard(),
             Positioned(
                top: 50,

              child:gameInterface(gameState)
             ),

            /*Align(
              alignment: Alignment.topCenter,
                      child: gameInterface(gameState),
            ),*/







          ]
        ))
      );
     /*Stack(
                    children: [
                    GestureDetector(
                      child: CustomPaint(
                        painter: GamePainter(nodes, level, hitNode, hitNodeList,
                            direction, downX, downY, newX, newY, needdraw),
                        size: MediaQuery.of(context).size),//Size.infinite),
                    onPanDown: onPanDown,
                    onPanUpdate: onPanUpdate,
                    onPanEnd: onPanUp,
                  ),

                ],
              );*/
            // gameInterface(gameState),
    }
  }
  Widget gameBoard(){
        //Image.asset('images/frame.jpg'),
      if(gameState!=GameState.complete) {
        return
          GestureDetector(

            child: CustomPaint(
                painter: GamePainter(
                    nodes,
                    level,
                    hitNode,
                    hitNodeList,
                    direction,
                    downX,
                    downY,
                    newX,
                    newY,
                    needdraw,
                    needindex

                ),
                size: Size.infinite), //Size.infinite),
            onPanDown: onPanDown,
            onPanUpdate: onPanUpdate,
            onPanEnd: onPanUp,
          );
      }
      else{
        return
          Stack(children:[
              InterfaceWidget.CompletedPicture(info.backpath),
            InterfaceWidget.CompletedPicture(path,true),
          ]
          );
         /*Positioned(
          top: ImagePathStore.baseY,
          left: ImagePathStore.baseX,
          child: Image.asset(
            path,
            width: screenSize.width,
            height: screenSize.width,
            alignment: FractionalOffset.topCenter,
            fit: BoxFit.fitWidth,));*/
      }
  }
  Widget checkedwidget(Widget widget,bool check){
    if(check){
      return widget;
    }
    else{
      return Center();
    }
  }
  ImagePathStore store=ImagePathStore();
  Widget gameInterface(GameState state,){
      return
          Container(

            color: Color.fromARGB(255, 244, 244, 220),
             // width: double.maxFinite,
              alignment: Alignment(0.0, 0.0),
          // padding:,
            child:IntrinsicHeight(
    child:InterfaceWidget.InterfaceRow(expanded: false,
            //mainAxisSize: MainAxisSize.Center,
            children:[
              //if(problem_index>1)
             IconButton(
                icon:Icon(Icons.arrow_back),
                //color: Colors.white,
                onPressed: (){

                    //  Navigator.of(context).pop(false);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>GameSettingPage( info.data, level, problem_index)),
                  );
                },
              ),//),problem_index>=1),
             IconButton(
               icon:Icon(Icons.replay),
                   onPressed: () {
                     GameEngine.makeRandom(nodes);
                     setState(() {
                       gamescore=0;
                       gameState = GameState.play;
                     });
                     showStartAnimation();
                   }
               ),
               IconButton(
                 icon:Icon(Icons.home),
                   onPressed: () {
                     Navigator.push(
                       context,
                       MaterialPageRoute(builder: (context) =>CategorySelectPage()),
                     );
                   }
               ),
               SizedBox(
               height: double.infinity,
                  //color: Colors.black,
                  child: FittedBox(
                  fit: BoxFit.fitHeight,
                    child:Text("Score $gamescore")

                  )
               )
              /* checkedwidget(InterfaceButton(IconButton(
               icon:Icon(Icons.arrow_forward),
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>GamePage(size, store.getPath_List()[problem_index+1], level,problem_index+1,needindex)),
                  );
                },
              ),true),problem_index+1<store.getPath_List().length),*/
        ]
     )));
  }
  Widget InterfaceButton(IconButton button,[bool rightedge=false]){
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
    if(rightedge){
      return Container(
        child:button,
        decoration: BoxDecoration(
            border: border_edge ,

          // borderRadius: BorderRadius.circular(12),
        ),
      );
    }
    else{
      return Container(
        child: button,
        decoration: BoxDecoration(
            border: border_center ,

          // borderRadius: BorderRadius.circular(12),
        ),
      );
    }

  }
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void showStartAnimation() {
    needdraw = true;
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    alpha = IntTween(begin: 0, end: 100).animate(controller);
    nodes.forEach((node) {
      nodeMap[node.curIndex] = node;

      Rect rect = node.rect;
      Rect dstRect = puzzleMagic.getOkRectF(
          node.curIndex % level, (node.curIndex / level).floor());

      final double deltX = dstRect.left - rect.left;
      final double deltY = dstRect.top - rect.top;

      final double oldX = rect.left;
      final double oldY = rect.top;

      alpha.addListener(() {
        double oldNewX2 = alpha.value * deltX / 100;
        double oldNewY2 = alpha.value * deltY / 100;
        setState(() {
          node.rect = Rect.fromLTWH(
              oldX + oldNewX2, oldY + oldNewY2, rect.width, rect.height);
        });
      });
    });
    alpha.addStatusListener((AnimationStatus val) {
      if (val == AnimationStatus.completed) {
        needdraw = false;
      }
    });
    controller.forward();
  }

  void onPanDown(DragDownDetails details) {
    if (controller != null && controller.isAnimating) {
      return;
    }
    gamescore++;
    needdraw = true;
    RenderBox referenceBox = context.findRenderObject();
    Offset localPosition = referenceBox.globalToLocal(details.globalPosition);
    for (int i = 0; i < nodes.length; i++) {
      ImageNode node = nodes[i];
      if (node.rect.contains(localPosition)) {
        hitNode = node;
        direction = isBetween(hitNode, emptyIndex);
        if (direction != Direction.none) {
          newX = downX = localPosition.dx;
          newY = downY = localPosition.dy;

          nodes.remove(hitNode);
          nodes.add(hitNode);
        }
        setState(() {});
        break;
      }
    }
  }

  void onPanUpdate(DragUpdateDetails details) {
    if (hitNode == null) {
      return;
    }
    RenderBox referenceBox = context.findRenderObject();
    Offset localPosition = referenceBox.globalToLocal(details.globalPosition);
    newX = localPosition.dx;
    newY = localPosition.dy;
    if (direction == Direction.top) {
      newY = min(downY, max(newY, downY - hitNode.rect.width));
    } else if (direction == Direction.bottom) {
      newY = max(downY, min(newY, downY + hitNode.rect.width));
    } else if (direction == Direction.left) {
      newX = min(downX, max(newX, downX - hitNode.rect.width));
    } else if (direction == Direction.right) {
      newX = max(downX, min(newX, downX + hitNode.rect.width));
    }

    setState(() {});
  }

  void onPanUp(DragEndDetails details) {
    if (hitNode == null) {
      return;
    }
    needdraw = false;
    if (direction == Direction.top) {
      if (-(newY - downY) > hitNode.rect.width / 2) {
        swapEmpty();
      }
    } else if (direction == Direction.bottom) {
      if (newY - downY > hitNode.rect.width / 2) {
        swapEmpty();
      }
    } else if (direction == Direction.left) {
      if (-(newX - downX) > hitNode.rect.width / 2) {
        swapEmpty();
      }
    } else if (direction == Direction.right) {
      if (newX - downX > hitNode.rect.width / 2) {
        swapEmpty();
      }
    }

    hitNodeList.clear();
    hitNode = null;

    var isComplete = true;
    nodes.forEach((node) {
      if (node.curIndex != node.index) {
        isComplete = false;
      }
    });
    if (isComplete) {
      gameState = GameState.complete;
     GameCompleted();
    }

    setState(() {});
  }

  Direction isBetween(ImageNode node, int emptyIndex) {
    int x = emptyIndex % level;
    int y = (emptyIndex / level).floor();

    int x2 = node.curIndex % level;
    int y2 = (node.curIndex / level).floor();

    if (x == x2) {
      if (y2 < y) {
        for (int index = y2; index < y; ++index) {
          hitNodeList.add(nodeMap[index * level + x]);
        }
        return Direction.bottom;
      } else if (y2 > y) {
        for (int index = y2; index > y; --index) {
          hitNodeList.add(nodeMap[index * level + x]);
        }
        return Direction.top;
      }
    }
    if (y == y2) {
      if (x2 < x) {
        for (int index = x2; index < x; ++index) {
          hitNodeList.add(nodeMap[y * level + index]);
        }
        return Direction.right;
      } else if (x2 > x) {
        for (int index = x2; index > x; --index) {
          hitNodeList.add(nodeMap[y * level + index]);
        }
        return Direction.left;
      }
    }
    return Direction.none;
  }

  void swapEmpty() {
    int v = -level;
    if (direction == Direction.right) {
      v = 1;
    } else if (direction == Direction.left) {
      v = -1;
    } else if (direction == Direction.bottom) {
      v = level;
    }
    hitNodeList.forEach((node) {
      node.curIndex += v;
      nodeMap[node.curIndex] = node;
      node.rect = puzzleMagic.getOkRectF(
          node.curIndex % level, (node.curIndex / level).floor());
    });
    emptyIndex -= v * hitNodeList.length;
  }
}
