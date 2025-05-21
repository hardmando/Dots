# Getting started

Pypr consists in two things:

- **a tool**: `pypr` which runs the daemon (service), but also allows to interact with it
- **some config file**: `~/.config/hypr/pyprland.toml` (or the path set using `--config`) using the [TOML](https://toml.io/en/) format

The `pypr` tool only have a few built-in commands:

- `help` lists available commands (including plugins commands)
- `exit` will terminate the service process
- `edit` edit the configuration using your `$EDITOR` (or `vi`), reloads on exit
- `dumpjson` shows a JSON representation of the configuration (after other files have been `include`d)
- `reload` reads the configuration file and apply some changes:
  - new plugins will be loaded
  - configuration items will be updated (most plugins will use the new values on the next usage)

Other commands are implemented by adding [plugins](./Plugins).

> [!important]
> - with no argument it runs the daemon (doesn't fork in the background)
>
> - if you pass parameters, it will interact with the daemon instead.

> [!tip]
> Pypr *command* names are documented using underscores (`_`) but you can use dashes (`-`) instead.
> Eg: `pypr shift_monitors` and `pypr shift-monitors` will run the same command


## Configuration file

The configuration file uses a [TOML format](https://toml.io/) with the following as the bare minimum:

```toml
[pyprland]
plugins = ["plugin_name", "other_plugin"]
```

Additionally some plugins require **Configuration** options, using the following format:

```toml
[plugin_name]
plugin_option = 42

[plugin_name.another_plugin_option]
suboption = "config value"
```

You can also split your configuration into [Multiple configuration files](./MultipleConfigurationFiles).

## Installation

Check your OS package manager first, eg:

- Archlinux: you can find it on AUR, eg with [yay](https://github.com/Jguer/yay): `yay pyprland`
- NixOS: Instructions in the [Nix](./Nix) page

Otherwise, use the python package manager (pip) [inside a virtual environment](InstallVirtualEnvironment)

```sh
pip install pyprland
```

## Running

> [!caution]
> If you messed with something else than your OS packaging system to get `pypr` installed, use the full path to the `pypr` command.

Preferably start the process with hyprland, adding to `hyprland.conf`:

```ini
exec-once = /usr/bin/pypr
```

or if you run into troubles (use the first version once your configuration is stable):

```ini
exec-once = /usr/bin/pypr --debug /tmp/pypr.log
```

> [!warning]
> To avoid issues (eg: you have a complex setup, maybe using a virtual environment), you may want to set the full path (eg: `/home/bob/venv/bin/pypr`).
> You can get it from `which pypr` in a working terminal

Once the `pypr` daemon is started (cf `exec-once`), you can list the eventual commands which have been added by the plugins using `pypr -h` or `pypr help`, those commands are generally meant to be use via key bindings, see the `hyprland.conf` part of *Configuring* section below.

## Configuring

Create a configuration file in `~/.config/hypr/pyprland.toml` enabling a list of plugins, each plugin may have its own configuration needs or don't need any configuration at all.
Most default values should be acceptable for most users, options which hare not mandatory are marked as such.

> [!important]
> Provide the values for the configuration options which have no annotation such as "(optional)"

Check the [TOML format](https://toml.io/) for details about the syntax.

Simple example:

```toml
[pyprland]
plugins = [
    "shift_monitors",
    "workspaces_follow_focus"
]
```

<details>
  <summary>
More complex example
  </summary>

```toml
[pyprland]
plugins = [
  "scratchpads",
  "lost_windows",
  "monitors",
  "toggle_dpms",
  "magnify",
  "expose",
  "shift_monitors",
  "workspaces_follow_focus",
]

[monitors.placement]
"Acer".top_center_of = "Sony"

[workspaces_follow_focus]
max_workspaces = 9

[expose]
include_special = false

[scratchpads.stb]
animation = "fromBottom"
command = "kitty --class kitty-stb sstb"
class = "kitty-stb"
lazy = true
size = "75% 45%"

[scratchpads.stb-logs]
animation = "fromTop"
command = "kitty --class kitty-stb-logs stbLog"
class = "kitty-stb-logs"
lazy = true
size = "75% 40%"

[scratchpads.term]
animation = "fromTop"
command = "kitty --class kitty-dropterm"
class = "kitty-dropterm"
size = "75% 60%"

[scratchpads.volume]
animation = "fromRight"
command = "pavucontrol"
class = "org.pulseaudio.pavucontrol"
lazy = true
size = "40% 90%"
unfocus = "hide"
```

Some of those plugins may require changes in your `hyprland.conf` to fully operate or to provide a convenient access to a command, eg:

```bash
bind = $mainMod SHIFT, Z, exec, pypr zoom
bind = $mainMod ALT, P,exec, pypr toggle_dpms
bind = $mainMod SHIFT, O, exec, pypr shift_monitors +1
bind = $mainMod, B, exec, pypr expose
bind = $mainMod, K, exec, pypr change_workspace +1
bind = $mainMod, J, exec, pypr change_workspace -1
bind = $mainMod,L,exec, pypr toggle_dpms
bind = $mainMod SHIFT,M,exec,pypr toggle stb stb-logs
bind = $mainMod,A,exec,pypr toggle term
bind = $mainMod,V,exec,pypr toggle volume
```

</details>

> [!tip]
> Consult or share [configuration files](https://github.com/hyprland-community/pyprland/tree/main/examples)
>
> You might also be interested in [optimizations](./Optimizations).
