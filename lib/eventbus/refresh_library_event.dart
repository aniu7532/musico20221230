///
///Description: 从外面传递到文件新增组件，用于刷新该组件
///
class RefreshLibraryEvent {
  RefreshLibraryEvent(
    this.type,
  );

  //类型
  String? type;
}
