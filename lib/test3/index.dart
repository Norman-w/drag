import 'dart:math';

import 'package:drag/widget.dart';
import 'package:flutter/material.dart';

class VectorDragging extends StatefulWidget {
  const VectorDragging({super.key});

  @override
  _VectorDraggingState createState() => _VectorDraggingState();
}

class _VectorDraggingState extends State<VectorDragging> {
  // Vector2D dragStartPos = Vector2D(0, 0);
  Offset? mouseDownPosition;
  Offset? mouseMoveToPosition;

  Vector2D nodePosition = Vector2D(0, 0);
  Vector2D nodePositionWhenMouseDown = Vector2D(0, 0);

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

    // Matrix4 matrix = Matrix4.identity();
    // matrix.rotateZ(pi / 2); //90度
    // dragStartPos = dragStartPos.transform(matrix);
    // dragStartPos.setLength(250);
  }

  @override
  Widget build(BuildContext context) {
    // print(vector);
    var bound = context.globalPaintBounds;
    var vec = Vector2D(100, 0);
    if (bound != null) {
      // vec = vec.transform(Matrix4.rotationZ(pi/2));
      vec = vec.rotateZ(pi / 4);
      vec = vec.translate(Vector2D(bound.width / 2, bound.height / 2));

      // vec.setLength(30);
    }

    return Container(
        color: Colors.lightBlue,
        width: 300,
        height: 300,
        child: MouseRegion(
            onHover: (event) {
              setState(() {
                mouseMoveToPosition = event.localPosition;
              });
            },
            onExit: (event) {
              setState(() {
                // mouseMoveToPosition = null;
                // mouseDownPosition = null;
              });
            },
            child: Listener(
                onPointerDown: (event) {
                  setState(() {
                    mouseDownPosition = event.localPosition;
                    nodePositionWhenMouseDown = Vector2D(
                        nodePosition.x, nodePosition.y);
                  });
                },
                onPointerUp: (event) {
                  setState(() {
                    mouseMoveToPosition = null;
                    mouseDownPosition = null;
                  });
                },
                onPointerMove: (event) {
                  setState(() {
                    mouseMoveToPosition = event.localPosition;
                    var mouseOffset = mouseMoveToPosition! - mouseDownPosition!;
                    nodePosition = nodePositionWhenMouseDown.translate(Vector2D(
                        mouseOffset.dx, mouseOffset.dy));
                  });
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child:
                          CustomPaint(
                        painter: MyPainter(
                            vec, mouseDownPosition, mouseMoveToPosition),
                        size: const Size(300, 300),
                        child: CustomPaint(
                          painter: MyPainter2(mouseDownPosition),
                          size: Size(300, 300),
                        ),
                      ),
                    ),
                    Positioned(
                      left: nodePosition.x,
                      top: nodePosition.y,
                      child: Container(
                        width: 50,
                        height: 50,
                        color: const Color.fromARGB(128, 24, 243, 122),
                      ),
                    ),
                  ],
                ))));
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

  //rotate z by angle without using matrix
  rotateZ(double angle) {
    double x = this.x * cos(angle) - this.y * sin(angle);
    double y = this.x * sin(angle) + this.y * cos(angle);
    return Vector2D(x, y);
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
