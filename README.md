# V-IRAL — ElevenLabs slice (Flutter)

I’m working on **V-IRAL**, a bilingual Flutter app designed to flip the script on screen time. Instead of just scrolling, kids complete short learning missions and quizzes to earn time in their favorite apps. The full project mixes Flutter and native Android for system-level gating; I’m keeping that core logic private for now.

**This repo** is a small, runnable slice of that app focused on **ElevenLabs** text-to-speech: API in use, cached audio, simple **English / German** UI. It’s mainly so I’ve engaged with TTS and voice UX in a real product context, not to showcase engineering depth.

*Implementation relied on AI coding tools.*

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
