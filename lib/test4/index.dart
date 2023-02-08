import 'dart:math';

import 'package:drag/widget.dart';
import 'package:flutter/material.dart';

import '../clipped_container.dart';
import '../geometry/lines/cross_info.dart';
import '../geometry/lines/line_segment.dart';
import '../geometry/points/point_ex.dart';
import '../geometry/planes/polygon.dart';
import 'custom_painters.dart';
import '../geometry/vectors/vector2d.dart';

class Test4 extends StatefulWidget {
  const Test4({super.key});

  @override
  createState() => _Test4State();
}

class _Test4State extends State<Test4> {
  Offset? mouseDownPosition;
  Offset? mouseMoveToPosition;

  Vector2D nodePosition = Vector2D(1, 1);
  Vector2D nodePositionWhenMouseDown = Vector2D(0, 0);
  var log = '';

  var backgroundPolygon = Polygon([
    PointEX(0, 0),
    PointEX(30, 0),
    PointEX(60, 60),
    PointEX(0, 60),
  ]);

  LineSegment crossTestLine = LineSegment(
      PointEX(100, 50),
      PointEX(250, 280));

  List<Vector2D>? vertexesOfPolyWhenMouseDown = [];//鼠标按下时候的顶点
  List<Vector2D>? vertexesOfMovingParallelMouseDirection = [];//鼠标移动方向上的顶点
  List<LineSegment> lines = [
    LineSegment(PointEX(0, 0), PointEX(300, 0)),
    LineSegment(PointEX(300, 0), PointEX(300, 300)),
    LineSegment(PointEX(300, 300), PointEX(0, 300)),
    LineSegment(PointEX(0, 300), PointEX(0, 0)),
  ];

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print(vector);
    var bound = context.globalPaintBounds;
    var vec = Vector2D(100, 0);
    if (bound != null) {
      vec = vec.rotateZ(pi / 4);
      vec = vec.translate(Vector2D(bound.width / 2, bound.height / 2));
    }

    return Container(
        color: Color.fromARGB(255, 215, 178, 122),
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
              });
            },
            child: Listener(
                onPointerDown: (event) {
                  setState(() {
                    mouseDownPosition = event.localPosition;
                    nodePositionWhenMouseDown = Vector2D(
                        nodePosition.x, nodePosition.y);
                    vertexesOfPolyWhenMouseDown = backgroundPolygon.points
                        .map((e) => Vector2D(e.x + nodePosition.x, e.y +nodePosition.y ))
                        .toList();
                  });
                },
                onPointerUp: (event) {
                  setState(() {
                    mouseMoveToPosition = null;
                    mouseDownPosition = null;
                    vertexesOfPolyWhenMouseDown = [];
                    vertexesOfMovingParallelMouseDirection = [];
                  });
                },
                onPointerMove: (event) {
                  setState(() {
                    mouseMoveToPosition = event.localPosition;
                    var mouseOffset = mouseMoveToPosition! - mouseDownPosition!;
                    var translateVector = Vector2D(
                        mouseOffset.dx, mouseOffset.dy);

                    // translateVector.setLength(10);

                    //set length to 50
                    // translateVector.setLength(50);

                    //region 计算每个起始顶点和鼠标移动方向上的顶点
                    vertexesOfMovingParallelMouseDirection =
                        vertexesOfPolyWhenMouseDown!.map((Vector2D e){
                          return Vector2D(e.x + translateVector.x, e.y + translateVector.y);
                        }).toList();

                    //endregion

                    List<LineSegment> allPolygonPointToDestinationPointLines =
                        vertexesOfPolyWhenMouseDown!.map((e) => LineSegment(
                            PointEX(e.x, e.y),
                            PointEX(e.x + translateVector.x, e.y + translateVector.y)
                        )).toList();

                    double maxOutBoundLength = -1;

                    for(var i = 0; i < allPolygonPointToDestinationPointLines.length; i++) {
                      for(var j=0;j<lines.length;j++){
                        var crossInfo = getTwoLineSegmentsCrossInfo(
                            allPolygonPointToDestinationPointLines[i], lines[j]);
                        if (crossInfo.isCross) {
                          var outBoundLength = crossInfo.endPointToCrossPointDistance!;
                          if (outBoundLength > maxOutBoundLength) {
                            maxOutBoundLength = outBoundLength;
                          }
                        }
                      }
                    }

                    log = '最长的超出距离: $maxOutBoundLength';

                    if(maxOutBoundLength>1){
                      var rightLength = translateVector.length - maxOutBoundLength;

                      //这里如果不减去一个长度的话 可能会因为精度问题 就超出去了.
                      translateVector.setLength(rightLength -0.5);

                      vertexesOfMovingParallelMouseDirection =
                          vertexesOfPolyWhenMouseDown!.map((Vector2D e){
                            return Vector2D(e.x + translateVector.x, e.y + translateVector.y);
                          }).toList();
                    }





                    //region 做长度限制,通过这种限制以后就可以类似于第二个例子的效果
                    //get finish offset points of polygon
                    // var finishPoints = vertexesOfPolyWhenMouseDown!
                    //     .map((e) => e.translate(translateVector))
                    //     .toList();
                    // //check each point is inside the rect
                    // var isInside = finishPoints.every((element) {
                    //   return element.x >= 0 &&
                    //       element.x <= 300 &&
                    //       element.y >= 0 &&
                    //       element.y <= 300;
                    // });
                    // if (!isInside) {
                    //   translateVector.setLength(50);
                    //   // return;
                    // }
                    //endregion

                    //get cross info
                    // List<LineLineCrossInfo> crossInfos = [];
                    // vertexesOfMovingParallelMouseDirection!.asMap().forEach((index, element) {
                    //   var line = Line(vertexesOfPolyWhenMouseDown![index], element);
                    //   var crossInfo = line.getLineCrossInfo(lines[index]);
                    //   crossInfos.add(crossInfo);
                    // });

                    //check is all cross
                    // var isAllCross = crossInfos.every((element) => element.isCross);
                    // print(isAllCross);

                    nodePosition = nodePositionWhenMouseDown.translate(translateVector);

                    //计算node position 和0 0 的距离
                    var distance = nodePosition.distance(Vector2D(0, 0));
                  });
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Text(log),
                    Align(
                      alignment: Alignment.center,
                      child:
                          CustomPaint(
                            //鼠标移动的线
                        painter: MyPainter(
                            vec, mouseDownPosition, mouseMoveToPosition),
                        size: const Size(300, 300),
                        child: CustomPaint(
                          //鼠标点击位置的红点
                          painter: MyPainter2(mouseDownPosition),
                          size: Size(300, 300),
                          child: CustomPaint(
                            //背景多边形
                            painter: MyPainter3(backgroundPolygon, nodePosition),
                            size: Size(300, 300),
                            child:
                                CustomPaint(
                                  //鼠标点击位置的多边形的顶点
                              painter: MyPainter4(vertexesOfPolyWhenMouseDown),
                              size: Size(300, 300),
                                  child: CustomPaint(
                                    //鼠标移动方向上的多边形的顶点
                                    painter: MyPainter5(vertexesOfPolyWhenMouseDown,vertexesOfMovingParallelMouseDirection),
                                    size: Size(300, 300),
                                    child:CustomPaint(
                                      //鼠标移动方向上的多边形的顶点
                                      painter: LinePainter(
                                          crossTestLine.start,crossTestLine.end
                                      ),
                                      size: Size(300, 300),
                                    )
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: nodePosition.x,
                      top: nodePosition.y,
                      child: ClippedContainer(
                        normalColor: Color.fromARGB(178, 224, 220, 224),
                        hoverColor: Colors.amber,
                        clickColor: Colors.purple,
                        key: const Key("child"),
                        backgroundColor: Color.fromARGB(125, 50, 178, 122),
                        containerSize: const Size(100, 100),
                        backgroundPolygon: backgroundPolygon,
                        isClicked: false,
                        isHover: false,
                        child: const Text("child"),
                      ),
                    ),
                  ],
                ))));
  }
}

