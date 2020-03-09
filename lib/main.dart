import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/view/home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runAppSpector();
  runApp(MyApp());
}

void runAppSpector() {
  // var config = new Config();
  // config.iosApiKey = "ios_YWQ4MWQ1MzctNWZhMi00YTg4LTlhNWEtN2ZhNzMxODVhMThl";
  // config.androidApiKey = "android_MGE2ZTRlNTQtNTU5MS00YWRkLTkxNjUtOGFjODI0NDUwZWU2";
  // AppSpectorPlugin.run(config);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Theme.of(context).platform == TargetPlatform.iOS ? Colors.blue[100]: null,
      ),
      home: HomePage(title: 'todo-demo'),
    );
  }
}
