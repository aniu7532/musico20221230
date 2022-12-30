import 'package:flustars/flustars.dart';

final appPms = AppPms();

///app权限
class AppPms {
  factory AppPms() => _instance;

  AppPms._();

  static late final AppPms _instance = AppPms._();

  ///功能权限
  late List psmList = [];

  ///已选择的单据类型列表
  late List billTypeList = [];

  ///是否授权商城 专题分类
  bool isHistoryRelease = false;

  ///是否购买商城
  bool isBuyShop = false;

  ///是否有装修商城的权限
  bool isDecoration = false;

  ///付/收账户中，自动填入默认账户信息
  bool enableDefaultAccount = false;

  ///启用预付款
  bool enabledPrepay = false;

  ///是否允许查看成本、毛利
  bool isShowCostProfit = false;

  ///是否默认所有用户开启价格跟踪
  bool enabledPriceTrace = false;

  ///系统设置
  SysSetting? sys;

  ///系统设置
  BillSys? billSys;

  ///商品基本设置
  GoodsBasicSetting? goodsBasicSetting;

  ///是否显示图片
  bool get showGoodsCover => goodsBasicSetting?.showCover == true;

  ///是否显示编号
  bool get showGoodsCode => goodsBasicSetting?.showCode == true;

  ///是否显示条码
  bool get showGoodsBarCode => goodsBasicSetting?.showBarCode == true;

  ///允许负库存出库
  bool get enableOutStockExWarehouse => sys?.forbidOutStockExWarehouse == false;

  /// 是否拥有权限
  /// [projType] 一级项目权限类型
  /// [secondaryProjectType] 二级项目权限类型，只有一级项目权限则不传
  /// [opType] 操作类型
  bool havePms({
    required ProjType projType,
    SecondaryProjectType? secondaryProjectType,
    required OpType opType,
  }) {
    if (ObjectUtil.isEmpty(psmList)) {
      return false;
    }
    final projectList = psmList
        .where((element) => (element as Map)['name'] == projType.name)
        .toList();
    if (projectList.isNotEmpty) {
      final projectTypeMap = projectList.first as Map;
      //最后一级项目map数据，如果没有二级则是一级，如果有二级则是二级
      Map finalProjectTypeMap;
      if (secondaryProjectType != null) {
        final secondaryList = (projectTypeMap['children'] as List)
            .where(
              (element) =>
                  (element as Map)['name'] == secondaryProjectType.name,
            )
            .toList();
        if (secondaryList.isNotEmpty) {
          finalProjectTypeMap = secondaryList.first as Map;
        } else {
          return false;
        }
      } else {
        finalProjectTypeMap = projectTypeMap;
      }
      late List operateList;
      //获取最后一级操作权限数据的key后端未统一，有children和permission两种，所以这里取有数据的一组
      final childrenList = finalProjectTypeMap['children'] as List?;
      final permissionList = finalProjectTypeMap['permission'] as List?;
      if (childrenList?.isNotEmpty == true) {
        operateList = childrenList!;
      } else if (permissionList?.isNotEmpty == true) {
        operateList = permissionList!;
      } else {
        operateList = [];
      }
      return operateList
          .any((element) => (element as Map)['name'] == opType.name);
    }
    return false;
  }

  ///客户基础资料权限
  bool haveCusPms(OpType type) {
    if (ObjectUtil.isNotEmpty(psmList) &&
        psmList.any((e) => e['name'] == 'CRM')) {
      final crm = psmList.firstWhere((e) => e['name'] == 'CRM');
      if (ObjectUtil.isNotEmpty(crm) && ObjectUtil.isNotEmpty('children')) {
        List children = crm['children'];
        if (children.any((e) => e['name'] == '客户')) {
          final item = children.firstWhere((e) => e['name'] == '客户');
          if (ObjectUtil.isNotEmpty(item['permission'])) {
            return item['permission'].any((e) => e['name'] == type.name);
          }
        }
      }
    }
    return false;
  }

  ///供应商基础资料权限
  bool haveSupPms(OpType type) {
    if (ObjectUtil.isNotEmpty(psmList) &&
        psmList.any((e) => e['name'] == 'CRM')) {
      final crm = psmList.firstWhere((e) => e['name'] == 'CRM');
      if (ObjectUtil.isNotEmpty(crm) && ObjectUtil.isNotEmpty('children')) {
        List children = crm['children'];
        if (children.any((e) => e['name'] == '供应商')) {
          final item = children.firstWhere((e) => e['name'] == '供应商');
          if (ObjectUtil.isNotEmpty(item['permission'])) {
            return item['permission'].any((e) => e['name'] == type.name);
          }
        }
      }
    }
    return false;
  }

  ///商品基础资料权限
  bool haveGoodsPms(OpType type) {
    if (ObjectUtil.isNotEmpty(psmList) &&
        psmList.any((e) => e['name'] == '商品')) {
      final goods = psmList.firstWhere((e) => e['name'] == '商品');
      if (ObjectUtil.isNotEmpty(goods) && ObjectUtil.isNotEmpty('children')) {
        List children = goods['children'];
        if (children.any((e) => e['name'] == '商品信息')) {
          final item = children.firstWhere((e) => e['name'] == '商品信息');
          if (ObjectUtil.isNotEmpty(item['permission'])) {
            return item['permission'].any((e) => e['name'] == type.name);
          }
        }
      }
    }
    return false;
  }

  ///单据中心的查看权限
  bool haveBillViewPms() {
    if (ObjectUtil.isNotEmpty(psmList) &&
        psmList.any((e) => e['name'].toString().contains('单据'))) {
      final item =
          psmList.firstWhere((e) => e['name'].toString().contains('单据'));
      if (ObjectUtil.isNotEmpty(item) && ObjectUtil.isNotEmpty('permission')) {
        List permission = item['permission'];
        return permission.any((e) => e['name'] == '查看');
      }
    }
    return false;
  }

  ///商品自定义字段设置权限
  bool haveGoodsFieldSettingPms() {
    return havePms(
      projType: ProjType.set,
      secondaryProjectType: SecondaryProjectType.goodsSetting,
      opType: OpType.goodsFieldSetting,
    );
  }

  ///自定义配置权限
  bool haveFieldConfigPms() {
    return havePms(
      projType: ProjType.set,
      secondaryProjectType: SecondaryProjectType.mobilSetting,
      opType: OpType.fieldConfig,
    );
  }

  ///价格跟踪总开关（直接影响是否可以使用客户最近售价）
  bool havePriceTracksPms() {
    return enabledPriceTrace;
  }
}

enum OpType {
  view,
  query,
  add,
  modify,
  delete,
  audit,
  print,
  post,
  red,
  delivery,
  receive,
  share,
  updateFee,
  gift,
  account,
  outStock,
  interrupt,
  cancel,
  reconciliation,
  checkBillPost,
  modifyAfterPosting,
  procurementCost,
  sellingExpenses,
  goodsFieldSetting,
  exchangeGoods,
  fieldConfig,
  collectionAccount,
}

extension PmsType on OpType {
  String get name {
    switch (this) {
      case OpType.view:
        return '查看';
      case OpType.query:
        return '查询';
      case OpType.add:
        return '新增';
      case OpType.modify:
        return '编辑';
      case OpType.delete:
        return '删除';
      case OpType.audit:
        return '审核';
      case OpType.print:
        return '打印';
      case OpType.post:
        return '过账';
      case OpType.checkBillPost:
        return '盘点完成';
      case OpType.red:
        return '撤销';
      case OpType.delivery:
        return '发货';
      case OpType.receive:
        return '收货';
      case OpType.share:
        return '分享';
      case OpType.updateFee:
        return '修改单价/运费';
      case OpType.gift:
        return '允许选择赠品';
      case OpType.account:
        return '收款';
      case OpType.outStock:
        return '出库';
      case OpType.interrupt:
        return '中止';
      case OpType.cancel:
        return '取消';
      case OpType.reconciliation:
        return '对账';
      case OpType.modifyAfterPosting:
        return '过账后修改';
      case OpType.exchangeGoods:
        return '换货';
      case OpType.procurementCost:
        return '采购费用';
      case OpType.sellingExpenses:
        return '销售费用';
      case OpType.goodsFieldSetting:
        return '商品字段设置';
      case OpType.fieldConfig:
        return '字段配置';
      case OpType.collectionAccount:
        return '现金银行账户';
    }
  }
}

///二级项目权限
enum SecondaryProjectType {
  goodsSetting,
  mobilSetting,
}

extension SecondaryProjectTypeExtension on SecondaryProjectType {
  String get name {
    switch (this) {
      case SecondaryProjectType.goodsSetting:
        return '商品设置';
      case SecondaryProjectType.mobilSetting:
        return '移动端设置';
    }
  }
}

///参照权限接口里的'componentId'字段，包含里面所有的类别
enum ProjType {
  order,
  stream,
  stock,
  crm,
  dh,
  set,
  InStorage,
  period,
  market,
}

extension ProjTypeExtension on ProjType {
  String get name {
    switch (this) {
      case ProjType.order:
        return '销售';
      case ProjType.stream:
        return '财务';
      case ProjType.stock:
        return '库存';
      case ProjType.crm:
        return 'CRM';
      case ProjType.dh:
        return '商品';
      case ProjType.set:
        return '设置';
      case ProjType.InStorage:
        return '采购';
      case ProjType.period:
        return '资料';
      case ProjType.market:
        return '营销';
    }
  }
}

// autoCode	商品设置参数vo-商品设置参数vo-是否启用自动编号(0：False,1:True)	integer(int32)
// autoCodeExpressions	商品设置参数vo-自动编号规则	string
// autoCodeRunNumberLength	商品设置参数vo-自动编号流水号长度	integer(int32)
// currencySymbol	商品设置参数vo-商品设置参数vo-币种	string
// discountPrecision	商品设置参数vo-商品折扣精度(0：整数，1：1位小数,2：2位小数,3：2位小数,4：4位小数,以此类推)	integer(int32)
// enabledNotCostPrice	商品设置参数vo-是否启用无成本单价出库	boolean
// enableExamine	启用验货	boolean
// enabledPriceTrace	商品设置参数vo-是否启动价格跟踪	integer(int32)
// forbidOutStockExWarehouse	商品设置参数vo-禁止无货出库	boolean
// forbidOutStockOrder	商品设置参数vo-禁止无货开单	boolean
// historyRelease	客户是否发布过小程序	boolean
// isBuyShop	是否购买商城	boolean
// isConnectERP	是否连接ERP	boolean
// isDecoration	是否有商城装修	boolean
// isEnableShop	是否启用商城	boolean
// isEnableSubjectCategory	是否勾选专题分类商城	boolean
// pricePrecision	商品设置参数vo-商品价格精度(0：整数，1：1位小数,2：2位小数,3：2位小数,4：4位小数,以此类推)	integer(int32)
// qtyPrecision	商品设置参数vo-商品数量精度(0：整数，1：1位小数,2：2位小数,3：2位小数,4：4位小数,以此类推)	integer(int32)
// stockDisplaySettingList	商品设置参数vo-库存显示设置	array	库存显示设置
//   compareSymbol	库存显示设置-比较符（0：小于，1：大于）	integer
//   displayText	库存显示设置-当显示类型为自定义时，指示显示的文本	string
//   displayType	库存显示设置-显示类型（0：显示数量，1：不显示库存，2：自定义显示）	integer
//   id	库存显示设置-业务ID	integer
//   qtyRange	库存显示设置-数量范围标	integer
// stockViewRange	商品设置参数vo-客户查看库存范围（1:查看客户对应仓库库存,2:查看所有仓库库存）	integer(int32)
class SysSetting {
  int? autoCode;
  String? autoCodeExpressions;
  int? autoCodeRunNumberLength;
  String? currencySymbol;
  int? discountPrecision;
  bool? enabledNotCostPrice;
  bool? enableExamine;
  int? enabledPriceTrace;
  bool? forbidOutStockExWarehouse;
  bool? forbidOutStockOrder;
  bool? historyRelease;
  bool? isBuyShop;
  bool? isConnectERP;
  bool? isDecoration;
  bool? isEnableShop;
  bool? isEnableSubjectCategory;
  int? pricePrecision;
  int? qtyPrecision;
  List<StockDisplaySettingList>? stockDisplaySettingList;
  int? stockViewRange;

  SysSetting(
      {this.autoCode,
      this.autoCodeExpressions,
      this.autoCodeRunNumberLength,
      this.currencySymbol,
      this.discountPrecision,
      this.enabledNotCostPrice,
      this.enableExamine,
      this.enabledPriceTrace,
      this.forbidOutStockExWarehouse,
      this.forbidOutStockOrder,
      this.historyRelease,
      this.isBuyShop,
      this.isConnectERP,
      this.isDecoration,
      this.isEnableShop,
      this.isEnableSubjectCategory,
      this.pricePrecision,
      this.qtyPrecision,
      this.stockDisplaySettingList,
      this.stockViewRange});

  SysSetting.fromJson(Map<String, dynamic> json) {
    autoCode = json['autoCode'];
    autoCodeExpressions = json['autoCodeExpressions'];
    autoCodeRunNumberLength = json['autoCodeRunNumberLength'];
    currencySymbol = json['currencySymbol'];
    discountPrecision = json['discountPrecision'];
    enabledNotCostPrice = json['enabledNotCostPrice'];
    enableExamine = json['enableExamine'];
    enabledPriceTrace = json['enabledPriceTrace'];
    forbidOutStockExWarehouse = json['forbidOutStockExWarehouse'];
    forbidOutStockOrder = json['forbidOutStockOrder'];
    historyRelease = json['historyRelease'];
    isBuyShop = json['isBuyShop'];
    isConnectERP = json['isConnectERP'];
    isDecoration = json['isDecoration'];
    isEnableShop = json['isEnableShop'];
    isEnableSubjectCategory = json['isEnableSubjectCategory'];
    pricePrecision = json['pricePrecision'];
    qtyPrecision = json['qtyPrecision'];
    if (json['stockDisplaySettingList'] != null) {
      stockDisplaySettingList = <StockDisplaySettingList>[];
      json['stockDisplaySettingList'].forEach((v) {
        stockDisplaySettingList!.add(new StockDisplaySettingList.fromJson(v));
      });
    }
    stockViewRange = json['stockViewRange'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['autoCode'] = this.autoCode;
    data['autoCodeExpressions'] = this.autoCodeExpressions;
    data['autoCodeRunNumberLength'] = this.autoCodeRunNumberLength;
    data['currencySymbol'] = this.currencySymbol;
    data['discountPrecision'] = this.discountPrecision;
    data['enabledNotCostPrice'] = this.enabledNotCostPrice;
    data['enableExamine'] = this.enableExamine;
    data['enabledPriceTrace'] = this.enabledPriceTrace;
    data['forbidOutStockExWarehouse'] = this.forbidOutStockExWarehouse;
    data['forbidOutStockOrder'] = this.forbidOutStockOrder;
    data['historyRelease'] = this.historyRelease;
    data['isBuyShop'] = this.isBuyShop;
    data['isConnectERP'] = this.isConnectERP;
    data['isDecoration'] = this.isDecoration;
    data['isEnableShop'] = this.isEnableShop;
    data['isEnableSubjectCategory'] = this.isEnableSubjectCategory;
    data['pricePrecision'] = this.pricePrecision;
    data['qtyPrecision'] = this.qtyPrecision;
    if (this.stockDisplaySettingList != null) {
      data['stockDisplaySettingList'] =
          this.stockDisplaySettingList!.map((v) => v.toJson()).toList();
    }
    data['stockViewRange'] = this.stockViewRange;
    return data;
  }
}

class StockDisplaySettingList {
  int? compareSymbol;
  String? displayText;
  int? displayType;
  dynamic id;
  int? qtyRange;

  StockDisplaySettingList(
      {this.compareSymbol,
      this.displayText,
      this.displayType,
      this.id,
      this.qtyRange});

  StockDisplaySettingList.fromJson(Map<String, dynamic> json) {
    compareSymbol = json['compareSymbol'];
    displayText = json['displayText'];
    displayType = json['displayType'];
    id = json['id'];
    qtyRange = json['qtyRange'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['compareSymbol'] = this.compareSymbol;
    data['displayText'] = this.displayText;
    data['displayType'] = this.displayType;
    data['id'] = this.id;
    data['qtyRange'] = this.qtyRange;
    return data;
  }
}

//enabledOrderAutoCancel	启用订单自动取销	boolean
// enabledOrderAutoSignFor	启用订单自动签收	boolean
// enabledOrderDelivery	启用订单发货	boolean
// enabledOrderDeliveryDate	启用订单交货日期	boolean
// enabledOrderOrdinaryTax	启用普通税	boolean
// enabledOrderOutOfStorage	启用订单出库	boolean
// enabledOrderSMS	启用订单短信推送	boolean
// enabledOrderSignFor	启用订单签收	boolean
// enabledOrderTax	启用订货税率	boolean
// enabledOrderVAT	启用增值税	boolean
// enabledOrderDiscount	启用折扣设置	boolean
// mallInvoiceRequired	商城端开单必填发票	boolean
// markPrintOption	开单打印设置,0：打印并存入草稿，1：打印并过账,可用值:0,1	integer(int32)
// minOrderMoney	订单最小起订金额	integer(int64)
// minOrderMoneyScope	订单最小起订金额作用域（1：代下单与客户自主下单同时生效、2：客户自主下单生效）	integer(int32)
// orderAutoCancelMinutes	自动取消订单的分钟数	integer(int32)
// orderAutoSignForDays	自动签收订单的天数	integer(int32)
// orderDeliveryDateRule	交货日期规则(0:客户自主填写，1：指定规则)	integer(int32)
// orderOrdinaryTaxRate	普通税率	number
// orderReceiveInfoRequired	订单收货信息必填	boolean
// orderVATRate	增值税率	number
class BillSys {
  num? markPrintOption;
  bool? enabledOrderOutOfStorage;
  bool? enabledOrderDelivery;
  bool? enabledOrderSignFor;
  num? minOrderMoney;
  num? minOrderMoneyScope;
  bool? enabledOrderDeliveryDate;
  num? orderDeliveryDateRule;
  bool? enabledOrderAutoCancel;
  num? orderAutoCancelMinutes;
  bool? enabledOrderAutoSignFor;
  num? orderAutoSignForDays;
  bool? orderReceiveInfoRequired;
  bool? enabledOrderSMS;
  bool? enabledOrderTax;
  bool? mallInvoiceRequired;
  bool? enabledOrderVAT;
  bool? enabledOrderOrdinaryTax;
  bool? enabledOrderDiscount;
  num? orderVATRate;
  num? orderOrdinaryTaxRate;

  BillSys(
      {this.markPrintOption,
      this.enabledOrderOutOfStorage,
      this.enabledOrderDelivery,
      this.enabledOrderSignFor,
      this.minOrderMoney,
      this.minOrderMoneyScope,
      this.enabledOrderDeliveryDate,
      this.orderDeliveryDateRule,
      this.enabledOrderAutoCancel,
      this.orderAutoCancelMinutes,
      this.enabledOrderAutoSignFor,
      this.orderAutoSignForDays,
      this.orderReceiveInfoRequired,
      this.enabledOrderSMS,
      this.enabledOrderTax,
      this.mallInvoiceRequired,
      this.enabledOrderVAT,
      this.enabledOrderOrdinaryTax,
      this.orderVATRate,
      this.orderOrdinaryTaxRate,
      this.enabledOrderDiscount});

  BillSys.fromJson(Map<String, dynamic> json) {
    markPrintOption = json['markPrintOption'];
    enabledOrderOutOfStorage = json['enabledOrderOutOfStorage'];
    enabledOrderDelivery = json['enabledOrderDelivery'];
    enabledOrderSignFor = json['enabledOrderSignFor'];
    minOrderMoney = json['minOrderMoney'];
    minOrderMoneyScope = json['minOrderMoneyScope'];
    enabledOrderDeliveryDate = json['enabledOrderDeliveryDate'];
    orderDeliveryDateRule = json['orderDeliveryDateRule'];
    enabledOrderAutoCancel = json['enabledOrderAutoCancel'];
    orderAutoCancelMinutes = json['orderAutoCancelMinutes'];
    enabledOrderAutoSignFor = json['enabledOrderAutoSignFor'];
    orderAutoSignForDays = json['orderAutoSignForDays'];
    orderReceiveInfoRequired = json['orderReceiveInfoRequired'];
    enabledOrderSMS = json['enabledOrderSMS'];
    enabledOrderTax = json['enabledOrderTax'];
    mallInvoiceRequired = json['mallInvoiceRequired'];
    enabledOrderVAT = json['enabledOrderVAT'];
    enabledOrderOrdinaryTax = json['enabledOrderOrdinaryTax'];
    orderVATRate = json['orderVATRate'];
    orderOrdinaryTaxRate = json['orderOrdinaryTaxRate'];
    enabledOrderDiscount = json['enabledOrderDiscount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['markPrintOption'] = this.markPrintOption;
    data['enabledOrderOutOfStorage'] = this.enabledOrderOutOfStorage;
    data['enabledOrderDelivery'] = this.enabledOrderDelivery;
    data['enabledOrderSignFor'] = this.enabledOrderSignFor;
    data['minOrderMoney'] = this.minOrderMoney;
    data['minOrderMoneyScope'] = this.minOrderMoneyScope;
    data['enabledOrderDeliveryDate'] = this.enabledOrderDeliveryDate;
    data['orderDeliveryDateRule'] = this.orderDeliveryDateRule;
    data['enabledOrderAutoCancel'] = this.enabledOrderAutoCancel;
    data['orderAutoCancelMinutes'] = this.orderAutoCancelMinutes;
    data['enabledOrderAutoSignFor'] = this.enabledOrderAutoSignFor;
    data['orderAutoSignForDays'] = this.orderAutoSignForDays;
    data['orderReceiveInfoRequired'] = this.orderReceiveInfoRequired;
    data['enabledOrderSMS'] = this.enabledOrderSMS;
    data['enabledOrderTax'] = this.enabledOrderTax;
    data['mallInvoiceRequired'] = this.mallInvoiceRequired;
    data['enabledOrderVAT'] = this.enabledOrderVAT;
    data['enabledOrderOrdinaryTax'] = this.enabledOrderOrdinaryTax;
    data['orderVATRate'] = this.orderVATRate;
    data['orderOrdinaryTaxRate'] = this.orderOrdinaryTaxRate;
    data['enabledOrderDiscount'] = this.enabledOrderDiscount;
    return data;
  }
}

class GoodsBasicSetting {
  GoodsBasicSetting({
    this.currencySymbol,
    this.showCover,
    this.showCode,
    this.showBarCode,
  });

  factory GoodsBasicSetting.fromJson(Map<String, dynamic> json) {
    return GoodsBasicSetting(
      currencySymbol: json['currencySymbol'],
      showCover: json['showCover'],
      showCode: json['showCode'],
      showBarCode: json['showBarCode'],
    );
  }

  String? currencySymbol;
  bool? showCover;
  bool? showCode;
  bool? showBarCode;
}
