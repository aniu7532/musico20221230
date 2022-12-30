import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

/// 可滚动到指定index的listview，实际不是用listview实现，而是用的SingleChildScrollView
/// 注意该组件没有item复用机制，太多item的list不可使用
class ZzLocationListView extends StatefulWidget {
  const ZzLocationListView({
    Key? key,
    required this.itemCount,
    required this.itemBuilder,
    this.separator,
    this.controller,
  }) : super(key: key);

  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final Widget? separator;
  final ZzLocationListController? controller;

  @override
  State<ZzLocationListView> createState() => _ZzLocationListViewState();
}

class _ZzLocationListViewState extends State<ZzLocationListView> {
  ZzLocationListController? controller;
  @override
  void initState() {
    controller = widget.controller ?? ZzLocationListController();
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: controller,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _buildItems(),
      ),
    );
  }

  List<Widget> _buildItems() {
    if (widget.itemCount <= 0) {
      return [];
    }
    final items = List<Widget>.generate(
      widget.itemCount,
      (index) => Container(
        key:
            index == controller?._showPosition ? controller?.positionKey : null,
        child: widget.itemBuilder(context, index),
      ),
    );
    if (widget.separator != null) {
      final itemsWithSeparator = <Widget>[];
      final separatorWidget = widget.separator!;
      final lastItem = items.last;
      for (final item in items) {
        itemsWithSeparator.add(item);
        if (item != lastItem) {
          itemsWithSeparator.add(separatorWidget);
        }
      }
      items
        ..clear()
        ..addAll(itemsWithSeparator);
    }
    return items;
  }
}

/// [ZzLocationListView]使用的controller，扩展了功能，可以滚动定位到指定index的item
class ZzLocationListController extends ScrollController {
  final positionKey = GlobalKey();
  var _showPosition = 0;

  VoidCallback? listener;

  void setScrollListener(VoidCallback listener) {
    this.listener = listener;
  }

  /// 滚动到指定位置
  Future<void> scrollToIndex(
    int index, {
    double offset = 0,
    ScrollPositionAlignmentPolicy alignmentPolicy =
        ScrollPositionAlignmentPolicy.explicit,
  }) async {
    _showPosition = index;
    listener?.call();
    notifyListeners();
    //给个延时，一定要在界面刷新后才会把key放置到指定的item位置，此时滚动才有效果
    Future.delayed(const Duration(milliseconds: 500), () {
      if (positionKey.currentContext != null) {
        Scrollable.ensureVisible(
          positionKey.currentContext!,
          alignmentPolicy: alignmentPolicy,
        );
        if (offset != 0) {
          super.animateTo(
            super.offset + offset,
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeOut,
          );
        }
      } else {
        if (kDebugMode) {
          print('未获取到对应context，请确保数据已经完整加载并刷新了List后再调用该方法！！！');
        }
      }
    });
  }
}
