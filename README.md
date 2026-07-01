![SpecialUI-Lib-violet](https://img.shields.io/badge/SpecialUI-Lib-violet)
[![Discord](https://img.shields.io/badge/Discord-Join-5865F2)](https://discord.gg/yvGpvEAVrn)


## 🍰SpecialUI Cheesecake (v1.1.0)🍰


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
| **Loud** | Cyan/aqua, fresh vibe |
| **Deep** | Ass Blue |
| **Sick** | Neon green, aggressive |
| **mint** | Calm Lime |
| **Terminal** | even more ass blue |
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

# 14: Notifications (NEW!)
```
Library:Notify("Hello World!", 3)  
Library:Notify("Short notification") 
```

---

# 15: Creating Color Pickers
```
Section:NewColorPicker("Color Text", "Color Info", Color3.fromRGB(255, 0, 0), function(color)
    print(color)
end)
```

---

## 16: Applying Custom themes
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

# 17: Theme Management
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

# 18: Console (useless but new and kewl)
```
local console = Section:NewConsolePlayer()       
local console = Section:NewConsolePlayer(true)    
```
if you want, you can print things, like this:
```
console:Print("Hello!")
console:Success("It worked!")
console:Warning("Be careful!")
console:Error("Something broke!")
console:Info("FYI...")
console:Clear()
console:SetMaxLines(100)
```

---

# 19: Destroy UI
```
Library.DestroyUI()
```

----------------------------------

## Sub-API
**The Sub-API allows you to create and register your own custom UI elements that behave like native SpecialUI elements.**
# RegisterElement
```
SpecialUI:RegisterElement("ElementName", function(sectionInners, themeList, ThemeEvent, AddConnection, UpdateSize, updateSectionFrame, ...)
    -- Your custom element code here
    -- Must return a table with your element's methods
end)
```
| Parameters | Description |
|-------|---------|
| **sectionInners** | the frame where you element should be parented |
| **themeList** | Current theme colors table (SchemeColor, Background, Header, TextColor, ElementColor) |
| **ThemeEvent** | BindableEvent that fires when theme changes, connect to it for theme updates |
| **AddConnection** | Function to add Connection for Proper Cleanup |
| **UpdateSize** | Function to update parent Section Size |
| **updateSectionFrame** | Function to update section frame size |
| **config** | Configuration table passed when creating the element |
| **Returns** | A table containing your element's methods |

# RegisterExtension
```
SpecialUI:RegisterExtension("FunctionName", function(...)
    -- Your custom function code here
end)
```
Adds new global functions directly to the SpecialUI API.
*example*:
```
SpecialUI:RegisterExtension("MyFunction", function()
    print("Hello World!")
end)

-- Usage:
SpecialUI:MyFunction() -- Prints "Hello World!"
```
# Custom Element Example: ProgressBar
# Registering:
```
Library:RegisterElement("NewProgressBar", function(parent, themeList, ThemeEvent, AddConnection, UpdateSize, updateSectionFrame, config)
    config = config or {}
    
    local frame = Instance.new("Frame")
    frame.Parent = parent
    frame.BackgroundColor3 = themeList.ElementColor
    frame.Size = UDim2.new(0, 352, 0, 33)
    frame.ClipsDescendants = true
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 4)
    
    local bar = Instance.new("Frame")
    bar.Parent = frame
    bar.BackgroundColor3 = themeList.SchemeColor
    bar.Size = UDim2.new((config.progress or 0) / 100, 0, 1, 0)
    Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 4)
    
    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, 0, 1, 0)
    label.Font = Enum.Font.FredokaOne
    label.Text = tostring(config.progress or 0) .. "%"
    label.TextColor3 = themeList.TextColor
    label.TextSize = 14
    
    AddConnection(ThemeEvent.Event:Connect(function()
        frame.BackgroundColor3 = themeList.ElementColor
        bar.BackgroundColor3 = themeList.SchemeColor
        label.TextColor3 = themeList.TextColor
    end))
    
    updateSectionFrame()
    UpdateSize()
    
    return {
        SetProgress = function(_, v)
            v = math.clamp(v, 0, 100)
            bar:TweenSize(UDim2.new(v / 100, 0, 1, 0), "InOut", "Quad", 0.3)
            label.Text = v .. "%"
        end
    }
end)
```
# Using:
```
local bar = Section:NewProgressBar({progress = 0})

Section:NewButton("25%", "", function()
    bar:SetProgress(25)
end)

Section:NewButton("50%", "", function()
    bar:SetProgress(50)
end)

Section:NewButton("100%", "", function()
    bar:SetProgress(100)
end)
```

---

Join Our Discord server for Changelogs (in future updates) other future projects,and soon, more documentation.
you can [Click here to join our discord](https://discord.gg/yvGpvEAVrn)

i am incavokewl here, the creator of Special; this was made with heart at 3 AM:)
