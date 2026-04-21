# V-IRAL — ElevenLabs slice (Flutter)

Extract from **V-IRAL**, my Flutter app. This repo only contains the **ElevenLabs TTS** piece: HTTP client, `eleven_multilingual_v2`, MP3 to disk with a **SHA256 cache key** (same line + voice + model + settings → same file, no double billing), and playback with **just_audio**. On top of that there’s a **small UI**: pulsing help bubble → full-screen overlay with a custom speech-bubble shape and DE/EN strings.

The full app is **not** here — Flutter + Kotlin where needed, bilingual UI, and other parts I’m keeping private. This repo is only the voice slice I’m fine publishing as code.

## Screenshots

Left to right: main screen, mission with bubble, mission with overlay open.

<p align="center">
  <img src="docs/screenshots/01-main-bubble.png" width="260" alt="Main screen: help bubble" />
  &nbsp;
  <img src="docs/screenshots/02-mission-bubble.png" width="260" alt="Mission screen: bubble visible" />
  &nbsp;
  <img src="docs/screenshots/03-mission-overlay.png" width="260" alt="Mission screen: overlay / speech bubble open" />
</p>

## Where the code lives

| What | Path |
|------|------|
| TTS + cache + errors | `lib/services/eleven_labs_service.dart` |
| Bubble, overlay, `CustomPainter` speech bubble | `lib/widgets/tutorial_bubble.dart` |
| Seen flags (SharedPreferences) | `lib/services/tutorial_controller.dart` |
| DE/EN copy + text sent to TTS | `lib/demo_strings.dart` |

## Run

Needs an [ElevenLabs API key](https://elevenlabs.io/) — pass via `--dart-define`, don’t commit it.

```bash
flutter pub get
flutter run --dart-define=ELEVENLABS_API_KEY=YOUR_KEY_HERE
```

Per-language voice IDs (e.g. Voice Design DE / EN):

```bash
flutter run \
  --dart-define=ELEVENLABS_API_KEY=YOUR_KEY \
  --dart-define=ELEVENLABS_VOICE_ID_DE=... \
  --dart-define=ELEVENLABS_VOICE_ID_EN=...
```

In the demo: **DE/EN** in the app bar switches strings (and which env voice id wins); **refresh** clears bubble state.

## Notes

- Default voice if you set nothing is a **premade** ID that tends to work on the free API tier; many **Voice Library** voices return **402** without a paid plan.
- Model: `eleven_multilingual_v2`.
- Mascot: `assets/brand/mascot-head.png`.

## License

No formal license file — treat as a personal code sample unless you add one.
