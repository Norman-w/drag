import 'package:drag/widget.dart';
import 'package:flutter/material.dart';

import 'clipped_container.dart';
import 'logMonitor/index.dart';
import 'geometry/points/point_ex.dart';
import 'geometry/planes/polygon.dart';

class PolyDraggableContainer extends StatefulWidget {
  PolyDraggableContainer({
    Key? key,
  }) : super(key: key);

  @override
  _PolyDraggableContainerState createState() => _PolyDraggableContainerState();
}

class _PolyDraggableContainerState extends State<PolyDraggableContainer> {
  Size parentContainerSize = Size(300, 300);
  Size childContainerSize = Size(60, 60);
  Offset childOffset = const Offset(60, 90);

  Offset? mousePosWhenMouseDown;
  Offset? childPosWhenMouseDown;

  Polygon parentPolygon = Polygon([
    PointEX(30, 15),
    PointEX(240, 30),
    PointEX(300, 120),
    PointEX(180, 300),
    PointEX(0, 270),
  ]);

  var childPolygon = Polygon([
  PointEX(0, 0),
  PointEX(30, 0),
  PointEX(60, 60),
  PointEX(0, 60),
  ]
  );

  bool _hoverParent = false;
  bool _clickParent = false;
  bool _hoverChild = false;
  bool _clickChild = false;

  //region 鼠标事件
  onMouseEnterParentRect(e) {
    // console.log('鼠标进入父组件');
  }

  //这个方法在鼠标点下去的时候并不会执行.
  onMouseMovingInParentRect(e, bound) {
    var mouseInParentBound = bound == null
        ? Offset(0, 0)
        : Offset(e.position.dx - bound.left, e.position.dy - bound.top);
    var isInParentPolygon =
        parentPolygon.isPointXYIn(mouseInParentBound.dx, mouseInParentBound.dy);

    bool isInChildRect = false;
    bool isInChildPolygon = false;
    if(isInParentPolygon){
      //检查是否也在子组件的rect中
      var mouseInChildBound = Offset(mouseInParentBound.dx - childOffset.dx, mouseInParentBound.dy - childOffset.dy);
      var childBound = Rect.fromLTWH(0, 0, childContainerSize.width, childContainerSize.height);
      if(childBound.contains(mouseInChildBound)){
        isInChildRect = true;
        if(childPolygon.isPointXYIn(mouseInChildBound.dx, mouseInChildBound.dy)){
          isInChildPolygon = true;
        }
      }
    }
    if(_hoverParent != isInParentPolygon){
      setState(() {
        _hoverParent = isInParentPolygon;
      });
    }
    if(_hoverChild != isInChildPolygon){
      setState(() {
        _hoverChild = isInChildPolygon;
      });
    }
  }

  //这个方法只有在鼠标点下去以后才执行.
  onMouseDragInParentRect(e, bound) {
    if(!_clickChild){
      return;
    }
    if(childPosWhenMouseDown != null && mousePosWhenMouseDown != null){
      Offset mouseOffset = e.position - mousePosWhenMouseDown!;
      Offset newChildOffset = childPosWhenMouseDown! + mouseOffset;

      Polygon newChildPolygon = Polygon(
        childPolygon.points.map((e) => PointEX(e.x + newChildOffset.dx, e.y + newChildOffset.dy)).toList()
      );

      if(!parentPolygon.isContains(newChildPolygon)){
        return;
      }
      // var firstPointGlobal = Offset(firstPoint.x + newChildOffset.dx, firstPoint.y + newChildOffset.dy);
      // console.log('firstPointGlobal: $firstPointGlobal');
      //
      // if(parentPolygon.isPointXYIn(firstPointGlobal.dx, firstPointGlobal.dy)){
      //   console.log('在父组件内');}

      // var newChildPolygon = childPolygon.offset(mouseOffset.dx, mouseOffset.dy);
      setState(() {
        childOffset = newChildOffset;
      });
      // console.log('鼠标在父组件中移动, childOffset: $childOffset');
      return;
    }
  }

  onMouseExitParent(e) {
    setState(() {
      _hoverParent = false;
      _clickParent = false;
    });
  }

  onMouseDownParent(e) {
    if  (_hoverChild) {
      setState(() {
        childPosWhenMouseDown = childOffset;
        mousePosWhenMouseDown = e.position;
        // console.log('$childOffset');
        _clickChild = true;
      });
      return;
    }
    if (_hoverParent) {
      setState(() {
        _clickParent = true;
      });
    }
    //在多边形外部但是是在该组件的区域内按下的.mouse region本身就是捕获到的是整个组件的.
  }

  onMouseUpParent(e) {
    if  (_hoverChild) {
      setState(() {
        childPosWhenMouseDown = null;
        mousePosWhenMouseDown = null;
        _clickChild = false;
      });
      return;
    }
    if (_hoverParent && _clickParent) {
      setState(() {
        _clickParent = false;
      });
    }
  }

  //endregion

  @override
  Widget build(BuildContext context) {
    var bound = context.globalPaintBounds;
    return MouseRegion(
      onHover: (e) {
        onMouseMovingInParentRect(e, bound);
      },
      onEnter: onMouseEnterParentRect,
      onExit: onMouseExitParent,
      child: Listener(
        onPointerDown: onMouseDownParent,
        onPointerUp: onMouseUpParent,
        onPointerMove: (e) {
          onMouseDragInParentRect(e, bound);
        },
        child: ClippedContainer(
          key: const Key("parent"),
          backgroundColor: Colors.grey,
          hoverColor: Colors.white,
          containerSize: parentContainerSize,
          backgroundPolygon: parentPolygon,
          isClicked: _clickParent,
          isHover: _hoverParent,
          child: Positioned(
            left: childOffset.dx,
            top: childOffset.dy,
            child: ClippedContainer(
              normalColor: Colors.red,
              hoverColor: Colors.amber,
              clickColor: Colors.purple,
              key: const Key("child"),
              backgroundColor: Colors.blue,
              containerSize: childContainerSize,
              backgroundPolygon: childPolygon,
              isClicked: _clickChild,
              isHover: _hoverChild,
              child: const Text("child"),
            ),
          ),
        ),
      ),
    );
  }
}
