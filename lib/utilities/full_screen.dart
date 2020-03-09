import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/view/category.dart';

class FullScreenDialog{
  static FullScreenDialog _instance;

  static FullScreenDialog getInstance(){
    if(_instance == null){
        _instance = FullScreenDialog._internal();
    }
    return _instance;
  }

  FullScreenDialog._internal();

  void showDialog(BuildContext context, Widget child){
    Navigator.push(
      context,
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (ctx,anm1,anm2){
          return child;
        }
      ),
    );
  }
}