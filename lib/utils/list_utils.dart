import 'package:flutter/cupertino.dart';

class ListUtil {
  static List<Widget> joinSpaceWidget({
    required List<Widget> widgets,
    required Widget spaceWidget,
  }) {
    final tempList = <Widget>[];
    for (final sub in widgets) {
      tempList.add(sub);
      if (sub != widgets.last) {
        tempList.add(spaceWidget);
      }
    }
    return tempList;
  }
}
