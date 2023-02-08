import '../../point_ex.dart';
import 'ray.dart';
import 'straight_line.dart';
import '../vector2d.dart';




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

