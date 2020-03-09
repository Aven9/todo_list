import 'package:flutter/foundation.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:todo_list/utilities/database.dart';

class Task {
  /// Task is made of id(primary key), title, progress, create_time, reward, status
  /// every task belongs to a category.
  // String _id;
  String _title;
  String _category;
  double _progress = 0;
  String _createTime; // (primary Key);
  bool _isFinish = false;

  /// build
  Task(this._category, this._createTime, this._title);

  /// get methods:
  String get title => _title;
  String get category => _category;
  double get progress => _progress;
  String get createTime => _createTime;
  bool get isFinish => _isFinish;

  /// set methods:
  set title(String title) {
    _title = title;
  }

  // set category : need a list of existing categories.
  
  set progress(double progress) {
    _progress = progress;
    if (_progress == 1.0) {
      _isFinish = true;
    } else {
      _isFinish = false;
    }
  }

  set status(bool finish) {
    _isFinish = finish;
  }

  /// map:
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (createTime != null) {
      map['createTime'] = _createTime;
    }
    map['title'] = _title;
    map['category'] = _category;
    map['progress'] = _progress;
    map['isFinish'] = _isFinish;
    return map;
  }
  
  Task.fromMap(Map<String, dynamic> map) {
    this._createTime = map['createTime'];
    this._title = map['title'];
    this._category = map['category'];
    this._progress = map['progress'];
    this._isFinish = map['isFinish'];
  }
}

class TaskList with ChangeNotifier {
  List<Task> taskList = List<Task>();
  
  void updateListFromDatabaseOf(String category) async{
    DataBaseTool tool = DataBaseTool();
    taskList = await tool.getTaskListFrom(category);
    notifyListeners();
  }

}