![SpecialUI-Lib-violet](https://img.shields.io/badge/SpecialUI-Lib-violet)
[![Discord](https://img.shields.io/badge/Discord-Join-5865F2)](https://discord.gg/yvGpvEAVrn)


## 🍨SpecialUI Sundae (v1.0.0)🍨


## important notice
---

**SpecialUI Library is a fork of Kavo UI, which was made by xHeptc.**
SpecialUI Fixed problems in Kavo UI And added new Features 

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
| **Dark** | Pure black, minimal |
| **Light** | White background, dark text |
| **Grey** | Minimalist Grey Background |
| **Blood** | Deep red, aggressive |
| **Grape** | Purple scheme |
| **Ocean** | Blue/cyan, fresh |
| **Midnight** | Teal on dark blue |
| **Night** | dark blue/purple |
| **Sunset** | orange/pink, warm evening |
| **Sentinel** | Red accents, green text |
| **Synapse** | Brown/gold, Synapse style |
| **Serpent** | Green scheme |
| **Amoled** | True black (OLED friendly) |
| **Lavender** | Soft purple/blue (recommended) |
| **Crimson** | Deep red (elegant) |
| **Forest** | Green/nature |
| **Amber** | Orange/warm |
| **Ice** | Kewl Blue/Cyan |
| **Fire** | Bright Orange/Red |
*Note: Dark, Light, Grape and Blood had the 'Theme' Suffix removed from the original Kavo UI*

---

# 3: Creating Tabs
```
local Tab = Window:NewTab("ExampleTab")
```

---

# 5: Creating Sections
```
local Section = Tab:NewSection("ExampleSection")
```
---

# 6: Creating Labels
```
Section:NewLabel("ExampleLabel")
```
---


# 7: Creating HomeCard
```
local home = Section:NewHomeCard({
    buttons = {
        {text = "Profile", callback = function() print("Profile clicked") end},
        {text = "Settings", callback = function() print("Settings clicked") end}
    }
})
home:UpdateUsername("NewUsername")
home:RefreshAvatar()
```
---


# 8: Creating Buttons
```
Section:NewButton("ExampleTextButton", "ButtonInfo", function()
    print("Clicked")
end)
```

# 8.5: Update Button Text
```
local button = Section:NewButton("Text", "Info", function() end)
button:UpdateButton("New Text")
```
*note: the button must be stored in a variable before updating it*

---

# 9: Creating Toggles
```
Section:NewToggle("ToggleText", "ToggleInfo", function(state)
    if state then
        print("Toggle On")
    else
        print("Toggle Off")
    end
end)
```

# 9.5: Updating Toggles
```
toggle:UpdateToggle("New Toggle Text")

toggle:UpdateToggle("New Toggle Text")  -- changes text only
toggle:UpdateToggle(nil, true)          -- turns on without changing text
toggle:UpdateToggle("Fly Mode", true)   -- changes both
```

---

# 10: Creating TextBoxes
```
Section:NewTextBox("Input Text", "Type something here", function(text)
    print("You typed: " .. text)
end)
```

# 11: Creating Sliders
```
Section:NewSlider("SliderText", "SliderInfo", 500, 0, function(s) -- 500 (MaxValue) | 0 (MinValue)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = s
end)
```

---

# 12: Creating Dropdowns
```
Section:NewDropdown("DropdownText", "DropdownInf", {"Option 1", "Option 2", "Option 3"}, function(currentOption)
    print(currentOption)
end)
```

# 12.5: Refreshing Dropdowns
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

# 13: Creating Keybinds
```
Section:NewKeybind("KeybindText", "KeybindInfo", Enum.KeyCode.F, function()
	print("You just clicked the bind")
end)
```

---

# 14: Creating Color Pickers
```
Section:NewColorPicker("Color Text", "Color Info", Color3.fromRGB(255, 0, 0), function(color)
    print(color)
end)
```

---

## 15: Applying Custom themes
```
local MyTheme = {
    SchemeColor = Color3.fromRGB(255, 100, 100),
    Background = Color3.fromRGB(30, 30, 40),
    Header = Color3.fromRGB(20, 20, 30),
    TextColor = Color3.fromRGB(255, 255, 255),
    ElementColor = Color3.fromRGB(35, 35, 45)
}
```
# Though, applying it will have you to change your window code a bit:
```
local Window = Library.CreateLib("Example", MyTheme)
```

---

# 16: Theme Management
this one's pretty confusing, therefore ill explain it here
you can change Themes, preset2preset, preset2custom, custom2custom & custom2preset
if its preset2preset then:
```
Library:SetTheme("Ocean")
Library:SetTheme("Lavender")
```
if its preset2custom then:
```
Library:SetTheme("Ocean")
Library:SetTheme(MyTheme)
```
if its custom2custom then:
```
Library:SetTheme(MyTheme1)
Library:SetTheme(MyTheme2)
```
if its custom2preset then:
```
Library:SetTheme(MyTheme)
Library:SetTheme("Lavender")
```

---

# 17: Console (useless but new and kewl)
```
local console = Section:NewConsolePlayer()
```
---

## 18: ToggleUI 

```
Section:NewToggleUI("Toggle UI", "Click to hide/show the UI")

local toggleUI = Section:NewToggleUI("Hide UI", "Click me")
toggleUI:UpdateText("Show UI")
toggleUI:Press()
```

---

# 19: Destroy UI
```
Library.DestroyUI()
```

---

Join Our Discord server for Changelogs (in future updates) other future projects,and soon, more documentation.
you can [Click here to join our discord](https://discord.gg/yvGpvEAVrn)

i am incavokewl here, the creator of Special; this was made with heart at 3 AM:)
