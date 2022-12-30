import 'package:flutter/material.dart';

class CloseIconWidget extends StatelessWidget {
  const CloseIconWidget({
    Key? key,
    this.onCallback,
    this.enablePop = true,
    this.padding = 10,
  }) : super(key: key);

  final VoidCallback? onCallback;
  final bool enablePop;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (onCallback != null) onCallback!();
        if (enablePop) {
          Navigator.pop(context);
        }
      },
      child: Container(
        padding: EdgeInsets.all(padding),
        child: const Icon(
          Icons.clear,
          size: 15,
          color: Color(0xFFCCCCCC),
        ),
      ),
    );
  }
}
