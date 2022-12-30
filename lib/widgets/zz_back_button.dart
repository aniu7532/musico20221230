import 'package:flutter/material.dart';
import 'package:musico/app/zz_icon.dart';
import 'package:musico/widgets/zz_icon_button.dart';

class ZzBackButton extends StatelessWidget {
  /// Creates an [IconButton] with the appropriate "back" icon for the current
  /// target platform.
  const ZzBackButton({Key? key, this.color, this.margin, this.onPressed})
      : super(key: key);

  /// The color to use for the icon.
  ///
  /// Defaults to the [IconThemeData.color] specified in the ambient [IconTheme],
  /// which usually matches the ambient [Theme]'s [ThemeData.iconTheme].
  final Color? color;

  final double? margin;

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));
    return ZzIconButton(
      padding: EdgeInsets.symmetric(horizontal: margin ?? 10),
      onPressed: onPressed ??
          () {
            Navigator.maybePop(context);
          },
      icon: ZzBackButtonIcon(
        color: color ?? Colors.white,
      ),
    );
  }
}

class ZzBackButtonIcon extends StatelessWidget {
  /// Creates an icon that shows the appropriate "back" file_select for
  /// the current platform (as obtained from the [Theme]).
  const ZzBackButtonIcon({Key? key, this.color}) : super(key: key);
  final Color? color;

  /// Returns the appropriate "back" icon for the given `platform`.
  static IconData? _getIconData(TargetPlatform platform) {
    switch (platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.iOS:
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
        return ZzIcons.icon_jiantou;
    }
  }

  @override
  Widget build(BuildContext context) => Icon(
        _getIconData(Theme.of(context).platform),
        color: color,
        size: zzIconSize,
      );
}
