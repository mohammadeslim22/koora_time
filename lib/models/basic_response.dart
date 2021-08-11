import 'package:meta/meta.dart';

class BasicResponse {
  final bool success;
  final String url;
  final String message;

  BasicResponse({
    @required this.success,
    @required this.url,
     @required this.message
  });

    factory BasicResponse.fromJson(Map<String, dynamic> json) {
    return BasicResponse(
      success: json['success'],
      url: json['url'],
      message: json['message']
    );
  }

}
