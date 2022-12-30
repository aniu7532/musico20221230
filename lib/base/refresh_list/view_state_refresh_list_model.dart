import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:musico/base/view_state_list_model.dart';
import 'package:musico/utils/app_crash_util.dart';

///多页，分页获取数据，下拉可刷新, 上拉加载更多

/// 基于 多页,
abstract class ViewStateRefreshListModel<T> extends ViewStateListModel<T> {
  ViewStateRefreshListModel({Map<String, dynamic>? requestParam})
      : super(requestParam: requestParam) {
    if (requestParam != null && requestParam.containsKey('billtype')) {
      mBillType = requestParam['billtype'] ?? 0;
    }
  }

  num mBillType = 0;

  /// 分页第一页页码
  static const int pageNumFirst = 0;

  /// 分页条目数量
  static const int pageSize = 20;

  ///Item总数量
  int totalCount = 0;

  final RefreshController _refreshController = RefreshController();

  RefreshController get refreshController => _refreshController;

  bool useMyHeader = false;

  /// 当前页码
  int currentPageNum = pageNumFirst;

  bool needInsertMethod = false;

  insertMethod() {}

  /// 下拉刷新 init=true,第一次加载，整体加载中效果，false: 下拉加载中的效果
  refresh({bool init = false}) async {
    if (init) {
      setBusy(true);
    }
    try {
      var data = await loadListData(0);

      if (error) {
        notifyListeners();
        return [];
      }
      if (data == null || data.isEmpty) {
        list.clear();
        setEmpty();
      } else {
        currentPageNum = pageNumFirst + 1;
        list.clear();
        list.addAll(data);
        refreshController.refreshCompleted();

        if (list.length >= totalCount) {
          refreshController.loadNoData();
        } else {
          //防止上次上拉加载更多失败,需要重置状态
          refreshController.loadComplete();
        }
        if (init) {
          //改变页面状态为非加载中
          setBusy(false);
        } else {
          notifyListeners();
        }
      }
      if (needInsertMethod) {
        insertMethod();
      }
      return data;
    } catch (e, s) {
      handleCatch(e, s);
      return null;
    }
  }

  /// 上拉加载更多
  Future<List<T>?> loadMore() async {
    try {
      var data = await loadListData(null);
      if (data.isEmpty) {
        refreshController.loadNoData();
      } else {
        ///操作成功，当前页加1
        currentPageNum++;

        list.addAll(data);
        //print('-----------mm ddd totalCount = $totalCount list.length = ${list.length} ');

        if (list.length >= totalCount) {
          refreshController.loadNoData();
        } else {
          refreshController.loadComplete();
        }
        loadMoreDealWithList();
        notifyListeners();
      }
      return data;
    } catch (e, s) {
      //currentPageNum--;
      refreshController.loadFailed();
      AppCrashChain.printError(e, s);
      return null;
    }
  }

  /// 加载更多数据处理
  void loadMoreDealWithList() {}

  /// 加载数据
  Future<List<T>> loadRefreshListData({int? pageNum});

  @override
  Future<List<T>> loadListData(int? pageNum) async {
    return loadRefreshListData(
      pageNum: (pageNum != null) ? (pageNum + 1) : (currentPageNum + 1),
    );
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  ///仅仅使用在带搜索bar时
  ///如果使用了 ListMoreSearchPageStateMixin 模板, 需要重载实现
  void setSearchModel(searchModel) {}

  //
  bool get canPullUp {
    if (list != null && list.length < totalCount) return true;
    return false;
  }
}
