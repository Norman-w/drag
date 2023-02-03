// import 'package:drag/widget.dart';
// import 'package:flutter/material.dart';
// import 'dart:math' as math;
//
// import 'path_clipper.dart';
// import 'point_ex.dart';
// import 'polygon_helper.dart';
// import 'polygonal.dart';
// import 'equilateral_polygon.dart';
//
// class PolyDraggableContainer extends StatefulWidget {
//   const PolyDraggableContainer({Key? key}) : super(key: key);
//
//   @override
//   State<PolyDraggableContainer> createState() => _PolyDraggableContainerState();
// }
//
// class _PolyDraggableContainerState extends State<PolyDraggableContainer> {
//   var _hover = false;
//   late Polygon backgroundPolygon;
//   late Polygon innerPolygon;
//   // var polygonalPath = EquilateralPolygonPath(size: 170,count: 40);
//   late Offset backRectOffsetOfParent;
//   late Offset clipOffsetOfContainer;
//   late Size containerSize;
//   late Size moveAbleBtnSize;
//
//   //外面圆形和里面圆形的大小和边数分别是多少.
//   double backgroundPolygonSize = 170;
//   int backgroundPolygonSideCount = 40;
//   double innerPolygonSize = 30;
//   int innerPolygonSideCount = 20;
//   //使用系统自带的Path做出来的圆,但是获取不到路径
//   // var backCirclePath = Path();
//   // var poly = Polygon(backCirclePath.getBounds());
//
//   @override
//   void initState() {
//     backgroundPolygon = Polygon.fromEquilateralPolygonPath(
//     EquilateralPolygonPath(size: backgroundPolygonSize,count: backgroundPolygonSideCount)
//     );
//     innerPolygon = Polygon.fromEquilateralPolygonPath(
//         EquilateralPolygonPath(size: innerPolygonSize, count:innerPolygonSideCount)
//     );
//     backRectOffsetOfParent = const Offset(135,0);
//     clipOffsetOfContainer = const Offset(50,12);
//     containerSize = const Size(450,200);
//     moveAbleBtnSize = Size(innerPolygonSize,innerPolygonSize);
//     backgroundPolygon.offset(clipOffsetOfContainer.dx,clipOffsetOfContainer.dy);
//     super.initState();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Transform.translate(offset: backRectOffsetOfParent,child:
//         MouseRegion(
//           onEnter: (e)
//           {
//             // setState(() {
//             //   _hover = true;
//             // });
//           },
//           onExit: (e){
//             setState(() {
//               _hover = false;
//             });
//           },
//           onHover: (e){
//             var bound = context.globalPaintBounds;
//             var offset = PointEX(e.position.dx - bound!.left-this.backRectOffsetOfParent.dx, e.position.dy - bound.top-this.backRectOffsetOfParent.dy);
//             setState(() {
//               var polyCirclePoints = backgroundPolygon.points.map((e) => PointEX(e.x,e.y)).toList();
//               // print('位移量: $offset');
//               var inPolyCircle = backgroundPolygon.isPointIn(offset);
//               _hover = inPolyCircle;
//             });
//           },
//           //包含真正的裁剪过的背景的框框
//           child: Container(
//             width: containerSize.width,
//             height: containerSize.height,
//             color: Colors.grey,
//             //框框里面的裁剪以后的背景
//             child: ClipPath(
//               clipper: PathClipper(backgroundPolygon.getPath()),
//               child:
//                   //背景里面的背景色
//               Container(width: containerSize.width,height: containerSize.height, color: _hover? Colors.red: Colors.orange,
//                 child:
//                     //这个位移是基于外部大容器的,也就是当前的context,并不是当前的
//                     Transform.translate(
//                       child:
//                   // Center(child:
//                       ClipPath(
//                         clipper: PathClipper(innerPolygon.getPath()),
//                         child: Container(
//                             width: 40,
//                             height: 40,
//                             color: _hover?
//                             Colors.lightGreenAccent: Colors.deepPurple
//                         ),
//                       ), offset: clipOffsetOfContainer +
//                         Offset(
//                             backgroundPolygonSize/2-moveAbleBtnSize.width/2,
//                             backgroundPolygonSize/2-moveAbleBtnSize.width/2,),
//                     ),
//                   // ),
//               ),
//               // Polygonal(
//               //   size: 100,
//               //   bigR: 50,
//               //   count: 11,
//               //   type: Type.side,
//               // ),
//             ),
//           ),
//         )
//     );
//   }
// }
//
