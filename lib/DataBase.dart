import 'package:flutter/cupertino.dart';
import 'package:flutter_puzzle/DataModel/DataBaseModel.dart';
import 'package:flutter_puzzle/imagestore.dart';
import 'package:flutter_puzzle/page/GamePage.dart';
import 'package:path/path.dart';
import 'dart:io' as io;
import 'package:sqflite/sqflite.dart';

enum DBName{
  state,clear_levels
}

class DBProvider  {
  String tableName;
  String _init_sql;
  static Database _database;
  DBProvider._(this.tableName,this._init_sql);
  //pathとはf000など
  static DBProvider _statedb=DBProvider._(
      "state",
      "CREATE TABLE IF NOT EXISTS state ("
          "path TEXT PRIMARY KEY,"
          "clear INTEGER,"
          "unlock INTEGER,"
          "category TEXT,"
          "characterName TEXT KEY"
          ")"
  ) ;
  static DBProvider _clearedleveldb=DBProvider._(
      "clearlevels",
      "CREATE TABLE IF NOT EXISTS clearlevels ("
          "path TEXT KEY,"
          "level INTEGER,"
          "score INTEGER"
          ")"
  ) ;
  factory DBProvider(DBName name ){
    switch(name){
      case DBName.state:return _statedb;
      case DBName.clear_levels:return _clearedleveldb;
      default:return _statedb;
    }
  }
  Future<Database> get database async {
    if (_database != null) {
      try {
        await _createTable(_database, 1);
      } catch (e, s) {
        print(s);
      }
      return _database;
    }
    // DBがなかったら作る
    _database = await initDB();
    return _database;
  }

  Future<void> _createTable(Database db, int version) async {
    return await db.execute(
        _init_sql
    );
  }
  reset()async{
    String path = join(await getDatabasesPath(), "stagesInfo.db");
    deleteDatabase(path);
  }
  Future<Database> initDB() async{

    // import 'package:path/path.dart'; が必要
    // なぜか サジェスチョンが出てこない
    String path = join(await getDatabasesPath(), "stagesInfo.db");
    return await openDatabase(path, version: 1, onCreate: _createTable);
  }
  insert(DBModel state)async{
    final db = await database;
   // var tes=state.toMap();
    var res = await db.insert(tableName, state.toMap());
    return res;
  }
  update(DBModel s)async{
    final db = await database;
    final keymap=s.getKeyList();
    final key0=keymap[0];
    final key1=keymap[1];
    int res=await db.update(tableName, s.toMap() ,where: " $key0 = '$key1'  ");
    return res;
  }
  //level
  insert_update(state)async{
    final db = await database;
    // var tes=state.toMap();
    var res = await db.insert(tableName, state.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,);
    conflictAlgorithm:
    /*if(res==1)
      return 1;
    res=await update(state);*/
    return res;
  }
  Future<List<StageState>>  getAll()async{
    final db = await database;
    List<Map> results = await db.query(tableName);
    List<StageState> ls=[];
    results.forEach((element) {
      ls.add(StageState.fromMap(element));
    });
    return ls;
  }
  Future<List<StageState>>  search(String key,String ke)async{
  final db = await database;
  List<Map> results = await db.rawQuery("SELECT * FROM $tableName WHERE $key = '$ke' ") ;
  List<StageState> ls=[];
  Future.forEach(results,(element) {
    ls.add(StageState.fromMap(element));
  });
  return ls;
  }

  update_unlock(String s)async{
    final db = await database;
    await db.rawQuery("UPDATE $tableName SET unlock = "+"'1'"+" WHERE path = '$s'");
   
  }
 Future<List<String>> get_lockedpaths(ImageCategory category)async{
    final db=await database;
    final cg=CategorytoString(category);//category.toString()
      List<Map> results  =await db.rawQuery("SELECT * FROM $tableName WHERE unlock='0' AND category = '$cg' ");
      List<String> ls=[];
      await Future.forEach(results, (element)  {
        ls.add(StageState.fromMap(element).pictureName);
      });
      return ls;
 }
  Future<List<StageState>> get_headers(ImageCategory category)async{
    int header_maxnum=3;
    final db=await database;
    final cg=CategorytoString(category);//category.toString()
    List<Map> results  =await db.rawQuery("SELECT * FROM $tableName WHERE unlock='1' AND category = '$cg' ORDER BY clear ASC  LIMIT $header_maxnum");
    List<StageState> ls=[];
    await Future.forEach(results, (element)  {
      ls.add(StageState.fromMap(element));
      //print(element.toString());
    });
    return ls;
  }
  Future<List<StageState>> sortedAll(String cg) async {
    final db = await database;
    List<Map> results = await db.rawQuery("SELECT * FROM $tableName WHERE category = '$cg' ORDER BY unlock DESC ,clear");
    List<StageState> ls=[];
    await Future.forEach(results,(element) {
      ls.add(StageState.fromMap(element));
    });
    return ls;
  }

  Future<List<ClearedLevel>> getAllByKey(String key) async{
    final db = await database;
   // ClearedLevel model=ClearedLevel(level: 0, pictureName: key, score: 0);
   // final keymap=model.getKeyList();
    List<Map> results = await db.rawQuery("SELECT * FROM $tableName WHERE path = '$key'");
    List<ClearedLevel> ls=[];
    await Future.forEach(results,(element) {
      ls.add(ClearedLevel.fromMap(element));
    });
    return ls;
  }
}
