import 'dart:math';

import 'point_ex.dart';



double fabs(double value) {
  if(value.isInfinite || value.isInfinite) {return value;}
  return value <0? 0-value: value;
}

var INFINITY = double.infinity;
var ESP = 1e-5;


class LineSegment {
  late PointEX pt1 = PointEX(0, 0);
  late PointEX pt2 = PointEX(0, 0);
}

extension LineSegmentMethods on LineSegment{
  // 判断线段是否包含点point
  bool  IsOnline(PointEX point, LineSegment line)
  {
    return( ( fabs(pointMultiply(line.pt1, line.pt2, point)) < ESP ) &&
        ( ( point.x - line.pt1.x ) * ( point.x - line.pt2.x ) <= 0 ) &&
        ( ( point.y - line.pt1.y ) * ( point.y - line.pt2.y ) <= 0 ) );
  }
  // 判断线段相交
  bool Intersect(LineSegment L1, LineSegment L2)
  {
    return( (max(L1.pt1.x, L1.pt2.x) >= min(L2.pt1.x, L2.pt2.x)) &&
        (max(L2.pt1.x, L2.pt2.x) >= min(L1.pt1.x, L1.pt2.x)) &&
        (max(L1.pt1.y, L1.pt2.y) >= min(L2.pt1.y, L2.pt2.y)) &&
        (max(L2.pt1.y, L2.pt2.y) >= min(L1.pt1.y, L1.pt2.y)) &&
        (pointMultiply(L2.pt1, L1.pt2, L1.pt1) * pointMultiply(L1.pt2, L2.pt2, L1.pt1) >= 0) &&
        (pointMultiply(L1.pt1, L2.pt2, L2.pt1) * pointMultiply(L2.pt2, L1.pt2, L2.pt1) >= 0)
    );
  }
}