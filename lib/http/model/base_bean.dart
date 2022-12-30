class BaseBean<T> {
  String? code;
  T? data;
  String? message;
  String? error;

  BaseBean({this.code, this.data, this.message, this.error});

  BaseBean.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    if (json['data'] != null) {
      data = json['data'];
    }
    message = json['message'];
    error = json['error'];
  }
}
