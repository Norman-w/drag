import 'package:flutter/material.dart';
import 'dart:math';

/// 使用边创建正多少边的形状
class EquilateralPolygonPath {
  final double size; // 组件大小
  final int count; // 几边形
  late var points = <Point<double>>[];



  EquilateralPolygonPath(
      {
        this.size = 80,
        this.count = 3,}){
    //region 函数定义
    start(double x, double y)
    {
      points.add(Point(x,y));
    }
    lineTo(double x, double y)
    {
      points.add(Point(x,y));
    }
    //endregion

    double r = size / 2;
    print(r);
    // 将圆等分,开始第一个点
    start(r * cos(pi / count)+r, r * sin(pi / count)+r);

    //创建边
    // start(r * cos(pi / count), r * sin(pi / count));
    for (int i = 2; i <= count * 2; i++) {
      if (i.isOdd) {
        lineTo(r * cos(pi / count * i)+r, r * sin(pi / count * i)+r);
      }
    }
  }

  Path toPath()
  {
    var path = Path();
    path.addPolygon(points.map((e) => Offset(e.x,e.y)).toList(), true);
    return path;
  }
}