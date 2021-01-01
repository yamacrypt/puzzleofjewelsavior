import 'dart:io';

import 'package:path_provider/path_provider.dart';

String _root;
Future<String> getFilePath([String filename=""])  async{
      if(_root==null) {
        Directory appDocumentsDirectory = await getApplicationDocumentsDirectory(); // 1
        _root = appDocumentsDirectory.path; // 2
      }
    String filePath = '$_root/$filename'; // 3

    return filePath;
}