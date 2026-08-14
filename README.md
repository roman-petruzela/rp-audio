# rp-audio

Unified audio output control for PipeWire/WirePlumber. Switches, mutes and sets
volume on all sinks at once, so switching between outputs (e.g. speakers /
headphones) never sounds like a volume jump, and already-running streams
follow the default output automatically.

## Commands

```
rp-audio switch <sink>   switch the default output (name or index)
rp-audio cycle           switch to the next output in order
rp-audio volume up|down|set <0-100>
rp-audio mute [on|off|toggle]
rp-audio unpin           release all streams back to the default output
rp-audio sync            match the volume of all outputs to the default one
rp-audio list            list outputs (JSON)
rp-audio daemon          watch volume and new streams (systemd unit)
```

Streams listed in `config/blacklist.conf` are left wherever the app itself
routed them (e.g. OBS monitoring, EasyEffects).

## Requirements

- `pactl`, `pw-dump`, `pw-metadata` (PipeWire / WirePlumber)
- `jq`
- optional: [quickshell](https://quickshell.outfoxxed.me/) (`qs`) for an OSD trigger on volume/mute changes

## Install

```bash
./install.sh              # installs files and enables the systemd service
./install.sh --no-enable  # installs files only, service left disabled
```

Re-running `install.sh` is safe — it never overwrites an existing
`~/.config/rp-audio/blacklist.conf` or `rp-audio.conf`. To remove everything:

```bash
./uninstall.sh          # keeps ~/.config/rp-audio
./uninstall.sh --purge  # also removes ~/.config/rp-audio
```

The WirePlumber snippet sets `node.stream.restore-target = false` and
`linking.follow-default-target = true`, so new streams always start on the
default output and already-running ones follow it when it changes. It's
installed as `51-rp-audio.conf` — WirePlumber's own bundled config uses
prefixes `≤ 50`, so `51+` is the conventional range for user overrides that
should apply after them.

## Config

Both files live in `~/.config/rp-audio/` and are only copied there once by
`install.sh` — edit them in place afterwards, they won't be touched again.

`blacklist.conf` — one pattern per line, matched as a case-insensitive
substring against a stream's `application.process.binary`,
`application.name` and `node.name`. Matching streams are never touched by
output switching (capture streams, e.g. screen-share/OBS capture, are never
touched regardless of the blacklist).

`rp-audio.conf` — shell-sourced settings: `VOLUME_STEP_PCT` (step size for
`volume up|down`), `OSD_CMD` (command triggered after a volume/mute change,
e.g. for [quickshell](https://quickshell.outfoxxed.me/); empty disables it),
and `SETTLE_SECS` (daemon quarantine window for freshly added outputs). See
the comments in `config/rp-audio.conf` for defaults.
