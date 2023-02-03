import 'package:drag/widget.dart';
import 'package:flutter/material.dart';

import 'path_clipper.dart';
import 'polygon.dart';
import 'polygon_helper.dart';

class ClippedContainer extends StatefulWidget {
  final Size containerSize;
  final Polygon backgroundPolygon;
  final Color backgroundColor;
  final Color hoverColor;
  final Color normalColor;
  final Color clickColor;
  final Widget child;
  final Function? onFocus;

  const ClippedContainer({
    Key? key,
    required this.containerSize,
    required this.backgroundPolygon,
    required this.child,
    this.hoverColor = Colors.red,
    this.normalColor = Colors.orange,
    this.clickColor = Colors.green,
    this.backgroundColor = Colors.grey, this.onFocus,
  }) : super(key: key);

  @override
  State<ClippedContainer> createState() => _ClippedContainerState();
}

//create state class for ClippedContainer with MouseRegion
class _ClippedContainerState extends State<ClippedContainer> {
  var _hover = false;
  var _click = false;
  ///子组件的点击事件
  childCachedClick() {
    setState(() {
      _click = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var containerSize = widget.containerSize;
    var backgroundPolygon = widget.backgroundPolygon;
    var bound = context.globalPaintBounds;

    // print('containerSize: $containerSize');

    return MouseRegion(
      onHover: (e) {
        var mouseInBound = bound == null ? Offset(0, 0)
            : Offset(e.position.dx - bound.left, e.position.dy - bound.top);

        setState(() {
          var isInChild = backgroundPolygon.isPointXYIn(
              mouseInBound.dx, mouseInBound.dy);
          if (widget.key.toString() == '[<\'child\'>]') {
            // print('${widget.key} mouseInBound: $mouseInBound');
            // print('is in child: $isInChild, $mouseInBound hoverColor: ${widget
            //     .hoverColor}');
          }
          _hover = isInChild;
          if(isInChild){
            widget.onFocus?.call();
          }
        });
      },
      onEnter: (e) {
        //后期可以加入一个东西:
        //如果裁剪的矩形边缘有很多空的地方,那么在进入以后做一个标记 是鼠标进入.
        //只有鼠标进入了以后 才对onHover 进行一个检测. 当时这个可能也不会特别影响性能.
      },
      onExit: (e) {
        setState(() {
          print('exit');
          _hover = false;
        });
      },
      child:
      Listener(
        onPointerDown: (e) {
          setState(() {
            _click = true;
          });
        },
        onPointerUp: (e) {
          setState(() {
            print('up');
            _click = false;
          });
        },
        child:
        Container(
          key: widget.key,
          width: containerSize.width,
          height: containerSize.height,
          color: widget.backgroundColor,
          //框框里面的裁剪以后的背景
          child: ClipPath(
            clipper: PathClipper(backgroundPolygon.toPath()),
            child:
            //背景里面的背景色
            Container(width: containerSize.width,
              height: containerSize.height,
              color:
              _click ? widget.clickColor : (_hover ? widget.hoverColor
                  : widget.normalColor),
              child:
              Stack(
                  children: [
                    // Align(
                    //   alignment: Alignment.topLeft,
                    //   child: widget.child,
                    // ),
                    widget.child,
                  ]
              ),

            ),
          ),
        ),
      ),
    );
  }
}