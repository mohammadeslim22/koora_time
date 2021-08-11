import 'package:meta/meta.dart';

class City {
  final int id;
  final String name;

  City({
    @required this.id,
    @required this.name,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'],
      name: json['name'],
    );
  }

  static List<City> fromJsonList(List jsonList) {
    List<City> cities = [];
    jsonList.forEach((city) {
      try {
        cities.add(City.fromJson(city));
      } catch (e) {}
    });
    return cities;
  }
}
