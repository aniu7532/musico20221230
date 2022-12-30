class MusicItemBean {
  MusicItemBean({
    this.fileName,
    this.songName,
    this.singerName,
    this.preUrl,
    this.assetPath,
    this.filesSize,
  });

  MusicItemBean.fromEmpty() {
    fileName = '';
    preUrl = '';
    filesSize = 0;

  }

  MusicItemBean.fromJson(Map<String, dynamic> json) {
    fileName = json['fileName'] ?? '';
    songName = json['songName'] ?? '';
    singerName = json['singerName'] ?? '';
    assetPath = json['assetPath'] ?? '';
    preUrl = json['preUrl'] ?? '';
    filesSize = json['filesSize'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['fileName'] = fileName;
    data['songName'] = songName;
    data['singerName'] = singerName;
    data['assetPath'] = assetPath;
    data['filesSize'] = filesSize;
    data['preUrl'] = preUrl;
    return data;
  }

  String? fileName;
  String? songName;
  String? singerName;
  String? preUrl;
  String? assetPath;
  int? filesSize;
}
