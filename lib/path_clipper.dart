import 'package:flutter/material.dart';

class PathClipper extends CustomClipper<Path> {
  final Path path;
  PathClipper(this.path);
  @override
  Path getClip(Size size) {
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}