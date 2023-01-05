import 'dart:async';
import 'package:musico/base/refresh_list/list_more_page_searchbar_mixin.dart';
import 'package:musico/base/view_state.dart';

mixin _Protocol {}

class SelectSingerModel extends BaseListMoreModel<dynamic> with _Protocol {
  SelectSingerModel({Map<String, dynamic>? requestParam})
      : super(requestParam: requestParam) {
    showSearchWidget = true;
    viewState = ViewState.empty;
  }

  @override
  Future<bool> initData() async {
    setBusy(true);

    return super.initData();
  }

  @override
  Future<List<dynamic>> loadRefreshListData({int? pageNum}) async {
    return [
      1,
      2,
      3,
      3,
      3,
      3,
      3,
      3,
      3,
      3,
      3,
      3,
      3,
      3,
      3,
      3,
      3,
      4,
    ];
  }
}
