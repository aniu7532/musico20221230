import 'dart:async';
import 'package:musico/app/myapp.dart';
import 'package:musico/base/view_state_model.dart';
import 'package:musico/router/router.gr.dart';

class SearchModel extends ViewStateModel {
  SearchModel({Map<String, dynamic>? requestParam})
      : super(requestParam: requestParam);

  List<dynamic>? historySearch;

  @override
  Future<bool> initData() async {
    historySearch = [
      'lover',
      'car park',
      'way to you heart',
      'f**k with you',
      'one letter for you'
    ];

    return super.initData();
  }

  ///
  /// 搜索结果页面
  ///
  void gotoSearchRst(v) {
    appRouter.push(TabSearchRstRoute());
  }
}
