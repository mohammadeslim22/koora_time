import 'dart:io';

import 'package:elmalaab/data/api_provider.dart';
import 'package:elmalaab/data/local_provider.dart';
import 'package:elmalaab/di.dart';
import 'package:elmalaab/models/city.dart';
import 'package:elmalaab/models/position.dart';
import 'package:elmalaab/models/user.dart';
import 'package:flutter/foundation.dart';

class UserProvider with ChangeNotifier {
  User _user;
  List<City> _cities;
  List<Position> _positions;
  bool _hasRefundBefore = true;
  bool _notificationStatus = true;
  bool _isLoadingUser = false;

  User get user => _user;

  List<City> get cities => _cities;

  List<Position> get positions => _positions;

  bool get isLoadingUser => _isLoadingUser;

  bool get hasRefundBefore => _hasRefundBefore;

  bool get notificationStatus => _notificationStatus;

  Future<void> readUser() async {
    final localUser = sl<LocalProvider>().getUser();
    sl<ApiProvider>().setAuthorizationHeader('Bearer ${localUser.token}');
    if (localUser != null) {
      _user = localUser;
      notifyListeners();
    }
  }

  Future<void> setUser(User user) async {
    try {
      await sl<LocalProvider>().setUser(user);
      sl<ApiProvider>().setAuthorizationHeader('Bearer ${user.token}');
      _user = user;
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> registerUser({
    int id,
    String name,
    File profileImage,
    int cityId,
    int positionId,
  }) async {
    try {
      final tempUser = await sl<ApiProvider>().registerUser(
        id: id,
        name: name,
        cityId: cityId,
        positionId: positionId,
        profileImage: profileImage,
      );
      sl<ApiProvider>().setAuthorizationHeader('Bearer ${tempUser.token}');
      await sl<LocalProvider>().setUser(tempUser);
      _user = tempUser;
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> updateUser({
    String name,
    String email,
    File profileImage,
    int cityId,
    int positionId,
  }) async {
    try {
      final tempUser = await sl<ApiProvider>().updateUser(
        name: name,
        email: email,
        profileImage: profileImage,
        cityId: cityId,
        positionId: positionId,
      );
    
      tempUser.token = _user.token;
      
      await sl<LocalProvider>().setUser(tempUser);
      _user = tempUser;
      notifyListeners();
    } catch (e) {
     
      throw e;
    }
  }

  Future<void> getHasRefundBefore() async {
    _hasRefundBefore = await sl<ApiProvider>().hasRefundedBefore();
    notifyListeners();
  }

  Future<void> refundRequest() async {
    await sl<ApiProvider>().refundRequest();
    await getHasRefundBefore();
  }

  Future<void> getNotificationStatus() async {
    _notificationStatus = await sl<ApiProvider>().getNotificationStatus();
    notifyListeners();
  }

  Future<void> updateNotificationStatus(bool status) async {
    await sl<ApiProvider>().sendNotificationStatus(status);
    await getNotificationStatus();
  }

  Future<void> getCitiesAndPositions() async {
    _cities = await sl<ApiProvider>().getCities();
    _positions = await sl<ApiProvider>().getPositions();
    notifyListeners();
  }

  Future<void> clearUser() async {
    sl<LocalProvider>().clearCreditCard();
    sl<LocalProvider>().clearUser();
    sl<ApiProvider>().client.options.headers.remove('Authorization');
    _user = null;
    notifyListeners();
  }
}
