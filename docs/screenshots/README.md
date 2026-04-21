# Screenshots for the GitHub README

Save the finished images **with these exact filenames** in this folder (`docs/screenshots/`) so the previews in the root `README.md` resolve correctly.

## Recommended captures (order)

| File | What to show |
|------|----------------|
| `01-main-bubble.png` | **Screen A**, pulsing bubble visible bottom-right, app bar “ElevenLabs · Flutter”, tabs “Screen A / B”. |
| `02-overlay-tts.png` | **Overlay open**: mascot on the left, speech bubble with copy, replay + dismiss buttons. Prefer **German** UI here so multilingual + ElevenLabs reads credibly. |
| `03-language-toggle.png` | Same idea as 1 but **German** in the UI (toggle shows “EN”) — highlights localization + per-language voice IDs. |
| `04-tab-b.png` (optional) | **Screen B**, second bubble — shows the pattern scales per screen. |

## Tips

- **Device:** Real phone or emulator, readable brightness, no sensitive personal info in the status bar (or a clean emulator status bar).
- **API key:** For screenshot 2, run briefly with a valid key so you do not capture “Voice unavailable” (or crop to UI-only on purpose).
- **Resolution:** High enough for sharp scaling (e.g. full phone or 1080×2400 crop); the README displays them at ~280px wide.
- **Optional GIF:** `demo-bubble-tap.gif` — short: tap → overlay → audio. Tools: Windows Clipchamp, [ScreenToGif](https://www.screentogif.com/), or on-device screen record → convert.

## After saving

```bash
git add docs/screenshots/*.png
git commit -m "Add README screenshots"
git push
```

If the PNGs are not in the repo yet, the `<img>` links in the main README will 404 on GitHub until you commit them — that is expected.
