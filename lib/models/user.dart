import 'package:meta/meta.dart';

class User {
  String token;
  final String name;
  final String mobile;
  final String email;
  final String profileImage;
  final int cityId;
  final int positionId;

  User({
    @required this.token,
    @required this.name,
    @required this.mobile,
    @required this.cityId,
    @required this.positionId,
    this.email,
    this.profileImage,
  });

  factory User.fromJson(Map<String, dynamic> json) {

/*
int jsonCityId;
int jsonPostionId;

dynamic a = json['city_id'];
if (a.runtimeType == int)
  jsonCityId = json['city_id'];
else if (a.runtimeType == String) 
  jsonCityId = int.parse(json['city_id']);


dynamic b = json['player_type_id'];
if (b.runtimeType == int)
 jsonPostionId = json['player_type_id'];
else if (b.runtimeType == String) 
  jsonPostionId = int.parse(json['player_type_id']);
*/

    return User(
      token: json['token'],
      name: json['name'],
      mobile: json['number'],
  //    cityId: jsonCityId,
  //    positionId: jsonPostionId,
      cityId: json['city_id'],
     positionId: json['player_type_id'],
      email: json['email'] ?? '',
      profileImage: json['image'] ?? '',
    );
  }
}
