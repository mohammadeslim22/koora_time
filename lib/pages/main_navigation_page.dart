import 'package:elmalaab/data/api_provider.dart';
import 'package:elmalaab/di.dart';
import 'package:elmalaab/pages/home_page.dart';
import 'package:elmalaab/pages/match_details_page_with_id.dart';
import 'package:elmalaab/pages/more_page.dart';
import 'package:elmalaab/pages/my_matches_page.dart';
import 'package:elmalaab/state/match_provider.dart';
import 'package:elmalaab/state/user_provider.dart';
import 'package:elmalaab/widgets/bottom_app_bar_item.dart';
import 'package:elmalaab/widgets/double_back_to_quit_app.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class MainNavigationPage extends StatefulWidget {
  @override
  _MainNavigationPageState createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  Widget _currentPage = HomePage();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      try {
        NotificationSettings settings =
            await FirebaseMessaging.instance.requestPermission();
        if (settings.authorizationStatus == AuthorizationStatus.authorized) {
          final token = await FirebaseMessaging.instance.getToken();
          sl<ApiProvider>().sendNotificationToken(token);
        }
      } catch (e) {}
      final matchProvider = Provider.of<MatchProvider>(context, listen: false);
      matchProvider.getMatches();
      matchProvider.getMyComingMatches();
      matchProvider.getMyPastMatches();

      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.getHasRefundBefore();
      userProvider.getNotificationStatus();
      initDynamicLinks();
    });
  }

  Future<void> initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      final Uri deepLink = dynamicLink?.link;

      if (deepLink != null) {
        final link = deepLink.path;
        if (link.startsWith('/match')) {
          final matchId = link.substring(7);
          Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => MatchDetailsPageById(matchId: matchId)));
        }
      }
    }, onError: (OnLinkErrorException e) async {
      print(e.message);
    });

    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;

    if (deepLink != null) {
      final link = deepLink.path;
      if (link.startsWith('/match')) {
        final matchId = link.substring(7);
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => MatchDetailsPageById(matchId: matchId)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DoubleBackToQuitApp(child: _currentPage),
      bottomNavigationBar: BottomAppBar(
        color: Color(0xFFFAFAFA),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            BottomAppBarItem(
              onPressed: () {
                setState(() {
                  _currentPage = HomePage();
                });
              },
              icon: FontAwesomeIcons.futbol,
              title: 'الرئيسية',
              selected: _currentPage.runtimeType == HomePage,
            ),
            BottomAppBarItem(
              onPressed: () {
                setState(() {
                  _currentPage = MyMatchesPage();
                });
              },
              icon: FontAwesomeIcons.calendarAlt,
              title: 'مبارياتي',
              selected: _currentPage.runtimeType == MyMatchesPage,
            ),
            BottomAppBarItem(
              onPressed: () {
                setState(() {
                  _currentPage = MorePage();
                });
              },
              icon: Icons.menu,
              title: 'المزيد',
              selected: _currentPage.runtimeType == MorePage,
            ),
          ],
        ),
      ),
    );
  }
}
