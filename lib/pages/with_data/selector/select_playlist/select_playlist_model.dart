import 'dart:async';
import 'package:musico/base/refresh_list/list_more_page_searchbar_mixin.dart';
import 'package:musico/base/view_state.dart';

mixin _Protocol {}

class DSelectPlaylistModel extends BaseListMoreModel<dynamic> with _Protocol {
  DSelectPlaylistModel({Map<String, dynamic>? requestParam})
      : super(requestParam: requestParam) {
    showSearchWidget = false;
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
      4,
      4,
      4,
      4,
      4,
      4,
      4,
      4,
      4,
      4,
      4,
      4,
      4,
      4,
    ];
  }
}
