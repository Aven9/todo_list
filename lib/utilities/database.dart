import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo_list/model/task.dart';

class DataBaseTool {
  static DataBaseTool _dataBaseTool;
  static Database _database;

  String task_table = "task_table";
  String task_title = "task_title";
  String task_category = "task_category";
  String task_progress = "task_progress";
  String task_status = "task_status";
  String task_id = "task_id";

  String category_table = "category_table";
  String category_name = "category_name";

  DataBaseTool._createInstance();

  factory DataBaseTool() {
    if (_dataBaseTool == null) {
      _dataBaseTool = DataBaseTool._createInstance();
    }
    return _dataBaseTool;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    //Get the directory path for both Android and iOS to store Database.
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + "task.db";

    //Open/Create the database at the given path
    var taskDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return taskDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE IF NOT EXISTS $task_table ($task_id TEXT PRIMARY KEY, $task_category TEXT, $task_title TEXT, $task_progress REAL, $task_status INTEGER');
    await db.execute('CREATE TABLE IF NOT EXISTS $category_table ($task_category TEXT PRIMARY KEY, UNIQUE($task_category))');
  }

  //Fetch Operation: Get all Task objects from database
  Future<List<Map<String, dynamic>>> getTaskMapList() async {
    Database db = await this.database;
    var result = db.rawQuery('SELECT * FROM $task_table order by $task_category, $task_id ASC');
    return result;
  }

  Future<List<Map<String, dynamic>>> getTaskMapListFrom(String category) async {
    Database db = await this.database;
    var result = db.rawQuery('SELECT * FROM $task_table where $task_category = ? order by $task_progress ASC', [category]);
    return result;
  }

  Future<List<String>> getCategoryList() async {
    Database db = await this.database;
    var category = await db.rawQuery('SELECT * FROM $category_table');
    int count = category.length;
    var result = List<String>();
    for (var i = 0; i < count; i++) {
      result.add(category[i][category_name]);
    }
    return result;
  }

  Future<List<Map<String, dynamic>>> getCompleteTaskMapList() async {
    Database db = await this.database;
    var result = db.rawQuery('SELECT * FROM $task_table where $task_status = ? order by $task_id ASC', [1]);
    return result;
  }

  Future<List<Map<String, dynamic>>> getCompleteTaskMapListFrom(String category) async {
    Database db = await this.database;
    var result = db.rawQuery('SELECT * FROM $task_table where $task_category = ? and $task_status = 1 order by $task_id ASC', [category]);
    return result;
  }

  Future<List<Map<String, dynamic>>> getIncompleteTaskMapList() async {
    Database db = await this.database;
    var result = db.rawQuery('SELECT * FROM $task_table where $task_status = ? order by $task_id ASC', [0]);
    return result;
  }

  Future<List<Map<String, dynamic>>> getIncompleteTaskMapListFrom(String category) async {
    Database db = await this.database;
    var result = db.rawQuery('SELECT * FROM $task_table where $task_category = ? and $task_status = 0 order by $task_id ASC', [category]);
    return result;
  }

  //Insert Operation: Insert a Task object to database
  Future<int> insertTask(Task task) async {
    Database db = await this.database;
    var result = await db.insert(task_table, task.toMap());
    debugPrint("Insert Task OK.");
    return result;
  }

  // Insert a Category to Database
  Future<int> insertCategory(String category) async {
    Database db = await this.database;
    var map = Map();
    map[category_name] = category;
    var result = 
      await db.rawInsert('INSERT OR IGNORE INTO $category_table($task_category) VALUES($category)');
    return result;
  }

  //Update Operation: Update a Task object and save it to database
  Future<int> updateTask(Task task) async {
    var db = await this.database;
    var result = await db.update(task_table, task.toMap(), where: '$task_id = ?', whereArgs: [task.createTime] );
    return result;
  }

  //Delete Operation: Delete a Task object from database
  Future<int> deleteTask(String id) async{
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM $task_table WHERE $task_id=?', [id]);
    return result;
  }

  //Delete a Category from Database
  Future<int> deleteCategory(String category) async{
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM $category_table WHERE $category_name=?', [category]);
    result += await db.rawDelete('DELETE FROM $task_table WHERE $task_category=?', [category]);
    return result;
  }

  //Get no. of Task objects in database
  Future<int> getCount() async{
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) FROM $task_table');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<List<Task>> getTaskList() async{
    var taskMapList = await getTaskMapList(); //Get Map List from database
    int count = taskMapList.length;
    List<Task> taskList = List<Task>();
    //For loop to create Task List from a Map List
    for (int i=0; i<count; i++){
      taskList.add(Task.fromMap(taskMapList[i]));
    }
    return taskList;
  }

  Future<List<Task>> getTaskListFrom(String category) async{
    var taskMapList = await getTaskMapListFrom(category); //Get Map List from database
    int count = taskMapList.length;
    List<Task> taskList = List<Task>();
    //For loop to create Task List from a Map List
    for (int i=0; i<count; i++){
      taskList.add(Task.fromMap(taskMapList[i]));
    }
    return taskList;
  }  

  Future<List<Task>> getInCompleteTaskList() async{
    var taskMapList = await getIncompleteTaskMapList(); //Get Map List from database
    int count = taskMapList.length;
    List<Task> taskList = List<Task>();
    //For loop to create Task List from a Map List
    for (int i=0; i<count; i++){
      taskList.add(Task.fromMap(taskMapList[i]));
    }
    return taskList;
  }

  Future<List<Task>> getCompleteTaskList() async{
    var taskMapList = await getCompleteTaskMapList(); //Get Map List from database
    int count = taskMapList.length;

    List<Task> taskList = List<Task>();
    //For loop to create Task List from a Map List
    for (int i=0; i<count; i++){
      taskList.add(Task.fromMap(taskMapList[i]));
    }
    return taskList;
  }
}