# Screenshots for the GitHub README

Save **exactly three** PNGs in this folder (`docs/screenshots/`) with these names so the root `README.md` picks them up.

## The three shots (story order)

| File | What to show |
|------|----------------|
| `01-main-bubble.png` | **Main / home screen** — pulsing help bubble (bottom-right or wherever it sits in V-IRAL). |
| `02-mission-bubble.png` | **Mission / challenge screen** — same bubble treatment, still **closed** (not tapped yet). |
| `03-mission-overlay.png` | **Still on a mission-style screen** — bubble **open**: mascot + speech-bubble panel, replay / dismiss. Run with a valid API key if you want audio state to look clean (no error line). |

In the **trimmed demo app** in this repo, “main” ≈ first tab, “mission” ≈ second tab — or capture from the **full V-IRAL build** if you prefer real product chrome.

## Tips

- **Device:** Phone or emulator, readable brightness, no private stuff in the status bar.
- **API key:** For `03-mission-overlay.png`, a quick run with `--dart-define=ELEVENLABS_API_KEY=...` avoids a “voice unavailable” banner in the shot (optional).
- **Resolution:** Full phone or tall crop; README scales to ~260px wide each.

## After saving

```bash
git add docs/screenshots/*.png
git commit -m "Add README screenshots"
git push
```

Until these three files exist in git, the images in the main README 404 on GitHub — expected.
