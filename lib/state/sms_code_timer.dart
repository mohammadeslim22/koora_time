import 'dart:async';

import 'package:flutter/foundation.dart';

class SmsCodeTimer with ChangeNotifier {
  int _time = 0;

  SmsCodeTimer();

  int get time => _time;

  bool isDone() {
    return _time == 0;
  }

  void startCodeTimer() {
    if (!isDone()) {
      return;
    }
    _time = 59;
    notifyListeners();
    Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        if (_time == 0) {
          timer.cancel();
        } else {
          _time--;
        }
        notifyListeners();
      },
    );
  }
}
