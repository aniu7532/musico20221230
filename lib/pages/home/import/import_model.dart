import 'package:musico/app/myapp.dart';
import 'package:musico/base/refresh_list/list_more_page_searchbar_mixin.dart';
import 'package:musico/gen/assets.gen.dart';
import 'package:musico/router/router.gr.dart';

mixin _Protocol {}

class ImportModel extends BaseListMoreModel<ImportItemBean> with _Protocol {
  ImportModel({Map<String, dynamic>? requestParam})
      : super(requestParam: requestParam) {
    showSearchWidget = false;
    enablePullUp = false;
    enablePullDown = false;
  }

  @override
  Future<bool> initData() async {
    setBusy(true);
    return super.initData();
  }

  @override
  Future<List<ImportItemBean>> loadRefreshListData({int? pageNum}) async {
    return [
      ImportItemBean(
        title: 'Import playlist from other app',
        description: 'import music playlist from spotify/apple music etc',
        icon: Assets.images.imports.typeApp,
      ),
      ImportItemBean(
        title: 'Computer',
        description: 'import music from your computer',
        icon: Assets.images.imports.typeComputer,
      ),
      ImportItemBean(
        title: 'Phone',
        description: 'Import music from your phone',
        icon: Assets.images.imports.typePhone,
      ),
      ImportItemBean(
        title: 'Other Device',
        description: 'import music from other phone device',
        icon: Assets.images.imports.typeDevice,
      ),
      ImportItemBean(
        title: 'Google Drive',
        description: 'import music from other google drive',
        icon: Assets.images.imports.typeGoogle,
      ),
    ];
  }

  ///点击时间
  void click(int pos) {
    switch (pos) {
      case 0:
      case 1:
      case 2:
        appRouter.push(
          ImportFromPhoneRoute(requestParams: const {'title': 'Import'}),
        );
        break;
      case 3:
      case 4:
        appRouter.push(
          ImportFromComputerRoute(requestParams: const {'title': 'Import'}),
        );
        break;
    }
  }
}

class ImportItemBean {
  ImportItemBean({
    required this.title,
    required this.description,
    required this.icon,
    this.pathIcon,
  });
  final String title;
  final String description;
  final AssetGenImage icon;
  final AssetGenImage? pathIcon;
}
