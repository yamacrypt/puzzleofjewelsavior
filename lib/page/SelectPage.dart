import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_puzzle/DataBase.dart';
import 'package:flutter_puzzle/DataModel/ListeData.dart';
import 'package:flutter_puzzle/ImagePosInformation.dart';
import 'package:flutter_puzzle/InterfaceWidget.dart';
import 'package:flutter_puzzle/downloader.dart';
import 'package:flutter_puzzle/gallery_bloc.dart';
import 'package:flutter_puzzle/page/CatergorySelectPage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quiver/iterables.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'dart:async';
import '../DataModel/DataBaseModel.dart';
import '../filepathController.dart';
import '../imagestore.dart';
import 'dart:io' as io;
import 'GamePage.dart';
import 'GameSettingPage.dart';
import 'package:provider/provider.dart';

class ImageSelectPage extends StatefulWidget {
  final ImageCategory category;

  const ImageSelectPage({Key key, this.category}) : super(key: key);
  @override
  State<ImageSelectPage> createState() => ImageSelectPageState(category);
}

class ImageSelectPageState extends State<ImageSelectPage> {
  final ImageCategory category;
  ImageSelectPageState(this.category);
  Future<String> getFilePath([String filename=""]) async {
    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory(); // 1
    String appDocumentsPath = appDocumentsDirectory.path; // 2
    String filePath = '$appDocumentsPath/$filename'; // 3

    return filePath;
  }
  Future<List<GalleryListData>> get _demoList  async{
   /* var store=ImagePathStore();
   var assetlist=await store.getPath_List(category);
   var categoryfolder=await getFilePath(category.toString().split('.').last);
    /*if(Directory(categoryfolder ).existsSync()==false) {
      new Directory(categoryfolder).create(recursive: true);
    }*/
    var statedb= DBProvider(DBName.state);
   await assetlist.forEach((element) async {
     var path= categoryfolder+"/"+element.path.split("/").last;
     if(File(path).existsSync()==false){
       File(path).create(recursive: true);
       ByteData data=await rootBundle.load(element.path);
       File(path).writeAsBytesSync(data.buffer?.asUint8List());
       var state=StageState(pictureName:path,clear: 0,unlock: 1);
       statedb.insert(state);
     }
   });
    store=ImagePathStore(true);
   List<CharacterImageData> ls=await  store.getPath_List(category);*/
   var root=await getFilePath();
    var statedb= DBProvider(DBName.state);
    //await statedb.update_unlock("f083");
   // var a=await statedb.searchBypath("f083");
   List<StageState> statels=await statedb.sortedAll(CategorytoString(category));

    List<GalleryListData> list=[];
    statels.forEach((ele) {
      list.add(GalleryListData.from(ele, root));
    });
    return list;
  }
  int maxdownload=5;
  ImagePathStore store=ImagePathStore();
   getCardsStream(GalleryBloc bloc) async {
     //await Future.delayed(Duration(seconds: 1));
    bool isDarkMode = Theme
        .of(context)
        .brightness == Brightness.dark;
    var list=await _demoList;
    List<Widget> Cards=[];
    cache=new List(list.length);
    for(int index=0;index<list.length;index++) {
     GalleryListData demoData = list[index];
          bool playable=io.File(demoData.picPath).existsSync();
          Widget card = Card(
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          elevation: 1,
          child: InkWell(
              onTap: () {
                playable?
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>
                        GameSettingPage( demoData, 3, index)
                    )
                )
                    :
                    Alert(
                        context: context,
                      //  onWillPopActive: true,
                        title: "広告を見て新しい$maxdownload個の画像を獲得する",
                        content: Column( children:[
                          DialogButton(
                                  child: Text(
                                  "Get",
                                    style: TextStyle(color: Colors.white, fontSize: 20),
                                  ),
                              onPressed: () async{
                                    Navigator.pop(context);
                                    var db=DBProvider(DBName.state);

                                    var downloader=Downloader();
                                 List<String> ls=await db.get_lockedpaths(category);
                                  //List<String> ls=value;
                                  int max=maxdownload;
                                  max=max>ls.length ? ls.length:max;

                                 for(final i in range(0,max)) {
                                    await downloader.download(category, ls[i]);
                                  }

                                 await Future.delayed(Duration(seconds: 1));
                                 setState(() {

                                 });

                               //  );

                                   /* var statedb = DBProvider(DBName.state);
                                    statedb.search("unlock", "0").then((value) => () async {
                                      int count=5;
                                      for(StageState ele in value){
                                        downloader.download(category, ele.pictureName);
                                        count--;
                                        if(count<0)
                                          break;
                                      }*/

                                    //});
                              //exit(0);
                              //Navigator.pop(context);
                              },
                              color: Color.fromRGBO(0, 179, 134, 1.0),
                              )])
                    ).show();
              },
              splashColor:
              Theme
                  .of(context)
                  .colorScheme
                  .onSurface
                  .withOpacity(0.12),
              // Generally, material cards do not have a highlight overlay.
              highlightColor: Colors.transparent,
              child: Stack(children:[   playable?
             Image.file(
                 io.File(demoData.picPath),
               //width:  demoData.imgWidth,
              // height: demoData.imgHeight,
             ):
              Image.asset(
                  ImagePathStore.unknownImagepath,
                  //width:  demoData.imgWidth,
                  //height: demoData.imgWidth,
                  //alignment: FractionalOffset.topCenter,
                  fit: BoxFit.fill
              ),
              demoData.cleared? Container(alignment: Alignment.bottomRight,
              child:Text(
                  "Cleared",
                style: TextStyle(color: Colors.redAccent,fontSize: 30),
              )):Container()])
          )
      );
     // Cards.add(card);
     cache[index]=card;
      if(index%5==0)
        bloc.draw.add(cache.first);
      //.add(card);
     // yield card;
    }
    bloc.draw.add(cache.first);
    //  list.add(card);
  }

  List<Widget> get _puzzleCards {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    List<Widget> list = [];
    /*_demoList.asMap().forEach((index, value) {
      _FLDemoListData demoData=value;
      Widget card = Card(
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          elevation: 1,
          child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GameSetting(MediaQuery.of(context).size,store.getPath_List()[index],3,index)
                    )
                );
              },
              splashColor:
              Theme.of(context).colorScheme.onSurface.withOpacity(0.12),
              // Generally, material cards do not have a highlight overlay.
              highlightColor: Colors.transparent,
              child: Image.asset(
                  isDarkMode
                      ? (demoData.darkPicPath ?? demoData.picPath)
                      : demoData.picPath,
                  //width:  demoData.imgWidth,
                  //height: demoData.imgWidth,
                  alignment: FractionalOffset.topCenter,
                  fit:  BoxFit.fitWidth
              )
          )

      );
      list.add(card);
    });*/
   /* for(int index=0;index<_demoList.length;index++) {
      _FLDemoListData demoData=_demoList[index];
      Widget card = Card(
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          elevation: 1,
          child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GameSetting(MediaQuery.of(context).size,store.getPath_List()[index],3,index)
                    )
                );
              },
              splashColor:
              Theme.of(context).colorScheme.onSurface.withOpacity(0.12),
              // Generally, material cards do not have a highlight overlay.
              highlightColor: Colors.transparent,
              child: Image.asset(
                  isDarkMode
                      ? (demoData.darkPicPath ?? demoData.picPath)
                      : demoData.picPath,
                      //width:  demoData.imgWidth,
                      //height: demoData.imgWidth,
                      alignment: FractionalOffset.topCenter,
                      fit:  BoxFit.fitWidth
                )
              )

      );
      list.add(card);
    }*/
    return list;
  }
  final int MaxLoaded=30;//=new List(MaxLoaded);
  //GalleryBloc galleryBloc;
  @override
  Widget build(BuildContext context) {
    //Cards=new List();
    //BlocList.add(Provider.of<GalleryBloc>(context));
    final galleyBloc = Provider.of<GalleryBloc>(context);
    ImagePathStore.ScreenSize=(MediaQuery.of(context).size);
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    Color bgColor = Theme.of(context).backgroundColor;
    //_puzzleCardsStream().then
    getCardsStream(galleyBloc);
    return Scaffold(
       /* appBar: AppBar(
          title: Text('FLUI', style: TextStyle(letterSpacing: 4)),
          centerTitle: true,
        ),*/
        body: Stack(
            children:[InterfaceWidget.Background(

        child:Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
           // color: isDarkMode ? bgColor : Color(0xFFFCFCFC),
            child:StreamBuilder(
                  initialData: Container(),
                  stream: galleyBloc.load,
                  builder: (context, snapshot) {
                    //cache.add(snapshot.data);
                    return GridView(
                        padding: EdgeInsets.symmetric(vertical: 20),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3/4,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20),
                    children:cache==null?[]:cache
        );}
    ),)
    ),
              Container(
                  alignment: Alignment.topRight,
                  child: RawMaterialButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>CategorySelectPage()),
                      );
                     //Navigator.pop(context);
                    },
                    elevation: 2.0,
                    fillColor: Colors.red,
                    child:  Icon(
                      Icons.clear,
                      color: Colors.white,
                    ),
                    //padding: EdgeInsets.all(15.0),
                    shape: CircleBorder(),
                  )
              )])
    );
  }
}
List<Widget> cache;
