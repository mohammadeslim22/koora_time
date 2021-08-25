import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:io' show Platform;
import 'package:elmalaab/data/api_provider.dart';
import 'package:elmalaab/di.dart';
import 'package:elmalaab/models/match.dart';
import 'package:elmalaab/pages/match_instructions_page.dart';
import 'package:elmalaab/pages/participating_players_page.dart';
import 'package:elmalaab/pages/visa_payment_page.dart';
import 'package:elmalaab/state/match_provider.dart';
import 'package:elmalaab/utils/custom_date_utils.dart';
import 'package:elmalaab/utils/map_utils.dart';
import 'package:elmalaab/widgets/button.dart';
import 'package:elmalaab/widgets/match_summary_widget.dart';
import 'package:elmalaab/widgets/participating_players_widget.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MatchDetailsPage extends StatefulWidget {
  final FootballMatch match;

  const MatchDetailsPage({
    Key key,
    @required this.match,
  }) : super(key: key);

  @override
  State<MatchDetailsPage> createState() => _MatchDetailsPage();
}

class _MatchDetailsPage extends State<MatchDetailsPage> {
  FootballMatch match;
  String buttonTitle = 'انضم الآن';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    match = widget.match;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          if (!kIsWeb && (Platform.isIOS || Platform.isAndroid))
            IconButton(
              icon: Icon(Icons.share),
              onPressed: () {
                _shareMatch();
              },
              color: Color(0xFF2B4A66),
            ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              'تفاصيل المباراة',
              style: TextStyle(
                color: Color(0xFF85C23F),
                fontSize: 24,
                fontFamily: 'BeINBlack',
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(32)),
                    ),
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      match.playgroundName ?? '',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'DINNextLTW23',
                        fontSize: 14,
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  MatchSummaryWidget(match: match),
                  SizedBox(height: 12),
                  Divider(height: 0),
                  ListTile(
                    contentPadding: const EdgeInsets.all(0),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => ParticipatingPlayersPage(
                              players: match.players)));
                    },
                    title: Row(
                      children: [
                        Flexible(
                          child: ParticipatingPlayersWidget(
                              players: match.players),
                        ),
                        SizedBox(width: 16),
                        Text(
                          'الإطلاع على المشتركين',
                          style: TextStyle(
                            color: Color(0xFF2B4A66),
                            fontFamily: 'DINNextLTW23',
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Color(0xFF2B4A66),
                    ),
                  ),
                  Divider(height: 0),
                  ListTile(
                    contentPadding: const EdgeInsets.all(0),
                    title: Row(
                      children: [
                        Text(
                          'المباراة تحت تنظيم: ',
                          style: TextStyle(
                            color: Color(0xFF2B4A66),
                            fontFamily: 'DINNextLTW23',
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          match.organizer ?? '',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontFamily: 'DINNextLTW23',
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(height: 0),
                  ListTile(
                    contentPadding: const EdgeInsets.all(0),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => MatchInstructionsPage(
                              instructions: match.instructions)));
                    },
                    title: Text(
                      'الإطلاع على التعليمات',
                      style: TextStyle(
                        color: Color(0xFF2B4A66),
                        fontFamily: 'DINNextLTW23',
                        fontSize: 14,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Color(0xFF2B4A66),
                    ),
                  ),
                  Divider(height: 0),
                  if (match.playgroundLocation != null)
                    ListTile(
                      contentPadding: const EdgeInsets.all(0),
                      onTap: () {
                        print(
                            "match.playgroundLocation.lat ${match.playgroundLocation.lat} match.playgroundLocation.lng ${match.playgroundLocation.lng}");
                        MapUtils.openMap(
                          match.playgroundLocation.lat,
                          match.playgroundLocation.lng,
                        );
                      },
                      title: Row(
                        children: [
                          Text(
                            'موقع ملعب المباراة',
                            style: TextStyle(
                              color: Color(0xFF2B4A66),
                              fontFamily: 'DINNextLTW23',
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(width: 12),
                          Icon(
                            Icons.location_on,
                            color: Theme.of(context).primaryColor,
                            size: 16,
                          ),
                        ],
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Color(0xFF2B4A66),
                      ),
                    ),
                  Divider(height: 0),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: bottomWidget(context),
    );
  }

  Future<void> _shareMatch() async {
    try {
      final DynamicLinkParameters parameters = DynamicLinkParameters(
        uriPrefix: 'https://elmalaab.page.link/match',
        //  link: Uri.parse('https://google.com/match/${match.id}'),
        link: Uri.parse('https://kooratime.net'),
        androidParameters: AndroidParameters(
          packageName: 'com.abdullah.koratime',
          minimumVersion: 1,
        ),
        iosParameters: IosParameters(
          bundleId: 'com.abdullah.malaab',
          minimumVersion: '1.0.0',
//        appStoreId: '123456789',
        ),
      );

      //  final ShortDynamicLink shortDynamicLink = await parameters.buildShortLink();
      //  final Uri shortUrl = shortDynamicLink.shortUrl;

      final Uri dynamicUrl = await parameters.buildUrl();
      final Uri shortUrl = dynamicUrl;

      Share.share(
          'لقد تمت دعوتك للمشاركة في التمرين يوم ${CustomDateUtils.getWeekDay(match.dateTime.weekday)} الساعة ${CustomDateUtils.getTime(match.dateTime)} ${CustomDateUtils.getTimePeriod(match.dateTime)} في ${match.playgroundName}'
          '\nشارك واستمتع باللعب معنا'
          '\n${shortUrl.toString()}');
    } catch (e) {
      print(e);
      Share.share(
          'لقد تمت دعوتك للمشاركة في التمرين يوم ${CustomDateUtils.getWeekDay(match.dateTime.weekday)} الساعة ${CustomDateUtils.getTime(match.dateTime)} ${CustomDateUtils.getTimePeriod(match.dateTime)} في ${match.playgroundName}'
          '\nشارك واستمتع باللعب معنا'
          '\n https://kooratime.net');
    }
  }

  Widget bottomWidget(BuildContext _context) {
    if (match.matchStatus == MatchStatus.NOT_JOINED) {
      if (match.availableSeats > 0) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Button(
            onPressed: buttonTitle.contains('انضم الآن')
                ? () async {
                    showModalBottomSheet(
                        context: _context,
                        shape: ContinuousRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(32))),
                        builder: (context) {
                          return Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Center(
                                  child: Image.asset(
                                    'assets/images/vectorpayment.png',
                                    height: 100,
                                  ),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'الإنضمام',
                                  style: TextStyle(
                                    fontFamily: 'DINNextLTArabic',
                                    fontSize: 14,
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'ودفع ${match.price} ريال',
                                  style: TextStyle(
                                    fontFamily: 'DINNextLTArabic',
                                    fontSize: 14,
                                    color: Color(0xFF191919),
                                  ),
                                ),
                                SizedBox(height: 16),
                                ListTile(
                                  title: Text(
                                    ' فيزا او مدى',
                                    style: TextStyle(
                                      color: Color(0xFF191919),
                                      fontFamily: 'DINNextLTArabic',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      buttonTitle = "الرجاء الانتظار...";
                                    });
                                    Navigator.pop(context);
                                    //   Navigator.of(context).push(MaterialPageRoute(
                                    //       builder: (_) => VisaPaymentPage(
                                    //            matchId: match.id, price: match.price)));
                                    payment(match.id, _context);
                                  },
                                ),
                                Divider(height: 1),
                                //  Platform.isIOS ? ListTile(
                                //   title: Text(
                                //     'دفع Apple Pay',
                                //     style: TextStyle(
                                //       color: Color(0xFF191919),
                                //       fontFamily: 'DINNextLTArabic',
                                //       fontSize: 16,
                                //       fontWeight: FontWeight.w500,
                                //     ),
                                //   ),
                                //   onTap: () {
                                //     Navigator.pop(context);
                                //   },
                                // ): Divider(height: 0),
                                Divider(height: 1),
                                ListTile(
                                  title: Center(
                                    child: Text(
                                      'إلغاء',
                                      style: TextStyle(
                                        color: Color(0xFFB15353),
                                        fontFamily: 'DINNextLTArabic',
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          );
                        });
                  }
                : null,
            title: buttonTitle,
          ),
        );
      } else {
        return Container(
          color: Color(0x0FD53B3B),
          alignment: Alignment.center,
          height: 48,
          padding: const EdgeInsets.all(8),
          child: Text(
            'محجوز بالكامل',
            style: TextStyle(
              color: Color(0xFFD53B3B),
              fontSize: 16,
              fontFamily: 'DINNextLTArabic',
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }
    }
    if (match.matchStatus == MatchStatus.JOINED_COMING) {
      return _UnJoinButton(matchId: match.id);
    }
    if (match.matchStatus == MatchStatus.JOINED_FINISHED) {
      return Container(
        color: Color(0x0FD53B3B),
        alignment: Alignment.center,
        height: 48,
        padding: const EdgeInsets.all(8),
        child: Text(
          'منتهية',
          style: TextStyle(
            color: Color(0xFFD53B3B),
            fontSize: 16,
            fontFamily: 'DINNextLTArabic',
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }
    return null;
  }

  void payment(int matchId, BuildContext context) async {
    try {
      String paymentUrl = await sl<ApiProvider>()
          .payAndRegister('temp', 'temp', 1, 1, 1, match.id);
      String url = paymentUrl.replaceAll("/", "").replaceAll('"', '');
      print("paymentUrl = " + url);

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => YourWebView(url)));

      Future.delayed(
          Duration(seconds: 1),
          () => {
                setState(() {
                  buttonTitle = 'انضم الآن';
                })
              });
    } catch (e) {
      print("paymentUrl =  Err -------");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }
}

class _UnJoinButton extends StatefulWidget {
  const _UnJoinButton({
    Key key,
    @required this.matchId,
  }) : super(key: key);

  final int matchId;

  @override
  _UnJoinButtonState createState() => _UnJoinButtonState();
}

class _UnJoinButtonState extends State<_UnJoinButton> {
  bool isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GestureDetector(
        onTap: () async {
          setState(() {
            isProcessing = true;
          });
          try {
            await sl<ApiProvider>().unJoinMatch(widget.matchId);
            await Provider.of<MatchProvider>(context, listen: false)
                .getMyComingMatches();
            Navigator.of(context).pop();
          } catch (e) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(e.message)));
          } finally {
            setState(() {
              isProcessing = false;
            });
          }
        },
        child: isProcessing
            ? Container(
                height: 64,
                width: 64,
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        new AlwaysStoppedAnimation<Color>(Color(0xFFD53B3B)),
                  ),
                ),
              )
            : Chip(
                label: Text(
                  'إلغاء الإنضمام',
                  style: TextStyle(
                    color: Color(0xFFD53B3B),
                    fontSize: 16,
                    fontFamily: 'DINNextLTArabic',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                padding: const EdgeInsets.all(8),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32))),
                backgroundColor: Color(0x0FD53B3B),
              ),
      ),
    );
  }
}

class YourWebView extends StatelessWidget {
  String url;
  bool isFinshed = false;

  YourWebView(this.url);

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('اكمال عملية الدفع..'),
          leading: new IconButton(
              icon: new Icon(Icons.close),
              onPressed: () {
                if (isFinshed) {
                  Provider.of<MatchProvider>(context, listen: false)
                      .getMyComingMatches();
                  Navigator.of(context).popUntil((route) => route.isFirst);
                } else {
                  Navigator.pop(context);
                }
              }),
        ),
        body: Builder(builder: (BuildContext context) {
          return WebView(
            initialUrl: url.replaceAll("\\",
                "/"), //Uri.encodeFull(url.replaceFirst("\\", "//")), //url.replaceFirst("//", "\\"), //'about:blank', //Uri.encodeFull(url),
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
              // webViewController.loadUrl(Uri.encodeFull(url));
              print("----URL---" + url);
              print("----URL-REPLACE--" + url.replaceAll("\\", "/"));
            },
            debuggingEnabled: true,
            onPageFinished: (String url) {
              //https://justdemo.almusand.com/tap/check?tap_id=chg_TS051620211200c9KQ1406099
              SystemChannels.textInput.invokeMethod('TextInput.hide');

              if (url.contains("tap/check?tap_id")) {
                isFinshed = true;
              }
              print('Page finished loading: $url');
            },
            gestureRecognizers: null,
            //  gestureNavigationEnabled: false
          );
        }));
  }

  _loadHtmlFromAssets(WebViewController webViewController, String url) async {
    webViewController.loadUrl(Uri.dataFromString(loadHtml(url),
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
  }

  String loadHtml(String url) {
    String pageHeader =
        '<meta name="viewport" content="initial-scale=1.0, maximum-scale=1.0">';
    String html =
        '<div style="display:flex;" ><iframe style="flex: 1; border: none;" src="${url}" seamless></iframe></div>';

    return html;
  }
}

//class YourWebView extends StatelessWidget {
//   String url;
//   bool isFinshed = false;
//   YourWebView(this.url);

//   InAppWebViewController webViewController;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text('اكمال عملية الدفع..'),
//           leading: new IconButton(
//               icon: new Icon(Icons.close),
//               onPressed: () {

//               if(isFinshed) {
//                       Provider.of<MatchProvider>(context, listen: false)
//                               .getMyComingMatches();
//                         Navigator.of(context).popUntil((route) => route.isFirst);
//               } else {

//                 Navigator.pop(context);
//               }

//               }),
//         ),
//         body: Builder(builder: (BuildContext context) {
//           return InAppWebView(
//             initialUrlRequest: URLRequest(url: Uri.parse(url)),
//             onWebViewCreated: (controller) {
//                           webViewController = controller;
//             },

//             // onPageFinished: (String url) {
//             //   //https://justdemo.almusand.com/tap/check?tap_id=chg_TS051620211200c9KQ1406099
//             //   SystemChannels.textInput.invokeMethod('TextInput.hide');

//             //   if (url.contains("tap/check?tap_id")) {

//             //          isFinshed = true;
//             //   }
//             //   print('Page finished loading: $url');
//             // },
//             gestureRecognizers: null,
//           //  gestureNavigationEnabled: false
//           );
//         }));
//   }
// }
