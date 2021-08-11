import 'package:elmalaab/data/api_provider.dart';
import 'package:elmalaab/di.dart';
import 'package:elmalaab/models/match.dart';
import 'package:elmalaab/pages/match_details_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MatchDetailsPageById extends StatefulWidget {
  final String matchId;

  const MatchDetailsPageById({
    Key key,
    @required this.matchId,
  }) : super(key: key);

  @override
  _MatchDetailsPageByIdState createState() => _MatchDetailsPageByIdState();
}

class _MatchDetailsPageByIdState extends State<MatchDetailsPageById> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      try {
        final FootballMatch match =
            await sl<ApiProvider>().getMatchById(widget.matchId);
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => MatchDetailsPage(match: match)));
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.message)));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(
                Theme.of(context).primaryColor)),
      ),
    );
  }
}
