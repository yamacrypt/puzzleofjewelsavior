import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_puzzle/DataBase.dart';
import 'package:flutter_puzzle/DataModel/ListeData.dart';
import 'package:flutter_puzzle/InterfaceWidget.dart';
import 'package:flutter_puzzle/imagestore.dart';
import 'package:flutter_puzzle/page/GameSettingPage.dart';
import 'package:flutter_puzzle/page/SelectPage.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:quiver/iterables.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'dart:io' as io;
import '../FileUtils.dart';
import '../ImagePosInformation.dart';
import '../gallery_bloc.dart';

class CategorySelectPage extends StatelessWidget {

/*
 Future<List<Widget>> _getitemlist(BuildContext context)async{
   List<Widget> wg_list=[];

   // ls.forEach((element) {wg_list.add(ListItem(element));});
   final db=DBProvider(DBName.state);
   var ls=["女キャラ","男キャラ","その他"];
   var ls2=[ImageCategory.girl,ImageCategory.boy,ImageCategory.monster];
   for (var item in zip([ls, ls2])) {
     wg_list.add(
         Expanded(
           child: ListItem(item[0], item[1], context),
           flex: 1,
         )
     );
     String root = await getFilePath();
     var headers = await db.get_headers(item[1]);
     wg_list.add(
       Expanded(
           child: Row(
               children: headers.map((e) =>
                   Expanded(
                       child: ItemCard(
                           GalleryListData.from(e, root), context,
                           item[1])),
               ).toList()
           ),
           flex: 3
       ),
     );
   }
  return wg_list;
 }*/
 BuildContext context;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    this.context=context;
    ImgPosInfo.ScreenSize=(MediaQuery.of(context).size);
    var store=ImagePathStore();
    //var wg_list=_getitemlist(context);
    final db=DBProvider(DBName.state);
    var ls=["女キャラ","男キャラ","その他"];
    var ls2=[ImageCategory.girl,ImageCategory.boy,ImageCategory.monster];
   /* IterableZip([ls, ls2]).map((item) =>() async{
      wg_list.add(
         Expanded(
          child:ListItem(item[0], item[1], context),
          flex: 1,
         )
      );
      String root=await getFilePath();
      var headers=await db.get_headers(item[1]);
      wg_list.add(
          Expanded(
              child:Row(
            children: headers.map((e) =>
                Expanded(
                    child:ItemCard(GalleryListData.from(e,root), context, item[1])),
                ).toList()
              ),
                flex: 3
          ),
          );
    });*/

    List<Widget> wls=[];
    wls.add(Expanded(flex: 1,child:Container(
        alignment: Alignment.topRight,
        child: RawMaterialButton(
          onPressed: () {

            ExitPopup(context);
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
    )));
    for(var item in zip([ls,ls2])){
      wls.add( Expanded(
        flex: 4,
          child:Column(
              children:[
                Expanded(
                  child:ListItem(item[0], item[1], context),
                  flex: 1,
                ),
                Expanded(
                  child:FutureBuilder<Widget>(
                      future: category_row(item[1],context),

                      builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
                        if(!snapshot.hasData)
                          return Container();
                        else
                          return snapshot.data;
                      }

                  ),
                  flex: 3,
                )

              ]
          ) )
      );
    }

          return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
            body: //Expanded(
              InterfaceWidget.Background(child:Column(
              children: wls,
               )
            )//),
          )
          );

  }
 void ExitPopup(BuildContext context){
   Alert(
     context: context,
     //onWillPopActive: true,
     // type: AlertType.warning,
     title: "ゲームを終了しますか？",
     //desc: "Flutter is more awesome with RFlutter Alert.",
     content:Column( children:[
       DialogButton(
         child: Text(
           "Exit",
           style: TextStyle(color: Colors.white, fontSize: 20),
         ),
         onPressed: () {
           //exit(0);
          if(io.Platform.isAndroid){
            SystemNavigator.pop();
          }
          else {
           io.exit(0);
          }
          // Navigator.of(context).pop(true);
         },
         color: Color.fromRGBO(0, 179, 134, 1.0),
       ),
       DialogButton(
         child: Text(
           "Rate App",
           style: TextStyle(color: Colors.white, fontSize: 20),
         ),
         onPressed: () => Navigator.pop(context),
         color:Color.fromRGBO(116, 116, 191, 1.0),
       ),
       DialogButton(
         child: Text(
           "Other Apps",
           style: TextStyle(color: Colors.white, fontSize: 20),
         ),
         onPressed: () => Navigator.pop(context),
         color:  Color.fromRGBO(52, 138, 199, 1.0),
       )
     ]),
   ).show();
 }
 Future<bool> _onWillPop() async{
   ExitPopup(context);
   return true;
 }
    Future<Widget> category_row(ImageCategory category,context) async
    {
    var root=await  getFilePath();
    final db=DBProvider(DBName.state);
    var headers=await db.get_headers(category);
      return Row(
            children:(headers.map((e) =>
          Expanded(
          child: ItemCard(
          GalleryListData.from(e, root), context,
           category),flex: 1,),
          ).toList())
          ,
      );
    }
  Widget ListItem(String titlename,ImageCategory category,context){
    return ListTile(
      //leading: Icon(Icons.people),
      title: Text(titlename,style:TextStyle(color: Colors.white)) ,
      trailing: InkWell(
        child: Text("もっと見る",style:TextStyle(color: Colors.white),),
       onTap: (){
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>
                  Provider<GalleryBloc>(
                    create: (context) => GalleryBloc(),
                    dispose: (context, bloc) => bloc.dispose(),
                    child:ImageSelectPage(category: category),
                  )
              ));
        },
      ),
    );
  }
  Widget ItemCard(GalleryListData demoData,BuildContext context,ImageCategory category){
    return Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        elevation: 1,
        //color: Colors.white,
        child: InkWell(
            onTap: () {
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>
              Provider<GalleryBloc>(
                create: (context) => GalleryBloc(),
                dispose: (context, bloc) => bloc.dispose(),
                child:GameSettingPage(demoData, 3, 0)//ImageSelectPage(category: category),
              )
          ));
          },
            /*splashColor:
            Theme
                .of(context)
                .colorScheme
                .onSurface
                .withOpacity(0.12),*/
            // Generally, material cards do not have a highlight overlay.
            highlightColor: Colors.transparent,
            child:
            Image.file(
              io.File(demoData.picPath),
              width:  demoData.imgWidth,
              height: demoData.imgHeight,
            )
        )
    );
  }
}
