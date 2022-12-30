import 'package:musico/widgets/file_select/file_bean.dart';

///
///Create by 李实 on 2022/6/21 17:08
///
///Description: 从外面传递到文件新增组件，用于刷新该组件
///
class PickFileEvent {
  PickFileEvent(this.type, this.files);

  //类型
  String? type;
  //数据
  List<FileBean>? files;
}
