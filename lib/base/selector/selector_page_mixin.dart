import 'package:flutter/material.dart';
import 'package:musico/app/myapp.dart';
import 'package:musico/app/zz_icon.dart';
import 'package:musico/base/base_page.dart';
import 'package:musico/base/provider_widget.dart';
import 'package:musico/base/refresh_list/list_more_page_searchbar_mixin.dart';
import 'package:musico/base/selector/selector_base_model.dart';
import 'package:musico/base/view_state_widget.dart';
import 'package:musico/gen/colors.gen.dart';
import 'package:musico/utils/divider_urils.dart';
import 'package:musico/utils/font_style_utils.dart';
import 'package:musico/widgets/primary_button.dart';
import 'package:musico/widgets/search_textfield_widget.dart';
import 'package:musico/widgets/zz_app_bar.dart';
import 'package:musico/widgets/zz_icon_button.dart';
import 'package:musico/widgets/zz_scaffold.dart';
import 'package:musico/widgets/zz_title_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

///选择器公用Mixin
///搜索功能、列表展示、右边抽屉分类选择
///新增、单选、多选
mixin SelectorMixin<P extends BasePage, M extends BaseSelectorModel>
    on BasePageState<P> {
  late M model;

  final GlobalKey<ScaffoldState> globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    model = initModel();
  }

  ///初始化Model
  @protected
  M initModel();

  @override
  Widget build(BuildContext context) {
    return ProviderWidget(
        model: model,
        onModelReady: (M model) {
          model.initData(); //初始化
        },
        builder: (_, m, c) {
          return ZzScaffold(
            key: globalKey,
            appBar: buildHeader(),
            endDrawer: buildEndDrawer(),
            drawerEdgeDragWidth: 0.0,
            body: buildBody(context),
          );
        });
  }

  ///内容
  Widget buildBody(BuildContext context) {
    List<Widget> _buildInnerWidget() {
      final listWidget = <Widget>[
        buildHeader1(),
        Expanded(
          child: buildListView(context),
        ),
        Visibility(
          visible: model.enableMulti && model.enable,
          child: buildSummaryWidget(),
        ),
        Visibility(
          visible: model.enable,
          child: buildFooter(),
        )
      ];

      return listWidget;
    }

    return Stack(
      children: <Widget>[
        Container(
          width: double.maxFinite,
          height: double.maxFinite,
          color: ColorName.bgColor,
          child: Column(
            children: <Widget>[
              buildHeader0(),
              Offstage(
                offstage: model.hideSearch,
                child: _buildSearch(),
              ),
              ..._buildInnerWidget(),
            ],
          ),
        ),
        Positioned(
          right: 0,
          top: MediaQuery.of(context).size.height / 3,
          child: buildRight(),
        ),
      ],
    );
  }

  Widget buildHeader0() {
    return const SizedBox.shrink();
  }

  Widget buildHeader1() {
    return const SizedBox.shrink();
  }

  // CustomDropdownMenu getCustomDropdownMenu(Widget child)=>child;

  ///汇总数据显示  按钮之上
  Widget buildSummaryWidget() => const SizedBox.shrink();

  ///底部 默认是确认按钮
  Widget buildFooter() {
    if (!model.enableMulti) {
      return const SizedBox.shrink();
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 60,
      color: Colors.white,
      child: Row(
        children: [
          Text.rich(
            TextSpan(
              text: '已选：',
              children: [
                TextSpan(
                  text: '${model.selectList.length}',
                  style: const TextStyle(
                    color: ColorName.themeColor,
                    fontSize: 16,
                  ),
                ),
                const TextSpan(text: ' 项 ')
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              ///清除选择
              model.onClear();
            },
            child: const Text(
              '清除选择',
              style: TextStyle(color: ColorName.themeColor),
            ),
          ),
          const Spacer(),
          SizedBox(
            width: 120,
            height: 40,
            child: PrimaryButton(
              onPressed: () {
                ///多选返回
                model.onMultiSelectedBack();
              },
            ),
          )
        ],
      ),
    );
  }

  ///头部  已默认实现（包含新增按钮）
  Widget? buildHeader() {
    if (model.hideHeader) return null;
    return ZzAppBar(
      title: buildTitle(),
      leading: buildBackButton(),
      actions: <Widget>[
        Visibility(
          visible: !model.hideAdd,
          child: ZzIconButton(
            icon: const Icon(
              ZzIcons.icon_tianjia,
              size: 16,
            ),
            onPressed: onAddButtonPressed,
          ),
        ),
      ],
    );
  }

  Widget? buildBackButton() {
    return null;
  }

  ///当点击添加按钮时调用
  void onAddButtonPressed() {}

  ///标题
  Widget buildTitle() {
    return ZzTitle(widget.title ?? '');
  }

  ///构建搜索框
  Widget _buildSearch() {
    return Container(
      alignment: Alignment.center,
      height: 52,
      color: Colors.white,
      margin: EdgeInsets.only(bottom: model.searchBottom ?? 5),
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: SizedBox(
        height: 36,
        child: Row(
          children: <Widget>[
            Expanded(
              child: SearchTextFieldWidget(
//            key: ValueKey('searchKey:${model.searchKey}'),
                hintText: model.searchHintText,
                keyWord: model.searchKey,
                showVoiceButton: model.showVoiceSearch,
                showScanCodeButton: model.showScanSearch,
                onSubmitCallback: (key) {
                  ///确认输入
                  model.changeSearch(key);
                },
                onSearchType: (type) => model.searchType = type,
                showManualButton: model.showManualButton,
                scanDialogTitle: model.scanDialogTitle,
              ),
            ),
            buildSearchRight(),
          ],
        ),
      ),
    );
  }

  Widget buildSearchRight() => const SizedBox.shrink();

  @protected
  Widget buildRight() {
    return setRightText() == ''
        ? Container()
        : InkWell(
            onTap: () {
              model.notifyListeners();
              globalKey.currentState?.openEndDrawer();
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
                style: FSUtils.font_normal_14_white,
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

  ///构建列表
  Widget buildListView(BuildContext context) {
    ///异常状态显示
    if (!model.idle || LoadStatusWidget.isEmpty(model)) {
      return LoadStatusWidget(model: model);
    }

    ///正常显示
    final list = model.list;

    return SmartRefresher(
      enablePullUp: model.enablePullUp,
      enablePullDown: model.enablePullDown,
      header: const WaterDropHeader(),
      footer: model.needTextFooter
          ? TextFooter(
              noDataText: model.noDataText,
            )
          : const RefresherFooter(),
      controller: model.refreshController,
      onRefresh: model.refresh,
      onLoading: model.loadMore,
      child: ListView.separated(
        padding: model.listViewPadding ?? const EdgeInsets.all(0),
        itemCount: list.length,
        itemBuilder: (c, i) {
          return model.needIndex
              ? buildContentWidgetWithIndex(list[i], i)
              : buildContentWidget(list[i]);
        },
        separatorBuilder: (c, i) {
          return model.needDiver ? dividerList1 : const SizedBox.shrink();
        },
      ),
    );
  }

  @protected
  onListRowItemClick(item) {
    appRouter.pop(item);
  }

  ///构建列表数据
  @protected
  Widget buildContentWidget(dynamic item);

  ///构建列表数据,带index
  Widget buildContentWidgetWithIndex(dynamic item, int i) {
    return const SizedBox.shrink();
  }
}
