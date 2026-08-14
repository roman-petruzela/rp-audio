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
mkdir -p ~/.local/bin ~/.config/rp-audio ~/.config/wireplumber/wireplumber.conf.d ~/.config/systemd/user

cp bin/rp-audio ~/.local/bin/rp-audio
chmod +x ~/.local/bin/rp-audio

cp config/blacklist.conf ~/.config/rp-audio/blacklist.conf
cp wireplumber.conf.d/51-rp-audio.conf ~/.config/wireplumber/wireplumber.conf.d/51-rp-audio.conf

cp systemd/rp-audio.service ~/.config/systemd/user/rp-audio.service
systemctl --user daemon-reload
systemctl --user enable --now rp-audio.service
```

The WirePlumber snippet sets `node.stream.restore-target = false` and
`linking.follow-default-target = true`, so new streams always start on the
default output and already-running ones follow it when it changes.

## Config

`config/blacklist.conf` — one pattern per line, matched as a case-insensitive
substring against a stream's `application.process.binary`,
`application.name` and `node.name`. Matching streams are never touched by
output switching (capture streams, e.g. screen-share/OBS capture, are never
touched regardless of the blacklist).
