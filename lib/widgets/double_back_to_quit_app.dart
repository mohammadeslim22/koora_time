import 'dart:async';

import 'package:flutter/material.dart';

class DoubleBackToQuitApp extends StatefulWidget {
  final Widget child;

  const DoubleBackToQuitApp({
    Key key,
    @required this.child,
  })  : assert(child != null),
        super(key: key);

  @override
  _DoubleBackToQuitAppState createState() => _DoubleBackToQuitAppState();
}

class _DoubleBackToQuitAppState extends State<DoubleBackToQuitApp> {
  DateTime _lastTimeBackButtonWasTapped;

  bool get _isAndroid => Theme.of(context).platform == TargetPlatform.android;

  bool get _isSnackBarVisible =>
      (_lastTimeBackButtonWasTapped != null) &&
      (Duration(seconds: 2) >
          DateTime.now().difference(_lastTimeBackButtonWasTapped));

  bool get _willHandlePopInternally =>
      ModalRoute.of(context).willHandlePopInternally;

  @override
  Widget build(BuildContext context) {
    if (_isAndroid) {
      return WillPopScope(
        onWillPop: _handleWillPop,
        child: widget.child,
      );
    } else {
      return widget.child;
    }
  }

  Future<bool> _handleWillPop() async {
    if (_isSnackBarVisible || _willHandlePopInternally) {
      return true;
    } else {
      _lastTimeBackButtonWasTapped = DateTime.now();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('اضغط مرة أخرى للخروج من التطبيق'),
        duration: Duration(seconds: 2),
      ));
      return false;
    }
  }
}
