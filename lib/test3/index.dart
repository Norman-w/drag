import 'dart:async';
import 'dart:math';

import 'package:drag/widget.dart';
import 'package:flutter/material.dart';

class VectorDragging extends StatefulWidget {
  @override
  _VectorDraggingState createState() => _VectorDraggingState();
}

class _VectorDraggingState extends State<VectorDragging> {
  Vector2D vector = Vector2D(1, 0);

  @override
  initState() {
    super.initState();
    // Timer.periodic(Duration(milliseconds: 5), (timer) {
    //   setState(() {
    //     Matrix4 matrix = Matrix4.identity();
    //     matrix.rotateZ(0.01);
    //     vector = vector.transform(matrix);
    //     vector.setLength(200);
    //     setState(
    //       () {
    //         vector = vector;
    //       },
    //     );
    //   });
    // });
    Matrix4 matrix = Matrix4.identity();
    matrix.rotateZ(pi/2);//90度
    vector = vector.transform(matrix);
    vector.setLength(250);
  }

  @override
  Widget build(BuildContext context) {
    // print(vector);
    var bound = context.globalPaintBounds;
    var vec = Vector2D(100, 0);
    if(bound!= null)
      {
        vec = vec.transform(Matrix4.rotationZ(pi/2));
        vec = vec.translate(Vector2D(bound.width / 2, bound.height / 2));

        print(vec);
        // vec.setLength(30);
      }


    return Container(
      color: Colors.lightBlue,
      width: 300,
      height: 300,
      child:
        Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: CustomPaint(
                painter: MyPainter(vec),
                size: Size(300, 300),
              ),
            ),
            Positioned(
              left: vector.x,
              top: vector.y,
              child: Container(
                width: 50,
                height: 50,
                color: Colors.red,
              ),
            ),
          ],
        )
    );
  }
}
class Vector2D {
  double x;
  double y;

  Vector2D(this.x, this.y);
  translate(Vector2D vector) {
    return Vector2D(x + vector.x, y + vector.y);
  }
  transform(Matrix4 matrix) {
    Vector2D vector = Vector2D(x, y);
    vector.x = matrix[0] * x + matrix[4] * y + matrix[12];
    vector.y = matrix[1] * x + matrix[5] * y + matrix[13];
    return vector;
  }
  operator +(Vector2D vector) {
    return Vector2D(x + vector.x, y + vector.y);
  }
  setLength(double length) {
    double angle = getAngle();
    x = length * cos(angle);
    y = length * sin(angle);
  }
  getAngle() {
    return atan2(y, x);
  }
  @override
  String toString() {
    return 'Vector2D{x: ${x.toStringAsFixed(2)}, y: ${y.toStringAsFixed(2)}';
  }
}

// test()
// {
//   Matrix4 matrix = Matrix4.identity();
//   matrix.rotateZ(0.5);
// }

class MyPainter extends CustomPainter{
  Vector2D vector;
  MyPainter(this.vector);
  @override
  void paint(Canvas canvas, Size size) {
    var center = Offset(size.width / 2, size.height / 2);
    Paint paint = Paint();
    paint.color = Colors.red;
    paint.strokeWidth = 2;
    paint.style = PaintingStyle.stroke;
    canvas.drawLine(center, Offset(vector.x, vector.y), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}
