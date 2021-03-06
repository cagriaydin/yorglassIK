// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:yorglass_ik/models/leader_board_item.dart';
import 'package:yorglass_ik/repositories/user_repository.dart';
import 'package:yorglass_ik/services/authentication-service.dart';

User userFromJson(String str) => User.fromMap(json.decode(str));

String userToJson(User data) => json.encode(data.toMap());

List<User> userListFromJson(List<dynamic> listOfString) =>
    (listOfString).map((e) => User.fromMap(e)).toList();

class User extends ChangeNotifier {
  String id;
  String name;
  String branchName;
  String branch;
  String phone;
  int code;
  String image;

  int percentage;
  int taskCount;
  int point;
  List<String> likedFeeds;
  List<String> deletedFeeds;

  List<LeaderBoardItem> leaderBoardItemList;

  User({
    this.id,
    @required this.name,
    @required this.point,
    @required this.percentage,
    @required this.taskCount,
    @required this.branchName,
    @required this.phone,
    @required this.code,
    @required this.image,
    @required this.likedFeeds,
    @required this.deletedFeeds,
    this.branch,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        phone: json["phone"],
        branch: json["branch"],
        code: json["code"],
        image: json["image"],
      );

  User copyWith({
    String id,
    String name,
    int point,
    int taskCount,
    int percentage,
    String branchName,
    String branch,
    String phone,
    int code,
    String image,
    List<String> likedFeeds,
    List<String> deletedFeeds,
  }) =>
      User(
        id: id ?? this.id,
        name: name ?? this.name,
        point: point ?? this.point,
        percentage: percentage ?? this.percentage,
        taskCount: taskCount ?? this.taskCount,
        branchName: branchName ?? this.branchName,
        branch: branch ?? this.branch,
        phone: phone ?? this.phone,
        code: code ?? this.code,
        image: image ?? this.image,
        likedFeeds: likedFeeds ?? this.likedFeeds,
        deletedFeeds: deletedFeeds ?? this.deletedFeeds,
      );

  factory User.fromMap(Map<String, dynamic> json) => User(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        point: json["point"] == null ? null : json["point"],
        percentage: json["percentage"] == null ? null : json["percentage"],
        taskCount: json["taskCount"] == null ? null : json["taskCount"],
        branchName: json["branchName"] == null ? null : json["branchName"],
        branch: json["branch"] == null ? null : json["branch"],
        phone: json["phone"] == null ? null : json["phone"],
        code: json["code"] == null ? null : json["code"],
        image: json["image"] == null ? null : json["image"],
        likedFeeds: List<String>.from(json["likedFeeds"] ?? [].map((x) => x)),
        deletedFeeds:
            List<String>.from(json["deletedFeeds"] ?? [].map((x) => x)),
      );

  factory User.fromSnapshot(DocumentSnapshot snapshot) => User(
        id: snapshot.data["id"] == null ? null : snapshot.data["id"],
        name: snapshot.data["name"] == null ? null : snapshot.data["name"],
        point: snapshot.data["point"] == null ? null : snapshot.data["point"],
        percentage: snapshot.data["percentage"] == null
            ? null
            : snapshot.data["percentage"],
        taskCount: snapshot.data["taskCount"] == null
            ? null
            : snapshot.data["taskCount"],
        branchName: snapshot.data["branchName"] == null
            ? null
            : snapshot.data["branchName"],
        branch:
            snapshot.data["branch"] == null ? null : snapshot.data["branch"],
        phone: snapshot.data["phone"] == null ? null : snapshot.data["phone"],
        code: snapshot.data["code"] == null ? null : snapshot.data["code"],
        image: snapshot.data["image"] == null ? null : snapshot.data["image"],
        likedFeeds:
            List<String>.from(snapshot.data["likedFeeds"].map((x) => x)),
        deletedFeeds:
            List<String>.from(snapshot.data["deletedFeeds"].map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "point": point == null ? null : point,
        "percentage": percentage == null ? null : percentage,
        "taskCount": taskCount == null ? null : taskCount,
        "branchName": branchName == null ? null : branchName,
        "branch": branch == null ? null : branch,
        "phone": phone == null ? null : phone,
        "code": code == null ? null : code,
        "image": image == null ? null : image,
        "likedFeeds": List<dynamic>.from(likedFeeds.map((x) => x)),
        "deletedFeeds": List<dynamic>.from(deletedFeeds.map((x) => x)),
      };

  Future<User> updatePoint() async {
//    point = await RewardRepository.instance.getActivePoint();
    getTopUserPointListAndNotify();
    var newUser = (await AuthenticationService.instance.refreshAuthenticate());
    this.point = newUser.point;
    this.percentage = newUser.percentage;
    this.taskCount = newUser.taskCount;
    notifyListeners();
    return newUser;
  }

  void getTopUserPointListAndNotify() {
    UserRepository.instance.getTopUserPointList().then((value) {
      leaderBoardItemList = value
          .map((e) => LeaderBoardItem(
                imageId: e.image,
                point: e.point,
                name: e.name,
                branchName: e.branchName,
              ))
          .toList();
      notifyListeners();
    });
  }
}

//{
//"id": "id",
//"name":"",
//"branchName":"",
//"branch":"",
//"phone":"",
//"extraInfo":{},
//"model": "hex",
//"brand":"",
//"os":"",
//"phoneNumber":""
//}
