import 'package:flutter/material.dart';
import 'package:musico/base/base_page.dart';
import 'package:musico/base/provider_widget.dart';
import 'package:musico/base/refresh_list/view_state_refresh_list_model.dart';
import 'package:musico/base/view_state_model.dart';
import 'package:musico/base/view_state_widget.dart';
import 'package:musico/gen/colors.gen.dart';
import 'package:musico/widgets/search_textfield_widget.dart';
import 'package:musico/widgets/zz_app_bar.dart';
import 'package:musico/widgets/zz_scaffold.dart';
import 'package:musico/widgets/zz_title_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

///管理页公共Mixin
///M: 数据控制model
///
/// 注意  必须实现或者赋值:
///   dataModel：控制model
///   getItemWidget：子Item显示Widget
///
mixin ListMoreSearchPageStateMixin<T extends BasePage,
    M extends BaseListMoreModel> on BasePageState<T> {
  late M model;

  final GlobalKey<ScaffoldState> globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    model = initModel();
  }

  ///监听返回按钮
  Future<bool> onWillPop() {
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return WillPopScope(
      onWillPop: onWillPop,
      child: ProviderWidget(
          model: model,
          onModelReady: (m) {
            model.initData(); //初始化
          },
          builder: (context, m, c) {
            return ZzScaffold(
              key: globalKey,
//              resizeToAvoidBottomPadding: false,
              backgroundColor: ColorName.bgColor,
              endDrawer: buildEndDrawer(),
              drawerEdgeDragWidth: buildEndDrawer() == null ? 0.0 : 4.0,

              ///禁止抽屉滑动显示
              appBar: buildAppBar(),
              body: _buildBody(),
            );
          }),
    );
  }

  ///构建搜索部件
  Widget buildSearchWidget() {
    if (!model.showSearchWidget) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      height: 40,
      child: SearchTextFieldWidget(
        hintText: model.searchHintText,
        keyWord: model.searchKey,
        canPda: false,
        onClearCallback: () {
          ///清除搜索关键字
          model.reset();
        },
        onSubmitCallback: (key) {
          ///确认输入
          model.setKeyWord(key);
        },
        onSearchType: (type) {
          model.setSearchType = type;
        },
        showSearchButton: false,
        showVoiceButton: model.showVoiceInput,
        showScanCodeButton: model.showScanInput,
        scanFitterCallback: model.scanFitterCallback,
      ),
    );
  }

  Widget _buildBody() {
    ///搜索框
    final searchBar = buildSearchWidget();

    ///列表内容
    final content = buildContent();

    ///如果有下拉菜单,包裹在菜单里面
    final result = wrapDropDownMenu(content);

    return model.searchWidgetOnAppbar
        ? result
        : Column(children: <Widget>[
            ///搜索
            searchBar,

            ///列表
            Expanded(
              child: result,
            ),
          ]);
  }

  @protected
  Widget buildFooter() {
    return const SizedBox.shrink();
  }

  @protected
  Widget buildHeader() {
    return const SizedBox.shrink();
  }

  @protected
  Widget buildRight() {
    return setRightText() == ''
        ? const SizedBox.shrink()
        : Draggable(
            feedback: buildDragWidget(),
            axis: Axis.vertical,
            childWhenDragging: const SizedBox.shrink(),
            onDraggableCanceled: (Velocity velocity, Offset offset) {
              //更新位置信息
              final y = offset.dy;
              if (y < 110) {
                model.offset = 0;
              } else if (y > 450) {
                model.offset = 350;
              } else {
                model.offset = y - 110;
              }
              model.notifyListeners();
            },
            child: buildDragWidget());
  }

  GlobalKey<ScaffoldState> getGlobalKey() => globalKey;
  ViewStateModel getModel() => model;

  Widget buildDragWidget() {
    return Material(
      child: InkWell(
        onTap: () {
          model.openEndDrawerForClassify(getModel(), getGlobalKey());
        },
        child: Container(
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: Color.fromRGBO(27, 27, 27, 0.6),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5),
              bottomLeft: Radius.circular(5),
            ),
          ),
          child: Text(
            setRightText(),
            style: const TextStyle(
              fontWeight: FontWeight.normal,
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  @protected
  String setRightText() {
    return '';
  }

  @protected
  Widget? buildEndDrawer() {
    return null;
  }

  ///下拉选择菜单
  @protected
  Widget wrapDropDownMenu(Widget child) {
    return child;
  }

  ///重载，实现自定义的AppBar
  @protected
  Widget buildAppBar() {
    return model.searchWidgetOnAppbar
        ? buildAppBarWithSearch()
        : ZzAppBar(
            leading: model.needBack ? null : const SizedBox.shrink(),
            title: buildTitle(),
            actions: <Widget>[
              ...getActions(),
            ],
          );
  }

  ///重载，实现自定义的AppBar
  @protected
  Widget buildAppBarWithSearch() {
    return ZzAppBar(
      leading: model.needBack ? null : const SizedBox.shrink(),
      leadingWidth: 0.0,
      title: buildSearchWidget(),
      actions: <Widget>[
        ...getActions(),
      ],
    );
  }

  Widget buildTitle() {
    return ZzTitle(widget.title ?? '');
  }

  ///重载，实现右侧按钮
  @protected
  List<Widget> getActions() {
    return [];
  }

  ///需要用户实现
  @protected
  M initModel();

  ///构建获取到数据为空的时候显示的页面
  Widget buildEmptyWidget() {
    return ViewStateEmptyWidget(model: model);
  }

  @protected
  Widget buildContent() {
    return Column(
      children: <Widget>[
        buildHeader(),
        Expanded(
          child: buildList(),
        ),
        buildFooter(),
      ],
    );
  }

  Widget buildList() {
    ///加载中
    if (model.busy) {
      return const Center(
          child: CircularProgressIndicator(
        color: ColorName.secondaryColor,
      ));
    }

    ///加载错误
    if (model.error) {
      return ViewStateWidget(model: model);
    }

    ///空数据
    if (model.empty) {
      return buildEmptyWidget();
    }

    return SmartRefresher(
      controller: model.refreshController,
      header:
          model.useMyHeader ? const RefresherHeader() : const WaterDropHeader(),
      footer: const RefresherFooter(),
      onRefresh: model.refresh,
      onLoading: model.loadMore,
      enablePullUp: model.enablePullUp,
      enablePullDown: model.enablePullDown,
      child: getListViewWidget(),
    );
  }

  ///在第一个子项之前增加空格
  bool useSpaceBeforeFirstItem = true;

  ///抽出listview方便重写
  Widget getListViewWidget() {
    return ListView.separated(
      itemCount: model.list.length + 1,
      itemBuilder: (context, index) {
        ///第一个空，增加一个分割距离
        if (index == 0) {
          return SizedBox(
            height: useSpaceBeforeFirstItem ? 8 : 0,
          );
        }

        return getItemWidget(model.list[index - 1], index - 1);
      },
      separatorBuilder: (context, index) {
        /*       return index == 0
            ? const SizedBox.shrink()
            : (getItemDivider() ?? dividerList1);*/
        return const SizedBox.shrink();
      },
    );
  }

  ///生成列表显示  需要用户实现
  @protected
  Widget getItemWidget(item, index);

  ///ListItem之间的分割线
  @protected
  Widget? getItemDivider() {
    return null;
  }
}

abstract class BaseListMoreModel<T> extends ViewStateRefreshListModel<T> {
  //搜索关键字
  String _searchKeyword = '';

  ///是否显示搜索框
  bool showSearchWidget = true;

  ///是否把搜索框 放在 appbar上面
  bool searchWidgetOnAppbar = false;

  ///是否需要返回按钮
  bool needBack = true;

  double offset = 200;

  ///为0时，使用分类抽屉
  int drawerType = 0;

  ///下拉刷新
  bool enablePullDown = true;

  ///上拉加载
  bool enablePullUp = true;

  ///是否显示语音输入
  bool showVoiceInput = true;

  ///是否显示扫描输入
  bool showScanInput = false;

  ///输入框提示文字
  String searchHintText = '';

  SearchType searchType = SearchType.TEXT;

  String get searchKey => _searchKeyword;

  /// 扫码过滤器，如果设置了该方法并且返回false的话则会抛弃本次扫码结果
  bool Function(String code)? scanFitterCallback;

  void setSearchKey(String key) {
    _searchKeyword = key;
  }

  BaseListMoreModel({requestParam}) : super(requestParam: requestParam);

  ///设置搜索关键字
  setKeyWord(String keyword, {isFromScan = false}) async {
    _searchKeyword = keyword;
    await initData();
    afterLoadData();
  }

  setKeyWordNoUpdate(String keyword) {
    _searchKeyword = keyword;
  }

  set setSearchType(SearchType type) => searchType = type;

  ///重置状态
  reset() {
    _searchKeyword = '';
    refresh(init: true);
    notifyListeners();
  }

  ///设置停用/启用
  Future<bool> setEnable(info, bastype) async {
    const ret = false;
    // bool flag = true;
    // if (info.flag == 1) {
    //   //已停用
    //   flag = false;
    // }
    // var infoMap = info.toJson();
    // infoMap.remove('flag');
    // infoMap['flag'] = flag;
    // var map = {'data': infoMap, "bastype": bastype};
    // var result = await HttpServiceBase.getHttpServiceBase()
    //     .postString('cc.erp.bll.bas.baseinfomanager.setenable', params: map);
    // if (result != null && result['type'] == 'normal') {
    //   ret = result['data']['isFlagChanged'];
    // } else {
    //   showToast(result['msg']);
    // }
    return ret;
  }

  String dateFormat(DateTime date) {
    if (date == null) return '';
    return '';
    // return DateTimeUtil.getDateYear(date.millisecondsSinceEpoch);
  }

  ///打开侧边栏  分类
  void openEndDrawerForClassify(
      ViewStateModel model, GlobalKey<ScaffoldState> globalKey) async {
    drawerType = 0;
    model.notifyListeners();
    globalKey.currentState?.openEndDrawer();
  }
}

class RefresherHeader extends StatelessWidget {
  const RefresherHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomHeader(
      builder: (_, mode) {
        Widget body;
        if (mode == RefreshStatus.idle) {
          body = Text(
            'pull',
            style: style(),
          );
        } else if (mode == RefreshStatus.refreshing) {
          body = const CircularProgressIndicator(
            strokeWidth: 2,
          );
        } else if (mode == RefreshStatus.canRefresh) {
          body = Text(
            'loading',
            style: style(),
          );
        } else if (mode == RefreshStatus.completed) {
          body = Text(
            'complete',
            style: style(),
          );
        } else {
          body = const SizedBox.shrink();
        }
        return SizedBox(
          height: 60,
          child: Center(
            child: body,
          ),
        );
      },
    );
  }

  TextStyle style() {
    return const TextStyle(
      fontWeight: FontWeight.normal,
      color: Color(0xFFCCCCCC),
      fontSize: 12,
      textBaseline: TextBaseline.alphabetic,
    );
  }
}

class RefresherFooter extends StatelessWidget {
  const RefresherFooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ClassicFooter(
      textStyle: TextStyle(fontSize: 12, color: Color(0xFFCCCCCC)),
    );
  }
}

///通用底部文字Footer
class TextFooter extends StatelessWidget {
  TextFooter({Key? key, this.noDataText = 'aniu.flutter'}) : super(key: key);

  String noDataText;

  @override
  Widget build(BuildContext context) {
    return ClassicFooter(
      height: 50,
      noDataText: noDataText,
      textStyle: const TextStyle(fontSize: 14, color: Color(0xFFC5CAD5)),
    );
  }
}
