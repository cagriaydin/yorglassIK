import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:yorglass_ik/models/content_option.dart';
import 'package:yorglass_ik/models/leader_board_item.dart';
import 'package:yorglass_ik/models/reward.dart';
import 'package:yorglass_ik/models/user.dart';
import 'package:yorglass_ik/pages/leader_board_page.dart';
import 'package:yorglass_ik/pages/rewards_page.dart';
import 'package:yorglass_ik/repositories/user_repository.dart';
import 'package:yorglass_ik/widgets/blur_background_image.dart';
import 'package:yorglass_ik/widgets/build_user_info.dart';
import 'package:yorglass_ik/widgets/content_selector.dart';
import 'package:yorglass_ik/widgets/gradient_text.dart';
import 'package:yorglass_ik/widgets/leader_board.dart';
import 'package:yorglass_ik/widgets/reward_cards.dart';

class ProfilePage extends StatefulWidget {
  final Function menuFunction;
  final User user;

  ProfilePage({Key key, @required this.menuFunction, @required this.user})
      : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final PageController pageController = PageController(initialPage: 0);

  final List<ContentOption> options = [
    ContentOption(title: 'Liderler', isActive: true),
    ContentOption(title: 'Ödüllerim'),
  ];

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => widget.menuFunction(),
          child: Icon(
            Icons.menu,
            color: Color(0xff2DB3C1),
            size: 40,
          ),
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Flexible(
            child: BlurBackgroundImage(
              imageUrl: widget.user.image,
              child: Column(
                children: [
                  SizedBox(
                    height: size.height < 600 ? 0 : padding.top,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GradientText(
                        '%' + (widget.user.percentage ?? 0).toString(),
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                      ),
                      BuildUserInfo(
                        showPercentage: true,
                        user: widget.user,
                        radius: size.height < 700 ? 50 : 80,
                      ),
                      FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GradientText(
                              (widget.user.point ?? 0).toString(),
                              fontWeight: FontWeight.w500,
                            ),
                            Text(
                              'puan',
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.w300),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Flexible(
                  flex: size.height < 600 ? 2 : 1,
                  child: Padding(
                    padding: size.height < 600
                        ? const EdgeInsets.all(8)
                        : const EdgeInsets.all(7.0),
                    child: ContentSelector(
                      onChange: onContentSelectorChange,
                      options: options,
                      contentSelectorType: ContentSelectorType.tab,
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: PageView(
                    onPageChanged: (i) {
                      options.forEach((element) {
                        element.isActive = false;
                      });
                      setState(() {
                        options.elementAt(i).isActive = true;
                      });
                    },
                    controller: pageController,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => pushLeaderBoardPage(context),
                              child: FutureBuilder<List<User>>(
                                future: UserRepository.instance
                                    .getTopUserPointList(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<List<User>> snapshot) {
                                  if (snapshot.hasData) {
                                    return SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          LeaderBoard(
                                            list: snapshot.data
                                                .map((e) => LeaderBoardItem(
                                                      image: e.image,
                                                      point: e.point,
                                                      name: e.name,
                                                    ))
                                                .toList(),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: OutlineButton(
                                              child: Text(
                                                'Lider Tablosunu Gör',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w300,
                                                  fontSize: 18,
                                                ),
                                              ),
                                              textColor: Color(0xff2DB3C1),
                                              borderSide: BorderSide(
                                                color: Color(0xff2DB3C1),
                                                style: BorderStyle.solid,
                                                width: 1,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(20))),
                                              onPressed: () =>
                                                  pushLeaderBoardPage(context),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  } else {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            RewardCards(
                              reward: Reward(
                                imageId: "c9a560ac-63f2-401b-8185-2bae139957ad",
                                point: 0,
                                likeCount: 0
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: OutlineButton(
                                child: Text(
                                  'Ödülleri Gör',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 18,
                                  ),
                                ),
                                textColor: Color(0xff2DB3C1),
                                borderSide: BorderSide(
                                  color: Color(0xff2DB3C1),
                                  style: BorderStyle.solid,
                                  width: 1,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                ),
                                onPressed: () => pushRewardsPage(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void pushLeaderBoardPage(BuildContext context) {
    UserRepository.instance.getTopUserPointList().then((userTopList) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) {
            return LeaderBoardPage(
              leaderBoard: LeaderBoard(
                list: [
                  LeaderBoardItem(
                    image: userTopList[0].image,
                    point: userTopList[0].point,
                    name: userTopList[0].name,
                    branchName: userTopList[0].branchName,
                  ),
                  LeaderBoardItem(
                    image: userTopList[1].image,
                    point: userTopList[1].point,
                    name: userTopList[1].name,
                    branchName: userTopList[0].branchName,
                  ),
                  LeaderBoardItem(
                    image: userTopList[2].image,
                    point: userTopList[2].point,
                    name: userTopList[2].name,
                    branchName: userTopList[0].branchName,
                  ),
                ],
                isLeaderBoard: true,
              ),
            );
          },
        ),
      );
    });
  }

  Future pushRewardsPage(BuildContext context) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return RewardsPage();
        },
      ),
    );
  }

  onContentSelectorChange(ContentOption contentOption) {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => pageController.animateToPage(
              contentOption.title == 'Liderler' ? 0 : 1,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeOut,
            ));
  }
}
