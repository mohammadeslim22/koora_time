import 'package:meta/meta.dart';

class AppSettings {
  final String twitter;
  final String whatsapp;
  final String terms;
  final String aboutApp;

  AppSettings({
    @required this.twitter,
    @required this.whatsapp,
    @required this.terms,
    @required this.aboutApp,
  });

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      twitter: json['twitter'],
      whatsapp: json['whatsapp_number'],
      terms: json['terms'],
      aboutApp: json['about_us'],
    );
  }
}
