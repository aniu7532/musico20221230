package com.aniu.flutter.muscio.plugins

import android.content.Context
import android.widget.Toast
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class TestPlugin : FlutterPlugin , MethodChannel.MethodCallHandler {

    private lateinit var context : Context
    lateinit var channel : MethodChannel

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {

        channel = MethodChannel(binding.binaryMessenger, "com.aniu.flutter.aniu_base.plugins/test_plugin")
        channel.setMethodCallHandler(this)
        context = binding.applicationContext
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        if(call.method == "test"){
            Toast.makeText(context,"'android test'"+ call.arguments,Toast.LENGTH_LONG).show()
         channel.invokeMethod("test","");

        }
    }

}