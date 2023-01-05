import 'dart:async';
import 'package:musico/base/view_state_model.dart';

class SearchRstModel extends ViewStateModel {
  SearchRstModel({Map<String, dynamic>? requestParam})
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
}
