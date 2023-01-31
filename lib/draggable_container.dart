import 'package:drag/widget.dart';
import 'package:flutter/material.dart';

import 'draggable_element.dart';

class DraggableContainer extends StatefulWidget {
  const DraggableContainer({Key? key}) : super(key: key);

  @override
  State<DraggableContainer> createState() => _DraggableContainerState();
}

class _DraggableContainerState extends State<DraggableContainer> {
  var _hover = false;
  Offset? _mouseDownPosition;

  Offset btnPos = Offset(50, 50);
  var _log = "";

  // isIn(Offset mousePos, )

  @override
  Widget build(BuildContext context) {
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
                rect = Rect.fromLTRB(bound.left+btnPos.dx, bound.top + btnPos.dy
                    , bound.left + btnPos.dx + 40, bound.top + btnPos.dy + 40);
                if(rect.contains(e.position)
                )
                  {
                    _hover = true;
                    _log = '在里面哦';
                  }
                else
                  {
                    _hover = false;
                  }
              }
            _log = '在大框框移动 ${e.position}';
          });
          // print('hover$e');
        },
        onExit: (e) {
          setState(() {
            _hover = false;
            _log = '离开了';
          });
        },
        child: Listener(
          onPointerDown: (e) {
            var bound = context.globalPaintBounds;
            setState(() {
              _mouseDownPosition = e.position;
              _log = '点下呢,鼠标点$_mouseDownPosition 当前组件的位置:$bound';
            });

            // var bound = context.globalPaintBounds;
            // var isIn = bound?.contains(e.position);
            // print('点击:$isIn');
          },
          onPointerMove: (e) {
            double moveX = 0;
            double moveY = 0;
            if (_mouseDownPosition != null) {
              moveX = e.position.dx - _mouseDownPosition!.dx;
              moveY = e.position.dy - _mouseDownPosition!.dy;
            } else {
              setState(() {
                _mouseDownPosition = null;
                _log = '移动出问题呢';
              });
              return;
            }
            btnPos = Offset(moveX, moveY);
          },
          onPointerUp: (e) {
            setState(() {
              _mouseDownPosition = null;
              _log = '抬起呢';
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
                      color: _hover ? Colors.deepOrange : Colors.cyan),
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
