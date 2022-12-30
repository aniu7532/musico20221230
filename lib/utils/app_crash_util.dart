///
///Create by 李实 on 2022/10/9 10:36
///
///Description:
///
import 'dart:async';
import 'dart:developer';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:stack_trace/stack_trace.dart';

class AppCrashChain {
  AppCrashChain._();

  static void capture<T>(
    T Function() callback, {
    bool simple = true,
  }) {
    Isolate.current.addErrorListener(
      RawReceivePort((dynamic pair) async {
        final isolateError = pair as List<dynamic>;
        final _error = isolateError.first;
        final _stackTrace = isolateError.last;
        Zone.current.handleUncaughtError(_error, _stackTrace);
      }).sendPort,
    );
    runZonedGuarded(
      () {
        FlutterError.onError = (FlutterErrorDetails details) async {
          Zone.current.handleUncaughtError(details.exception, details.stack!);
        };
        callback();
      },
      (_error, _stack) {
        printError(_error, _stack, simple: simple);
      },
    );
    FlutterError.onError = (FlutterErrorDetails details) async {
      Zone.current.handleUncaughtError(details.exception, details.stack!);
    };
  }

  static printError(_error, _stack, {bool simple = true}) {
    debugLog(_error.toString(),
        isShowTime: true, showLine: true, isDescription: true);
    var errorStr = '';
    if (simple) {
      errorStr = _parseFlutterStack(Trace.from(_stack));
    } else {
      errorStr = Trace.from(_stack).toString();
    }
    if (errorStr.isNotEmpty) {
      debugLog(errorStr,
          isShowTime: false, showLine: true, isDescription: true);
    }
  }

  static String _parseFlutterStack(Trace _trace) {
    var result = '';
    final _traceStr = _trace.toString();
    final _strs = _traceStr.split('\n');
    for (final _str in _strs) {
      if (!_str.contains('package:flutter/') &&
          !_str.contains('dart:') &&
          !_str.contains('package:flutter_stack_trace/')) {
        if (_str.isNotEmpty) {
          if (result.isNotEmpty) {
            result = '$result\n$_str';
          } else {
            result = _str;
          }
        }
      }
    }
    return result;
  }
}

///
/// print message when debug.
///
/// `maxLength` takes effect when `isDescription = true`, You can edit it based on your console width
///
/// `isDescription` means you're about to print a long text
///
/// debugLog(
///   "1234567890",
///   isDescription: true,
///   maxLength: 1,
/// );
///  ------
///  | 1  |
///  | 2  |
///  | 3  |
///  | 4  |
///  | 5  |
///  | 6  |
///  | 7  |
///  | 8  |
///  | 9  |
///  | 0  |
///  ------
///
void debugLog(
  Object obj, {
  bool isShowTime = false,
  bool showLine = true,
  int maxLength = 500,
  bool isDescription = true,
}) {
  if (kDebugMode) {
    var slice = obj.toString();
    if (isDescription) {
      if (obj.toString().length > maxLength) {
        final objSlice = <String>[];
        for (var i = 0;
            i <
                (obj.toString().length % maxLength == 0
                    ? obj.toString().length / maxLength
                    : obj.toString().length / maxLength + 1);
            i++) {
          if (maxLength * i > obj.toString().length) {
            break;
          }
          objSlice.add(obj.toString().substring(
              maxLength * i,
              maxLength * (i + 1) > obj.toString().length
                  ? obj.toString().length
                  : maxLength * (i + 1)));
        }
        slice = '\n';
        for (final element in objSlice) {
          slice += '$element\n';
        }
      }
    }
    _print(slice, showLine: showLine, isShowTime: isShowTime);
  }
}

_print(String content, {bool isShowTime = true, bool showLine = false}) {
  final logStr = isShowTime ? '${DateTime.now()}:  $content' : content;
  if (showLine) {
    final logSlice = logStr.split('\n');
    final maxLength = _getMaxLength(logSlice) + 3;
    var line = '-';
    for (var i = 0; i < maxLength + 1; i++) {
      line = '$line-';
    }
    debugPrint(line);
    for (final _log in logSlice) {
      if (_log.isEmpty) {
        return;
      }
      final gapLength = maxLength - _log.length;
      if (gapLength > 0) {
        var space = ' ';
        for (var i = 0; i < gapLength - 3; i++) {
          space = '$space ';
        }
        debugPrint('| $_log$space |');
      }
    }
    debugPrint(line);
  } else {
    debugPrint(logStr);
  }
}

int _getMaxLength(List<String> logSlice) {
  final lengthList = <int>[];
  for (final _log in logSlice) {
    lengthList.add(_log.length);
  }
  lengthList.sort((left, right) => right - left);
  return lengthList[0];
}
