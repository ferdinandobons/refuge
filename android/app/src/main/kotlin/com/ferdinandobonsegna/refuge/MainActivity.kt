package com.ferdinandobonsegna.refuge

import android.speech.tts.TextToSpeech
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.Locale

class MainActivity : FlutterActivity() {
    private var tts: TextToSpeech? = null
    private var ttsReady = false

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        tts = TextToSpeech(this) { status -> ttsReady = status == TextToSpeech.SUCCESS }

        // Lettura ad alta voce con le voci di sistema (offline se la lingua è installata).
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "rifugio/speech").setMethodCallHandler { call, result ->
            when (call.method) {
                "speak" -> {
                    val text = call.argument<String>("text")
                    val language = call.argument<String>("language")
                    if (!ttsReady || text == null) return@setMethodCallHandler result.error("tts", "Sintesi vocale non pronta", null)
                    language?.let { tts?.language = Locale.forLanguageTag(it) }
                    tts?.speak(text, TextToSpeech.QUEUE_FLUSH, null, "rifugio")
                    result.success(null)
                }
                "stop" -> {
                    tts?.stop()
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }

    override fun onDestroy() {
        tts?.shutdown()
        super.onDestroy()
    }
}
