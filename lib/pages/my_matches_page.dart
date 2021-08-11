import 'package:elmalaab/state/match_provider.dart';
import 'package:elmalaab/widgets/button.dart';
import 'package:elmalaab/widgets/match_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum Tab {
  Coming,
  Past,
}

class MyMatchesPage extends StatefulWidget {
  @override
  _MyMatchesPageState createState() => _MyMatchesPageState();
}

class _MyMatchesPageState extends State<MyMatchesPage> {
  Tab selectedTab = Tab.Coming;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Flexible(
                    child: SizedBox(
                      height: 36,
                      child: Button(
                        title: 'القادمة',
                        color: selectedTab == Tab.Coming
                            ? Theme.of(context).primaryColor
                            : Color(0xFFCCCCCC),
                        onPressed: () async {
                          setState(() {
                            selectedTab = Tab.Coming;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Flexible(
                    child: SizedBox(
                      height: 36,
                      child: Button(
                        title: 'السابقة',
                        color: selectedTab == Tab.Past
                            ? Theme.of(context).primaryColor
                            : Color(0xFFCCCCCC),
                        onPressed: () async {
                          setState(() {
                            selectedTab = Tab.Past;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                color: Theme.of(context).primaryColor,
                onRefresh: () async {
                  if (selectedTab == Tab.Coming)
                    await Provider.of<MatchProvider>(context, listen: false)
                        .refreshMyComingMatches();
                  if (selectedTab == Tab.Past)
                    await Provider.of<MatchProvider>(context, listen: false)
                        .refreshMyPastMatches();
                },
                child: Consumer<MatchProvider>(
                  builder: (context, provider, child) {
                    if (selectedTab == Tab.Coming) {
                      if (provider.isLoadingComingMatches)
                        return Center(
                            child: CircularProgressIndicator(
                          valueColor: new AlwaysStoppedAnimation<Color>(
                              Theme.of(context).primaryColor),
                        ));
                      if (provider.myComingMatches.isEmpty)
                        return ListView(
                          children: [
                            Center(
                              child: Text(
                                'لا يوجد مباريات للعرض',
                                style: TextStyle(fontFamily: 'DINNextLTArabic'),
                              ),
                            ),
                          ],
                        );
                      return ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: provider.myComingMatches.length,
                        itemBuilder: (context, index) {
                          return MatchWidget(
                              match: provider.myComingMatches[index]);
                        },
                        separatorBuilder: (context, index) {
                          return SizedBox(height: 12);
                        },
                      );
                    } else {
                      if (provider.isLoadingPastMatches)
                        return Center(
                            child: CircularProgressIndicator(
                          valueColor: new AlwaysStoppedAnimation<Color>(
                              Theme.of(context).primaryColor),
                        ));
                      if (provider.myPastMatches.isEmpty)
                        return ListView(
                          children: [
                            Center(
                                child: Text(
                              'لا يوجد مباريات للعرض',
                              style: TextStyle(fontFamily: 'DINNextLTArabic'),
                            )),
                          ],
                        );
                      return ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: provider.myPastMatches.length,
                        itemBuilder: (context, index) {
                          return MatchWidget(
                              match: provider.myPastMatches[index]);
                        },
                        separatorBuilder: (context, index) {
                          return SizedBox(height: 12);
                        },
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
