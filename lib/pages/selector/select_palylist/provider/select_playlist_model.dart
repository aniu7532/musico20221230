import 'package:musico/app/myapp.dart';
import 'package:musico/base/selector/selector_base_model.dart';
import 'package:musico/const/app_data.dart';
import 'package:musico/eventbus/refresh_library_event.dart';
import 'package:musico/utils/helper/audio_query_helper.dart';
import 'package:musico/utils/toast_util.dart';
import 'package:flustars/flustars.dart';
import 'package:on_audio_query/on_audio_query.dart';

mixin _Protocol {}

/// palylist选择 model
class SelectPlaylistModel extends BaseSelectorModel<PlaylistModel>
    with _Protocol {
  SelectPlaylistModel({Map<String, dynamic>? requestParam})
      : super(requestParam: requestParam) {
    hideSearch = true;
    needDiver = false;
    if (ObjectUtil.isNotEmpty(requestParam) &&
        requestParam!.containsKey('audioId')) {
      audioId = int.tryParse(requestParam['audioId']);
    }
    if (ObjectUtil.isNotEmpty(requestParam) &&
        requestParam!.containsKey('audioPath')) {
      audioPath = requestParam['audioPath'];
    }
  }

  int? audioId;
  String? audioPath;

  @override
  Future<bool> initData() async {
    setBusy(true);
    return super.initData();
  }

  @override
  Future<List<PlaylistModel>> loadRefreshListData({int? pageNum}) async {
    return audioQueryHelper.queryLibrary();
  }

  void click(PlaylistModel opItem) async {
    final b = await audioQueryHelper.addToPlaylist(
      opItem.id,
      audioId ?? 0,
      audioPath,
    );
    if (b) {
      MyToast.showToast(b ? 'Song Add Successfully' : 'failed');
    } else {
      MyToast.showToast('The Song  had already exist');
    }

    if (b) {
      AppData.eventBus.fire(RefreshLibraryEvent('refresh'));
      appRouter.pop();
    }
  }
}
