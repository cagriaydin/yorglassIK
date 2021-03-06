import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yorglass_ik/models/content_option.dart';
import 'package:yorglass_ik/models/reward.dart';
import 'package:yorglass_ik/models/user-reward.dart';
import 'package:yorglass_ik/models/user.dart';
import 'package:yorglass_ik/pages/leader_board_page.dart';
import 'package:yorglass_ik/pages/rewards_page.dart';
import 'package:yorglass_ik/repositories/branch_repository.dart';
import 'package:yorglass_ik/repositories/user_repository.dart';
import 'package:yorglass_ik/widgets/blur_background_image.dart';
import 'package:yorglass_ik/widgets/build_user_info.dart';
import 'package:yorglass_ik/widgets/content_selector.dart';
import 'package:yorglass_ik/widgets/leader_board.dart';
import 'package:yorglass_ik/widgets/reward_cards.dart';
import 'package:yorglass_ik/widgets/user_percentage.dart';
import 'package:yorglass_ik/widgets/user_point.dart';

class ProfilePage extends StatelessWidget {
  final Function menuFunction;

  ProfilePage({Key key, @required this.menuFunction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;
    final size =
        MediaQuery.of(context).size * MediaQuery.of(context).devicePixelRatio;
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: GestureDetector(
            onTap: () => menuFunction(),
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
            Flexible(child: BuildProfileInfo(size: size, padding: padding)),
            Flexible(
              child: BuildProfileTabs(),
            ),
          ],
        ),
      ),
    );
  }
}

class BuildProfileTabs extends StatefulWidget {
  @override
  _BuildProfileTabsState createState() => _BuildProfileTabsState();
}

class _BuildProfileTabsState extends State<BuildProfileTabs> {
  final PageController pageController = PageController(initialPage: 0);

  final List<ContentOption> options = [
    ContentOption(title: 'Liderler', isActive: true),
    ContentOption(title: 'Ödüllerim'),
  ];

  Future<List<User>> leaderListFeature;

  Future pushRewardsPage(BuildContext context) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) {
          final userRewardProvider = Provider.of<UserReward>(context);
          return ChangeNotifierProvider.value(
              value: userRewardProvider, child: RewardsPage());
        },
      ),
    );
  }

  onContentSelectorChange(ContentOption contentOption) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (getPage(contentOption) == 0) {
        setState(() {
          leaderListFeature = null;
        });
        setState(() {
          leaderListFeature = UserRepository.instance.getTopUserPointList();
        });
      }
      return pageController.animateToPage(
        getPage(contentOption),
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  int getPage(ContentOption contentOption) =>
      contentOption.title == 'Liderler' ? 0 : 1;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          flex: size.height < 600 ? 3 : 2,
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
          flex: 10,
          child: PageView(
            physics: NeverScrollableScrollPhysics(),
            controller: pageController,
            children: [
              BuildLeadersTab(),
              SingleChildScrollView(
                child: Transform.scale(
                  scale: size.height < 600 ? .7 : 1,
                  alignment: Alignment.topCenter,
                  child: Column(
                    children: [
                      RewardCards(
                        reward: Reward(
                            imageId: "21eb8c71-9f90-11ea-b559-005056b3b493",
                            point: 0,
                            likeCount: 0),
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
              ),
            ],
          ),
        )
      ],
    );
  }
}

class BuildLeadersTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final select = context.select((User value) => value.leaderBoardItemList);
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: select == null
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: GestureDetector(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return LeaderBoardPage(leaderBoardUsers: select);
                          },
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        LeaderBoard(
                          isLeaderBoard: true,
                          list: select,
                        ),
                        OutlineButton(
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return LeaderBoardPage(
                                      leaderBoardUsers: select);
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}

class BuildProfileInfo extends StatelessWidget {
  const BuildProfileInfo({
    Key key,
    @required this.size,
    @required this.padding,
  }) : super(key: key);

  final Size size;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final user = context.select((User value) => value);
    return BlurBackgroundImage(
      imageUrl: user.image,
      child: SingleChildScrollView(
        child: Column(
          children: [
//            SizedBox(
//              height: size.height < 600 ? 0 : padding.top,
//            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                UserPercentage(),
                Container(
                  child: BuildUserInfo(
                    showPercentage: true,
                    user: user,
                    radius: size.height < 700 ? 45 : 70,
                  ),
                ),
                FittedBox(
                  fit: BoxFit.fitWidth,
                  child: UserPoint(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
