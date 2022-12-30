import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:musico/base/view_state.dart';
import 'package:musico/base/mixins/api_mixin.dart';
import 'package:musico/utils/app_crash_util.dart';

class ViewStateModel with ChangeNotifier, ApiMixin {
  /// 根据状态构造
  ///
  /// 子类可以在构造函数指定需要的页面状态
  /// FooModel():super(viewState:ViewState.busy);
  ViewStateModel({ViewState? viewState, Map<String, dynamic>? requestParam}) {
    this.requestParam = requestParam ?? {};
    _viewState = viewState ?? ViewState.idle;
  }

  String apiString = '';

  /// 防止页面销毁后,异步任务才完成,导致报错
  bool _disposed = false;

  bool get isDispose => _disposed;

  /// 当前的页面状态,默认为busy,可在viewModel的构造方法中指定;
  ViewState _viewState = ViewState.idle;

  ///参数
  Map<String, dynamic>? requestParam;

  ///是否修改过数据
  bool dataChanged = false;

  initData() {
    //setBusy(true);
    loadData();
  }

  ViewState get viewState => _viewState;

  set viewState(ViewState viewState) {
    _viewState = viewState;
    notifyListeners();
  }

  /// 出错时的message
  String _errorMessage = '';

  String get errorMessage => _errorMessage;

  ///是否交给基类处理空页面处理
  bool needStateControl = true;

  bool get busy => viewState == ViewState.busy;

  bool get idle => viewState == ViewState.idle;

  bool get empty => viewState == ViewState.empty;

  bool get error => viewState == ViewState.error;

  bool get unAuthorized => viewState == ViewState.unAuthorized;

  void setBusy(bool value) {
    _errorMessage = '';
    viewState = value ? ViewState.busy : ViewState.idle;
  }

  void setEmpty() {
    _errorMessage = '';
    viewState = ViewState.empty;
  }

  void setError(String message) {
    _errorMessage = message;
    viewState = ViewState.error;
  }

  void setUnAuthorized() {
    _errorMessage = '';
    viewState = ViewState.unAuthorized;
  }

  @override
  String toString() {
    return 'BaseModel{_viewState: $viewState, _errorMessage: $_errorMessage}';
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  @override
  void dispose() {
    cancelPageApi();
    _disposed = true;
    super.dispose();
  }

  bool showLoading = false;

  setShowLoading(bool value) {
    showLoading = value;
    notifyListeners();
  }

  /// Handle Error and Exception
  ///
  /// 统一处理子类的异常情况
  /// [e],有可能是Error,也有可能是Exception.所以需要判断处理
  /// [s] 为堆栈信息
  void handleCatch(e, s) {
    // DioError的判断,理论不应该拿进来,增强了代码耦合性,抽取为时组件时.应移除
    if (e is DioError) {
      setUnAuthorized();
    } else {
      AppCrashChain.printError(e, s);
      setError(e is Error ? e.toString() : e.message);
    }
  }

  // 加载数据
  @protected
  Future? loadData() {
    return null;
  }
}
