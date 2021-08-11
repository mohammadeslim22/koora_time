import 'package:elmalaab/models/player.dart';
import 'package:flutter/material.dart';

class ParticipatingPlayersPage extends StatelessWidget {
  final List<Player> players;

  const ParticipatingPlayersPage({
    Key key,
    @required this.players,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              'اللاعبون المشتركون',
              style: TextStyle(
                color: Color(0xFF85C23F),
                fontSize: 24,
                fontFamily: 'BeINBlack',
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: players.length,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundImage: NetworkImage(players[index].imageUrl),
                    ),
                    SizedBox(width: 16),
                    Text(
                      players[index].name,
                      style: TextStyle(
                        fontFamily: 'DINNextLTArabic',
                        fontSize: 18,
                        color: Color(0xFF2B4A66),
                      ),
                    ),
                  ],
                );
              },
              separatorBuilder: (context, index) {
                return Divider(height: 12);
              },
            ),
          ),
        ],
      ),
    );
  }
}
