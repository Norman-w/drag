import 'package:drag/widget.dart';
import 'package:flutter/material.dart';

import 'draggable_element.dart';
import 'polygon_helper.dart';

class DraggableContainer extends StatefulWidget {
  const DraggableContainer({Key? key}) : super(key: key);

  @override
  State<DraggableContainer> createState() => _DraggableContainerState();
}

class _DraggableContainerState extends State<DraggableContainer> {
  var _hover = false;
  var _dragging = false;
  //可拖动组件在鼠标按下时候的左上角位置.
  Offset? _childPosWhenMouseDown;
  //鼠标光标在按下时候的位置.
  Offset? _cursorPosWhenMouseDown;

  Offset btnPos = Offset(50, 50);
  var _log = "";

  // isIn(Offset mousePos, )

  @override
  Widget build(BuildContext context) {

    Polygon poly = Polygon(
        [
          Point(5,5),
          Point(10,0),
          Point(10,10),
          Point(20,10),
          Point(20,0),
          Point(40,0),
          Point(30,40),
          Point(0,40),
        ]
    );
    var path = poly.toPath();

    return Container(
      width: 600,
      height: 400,
      constraints: null,
      // decoration: const BoxDecoration(color: Colors.amber),
      child: MouseRegion(
        onHover: (e) {
          setState(() {
            var bound = context.globalPaintBounds;
            Rect rect = Rect.zero;
            if(bound!= null)
              {
                //按钮的世界坐标上的盒子
                rect = Rect.fromLTRB(bound.left+btnPos.dx, bound.top + btnPos.dy
                    , bound.left + btnPos.dx + 40, bound.top + btnPos.dy + 40);
                if(rect.contains(e.position)
                )
                  {

                    // _hover = true;
                    // _log = '在矩形里面哦';


                    //region 在矩形里面,再检测一下点是否在path中.
                    //鼠标在按钮中的相对位置
                    var xOffsetOfBtn = e.position.dx - rect.left;
                    var yOffsetOfBtn = e.position.dy - rect.top;

                    var ret = checkIsPtInPoly(Point(xOffsetOfBtn, yOffsetOfBtn),poly.points);
                    //endregion

                    _log = '在多边形里面吗? $ret';
                    _hover = ret;
                  }
                else
                  {
                    _hover = false;
                    _log = '';
                  }
              }
            // _log = '在大框框移动 ${e.position}';
          });
          // print('hover$e');
        },
        onExit: (e) {
          setState(() {
            // _childPosWhenMouseDown = null;
            // _cursorPosWhenMouseDown = null;
            _hover = false;
            _dragging = false;
            _log = '离开了';
          });
        },
        child: Listener(
          onPointerDown: (e) {
            var bound = context.globalPaintBounds;
            if(_hover && _childPosWhenMouseDown == null && _cursorPosWhenMouseDown == null && bound!= null)
              {
                Rect rect = Rect.zero;
                rect = Rect.fromLTRB(bound.left+btnPos.dx, bound.top + btnPos.dy
                    , bound.left + btnPos.dx + 40, bound.top + btnPos.dy + 40);
                if(rect.contains(e.position)
                )
                {
                  _hover = true;
                  _dragging = true;
                  setState(() {
                    _childPosWhenMouseDown = btnPos;
                    _cursorPosWhenMouseDown = e.position;
                    print('按下按钮时的控件位置:$_childPosWhenMouseDown');
                  });
                }
              }
          },
          //这个move只有在按下时候才会触发.
          onPointerMove: (e) {
            if(_cursorPosWhenMouseDown == null || _childPosWhenMouseDown == null)
              {
                return;
              }
            var containerBound = context.globalPaintBounds;
            //e是给的鼠标光标位置,计算他距离按下的时候走了多远.
            var movedX = e.position.dx - _cursorPosWhenMouseDown!.dx;
            var movedY = e.position.dy - _cursorPosWhenMouseDown!.dy;
            //根据位移量,重新计算可移动组件的新位置.
            var newX = _childPosWhenMouseDown!.dx + movedX;
            var newY = _childPosWhenMouseDown!.dy + movedY;
            //修正新位置,如果超出了的话 就把他归位
            if(newX<0)
              {
                newX  = 0;
              }
            if(containerBound!= null)
              {
                if(newX>containerBound.width-40)
                  {
                    newX = containerBound.width-40;
                  }
              }
            if(newY <0 )
              {
                newY = 0;
              }
            if(containerBound!= null)
              {
                if(newY >containerBound.height-40)
                  {
                    newY = containerBound.height -40;
                  }
              }
            var newBtnPos = Offset(
                newX,
                newY);
            setState(() {
              btnPos = newBtnPos;
            });
          },
          onPointerUp: (e) {
            setState(() {
              _childPosWhenMouseDown = null;
              _cursorPosWhenMouseDown = null;
              _log = '抬起呢';
              _dragging = false;
            });
          },
          child: Stack(
            children: [
              CustomPaint(
                size: const Size(600, 400),
                painter: DraggableContainerPainter(),
              ),
              Text(_log),
              Positioned(
                top: btnPos.dy,
                left: btnPos.dx,
                // child: MouseRegion(
                //   onHover: (e)
                //   {
                //     setState(() {
                //       _hover = true;
                //       _log='悬停了';
                //     });
                //     // print('hover$e');
                //   },
                //   onExit: (e)
                //   {
                //     setState(() {
                //       _hover = false;
                //       _log='离开了';
                //     });
                //   },
                child:
                    // Listener(
                    //   onPointerDown: (e){
                    //     var bound = context.globalPaintBounds;
                    //     setState(() {
                    //       _mouseDownPosition = e.position;
                    //       _log='点下呢,鼠标点$_mouseDownPosition 当前组件的位置:$bound';
                    //     });
                    //
                    //     // var bound = context.globalPaintBounds;
                    //     // var isIn = bound?.contains(e.position);
                    //     // print('点击:$isIn');
                    //   },
                    //   onPointerMove: (e)
                    //   {
                    //     double moveX = 0;
                    //     double moveY = 0;
                    //     if(_mouseDownPosition!= null) {
                    //       moveX = e.position.dx - _mouseDownPosition!.dx;
                    //       moveY = e.position.dy - _mouseDownPosition!.dy;
                    //     }
                    //     else
                    //       {
                    //         setState(() {
                    //           _mouseDownPosition = null;
                    //           _log='移动出问题呢';
                    //         });
                    //         return;
                    //       }
                    //     btnPos = Offset(moveX, moveY);
                    //   },
                    //   onPointerUp: (e)
                    //   {
                    //     setState(() {
                    //       _mouseDownPosition = null;
                    //       _log='抬起呢';
                    //     });
                    //   },
                    //   child:
                    Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      color:
                      _dragging? Colors.purple:
                      _hover ? Colors.deepOrange : Colors.cyan),
                      child:
                      ClipPath(
                        clipper: MyPathClipper(path),
                        child:
                      Container(
                        child: Container(width: 40,height: 40, color: Colors.black38,),
                      ),
                      ),
                ),
                // ),
                // )
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DraggableContainerPainter extends CustomPainter {
  final _paint = Paint()
    ..color = Colors.lightGreen
    ..strokeWidth = 1;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Rect.fromLTRB(0, 0, size.width, size.height), _paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}



class MyPathClipper extends CustomClipper<Path> {
  final Path path;
  MyPathClipper(this.path);
  @override
  Path getClip(Size size) {
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}