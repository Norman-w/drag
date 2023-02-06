import 'package:drag/widget.dart';
import 'package:flutter/material.dart';

import 'path_clipper.dart';
import 'polygon.dart';
import 'polygon_helper.dart';
import 'webSocket/index.dart';

class ClippedContainer extends StatefulWidget {
  final Size containerSize;
  final Polygon backgroundPolygon;
  final Color backgroundColor;
  final Color hoverColor;
  final Color normalColor;
  final Color clickColor;
  final Widget child;
  final bool? ignoreEvent;
  final VoidCallback? onClickInsidePolygon;
  final Function? onHoverChange;

  const ClippedContainer({
    Key? key,
    this.ignoreEvent,
    required this.containerSize,
    required this.backgroundPolygon,
    required this.child,
    this.hoverColor = Colors.red,
    this.normalColor = Colors.orange,
    this.clickColor = Colors.green,
    this.backgroundColor = Colors.grey, this.onClickInsidePolygon, this.onHoverChange,
  }) : super(key: key);

  @override
  State<ClippedContainer> createState() => _ClippedContainerState();
}

//create state class for ClippedContainer with MouseRegion
class _ClippedContainerState extends State<ClippedContainer> {
  //region 不会变的变量
  late Polygon backgroundPolygon;
  late Color clippedPolygonBackgroundColor;
  late Size containerSize = widget.containerSize;
  late Rect? bound;
  late Path backgroundPolygonPath;
  //endregion

  //region 会变的变量
  var _hover = false;
  var _click = false;
  var ws = WebSocketClient(
      'ws://127.0.0.1:8000'
  );
  //endregion

  //region  初始化状态
  @override
  void initState() {
    super.initState();
    backgroundPolygon = widget.backgroundPolygon;
    clippedPolygonBackgroundColor = getCurrentColor();
    backgroundPolygonPath = backgroundPolygon.toPath();
  }
  //endregion

  //region 鼠标事件
  onMouseEnterRect(e) {
    // onEnter: (e) {
    //   //后期可以加入一个东西:
    //   //如果裁剪的矩形边缘有很多空的地方,那么在进入以后做一个标记 是鼠标进入.
    //   //只有鼠标进入了以后 才对onHover 进行一个检测. 当时这个可能也不会特别影响性能.
    // },
  }
  onMouseMovingInRect(e,bound) {
    if (widget.ignoreEvent == true) {
      print('检测到不需要处理事件');
      return;
    }
    var mouseInBound = bound == null ? Offset(0, 0)
        : Offset(e.position.dx - bound.left, e.position.dy - bound.top);
    var isInPolygon = backgroundPolygon.isPointXYIn(
        mouseInBound.dx, mouseInBound.dy);

    //region 当现在的状态跟之前的一样的时候就不需要setState触发build了 这句很重要.避免频繁build的问题
    if(_hover ==isInPolygon)
    {
      return;
    }
    //endregion

    setState(() {
      _hover = isInPolygon;
      if (widget.onHoverChange != null) {
        widget.onHoverChange!(isInPolygon);
      }
    });
  }
  onMouseExit(e)
  {
    setState(() {
      print('鼠标离开 ${widget.key}}');
      _hover = false;
      //离开组件的时候肯定离开区域,不hover了
      if(widget.onHoverChange != null){
        widget.onHoverChange!(false);
      }
    });
  }
  onMouseDown(e){
    if(widget.ignoreEvent == true) {
      print('在组件${widget.key}检测到不需要处理事件');
      return;
    }
     if(_hover){
       //在区域里面并且按下了
        if(widget.onClickInsidePolygon != null){
          widget.onClickInsidePolygon!();
        }
     }
      setState(() {
        _click = true;
      });
  }
  onMouseUp(e) {
    setState(() {
    _click = false;
    });
  }
  //endregion

  //region 获取当前颜色
  Color getCurrentColor(){
    return _click ? widget.clickColor : (_hover ? widget.hoverColor
        : widget.normalColor);
  }
  //endregion

  @override
  Widget build(BuildContext context) {
    //region 每次build的时候都要重新计算一下 外围的矩形 和颜色
    print('build on ${widget.key}');
    bound = context.globalPaintBounds;


    var message = '组件build ${widget.key}';
    ws.sendMessage(message);

    clippedPolygonBackgroundColor = getCurrentColor();
    //endregion

    //region 输出组件的key
    // if(widget.key.toString() == '[<\'child\'>]'){
    //   print('------子组件构建------');
    // }
    // else{
    //   print('------父组件构建------');
    // }
    //endregion

    return MouseRegion(
      onHover: (e) {
        onMouseMovingInRect(e,bound);
      },
      onEnter: onMouseEnterRect,
      onExit: onMouseExit,
      child:
      Listener(
        onPointerDown: onMouseDown,
        onPointerUp: onMouseUp,
        child:
        Container(
          key: widget.key,
          width: containerSize.width,
          height: containerSize.height,
          color: widget.backgroundColor,
          //框框里面的裁剪以后的背景
          child: ClipPath(
            clipper: PathClipper(backgroundPolygonPath),
            child:
            //背景里面的背景色
            Container(width: containerSize.width,
              height: containerSize.height,
              color: clippedPolygonBackgroundColor,
              child:
              Stack(
                  children: [
                    widget.child,
                  ]
              ),

            ),
          ),
        ),
      ),
    );
  }
}