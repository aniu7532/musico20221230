class OptionList {
  OptionList({this.value, this.label, this.isMulti, this.data});

  OptionList.fromJson(Map<String, dynamic> json) {
    value = json['value'].toString(); //防止  initValue 和 返回的值类型不对应导致 选不上
    label = json['label'];
  }

  OptionList.fromWaitOutJson(Map<String, dynamic> json) {
    value = json['id'].toString();
    label = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    data['label'] = this.label;
    return data;
  }

  //就是id
  dynamic value;
  //显示的名称
  String? label;
  bool? isMulti;

  ///用于存储对象数据
  Map<String, dynamic>? data;
  @override
  String toString() {
    return '$label,';
  }

  @override
  bool operator ==(Object other) => other is OptionList && value == other.value;

  @override
  int get hashCode => value.hashCode;
}
