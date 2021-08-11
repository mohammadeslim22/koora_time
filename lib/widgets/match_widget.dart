import 'package:elmalaab/models/match.dart';
import 'package:elmalaab/pages/match_details_page.dart';
import 'package:elmalaab/widgets/button.dart';
import 'package:elmalaab/widgets/match_summary_widget.dart';
import 'package:elmalaab/widgets/participating_players_widget.dart';
import 'package:flutter/material.dart';

class MatchWidget extends StatelessWidget {
  final FootballMatch match;

  const MatchWidget({
    Key key,
    @required this.match,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => MatchDetailsPage(match: match)));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8)),
          boxShadow: [
            BoxShadow(
              color: Color(0x29000000),
              blurRadius: 1,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
              ),
              width: double.infinity,
              alignment: Alignment.center,
              padding: const EdgeInsets.all(12),
              child: Text(
                match.playgroundName ?? '',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'DINNextLTW23',
                  fontSize: 14,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  MatchSummaryWidget(match: match),
                  SizedBox(height: 12),
                  Divider(),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Flexible(
                        flex: 3,
                        child:
                            ParticipatingPlayersWidget(players: match.players),
                      ),
                      SizedBox(width: 8),
                      Flexible(
                        flex: 2,
                        child: SizedBox(
                          height: 36,
                          child: match.availableSeats > 0
                              ? Button(
                                  onPressed: () async {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (_) => MatchDetailsPage(
                                                match: match)));
                                  },
                                  title: match.matchStatus ==
                                          MatchStatus.NOT_JOINED
                                      ? 'انضم'
                                      : 'تفاصيل المباراة',
                                )
                              : Center(
                                  child: Text(
                                    'محجوز بالكامل',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFFD53B3B),
                                      fontFamily: 'DINNextLTW23',
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
