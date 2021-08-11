import 'package:elmalaab/models/location.dart';
import 'package:elmalaab/models/player.dart';
import 'package:meta/meta.dart';

enum MatchStatus {
  NOT_JOINED,
  JOINED_COMING,
  JOINED_FINISHED,
}

class FootballMatch {
  final int id;
  final String playgroundName;
  final Location playgroundLocation;
  final String organizer;
  final String instructions;
  final DateTime dateTime;
  final int type;
  final String city;
  final int price;
  final int teamSize;
  final int availableSeats;
  final MatchStatus matchStatus;
  final List<Player> players;

  FootballMatch({
    @required this.id,
    @required this.playgroundName,
    @required this.playgroundLocation,
    @required this.organizer,
    @required this.instructions,
    @required this.dateTime,
    @required this.type,
    @required this.city,
    @required this.price,
    @required this.teamSize,
    @required this.availableSeats,
    @required this.matchStatus,
    @required this.players,
  });

  factory FootballMatch.fromJson(
      Map<String, dynamic> json, MatchStatus matchStatus) {
    return FootballMatch(
      id: json['id'],
      playgroundName: json['playground_name'],
      playgroundLocation: Location.fromJson(json['location']),
      organizer: json['organizer'],
      instructions: json['description'],
      city: json['city_name'],
      price: json['fees'],
      teamSize: json['max_players'],
      availableSeats: json['max_players'] - json['number_of_players'],
      players: Player.fromJsonList(json['players']),
      matchStatus: matchStatus,
      dateTime: DateTime.parse(json['original_time']).toLocal(),
      type: json['type'],
    );
  }

  static List<FootballMatch> fromJsonList(
      List jsonList, MatchStatus matchStatus) {
    List<FootballMatch> matches = [];
    jsonList.forEach((match) {
      try {
        matches.add(FootballMatch.fromJson(match, matchStatus));
      } catch (e) {}
    });
    return matches;
  }
}
