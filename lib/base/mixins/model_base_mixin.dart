import 'package:musico/base/view_state.dart';

mixin ModelBaseMixin {
  /// 当前的页面状态,默认为busy
  ViewState _viewState = ViewState.busy;
  ViewState get viewState => _viewState;
  set viewState(ViewState viewState) => _viewState = viewState;
  bool get busy => viewState == ViewState.busy;
  bool get idle => viewState == ViewState.idle;
  bool get empty => viewState == ViewState.empty;
  bool get error => viewState == ViewState.error;
  bool get unAuthorized => viewState == ViewState.unAuthorized;

  /// 出错时的message
  String? _errorMessage;
  String get errorMessage => _errorMessage ?? '';

  void setBusy(bool value) {
    _errorMessage = null;
    viewState = value ? ViewState.busy : ViewState.idle;
  }

  void setEmpty() {
    _errorMessage = null;
    viewState = ViewState.empty;
  }

  void setError(String message) {
    _errorMessage = message;
    viewState = ViewState.error;
  }

  void setUnAuthorized() {
    _errorMessage = null;
    viewState = ViewState.unAuthorized;
  }

  ///是否修改过数据
  bool dataChanged = false;
}
