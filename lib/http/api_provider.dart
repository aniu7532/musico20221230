// ignore_for_file: parameter_assignments

import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:musico/app/myapp.dart';
import 'package:musico/const/app_data.dart';
import 'package:musico/http/api_response.dart';
import 'package:musico/http/app_exception.dart';
import 'package:musico/http/interceptor/dio_connectivity_request_retrier.dart';
import 'package:musico/http/interceptor/retry_interceptor.dart';
import 'package:musico/http/model/base_bean.dart';
import 'package:musico/http/repository/token_repository.dart';
import 'package:musico/utils/toast_util.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

enum ContentType { urlEncoded, json }

class ApiModel {
  factory ApiModel() => _instance;

  ApiModel._() {
    initDio();
  }

  static late final ApiModel _instance = ApiModel._();

  late Dio _dio;
  late String _baseUrl;
  final TokenModel _tokenModel = TokenModel();

  void initDio() {
    _dio = Dio();
    _dio.options.sendTimeout = 15000;
    _dio.options.connectTimeout = 15000;
    _dio.options.receiveTimeout = 60000;
    _dio.interceptors.add(
      RetryOnConnectionChangeInterceptor(
        requestRetrier: DioConnectivityRequestRetrier(
          dio: _dio,
          connectivity: Connectivity(),
        ),
      ),
    );

    _dio.httpClientAdapter = DefaultHttpClientAdapter();

    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      // final production = dotenv.get('IS_PRODUCTION');
      // final proxy = dotenv.get('proxy');
      // if ((production == '0' || production == '1') &&
      //     ObjectUtil.isNotEmpty(proxy)) {
      //   client.findProxy = (uri) => 'PROXY $proxy';
      // }
    };

    if (kDebugMode) {
      _dio.interceptors.add(
        PrettyDioLogger(
          request: false,
          // requestHeader: true,
          // responseHeader: true,
          responseBody: false,
        ),
      );
    }

    if (dotenv.env['BASE_URL'] != null) {
      _baseUrl = dotenv.env['BASE_URL']!;
    }
  }

  Future<APIResponse> post(
    String path,
    dynamic body, {
    String? newBaseUrl,
    String? token,
    Map<String, String?>? params,
    ContentType contentType = ContentType.json,
    CancelToken? cancelToken,
    bool loginOutWhenTokenOutOfTime = true,
    String preventRepeatKey = '',
  }) async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return APIResponse.error(
        AppException.errorWithBean(BaseBean(message: '网络异常')),
      );
    }
    String url;

    if (newBaseUrl != null) {
      url = newBaseUrl + path;
    } else {
      url = _baseUrl + path;
    }
/*//单个接口调试
    if (path.contains('http')) {
      url = path;
    }*/

    var content = 'application/x-www-form-urlencoded';

    if (contentType == ContentType.json) {
      content = 'application/json';
    }

    try {
      final headers = {
        'Accept': 'application/json,text/plain,*/*',
        'Content-Type': content,
      };
      final _appToken = await _tokenModel.fetchToken();
      if (_appToken != null) {
        headers['Authorization'] = 'Bearer ${_appToken.token}';
      }
      //Sometime for some specific endpoint it may require to use different Token
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }

      if (ObjectUtil.isNotEmpty(preventRepeatKey)) {
        headers['prevent-repeat-key'] = preventRepeatKey;
      }

      final response = await _dio.post(
        url,
        data: body,
        queryParameters: params,
        options: Options(validateStatus: (status) => true, headers: headers),
        cancelToken: cancelToken,
      );

      if (response.statusCode == null) {
        return APIResponse.error(
          AppException.errorWithBean(BaseBean(message: '网络异常')),
        );
      }
      if (kDebugMode && AppData.useResponseBodyLog) {
        log('------>>> url:  $url');
        log('------>>> params: ${JsonUtil.encodeObj(body) ?? ''}');
        log('------>>> response: ${JsonUtil.encodeObj(response.data) ?? ''}');
      }
      if (response.statusCode! < 300) {
        final bean = BaseBean.fromJson(response.data);
        if (bean.code == 'SYS_0000') {
          return APIResponse.success(BaseBean.fromJson(response.data));
        } else {
          return APIResponse.error(
            AppException.errorWithBean(bean),
          );
        }
      } else {
        if (response.statusCode! == 401 && loginOutWhenTokenOutOfTime) {
          MyToast.showError('登录已失效，请重新登录!');
          appRouter.popUntilRoot();
          // await appRouter.replace(LoginRoute());
        }
        return APIResponse.error(
          AppException.errorWithBean(BaseBean(message: '服务器异常')),
        );
        // if (response.statusCode! == 400) {
        //   return const APIResponse.error(
        //       AppException.errorWithMessage('服务器内部错误'));
        // } else if (response.statusCode! == 401) {
        //   return const APIResponse.error(AppException.unauthorized());
        // } else if (response.statusCode! == 502) {
        //   return const APIResponse.error(AppException.error());
        // } else {
        //   if (response.data['message'] != null) {
        //     return APIResponse.error(
        //         AppException.errorWithMessage(response.data['message'] ?? ''));
        //   } else {
        //     return const APIResponse.error(AppException.error());
        //   }
        // }
      }
    } on DioError catch (e) {
      if (kDebugMode && AppData.useResponseBodyLog) {
        log('------>>> params: ${JsonUtil.encodeObj(body) ?? ''}');
      }
      return APIResponse.error(
        AppException.errorWithBean(BaseBean(message: formatError(e))),
      );
    } catch (e) {
      if (kDebugMode && AppData.useResponseBodyLog) {
        log('------>>> params: ${JsonUtil.encodeObj(body) ?? ''}');
      }
      return APIResponse.error(
        AppException.errorWithBean(BaseBean(message: '未知错误')),
      );
    }
  }

  Future<APIResponse> get(
    String path, {
    String? newBaseUrl,
    String? token,
    Map<String, dynamic>? params,
    ContentType contentType = ContentType.json,
    CancelToken? cancelToken,
    bool loginOutWhenTokenOutOfTime = true,
  }) async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return APIResponse.error(
        AppException.errorWithBean(BaseBean(message: '网络异常')),
      );
    }
    String url;

    if (newBaseUrl != null) {
      url = newBaseUrl + path;
    } else {
      url = _baseUrl + path;
    }

    var content = 'application/x-www-form-urlencoded';

    if (contentType == ContentType.json) {
      content = 'application/json; charset=utf-8';
    }

    final headers = {
      'accept': '*/*',
      'Content-Type': content,
    };

    final _appToken = await _tokenModel.fetchToken();
    if (_appToken != null) {
      headers['Authorization'] = 'Bearer ${_appToken.token}';
    }

    try {
      final response = await _dio.get(
        url,
        queryParameters: params,
        options: Options(validateStatus: (status) => true, headers: headers),
        cancelToken: cancelToken,
      );
      if (response == null) {
        return APIResponse.error(
          AppException.errorWithBean(BaseBean(message: '网络异常')),
        );
      }
      if (response.statusCode == null) {
        return APIResponse.error(
          AppException.errorWithBean(BaseBean(message: '网络异常')),
        );
      }

      if (kDebugMode && AppData.useResponseBodyLog) {
        log('------>>> response: ${JsonUtil.encodeObj(response.data) ?? ''}');
      }

      if (response.statusCode! < 300) {
        final bean = BaseBean.fromJson(response.data);
        if (bean.code == 'SYS_0000') {
          return APIResponse.success(BaseBean.fromJson(response.data));
        } else {
          return APIResponse.error(
            AppException.errorWithBean(bean),
          );
        }
      } else {
        if (response.statusCode! == 401 && loginOutWhenTokenOutOfTime) {
          MyToast.showError('登录已失效，请重新登录!');
          appRouter.popUntilRoot();
          // await appRouter.replace(LoginRoute());
        }
        return APIResponse.error(
          AppException.errorWithBean(BaseBean(message: '服务器异常')),
        );
        // if (response.statusCode! == 400) {
        //   return const APIResponse.error(
        //       AppException.errorWithMessage('服务器内部错误'));
        // } else if (response.statusCode! == 401) {
        //   return const APIResponse.error(AppException.unauthorized());
        // } else if (response.statusCode! == 502) {
        //   return const APIResponse.error(AppException.error());
        // } else {
        //   if (response.data['message'] != null) {
        //     return APIResponse.error(
        //         AppException.errorWithMessage(response.data['message'] ?? ''));
        //   } else {
        //     return const APIResponse.error(AppException.error());
        //   }
        // }
      }
    } on DioError catch (e) {
      if (kDebugMode && AppData.useResponseBodyLog) {
        log('------>>> params: ${params ?? ''}');
      }
      return APIResponse.error(
        AppException.errorWithBean(BaseBean(message: formatError(e))),
      );
    } catch (e) {
      if (kDebugMode && AppData.useResponseBodyLog) {
        log('------>>> params: ${params ?? ''}');
      }
      return APIResponse.error(
        AppException.errorWithBean(BaseBean(message: '未知错误')),
      );
    }
  }

  Future<APIResponse> postFiles(
    String path,
    List files, {
    String? newBaseUrl,
    String? token,
    Map<String, String?>? params,
    ContentType contentType = ContentType.json,
    CancelToken? cancelToken,
  }) async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return APIResponse.error(
        AppException.errorWithBean(BaseBean(message: '网络异常')),
      );
    }
    String url;
    if (newBaseUrl != null) {
      url = newBaseUrl + path;
    } else {
      url = _baseUrl + path;
    }

    final formData = FormData();

    final allFiles = files
        .map((e) => MapEntry('files', MultipartFile.fromFileSync(e)))
        .toList();

    formData.files.addAll(allFiles);

    try {
      final headers = {
        'Accept': 'application/json,text/plain,*/*',
        'Content-Type': 'multipart/form-data',
      };
      final _appToken = await _tokenModel.fetchToken();
      if (_appToken != null) {
        headers['Authorization'] = 'Bearer ${_appToken.token}';
      }
      //Sometime for some specific endpoint it may require to use different Token
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }

      final response = await _dio.post(
        url,
        data: formData,
        queryParameters: params,
        options: Options(validateStatus: (status) => true, headers: headers),
        cancelToken: cancelToken,
      );

      if (response.statusCode == null) {
        return APIResponse.error(
          AppException.errorWithBean(BaseBean(message: '网络异常')),
        );
      }

      if (response.statusCode! < 300) {
        final bean = BaseBean.fromJson(response.data);
        if (bean.code == 'SYS_0000') {
          return APIResponse.success(BaseBean.fromJson(response.data));
        } else {
          return APIResponse.error(
            AppException.errorWithBean(bean),
          );
        }
      } else {
        return APIResponse.error(
          AppException.errorWithBean(BaseBean(message: '服务器异常')),
        );
      }
    } on DioError catch (e) {
      if (kDebugMode && AppData.useResponseBodyLog) {
        log('------>>> params: ${params ?? ''}');
      }
      return APIResponse.error(
        AppException.errorWithBean(BaseBean(message: formatError(e))),
      );
    } catch (e) {
      return APIResponse.error(
        AppException.errorWithBean(BaseBean(message: '未知错误')),
      );
    }
  }

  Future<APIResponse> postFile(
    String path, {
    String? newBaseUrl,
    String? token,
    required Map<String, Object> params,
    ContentType contentType = ContentType.json,
    CancelToken? cancelToken,
  }) async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return APIResponse.error(
        AppException.errorWithBean(BaseBean(message: '网络异常')),
      );
    }
    String url;
    if (newBaseUrl != null) {
      url = newBaseUrl + path;
    } else {
      url = _baseUrl + path;
    }

    // formData.files.add(MapEntry('files', MultipartFile.fromFileSync(file)));

    final formData = FormData.fromMap(params);

    try {
      final headers = {
        'Accept': 'application/json,text/plain,*/*',
        'Content-Type': 'multipart/form-data',
      };
      final _appToken = await _tokenModel.fetchToken();
      if (_appToken != null) {
        headers['Authorization'] = 'Bearer ${_appToken.token}';
      }
      //Sometime for some specific endpoint it may require to use different Token
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }

      final response = await _dio.post(
        url,
        data: formData,
        queryParameters: params,
        options: Options(validateStatus: (status) => true, headers: headers),
        cancelToken: cancelToken,
      );

      if (response.statusCode == null) {
        return APIResponse.error(
          AppException.errorWithBean(BaseBean(message: '网络异常')),
        );
      }

      if (response.statusCode! < 300) {
        final bean = BaseBean.fromJson(response.data);
        if (bean.code == 'SYS_0000') {
          return APIResponse.success(BaseBean.fromJson(response.data));
        } else {
          return APIResponse.error(
            AppException.errorWithBean(bean),
          );
        }
      } else {
        return APIResponse.error(
          AppException.errorWithBean(BaseBean(message: '服务器异常')),
        );
      }
    } on DioError catch (e) {
      return APIResponse.error(
        AppException.errorWithBean(BaseBean(message: formatError(e))),
      );
    } catch (e) {
      return APIResponse.error(
        AppException.errorWithBean(BaseBean(message: '未知错误')),
      );
    }
  }

  /*
   * error统一处理
   */
  String formatError(DioError e) {
    if (e.type == DioErrorType.connectTimeout) {
      // It occurs when url is opened timeout.
      return '连接超时';
    } else if (e.type == DioErrorType.sendTimeout) {
      // It occurs when url is sent timeout.
      return '请求超时';
    } else if (e.type == DioErrorType.receiveTimeout) {
      //It occurs when receiving timeout
      return '响应超时';
    } else if (e.type == DioErrorType.response) {
      // When the server response, but with a incorrect status, such as 404, 503...
      return '出现异常';
    } else if (e.type == DioErrorType.cancel) {
      // When the request is cancelled, dio will throw a error with this type.
      return '请求取消';
    } else {
      //DEFAULT Default error type, Some other Error. In this case, you can read the DioError.error if it is not null.
      return '未知错误';
    }
  }
}
