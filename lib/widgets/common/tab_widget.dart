import 'package:flutter/material.dart';
import 'package:musico/gen/colors.gen.dart';
import 'package:musico/utils/divider_urils.dart';
import 'package:musico/utils/size_utils.dart';

class BottomTabBar extends StatelessWidget {
  const BottomTabBar({
    Key? key,
    this.selectedIndex = 0,
    this.showElevation = false,
    this.iconSize = 16,
    this.backgroundColor,
    this.itemCornerRadius = 5,
    this.containerHeight = 56,
    this.mainAxisAlignment = MainAxisAlignment.spaceBetween,
    required this.items,
    required this.onItemSelected,
  })  : assert(items.length >= 2 && items.length <= 5, 'TAB范围为2-5'),
        super(key: key);

  /// item选中索引，默认0
  final int selectedIndex;

  /// icon的大小
  final double iconSize;

  /// 背景色
  final Color? backgroundColor;

  final bool showElevation;

  /// 显示的tab数据
  final List<BottomTabBarItem> items;

  /// item点击回调
  final ValueChanged<int> onItemSelected;

  final MainAxisAlignment mainAxisAlignment;

  /// [items] 的圆角, 默认 50.
  final double itemCornerRadius;

  /// tab的高度. 默认 56.
  final double containerHeight;

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? Theme.of(context).bottomAppBarColor;

    return Container(
      decoration: BoxDecoration(
        color: ColorName.themeColor.withOpacity(0.4),
        boxShadow: [
          if (showElevation)
            BoxShadow(
              color: ColorName.themeColor.withOpacity(0.4),
              blurRadius: 2,
            ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: sizeUtil.h60,
          child: Column(
            children: [
              dividerNormal1,
              Expanded(
                child: Row(
                  mainAxisAlignment: mainAxisAlignment,
                  children: items.map((item) {
                    var index = items.indexOf(item);
                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => onItemSelected(index),
                      child: _ItemWidget(
                        item: item,
                        iconSize: iconSize,
                        isSelected: index == selectedIndex,
                        backgroundColor: bgColor,
                        itemCornerRadius: itemCornerRadius,
                      ),
                    );
                  }).toList(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _ItemWidget extends StatelessWidget {
  const _ItemWidget({
    Key? key,
    required this.item,
    required this.isSelected,
    required this.backgroundColor,
    required this.itemCornerRadius,
    required this.iconSize,
  }) : super(key: key);

  final double iconSize;
  final bool isSelected;
  final BottomTabBarItem item;
  final Color backgroundColor;
  final double itemCornerRadius;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      selected: isSelected,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: isSelected ? item.icon : item.inactiveIcon,
      ),
    );
  }
}

/// [BottomTabBar.items] 参数
class BottomTabBarItem {
  BottomTabBarItem({
    required this.icon,
    required this.inactiveIcon,
    required this.title,
    this.activeColor = ColorName.themeColor,
    this.textAlign = TextAlign.center,
    this.inactiveColor = const Color(0xFF111A34),
  });

  ///选中时的Icon
  final Widget icon;

  ///未选中时的Icon
  final Widget inactiveIcon;

  final Widget title;

  /// 选择时定义的icon和title颜色。默认为Colors.blue
  final Color activeColor;

  /// 未选择此项时定义的icon和title颜色
  final Color? inactiveColor;

  /// title的对齐方式。
  ///
  /// 这只有在将其title为Text时才会生效
  final TextAlign? textAlign;
}
