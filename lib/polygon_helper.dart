/**
 * 多边形的帮助类.用于检测多边形之间的关系:
 * A包含B
 * A被B包含
 * A和B相等
 * A和B相交
 * A切于B(只有一个点和B的一条线相交)
 * A被B切(B只有一个点和A相交)
 * A挂于B(A的短边和B的长边重叠)
 * A挂B(A的长边下挂有短的B边)
 * A和B共边(A有一个边和B的边一样)
 * A和B形似(所有相邻线的比例序列相同)
 */


import 'dart:ui';
import 'dart:math';

///两个图形之间的包含关系.
enum InclusionEnum
{
  ///未知
  unknown,
  ///包含后者
  contains,
  ///在后者之中
  inside,
  ///相同
  equal,
  ///相交
  cross,
  ///形似(目前是没有旋转的情况下)
  similar,
  ///相离,就是没有接触
  disjoint,
}
///两个图形之间的相接关系,不包含交叉的情况.交叉可以根据InclusionEnum=cross来判断,然后可以返回交叉的边数
enum TouchEnum
{
  ///未知
  unknown,
  ///点和点相交
  point2point,
  ///前者的边和后者的点相交,也就是 后切于前
  point2side,
  ///前者的点和后者的边相交,也就是 前切于后
  side2point,
  ///两者的边有重叠的地方,并且前者包含后者的边
  sideContainsSide,
  ///两者的边有重叠的地方,并且前者在后者中
  sideInsideSide,
  ///两者的边有重叠的地方,并且前者和后者的边相同,也就是共边
  shareSide,
}

///两个多边形之间的关系
class Relative
{
  late InclusionEnum inclusion = InclusionEnum.unknown;
  late TouchEnum touch = TouchEnum.unknown;

  @override
  String toString() {
    var msg = "";
    switch(inclusion)
    {
      case InclusionEnum.unknown:
        return "未知包含关系";
        break;
      case InclusionEnum.contains:
        msg+= '前者包含后者';
        break;
      case InclusionEnum.inside:
        msg+= '前者在后者中';
        break;
      case InclusionEnum.equal:
        msg+= '相等';
        break;
      case InclusionEnum.cross:
        msg+= '两个多边形相交';
        break;
      case InclusionEnum.similar:
        msg+= '两者形状相似';
        break;
      case InclusionEnum.disjoint:
        msg+= '两者没有交集';
        break;
    }

    switch(touch){
      case TouchEnum.unknown:
        msg+= '';
        break;
      case TouchEnum.point2point:
        msg+= '\r\n点和点相接';
        break;
      case TouchEnum.point2side:
        msg+= '\r\n前者的点接到后者的边上';
        break;
      case TouchEnum.side2point:
        msg+= '\r\n前者的边接到后者的点上';
        break;
      case TouchEnum.sideContainsSide:
        msg+= '\r\n前者的边包含后者的边';
        break;
      case TouchEnum.sideInsideSide:
        msg+= '\r\n前者的边在后者的边内';
        break;
      case TouchEnum.shareSide:
        msg+= '\r\n两者有相同的边';
        break;
    }
    msg += '\r\n';
    return msg;
  }
}

class Polygon{
  Polygon(this.points);
  List<Point> points;
  bool containsPoint(Point point){
    for(var p in points){
      if(point.x == p.x && point.y == p.y) {
        return true;
      }
    }
    return false;
  }
}

extension PathRelativeWith on Polygon
{
  Relative getRelativeWith(Polygon other)
  {
    Relative ret = Relative();
    //region 判断是否相等
    var allPointSame = true;
    //如果点数相等
    if(points.length == other.points.length){
      //如果所有点都相等,那就是相同
      for(var selfPoint in points){
        if(other.containsPoint(selfPoint) == false) {
          allPointSame = false;
        }
      }
      //如果不是所有的点都相等,那可能只是边一样而已.
    }
    //如果所有点都相同那就是相等.
    if(allPointSame) {
      ret.inclusion = InclusionEnum.equal;
    }
    //否则就有很多种情况了.
    else {
      var inside = true;
      // var selfPath = getPath();
      for(var selfPoint in points)
        {
          var selfPointIsInOtherPoly = checkIsPtInPoly(selfPoint, other.points);
          if(selfPointIsInOtherPoly == false)
            {
              inside = false;
            }
        }
      if(inside) {
        ret.inclusion = InclusionEnum.inside;
        return ret;
      }
      var contains = true;
      for(var otherPoint in other.points){
        var c = checkIsPtInPoly(otherPoint, points);
        if(!c){contains = false;}
      }
      if(contains) {
        ret.inclusion = InclusionEnum.contains;
        return ret;
      }
    }
    //endregion
    return ret;
  }

  Path toPath(){
    Path path = Path();
    path.addPolygon(points.map((e) => Offset(e.x,e.y)).toList(), true);
    return path;
  }
}



class LineSegment {
late Point pt1 = Point(0, 0);
late Point pt2 = Point(0, 0);
}
class Point {
  Point(this.x,this.y);
  late double x;
  late double y;
  bool equals(other){
    return other.x == x && other.y == y;
  }
}
double fabs(double value) {
  if(value.isInfinite || value.isInfinite) {return value;}
  return value <0? 0-value: value;
}
var INFINITY = double.infinity;
var ESP = 1e-5;
// 计算叉乘 |P0P1| × |P0P2|
double Multiply(Point p1, Point p2, Point p0)
{
  return ( (p1.x - p0.x) * (p2.y - p0.y) - (p2.x - p0.x) * (p1.y - p0.y) );
}
// 判断线段是否包含点point
bool  IsOnline(Point point, LineSegment line)
{
  return( ( fabs(Multiply(line.pt1, line.pt2, point)) < ESP ) &&
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
      (Multiply(L2.pt1, L1.pt2, L1.pt1) * Multiply(L1.pt2, L2.pt2, L1.pt1) >= 0) &&
      (Multiply(L1.pt1, L2.pt2, L2.pt1) * Multiply(L2.pt2, L1.pt2, L2.pt1) >= 0)
  );
}
// 判断点在多边形内
bool InPolygon(Polygon polygon, Point point) {
  int n = polygon.points.length;
  int count = 0;
  var line = LineSegment();
  line.pt1 = point;
  line.pt2.y = point.y;
  line.pt2.x = -INFINITY;
  for (int i = 0; i < n; i++) {
    // 得到多边形的一条边
    var side = LineSegment();
    side.pt1 = polygon.points[i];
    side.pt2 = polygon.points[(i + 1) % n];
    if (IsOnline(point, side)) {
      return true;
    }
    // 如果side平行x轴则不作考虑
    if (fabs(side.pt1.y - side.pt2.y) < ESP) {
      continue;
    }
    if (IsOnline(side.pt1, line)) {
      if (side.pt1.y > side.pt2.y) count++;
    } else if (IsOnline(side.pt2, line)) {
      if (side.pt2.y > side.pt1.y) count++;
    } else if (Intersect(line, side)) {
      count++;
    }
  }
  if (count % 2 == 1) {
    return false;
  }
  else {
    return true;
  }
}

bool checkIsInPolygon(Polygon polygon,Point point){
  return checkIsPtInPoly(point, polygon.points);
}

bool checkIsPtInPoly(Point point, List<Point> pts) {
  int N = pts.length;
  //如果点位于多边形的顶点或边上，也算做点在多边形内，直接返回true
  bool boundOrVertex = true;
  //cross points count of x
  int intersectCount = 0;
  //浮点类型计算时候与0比较时候的容差
  double precision = 2e-10;
  //neighbour bound vertices
  Point p1, p2;
  //当前点
  Point p = point;
  //left vertex
  p1 = pts[0];
  //check all rays
  for (int i = 1; i <= N; ++i) {
    if (p.equals(p1)) {
      //p is an vertex
      return boundOrVertex;
    }
    //right vertex
    p2 = pts[i % N];
    //ray is outside of our interests
    if (p.x < min(p1.x, p2.x) || p.x > max(p1.x, p2.x)) {
      p1 = p2;
      //next ray left point
      continue;
    }
    //ray is crossing over by the algorithm (common part of)
    if (p.x > min(p1.x, p2.x) && p.x < max(p1.x, p2.x)) {
      //x is before of ray
      if (p.y <= max(p1.y, p2.y)) {
        //overlies on a horizontal ray
        if (p1.x == p2.x && p.y >= min(p1.y, p2.y)) {
          return boundOrVertex;
        }
        //ray is vertical
        if (p1.y == p2.y) {
          //overlies on a vertical ray
          if (p1.y == p.y) {
            return boundOrVertex;
            //before ray
          } else {
            ++intersectCount;
          }
        } else {
          //cross point on the left side
          //cross point of y
          double xinters = (p.x - p1.x) * (p2.y - p1.y) / (p2.x - p1.x) + p1.y;
          //overlies on a ray
          if (fabs(p.y - xinters) < precision) {
            return boundOrVertex;
          }
          //before ray
          if (p.y < xinters) {
            ++intersectCount;
          }
        }
      }
    } else {
      //special case when ray is crossing through the vertex
      //p crossing over p2
      if (p.x == p2.x && p.y <= p2.y) {
        //next vertex
        Point p3 = pts[(i + 1) % N];
        //p.x lies between p1.x & p3.x
        if (p.x >= min(p1.x, p3.x) && p.x <= max(p1.x, p3.x)) {
          ++intersectCount;
        } else {
          intersectCount += 2;
        }
      }
    }
    //next ray left point
    p1 = p2;
  }
  //偶数在多边形外
  if (intersectCount % 2 == 0) {
    return false;
  } else {
    //奇数在多边形内
    return true;
  }
}

