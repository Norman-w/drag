import 'package:drag/widget.dart';
import 'package:flutter/material.dart';

class DraggableElement extends StatefulWidget {
  const DraggableElement({Key? key}) : super(key: key);

  @override
  State<DraggableElement> createState() => _DraggableElementState();
}

class _DraggableElementState extends State<DraggableElement> {
  var _hover  = false;
  Offset? _mouseDownPosition;
  @override
  Widget build(BuildContext context) {
    return
    MouseRegion(
      onEnter: (e){
        setState(() {
          _hover = true;
        });
      },
      onExit: (e){
        setState(() {
          _hover = false;
        });
      },
      child:
      Listener(
        onPointerDown: (e){
          _mouseDownPosition = e.position;
          // var bound = context.globalPaintBounds;
          // var isIn = bound?.contains(e.position);
          // print('点击:$isIn');
        },
        onPointerMove: (e)
        {

        },
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 50,maxHeight: 50),
          child: Container(
            decoration: BoxDecoration(color: _hover?Colors.deepOrange: Colors.cyan),
          ),
        ),
      ),
    );
  }
}
