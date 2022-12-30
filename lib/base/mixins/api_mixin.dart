import 'package:dio/dio.dart';
import 'package:musico/http/api_provider.dart';
import 'package:musico/http/api_response.dart';
import 'package:musico/utils/log_util.dart';

mixin ApiMixin {
  ///数据请求
  final ApiModel apiModel = ApiModel();

  ///记录取消请求的列表
  CancelToken pageCancelToken = CancelToken();

  Future<APIResponse> post(
    String path,
    dynamic body, {
    CancelToken? cancelToken,
    String? newBaseUrl,
    bool loginOutWhenTokenOutOfTime = true,
    String preventRepeatKey = '',
  }) async {
    return apiModel.post(
      path,
      body,
      newBaseUrl: newBaseUrl,
      cancelToken: cancelToken,
      loginOutWhenTokenOutOfTime: loginOutWhenTokenOutOfTime,
      preventRepeatKey: preventRepeatKey,
    );
  }

  Future<APIResponse> get(
    String path, {
    Map<String, dynamic>? params,
    CancelToken? cancelToken,
    bool loginOutWhenTokenOutOfTime = true,
  }) async {
    return apiModel.get(
      path,
      params: params,
      cancelToken: cancelToken,
      loginOutWhenTokenOutOfTime: loginOutWhenTokenOutOfTime,
    );
  }

  ///取消页面的所有请求
  void cancelPageApi() {
    try {
      if (!pageCancelToken.isCancelled) {
        pageCancelToken.cancel();
      }
    } catch (e) {
      logger.v(e);
    }
  }
}
