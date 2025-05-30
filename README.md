# Nix(OS) Configurations
## Manual Settings
### (Unsure) Hyprland
It may be required to execute `uwsm select` manually for enabling `/nix/store/****/share/wayland-sessions/hyprland-uwsm.desktop`.

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

### Visual Studio Code or alternatives Cursor
Append the following to the top level of the JSON in `~/${config_dir}/argv.json`. `config_dir` should be `.cursor` in the Cursor case.

```
, // Don't forget inserting a comma
"password-store": "gnome-keyring"
```

Although it's possible to set the configuration file with Nix, the configuration file may contain `crash-reporter-id` that should be unique. Therefore, it's not configured automatically so as not to expose the ID to  the internet, just in case.

NOTE: Vault may be applied for this purpose in the future.

https://code.visualstudio.com/docs/configure/settings-sync#_recommended-configure-the-keyring-to-use-with-vs-code

### Waydroid

```
sudo waydroid init
```

After initialization, manually install [waydroid_script](https://github.com/casualsnek/waydroid_script) and install an ARM translator with it. Otherwise, ARM specific apps, e.g., Kindle, are not available.

If `waydroid show-full-ui` shows a black-outed screen, GPU adjustments may be required. Try the following change to `/var/lib/waydroid/waydroid_base.prop` manually.

```diff
-ro.hardware.gralloc=gbm
-ro.hardware.egl=mesa
+ro.hardware.gralloc=default
+ro.hardware.egl=swiftshader
```

Install Aurora Store with the following URL:
https://f-droid.org/ja/packages/com.aurora.store/

## Dual Boot Windows-Side Configuration
- For dual boot:
  - Disable Fast Startup
  - Disable hibernation
- Change IME switch keybind
