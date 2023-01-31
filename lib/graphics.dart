// // System.Drawing.Region
// using System.Drawing.Drawing2D;
// using System.Drawing.Internal;
// using System.Runtime.InteropServices;

import 'dart:ui';
import 'dart:math' as math;

// import 'package:flutter/cupertino.dart';

/// <summary>Returns an array of <see cref="T:System.Drawing.RectangleF" /> structures that approximate this <see cref="T:System.Drawing.Region" /> after the specified matrix transformation is applied.</summary>
/// <returns>An array of <see cref="T:System.Drawing.RectangleF" /> structures that approximate this <see cref="T:System.Drawing.Region" /> after the specified matrix transformation is applied.</returns>
/// <param name="matrix">A <see cref="T:System.Drawing.Drawing2D.Matrix" /> that represents a geometric transformation to apply to the region. </param>
/// <exception cref="T:System.ArgumentNullException">
///   <paramref name="matrix" /> is null.</exception>
/// <filterpriority>1</filterpriority>
/// <PermissionSet>
///   <IPermission class="System.Security.Permissions.SecurityPermission, mscorlib, Version=2.0.3600.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" version="1" Flags="UnmanagedCode, ControlEvidence" />
/// </PermissionSet>
enum Position
{
  CONTAINS,INSIDE,OVERLAPS,EQUAL,DISJOINT,TOUCHING
}
var dp = 2;
var dp1 = dp-1;
var dp2 = dp-2;
var inf = double.infinity;

double round(double value,int? digits)
{
  if(digits== null || digits<1)
    {
      return value.truncate() as double;
    }
  var fixedStr = value.toStringAsFixed(digits);
  var fixed = double.parse(fixedStr);
  return fixed;
}

double abs(double value)
{
  return value>0?value:(0-value);
}
num min(List<num> list)
{
  num minVal = list.reduce((v, e) => math.min(v, e));
  return minVal;
}
num max(List<num> list) {
num maxVal = list.reduce((v, e) => math.max(v, e));
return maxVal;
}


class SweepPastResult<P,S>
{
  final Position position;
  final List<Seg>? segList;

  SweepPastResult(this.position, this.segList);
}

class Region
{
  getRotatedCoords(polyList, xdp)
  {
    getBestAngle(polyList){
      var anglesFromVertical = [];
      for( var poly in polyList){
        var segments = poly.segments;
        for(var seg in segments){
          var angle = round(abs(seg.angle), 3);
          anglesFromVertical.add(angle);
        }
      }
      if(anglesFromVertical.contains(0) == false)
        {
          return 0;
        }
      var positiveAngles = <double>[];
      {
        for(var a in anglesFromVertical)
          {
            if(a>0.1) {
              positiveAngles.add(a);
            }
          }
      }
      return round(min(positiveAngles)/2, 1);
    }
    var a = getBestAngle(polyList);
    var cosA = math.cos(a);
    var sinA = math.sin(a);
    List<List<Coord>> coordsLists = [];
    for(var poly in polyList){
      var polyRotated = <Poly>[];
      if(a==0){
        polyRotated = poly.pointList;
      }
      else{
        polyRotated = [];
        //TODO 这里还有一部分没有写.需要用到SVG相关的东西
      }
      var coords = <Coord>[];
      for(poly in polyRotated) {
          coords.add(Coord(round(poly.x, xdp), poly.y));
      }
      coordsLists.add(coords);
    }
    return coordsLists;
  }
  late double boundary;
  Position relativeposition(Region self, Region other)
  {
    var polyA = self.boundary;
    var polyB = other.boundary;
    var coordsList1 = getRotatedCoords([polyA,polyB], dp);
    var coordsList2 = getRotatedCoords([polyA,polyB], dp);
    var transposed = false;
    var bBoxResult = compareBoundingBoxes(coordsList1, coordsList2, null, dp);
    if([Position.DISJOINT, Position.TOUCHING].contains(bBoxResult)){
      return Position.DISJOINT;
    }

    if(bBoxResult == Position.EQUAL){
      if(equalPolygons(coordsList1, coordsList2)){
        return Position.EQUAL;
      }
      else if(area(coordsList2) > area(coordsList1)){
        var coordTemp = coordsList1;
        coordsList1 = coordsList2;
        coordsList2 = coordTemp;
        var polyTemp = polyA;
        polyA = polyB;
        polyB = polyTemp;
        transposed = true;
      }
    }

    if(bBoxResult == Position.INSIDE){
      var coordTemp = coordsList1;
      coordsList1 = coordsList2;
      coordsList2 = coordTemp;
      var polyTemp = polyA;
      polyA = polyB;
      polyB = polyTemp;
      transposed = true;
    }
    List<Seg> unUsedSegments = getStoredSegments(polyA+polyB, coordsList1+coordsList2);

    List<Seg> liveSegments = [];
    var currentOutCome;
    List<Coord> coords1And2 = coordsList1 + coordsList2;
    coords1And2.sort((a,b){
      return a.x>b.x? 1
          :a.x==b.x? 0
          :-1;
    });
    var xValues = coords1And2;
    for(var x in xValues){
      var ret = SweepPastResult(x, liveSegments);
      currentOutCome = ret[0];
      liveSegments = ret[1];
      if(currentOutCome == Position.OVERLAPS) return currentOutCome;
    }
    if(currentOutCome == Position.CONTAINS && transposed)
      {
        currentOutCome = Position.INSIDE;
      }
    SweepPastResult sweepPast(x, Position latestoutcome, List<Seg> livesegments) {
      for (var i = 0; i < livesegments.length; i++) {
        var seg = livesegments[i];
        if (seg.rightX == x) {
          seg.y = seg.rightY.truncate() as double;
        }
        else {
          seg.y =
          (seg.leftY + (x - seg.leftX) * seg.gradient).truncate() as double;
        }
      }
      for (var i = 0; i < livesegments.length; i++) {
        var seg = livesegments[i];
        var subList = livesegments.sublist(i + 1);
        for (var j = 0; j < subList.length; j++) {
          var seg2 = subList[j];
          if (seg.y == inf || seg2.y == inf) {
            continue;
          }
          if (seg.y > seg2.y && seg.poly != seg2.poly) {
            return SweepPastResult(Position.OVERLAPS, null);
          }
        }
      }
      var newLiveSegments = <Seg>[];
      for (var seg in livesegments) {
        var rightXFixedStr = seg.rightX.toStringAsFixed(1);
        double rightXFixed = double.parse(rightXFixedStr);
        var xFixedStr = seg.x.toStringAsFixed(1);
        double xFixed = double.parse(xFixedStr);
        if (rightXFixed > xFixed) {
          newLiveSegments.add(seg);
        }
      }
      livesegments = newLiveSegments;
      while (unUsedSegments.isNotEmpty
              && round(unUsedSegments[0].leftX, dp1) ==
              round(unUsedSegments[0].x, dp1)) {
        var newSeg = unUsedSegments[0];
        unUsedSegments.removeAt(0);
        newSeg.y = round(newSeg.leftY, dp2);
      }
      unUsedSegments.sort((a, b) {
        int ret = a.y > b.y ? 1
            : a.y == b.y ? 0
            : -1;
        return ret;
      });
      unUsedSegments.sort((a, b) {
        int ret = a.gradient > b.gradient ? 1
            : a.gradient == b.gradient ? 0
            : -1;
        return ret;
      });

      var yValuesA = <double>[];
      for (var seg in livesegments) {
        if (seg.poly == polyA) {
          yValuesA.add(seg.y);
        }
      }
      var intervalsA = <Interval>[];
      for(var i=0;i<yValuesA.length;i+=2)
        {
          intervalsA.add(Interval(yValuesA[i], yValuesA[i+1]));
        }


      var yValuesB = <double>[];
      for (var seg in livesegments) {
        if (seg.poly == polyB) {
          yValuesB.add(seg.y);
        }
      }
      var intervalsB = <Interval>[];
      for(var i=0;i<yValuesB.length;i+=2)
      {
        intervalsB.add(Interval(yValuesB[i], yValuesB[i+1]));
      }

      for(var b in intervalsB)
        {
          var startB = b.d1;
          var endB = b.d2;
          for(var a in intervalsA)
            {
              var startA = a.d1;
              var endA = a.d2;
              if(startB == endB && (startA == startB || endA == endB))
                {
                  break;
                }
              if(startA<=startB && endA>=endB){
                if(latestoutcome == Position.DISJOINT){
                  return SweepPastResult(Position.OVERLAPS, null);
                }
                latestoutcome = Position.CONTAINS;
                break;
              }
              else if((startB <startA && startA<endB) || (startB<endA && endA <endB)){
                return SweepPastResult(Position.OVERLAPS, null);
              }
              else{
                if(latestoutcome == Position.CONTAINS){
                  return SweepPastResult(Position.OVERLAPS, null);
                }
                latestoutcome = Position.DISJOINT;
              }
            }
        }
      return SweepPastResult(latestoutcome, livesegments);
    }
    return currentOutCome;
  }
  getStoredSegments(List<Poly> polyList,List< List<Coord>> coordsLists)
  {
    var segments = [];
    for(var i=0;i<polyList.length; i++)
      {
        var poly = polyList[i];
        var coordList = coordsLists[i];
        var len = coordList.length;

      }
  }
  area(List<Coord> poly)
  {
    double area = 0;
    var last = poly[-1];
    var x0 = last.x;
    var y0 = last.y;
    for(var p in poly)
      {
        var x1 = p.x;
        var y1 = p.y;
        area += x1*y0 - x0* y1;
        x0 = x1;
        y0 = y1;
      }
    return abs(area/2);
  }
  equalPolygons(List<int> poly1, List<int> poly2)
  {
    var min1 = min(poly1);
    var start1 = poly1.indexOf(min1.toInt());
    poly1 = poly1.sublist(start1+1)+poly1.sublist(0,start1);

    var min2 = min(poly2);
    var start2 = poly2.indexOf(min2.toInt());
    poly2 = poly2.sublist(start2+1)+poly2.sublist(0,start2);

    return poly1 == poly2 || poly1 == poly2.reversed;
  }

  Rect getBoundingBox(List<Coord> poly, int? xdp, int? ydp)
  {
    List<double> xCoords = [];
    for(var p in poly)
      {
        xCoords.add(xdp == null? p.x: round(p.x, xdp));
      }
    var left = min(xCoords);
    var right = max(xCoords);

    List<double> yCoords = [];
    for(var p in poly){
      yCoords.add(ydp == null? p.y: round(p.y, ydp));
    }

    var top = min(yCoords);
    var bottom = max(yCoords);

    var points = [Offset(left.toDouble(), top.toDouble()), Offset(right.toDouble(), bottom.toDouble())];
    return Rect.fromPoints(points[0], points[1]);
  }

  Position compareBoundingBoxes(List<Coord> poly1, List<Coord> poly2, int? xdp, int? ydp)
  {
    if(yes(xdp) && not(ydp)){
      ydp = xdp;
    }
    var rect1 = getBoundingBox(poly1, xdp,ydp);
    var rect2 = getBoundingBox(poly2, xdp, ydp);
    var left1 = rect1.left;
    var top1 = rect1.top;
    var right1 = rect1.right;
    var bottom1 = rect1.bottom;
    var left2 = rect2.left;
    var top2 = rect2.top;
    var right2 = rect2.right;
    var bottom2 = rect2.bottom;

    var xResult = Position.CONTAINS;

    if(right1<left2 || right2<left1 || bottom1 < top2 || bottom2 < top1){
      return Position.DISJOINT;
    }
    if (right1 == left2 || right2 == left1 || bottom1 == top2 || bottom2 == top1) {
      return Position.TOUCHING;
    }
    if(left1<left2) {
      if (right1 < right2) {
        return Position.OVERLAPS;
      }
      else {
        xResult = Position.CONTAINS;
      }
    }
    else if(left1 == left2)
      {
        xResult = right1<right2?Position.INSIDE
            :right1 == right2 ? Position.EQUAL
            :Position.CONTAINS;
      }
    else {
      //left1>left2
      xResult = right1 >right2 ? Position.OVERLAPS
          :Position.INSIDE;
    }


    if(top1<top2){
      if(bottom1<bottom2) {
        return Position.OVERLAPS;
      } else{
        if(xResult == Position.INSIDE) {
          return Position.OVERLAPS;
        } else {
          return Position.CONTAINS;
        }
      }
    }
    else if(top1 == top2){
      if(bottom1<bottom2) {
        if(xResult == Position.CONTAINS) {
          return Position.OVERLAPS;
        } else{
          return Position.INSIDE;
        }
      }
      else if(bottom1 == bottom2) {
        return xResult;
      } else{
        if(xResult == Position.INSIDE) return Position.OVERLAPS;
        return Position.CONTAINS;
      }
    }
    else{
      if(bottom1>bottom2) {
        return Position.OVERLAPS;
      } else
        {
           if(xResult == Position.CONTAINS) return Position.OVERLAPS;
           return Position.INSIDE;
        }
    }
  }
  
  yes(int? dp)
  {
    return dp != null && dp>0;
  }
  not(int? dp)
  {
    return dp == null || dp<1;
  }
}
class Coord
{
  final double x;
  final double y;

  Coord(this.x, this.y);
}
class Poly
{
  final pointList = [];
}

class Interval<T1, T2>
{
  final double d1;
  final double d2;

  Interval(this.d1, this.d2);
}

// class Seg
// {
//   double angle;
//   double x;
//   double y;
//   double rightX;
//   double rightY;
//   double leftY;
//   double leftX;
//   double gradient;
//   double poly;
//
//   Seg(this.x, this.rightX, this.y, this.rightY, this.leftY, this.leftX, this.gradient, this.poly, this.angle);
// }

class Seg{
  late Offset leftPoint;
  late Offset rightPoint;
  late List<int> leftIndex;
  late List<int> rightIndex;
  late double rightX;
  late double rightY;
  late double leftY;
  late double leftX;
  late double top;
  late double bottom;
  late Poly poly;
  late List<int> index;
  late double dx;
  late double dy;
  late double gradient;
  late double angle;
  late double y;
  late double x;
  late String xPos;
  Seg(Offset startpoint, Offset endPoint,this.poly, this.index) {
   if (endPoint < startpoint) {
     leftPoint = endPoint;
     rightPoint = startpoint;
     rightIndex = leftIndex = index.reversed.toList();
   }
   else {
     leftPoint = startpoint;
     rightPoint = endPoint;
     rightIndex = leftIndex = index;
   }
   leftX = leftPoint.dx;
   leftY = leftPoint.dy;
   rightX = rightPoint.dx;
   rightY = rightPoint.dy;
   if(rightY < leftY)
     {
       top = rightY;bottom = leftY;
     }else{
     top = leftY; bottom = rightY;
   }
   dx = rightX- leftX;
   dy = rightX-leftY;

   gradient = dx == 0? double.infinity : dy/dx;
   angle = math.atan2(dy, dy)-math.pi/2+math.pi*(dy<0?1:0);

   y=leftY;
   xPos = "L";
 }
}