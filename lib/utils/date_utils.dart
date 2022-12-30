class ZzDateUtils {
  /// 将时间中的秒置为0后，再转为时间戳（makeTime处理 同H5 PC）
  static int getExpectSecond(DateTime time) {
    return DateTime(time.year, time.month, time.day, time.hour, time.minute)
        .millisecondsSinceEpoch;
  }
}
