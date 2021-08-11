import 'dart:io';

import 'package:dio/dio.dart';
import 'package:elmalaab/models/app_settings.dart';
import 'package:elmalaab/models/basic_response.dart';
import 'package:elmalaab/models/city.dart';
import 'package:elmalaab/models/match.dart';
import 'package:elmalaab/models/position.dart';
import 'package:elmalaab/models/user.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'dart:convert' show json;
import 'dart:convert';

class ApiProvider {
  final Dio client;

  ApiProvider({@required this.client});

  void setAuthorizationHeader(String token) {
    client.options.headers.addAll({'Authorization': token});
  }

  Future<int> sendLoginPassword({
    @required String mobile,
  }) async {
    try {
      Response response = await client.post(
        '/numbers',
        data: json.encode({
          'content': mobile,
        }),
      );
      return response.data['data']['id'];
    } catch (e) {
      throw Exception(e.response.data['errors']
          [e.response.data['errors'].keys.toList()[0]][0]);
    }
  }

  Future<User> verifyLoginPassword({
    @required int id,
    @required String password,
  }) async {
    try {

print("---id");
print(id);
print("---password" + password);

      Response response = await client.patch(
        '/numbers/$id/verify',
        data: json.encode({
          'verification_code': password,
          'device_name': Platform.isAndroid ? 'android' : 'ios',
        }),
      );

      if (response.data['is_new']) {
        return null;
      } else {
        return User.fromJson(response.data['data']);
      }
    } catch (e) {

      throw Exception(e.response.data['errors']
          [e.response.data['errors'].keys.toList()[0]][0]);
    }
  }

  Future<List<City>> getCities() async {
    try {
      Response response = await client.get('/cities');
      return City.fromJsonList(response.data['data']);
    } catch (e) {
      throw Exception(e.response.data['errors']
          [e.response.data['errors'].keys.toList()[0]][0]);
    }
  }

  Future<List<Position>> getPositions() async {
    try {
      Response response = await client.get('/playerTypes');
      return Position.fromJsonList(response.data['data']);
    } catch (e) {
      throw Exception(e.response.data['errors']
          [e.response.data['errors'].keys.toList()[0]][0]);
    }
  }

  Future<User> registerUser({
    @required int id,
    @required String name,
    @required int cityId,
    @required int positionId,
    File profileImage,
  }) async {
    try {
      final data = {
        'name': name,
        'player_type_id': positionId,
        'city_id': cityId,
        'device_name': Platform.isAndroid ? 'android' : 'ios',
      };
      if (profileImage != null)
        data.addAll({'image': base64Encode(profileImage.readAsBytesSync())});

      Response response = await client.post(
        '/register/$id/varified',
        data: data,
      );
      return User.fromJson(response.data['data']);
    } catch (e) {
      throw Exception(e.response.data['errors']
          [e.response.data['errors'].keys.toList()[0]][0]);
    }
  }

  Future<User> updateUser({
    @required String name,
    String email,
    @required int cityId,
    @required int positionId,
    File profileImage,
  }) async {
    try {
      final data = {
        'name': name,
        'player_type_id': positionId,
        'city_id': cityId,
        'email': email,
      };
      if (profileImage != null)
        data.addAll({'image': base64Encode(profileImage.readAsBytesSync())});

      Response response = await client.post(
        '/profile',
        data: data,
      );
      return User.fromJson(response.data['data']);
    } catch (e) {
  
      throw Exception(e.response.data['errors']
          [e.response.data['errors'].keys.toList()[0]][0]);
    }
  }

  Future<void> sendEnquiry({
    @required String enquiry,
  }) async {
    try {
      await client.post(
        '/applications',
        data: {'content': enquiry},
      );
    } catch (e) {
      throw Exception(e.response.data['errors']
          [e.response.data['errors'].keys.toList()[0]][0]);
    }
  }

  Future<bool> hasRefundedBefore() async {
    try {
      Response response = await client.get('/money-back');
      return response.data['has_money_request'];
    } catch (e) {
      throw Exception(e.response.data['errors']
          [e.response.data['errors'].keys.toList()[0]][0]);
    }
  }

  Future<void> refundRequest() async {
    try {
      await client.post('/money-back');
    } catch (e) {
      throw Exception(e.response.data['errors']
          [e.response.data['errors'].keys.toList()[0]][0]);
    }
  }

  Future<void> sendNotificationToken(String token) async {
    try {
      await client.patch(
        '/tokens',
        data: json.encode({'token': token}),
      );
    } catch (e) {
      throw Exception(e.response.data['errors']
      [e.response.data['errors'].keys.toList()[0]][0]);
    }
  }

  Future<void> sendNotificationStatus(bool notificationStatus) async {
    try {
      await client.patch(
        '/notifications',
        data: json.encode({'notifications_settings': notificationStatus}),
      );
    } catch (e) {
      throw Exception(e.response.data['errors']
          [e.response.data['errors'].keys.toList()[0]][0]);
    }
  }

  Future<bool> getNotificationStatus() async {
    try {
      Response response = await client.get('/notifications');
      return response.data['notifications_settings'];
    } catch (e) {
      throw Exception(e.response.data['errors']
          [e.response.data['errors'].keys.toList()[0]][0]);
    }
  }

  Future<List<FootballMatch>> getMatches() async {
    try {
      Response response = await client.get('/games');



      return FootballMatch.fromJsonList(
          response.data['data'], MatchStatus.NOT_JOINED);
    } catch (e) {
      throw Exception(e.response.data['errors']
          [e.response.data['errors'].keys.toList()[0]][0]);
    }
  }

  Future<FootballMatch> getMatchById(String matchId) async {
    try {
      Response response = await client.get('/games/$matchId');
      return FootballMatch.fromJson(
          response.data['data'], MatchStatus.NOT_JOINED);
    } catch (e) {
      throw Exception(e.response.data['errors'] 
          [e.response.data['errors'].keys.toList()[0]][0]);
    }
  }

  Future<List<FootballMatch>> getMyComingMatches() async {
    try {
      Response response = await client.get('/games/next-games');
      return FootballMatch.fromJsonList(
          response.data['data'], MatchStatus.JOINED_COMING);
    } catch (e) {
      throw Exception(e.response.data['errors']
          [e.response.data['errors'].keys.toList()[0]][0]);
    }
  }

  Future<List<FootballMatch>> getMyPastMatches() async {
    try {
      Response response = await client.get('/games/last-games');
      return FootballMatch.fromJsonList(
          response.data['data'], MatchStatus.JOINED_FINISHED);
    } catch (e) {
      throw Exception(e.response.data['errors']
          [e.response.data['errors'].keys.toList()[0]][0]);
    }
  }

  Future<AppSettings> getAppSettings() async {
    try {
      Response response = await client.get('/settings');
      return AppSettings.fromJson(response.data['data']);
    } catch (e) {
      throw Exception(e.response.data['errors']
          [e.response.data['errors'].keys.toList()[0]][0]);
    }
  }

  Future<String> payAndRegister(
    String cardHolderName,
    String cardNumber,
    int month,
    int year,
    int cvv,
    int matchId,
  ) async {
    try {
      Response response = await client.post('/games/$matchId/join');
      print("-----RES-----");
      print(response);

      if(BasicResponse.fromJson(response.data).success == false && BasicResponse.fromJson(response.data).message != null){
        
        print("--------Already regestired--------");
       throw Exception(BasicResponse.fromJson(response.data).message);

     }

    print("--------NEW REGISTERATION--------");
    String url = BasicResponse.fromJson(response.data).url;
     return url;
   } catch (e) {
      throw Exception(e.response.data['errors']
          [e.response.data['errors'].keys.toList()[0]][0]);
    }
  }


  Future<void> unJoinMatch(int matchId) async {
    try {
      await client.delete('/games/$matchId/out');
    } catch (e) {
      throw Exception(e.response.data['errors']
          [e.response.data['errors'].keys.toList()[0]][0]);
    }
  }
  
}
