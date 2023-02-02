import 'package:drag/poly_draggable_container.dart';
import 'package:flutter/material.dart';

import 'Point.dart';
import 'background.dart';
import 'graphics.dart';
import 'polygon_helper.dart';

void main() => runApp(MyApp());


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //region this way is not work for me.may be there is some typo or syntax issues;
    //只能判断出来是否相等 和是否相离  但是这根本不满足需求.所以自己写一个吧.
    //
    // Poly poly1= Poly();
    // poly1.pointList = [
    //   Coord(0, 0),
    //   Coord(100, 0),
    //   Coord(100, 100),
    //   Coord(0, 100),
    // ];
    //
    // Poly poly2 = Poly();
    // poly2.pointList = [
    //   Coord(1, 1),
    //   Coord(99, 1),
    //   Coord(99, 99),
    //   Coord(1, 99),
    // ];
    //
    // var region = Region();
    // var ret = region.relativePosition(poly1, poly2);
    // print(ret);//endregion

    // var path = Path();
    // path.addPolygon([
    //   Offset(0, 0),
    //   Offset(100, 0),
    //   Offset(100, 100),
    //   Offset(0, 100),
    // ], true);
    // var point = Offset(0,0);
    // var contains = path.contains(point);
    var ret = "";

    Polygon p1 = Polygon(
        [
          PointEX(1, 1),
          PointEX(100, 0),
          PointEX(100, 100),
          PointEX(0, 100),
        ]
    );
    Polygon p2 = Polygon(
        [
          PointEX(0, 0),
          PointEX(100, 0),
          PointEX(100, 100),
          PointEX(0, 100),
        ]
    );
    Polygon p3 = Polygon(
        [
          PointEX(0,0),
          PointEX(10,0),
          PointEX(10,10),
          PointEX(20,10),
          PointEX(20,0),
          PointEX(30,0),
          PointEX(30,40),
          PointEX(0,40),
        ]
    );
    print(p3.isPointIn(PointEX(10,0)));

    ret = p2.getRelativeWith(p1).toString();
    // print(ret);


    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: Text(ret.toString()),
        ),
        body: Row(
          children: const [
            Background(),
            PolyDraggableContainer(),
        ]
        ),
      ),
    );
  }
}
