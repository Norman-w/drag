import 'dart:math';

import '../points/point_ex.dart';
import '../../utils.dart';
import 'ray.dart';
import 'straight_line.dart';
import '../vectors/vector2d.dart';


var ESP = 1e-5;


class LineSegment{
  PointEX start;
  PointEX end;
  LineSegment(this.start, this.end);
  Vector2D getVector(){
    return Vector2D(end.x - start.x, end.y - start.y);
  }
  double getAngle(){
    return getVector().getAngle();
  }
  double getStartPointToDistance(PointEX point){
    var vector1 = getVector();
    var vector2 = point - start;
    var cross = vector1.x * vector2.y - vector1.y * vector2.x;
    return cross.abs() / vector1.distance(Vector2D(0, 0));
  }
  double getEndPointToDistance(PointEX point){
    var vector1 = getVector();
    var vector2 = point - end;
    var cross = vector1.x * vector2.y - vector1.y * vector2.x;
    return cross.abs() / vector1.distance(Vector2D(0, 0));
  }

  get length{
    return getVector().distance(Vector2D(0, 0));
  }
  bool isCrossToStraightLine(StraightLine straightLine){
    var vector1 = straightLine.getVector();
    var vector2 = getVector();
    var vector3 = start - straightLine.point1;
    var cross1 = vector1.x * vector2.y - vector1.y * vector2.x;
    var cross2 = vector1.x * vector3.y - vector1.y * vector3.x;
    if(cross1 == 0){
      return false;
    }
    var r = cross2 / cross1;
    if(r < 0 || r > 1){
      return false;
    }
    return true;
  }
  bool isCrossToRaysLine(Ray raysLine){
    var vector1 = raysLine.getVector();
    var vector2 = getVector();
    var vector3 = start - raysLine.start;
    var cross1 = vector1.x * vector2.y - vector1.y * vector2.x;
    var cross2 = vector1.x * vector3.y - vector1.y * vector3.x;
    if(cross1 == 0){
      return false;
    }
    var r = cross2 / cross1;
    if(r < 0){
      return false;
    }
    return true;
  }
  bool isCrossToLineSegment(LineSegment lineSegment){
    var vector1 = lineSegment.getVector();
    var vector2 = getVector();
    var vector3 = start - lineSegment.start;
    var cross1 = vector1.x * vector2.y - vector1.y * vector2.x;
    var cross2 = vector1.x * vector3.y - vector1.y * vector3.x;
    if(cross1 == 0){
      return false;
    }
    var r = cross2 / cross1;
    if(r < 0 || r > 1){
      return false;
    }
    vector1 = getVector();
    vector2 = lineSegment.getVector();
    vector3 = lineSegment.start - start;
    cross1 = vector1.x * vector2.y - vector1.y * vector2.x;
    cross2 = vector1.x * vector3.y - vector1.y * vector3.x;
    if(cross1 == 0){
      return false;
    }
    r = cross2 / cross1;
    if(r < 0 || r > 1){
      return false;
    }
    return true;
  }
}


extension LineSegmentMethods on LineSegment{
  // 判断线段是否包含点point
  bool  isOnLine(PointEX point, LineSegment line)
  {
    return( ( fabs(pointMultiply(line.start, line.end, point)) < ESP ) &&
        ( ( point.x - line.start.x ) * ( point.x - line.end.x ) <= 0 ) &&
        ( ( point.y - line.start.y ) * ( point.y - line.end.y ) <= 0 ) );
  }
  // 判断线段相交 老方法
  bool intersect(LineSegment L1, LineSegment L2)
  {
    return( (max(L1.start.x, L1.end.x) >= min(L2.start.x, L2.end.x)) &&
        (max(L2.start.x, L2.end.x) >= min(L1.start.x, L1.end.x)) &&
        (max(L1.start.y, L1.end.y) >= min(L2.start.y, L2.end.y)) &&
        (max(L2.start.y, L2.end.y) >= min(L1.start.y, L1.end.y)) &&
        (pointMultiply(L2.start, L1.end, L1.start) * pointMultiply(L1.end, L2.end, L1.start) >= 0) &&
        (pointMultiply(L1.start, L2.end, L2.start) * pointMultiply(L2.end, L1.end, L2.start) >= 0)
    );
  }
}
