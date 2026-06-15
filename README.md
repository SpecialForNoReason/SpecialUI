![SpecialUI-Lib-violet](https://img.shields.io/badge/SpecialUI-Lib-violet)
[![Discord](https://img.shields.io/badge/Discord-Join-5865F2)](https://discord.gg/yvGpvEAVrn)


## SpecialUI v0.1-Preview1


## important notice
---

**SpecialUI Library is a fork of Kavo UI, which was made by xHeptc.**
SpecialUI Fixed Memory leaks and changed the API (From Kavo to SpecialUI)
currently, its in version Beta, so it might be unstable, therefore, if you find any bugs, report 
them to our discord server.

## SpecialUI Library
---

**SpecialUI is an Open Source fork of Kavo UI Lib written in luau/lua5.1. made to easily create Scripts without having to deal
with the pain in the ass of making a custom UI, providing a Decent Minimalist API and a Decent UI.**

## Tutorial
---

# 1: getting the loadstring
```
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/SpecialForNoReason/SpecialUI/refs/heads/main/SpecialUI.lua"))()
```
---

# 2: Creating UI library Window
```
local Window = Library.CreateLib("Example", "Lavender")
```
all of the themes:
| Theme | What they are |
|-------|---------|
| **Default** | Original Kavo blue-gray |
| **Dark** | Pure black, minimal |
| **Light** | White background, dark text |
| **Blood** | Deep red, aggressive |
| **Grape** | Purple scheme |
| **Ocean** | Blue/cyan, fresh |
| **Midnight** | Teal on dark blue |
| **Sentinel** | Red accents, green text |
| **Synapse** | Brown/gold, Synapse style |
| **Serpent** | Green scheme |
| **Amoled** | True black (OLED friendly) |
| **Lavender** | Soft purple/blue (recommended) |
| **Crimson** | Deep red (elegant) |
| **Forest** | Green/nature |
| **Amber** | Orange/warm |
*Note: Dark, Light, Grape and Blood had the 'Theme' Suffix removed from the original Kavo UI*

---

# 3: Creating Tabs
```
local Tab = Window:NewTab("ExampleTab")
```

---

# 4: Creating Sections
```
local Section = Tab:NewSection("ExampleSection")
```
---

# 5: Creating Labels
```
Section:NewLabel("ExampleLabel")
```
---

# 6: Creating Buttons
```
Section:NewButton("ExampleTextButton", "ButtonInfo", function()
    print("Clicked")
end)
```

# 6.5: Update Button Text
```
local button = Section:NewButton("Text", "Info", function() end)
button:UpdateButton("New Text")
```
*note: the button must be stored in a variable before updating it*

---

# 7: Creating Toggles
```
Section:NewToggle("ToggleText", "ToggleInfo", function(state)
    if state then
        print("Toggle On")
    else
        print("Toggle Off")
    end
end)
```

# 7.5: Updating Toggles
```
toggle:UpdateToggle("New Toggle Text")

toggle:UpdateToggle("New Toggle Text")  -- changes text only
toggle:UpdateToggle(nil, true)          -- turns on without changing text
toggle:UpdateToggle("Fly Mode", true)   -- changes both
```

---

# 8: Creating Sliders
```
Section:NewSlider("SliderText", "SliderInfo", 500, 0, function(s) -- 500 (MaxValue) | 0 (MinValue)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = s
end)
```

---

# 9: Creating Dropdowns
```
Section:NewDropdown("DropdownText", "DropdownInf", {"Option 1", "Option 2", "Option 3"}, function(currentOption)
    print(currentOption)
end)
```

# 9.5: Refreshing Dropdowns
```
local oldList = {
  "2019",
  "2020"
}
local newList = {
  "2021",
  "2022"
}
local dropdown = Section:NewDropdown("Dropdown","Info", oldList, function()

end)
Section:NewButton("Update Dropdown", "Refreshes Dropdown", function()
  dropdown:Refresh(newList)
end)
```

---

# 10: Creating Keybinds
```
Section:NewKeybind("KeybindText", "KeybindInfo", Enum.KeyCode.F, function()
	print("You just clicked the bind")
end)
```

# 10.5: Toggling UI with Keybinds
```
Section:NewKeybind("KeybindText", "KeybindInfo", Enum.KeyCode.F, function()
	Library:ToggleUI()
end)
```

---

# 11: Creating Color Pickers
```
Section:NewColorPicker("Color Text", "Color Info", Color3.fromRGB(255, 0, 0), function(color)
    print(color)
end)
```

---

## 12: Applying Custom themes
```
local MyTheme = {
    SchemeColor = Color3.fromRGB(255, 100, 100),
    Background = Color3.fromRGB(30, 30, 40),
    Header = Color3.fromRGB(20, 20, 30),
    TextColor = Color3.fromRGB(255, 255, 255),
    ElementColor = Color3.fromRGB(35, 35, 45)
}
```
# Though, applying it will have you to change your window code a bit
local Window = Library.CreateLib("Example", MyTheme)

# 13: Clean up (DestroyUI)
**Call this to prevent Memory leaks when the player leaves or the script ends:**
```
Library.DestroyUI()
```

---

Join Our Discord server for Changelogs (in future updates) other future projects,and soon, more documentation.
you can [Click here to join our discord](https://discord.gg/yvGpvEAVrn)
