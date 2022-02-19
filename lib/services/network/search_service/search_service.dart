import 'dart:io';
import 'dart:convert';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:image_search_example/services/environment/environment.dart';
import 'package:image_search_example/services/network/search_service/models/search_response.dart';

import '../network_error.dart';

class SearchService {
  late Dio _dio;
  final String baseUrl = 'https://serpapi.com';

  SearchService._privateConstructor() {
    BaseOptions options = BaseOptions(
      connectTimeout: 10000,
      receiveTimeout: 10000,
      baseUrl: baseUrl
    );
    _dio = Dio(options);
    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      return client;
    };
  }

  static final SearchService _instance = SearchService._privateConstructor();

  static SearchService get instance => _instance;

  Future<SearchResponse> search({required String query, required int offset}) async {
    try {

      final response = await _dio.get('/search.json',
          queryParameters: {
          'engine': 'google',
            'q': query,
            'google_domain': 'google.com',
            'hl': 'en',
            'gl': 'us',
            'ijn': offset.toString(),
            'tbm': 'isch',
          'api_key':Environment.instance.apiKey()},
          options: Options(responseType: ResponseType.plain, headers: {
            Headers.contentTypeHeader: 'application/json; charset=UTF-8'
          }));

      final json = jsonDecode(response.data);
      return SearchResponse.fromJson(json);
    } on DioError catch (e) {
      if (e.response != null) {
        if (e.response!.statusCode! >= 400 && e.response!.statusCode! < 500) {
          final json = jsonDecode(e.response!.data);
          return SearchResponse.error(NetworkError.fromJson(json));
        } else {
          return SearchResponse.error(NetworkError.server());
        }
      }
      return SearchResponse.error(NetworkError.server());
    }
  }
}