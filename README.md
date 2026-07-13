# Pryv4x

Minimal, high-tech / dark cyberpunk UI library for Roblox.
Near-black panels, thin cyan borders, monospace text, no bouncy/heavy effects — built to be sharp and functional.

![style](https://img.shields.io/badge/style-cyberpunk-00e0d0?style=flat-square)
![lang](https://img.shields.io/badge/lang-Luau-00e0d0?style=flat-square)

## Features

- Window with draggable top bar + custom icon (top-left)
- Sidebar tab system
- Components: Button, Toggle, Slider, Dropdown, Label
- Notification popups
- Single-file, dependency-free ModuleScript
- No external assets besides your own icon image

## Installation (in your game)

**Option A — Rojo / directly in Studio**

1. Copy `Pryv4x.lua` into a `ModuleScript` named `Pryv4x` (e.g. under `ReplicatedStorage`).
2. Require it from a `LocalScript`:
   ```lua
   local Pryv4x = require(game.ReplicatedStorage.Pryv4x)
   ```

**Option B — Load from GitHub (loadstring)**

```lua
local Pryv4x = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/<USERNAME>/<REPO>/main/Pryv4x.lua"
))()
```

> `game:HttpGet` requires `HttpService.HttpEnabled = true` in game settings (or works automatically for executors/loader scripts outside of published games).

## Quick Start

```lua
local Window = Pryv4x:CreateWindow({
    Title = "PRYV4X",
    Icon  = "rbxassetid://111219641085455",
    Size  = UDim2.fromOffset(560, 360),
})

local Tab = Window:CreateTab("Main")

Tab:CreateButton({ Text = "Click me", Callback = function()
    print("clicked")
end })

Tab:CreateToggle({ Text = "Enabled", Default = false, Callback = function(state)
    print(state)
end })

Tab:CreateSlider({ Text = "Speed", Min = 0, Max = 100, Default = 16, Callback = function(value)
    print(value)
end })

Tab:CreateDropdown({ Text = "Mode", Options = {"A", "B", "C"}, Callback = function(value)
    print(value)
end })

Tab:CreateLabel("Some info text")

Window:Notify({ Title = "Pryv4x", Content = "Loaded successfully.", Duration = 3 })
```

See `Example.client.lua` for a full working example.

## Theme

All colors live in the `Theme` table at the top of `Pryv4x.lua` — edit these to retheme:

| Key       | Default (RGB)      | Use                    |
|-----------|--------------------|------------------------|
| Background| 8, 8, 12           | Window background      |
| Panel     | 13, 13, 18         | Top bar / sidebar      |
| PanelAlt  | 17, 17, 23         | Buttons / inputs       |
| Border    | 0, 210, 200        | Accent border (cyan)   |
| Accent    | 0, 240, 230        | Title / highlight text |
| Text      | 215, 235, 235      | Primary text           |
| SubText   | 110, 130, 130      | Secondary text         |
| Danger    | 255, 70, 90        | Close button hover     |

## How to publish this to GitHub

1. **Create a repo**
   - Go to github.com → New repository → name it `Pryv4x` (or whatever you like) → Public or Private → Create.

2. **Push the files** (from your local machine, with git installed):
   ```bash
   cd path/to/Pryv4x
   git init
   git add .
   git commit -m "Initial commit: Pryv4x UI library"
   git branch -M main
   git remote add origin https://github.com/<USERNAME>/<REPO>.git
   git push -u origin main
   ```

3. **Get the raw link** for `Pryv4x.lua`:
   - Open the file on GitHub → click **Raw** → copy the URL.
   - It looks like: `https://raw.githubusercontent.com/<USERNAME>/<REPO>/main/Pryv4x.lua`

4. **Load it in Roblox** using `loadstring(game:HttpGet(...))()` as shown above.

5. *(Optional)* Tag a release (`git tag v1.0.0 && git push --tags`) so you can pin a stable version URL instead of always pointing at `main`, e.g.:
   ```
   https://raw.githubusercontent.com/<USERNAME>/<REPO>/v1.0.0/Pryv4x.lua
   ```

## Notes

- The icon uses `Image = "rbxassetid://111219641085455"` by default — pass your own via the `Icon` field in `CreateWindow`.
- Font is `Enum.Font.Code` (Roblox's built-in monospace font) to match the terminal/hacker aesthetic.
- No gradients, glows, or particle effects by design — keeps it sharp and lightweight.
