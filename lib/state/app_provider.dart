import 'package:elmalaab/data/api_provider.dart';
import 'package:elmalaab/di.dart';
import 'package:elmalaab/models/app_settings.dart';
import 'package:flutter/foundation.dart';

class AppProvider with ChangeNotifier {
  AppSettings _appSettings;
  bool _isLoading = false;

  AppSettings get appSettings => _appSettings;

  bool get isLoading => _isLoading;

  Future<void> getAppSettings() async {
    _isLoading = true;
    notifyListeners();
    _appSettings = await sl<ApiProvider>().getAppSettings();
    _isLoading = false;
    notifyListeners();
  }
}
