import 'package:musico/app/myapp.dart';
import 'package:musico/base/basebeans/option_list.dart';
import 'package:musico/base/refresh_list/list_more_page_searchbar_mixin.dart';
import 'package:musico/widgets/search_textfield_widget.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';

///选择器公用Model
abstract class BaseSelectorModel<T> extends BaseListMoreModel {
  bool enablePullUp = true; //是否上拉加载可用 true可用
  bool enablePullDown = true; //是否下拉刷新可用 true可用
  bool hideSearch = false; //是否显示搜索框 true隐藏
  bool hideAdd = false; //是否显示新增按钮 true隐藏
  bool hideHeader = false; //是否显示头部 true隐藏
  String searchHintText = '搜索名称/编码'; //搜索提示
  String searchKey = ''; //搜索关键字
  String noDataText = '新增、编辑内容请登陆c.handday.com进行设置'; //底部文字
  bool showManualButton = false;
  bool needDiver = true; //是否需要分割线
  bool needTextFooter =
      false; // 是否需要c.handday.com 文字footer  配合 enablePullUp = true 使用

  ///全屏拍照手动录入按钮
  String scanDialogTitle = '拍照';

  bool showVoiceSearch = true; //是否显示语音搜索
  bool showScanSearch = false; //是否显示扫码搜索

  ///搜索类型
  SearchType searchType = SearchType.TEXT;

  bool enable = true; //true: 可操作，可选择 false：

  ///界面样式，默认可以不设置
  double? searchBottom = 0;
  EdgeInsets? listViewPadding;

  bool needIndex = false; //是否需要list 的item 带index返回
  bool needRepeat = true; //是否需要相同的字段 重复请求

  ///-----------------数据控制----------------------------------
  static String multiKey = 'enableMulti'; //key
  bool enableMulti = false; //是否允许多选，默认单选
  static String selectKey = 'selectKey'; //key
  List<OptionList> selectList = []; //单选多选时，选择项集合
  bool enableCancelSelected = false; //是否允许单选时取消选中状态

  BaseSelectorModel({Map<String, dynamic>? requestParam})
      : super(requestParam: requestParam) {
    enableMulti =
        requestParam == null ? false : requestParam[multiKey] ?? false;
    enable = requestParam == null ? true : requestParam['enable'] ?? true;
    hideHeader =
        requestParam == null ? false : requestParam['hideHeader'] ?? false;
    enableCancelSelected = requestParam == null
        ? false
        : requestParam['enableCancelSelected'] ?? false;
    showScanSearch =
        requestParam == null ? false : requestParam['showScanSearch'] ?? false;
    if (ObjectUtil.isNotEmpty(requestParam) &&
        requestParam!.containsKey(selectKey) &&
        ObjectUtil.isNotEmpty(requestParam[selectKey])) {
      final sList = requestParam[selectKey] as List<OptionList>;
      if (ObjectUtil.isNotEmpty(sList)) {
        for (final item in sList) {
          if (ObjectUtil.isNotEmpty(item) && item.value != null) {
            selectList.add(item);
          }
        }
      }
    }
  }

  ///置空搜索栏中的数据
  void reset() {
    notifyListeners();
  }

  ///当搜索数据改变时调用
  void changeSearch(String key) {
    if (searchKey == key && !needRepeat) return;
    searchKey = key;
    notifyListeners();
    initData();
  }

  ///-----------------------------------

  ///返回item是否被选中
  bool isItemSelected(OptionList item) {
    return selectList.contains(item);
  }

  ///多选时 添加/取消一个选项; 单选时直接返回选中项
  void onItemSelected(OptionList item) {
    if (!enable) {
      return;
    }
    if (enableMulti) {
      if (selectList.contains(item)) {
        selectList.remove(item);
      } else {
        selectList.add(item);
      }
      notifyListeners();
    } else {
      if (enableCancelSelected &&
          ObjectUtil.isNotEmpty(selectList) &&
          selectList.first.value == item.value) {
        appRouter.pop([OptionList(value: -1)]);
        return;
      } else {
        selectList
          ..clear()
          ..add(item);
      }
      appRouter.pop(selectList);
    }
  }

  ///多选回调
  void onMultiSelectedBack() {
    if (!enable) {
      return;
    }
    appRouter.pop(selectList);
  }

  ///当点击清除按钮时调用
  void onClear() {
    if (!enable) {
      return;
    }

    ///清除选择
    if (ObjectUtil.isNotEmpty(selectList)) {
      ///清空选中
      selectList.clear();
      notifyListeners();
    }
  }
}
