import 'package:flustars/flustars.dart';
import 'package:musico/http/app_exception.dart';
import 'package:musico/http/model/base_bean.dart';
import 'package:musico/utils/toast_util.dart';

///app错误帮助类
class ApiErrorHelper {
  ApiErrorHelper._();

  ///toast提示错误信息
  static void toastApiErrorMessage(AppException exception) {
    if (ObjectUtil.isNotEmpty(exception.errorMessage)) {
      MyToast.showToast(exception.errorMessage!);
    }
  }

  ///获取错误的信息实体
  static BaseBean? getErrorBean(AppException exception) => exception.errorBean;
}
