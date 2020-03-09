import 'package:flutter/material.dart';

class TaskCard extends StatefulWidget{
  final Widget child;
  final Color boderShadowColor;

  TaskCard({Key key, @required this.child, this.boderShadowColor}): super(key: key);

  @override
  _TaskCardState createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Card(
          margin: EdgeInsets.all(20.0),
          color: Colors.white,
          child: Container(
            padding: EdgeInsets.all(20.0),
            child: widget.child,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: widget.boderShadowColor ?? Colors.black,
                width: 2.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: widget.boderShadowColor ?? Colors.black,
                  offset: Offset(10.0, 10),
                )
              ] 
            )
          )

        ),
      ],
    );
  }
}