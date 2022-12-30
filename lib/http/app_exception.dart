import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:musico/http/model/base_bean.dart';

part 'app_exception.freezed.dart';

@freezed
class AppException with _$AppException {
  const factory AppException.connectivity() = AppExceptionConnectivity;

  const factory AppException.unauthorized() = AppExceptionUnauthorized;

  const factory AppException.errorWithMessage(String message) =
      _AppExceptionErrorMessage;

  const factory AppException.errorWithBean(BaseBean bean) =
      _AppExceptionErrorBean;

  const factory AppException.error() = _AppExceptionError;
}

extension ApiErrorResponseWrapper on AppException {
  String? get message => _getMessage(this);

  // ignore: avoid_dynamic_calls
  String? _getMessage(dynamic exception) {
    if (exception is _AppExceptionErrorMessage) {
      return exception.message;
    }
    return null;
  }

  BaseBean? get errorBean => _getBaseBean(this);

  // ignore: avoid_dynamic_calls
  BaseBean? _getBaseBean(dynamic exception) {
    if (exception is _AppExceptionErrorBean) {
      return exception.bean;
    }
    return null;
  }

  String? get errorMessage => message ?? errorBean?.message;
}
