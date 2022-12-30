///
///Create by 李实 on 2022/7/6 15:31
///
///Description: 控制单据切换时的弹窗
///
class BillInfoClearEvent {
  BillInfoClearEvent(
    this.show, {
    this.defaultTitle,
  });

  bool show;
  String? defaultTitle;
}

/// 单据操作按钮触发eventBus
class BillChangeOperationEvent {
  BillChangeOperationEvent(
    this.type, {
    this.billId,
    this.oldBillId,
  });
  final BillChangeOperationType? type;
  final String? billId;
  final String? oldBillId;
}

enum BillChangeOperationType {
  modify, // 过账后修改
  edit, // 编辑
  saleReturn, // 销售退货
  receipt, // 收款
  payment, // 付款
  redBill, // 撤销
}
