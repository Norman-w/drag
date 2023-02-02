class PointEX {
  PointEX(this.x,this.y);
  late double x;
  late double y;
  bool equals(other){
    return other.x == x && other.y == y;
  }
  @override
  String toString() {
    return "点(x:$x , y:$y)";
  }
}
// 计算叉乘 |P0P1| × |P0P2|
double pointMultiply(PointEX p1, PointEX p2, PointEX p0)
{
  return ( (p1.x - p0.x) * (p2.y - p0.y) - (p2.x - p0.x) * (p1.y - p0.y) );
}