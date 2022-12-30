import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:math' as math;

///类似Wrap的控件，可限制显示的最大行数
class MyFlow extends MultiChildRenderObjectWidget {
  // ignore: deprecated_consistency
  MyFlow({
    Key? key,
    this.padding = EdgeInsets.zero,
    this.spacing = 10,
    this.runSpacing = 10,
    this.maxLine = 2,
    List<Widget> children = const [],
  }) : super(key: key, children: RepaintBoundary.wrapAll(children));

  final EdgeInsets padding;
  final double spacing;
  final double runSpacing;
  final int maxLine;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return MyRenderFlow(
      padding: padding,
      spacing: spacing,
      runSpacing: runSpacing,
      maxLine: maxLine,
    );
  }

  @override
  void updateRenderObject(BuildContext context, MyRenderFlow renderObject) {
    renderObject
      ..padding = padding
      ..spacing = spacing
      ..runSpacing = runSpacing
      ..maxLine = maxLine;
  }
}

///每个child都带一个parentData,在这里可以定义想用的属性
class _MyFlowParentData extends ContainerBoxParentData<RenderBox> {
  //是否可用
  bool _dirty = false;
}

///主要实现
class MyRenderFlow extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _MyFlowParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, _MyFlowParentData> {
  EdgeInsets _padding;

  set padding(EdgeInsets padding) {
    _padding = padding;
  }

  double _spacing;

  set spacing(double spacing) {
    _spacing = spacing;
  }

  double _runSpacing;

  set runSpacing(double runSpacing) {
    _runSpacing = runSpacing;
  }

  int _maxLine;

  set maxLine(int maxLine) {
    _maxLine = maxLine;
  }

  MyRenderFlow({
    EdgeInsets padding = EdgeInsets.zero,
    double spacing = 10,
    double runSpacing = 10,
    int maxLine = 3,
  })  : _padding = padding,
        _spacing = spacing,
        _runSpacing = runSpacing,
        _maxLine = maxLine;

  @override
  bool get isRepaintBoundary => true;

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _MyFlowParentData) {
      child.parentData = _MyFlowParentData();
    }
  }

  //核心方法，计算每个child的offset,也就是想对于原点的偏移位置，最终算出来满足条件的要参与layout和paint的children,
  //然后根据要显示的children的高度，算出窗口高度。
  //不参与显示的child打上_dirty=ture的标记。
  double _computeIntrinsicHeightForWidth(double width) {
    var runCount = 0;
    var height = _padding.top;
    var runWidth = _padding.left;
    var runHeight = 0.0;
    var childCount = 0;
    var child = firstChild;
    while (child != null) {
      final childWidth = child.getMaxIntrinsicWidth(double.infinity);
      final childHeight = child.getMaxIntrinsicHeight(childWidth);
      final childParentData = child.parentData! as _MyFlowParentData;
      if (runWidth + childWidth + _padding.right > width) {
        if (_maxLine > 0 && runCount + 1 == _maxLine) {
          childParentData._dirty = true;
          child = childAfter(child);
          continue;
        }
        childParentData._dirty = false;
        height += runHeight;
        if (runCount > 0) {
          height += _runSpacing;
        }
        runCount += 1;
        runWidth = _padding.left;
        runHeight = 0.0;
        childCount = 0;
      }
      //更新绘制位置start
      childParentData.offset = Offset(
          runWidth + ((childCount > 0) ? _spacing : 0),
          height + ((runCount > 0) ? _runSpacing : 0));
      //更新绘制位置end
      runWidth += childWidth;
      runHeight = math.max(runHeight, childHeight);
      if (childCount > 0) {
        runWidth += _spacing;
      }
      childCount += 1;
      child = childAfter(child);
    }
    if (childCount > 0) {
      height += runHeight + _runSpacing + _padding.bottom;
    }
    return height;
  }

  //因为是纵向换行，横向固定使用父控限定的最大宽度
  double _computeIntrinsicWidthForHeight(double height) {
    return constraints.maxWidth;
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    return _computeIntrinsicWidthForHeight(height);
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    return _computeIntrinsicWidthForHeight(height);
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    return _computeIntrinsicHeightForWidth(width);
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    return _computeIntrinsicHeightForWidth(width);
  }

  @override
  void performLayout() {
    var child = firstChild;
    if (child == null) {
      size = constraints.smallest;
      return;
    }
    size = Size(_computeIntrinsicWidthForHeight(constraints.maxHeight),
        _computeIntrinsicHeightForWidth(constraints.maxWidth));

    //布局每个child,_dirty的child自动忽略
    while (child != null) {
      final innerConstraints = constraints.loosen();
      final childParentData = child.parentData! as _MyFlowParentData;
      if (!childParentData._dirty) {
        child.layout(innerConstraints, parentUsesSize: true);
      }
      child = childParentData.nextSibling;
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    var child = firstChild;
    //绘制每个child
    while (child != null) {
      final childParentData = child.parentData! as _MyFlowParentData;
      if (!childParentData._dirty) {
        context.paintChild(child, childParentData.offset + offset);
      }
      child = childParentData.nextSibling;
    }
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    //响应点击区域，因为布局和绘制是同样的位置 ，没有偏移，所以使用默认逻辑
    // return defaultHitTestChildren(result, position: position);
    var child = firstChild;
    while (child != null) {
      final childParentData = child.parentData! as _MyFlowParentData;
      if (childParentData._dirty) {
        return false;
      }
      // if (kDebugMode) print(child.size);
      final isHit = addWithPaintOffset(
        result: result,
        offset: childParentData.offset,
        position: position,
        hitTest: (BoxHitTestResult result, Offset transformed) {
          assert(transformed == position - childParentData.offset);
          return child!.hitTest(result, position: transformed);
        },
      );
      if (isHit) {
        return true;
      }
      child = childParentData.nextSibling;
    }
    return false;
  }

  bool addWithPaintOffset({
    required BoxHitTestResult result,
    required Offset? offset,
    required Offset position,
    required BoxHitTest hitTest,
  }) {
    assert(position != null);
    assert(hitTest != null);
    final transformedPosition = offset == null ? position : position - offset;
    if (offset != null) {
      result.pushOffset(-offset);
    }
    final isHit = hitTest(result, transformedPosition);
    if (offset != null) {
      result.popTransform();
    }
    return isHit;
  }
}

class MaxLineFlowDelegate extends FlowDelegate {
  MaxLineFlowDelegate({
    this.maxLine = 3,
    this.spacing = 10,
    this.childHeight = 40,
  }) : assert(maxLine > 0, '展示的行数必须大于0');

  ///最大可展示的行数
  int maxLine;

  ///子控件之间的间隔
  double spacing;

  double childHeight;

  @override
  void paintChildren(FlowPaintingContext context) {
    //父容器尺寸
    final parentSize = context.size;
    //父容器宽度
    final screenW = parentSize.width;

    //起始位置
    var offsetX = 0.0; //x坐标
    var offsetY = 0.0; //y坐标

    for (var i = 0; i < context.childCount; i++) {
      //子控件的尺寸
      final childSize = context.getChildSize(i);
      final childWidth = childSize?.width ?? 0.0;
      final childHeight = childSize?.height ?? 0.0;

      /*如果当前x左边加上子控件宽度小于父容器宽度  则继续绘制  否则换行*/
      if (offsetX + childWidth <= screenW) {
        /*绘制子控件*/
        context.paintChild(i,
            transform: Matrix4.translationValues(offsetX, offsetY, 0));
        /*更改x坐标*/
        offsetX = offsetX + childWidth + spacing;
      } else {
        /*将x坐标重置为margin*/
        offsetX = 0.0;
        /*计算y坐标的值*/
        offsetY = offsetY + childHeight + spacing;
        /*绘制子控件*/
        context.paintChild(i,
            transform: Matrix4.translationValues(offsetX, offsetY, 0));
      }
    }
  }

  @override
  bool shouldRepaint(FlowDelegate oldDelegate) {
    return true;
  }

  @override
  Size getSize(BoxConstraints constraints) {
    //指定Flow的大小，高度必须是确定的值，这个大小在绘制之前就会确定，所以不能用子控件的高度和来计算
    return Size(
        double.infinity, childHeight * maxLine + (maxLine - 1) * spacing);
  }
}

class GridLayoutDelegate extends MultiChildLayoutDelegate {
  final double horizontalSpace;
  final double verticalSpace;
  List<Size> _itemSizes = [];

  GridLayoutDelegate(
      {required this.horizontalSpace, required this.verticalSpace});

  @override
  void performLayout(Size size) {
    //对每个child进行逐一布局
    int index = 0;
    double width = (size.width - horizontalSpace) / 2;
    var itemConstraints = BoxConstraints(
        minWidth: width, maxWidth: width, maxHeight: size.height);
    while (hasChild(index)) {
      _itemSizes.add(layoutChild(index, itemConstraints));
      index++;
    }
    //对每一个child逐一进行定位
    index = 0;
    double dx = 0;
    double dy = 0;
    while (hasChild(index)) {
      positionChild(index, Offset(dx, dy));
      dx = index % 2 == 0 ? width + horizontalSpace : 0;
      if (index % 2 == 1) {
        double maxHeight =
            math.max(_itemSizes[index].height, _itemSizes[index - 1].height);
        dy += maxHeight + verticalSpace;
      }
      index++;
    }
  }

  @override
  bool shouldRelayout(MultiChildLayoutDelegate oldDelegate) {
    return oldDelegate != this;
  }

  //确定layout的size，constraints是parent传过来的约束
  @override
  Size getSize(BoxConstraints constraints) => super.getSize(constraints);
}
