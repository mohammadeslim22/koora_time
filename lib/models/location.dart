import 'package:meta/meta.dart';

class Location {
  final double lat;
  final double lng;

  Location({
    @required this.lat,
    @required this.lng,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return Location(
      lat: json['lat'],
      lng: json['lng'],
    );
  }
}
