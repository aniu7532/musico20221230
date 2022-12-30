final appCommon = AppCommon();

///公共配置
class AppCommon {
  factory AppCommon() => _instance;
  AppCommon._();
  static late final AppCommon _instance = AppCommon._();

  ///腾讯云前缀
  late String baseOssUrl;
}
