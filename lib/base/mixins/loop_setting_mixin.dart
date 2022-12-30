import 'package:dio/dio.dart';
import 'package:flustars/flustars.dart';
import 'package:musico/utils/log_util.dart';

///
///Create by 李实 on 2022/6/15 19:07
///
///Description: 定时请求一次配置信息，并重新缓存
///
mixin LoopSettingMixin {
  ///记录取消请求的列表
  CancelToken pageCancelToken = CancelToken();

  final totalTime = 30 * 60 * 1000;

  ///定时器
  late TimerUtil timer;

  ///开始轮训
  startLoop() {
    timer = TimerUtil();
    timer
      ..setTotalTime(totalTime)
      ..setOnTimerTickCallback((millisUntilFinished) {
        if (millisUntilFinished == 0) {
          Future.wait([
            /*
            settingDataUtil.getCommonConfData(cancelToken: pageCancelToken),
            settingDataUtil.getPMSInfo(cancelToken: pageCancelToken),
            settingDataUtil.getShopConfigInfo(cancelToken: pageCancelToken),
            settingDataUtil.getSetting(cancelToken: pageCancelToken),
            settingDataUtil.getBillSetting(cancelToken: pageCancelToken),
            settingDataUtil.getCostProfitInfo(cancelToken: pageCancelToken),
            settingDataUtil.getBillTypeList(cancelToken: pageCancelToken),*/
          ]);
          startLoop();
        }
      })
      ..startCountDown();
  }

  disposeLoop() {
    try {
      timer.cancel();
      if (!pageCancelToken.isCancelled) {
        pageCancelToken.cancel();
      }
    } catch (e) {
      logger.v(e);
    }
  }
}
