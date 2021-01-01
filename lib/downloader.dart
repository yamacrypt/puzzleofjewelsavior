

import 'dart:io' as io;

import 'package:flutter/cupertino.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_puzzle/DataBase.dart';
import 'package:flutter_puzzle/imagestore.dart';
import 'package:flutter_puzzle/main.dart';

import 'FileUtils.dart';

class Downloader{

  Future<void> init() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(
  debug: true // optional: set false to disable printing logs to console
  );
  }
  download(ImageCategory cg,String name) async{
    String urlprefix="https://storage.googleapis.com/characterimages/all/character";
    String link=urlprefix+"/"+name+".png";
    String savedDir=await getFilePath(CategorytoString(cg));
    if(io.Directory(savedDir).existsSync()==false)
      await io.Directory(savedDir).create(recursive: true);
   // io.File file = await ;
    final taskId = await FlutterDownloader.enqueue(
      url:link,
      savedDir:savedDir,
      showNotification: true, // show download progress in status bar (for Android)
      openFileFromNotification: false, // click on notification to open downloaded file (for Android)
    );
    var statedb=DBProvider(DBName.state);
   await  statedb.update_unlock(name);
  }
}