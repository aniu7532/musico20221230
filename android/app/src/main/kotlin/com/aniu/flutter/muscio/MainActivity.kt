package com.aniu.flutter.muscio

import com.aniu.flutter.muscio.plugins.TestPlugin
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity: FlutterActivity() {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        flutterEngine.plugins.add(TestPlugin())
    }

    override fun onRestart() {
        super.onRestart()
        //解决从后台切换到前台flutter黑屏的问题
        flutterEngine!!.lifecycleChannel.appIsResumed()
    }
}
