import 'package:flustars/flustars.dart';
import 'package:musico/base/view_state.dart';
import 'package:musico/base/view_state_model.dart';

///单页，一次获取全部数据，下拉可刷新

/// 基于
abstract class ViewStateListModel<T> extends ViewStateModel {
  ViewStateListModel({Map<String, dynamic>? requestParam})
      : super(requestParam: requestParam);

  /// 页面数据
  List<T> list = [];

  /// 第一次进入页面loading skeleton
  Future<bool> initData() async {
    setBusy(true);
    var result = await refresh(init: true);
    if (result is bool) {
      return result;
    }
    return ObjectUtil.isNotEmpty(result);
  }

  // 下拉刷新
  refresh({bool init = false}) async {
    try {
      final data = await loadListData(0);
      if (data == null || data.isEmpty) {
        if (viewState != ViewState.error) setEmpty();
      } else {
        list = data;
        if (init) {
          //改变页面状态为非加载中
          setBusy(false);
        } else {
          notifyListeners();
        }
      }
      return true;
    } catch (e, s) {
      handleCatch(e, s);
    }
    return false;
  }

  // 加载数据
  @override
  Future<List<T>?> loadListData(int? pageNum);

  ///获取完数据之后调用
  void afterLoadData() {}
}
