
import 'package:flutter/material.dart';

import '../geometry/points/point_ex.dart';
import '../geometry/planes/polygon.dart';
import '../geometry/vectors/vector2d.dart';

class MyPainter extends CustomPainter {
  Offset? mouseDownPosition;
  Offset? mouseMoveToPosition;
  Vector2D vector;

  MyPainter(
      this.vector, Offset? mouseDownPosition, Offset? mouseMoveToPosition) {
    this.mouseDownPosition = mouseDownPosition;
    this.mouseMoveToPosition = mouseMoveToPosition;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if(mouseMoveToPosition == null) return;
    //cancel when no mouse down
    if (mouseDownPosition == null) return;
    //draw line start with mouse down position and end with mouse move to position
    canvas.drawLine(
        mouseDownPosition!, mouseMoveToPosition!, Paint()..color = Colors.red);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

//show a red dot when mouse down
class MyPainter2 extends CustomPainter {
  Offset? mouseDownPosition;

  MyPainter2(Offset? mouseDownPosition) {
    this.mouseDownPosition = mouseDownPosition;
  }

  @override
  void paint(Canvas canvas, Size size) {
    //cancel when no mouse down
    if (mouseDownPosition == null) return;
    //draw line start with mouse down position and end with mouse move to position
    canvas.drawCircle(mouseDownPosition!, 5, Paint()..color = Colors.red);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

//show blue dots on each Polygon vertex
class MyPainter3 extends CustomPainter {
  Polygon polygon;
  Vector2D nodePosition;

  MyPainter3(this.polygon, this.nodePosition);

  @override
  void paint(Canvas canvas, Size size) {
    if(polygon.points.isEmpty) return;
    polygon.points.forEach((element) {
      canvas.drawCircle(Offset(element.x + nodePosition.x, element.y+ nodePosition.y), 5,
          Paint()..color = Colors.blue);
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

//show yellow dots for vertexesOfPolyWhenMouseDown
class MyPainter4 extends CustomPainter {
  List<Vector2D>? vertexesOfPolyWhenMouseDown;

  MyPainter4(this.vertexesOfPolyWhenMouseDown);

  @override
  void paint(Canvas canvas, Size size) {
    if(vertexesOfPolyWhenMouseDown == null || vertexesOfPolyWhenMouseDown!.isEmpty) return;
    vertexesOfPolyWhenMouseDown!.forEach((element) {
      canvas.drawCircle(Offset(element.x, element.y), 5,
          Paint()..color = Colors.yellow);
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

//show lines for vertexesOfPolyWhenMouseDown
class MyPainter5 extends CustomPainter {
  List<Vector2D>? vertexesOfPolyWhenMouseDown;
  List<Vector2D>? vertexesOfMovingParallelMouseDirection;

  MyPainter5(this.vertexesOfPolyWhenMouseDown, this.vertexesOfMovingParallelMouseDirection);

  @override
  void paint(Canvas canvas, Size size) {
    if(vertexesOfMovingParallelMouseDirection == null || vertexesOfMovingParallelMouseDirection!.isEmpty) return;
    if(vertexesOfPolyWhenMouseDown == null || vertexesOfPolyWhenMouseDown!.isEmpty) return;
    //draw lines start with vertexesOfPolyWhenMouseDown and end with vertexesOfMovingParallelMouseDirection
    for(int i = 0; i < vertexesOfPolyWhenMouseDown!.length; i++) {
      canvas.drawLine(
          Offset(vertexesOfPolyWhenMouseDown![i].x, vertexesOfPolyWhenMouseDown![i].y),
          Offset(vertexesOfMovingParallelMouseDirection![i].x, vertexesOfMovingParallelMouseDirection![i].y),
          Paint()..color = Colors.yellow);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

//show line for given two points
class LinePainter extends CustomPainter {
  PointEX? point1;
  PointEX? point2;

  LinePainter(this.point1, this.point2);

  @override
  void paint(Canvas canvas, Size size) {
    if(point1 == null || point2 == null) return;
    canvas.drawLine(
        Offset(point1!.x, point1!.y),
        Offset(point2!.x, point2!.y),
        Paint()..color = Colors.purple
        ..strokeWidth = 2
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
