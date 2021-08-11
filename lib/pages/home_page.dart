import 'package:elmalaab/models/match.dart';
import 'package:elmalaab/state/match_provider.dart';
import 'package:elmalaab/state/user_provider.dart';
import 'package:elmalaab/widgets/coming_match_widget.dart';
import 'package:elmalaab/widgets/match_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Text(
                    'أهلا بك',
                    style: TextStyle(
                      color: Color(0xFF85C23F),
                      fontFamily: 'BeINBlack',
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(width: 4),
                  Text(
                    Provider.of<UserProvider>(context).user?.name ?? '',
                    style: TextStyle(
                      color: Color(0xFF2B4A66),
                      fontFamily: 'BeINBlack',
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await Provider.of<MatchProvider>(context, listen: false)
                      .refreshMatches();
                },
                color: Theme.of(context).primaryColor,
                child: Consumer<MatchProvider>(
                  builder: (context, provider, child) {
                    if (provider.isLoadingMatches)
                      return Center(
                          child: CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(
                            Theme.of(context).primaryColor),
                      ));
                    if (provider.matchesMap.isEmpty)
                      return ListView(
                        children: [
                          Center(
                              child: Text(
                            'لا يوجد مباريات للعرض',
                            style: TextStyle(fontFamily: 'DINNextLTArabic'),
                          )),
                        ],
                      );
                    return ListView(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                      children: [
                        for (DateTime dateTime in provider.matchesMap.keys) ...[
                          Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  color: Color(0xFF191919),
                                  thickness: 2,
                                ),
                              ),
                              SizedBox(width: 16),
                              Text(
                                _getDate(dateTime),
                                style: TextStyle(
                                  color: Color(0xFF191919),
                                  fontSize: 14,
                                  fontFamily: 'DINNextLTW23',
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Divider(
                                  color: Color(0xFF191919),
                                  thickness: 2,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          for (FootballMatch footballMatch
                              in provider.matchesMap[dateTime])
                            Column(
                              children: [
                                if (footballMatch.type == 1)
                                  MatchWidget(match: footballMatch)
                                else if (footballMatch.type == 0)
                                  ComingMatchWidget(match: footballMatch),
                                SizedBox(height: 12),
                              ],
                            ),
                        ],
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getDate(DateTime dateTime) {
    String date = '${dateTime.day.toString().padLeft(2, '0')}'
        '/${dateTime.month.toString().padLeft(2, '0')}'
        '/${dateTime.year}';

    DateTime nowWithHour = DateTime.now();
    DateTime nowWithoutHour =
        DateTime(nowWithHour.year, nowWithHour.month, nowWithHour.day);
    DateTime dateTimeWithoutHour =
        DateTime(dateTime.year, dateTime.month, dateTime.day);
    if (dateTimeWithoutHour.difference(nowWithoutHour).inDays == 0) {
      date = 'اليوم';
    } else if (dateTimeWithoutHour.difference(nowWithoutHour).inDays == 1) {
      date = 'غدا';
    }
    return date;
  }
}
