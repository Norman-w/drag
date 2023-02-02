import 'package:drag/widget.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'polygon_helper.dart';
import 'polygonal.dart';
import 'polygonal_path.dart';

class PolyDraggableContainer extends StatefulWidget {
  const PolyDraggableContainer({Key? key}) : super(key: key);

  @override
  State<PolyDraggableContainer> createState() => _PolyDraggableContainerState();
}

class _PolyDraggableContainerState extends State<PolyDraggableContainer> {
  var _hover = false;
  var polygonalPath = PolygonalPath(size: 80,count: 40);
  //使用系统自带的Path做出来的圆,但是获取不到路径
  // var backCirclePath = Path();
  // var poly = Polygon(backCirclePath.getBounds());

  @override
  void initState() {
    polygonalPath.offset(10,10);
    Rect rect = Rect.fromCircle(
      center: const Offset(50.0, 50.0),
      radius: 50.0,
    );
    // backCirclePath.addArc(rect, 0, math.pi*2);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Transform.translate(offset: Offset(100,0),child:
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
            var offset = Point(e.position.dx - bound!.left-100, e.position.dy - bound.top);
            setState(() {
              var polyCirclePoints = polygonalPath.points.map((e) => Point(e.x,e.y)).toList();
              // print('位移量: $offset');
              var inPolyCircle = checkIsPtInPoly(offset,polyCirclePoints);
              _hover = inPolyCircle;
            });
          },
          child: Container(
            width: 100,
            height: 100,
            color: Colors.grey,
            child: ClipPath(
              clipper: PathClipper(polygonalPath.toPath()),
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
