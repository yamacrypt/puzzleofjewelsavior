import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../imagestore.dart';

class CharacterImageData{
  String path;
  //bool cleared;
  String characterName;
  CharacterImageData(this.path,this.characterName);
}
class ClearedLevel  extends DBModel{
  String pictureName;
  int level;
  int score;
  ClearedLevel({@required this.level,@required this.pictureName,@required this.score});
  factory  ClearedLevel.fromMap(Map<String, dynamic> json) =>  ClearedLevel(
      pictureName: json["path"],
      level:json["level"],
      score:json["score"]
  );
  Map<String, dynamic> toMap() => {
    "path": pictureName,
    "level":level,
    "score":score
  };



  @override
   getKeyList() {
    // TODO: implement getKeyMap
    return ["path",pictureName];
  }
}
class StageState extends DBModel{
  @override
  getKeyList() {
    // TODO: implement getKeyMap
    return ["path",pictureName];
  }
  String getpath(String rootpath){
    var categoryfolder=rootpath+CategorytoString(category);
    return categoryfolder+"/"+pictureName+".png";
  }
  String pictureName;
  String characterName;
  //int level;
  ImageCategory category;
  // 1=true 0=false;
  int clear;
  int unlock;
  StageState({@required this.pictureName,@required this.clear,@required this.unlock,@required this.category,@required this.characterName});
  factory StageState.fromMap(Map<String, dynamic> json) => StageState(
      pictureName: json["path"],
      clear: json["clear"],
      unlock: json["unlock"],
      category: StringtoCategory(json["category"]),
    characterName: json["characterName"]
  );

  Map<String, dynamic> toMap() => {
    "path": pictureName,
    "clear":clear,
    "unlock":unlock,
    "category":CategorytoString(category),
    "characterName":characterName
  };
  copy({pictureName,clear,unlock, category,characterName}){
    return StageState(
      pictureName: pictureName==null?this.pictureName:pictureName,
      clear: clear==null?this.clear:clear,
      unlock: unlock==null?this.unlock:unlock,
      category: category==null?this.category:category,
      characterName: characterName==null?this.characterName:characterName
    );
  }
}
abstract class DBModel{
  List<String> getKeyList();
  Map<String, dynamic> toMap();
}