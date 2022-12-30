import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:musico/app/myapp.dart';
import 'package:musico/firebase_options.dart';
import 'package:musico/http/http_override.dart';
import 'package:musico/utils/app_crash_util.dart';
import 'package:musico/utils/helper/audio_player_helper.dart';

Future<void> start() async {
  WidgetsFlutterBinding.ensureInitialized();

  await audioPlayerHelper.init();

  AppCrashChain.capture(
    () {
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.light, // 状态栏字体颜色（白色）
          statusBarColor: Colors.transparent, // 状态栏背景色
        ),
      );

      HttpOverrides.global = MyHttpOverrides();
      Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      runApp(
        const MyApp(),
      );
    },
  );

  // await runZonedGuarded(() async {
  //   SystemChrome.setSystemUIOverlayStyle(
  //     const SystemUiOverlayStyle(
  //       statusBarIconBrightness: Brightness.light, // 状态栏字体颜色（白色）
  //       statusBarColor: ColorName.themeColor, // 状态栏背景色
  //     ),
  //   );
  //
  //   HttpOverrides.global = MyHttpOverrides();
  //
  //   runApp(
  //     const MyApp(),
  //   );
  // }, (Object obj, StackTrace stack) {
  //   if (kDebugMode) {
  //     log(obj.toString(), stackTrace: stack);
  //   } else {
  //     //其它异常捕获与日志收集
  //   }
  // });
}
