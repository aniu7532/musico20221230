import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:musico/base/view_state_model.dart';
import 'package:musico/utils/helper/cache_timer_helper.dart';
import 'package:musico/utils/toast_util.dart';
import 'package:musico/widgets/common/loading_button.dart';

///操作类型
enum OperateType {
  add,
  delete,
  modify,
  copy,
  getOne,
  newCode,
  justDoIt, // 做 ‘当前进入页面’ 的 操作  例如 进入收款单 就是 做 收款 操作
}

enum BaseInfoType {
  customer,
  goods,
  supplier,
}

abstract class BaseInfoEditModel extends ViewStateModel {
  BaseInfoEditModel({Map<String, dynamic>? requestParam})
      : super(requestParam: requestParam) {
    setParams(requestParam);
  }

  ///基础资料类型
  BaseInfoType baseType = BaseInfoType.customer;

  ///操作类型 添加/修改
  OperateType opType = OperateType.add;

  ///是否使用缓存功能
  bool useCache = false;

  ///------------用于页面-----------
  ScrollController controller = ScrollController();
  final RoundedLoadingButtonController btnController =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController btnControllerLeft =
      RoundedLoadingButtonController();
  bool canScroll = true; //页面是否可滚动
  bool showSaveButton = true; //页面是否显示保存按钮
  bool notUseBaseInfoEditBuildContent = false; //页面是否用baseinfoedite下的content方法
  ///------------用于页面---END-----

  //是否有权限删除
  bool canRemove = true;

  ///缓存管理帮助
  late CacheTimerHelper _cacheTimerHelper;

  ///设置页面打开参数
  setParams(Map<String, dynamic>? requestParam) {
    if (requestParam != null) {
      opType = requestParam.containsKey('opType')
          ? requestParam['opType']
          : OperateType.add;
      baseType = requestParam.containsKey('baseType')
          ? requestParam['baseType']
          : BaseInfoType.customer;
    }
  }

  ///页面相关数据修改设置页面变化事件
  void setDataChanged() {
    dataChanged = true;
    if (useCache) {
      _cacheTimerHelper.startCacheData();
    }
  }

  ///页面相关数据修改设置页面变化事件，并更新UI
  void setDataChangedAndNotify() {
    setDataChanged();
    super.notifyListeners();
  }

  ///设置页面未发生变化
  void setDataNotChanged() {
    dataChanged = false;
  }

  @override
  void notifyListeners() {
    super.notifyListeners();
  }

  ///需要同步执行的接口
  List<Future> getOtherApi() {
    return [];
  }

  void setUpCache() {
    _cacheTimerHelper = CacheTimerHelper(cacheBaseInfoWithCID);
  }

  ///初始化页面数据
  initData() async {
    final futureList = <Future>[];
    if (opType == OperateType.add) {
      if (useCache) {
        //新增时，并且用户同意恢复缓存
        setUpCache();
        futureList.add(restoreBaseInfoWithCID());
      } else {
        futureList.add(getConfigList());
      }
    } else if (opType == OperateType.modify) {
      futureList.add(getOne());
    } else {
      await getOne();
    }

    ///添加其他需要同步执行的接口
    futureList.addAll(getOtherApi());

    ///最后一起执行
    await Future.wait(futureList);
  }

  ///保存
  save() async {
    if (onValidateInfo()) {
      setShowLoading(true);
      _doSave();
    }
  }

  Future _doSave() async {
    if (opType == OperateType.add) {
      return await add();
    } else {
      return await modify();
    }
  }

  ///验证基础资料合法性
  bool onValidateInfo() {
    return true;
  }

  ///获取基础资料code，及后台配置的参数
  getConfigList() {}

  ///获取一条信息
  getOne() {}

  ///编辑基础资料信息
  modify() {}

  ///保存数据
  add() {}

  ///删除当前基础资料数据
  delete() {}

  ///设置基础资料的停用启用
  setEnable() {}

  ///调用成功之后处理
  handlerSuccess(dynamic result, OperateType type) {
    final notifyTypes = [OperateType.newCode, OperateType.getOne];
    if (notifyTypes.contains(type)) {
      setBusy(false);
      //notifyListeners();
    } else {
      var msg = type == OperateType.add
          ? '新增成功'
          : (type == OperateType.modify
              ? '修改成功'
              : type == OperateType.copy
                  ? '复制成功'
                  : '删除成功');
      // showSuccessToast(msg);
      MyToast.showToast(msg);
    }
  }

  ///接口返回错误时处理
  handlerError(dynamic result) {
    MyToast.showToast(result.message);
    btnController.reset();
  }

  ///根据操作员 保存编辑的信息
  cacheBaseInfoWithCID() {}

  ///根据操作员 恢复缓存
  restoreBaseInfoWithCID() async {}

  @override
  void dispose() {
    if (useCache && ObjectUtil.isNotEmpty(_cacheTimerHelper)) {
      _cacheTimerHelper.dispose();
    }
    super.dispose();
  }
}
