class UserBean {
  String? accessToken;
  String? avatar;
  int? corpId;
  String? corpName;
  int? expiresTime;
  bool? hasOtherCorp;
  int? leadStatus;
  int? parentCorpId;
  String? userId;
  String? userName;

  UserBean(
      {this.accessToken,
      this.avatar,
      this.corpId,
      this.corpName,
      this.expiresTime,
      this.hasOtherCorp,
      this.leadStatus,
      this.parentCorpId,
      this.userId,
      this.userName});

  UserBean.fromJson(Map<String, dynamic> json) {
    accessToken = json['accessToken'];
    avatar = json['avatar'];
    corpId = json['corpId'];
    corpName = json['corpName'];
    expiresTime = json['expiresTime'];
    hasOtherCorp = json['hasOtherCorp'];
    leadStatus = json['leadStatus'];
    parentCorpId = json['parentCorpId'];
    userId = json['userId'];
    userName = json['userName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['accessToken'] = this.accessToken;
    data['avatar'] = this.avatar;
    data['corpId'] = this.corpId;
    data['corpName'] = this.corpName;
    data['expiresTime'] = this.expiresTime;
    data['hasOtherCorp'] = this.hasOtherCorp;
    data['leadStatus'] = this.leadStatus;
    data['parentCorpId'] = this.parentCorpId;
    data['userId'] = this.userId;
    data['userName'] = this.userName;
    return data;
  }
}
