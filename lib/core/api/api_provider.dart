import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart' as rb;

import '../../main.dart';
import '../utils/storage_util.dart';

class ApiProvider {
  final Dio _dio;

  ApiProvider({String? baseUrl})
      : _dio = Dio(
          BaseOptions(
            baseUrl: baseUrl ?? 'https://api-trackmate-bribox-stg.bitcorp.id',
            connectTimeout: const Duration(seconds: 50),
            receiveTimeout: const Duration(seconds: 30),
          ),
        ) {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        if (!await _hasInternetConnection()) {
          return handler.reject(DioException(
            requestOptions: options,
            error: 'No Internet Connection',
            type: DioExceptionType.connectionError,
          ));
        }

        final token = await StorageUtil.getToken();

        kLogger.w("Endpoint => ${options.baseUrl}${options.path}");
        kLogger.w("Query Param => ${options.queryParameters}"); // Check if the body is of type FormData
        if (options.data is FormData) {
          final formData = options.data as FormData;
          kLogger.w("FormData Fields:");
          for (var field in formData.fields) {
            kLogger.w("${field.key} => ${field.value}");
          }
          kLogger.w("FormData Files:");
          for (var file in formData.files) {
            kLogger.w("${file.key} => ${file.value.filename}");
          }
        } else {
          kLogger.w("Body => ${options.data}");
        }

        if (token != null) {
          kLogger.w("Bearer Token => ${token.trim()}");
          options.headers['Authorization'] = 'Bearer $token';
        }

        options.headers['Content-Type'] = 'application/json';

        return handler.next(options);
      },
      onResponse: (response, handler) {
        kLogger.i("Endpoint => ${response.requestOptions.baseUrl}${response.requestOptions.path}");
        kLogger.i("Message => ${response.statusMessage}");
        kLogger.i("Code => ${response.statusCode}");
        kLogger.i("Data => ${response.data}");
        return handler.next(response);
      },
      onError: (error, handler) async {
        kLogger.e("Error Response", error: error.response);
        kLogger.e("Error Message", error: error.message);
        kLogger.e("Error", error: error.error);

        if (error.response?.statusCode == 401) {
          final token = await StorageUtil.getToken();
          final isTokenRefreshed = await _refreshToken();
          if (isTokenRefreshed) {
            final retryOptions = error.requestOptions;
            retryOptions.headers['Authorization'] = 'Bearer $token';
            final retryResponse = await _dio.request(
              retryOptions.path,
              options: Options(
                method: retryOptions.method,
                headers: retryOptions.headers,
              ),
              data: retryOptions.data,
              queryParameters: retryOptions.queryParameters,
            );
            return handler.resolve(retryResponse);
          }
        } else if (error.response?.statusCode == 500 || error.response?.statusCode == 503) {
          kLogger.e("Server error, please try again later.");
        } else if (error.response?.statusCode == 404) {
          kLogger.e("Resource not found.");
        } else if (error.response?.statusCode == 400) {
          kLogger.e("Bad request, check the request parameters.");
        }
        return handler.next(error);
      },
    ));
  }

  Future<Response> post(
    String path, {
    Map<String, dynamic>? mapData,
    FormData? formData,
    bool mock = false,
  }) async {
    if (mock) {
      return _getMockResponse(path);
    }

    final Object? payload = formData ?? mapData;
    if (payload == null) {
      throw ArgumentError('Both mapData and formData cannot be null');
    }

    return await _dio.post(path, data: payload);
  }

  Future<Response> put(
    String path, {
    Map<String, dynamic>? data,
    bool mock = false,
  }) async {
    if (mock) {
      return _getMockResponse(path);
    }
    return await _dio.put(path, data: data);
  }

  Future<Response> get(
    String path, {
    bool mock = false,
  }) async {
    if (mock) {
      return _getMockResponse(path);
    }
    return await _dio.get(path);
  }

  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await StorageUtil.getRefreshToken();
      if (refreshToken == null) return false;

      final response = await _dio.post('/auth/api/v1/auth/refresh', data: {
        'refresh_token': refreshToken,
      });

      final newAccessToken = response.data['access_token'];
      final newRefreshToken = response.data['refresh_token'];

      await StorageUtil.saveToken(newAccessToken);
      await StorageUtil.saveRefreshToken(newRefreshToken);

      return true;
    } catch (e) {
      kLogger.e("Error refreshing token: $e");
      return false;
    }
  }

  Future<Response> _getMockResponse(String path) async {
    final mockData = await _loadMockData(path);
    return Response(
      data: mockData,
      statusCode: 200,
      requestOptions: RequestOptions(path: path),
    );
  }

  Future<dynamic> _loadMockData(String path) async {
    String jsonString = await _loadAsset(path);
    return jsonDecode(jsonString);
  }

  Future<String> _loadAsset(String path) async {
    String assetPath = _getMockAssetPath(path);
    return await rb.rootBundle.loadString(assetPath);
  }

  /// the function uses [path] to get the mockup response by enpoint
  String _getMockAssetPath(String path) {
    switch (path) {
      case '/login':
        return 'assets/mocks/login_mock.json';
      case '/user/profile':
        return 'assets/mocks/user_profile_mock.json';
      case '/core/api/v1/workorder-pm/engineer/findall':
        return 'assets/mocks/pm_tickets_mock.json';
      default:
        return 'assets/mocks/error_mock.json';
    }
  }

  Future<bool> _hasInternetConnection() async {
    final List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.wifi) || connectivityResult.contains(ConnectivityResult.mobile)) {
      return true;
    }
    return false;
  }
}
