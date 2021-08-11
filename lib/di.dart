import 'package:dio/dio.dart';
import 'package:elmalaab/data/api_provider.dart';
import 'package:elmalaab/data/local_provider.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

GetIt sl = GetIt.instance;

class DependencyInjection {
  static Future<void> init() async {
    sl.registerLazySingleton<LocalProvider>(
        () => LocalProvider(sharedPreferences: sl()));

    sl.registerLazySingleton<ApiProvider>(() => ApiProvider(client: sl()));

    final sharedPreferences = await SharedPreferences.getInstance();
    sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

    const String _apiUrl = 'https://kooratime.net/api';
    Dio client = Dio(
      BaseOptions(
        baseUrl: _apiUrl,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': sl<LocalProvider>().getUser().token,
          'x-api-key': '123',
        },
      ),
    );
    client.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        print('Start Request------------------------------------------------');
        print(options.uri);
        print(options.headers);
        print(options.data);
        print('End------------------------------------------------');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        print('Start Response------------------------------------------------');
        print(response.realUri);
        print(response.data);
        print('End------------------------------------------------');
        return handler.next(response);
      },
      onError: (DioError e, handler) {
        print('Start Error------------------------------------------------');
        print(e.response.realUri);
        print(e.response.data);
        print('End------------------------------------------------');
        return handler.next(e);
      },
    ));

    sl.registerLazySingleton<Dio>(() => client);
  }
}
