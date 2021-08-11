import 'dart:math';

import 'package:elmalaab/models/player.dart';
import 'package:flutter/material.dart';

class ParticipatingPlayersWidget extends StatelessWidget {
  final List<Player> players;
  final bool isCenter;

  const ParticipatingPlayersWidget({
    Key key,
    @required this.players,
    this.isCenter = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int count = min(6, players.length);
    return Container(
      height: 32,
      child: Row(
        mainAxisSize: isCenter ? MainAxisSize.min : MainAxisSize.max,
        children: [
          Container(
            width: count * 20.0 + (16 - (count * 4)),
            child: Stack(
              alignment: Alignment.centerRight,
              children: [
                for (int i = count - 1; i >= 0; i--)
                  Positioned(
                    right: i * 16.0,
                    left: 0,
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: CircleAvatar(
                        radius: 16,
                        backgroundImage: players[i].imageUrl == null
                            ? AssetImage('assets/images/profile.png')
                            : NetworkImage(players[i].imageUrl),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(width: 8),
          if (players.length > 6)
            Text(
              '+${players.length - 6}',
              style: TextStyle(
                fontFamily: 'DINNextLTW23',
                color: Theme.of(context).primaryColor,
                fontSize: 14,
              ),
            ),
        ],
      ),
    );
  }
}
