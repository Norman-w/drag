import 'dart:async';
import 'dart:math';

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


    print(vector);

    return Container(
      color: Colors.lightBlue,
      width: 300,
      height: 300,
      child:
        Stack(
          alignment: Alignment.center,
          children: [
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
    return 'Vector2D{x: $x, y: $y}';
  }
}

test()
{
  Matrix4 matrix = Matrix4.identity();
  matrix.rotateZ(0.5);
}