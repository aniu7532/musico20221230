class MyDateUtils {
  ///获取当前微秒时间戳
  static int getNowDateMics() {
    return DateTime.now().microsecondsSinceEpoch;
  }

  ///获取本月的第一天
  static DateTime? getFirstDayOfMouth() {
    final dateNow = DateTime.now();
    final mouth = '${dateNow.month}'.padLeft(2, '0');
    final str = '${dateNow.year}-$mouth-01';
    final returnDate = DateTime.tryParse(str);
    return returnDate;
  }

  ///获取本月的最后一天
  static DateTime? getLastDayOfMouth() {
    final dateNow = DateTime.now();
    var mouth = '';
    var year = dateNow.year;
    if (dateNow.month != 12) {
      mouth = '${dateNow.month + 1}'.padLeft(2, '0');
    } else {
      year = dateNow.year + 1;
      mouth = '01';
    }
    final str = '$year-$mouth-01';
    final returnDate = DateTime.tryParse(str);
    return returnDate?.add(const Duration(days: -1));
  }

  ///获取当前 DateTime 的 00:00
  static DateTime? getStartOfToday(DateTime dateNow) {
    final mouth = '${dateNow.month}'.padLeft(2, '0');
    final day = '${dateNow.day}'.padLeft(2, '0');
    final str = '${dateNow.year}-$mouth-$day 00:00:00';
    final returnDate = DateTime.tryParse(str);
    return returnDate;
  }

  ///获取今日23:59
  static DateTime? getEndOfToday(DateTime dateNow) {
    final mouth = '${dateNow.month}'.padLeft(2, '0');
    final day = '${dateNow.day}'.padLeft(2, '0');
    final str = '${dateNow.year}-$mouth-$day 23:59:59';
    final returnDate = DateTime.tryParse(str);
    return returnDate;
  }

  ///获取本年的第一天
  static DateTime? getFirstDayOfYear() {
    final dateNow = DateTime.now();
    final str = '${dateNow.year}-01-01';
    final returnDate = DateTime.tryParse(str);
    return returnDate;
  }

  ///获取本季的第一天
  static DateTime? getFirstDayOfSeason() {
    final dateNow = DateTime.now();
    final mouth = getSeason(dateNow).toString().padLeft(2, '0');
    final str = '${dateNow.year}-$mouth-01';
    final returnDate = DateTime.tryParse(str);
    return returnDate;
  }

  ///获取当前日期输入那个季度的第一个月
  /// 1 2 3 4
  static int getSeason(DateTime dateTime) {
    var season = 1;

    if (dateTime.month == 1 || dateTime.month == 2 || dateTime.month == 3) {
      season = 1;
    } else if (dateTime.month == 4 ||
        dateTime.month == 5 ||
        dateTime.month == 6) {
      season = 4;
    } else if (dateTime.month == 7 ||
        dateTime.month == 8 ||
        dateTime.month == 9) {
      season = 7;
    } else if (dateTime.month == 10 ||
        dateTime.month == 11 ||
        dateTime.month == 12) {
      season = 10;
    }

    return season;
  }
}
