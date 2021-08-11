import 'package:elmalaab/data/api_provider.dart';
import 'package:elmalaab/di.dart';
import 'package:elmalaab/models/match.dart';
import 'package:elmalaab/state/match_provider.dart';
import 'package:elmalaab/state/user_provider.dart';
import 'package:elmalaab/widgets/button.dart';
import 'package:elmalaab/widgets/participating_players_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ComingMatchWidget extends StatelessWidget {
  final FootballMatch match;

  const ComingMatchWidget({
    Key key,
    @required this.match,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // SizedBox(height: 12),
                Text(
                  'مباراة يوم ${_getDate(match.dateTime)}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF191919),
                    fontFamily: 'DINNextLTArabic',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'سيتم إعلامك عند توفر مكان',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF191919),
                    fontFamily: 'DINNextLTW23',
                  ),
                ),
                SizedBox(height: 12),
                ParticipatingPlayersWidget(
                    players: match.players, isCenter: true),
                SizedBox(height: 12),
                match.availableSeats > 0
                    ? (() {
                        for (var player in match.players)
                          if (player.number ==
                              Provider.of<UserProvider>(context, listen: false)
                                  .user
                                  .mobile) return false;
                        return true;
                      }()
                        ? Button(
                            onPressed: () async {
                              try {
                                await sl<ApiProvider>().payAndRegister(
                                  'temp',
                                  'temp',
                                  1,
                                  1,
                                  1,
                                  match.id,
                                );
                                await Provider.of<MatchProvider>(context,
                                        listen: false)
                                    .refreshMatches();
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'تم الحجز في قائمة الإنتظار')));
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(e.message)));
                              }
                            },
                            title: 'احجز في قائمة الإنتظار',
                          )
                        : Center(
                            child: Text(
                              'تم الحجز في قائمة الإنتظار',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFFD53B3B),
                                fontFamily: 'DINNextLTW23',
                              ),
                            ),
                          ))
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getDate(DateTime dateTime) {
    String date = '${dateTime.day.toString().padLeft(2, '0')}'
        '/${dateTime.month.toString().padLeft(2, '0')}';
    date = '${_getWeekDay(dateTime.weekday)} $date';
    return date;
  }

  String _getWeekDay(int weekDay) {
    switch (weekDay) {
      case 1:
        return 'الاثنين';
      case 2:
        return 'الثلاثاء';
      case 3:
        return 'الأربعاء';
      case 4:
        return 'الخميس';
      case 5:
        return 'الجمعة';
      case 6:
        return 'السبت';
      case 7:
        return 'الأحد';
      default:
        return '';
    }
  }
}
