import 'package:flutter/material.dart';
import 'package:todo_list/view/task_card.dart';
import 'package:todo_list/view/menu.dart';
import 'package:todo_list/view/animated_floating_button.dart';

class HomePage extends StatefulWidget {
  final String title;
  HomePage({Key key, this.title}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget> [
            UserAccountsDrawerHeader(
              accountName: Text('Fresh Man'), 
              accountEmail: Text('Have a good day'),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage(
                  // 默认头像
                  'lib/img/icon_default.png'
                ),
              ),
              otherAccountsPictures: <Widget>[
                Icon(
                  Icons.share,
                  color: Colors.white,
                ),
              ],
              ),

            ListTile(
              title: Text('Page One'),
              trailing: Icon(Icons.arrow_upward),
              onTap: (){
                Navigator.of(context).pop();
                // Navigator.of(context).pushNamed("new_page");
              },
            ),
            new Divider(),
            ListTile(
              title: Text('Close'),
              trailing: Icon(Icons.close),
              onTap: (){
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              // child: TaskCard(
              //   boderShadowColor: Colors.blue,
              //   child: Column(
              //     children: <Widget>[
              //       Text("A New Task", style: TextStyle(fontSize: 28.0)),
              //     ],
              //   ),
              // )
              child: Text('当前还没有分类，先创建一个吧~'),
            ),
          ],
        ),
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AnimatedFloatingButton(
        bgColor: Colors.blue,
      ),
    );
  }
}
