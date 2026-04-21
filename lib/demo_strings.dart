/// Localisation + tutorial copy for this showcase only.
class DemoStrings {
  static String _lang = 'en';

  static void setLanguage(String lang) => _lang = lang;
  static bool get isGerman => _lang == 'de';

  static String get tutorialClose => isGerman ? 'Verstanden' : 'Got it';
  static String get tutorialReplay =>
      isGerman ? 'Erklärung wiederholen' : 'Replay explanation';
  static String get tutorialAudioFailed =>
      isGerman ? 'Stimme konnte nicht geladen werden' : 'Voice unavailable';
  static String get tutorialRestartLabel =>
      isGerman ? 'Bubbles zurücksetzen' : 'Reset bubbles';
  static String get tabA => isGerman ? 'Screen A' : 'Screen A';
  static String get tabB => isGerman ? 'Screen B' : 'Screen B';
  static String get langToggle => isGerman ? 'EN' : 'DE';
  static String get blurbA => isGerman
      ? 'Kontextuelle Hilfe-Bubble. Tippe sie an für Overlay + Stimme.'
      : 'Contextual help bubble. Tap for overlay + voice.';
  static String get blurbB => isGerman
      ? 'Zweiter Screen — eigene Bubble, eigener Text. So skaliert das Muster.'
      : 'Second screen — its own bubble and copy. Same integration pattern.';

  static const String stepIntro = 'showcase_intro';
  static const String stepDetail = 'showcase_detail';

  static TutorialStep get tutorialIntro => isGerman
      ? const TutorialStep(
          title: 'ElevenLabs in Flutter',
          body:
              'Tippe auf die pulsierende Bubble. Es öffnet sich eine Sprechblase '
              'mit Text — die Stimme kommt von der ElevenLabs Text-to-Speech API '
              '(Modell eleven_multilingual_v2). Gleicher Text wird auf der '
              'Platte gecacht, damit nichts doppelt abgerechnet wird.',
          voice:
              'Tippe auf die pulsierende Bubble. Du hörst dann eine Stimme von '
              'ElevenLabs, und der Text wird auf dem Gerät zwischengespeichert.',
        )
      : const TutorialStep(
          title: 'ElevenLabs in Flutter',
          body:
              'Tap the pulsing bubble. A speech-bubble overlay opens — audio is '
              'synthesized with the ElevenLabs Text-to-Speech API '
              '(eleven_multilingual_v2). Identical prompts are cached on disk so '
              'you are not billed twice for the same line.',
          voice:
              'Tap the pulsing bubble. You will hear ElevenLabs speech synthesis, '
              'and the audio is cached on device for repeat plays.',
        );

  static TutorialStep get tutorialDetail => isGerman
      ? const TutorialStep(
          title: 'Sprache & Stimmen',
          body:
              'Oben kannst du DE/EN umschalten. Mit '
              'ELEVENLABS_VOICE_ID_DE und ELEVENLABS_VOICE_ID_EN kannst du '
              'pro Sprache eine eigene Voice-ID setzen — z. B. zwei Voice-Design-Stimmen.',
          voice:
              'Schalte die Sprache oben um. Pro Sprache kann eine eigene '
              'ElevenLabs Voice-ID gesetzt werden, zum Beispiel zwei '
              'unterschiedliche Voice-Design-Stimmen.',
        )
      : const TutorialStep(
          title: 'Language & voices',
          body:
              'Use the app bar to switch DE/EN. Pass '
              'ELEVENLABS_VOICE_ID_DE and ELEVENLABS_VOICE_ID_EN at build time '
              'to use a different premade or Voice-Design voice per language.',
          voice:
              'Switch the language in the app bar. You can set a different '
              'ElevenLabs voice ID per language using dart-define flags.',
        );

  static TutorialStep tutorialStepById(String id) {
    switch (id) {
      case stepIntro:
        return tutorialIntro;
      case stepDetail:
        return tutorialDetail;
    }
    return tutorialIntro;
  }

  static const List<String> tutorialAllStepIds = [stepIntro, stepDetail];
}

class TutorialStep {
  final String title;
  final String body;
  final String voice;
  const TutorialStep({
    required this.title,
    required this.body,
    required this.voice,
  });
}
