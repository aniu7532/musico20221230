import 'package:flutter/material.dart';
import 'package:musico/utils/log_util.dart';

///使用说明：
/// class DemoPage extends BasePage {
///
///   @override
///    _DemoPageState createState() => _DemoPageState();
/// }
///
/// class _DemoPageState extends BasePageState<DemoPage> {
///
/// }
///

class BasePage extends StatefulWidget {
  BasePage({Key? key, this.requestParams})
      : title = requestParams != null ? (requestParams['title'] ?? '') : '',
        super(key: key);

  final Map<String, dynamic>? requestParams;
  final String? title;

  @override
  State<StatefulWidget> createState() => BasePageState();
}

class BasePageState<T extends BasePage> extends State<T> {
  @override
  void initState() {
    super.initState();
    if (widget.requestParams != null &&
        widget.requestParams!['title'] != null) {
      logger.v(widget.requestParams!['title']);
    }
//    print('growio initState 埋点开始位置');
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
//    print('growio didChangeDependencies');
  }

  @override
  void didUpdateWidget(T oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void deactivate() {
    super.deactivate();
//    print('growio deactivate');
  }

  @override
  void dispose() {
    super.dispose();
//    debugPrint('growio dispose 埋点结束位置');
  }
}
