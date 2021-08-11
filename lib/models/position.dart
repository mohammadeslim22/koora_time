import 'package:meta/meta.dart';

class Position {
  final int id;
  final String name;

  Position({
    @required this.id,
    @required this.name,
  });

  factory Position.fromJson(Map<String, dynamic> json) {
    return Position(
      id: json['id'],
      name: json['name'],
    );
  }

  static List<Position> fromJsonList(List jsonList) {
    List<Position> positions = [];
    jsonList.forEach((position) {
      try {
        positions.add(Position.fromJson(position));
      } catch (e) {}
    });
    return positions;
  }
}
