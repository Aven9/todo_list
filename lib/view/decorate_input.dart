import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:todo_list/utilities/common_utils.dart';
import 'package:todo_list/utilities/database.dart';
import 'package:todo_list/model/task.dart';

class DecorateInput extends StatefulWidget {
  final String category;
  final String title;
  final String placeHoderText;

  DecorateInput({Key key, this.category, this.title, this.placeHoderText})
      : super(key: key);

  @override
  _DecorateInputState createState() => _DecorateInputState();
}

class _DecorateInputState extends State<DecorateInput> {
  final controller = TextEditingController();
  static DataBaseTool db_tool = DataBaseTool();
  Future<Database> db = db_tool.initializeDatabase();
  Task task = null;
  
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final listProvider = Provider.of<TaskList>(context);
    return Material(
      child: Container(
        padding: const EdgeInsets.all(30.0),
        color: Colors.white,
        child: Container(
            child: Column(
              children: [
              Padding(padding: EdgeInsets.only(top: 30.0)),
                  TextFormField(
                    controller: controller,
                    decoration: InputDecoration(
                      labelText: widget.title,
                      fillColor: Colors.white,
                      hintText: widget.placeHoderText,
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                        borderSide: new BorderSide(),
                      ),
                    ),
                    validator: (val) {
                      if (val.length == 0) {
                        return "Task can not be Empty!";
                      } else {
                        return null;
                      }
                    },
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    style: new TextStyle(
                      fontFamily: "Poppins",
                    ),
                    onEditingComplete: () async {
                      debugPrint("Complete Editing");
                      task = Task(widget.category, getTimeStamp(), widget.title);
                      await db_tool.insertTask(task);
                      listProvider.updateListFromDatabaseOf(widget.category);
                    },
                  ),
              ],
        )),
      ),
    );
  }
}
