import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:musico/gen/colors.gen.dart';

///
/// 为适应全面屏手机，
///
class ZzScaffold extends Scaffold {
  ZzScaffold({
    Key? key,
    appBar,
    body,
    floatingActionButton,
    floatingActionButtonLocation,
    floatingActionButtonAnimator,
    persistentFooterButtons,
    drawer,
    onDrawerChanged,
    endDrawer,
    onEndDrawerChanged,
    bottomNavigationBar,
    bottomSheet,
    backgroundColor = ColorName.bgColor,
    resizeToAvoidBottomInset,
    primary = true,
    drawerDragStartBehavior = DragStartBehavior.start,
    extendBody = false,
    extendBodyBehindAppBar = false,
    drawerScrimColor,
    drawerEdgeDragWidth,
    drawerEnableOpenDragGesture = true,
    endDrawerEnableOpenDragGesture = true,
    restorationId,
  }) : super(
          key: key,
          appBar: appBar != null
              ? PreferredSize(
                  preferredSize: const Size(double.maxFinite, 44),
                  child: _Unfocus(
                    child: appBar,
                  ),
                )
              : null,
          body: appBar == null
              ? body
              : (body == null
                  ? body
                  : _Unfocus(
                      child: SafeArea(
                        child: body,
                      ),
                    )),
          floatingActionButton: floatingActionButton,
          floatingActionButtonLocation: floatingActionButtonLocation,
          floatingActionButtonAnimator: floatingActionButtonAnimator,
          persistentFooterButtons: persistentFooterButtons,
          drawer: drawer,
          onDrawerChanged: onDrawerChanged,
          endDrawer: endDrawer,
          onEndDrawerChanged: onEndDrawerChanged,
          bottomNavigationBar: bottomNavigationBar,
          bottomSheet: bottomSheet,
          backgroundColor: backgroundColor ?? Colors.white,
          resizeToAvoidBottomInset: resizeToAvoidBottomInset,
          primary: primary ?? true,
          drawerDragStartBehavior:
              drawerDragStartBehavior ?? DragStartBehavior.start,
          extendBody: extendBody ?? false,
          extendBodyBehindAppBar: extendBodyBehindAppBar ?? false,
          drawerScrimColor: drawerScrimColor,
          drawerEdgeDragWidth: drawerEdgeDragWidth,
          drawerEnableOpenDragGesture: drawerEnableOpenDragGesture,
          endDrawerEnableOpenDragGesture: endDrawerEnableOpenDragGesture,
          restorationId: restorationId,
        );
}

///按下空白处时隐藏输入法
class _Unfocus extends StatelessWidget {
  const _Unfocus({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: child,
    );
  }
}
