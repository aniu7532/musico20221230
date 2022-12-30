class FileBean {
  String? mediaId;
  String? businessId;
  String? fileName;
  String? preUrl;
  int? filesSize;
  String? suffix;
  int? fileCategory;

  bool? isImage;

  bool? isNew;

  FileBean? coverImage;

  FileBean({
    this.mediaId,
    this.businessId,
    this.fileName,
    this.preUrl,
    this.filesSize,
    this.suffix,
    this.fileCategory,
    this.isImage,
    this.coverImage,
  });

  FileBean.fromEmpty({this.isImage = false}) {
    mediaId = '';
    businessId = '';
    fileName = '';
    preUrl = '';
    filesSize = 0;
    suffix = '';
    fileCategory = 0;
  }

  FileBean.fromJson(Map<String, dynamic> json, {this.isImage = true}) {
    mediaId = json['mediaId'] ?? '';
    businessId = json['businessId'] ?? '';
    fileName = json['fileName'] ?? '';
    preUrl = json['preUrl'] ?? '';
    filesSize = json['filesSize'] ?? 0;
    suffix = json['suffix'] ?? '';
    fileCategory = json['fileCategory'] ?? 0;
    isNew = true;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['mediaId'] = this.mediaId;
    data['businessId'] = this.businessId;
    data['fileName'] = this.fileName;
    data['preUrl'] = this.preUrl;
    data['filesSize'] = this.filesSize;
    data['suffix'] = this.suffix;
    data['fileCategory'] = this.fileCategory;
    return data;
  }

  @override
  String toString() {
    return 'FileBean{businessId: $businessId, fileName: $fileName}';
  }
}
