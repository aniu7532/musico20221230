import 'package:flutter/material.dart';
import 'package:musico/base/base_page.dart';
import 'package:musico/base/baseinfo/base_info_edit_model.dart';
import 'package:musico/base/provider_widget.dart';
import 'package:musico/base/view_state_widget.dart';
import 'package:musico/const/app_data.dart';
import 'package:musico/utils/dialog_utils.dart';
import 'package:musico/widgets/common/loading_button.dart';
import 'package:musico/widgets/dialog/center_base_dialog.dart';
import 'package:musico/widgets/zz_app_bar.dart';
import 'package:musico/widgets/zz_scaffold.dart';
import 'package:musico/widgets/zz_title_widget.dart';

mixin BaseInfoEditMixin<P extends BasePage, M extends BaseInfoEditModel>
    on BasePageState<P> {
  late M model;

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
    return WillPopScope(
      onWillPop: () async {
        if (model.dataChanged) {
          await showElasticDialog(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext context) {
              return CenterBaseDialog(
                hiddenTitle: true,
                cancelText: '否',
                confirmText: '是',
                top: 0,
                contentBottomMargin: 0,
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  model.btnController.reset();
                  model.btnControllerLeft.reset();
                },
                onCancel: () {
                  model.btnController.reset();
                  model.btnControllerLeft.reset();
                },
                child: const Padding(
                  padding: EdgeInsets.only(top: 25, bottom: 25),
                  child: Text(
                    '页面已修改，是否返回?',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                      color: Color(0xFF111111),
                    ),
                  ),
                ),
              );
            },
          );
        }
        return !model.dataChanged;
      },
      child: ZzScaffold(
        resizeToAvoidBottomInset: true,
        appBar: buildAppBar(),
        body: ProviderWidget<M>(
          model: model,
          builder: (context, model, child) {
            ///异常状态显示
            if (!model.idle || LoadStatusWidget.isEmpty(model)) {
              return LoadStatusWidget(model: model);
            }

            ///正常显示
            return _buildBody();
          },
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      children: <Widget>[
        ///顶部内容
        buildTopWidget(),

        ///主要内容
        if (model.notUseBaseInfoEditBuildContent)
          buildContentWidget()
        else
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 10),
              controller: model.controller,
              physics: model.canScroll
                  ? const BouncingScrollPhysics()
                  : const NeverScrollableScrollPhysics(),
              child: buildContentWidget(),
            ),
          ),

        ///保存按钮
        buildSaveButton(),
      ],
    );
  }

  ///标题
  @protected
  ZzTitle? buildTitle();

  ///顶部
  @protected
  Widget buildTopWidget() {
    return const SizedBox();
  }

  ///内容
  @protected
  Widget buildContentWidget();

  ///头部
  Widget buildAppBar() {
    return ZzAppBar(
      title: buildTitle() ??
          ZzTitle(model.opType == OperateType.modify ? '编辑' : '添加'),
      actions: <Widget>[
        ...buildIcons(),
      ],
    );
  }

  ///头部按钮
  List<Widget> buildIcons() {
    return [];
  }

  ///保存按钮
  Widget buildSaveButton() {
    return Visibility(
      visible: model.showSaveButton,
      // visible: true,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: RoundedLoadingButton(
          width: MediaQuery.of(AppData.rootContext).size.width - 40,
          controller: model.btnController,
          onPressed: model.save,
          child: const Text(
            '保存',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
