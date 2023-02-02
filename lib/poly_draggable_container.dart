import 'package:drag/widget.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'Point.dart';
import 'polygon_helper.dart';
import 'polygonal.dart';
import 'equilateral_polygon_path.dart';

class PolyDraggableContainer extends StatefulWidget {
  const PolyDraggableContainer({Key? key}) : super(key: key);

  @override
  State<PolyDraggableContainer> createState() => _PolyDraggableContainerState();
}

class _PolyDraggableContainerState extends State<PolyDraggableContainer> {
  var _hover = false;
  var backgroundPolygon = Polygon.fromEquilateralPolygonPath(
      EquilateralPolygonPath(size: 170,count: 40)
  );
  // var polygonalPath = EquilateralPolygonPath(size: 170,count: 40);
  var offset = Offset(200,0);
  var containerSize = Size(200,200);
  //使用系统自带的Path做出来的圆,但是获取不到路径
  // var backCirclePath = Path();
  // var poly = Polygon(backCirclePath.getBounds());

  @override
  void initState() {
    backgroundPolygon.offset(30,10);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Transform.translate(offset: offset,child:
        MouseRegion(
          onEnter: (e)
          {
            // setState(() {
            //   _hover = true;
            // });
          },
          onExit: (e){
            setState(() {
              _hover = false;
            });
          },
          onHover: (e){
            var bound = context.globalPaintBounds;
            var offset = PointEX(e.position.dx - bound!.left-this.offset.dx, e.position.dy - bound.top-this.offset.dy);
            setState(() {
              var polyCirclePoints = backgroundPolygon.points.map((e) => PointEX(e.x,e.y)).toList();
              // print('位移量: $offset');
              var inPolyCircle = backgroundPolygon.isPointIn(offset);
              _hover = inPolyCircle;
            });
          },
          child: Container(
            width: containerSize.width,
            height: containerSize.height,
            color: Colors.grey,
            child: ClipPath(
              clipper: PathClipper(backgroundPolygon.getPath()),
              child:
              Container(width: 100,height: 100, color: _hover? Colors.red: Colors.amberAccent,),
              // Polygonal(
              //   size: 100,
              //   bigR: 50,
              //   count: 11,
              //   type: Type.side,
              // ),
            ),
          ),
        )
    );
  }
}

class PathClipper extends CustomClipper<Path> {
  final Path path;
  PathClipper(this.path);
  @override
  Path getClip(Size size) {
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
