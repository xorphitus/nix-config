# Nix(OS) Configurations
## Manual Settings
### Fcitx
Apply the following with ~fcitx5-configtool~

- Add Mozc
- Change key bind

### GPG
- Import GPG keys
- Trust the main one

### KeePassXC
Enable browser integrations

### SKK
Download dictionaries with the script under `~/.local/bin`

### YubiKey

```
mkdir -p ~/.config/Yubico
pamu2fcfg > ~/.config/Yubico/u2f_keys
```

### Rnote
Touchscreen setting:
https://github.com/flxzt/rnote/issues/1348

## Dual Boot Windows-Side Configuration
- For dual boot:
  - Disable Fast Startup
  - Disable hibernation
- Change IME switch keybind
