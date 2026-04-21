import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../demo_strings.dart';

class VoiceSettings {
  final double stability;
  final double similarityBoost;
  final double style;
  final bool useSpeakerBoost;

  const VoiceSettings({
    this.stability = 0.75,
    this.similarityBoost = 0.85,
    this.style = 0.0,
    this.useSpeakerBoost = false,
  });

  Map<String, dynamic> toJson() => {
    'stability': stability,
    'similarity_boost': similarityBoost,
    'style': style,
    'use_speaker_boost': useSpeakerBoost,
  };
}

class ElevenLabsService {
  static const String _bakedVoiceId = 'Xb7hH8MSUJpSbSDYk0k2';
  static const String _voiceIdDe = String.fromEnvironment(
    'ELEVENLABS_VOICE_ID_DE',
    defaultValue: '',
  );
  static const String _voiceIdEn = String.fromEnvironment(
    'ELEVENLABS_VOICE_ID_EN',
    defaultValue: '',
  );
  static const String _voiceIdGeneric = String.fromEnvironment(
    'ELEVENLABS_VOICE_ID',
    defaultValue: '',
  );

  static String get defaultVoiceId {
    final forLang = DemoStrings.isGerman ? _voiceIdDe : _voiceIdEn;
    if (forLang.isNotEmpty) return forLang;
    if (_voiceIdGeneric.isNotEmpty) return _voiceIdGeneric;
    return _bakedVoiceId;
  }

  static const String defaultModelId = 'eleven_multilingual_v2';
  static const String _baseUrl = 'https://api.elevenlabs.io';
  static const String _apiKey = String.fromEnvironment(
    'ELEVENLABS_API_KEY',
    defaultValue: '',
  );

  static bool get isConfigured => _apiKey.isNotEmpty;

  static Future<String?> synthesiseToFile({
    required String text,
    String? voiceId,
    String modelId = defaultModelId,
    VoiceSettings settings = const VoiceSettings(),
  }) async {
    if (!isConfigured) return null;

    final resolvedVoiceId = voiceId ?? defaultVoiceId;

    try {
      final cacheFile = await _cacheFileFor(
        text: text,
        voiceId: resolvedVoiceId,
        modelId: modelId,
        settings: settings,
      );

      if (await cacheFile.exists() && await cacheFile.length() > 0) {
        return cacheFile.path;
      }

      final bytes = await _fetch(
        text: text,
        voiceId: resolvedVoiceId,
        modelId: modelId,
        settings: settings,
      );
      if (bytes == null || bytes.isEmpty) return null;

      await cacheFile.parent.create(recursive: true);
      await cacheFile.writeAsBytes(bytes, flush: true);
      return cacheFile.path;
    } catch (e) {
      // ignore: avoid_print
      print('[ElevenLabsService] synthesise failed: $e');
      return null;
    }
  }

  static Future<void> prefetch(
    List<String> texts, {
    String? voiceId,
    String modelId = defaultModelId,
    VoiceSettings settings = const VoiceSettings(),
  }) async {
    if (!isConfigured) return;
    final resolvedVoiceId = voiceId ?? defaultVoiceId;
    await Future.wait(
      texts.map(
        (t) => synthesiseToFile(
          text: t,
          voiceId: resolvedVoiceId,
          modelId: modelId,
          settings: settings,
        ),
      ),
    );
  }

  static Future<List<int>?> _fetch({
    required String text,
    required String voiceId,
    required String modelId,
    required VoiceSettings settings,
  }) async {
    final uri = Uri.parse('$_baseUrl/v1/text-to-speech/$voiceId');
    final response = await http
        .post(
          uri,
          headers: {
            'xi-api-key': _apiKey,
            'Content-Type': 'application/json',
            'Accept': 'audio/mpeg',
          },
          body: jsonEncode({
            'text': text,
            'model_id': modelId,
            'voice_settings': settings.toJson(),
          }),
        )
        .timeout(const Duration(seconds: 20));

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response.bodyBytes;
    }

    String detail = response.body;
    try {
      final parsed = jsonDecode(response.body);
      if (parsed is Map && parsed['detail'] != null) {
        detail = parsed['detail'].toString();
      }
    } catch (_) {}
    throw Exception('ElevenLabs HTTP ${response.statusCode}: $detail');
  }

  static Future<File> _cacheFileFor({
    required String text,
    required String voiceId,
    required String modelId,
    required VoiceSettings settings,
  }) async {
    final cacheDir = await getTemporaryDirectory();
    final payload = jsonEncode({
      't': text,
      'v': voiceId,
      'm': modelId,
      's': settings.toJson(),
    });
    final hash = sha256.convert(utf8.encode(payload)).toString();
    return File('${cacheDir.path}/tts_cache/$hash.mp3');
  }
}
