class StringUtil {
  //size.substring(0,size.indexOf(".")+2) 小数点位数
  static String getFileSize({required int limit}) {
    var size = '';
    //内存转换
    if (limit < 0.1 * 1024) {
      //小于0.1KB，则转化成B
      size = limit.toString();
      size = '${size.substring(0, size.indexOf('.') + 2)}B';
    } else if (limit < 0.1 * 1024 * 1024) {
      //小于0.1MB，则转化成KB
      size = (limit / 1024).toString();
      size = '${size.substring(0, size.indexOf('.') + 2)}KB';
    } else if (limit < 0.1 * 1024 * 1024 * 1024) {
      //小于0.1GB，则转化成MB
      size = (limit / (1024 * 1024)).toString();
      size = '${size.substring(0, size.indexOf('.') + 2)}MB';
    } else {
      //其他转化成GB
      size = (limit / (1024 * 1024 * 1024)).toString();
      size = '${size.substring(0, size.indexOf('.') + 2)}GB';
    }
    return size;
  }

  static String removeLineBreaks(String str) {
    return str.replaceAll('\n', '');
  }
}
