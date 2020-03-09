import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:todo_list/utilities/database.dart';
import 'package:todo_list/view/decorate_input.dart';
import 'package:todo_list/model/task.dart';
import 'package:todo_list/view/task_card.dart';
import 'package:todo_list/utilities/common_utils.dart';

/// Category Page is complete page of a category of tasks.
class Category extends StatefulWidget {
  final String title;
  Category({Key key, this.title}) : super(key: key);
  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  static DataBaseTool db_tool = DataBaseTool();
  Future<Database> db = db_tool.initializeDatabase();

  @override
  Widget build(BuildContext context) {
    // get list from provider.
    final listProvider = Provider.of<TaskList>(context);
    return Scaffold(
      appBar: AppBar(
        title: Row(
            children: <Widget>[
              Text(widget.title),
              // Expanded(
              //   child: TextField(
              //     controller: controller,
              //     style: TextStyle(
              //       fontSize: 20.0,
              //     ),
              //     decoration: InputDecoration.collapsed(
              //       hintText: widget.title,
              //     ),
              //     autofocus: true,
              //     keyboardType: TextInputType.text,
              //   ),
              // ),
            ],
          ),
      ),
      body: Center(
          child: Column(
              children: <Widget>[
                Column(
                  children: List.generate(listProvider.taskList.length, (index){
                    return TaskCard(
                      child: Text(listProvider.taskList[index].title),
                    );
                  }),
                ),
                DecorateInput(
                  category: widget.title,
                  title: "Task",
                  placeHoderText: "Create a Task",
                )
              ],
          ),
        ),
    );
  }
}
