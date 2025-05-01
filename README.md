# Nix(OS) Configurations
## Manual Settings
### Fcitx
Apply the following with ~fcitx5-configtool~

- Add Mozc
- Change key bind

### GPG
Import GPG keys.

### KeePassXC
Enable browser integrations

### SKK
Download dictionaries with the script under `~/.local/bin`

### YubiKey

```
mkdir -p ~/.config/Yubico
pamu2fcfg > ~/.config/Yubico/u2f_keys
```
