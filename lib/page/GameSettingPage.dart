

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_puzzle/DataBase.dart';
import 'package:flutter_puzzle/DataModel/DataBaseModel.dart';
import 'package:flutter_puzzle/DataModel/ListeData.dart';
import 'package:flutter_puzzle/ImagePosInformation.dart';
import 'package:flutter_puzzle/imagestore.dart';
import 'package:flutter_puzzle/magic/GamePainter.dart';
import 'package:flutter_puzzle/magic/ImageNode.dart';
import 'package:flutter_puzzle/magic/PuzzleMagic.dart';
import 'package:flutter_puzzle/page/CatergorySelectPage.dart';
import 'package:provider/provider.dart';

import '../BackgroundMagic.dart';
import '../InterfaceWidget.dart';
import '../gallery_bloc.dart';
import 'GamePage.dart';
import 'SelectPage.dart';

class GameSettingPage extends StatefulWidget{

 // final Size size;
 // final String imgPath;
  final GalleryListData data;
  final int level;
  final int problem_index;
  GameSettingPage( this.data, this.level, this.problem_index);

  @override
  State<StatefulWidget> createState() {
    return GameSettingPageState( data, level,problem_index);
  }

}
class GameInformation{
  //String path;
  final GalleryListData data;
  String backpath;
  int problem_index;
  int level;
  bool needindex;
  GameInformation(this.data,this.level,this.problem_index,this.needindex,[this.backpath]);
}
class GameSettingPageState extends State<GameSettingPage>{
  Size size;

  var problem_index;

  var level;
  int maxlevel=9;
  int minlevel=3;
  bool needindex=true;
  double downX, downY, newX, newY;
  int emptyIndex;
  Direction direction;
  bool needdraw = true;
  List<ImageNode> hitNodeList = [];
  BackgroundMagic puzzleMagic;
  List<ImageNode> nodes;
  ImageNode hitNode;
  int drawflag=1;
 // var path;
  GameState gameState = GameState.loading;
  final GalleryListData data;

  get _gamescores async{
    List<String>  gamescores=List.filled(maxlevel+1, "-");
    final db=DBProvider(DBName.clear_levels);

    List<ClearedLevel> levels=await db.getAllByKey(data.stageState.pictureName);
    if(levels!=null) {
      await Future.forEach(levels,(element) {
        gamescores[element.level] = element.score.toString();
      });
    }
    return gamescores;
  }
  GameSettingPageState(this.data, this.level,this.problem_index){
    size=ImgPosInfo.screenSize;
    this.level=level;
    store=ImagePathStore();
    backpathlist=ImagePathStore.getcharabackpath();
    puzzleMagic = BackgroundMagic();


    Redraw();
  }
  ImagePathStore store;
  int backpath_index=0;
  String back_path;
  List<String> backpathlist;//=store.getCharaBackground_PathList();
  @override
  Widget build(BuildContext context) {
    emptyIndex = level * level - 1;
    // backpathlist.add(null);
    // TODO: implement build
    return Scaffold(body:InterfaceWidget.Background(  child: Stack(
      fit: StackFit.expand,
      children: [

        CustomPaint(
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
          // child: Container(),
        ),
        /* Positioned(
      top:ImagePathStore.baseY,
      left: ImagePathStore.baseX,
      child: Image.asset(
        path,
        width: size.width,
        height: size.width,
        alignment: FractionalOffset.topCenter,
        fit: BoxFit.fitWidth,
      ),
      ),*/
        Positioned(
            top: ImgPosInfo.baseY*1/8,
            left: 0,right: 0,
            child:
            SizedBox(
              height: ImgPosInfo.baseY*3/4,
                child:Column(
                  children: [

                    Expanded(
                        child:Text(data.title,style: TextStyle(color: Colors.white,fontSize:ImgPosInfo.baseY*1/4 ))
                    ),
                    gameInterface(),
                  ],
                )
            )

        ),
        //  left: size.width/2,
        Positioned(
          bottom: 10,
          left: size.width/4,
          right: size.width/4,
          child:RaisedButton(
            color: background,
            child:Text(
              "ニューゲーム",
              textAlign: TextAlign.center,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>GamePage(GameInformation(data, level,problem_index,needindex,back_path))),
              );
            },
          ),
        ),

      ],

    ))
    );

  }
  Redraw(){
    back_path=backpathlist[backpath_index];
    puzzleMagic.init(data.picPath,back_path, level).then((val) async{
      nodes =await puzzleMagic.doTask();
      setState(() {
        gameState = GameState.play;
        // drawflag=0;
      });

    }
    );
  }
  Color background=Color.fromARGB(255, 244, 244, 220);
  Widget gameInterface(){
    // double height=24.0;
    BoxFit fit=BoxFit.fitWidth;

    return
      Container(
        // height: height,
          color: background,
          // width: double.maxFinite,
          alignment: Alignment(0.0, 0.0),
          //child:Expanded(
          child:IntrinsicHeight(
                  child:InterfaceWidget.InterfaceRow(
                  children:[
                    //if(problem_index>1)
                    IconButton(
                      // iconSize : 24.0,
                      icon:Icon(Icons.arrow_back),
                      //color: Colors.w
                      // e,
                      onPressed: (){

                        // Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>
                              Provider<GalleryBloc>(
                                create: (context) => GalleryBloc(),
                                dispose: (context, bloc) => bloc.dispose(),
                                child:ImageSelectPage(category: data.stageState.category),
                              )
                          ),
                        );
                      },
                    ),
                    SizedBox(
                        height: double.infinity,
                        child: RaisedButton(

                          child:Text("番号"),
                          color: background,
                          onPressed: (){

                            if(needindex){
                              needindex=false;
                            }
                            else{
                              needindex=true;
                            }
                            Redraw();

                          },
                        )
                    ),
                    SizedBox(
                        height: double.infinity,
                        child: RaisedButton(

                          child:Text("背景$backpath_index"),
                          color: background,
                          onPressed: (){

                            if(backpath_index<backpathlist.length-1){
                              backpath_index++;
                            }
                            else{
                              backpath_index=0;
                            }
                            Redraw();

                          },
                        )
                    ),
                   Row(children: [
                     Expanded(flex :3, child:
                   Column(children: [
                        Expanded(child:
                        SizedBox(height :0,
                            child:  FittedBox(
                        child:Text("$level×$level")
                        ,fit: BoxFit.fitHeight,))
                            ,flex: 2,
                        ),
                          Expanded(
                            child:SizedBox(child:FittedBox(
                              child:FutureBuilder(
                                future: _gamescores,
                                builder: (BuildContext context,AsyncSnapshot<dynamic> snapdata){
                                  if(snapdata.data==null)
                                    return Text("score -");
                                  return Text("score "+snapdata?.data[level]);
                                },
                              )
                                ,fit: BoxFit.fitHeight),
                            height: 0,



                            ),
                            flex: 1,
                          )
                        ],)),
                          //  style: TextStyle(fontSize: 40),

                    //    fit: BoxFit.fitHeight,
                     // ),
                    Expanded(
                      flex: 2,
                    child:Container(
                        decoration: BoxDecoration(
                            border: Border(left: BorderSide(width: 1.0, color:Color.fromARGB(255, 85, 61, 41))),
                        ),
                    child:Column(
                        children:[
                          Expanded(
                            flex: 1,
                            child:  SizedBox(
                                height: 0,
                                child:
                                FittedBox(
                                    fit: fit,
                                    child:InterfaceWidget.Decoration(
                                        bottom: true,child:IconButton(

                                      // alignment: Alignment.topCenter,
                                      // iconSize : 12.0,
                                      icon:Icon(Icons.keyboard_arrow_up),
                                      //color: Colors.w
                                      // e
                                      onPressed: (){

                                        if(level<maxlevel)
                                          level++;
                                        Redraw();
                                      },
                                    )
                                    )
                                )
                            ),
                          ),
                          Expanded(
                              flex: 1,
                              child:  SizedBox(
                                  height: 0,
                                  child: FittedBox(
                                    fit: fit,
                                    child: IconButton(
                                      //alignment:  Alignment.bottomCenter,
                                      //  iconSize : .0,
                                      icon:Icon(Icons.keyboard_arrow_down),
                                      //color: Colors.w
                                      // e,
                                      onPressed: (){

                                        if(level>minlevel)
                                          level--;
                                        Redraw();
                                      },
                                    ),
                                  )))]
                    )))],)


                    /* IconButton(
                      icon:Icon(Icons.arrow_back),
                      //color: Colors.white,
                      onPressed: (){

                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>GamePage(size,store.getPath_List()[problem_index-1], level,problem_index-1)),
                        );
                      },
                    )*/
                  ]
              ))

      );
  }

}
