import 'package:flutter/material.dart';

import 'logMonitor/index.dart';
import 'path_clipper.dart';
import 'geometry/planes/polygon.dart';
import 'geometry/planes/polygon_helper.dart';

class ClippedContainer extends StatelessWidget {
  final Size containerSize;
  final Polygon backgroundPolygon;
  final Color backgroundColor;
  final Color hoverColor;
  final Color normalColor;
  final Color clickColor;
  final Widget child;
  final bool isClicked;
  final bool isHover;

  const ClippedContainer({
    Key? key,
    required this.containerSize,
    required this.backgroundPolygon,
    required this.child,
    this.hoverColor = Colors.red,
    this.normalColor = Colors.orange,
    this.clickColor = Colors.green,
    this.backgroundColor = Colors.grey, required this.isClicked, required this.isHover,
  }) : super(key: key);

  //region 获取当前颜色
  Color getCurrentColor(){
    return isClicked ? clickColor : (isHover ? hoverColor
        : normalColor);
  }

  //endregion
  @override
  Widget build(BuildContext context) {
    //region 每次build的时候都要重新计算一下 外围的矩形 和颜色
    // console.log('build on ${key}');

    return Container(
      key: key,
      width: containerSize.width,
      height: containerSize.height,
      color: backgroundColor,
      //框框里面的裁剪以后的背景
      child: ClipPath(
        clipper: PathClipper(backgroundPolygon.toPath()),
        child:
        //背景里面的背景色
        Container(width: containerSize.width,
          height: containerSize.height,
          color: getCurrentColor(),
          child:
          Stack(
              children: [
                child,
              ]
          ),

        ),
      ),
    );
  }
}