import 'package:flutter/material.dart';

class LeaderBoardItem {
  final String image;
  final int point;
  final String name;
  final String branchName;

  LeaderBoardItem({
    @required this.image,
    @required this.point,
    @required this.name,
    this.branchName,
  });
}
