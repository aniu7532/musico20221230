import 'package:dio/dio.dart';
import 'package:flustars/flustars.dart';
import 'package:musico/base/view_state_model.dart';
import 'package:musico/http/app_exception.dart';
import 'package:musico/utils/toast_util.dart';
import 'package:musico/widgets/file_select/file_bean.dart';
import 'package:musico/widgets/file_select/file_state.dart';

class PickImageVideoModel extends ViewStateModel {
  PickImageVideoModel(
    this.isImageSingle,
    this.isVideoSingle,
    this.isImageOnly,
    this.maxLength,
  ) {
    if (!isImageSingle && !isVideoSingle && !isImageOnly) {
      //添加空的视频数据
      fileList.add(FileBean.fromEmpty());
      //添加空的图片数据
      fileList.add(FileBean.fromEmpty(isImage: true));
    }
    if (!isImageSingle && !isVideoSingle && isImageOnly) {
      //添加空的图片数据
      fileList.add(FileBean.fromEmpty(isImage: true));
    }
  }

  ///只单选图片
  final bool isImageSingle;

  ///只单选视频
  final bool isVideoSingle;

  ///只选择图片
  final bool isImageOnly;

  final int maxLength;

  List<FileBean> fileList = [];

  FileState _state = FileState.none;

  FileState get state => _state;

  set state(FileState value) {
    _state = value;
    notifyListeners();
  }

  FileState _videoState = FileState.none;

  FileState get videoState => _videoState;

  set videoState(FileState value) {
    _videoState = value;
    notifyListeners();
  }

  void updateFileList(List<FileBean>? fList) {
    fileList.clear();
    fileList = fList!;
    notifyListeners();
  }

  void onDeleteMultiImage(FileBean bean) {
    fileList.removeWhere(
      (e) => (bean.businessId ?? '') == (e.businessId ?? ''),
    );
    //当前已经上传了的图片数量
    final curLength = fileList
        .where(
          (value) =>
              (value.isImage ?? false) &&
              ObjectUtil.isNotEmpty(value.businessId ?? ''),
        )
        .length;
    //剩余可上传图片的数量
    final restLength = maxLength - curLength;
    if (restLength > 0) {
      fileList
        ..removeWhere(
          (e) => (e.isImage ?? false) && ObjectUtil.isEmpty(e.businessId ?? ''),
        )
        ..add(FileBean.fromEmpty(isImage: true));
    }
  }

  /// 批量上传临时文件，过一段时间会自动清理
  ///
  /// [files] 文件在内部存储的绝对路径
  Future<bool> uploadFile(List<String> files) async {
    const url = '/oss-service/api/v1/fileservice/files/advanced/batch/upload';
    final request = {
      'isExpire': '1', //是否过期（0 需要过期-每次需重新获取预览地址(默认)，1-不过期具有公共读属性）
      'corpId': '', //企业id
    };
    final result = (await apiModel.postFiles(url, files, params: request)).when(
      success: (success) => success,
      error: (error) => error,
    );
    if (result is AppException || ObjectUtil.isEmpty(result.data)) {
      MyToast.showError('保存失败：${result.message}');
      return false;
    }
    final List rList = result.data;
    fileList = rList.map((e) => FileBean.fromJson(e)).toList();
    return true;
  }

  /// 批量上传临时文件
  ///
  /// [files] 文件在内部存储的绝对路径
  Future<List<FileBean>?> uploadFileOnly(
    List<String> files, {
    bool isImage = false,
  }) async {
    const url = '/oss-service/api/v1/fileservice/files/advanced/batch/upload';
    final request = {
      'isExpire': '1', //是否过期（0 需要过期-每次需重新获取预览地址(默认)，1-不过期具有公共读属性）
      'corpId': '', //企业id
    };
    final result = (await apiModel.postFiles(url, files, params: request)).when(
      success: (success) => success,
      error: (error) => error,
    );
    if (result is AppException || ObjectUtil.isEmpty(result.data)) {
      MyToast.showError('保存失败：${result.message}');
      return null;
    }
    final List rList = result.data;
    return rList.map((e) => FileBean.fromJson(e, isImage: isImage)).toList();
  }

  ///
  ///
  /// 参数名称
  /// 参数说明
  /// 请求类型
  /// 是否必须
  /// 数据类型
  /// schema
  /// businessId	业务系统 ID	query	true
  /// integer(int64)
  ///
  /// file	文件	body	true
  /// string
  ///
  /// corpId	企业ID	query	false
  /// integer(int64)
  ///
  /// isExpire	是否过期（0 需要过期-每次需重新获取预览地址(默认)，1-不过期具有公共读属性）	query	false
  /// integer(int32)
  ///
  Future<List<FileBean>> advanceduploadbusiness(List<String> files,
      {bool isBill = false}) async {
    const url = '/oss-service/api/v1/fileservice/files/advancedupload';
    final request = {
      'isExpire': '1', //是否过期（0 需要过期-每次需重新获取预览地址(默认)，1-不过期具有公共读属性）
      'corpId': '', //企业id
      'file': await MultipartFile.fromFile(files[0]), //企业id
    };
    final result = (await apiModel.postFile(url, params: request)).when(
      success: (success) => success,
      error: (error) => error,
    );

    if (result is AppException || ObjectUtil.isEmpty(result.data)) {
      MyToast.showError('保存失败：${result.message}');
      return [];
    }
    final fileBack = result.data;
    fileList = [FileBean.fromJson(fileBack)];
    return fileList;
  }
}
