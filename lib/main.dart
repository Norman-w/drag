import 'package:drag/useless/poly_draggable_container.dart';
import 'package:flutter/material.dart';

import 'clipped_container.dart';
import 'point_ex.dart';
import 'background.dart';
import 'graphics.dart';
import 'polygon.dart';
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

    Offset childOffset = Offset(10,10);

    var focusedNode = [];


    return MaterialApp(
      title: 'Material App',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(ret.toString()),
        ),
        body: Row(
          children: [
            Background(),
            // PolyDraggableContainer(),
            ClippedContainer(
              key:Key("1"),
              onFocus: (){
                print("onFocus parent");
              },
              backgroundColor: Colors.grey,
              hoverColor: Colors.white,
              containerSize: Size(100, 100),
              backgroundPolygon: Polygon([
                PointEX(10, 5),
                PointEX(100, 10),
                PointEX(90, 100),
                PointEX(0, 100),
              ]
              ),
              child:
                  Positioned(
                    left: childOffset.dx,
                    top: childOffset.dy,
                    child:
                      ClippedContainer(
                        onFocus: (){
                          print("onFocus child");
                        },
                        normalColor: Colors.red,
                        hoverColor: Colors.amber,
                        clickColor: Colors.purple,
                        key : const Key("child"),
                        backgroundColor: Colors.blue,
                        containerSize: Size(20, 20),
                        backgroundPolygon: Polygon([
                          PointEX(0, 0),
                          PointEX(20, 0),
                          PointEX(20, 20),
                          PointEX(0, 20),
                        ]
                        ),
                        child: Text("child"),
                      ),
                    ),
            ),
          ]
        ),
      ),
    );
  }
}
