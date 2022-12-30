import 'package:musico/base/refresh_list/list_more_page_searchbar_mixin.dart';
import 'package:musico/gen/assets.gen.dart';
import 'package:musico/pages/home/import/import_model.dart';
import 'package:musico/utils/toast_util.dart';

mixin _Protocol {}

class ImportFromComputerModel extends BaseListMoreModel<ImportItemBean>
    with _Protocol {
  ImportFromComputerModel({Map<String, dynamic>? requestParam})
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
        title:
            ' Make sure your device and computer are connected to the same Wi-Fi network',
        description:
            ' Make sure your device and computer are connected to the same Wi-Fi network',
        icon: Assets.images.imports.pathComputer1,
        pathIcon: Assets.images.imports.tipsComputer1,
      ),
      ImportItemBean(
        title:
            ' Write down the given ip address on your browser(not google search)',
        description:
            ' Write down the given ip address on your browser(not google search)',
        icon: Assets.images.imports.pathComputer2,
        pathIcon: Assets.images.imports.tipsComputer2,
      ),
      ImportItemBean(
        title: ' Select MP3 files from computer',
        description: ' Select MP3 files from computer',
        icon: Assets.images.imports.pathComputer3,
        pathIcon: Assets.images.imports.tipsComputer3,
      ),
    ];
  }
}
