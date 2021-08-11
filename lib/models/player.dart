import 'package:meta/meta.dart';

class Player {
  final int id;
  final String imageUrl;
  final String number;
  final String name;

  Player({
    @required this.id,
    @required this.imageUrl,
    @required this.number,
    @required this.name,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'],
      name: json['name'],
      imageUrl: json['image'],
      number: json['number'],
    );
  }

  static List<Player> fromJsonList(List jsonList) {
    List<Player> players = [];
    jsonList.forEach((player) {
      try {
        players.add(Player.fromJson(player));
      } catch (e) {}
    });
    return players;
  }
}
