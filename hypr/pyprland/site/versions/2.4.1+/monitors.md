---
commands:
  - name: relayout
    description: Apply the configuration and update the layout
---

# monitors

> First, simpler version of the plugin is still available under the name `monitors_v0`

Allows relative placement of monitors depending on the model ("description" returned by `hyprctl monitors`).
Useful if you have multiple monitors connected to a video signal switch or using a laptop and plugging monitors having different relative positions.

Syntax:

```toml
[monitors.placement]
"description match".placement = "other description match"
```

<details>
    <summary>Example to set a Sony monitor on top of a BenQ monitor</summary>

```toml
[monitors.placement]
Sony.topOf = "BenQ"

## Character case is ignored, "_" can be added
Sony.Top_Of = ["BenQ"]

## Thanks to TOML format, complex configurations can use separate "sections" for clarity, eg:

[monitors.placement."My monitor brand"]
## You can also use "port" names such as *HDMI-A-1*, *DP-1*, etc...
leftOf = "eDP-1"

## lists are possible on the right part of the assignment:
rightOf = ["Sony", "BenQ"]

## > 2.3.2: you can also set scale, transform & rate for a given monitor
[monitors.placement.Microstep]
rate = 100
```

Try to keep the rules as simple as possible, but relatively complex scenarios are supported.

> [!note]
> Check [wlr layout UI](https://github.com/fdev31/wlr-layout-ui) which is a nice complement to configure your monitor settings.

</details>

## Command

<CommandList :commands="$frontmatter.commands" />

## Configuration

### `placement` (REQUIRED)

Supported placements are:

- leftOf
- topOf
- rightOf
- bottomOf
- \<one of the above>(center|middle|end)Of

> [!important]
> If you don't like the screen to align on the start of the given border,
> you can use `center` (or `middle`) to center it or `end` to stick it to the opposite border.
> Eg: "topCenterOf", "leftEndOf", etc...

You can separate the terms with "_" to improve the readability, as in "top_center_of".

#### monitor settings

Not only can you place monitors relatively to each other, but you can also set specific settings for a given monitor.

The following settings are supported:

- scale
- transform
- rate
- resolution

```toml
[monitors.placement."My monitor brand"]
rate = 60
scale = 1.5
transform = 1 # 0: normal, 1: 90°, 2: 180°, 3: 270°, 4: flipped, 5: flipped 90°, 6: flipped 180°, 7: flipped 270°
resolution = "1920x1080"  # can also be expressed as [1920, 1080]
```

### `startup_relayout`

Default to `ŧrue`.

When set to `false`,
do not initialize the monitor layout on startup or when configuration is reloaded.

### `new_monitor_delay`

By default,
the layout computation happens one second after the event is received to let time for things to settle.

You can change this value using this option.

### `hotplug_command`

None by default, allows to run a command when any monitor is plugged.


```toml
[monitors]
hotplug_commands = "wlrlui -m"
```

### `hotplug_commands`

None by default, allows to run a command when a given monitor is plugged.

Example to load a specific profile using [wlr layout ui](https://github.com/fdev31/wlr-layout-ui):

```toml
[monitors.hotplug_commands]
"DELL P2417H CJFH277Q3HCB" = "wlrlui rotated"
```

### `unknown`

None by default,
allows to run a command when no monitor layout has been changed (no rule applied).

```toml
[monitors]
unknown = "wlrlui"
```

### `trim_offset`

`true` by default,

Prevents having arbitrary window offsets or negative values.
