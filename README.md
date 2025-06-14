# Nix(OS) Configurations
## Manual Settings
### (Unsure) Hyprland
It may be required to execute `uwsm select` manually for enabling `/nix/store/****/share/wayland-sessions/hyprland-uwsm.desktop`.

### Install Fish Plugins

```sh
setup-fish-env
```

### Emacs

```sh
~/.local/bin/update-skk-jisyos.sh
```

On Emacs:

```
M-x all-the-icons-install-fonts
```

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

### VOICEVOX

```bash
docker pull voicevox/voicevox_engine:nvidia-latest
```

#### Editor
Install Node.js 22. This may take long time.

```bash
mise node@22
```

Then, follow the official instruction: https://github.com/VOICEVOX/voicevox

Notably, `"executionEnabled": false` must be set in `.env`.

### WIP: Printer
Identify the URI:

```bash
lpinfo -v | grep usb
direct usb://Canon/LBP6030/6040/6018L?serial=0000A1K63M59
```

Identify the model name:

```bash
lpinfo -m | grep -i can | grep 6030
CNRCUPSLBP6030ZNK.ppd Canon LBP6030/6040/6018L
```

Enable the printer:

```bash
sudo lpadmin -p LBP6030 -E -v "usb://Canon/LBP6030/6040/6018L?serial=0000A1K63M59" -m CNRCUPSLBP6030ZNK.ppd
```

Unfortunately, the above command may say the following:

```
lpadmin: Printer drivers are deprecated and will stop working in a future version of CUPS.
```

When it stops working, it's better to buy a new one because it's not expected that the driver will be updated.

NOTE: The above doesn't work. The following may be a hint.
https://community.usa.canon.com/t5/Office-Printers/Installing-imageCLASS-LBP6030w-on-Debian-12/td-p/492639

## Dual Boot Windows-Side Configuration
- For dual boot:
  - Disable Fast Startup
  - Disable hibernation
- Change IME switch keybind

## macOS
1. Install Nix from [the official](https://nixos.org)
1. `git clone` with HTTPS under the home directory
  - It's because SSH is still not fully configured and it's unavailable in this step
1. `cd` to the top of the cloned repository
1. `sudo nix --extra-experimental-features "nix-command flakes" run nix-darwin/master#darwin-rebuild -- switch --flake ~/nix-config#macbook-air-m2`
1. Restart the shell
1. `sudo darwin-rebuild switch`
1. Change the repository's remote host protocol to SSH from HTTP and check if it works

### Manual Settings

```sh
mise use -g python@3.12
```
