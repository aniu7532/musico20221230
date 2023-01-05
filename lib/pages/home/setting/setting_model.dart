import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:musico/app/myapp.dart';
import 'package:musico/base/refresh_list/list_more_page_searchbar_mixin.dart';
import 'package:musico/gen/assets.gen.dart';
import 'package:musico/router/router.gr.dart';
import 'package:musico/utils/toast_util.dart';
import 'package:url_launcher/url_launcher.dart';

mixin _Protocol {}

class SettingModel extends BaseListMoreModel<ImportItemBean> with _Protocol {
  SettingModel({Map<String, dynamic>? requestParam})
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
      /* ImportItemBean(
        title: 'Language',
        description: 'Language',
        icon: Assets.images.setting.iconLanguage,
      ),*/
      ImportItemBean(
        title: 'Contact Us',
        description: 'Contact Us',
        icon: Assets.images.setting.iconContactUs,
      ),
      /*  ImportItemBean(
        title: 'Score',
        description: 'Score',
        icon: Assets.images.setting.iconScore,
      ),*/
      ImportItemBean(
        title: 'Privacy Policy',
        description: 'Privacy Policy',
        icon: Assets.images.setting.iconPrivacyPolicy,
      ),
      ImportItemBean(
        title: 'Term of Servers',
        description: 'Term of Servers',
        icon: Assets.images.setting.iconTeemOfServers,
      ),
    ];
  }

  Future<void> _openUrl() async {
    if (await canLaunch('mailto:support@freemusicplayer.net')) {
      await launch('mailto:support@freemusicplayer.net');
    } else {
      MyToast.showDialog('support@freemusicplayer.net');
    }
  }

  ///点击
  void click(int pos) {
    switch (pos) {
      case 0:
        _openUrl();

        break;
      case 1:
        appRouter.push(
          PrivacyPolicyRoute(
            requestParams: const {
              'title': 'Privacy Policy',
              'url': 'https://musicoapp.com/privacy/'
            },
          ),
        );
        break;
      case 2:
        appRouter.push(
          PrivacyPolicyRoute(
            requestParams: const {
              'title': 'Term Of Service',
              'url': 'https://musicoapp.com/terms/'
            },
          ),
        );
        break;
    }
  }
}

void loginFaceBook() async {
  await _sendAnalyticsEvent();
  if (!kIsWeb) {
    final result = await FacebookAuth.instance
        .login(); // by default we request the email and the public profile
    if (kDebugMode) {
      print('facebook login status:${result.status}');
      print('facebook login message:${result.message}');
    }
    if (result.status == LoginStatus.success) {
      // you are logged
      final accessToken = result.accessToken!;
    } else {}
  }
}

Future<void> _sendAnalyticsEvent() async {
  await FirebaseAnalytics.instance.logEvent(
    name: 'select_content',
    parameters: {
      'content_type': 'image',
      'item_id': 'ani',
    },
  );
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
