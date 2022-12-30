import 'dart:async';

///缓存管理帮助类
class CacheTimerHelper {
  ///延时执行缓存函数
  ///
  /// [delayTime] 延迟的时间 单位毫秒
  CacheTimerHelper(this.callback, {int delayTime = 0}) {
    if (delayTime > 0) {
      _delayMillisecond = delayTime;
    }
  }

  ///延时回调函数
  Function? callback;

  ///延时3000毫秒钟进行
  int _delayMillisecond = 3000;

  ///定时器
  Timer? _timer;

  ///开始时间
  int _startTime = 0;

  ///请求更新
  bool enableUpdate = false;

  ///执行缓存函数
  void startCacheData() {
    enableUpdate = true;
    _startTime = DateTime.now().millisecondsSinceEpoch;

    if (_timer != null) {
      return;
    }

    _timer = Timer.periodic(const Duration(milliseconds: 200), _execCache);
  }

  _execCache(t) {
    ///不用更新，直接返回
    if (!enableUpdate) {
      return;
    }

    if (DateTime.now().millisecondsSinceEpoch - _startTime >
        _delayMillisecond) {
      ///timer == null 代表提前dispose了
      if (callback != null && _timer != null) {
        callback!();
      }

      ///已经更新，等下次
      enableUpdate = false;
    }
  }

  void dispose() {
    _timer?.cancel();
    _timer = null;
  }
}
