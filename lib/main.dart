import 'package:dio/dio.dart';
import 'package:elmalaab/data/api_provider.dart';
import 'package:elmalaab/data/local_provider.dart';
import 'package:elmalaab/di.dart';
import 'package:elmalaab/pages/login_page.dart';
import 'package:elmalaab/pages/main_navigation_page.dart';
import 'package:elmalaab/pages/onboarding_page.dart';
import 'package:elmalaab/state/app_provider.dart';
import 'package:elmalaab/state/match_provider.dart';
import 'package:elmalaab/state/sms_code_timer.dart';
import 'package:elmalaab/state/user_provider.dart';
import 'package:elmalaab/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DependencyInjection.init();
  await Firebase.initializeApp();

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, badge: true, sound: true);
  runApp(MetaWidget());
}

class MetaWidget extends StatelessWidget {
  const MetaWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SmsCodeTimer>(create: (_) => SmsCodeTimer()),
        ChangeNotifierProvider<AppProvider>(create: (_) => AppProvider()),
        ChangeNotifierProvider<MatchProvider>(create: (_) => MatchProvider()),
        ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider()),
      ],
      child: App(),
    );
  }
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final GlobalKey<NavigatorState> _navigator = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    initAppttt();
    sl<ApiProvider>().client.interceptors.add(
      InterceptorsWrapper(
        onError: (DioError e, handler) {
          if (e.response?.data
                  ?.toString()
                  ?.toLowerCase()
                  ?.contains('unauthenticated') ??
              false) {
            Provider.of<UserProvider>(context, listen: false).clearUser();
            _navigator.currentState.pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => LoginPage()),
                (route) => false);
          }
          return handler.next(e);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Elmalaab',
      navigatorKey: _navigator,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [const Locale('ar')],
      theme: AppTheme.appTheme,
      home: scaffoldHomeWidget(),
    );
  }

  Widget scaffoldHomeWidget() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      try {
        NotificationSettings settings =
            await FirebaseMessaging.instance.requestPermission();
        if (settings.authorizationStatus == AuthorizationStatus.authorized) {
          final token = await FirebaseMessaging.instance.getToken();
          sl<ApiProvider>().sendNotificationToken(token);
        }
      } catch (e) {}
    });
    if (sl<LocalProvider>().getUser()?.token != null) {
      return MainNavigationPage();
    } else if (sl<LocalProvider>().getOnBoardingShown()) {
      return LoginPage();
    } else {
      return OnboardingPage();
    }
  }

  Future<void> initAppttt() async {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        final appProvider = Provider.of<AppProvider>(context, listen: false);
        appProvider.getAppSettings();

        final userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.readUser();
        userProvider.getCitiesAndPositions();
      },
    );
  }
}
