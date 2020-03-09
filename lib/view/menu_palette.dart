import 'dart:math';
import 'package:provider/provider.dart';
import 'package:todo_list/model/task.dart';
import 'package:todo_list/view/category.dart';
import 'package:flutter/material.dart';
import 'package:circle_list/circle_list.dart';
import 'package:flutter/cupertino.dart';

class MenuPalette extends StatefulWidget {
  final VoidCallback onExit;
  List<String> icons_name = [
    'work', 'learn', 'book', 'game', 'travel', 'exersize',
  ];
  MenuPalette({this.onExit});
  @override
  _MenuPaletteState createState() => _MenuPaletteState();
}

class _MenuPaletteState extends State<MenuPalette>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;
  var _children = Map<String, dynamic>();

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _animation = new Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine));
    _controller.forward();
    _children['work'] = Icons.work;
    _children['learn'] = Icons.assignment;
    _children['book'] = Icons.book;
    _children['game'] = Icons.games;
    _children['travel'] = Icons.flight;
    _children['exersize'] = Icons.accessibility;
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    debugPrint("Menu Palette 销毁");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final minSize = min(size.height, size.width);
    final circleSize = minSize;
    final Offset circleOrigin = Offset((size.width - circleSize) / 2, 0);
  
    return WillPopScope(
      onWillPop: () {
        doExit(context, _controller);
        return Future.value(false);
      },
      child: GestureDetector(
        onTap: () {
          doExit(context, _controller);
        },
        child: Scaffold(
          backgroundColor: Colors.black.withOpacity(0),
          body: Container(
            width: size.width,
            height: size.height,
            child: Stack(
              children: <Widget>[
                Positioned(
                  bottom: 20,
                  left: size.width / 2 - 28,
                  child: AnimatedBuilder(
                      animation: _animation,
                      child: Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                            color: Theme.of(context)
                                .primaryColorDark
                                .withOpacity(0.2),
                            shape: BoxShape.circle),
                      ),
                      builder: (ctx, child) {
                        return Transform.scale(
                          scale: (max(size.height, size.width) / 28) * (_animation.value),
                          child: child,
                        );
                      }),
                ),
                Positioned(
                  left: circleOrigin.dx,
                  top: circleOrigin.dy,
                  child: AnimatedBuilder(
                    animation: _animation,
                    child: CircleList(
                      origin: Offset(0, -min(size.height, size.width) / 2 + 20),
                      showInitialAnimation: true,
                      children: List.generate(_children.length, (index) {
                        return IconButton(
                          onPressed: () {
                            doExit(context, _controller);
                            Navigator.of(context).push(
                              new CupertinoPageRoute(
                                builder: (ctx) {
                                  // 一个新建的分类页面 return xxx;
                                  return ChangeNotifierProvider(
                                    create: (context)=>TaskList(),
                                    child: Category(title: widget.icons_name[index]),
                                  );
                                },
                              ),
                            );
                          },
                          tooltip: widget.icons_name[index],
                          icon: Icon(
                            _children[widget.icons_name[index]],
                            size: 40,
                            color: Colors.white,
                          ),
                        );
                      }),
                      innerCircleColor: Theme.of(context).primaryColorLight,
                      outerCircleColor: Colors.lightBlue,
                      innerCircleRotateWithChildren: true,
                      centerWidget: GestureDetector(
                          onTap: () {
                            doExit(context, _controller);
                            debugPrint("点击了menu");
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width / 3,
                            height: MediaQuery.of(context).size.width / 3,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            child: Container(
                              color: Colors.transparent,
                              child: Icon(
                                Icons.clear,
                                color: Colors.white,
                                size: 40,
                              ),
                            ),
                          )),
                    ),
                    builder: (ctx, child) {
                      return Transform.translate(
                          offset: Offset(
                              0,
                              MediaQuery.of(context).size.height -
                                  (_animation.value) * circleSize),
                          child: Transform.scale(
                              scale: _animation.value, child: child));
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void doExit(BuildContext context, AnimationController controller) {
    widget?.onExit();
    controller.reverse().then((r) {
      Navigator.of(context).pop();
    });
  }
}
