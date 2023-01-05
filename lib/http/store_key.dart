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
