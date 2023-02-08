import 'dart:math';

import 'package:drag/widget.dart';
import 'package:flutter/material.dart';

import '../clipped_container.dart';
import '../geometry/lines/cross_info.dart';
import '../geometry/lines/line_segment.dart';
import '../geometry/points/point_ex.dart';
import '../geometry/planes/polygon.dart';
import '../geometry/vectors/vector2d.dart';
import '../test4/custom_painters.dart';

class Test5 extends StatefulWidget {
  const Test5({super.key});

  @override
  createState() => _Test5State();
}

class _Test5State extends State<Test5> {
  Offset? mouseDownPosition;
  Offset? mouseMoveToPosition;

  Vector2D nodePosition = Vector2D(80, 80);
  Vector2D nodePositionWhenMouseDown = Vector2D(0, 0);
  var log = '';

  var parentWidgetBackgroundPolygon = Polygon([
    PointEX(50, 50),
    PointEX(270, 20),
    PointEX(240, 140),
    PointEX(280, 280),
    PointEX(15, 240),
  ]);
  var childWidgetBackgroundPolygon = Polygon([
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
        color: Color.fromARGB(255, 185, 188, 92),
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
                    vertexesOfPolyWhenMouseDown = childWidgetBackgroundPolygon.points
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
                    //鼠标目标位置
                    mouseMoveToPosition = event.localPosition;
                    //鼠标的偏移量
                    var mouseOffset = mouseMoveToPosition! - mouseDownPosition!;
                    //鼠标移动方向上的向量
                    var translateVector = Vector2D(
                        mouseOffset.dx, mouseOffset.dy);

                    //region 计算每个起始顶点和鼠标移动方向上的顶点
                    vertexesOfMovingParallelMouseDirection =
                        vertexesOfPolyWhenMouseDown!.map((Vector2D e){
                          return Vector2D(e.x + translateVector.x, e.y + translateVector.y);
                        }).toList();

                    //endregion

                    //region 计算每个顶点和鼠标移动方向上的顶点的线段
                    List<LineSegment> allPolygonPointToDestinationPointLines =
                        vertexesOfPolyWhenMouseDown!.map((e) => LineSegment(
                            PointEX(e.x, e.y),
                            PointEX(e.x + translateVector.x, e.y + translateVector.y)
                        )).toList();
                    //endregion

                    //超出边界的最长距离
                    double maxOutBoundLength = -1;

                    //region 计算每个顶点的目标点超出边界的最长距离
                    var lines = parentWidgetBackgroundPolygon.getLineSegments();
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
                    //endregion

                    log = '最长的超出距离: $maxOutBoundLength';

                    //region 如果有超出的点 重设每个点将要移动的向量的长度
                    if(maxOutBoundLength>0){
                      var rightLength = translateVector.length - maxOutBoundLength;

                      //这里如果不减去一个长度的话 可能会因为精度问题 就超出去了.
                      translateVector.setLength(rightLength -0.5);

                      vertexesOfMovingParallelMouseDirection =
                          vertexesOfPolyWhenMouseDown!.map((Vector2D e){
                            return Vector2D(e.x + translateVector.x, e.y + translateVector.y);
                          }).toList();
                    }
                    //endregion

                    //使用修正过的向量移动拖动的组件
                    nodePosition = nodePositionWhenMouseDown.translate(translateVector);
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
                            painter: MyPainter3(childWidgetBackgroundPolygon, nodePosition),
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
                        backgroundPolygon: childWidgetBackgroundPolygon,
                        isClicked: false,
                        isHover: false,
                        child: const Text("child"),
                      ),
                    ),
                    Align(
                      child:ClippedContainer(
                        normalColor: Color.fromARGB(178, 224, 220, 224),
                        hoverColor: Colors.amber,
                        clickColor: Colors.purple,
                        key: const Key("parent"),
                        backgroundColor: Color.fromARGB(30, 50, 178, 122),
                        containerSize: const Size(300, 300),
                        backgroundPolygon: parentWidgetBackgroundPolygon,
                        isClicked: false,
                        isHover: false,
                        child: const Text("parent"),
                      ),
                    ),
                  ],
                ))));
  }
}

