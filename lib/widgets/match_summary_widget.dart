import 'package:elmalaab/models/match.dart';
import 'package:elmalaab/utils/custom_date_utils.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MatchSummaryWidget extends StatelessWidget {
  final FootballMatch match;

  const MatchSummaryWidget({
    Key key,
    @required this.match,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Color(0xFFF0F0F0),
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            child: Column(
              children: [
                Text(
                  'موعد المباراة',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF2B4A66),
                    fontFamily: 'DINNextLTW23',
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      CustomDateUtils.getTime(match.dateTime) ?? '',
                      style: TextStyle(
                        fontSize: 24,
                        color: Color(0xFF191919),
                        fontFamily: 'DINNextLTW23',
                      ),
                    ),
                    Text(
                      CustomDateUtils.getTimePeriod(match.dateTime),
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF191919),
                        fontFamily: 'DINNextLTW23',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Theme.of(context).primaryColor,
                      size: 16,
                    ),
                    SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        match.city ?? '',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF191919),
                          fontFamily: 'DINNextLTW23',
                        ),
                      ),
                    ),
                    Spacer(),
                    Icon(
                      Icons.money,
                      color: Theme.of(context).primaryColor,
                      size: 16,
                    ),
                    SizedBox(width: 8),
                    Text(
                      '${match.price} ريال',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF191919),
                        fontFamily: 'DINNextLTW23',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      FontAwesomeIcons.calendarAlt,
                      color: Theme.of(context).primaryColor,
                      size: 14,
                    ),
                    SizedBox(width: 8),
                    Text(
                      CustomDateUtils.getDate(match.dateTime) ?? '',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF191919),
                        fontFamily: 'DINNextLTW23',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      FontAwesomeIcons.users,
                      color: Theme.of(context).primaryColor,
                      size: 14,
                    ),
                    SizedBox(width: 8),
                    Text(
                      '${match.teamSize} لاعب',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF191919),
                        fontFamily: 'DINNextLTW23',
                      ),
                    ),
                    SizedBox(width: 8),
                    if (match.availableSeats > 0)
                      Text(
                        'متبقي ${match.availableSeats} لاعبين',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFFD53B3B),
                          fontFamily: 'DINNextLTW23',
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
