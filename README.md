# V-IRAL — ElevenLabs slice (Flutter)

Extract from **V-IRAL**, my Flutter app. This repo only contains the **ElevenLabs TTS** piece: HTTP client, `eleven_multilingual_v2`, MP3 to disk with a **SHA256 cache key** (same line + voice + model + settings → same file, no double billing), and playback with **just_audio**. On top of that there’s a **small UI**: pulsing help bubble → full-screen overlay with a custom speech-bubble shape and DE/EN strings.

The full app is **not** here — it’s Flutter + Kotlin where needed, bilingual UI, and other features I’m keeping private. This folder is what I’m comfortable open-sourcing for a technical look at the voice integration. The wider architecture and product side I’m happy to talk through in a normal conversation — that stuff doesn’t all need to sit in a public repository.

## Screenshots

Filenames and what to capture: [`docs/screenshots/README.md`](docs/screenshots/README.md).

**Upload (same workflow as any other file change):** save the PNGs into `docs/screenshots/` on your machine (`01-main-bubble.png`, `02-overlay-tts.png`, …), then from the repo root:

```bash
git add docs/screenshots/*.png
git commit -m "Add README screenshots"
git push
```

You can also drop the files there in Explorer or your editor, then run those three commands. After `push`, refresh the GitHub repo page — the `<img>` tags below will resolve.

Until the PNGs are committed, the images below stay broken — that’s expected.

<p align="center">
  <img src="docs/screenshots/01-main-bubble.png" width="280" alt="Main screen with pulsing tutorial bubble" />
  &nbsp;&nbsp;
  <img src="docs/screenshots/02-overlay-tts.png" width="280" alt="Speech-bubble overlay with TTS UI" />
</p>

<p align="center">
  <img src="docs/screenshots/03-language-toggle.png" width="280" alt="German UI and language toggle" />
  &nbsp;&nbsp;
  <img src="docs/screenshots/04-tab-b.png" width="280" alt="Second tab with its own bubble" />
</p>

Optional GIF: `docs/screenshots/demo-bubble-tap.gif` — can be linked here the same way as the PNGs.

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

Portfolio / sample — add a `LICENSE` if you need something explicit.
