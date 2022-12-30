import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

///可监听抽屉的打开和关闭，
///设置展开宽度
class ZzDrawer extends StatefulWidget {
  const ZzDrawer({
    Key? key,
    this.elevation = 16.0,
    required this.child,
    this.semanticLabel,
    this.widthPercent = 0.85,
    this.callback,
    this.useSafeArea = true,
  })  : assert(widthPercent < 1.0 && widthPercent > 0.0, '请检查widthPercent'),
        super(key: key);

  ///阴影大小
  final double elevation;
  final Widget child;
  final String? semanticLabel;

  ///抽屉打开的屏幕占比
  final double widthPercent;

  ///监听抽屉的开启关闭
  final DrawerCallback? callback;
  final bool useSafeArea;

  @override
  _ZzDrawerState createState() => _ZzDrawerState();
}

class _ZzDrawerState extends State<ZzDrawer> {
  @override
  void initState() {
    ///add start
    if (widget.callback != null) {
      widget.callback!(true);
    }

    ///add end
    super.initState();
  }

  @override
  void dispose() {
    ///add start
    if (widget.callback != null) {
      widget.callback!(false);
    }

    ///add end
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));
    var label = widget.semanticLabel;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
        label = widget.semanticLabel ??
            MaterialLocalizations.of(context).drawerLabel;
        break;
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      case TargetPlatform.iOS:
        label = widget.semanticLabel;
        break;
    }
    final _width = MediaQuery.of(context).size.width * widget.widthPercent;

    Widget result = widget.child;
    if (widget.useSafeArea) {
      result = SafeArea(
        child: result,
      );
    }

    return Semantics(
      scopesRoute: true,
      namesRoute: true,
      explicitChildNodes: true,
      label: label,
      child: ConstrainedBox(
        constraints: BoxConstraints.expand(width: _width),
        child: Material(
          elevation: widget.elevation,
          child: Container(
            color: Colors.white,
            child: result,
          ),
        ),
      ),
    );
  }
}
