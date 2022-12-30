import 'dart:io';

import 'package:musico/base/base_page.dart';
import 'package:musico/base/base_page_mixin.dart';
import 'package:musico/gen/colors.gen.dart';
import 'package:musico/pages/home/setting/privacy/privacy_policy_model.dart';
import 'package:musico/utils/font_style_utils.dart';
import 'package:musico/utils/toast_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyPolicyPage extends BasePage {
  PrivacyPolicyPage({Key? key, Map<String, dynamic>? requestParams})
      : super(key: key, requestParams: requestParams);

  @override
  State<PrivacyPolicyPage> createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends BasePageState<PrivacyPolicyPage>
    with BasePageMixin<PrivacyPolicyPage, PrivacyPolicyModel> {
  @override
  PrivacyPolicyModel initModel() {
    return PrivacyPolicyModel(requestParam: widget.requestParams);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget buildContentWidget() {
    return Container(
      color: ColorName.themeColor,
      child: WebView(
        initialUrl: widget.requestParams!['url'],
      ),
    );
  }
}
