import 'package:musico/base/baseinfo/base_info_edit_model.dart';
import 'package:musico/const/app_data.dart';

///本地缓存的key
enum StoreKey {
  token,
  expireTime,
  user,
  locale,
  privacy,

  cusUseConfig,
  cusUnUseConfig,
  conUseConfig,
  conUnUseConfig,
  supUseConfig,
  supUnUseConfig,

  bill,
  baseInfo,
  billSetting,

  bluetooth,
  btDeviceUUID,
  btServiceUUID,
  btCharacteristicsUUID,
}

///按照操作员获取key
extension StoreType on StoreKey {
  String get displayString {
    switch (this) {
      case StoreKey.token:
        return 'key_token_${AppData.userBean?.userId}';
      case StoreKey.expireTime:
        return 'key_expireTime_${AppData.userBean?.userId}';
      case StoreKey.user:
        return 'key_user_${AppData.userBean?.userId}';
      case StoreKey.locale:
        return 'key_locale_${AppData.userBean?.userId}';
      case StoreKey.cusUseConfig:
        return 'key_cusUseConfig_${AppData.userBean?.userId}';
      case StoreKey.cusUnUseConfig:
        return 'key_cusUnUseConfig_${AppData.userBean?.userId}';
      case StoreKey.conUseConfig:
        return 'key_conUseConfig_${AppData.userBean?.userId}';
      case StoreKey.conUnUseConfig:
        return 'key_conUnUseConfig_${AppData.userBean?.userId}';
      case StoreKey.supUseConfig:
        return 'key_supUseConfig_${AppData.userBean?.userId}';
      case StoreKey.supUnUseConfig:
        return 'key_supUnUseConfig_${AppData.userBean?.userId}';
      case StoreKey.bluetooth:
        return 'key_bluetooth_${AppData.userBean?.userId}';
      case StoreKey.btDeviceUUID:
        return 'key_bt_device_uuid';
      case StoreKey.btServiceUUID:
        return 'key_bt_service_uuid';
      case StoreKey.btCharacteristicsUUID:
        return 'key_bt_characteristics_uuid';
      default:
    }
    return '';
  }

  String getStringWithBillId(num billType) {
    return 'key_bill_${billType}_${AppData.userBean?.userId}';
  }

  String getBillSettingStringWithBillId(num billType) {
    return 'key_billSetting_${billType}_${AppData.userBean?.userId}';
  }

  String getStringWithBaseInfoType(BaseInfoType type) {
    return 'key_base_info_${type.toString()}_${AppData.userBean?.userId}';
  }

  // 当前登陆账号是否使用单据缓存key
  String getUserUseBillCache() {
    return '${StoreKey.user.displayString}_use_bill_cache';
  }
}
