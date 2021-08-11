import 'dart:collection';

import 'package:elmalaab/data/api_provider.dart';
import 'package:elmalaab/di.dart';
import 'package:elmalaab/models/match.dart';
import 'package:flutter/foundation.dart';

class MatchProvider with ChangeNotifier {
  List<FootballMatch> _matches = [];
  SplayTreeMap<DateTime, List<FootballMatch>> _matchesMap =
      SplayTreeMap<DateTime, List<FootballMatch>>();
  List<FootballMatch> _myComingMatches = [];
  List<FootballMatch> _myPastMatches = [];
  bool _isLoadingMatches = false;
  bool _isLoadingComingMatches = false;
  bool _isLoadingPastMatches = false;

  SplayTreeMap<DateTime, List<FootballMatch>> get matchesMap => _matchesMap;

  List<FootballMatch> get myComingMatches => _myComingMatches;

  List<FootballMatch> get myPastMatches => _myPastMatches;

  bool get isLoadingMatches => _isLoadingMatches;

  bool get isLoadingComingMatches => _isLoadingComingMatches;

  bool get isLoadingPastMatches => _isLoadingPastMatches;

  Future<void> getMatches() async {
    _isLoadingMatches = true;
    notifyListeners();
    _matches = await sl<ApiProvider>().getMatches();
    _matchesMap.clear();
    for (var match in _matches) {
      if (_matchesMap[match.dateTime] == null)
        _matchesMap[match.dateTime] = <FootballMatch>[];
      _matchesMap[match.dateTime].add(match);
    }
    _isLoadingMatches = false;
    notifyListeners();
  }

  Future<void> refreshMatches() async {
    _matches = await sl<ApiProvider>().getMatches();
    _matchesMap.clear();
    for (var match in _matches) {
      if (_matchesMap[match.dateTime] == null)
        _matchesMap[match.dateTime] = <FootballMatch>[];
      _matchesMap[match.dateTime].add(match);
    }
    _isLoadingMatches = false;
    notifyListeners();
  }

  Future<void> getMyComingMatches() async {
    _isLoadingComingMatches = true;
    notifyListeners();
    _myComingMatches = await sl<ApiProvider>().getMyComingMatches();
    _isLoadingComingMatches = false;
    notifyListeners();
  }

  Future<void> refreshMyComingMatches() async {
    _myComingMatches = await sl<ApiProvider>().getMyComingMatches();
    _isLoadingComingMatches = false;
    notifyListeners();
  }

  Future<void> getMyPastMatches() async {
    _isLoadingPastMatches = true;
    notifyListeners();
    _myPastMatches = await sl<ApiProvider>().getMyPastMatches();
    _isLoadingPastMatches = false;
    notifyListeners();
  }

  Future<void> refreshMyPastMatches() async {
    _myPastMatches = await sl<ApiProvider>().getMyPastMatches();
    _isLoadingPastMatches = false;
    notifyListeners();
  }
}
