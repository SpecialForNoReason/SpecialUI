-- SpecialUI v1.0.0 (Sundae)
-- Credits to xHeptc for Kavo UI Lib

local SpecialUI = {}

local tween = game:GetService("TweenService")
local tweeninfo = TweenInfo.new
local input = game:GetService("UserInputService")
local run = game:GetService("RunService")

local Utility = {}

local ActiveConnections = {}
local ActiveObjects = {}
local DraggingConnections = {}
local ThemeEvent = nil
local MainInstance = nil
local LibName = nil
local CurrentThemeName = "Dark"
local CurrentThemeTable = nil
local Pages = nil
local tabFrames = nil
local infoContainer = nil
local blurFrame = nil

local ThemeStyles = {
    Dark = { SchemeColor = Color3.fromRGB(64, 64, 64), Background = Color3.fromRGB(0, 0, 0), Header = Color3.fromRGB(0, 0, 0), TextColor = Color3.fromRGB(255,255,255), ElementColor = Color3.fromRGB(20, 20, 20) },
    Light = { SchemeColor = Color3.fromRGB(200, 200, 200), Background = Color3.fromRGB(255,255,255), Header = Color3.fromRGB(200, 200, 200), TextColor = Color3.fromRGB(0,0,0), ElementColor = Color3.fromRGB(224, 224, 224) },
    Grey = { SchemeColor = Color3.fromRGB(150, 150, 150), Background = Color3.fromRGB(30, 30, 35), Header = Color3.fromRGB(20, 20, 25), TextColor = Color3.fromRGB(255,255,255), ElementColor = Color3.fromRGB(45, 45, 50) },
    Blood = { SchemeColor = Color3.fromRGB(227, 27, 27), Background = Color3.fromRGB(10, 10, 10), Header = Color3.fromRGB(5, 5, 5), TextColor = Color3.fromRGB(255,255,255), ElementColor = Color3.fromRGB(20, 20, 20) },
    Grape = { SchemeColor = Color3.fromRGB(166, 71, 214), Background = Color3.fromRGB(64, 50, 71), Header = Color3.fromRGB(36, 28, 41), TextColor = Color3.fromRGB(255,255,255), ElementColor = Color3.fromRGB(74, 58, 84) },
    Ocean = { SchemeColor = Color3.fromRGB(86, 76, 251), Background = Color3.fromRGB(26, 32, 58), Header = Color3.fromRGB(38, 45, 71), TextColor = Color3.fromRGB(200, 200, 200), ElementColor = Color3.fromRGB(38, 45, 71) },
    MidNight = { SchemeColor = Color3.fromRGB(26, 189, 158), Background = Color3.fromRGB(44, 62, 82), Header = Color3.fromRGB(57, 81, 105), TextColor = Color3.fromRGB(255, 255, 255), ElementColor = Color3.fromRGB(52, 74, 95) },
    Night = { SchemeColor = Color3.fromRGB(100, 100, 200), Background = Color3.fromRGB(10, 10, 20), Header = Color3.fromRGB(5, 5, 15), TextColor = Color3.fromRGB(255,255,255), ElementColor = Color3.fromRGB(20, 20, 35) },
    Sunset = { SchemeColor = Color3.fromRGB(255, 140, 0), Background = Color3.fromRGB(40, 20, 25), Header = Color3.fromRGB(30, 15, 20), TextColor = Color3.fromRGB(255,255,255), ElementColor = Color3.fromRGB(55, 30, 35) },
    Sentinel = { SchemeColor = Color3.fromRGB(230, 35, 69), Background = Color3.fromRGB(32, 32, 32), Header = Color3.fromRGB(24, 24, 24), TextColor = Color3.fromRGB(119, 209, 138), ElementColor = Color3.fromRGB(24, 24, 24) },
    Synapse = { SchemeColor = Color3.fromRGB(46, 48, 43), Background = Color3.fromRGB(13, 15, 12), Header = Color3.fromRGB(36, 38, 35), TextColor = Color3.fromRGB(152, 99, 53), ElementColor = Color3.fromRGB(24, 24, 24) },
    Amoled = { SchemeColor = Color3.fromRGB(100, 100, 100), Background = Color3.fromRGB(0, 0, 0), Header = Color3.fromRGB(0, 0, 0), TextColor = Color3.fromRGB(255,255,255), ElementColor = Color3.fromRGB(10, 10, 10) },
    Lavender = { SchemeColor = Color3.fromRGB(180, 136, 255), Background = Color3.fromRGB(25, 20, 35), Header = Color3.fromRGB(20, 15, 30), TextColor = Color3.fromRGB(255,255,255), ElementColor = Color3.fromRGB(30, 25, 45) },
    Crimson = { SchemeColor = Color3.fromRGB(220, 20, 60), Background = Color3.fromRGB(15, 15, 20), Header = Color3.fromRGB(10, 10, 15), TextColor = Color3.fromRGB(255,255,255), ElementColor = Color3.fromRGB(20, 20, 25) },
    Forest = { SchemeColor = Color3.fromRGB(34, 139, 34), Background = Color3.fromRGB(20, 30, 20), Header = Color3.fromRGB(15, 25, 15), TextColor = Color3.fromRGB(255,255,255), ElementColor = Color3.fromRGB(25, 35, 25) },
    Amber = { SchemeColor = Color3.fromRGB(255, 126, 0), Background = Color3.fromRGB(25, 20, 15), Header = Color3.fromRGB(20, 15, 10), TextColor = Color3.fromRGB(255,255,255), ElementColor = Color3.fromRGB(30, 25, 20) },
    Ice = { SchemeColor = Color3.fromRGB(0, 200, 255), Background = Color3.fromRGB(20, 25, 35), Header = Color3.fromRGB(15, 20, 30), TextColor = Color3.fromRGB(255,255,255), ElementColor = Color3.fromRGB(30, 40, 55) },
    Fire = { SchemeColor = Color3.fromRGB(255, 80, 0), Background = Color3.fromRGB(35, 15, 10), Header = Color3.fromRGB(25, 10, 5), TextColor = Color3.fromRGB(255,255,255), ElementColor = Color3.fromRGB(45, 25, 15) }
}

-- Set initial theme reference to prevent nil index errors
local themeList = table.clone(ThemeStyles.Dark)

local function safeCall(func, ...)
    local success, result = pcall(func, ...)
    if not success then warn("SpecialUI Error: " .. tostring(result)) end
    return result
end

local function AddConnection(conn)
    table.insert(ActiveConnections, conn)
    return conn
end

local function AddObject(obj)
    table.insert(ActiveObjects, obj)
    return obj
end

function Utility:TweenObject(obj, properties, duration, ...)
    if obj and obj.Parent then
        local twe = safeCall(tween.Create, tween, obj, tweeninfo(duration, ...), properties)
        if twe then twe:Play() end
        return twe
    end
end

local function GetTheme(theme)
    if type(theme) == "string" then
        return ThemeStyles[theme] or ThemeStyles.Dark
    end
    return theme or ThemeStyles.Dark
end

function SpecialUI:DraggingEnabled(frame, parent, instanceId)
    parent = parent or frame
    local dragging = false
    local dragInput, mousePos, framePos

    local conn1 = frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            mousePos = input.Position
            framePos = parent.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    AddConnection(conn1)

    local conn2 = frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    AddConnection(conn2)

    local conn3 = input.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            parent.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
        end
    end)
    AddConnection(conn3)
end

function SpecialUI:ToggleUI()
    local gui = game.CoreGui:FindFirstChild(LibName)
    if gui then gui.Enabled = not gui.Enabled end
end

function SpecialUI.DestroyUI()
    if ThemeEvent then safeCall(ThemeEvent.Destroy, ThemeEvent); ThemeEvent = nil end
    for _, conn in pairs(ActiveConnections) do safeCall(conn.Disconnect, conn) end
    for _, conns in pairs(DraggingConnections) do
        for _, conn in ipairs(conns) do safeCall(conn.Disconnect, conn) end
    end
    for i = #ActiveObjects, 1, -1 do
        local obj = ActiveObjects[i]
        if obj and obj.Parent then safeCall(obj.Destroy, obj) end
        ActiveObjects[i] = nil
    end
    if MainInstance and MainInstance.Parent then safeCall(MainInstance.Destroy, MainInstance); MainInstance = nil end
    local gui = game.CoreGui:FindFirstChild(LibName)
    if gui then safeCall(gui.Destroy, gui) end
    ActiveConnections = {}
    DraggingConnections = {}
    ActiveObjects = {}
    Pages = nil
    tabFrames = nil
    infoContainer = nil
    blurFrame = nil
end

function SpecialUI:SetTheme(theme)
    local newTheme
    if type(theme) == "string" then
        if ThemeStyles[theme] then
            newTheme = ThemeStyles[theme]
            CurrentThemeName = theme
            CurrentThemeTable = nil
        else
            warn("SpecialUI: Theme '" .. theme .. "' not found!")
            return
        end
    elseif type(theme) == "table" then
        newTheme = theme
        CurrentThemeName = "Custom"
        CurrentThemeTable = theme
    else
        warn("SpecialUI: Invalid theme type!")
        return
    end
    for key, value in pairs(newTheme) do
        themeList[key] = value
    end
    if ThemeEvent then ThemeEvent:Fire() end
end

function SpecialUI:GetTheme()
    if CurrentThemeTable then return CurrentThemeTable end
    return CurrentThemeName
end

function SpecialUI:GetThemes()
    local themeNames = {}
    for name, _ in pairs(ThemeStyles) do
        table.insert(themeNames, name)
    end
    return themeNames
end

function SpecialUI:ThemeExists(theme)
    return ThemeStyles[theme] ~= nil
end

function SpecialUI.CreateLib(kavName, themeName)
    if ThemeEvent then safeCall(ThemeEvent.Destroy, ThemeEvent); ThemeEvent = nil end
    ThemeEvent = Instance.new("BindableEvent")
    
    local resolvedTheme = GetTheme(themeName)
    for key, val in pairs(resolvedTheme) do
        themeList[key] = val
    end
    
    CurrentThemeName = type(themeName) == "string" and themeName or "Custom"
    kavName = kavName or "Library"
    LibName = tostring(math.random(1000, 9999)) .. tostring(math.random(1000, 9999))
    local instanceId = tostring(os.clock()) .. tostring(math.random(9999))
    
    for i,v in pairs(game.CoreGui:GetChildren()) do
        if v:IsA("ScreenGui") and v.Name == kavName then safeCall(v.Destroy, v) end
    end
    
    local ScreenGui = safeCall(Instance.new, "ScreenGui")
    if not ScreenGui then return nil end
    ScreenGui.Name = LibName
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = game.CoreGui
    AddObject(ScreenGui)
    
    MainInstance = safeCall(Instance.new, "Frame")
    if not MainInstance then return nil end
    MainInstance.Name = "Main"
    MainInstance.Parent = ScreenGui
    MainInstance.BackgroundColor3 = themeList.Background
    MainInstance.ClipsDescendants = true
    MainInstance.Position = UDim2.new(0.3365, 0, 0.2755, 0)
    MainInstance.Size = UDim2.new(0, 525, 0, 318)
    AddObject(MainInstance)
    
    local MainCorner = safeCall(Instance.new, "UICorner")
    if MainCorner then MainCorner.CornerRadius = UDim.new(0, 4); MainCorner.Parent = MainInstance end
    
    local MainHeader = safeCall(Instance.new, "Frame")
    if MainHeader then
        MainHeader.Name = "MainHeader"
        MainHeader.Parent = MainInstance
        MainHeader.BackgroundColor3 = themeList.Header
        MainHeader.Size = UDim2.new(0, 525, 0, 29)
    end
    
    local headerCover = safeCall(Instance.new, "UICorner")
    if headerCover then headerCover.CornerRadius = UDim.new(0, 4); headerCover.Parent = MainHeader end
    
    local coverup = safeCall(Instance.new, "Frame")
    if coverup then
        coverup.Name = "coverup"
        coverup.Parent = MainHeader
        coverup.BackgroundColor3 = themeList.Header
        coverup.BorderSizePixel = 0
        coverup.Position = UDim2.new(0, 0, 0.7586, 0)
        coverup.Size = UDim2.new(0, 525, 0, 7)
    end
    
    local title = safeCall(Instance.new, "TextLabel")
    if title then
        title.Name = "title"
        title.Parent = MainHeader
        title.BackgroundTransparency = 1
        title.Position = UDim2.new(0.01714, 0, 0.3448, 0)
        title.Size = UDim2.new(0, 204, 0, 8)
        title.Font = Enum.Font.FredokaOne
        title.RichText = true
        title.Text = kavName
        title.TextColor3 = Color3.fromRGB(245, 245, 245)
        title.TextSize = 16
        title.TextXAlignment = Enum.TextXAlignment.Left
    end
    
    local close = safeCall(Instance.new, "ImageButton")
    if close then
        close.Name = "close"
        close.Parent = MainHeader
        close.BackgroundTransparency = 1
        close.Position = UDim2.new(0.95, 0, 0.138, 0)
        close.Size = UDim2.new(0, 21, 0, 21)
        close.Image = "rbxassetid://3926305904"
        close.ImageRectOffset = Vector2.new(284, 4)
        close.ImageRectSize = Vector2.new(24, 24)
        local closeConn = close.MouseButton1Click:Connect(function() SpecialUI.DestroyUI() end)
        AddConnection(closeConn)
    end
    
    local MainSide = safeCall(Instance.new, "Frame")
    if MainSide then
        MainSide.Name = "MainSide"
        MainSide.Parent = MainInstance
        MainSide.BackgroundColor3 = themeList.Header
        MainSide.Position = UDim2.new(-7.45e-09, 0, 0.09119, 0)
        MainSide.Size = UDim2.new(0, 149, 0, 289)
    end
    
    local sideCorner = safeCall(Instance.new, "UICorner")
    if sideCorner then sideCorner.CornerRadius = UDim.new(0, 4); sideCorner.Parent = MainSide end
    
    local coverup_2 = safeCall(Instance.new, "Frame")
    if coverup_2 then
        coverup_2.Name = "coverup"
        coverup_2.Parent = MainSide
        coverup_2.BackgroundColor3 = themeList.Header
        coverup_2.BorderSizePixel = 0
        coverup_2.Position = UDim2.new(0.94994, 0, 0, 0)
        coverup_2.Size = UDim2.new(0, 7, 0, 289)
    end
    
    tabFrames = safeCall(Instance.new, "Frame")
    if tabFrames then
        tabFrames.Name = "tabFrames"
        tabFrames.Parent = MainSide
        tabFrames.BackgroundTransparency = 1
        tabFrames.Position = UDim2.new(0.0439, 0, -0.00066, 0)
        tabFrames.Size = UDim2.new(0, 135, 0, 283)
    end
    
    local tabListing = safeCall(Instance.new, "UIListLayout")
    if tabListing then tabListing.Parent = tabFrames; tabListing.SortOrder = Enum.SortOrder.LayoutOrder end
    
    local pages = safeCall(Instance.new, "Frame")
    if pages then
        pages.Name = "pages"
        pages.Parent = MainInstance
        pages.BackgroundTransparency = 1
        pages.Position = UDim2.new(0.29905, 0, 0.12264, 0)
        pages.Size = UDim2.new(0, 360, 0, 269)
    end
    
    Pages = safeCall(Instance.new, "Folder")
    if Pages then Pages.Name = "Pages"; Pages.Parent = pages end
    
    infoContainer = safeCall(Instance.new, "Frame")
    if infoContainer then
        infoContainer.Name = "infoContainer"
        infoContainer.Parent = MainInstance
        infoContainer.BackgroundTransparency = 1
        infoContainer.ClipsDescendants = true
        infoContainer.Position = UDim2.new(0.29905, 0, 0.8742, 0)
        infoContainer.Size = UDim2.new(0, 368, 0, 33)
    end
    
    blurFrame = safeCall(Instance.new, "Frame")
    if blurFrame then
        blurFrame.Name = "blurFrame"
        blurFrame.Parent = pages
        blurFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        blurFrame.BackgroundTransparency = 1
        blurFrame.BorderSizePixel = 0
        blurFrame.Position = UDim2.new(-0.02222, 0, -0.03717, 0)
        blurFrame.Size = UDim2.new(0, 376, 0, 289)
        blurFrame.ZIndex = 999
    end
    
    SpecialUI:DraggingEnabled(MainHeader, MainInstance, instanceId)
    
    local function UpdateAllThemeColors()
        if not MainInstance or not MainInstance.Parent then return end
        MainInstance.BackgroundColor3 = themeList.Background
        if MainHeader then MainHeader.BackgroundColor3 = themeList.Header end
        if MainSide then MainSide.BackgroundColor3 = themeList.Header end
        if coverup_2 then coverup_2.BackgroundColor3 = themeList.Header end
        if coverup then coverup.BackgroundColor3 = themeList.Header end
    end
    
    local themeConn = ThemeEvent.Event:Connect(UpdateAllThemeColors)
    AddConnection(themeConn)
    UpdateAllThemeColors()
    
    function SpecialUI:ChangeColor(prop, color)
        if prop == "Background" then themeList.Background = color
        elseif prop == "SchemeColor" then themeList.SchemeColor = color
        elseif prop == "Header" then themeList.Header = color
        elseif prop == "TextColor" then themeList.TextColor = color
        elseif prop == "ElementColor" then themeList.ElementColor = color
        end
        if ThemeEvent then ThemeEvent:Fire() end
    end
    
    local Tabs = {}
    local first = true
    
    function Tabs:NewTab(tabName)
        tabName = tabName or "Tab"
        local tabButton = Instance.new("TextButton")
        local UICorner = Instance.new("UICorner")
        local page = Instance.new("ScrollingFrame")
        local pageListing = Instance.new("UIListLayout")
        
        local function UpdateSize()
            if not page or not page.Parent then return end
            local success, cS = pcall(function() return pageListing.AbsoluteContentSize end)
            if success and cS then
                pcall(function()
                    tween:Create(page, TweenInfo.new(0.15, Enum.EasingStyle.Linear), {
                        CanvasSize = UDim2.new(0, cS.X, 0, cS.Y)
                    }):Play()
                end)
            end
        end
        
        page.Name = tabName
        page.Parent = Pages
        page.Active = true
        page.BackgroundColor3 = themeList.Background
        page.BorderSizePixel = 0
        page.Position = UDim2.new(0, 0, -0.00372, 0)
        page.Size = UDim2.new(1, 0, 1, 0)
        page.ScrollBarThickness = 5
        page.Visible = false
        page.ScrollBarImageColor3 = Color3.fromRGB(math.clamp(themeList.SchemeColor.R * 255 - 16, 0, 255), math.clamp(themeList.SchemeColor.G * 255 - 15, 0, 255), math.clamp(themeList.SchemeColor.B * 255 - 28, 0, 255))
        
        pageListing.Name = "pageListing"
        pageListing.Parent = page
        pageListing.SortOrder = Enum.SortOrder.LayoutOrder
        pageListing.Padding = UDim.new(0, 5)
        
        tabButton.Name = tabName.."TabButton"
        tabButton.Parent = tabFrames
        tabButton.BackgroundColor3 = themeList.SchemeColor
        tabButton.Size = UDim2.new(0, 135, 0, 28)
        tabButton.AutoButtonColor = false
        tabButton.Font = Enum.Font.FredokaOne
        tabButton.Text = tabName
        tabButton.TextColor3 = themeList.TextColor
        tabButton.TextSize = 14
        tabButton.BackgroundTransparency = 1
        
        if first then
            first = false
            page.Visible = true
            tabButton.BackgroundTransparency = 0
            UpdateSize()
        else
            page.Visible = false
            tabButton.BackgroundTransparency = 1
        end
        
        UICorner.CornerRadius = UDim.new(0, 5)
        UICorner.Parent = tabButton
        
        UpdateSize()
        local childAddedConn = page.ChildAdded:Connect(UpdateSize)
        local childRemovedConn = page.ChildRemoved:Connect(UpdateSize)
        AddConnection(childAddedConn)
        AddConnection(childRemovedConn)
        
        local tabClickConn = tabButton.MouseButton1Click:Connect(function()
            UpdateSize()
            for _, v in pairs(Pages:GetChildren()) do
                if v:IsA("ScrollingFrame") then v.Visible = false end
            end
            page.Visible = true
            for _, v in pairs(tabFrames:GetChildren()) do
                if v:IsA("TextButton") then Utility:TweenObject(v, {BackgroundTransparency = 1}, 0.2) end
            end
            Utility:TweenObject(tabButton, {BackgroundTransparency = 0}, 0.2)
        end)
        AddConnection(tabClickConn)
        
        local Sections = {}
        local focusing = false
        local viewDe = false
        
        Sections._updateSize = UpdateSize
        
        local function UpdateTabTheme()
            if not page or not page.Parent then return end
            page.BackgroundColor3 = themeList.Background
            page.ScrollBarImageColor3 = Color3.fromRGB(math.clamp(themeList.SchemeColor.R * 255 - 16, 0, 255), math.clamp(themeList.SchemeColor.G * 255 - 15, 0, 255), math.clamp(themeList.SchemeColor.B * 255 - 28, 0, 255))
            if tabButton and tabButton.Parent then
                tabButton.TextColor3 = themeList.TextColor
                tabButton.BackgroundColor3 = themeList.SchemeColor
            end
        end
        
        local themeConn = ThemeEvent.Event:Connect(UpdateTabTheme)
        AddConnection(themeConn)
        UpdateTabTheme()
        
        function Sections:NewSection(secName, hidden)
            secName = secName or "Section"
            local sectionFrame = Instance.new("Frame")
            local sectionlistoknvm = Instance.new("UIListLayout")
            local sectionHead = Instance.new("Frame")
            local sHeadCorner = Instance.new("UICorner")
            local sectionName = Instance.new("TextLabel")
            local sectionInners = Instance.new("Frame")
            local sectionElListing = Instance.new("UIListLayout")
            
            if hidden then sectionHead.Visible = false else sectionHead.Visible = true end
            
            sectionFrame.Name = "sectionFrame"
            sectionFrame.Parent = page
            sectionFrame.BackgroundColor3 = themeList.Background
            sectionFrame.BorderSizePixel = 0
            
            sectionlistoknvm.Name = "sectionlistoknvm"
            sectionlistoknvm.Parent = sectionFrame
            sectionlistoknvm.SortOrder = Enum.SortOrder.LayoutOrder
            sectionlistoknvm.Padding = UDim.new(0, 5)
            
            sectionHead.Name = "sectionHead"
            sectionHead.Parent = sectionFrame
            sectionHead.BackgroundColor3 = themeList.SchemeColor
            sectionHead.Size = UDim2.new(0, 352, 0, 33)
            
            sHeadCorner.CornerRadius = UDim.new(0, 4)
            sHeadCorner.Parent = sectionHead
            
            sectionName.Name = "sectionName"
            sectionName.Parent = sectionHead
            sectionName.BackgroundTransparency = 1
            sectionName.Position = UDim2.new(0.01989, 0, 0, 0)
            sectionName.Size = UDim2.new(0.98011, 0, 1, 0)
            sectionName.Font = Enum.Font.FredokaOne
            sectionName.Text = secName
            sectionName.RichText = true
            sectionName.TextColor3 = themeList.TextColor
            sectionName.TextSize = 14
            sectionName.TextXAlignment = Enum.TextXAlignment.Left
            
            sectionInners.Name = "sectionInners"
            sectionInners.Parent = sectionFrame
            sectionInners.BackgroundTransparency = 1
            sectionInners.Position = UDim2.new(0, 0, 0.19075, 0)
            
            sectionElListing.Name = "sectionElListing"
            sectionElListing.Parent = sectionInners
            sectionElListing.SortOrder = Enum.SortOrder.LayoutOrder
            sectionElListing.Padding = UDim.new(0, 3)
            
            local function updateSectionFrame()
                if not sectionInners or not sectionInners.Parent then return end
                local success, innerSc = pcall(function() return sectionElListing.AbsoluteContentSize end)
                if success and innerSc then sectionInners.Size = UDim2.new(1, 0, 0, innerSc.Y) end
                local success2, frameSc = pcall(function() return sectionlistoknvm.AbsoluteContentSize end)
                if success2 and frameSc then sectionFrame.Size = UDim2.new(0, 352, 0, frameSc.Y) end
            end
            
            updateSectionFrame()
            UpdateSize()
            
            local function onChildChanged()
                updateSectionFrame()
                UpdateSize()
            end
            
            local childAddedConn = sectionInners.ChildAdded:Connect(onChildChanged)
            local childRemovedConn = sectionInners.ChildRemoved:Connect(onChildChanged)
            AddConnection(childAddedConn)
            AddConnection(childRemovedConn)
            
            local function UpdateSectionTheme()
                if not sectionFrame or not sectionFrame.Parent then return end
                sectionFrame.BackgroundColor3 = themeList.Background
                if sectionHead then sectionHead.BackgroundColor3 = themeList.SchemeColor end
                if sectionName then sectionName.TextColor3 = themeList.TextColor end
            end
            
            local themeConn = ThemeEvent.Event:Connect(UpdateSectionTheme)
            AddConnection(themeConn)
            UpdateSectionTheme()
            
            local Elements = {}
            Elements._frame = sectionFrame
            
            function Elements:NewButton(bname, tipInf, callback)
                tipInf = tipInf or "Click this button"
                bname = bname or "Button"
                callback = callback or function() end
                
                local buttonElement = Instance.new("TextButton")
                local UICorner = Instance.new("UICorner")
                local btnInfo = Instance.new("TextLabel")
                local viewInfo = Instance.new("ImageButton")
                local touch = Instance.new("ImageLabel")
                local Sample = Instance.new("ImageLabel")
                
                buttonElement.Name = bname
                buttonElement.Parent = sectionInners
                buttonElement.BackgroundColor3 = themeList.ElementColor
                buttonElement.ClipsDescendants = true
                buttonElement.Size = UDim2.new(0, 352, 0, 33)
                buttonElement.AutoButtonColor = false
                buttonElement.Font = Enum.Font.FredokaOne
                buttonElement.Text = ""
                buttonElement.TextColor3 = Color3.fromRGB(0, 0, 0)
                buttonElement.TextSize = 14
                
                UICorner.CornerRadius = UDim.new(0, 4)
                UICorner.Parent = buttonElement
                
                viewInfo.Name = "viewInfo"
                viewInfo.Parent = buttonElement
                viewInfo.BackgroundTransparency = 1
                viewInfo.Position = UDim2.new(0.93, 0, 0.152, 0)
                viewInfo.Size = UDim2.new(0, 23, 0, 23)
                viewInfo.ZIndex = 2
                viewInfo.Image = "rbxassetid://3926305904"
                viewInfo.ImageColor3 = themeList.SchemeColor
                viewInfo.ImageRectOffset = Vector2.new(764, 764)
                viewInfo.ImageRectSize = Vector2.new(36, 36)
                
                Sample.Name = "Sample"
                Sample.Parent = buttonElement
                Sample.BackgroundTransparency = 1
                Sample.Image = "rbxassetid://4560909609"
                Sample.ImageColor3 = themeList.SchemeColor
                Sample.ImageTransparency = 0.6
                
                local moreInfo = Instance.new("TextLabel")
                local moreInfoCorner = Instance.new("UICorner")
                
                moreInfo.Name = "TipMore"
                moreInfo.Parent = infoContainer
                moreInfo.BackgroundColor3 = Color3.fromRGB(math.clamp(themeList.SchemeColor.R * 255 - 14, 0, 255), math.clamp(themeList.SchemeColor.G * 255 - 17, 0, 255), math.clamp(themeList.SchemeColor.B * 255 - 13, 0, 255))
                moreInfo.Position = UDim2.new(0, 0, 2, 0)
                moreInfo.Size = UDim2.new(0, 353, 0, 33)
                moreInfo.ZIndex = 9
                moreInfo.Font = Enum.Font.FredokaOne
                moreInfo.RichText = true
                moreInfo.Text = "  " .. tipInf
                moreInfo.TextColor3 = themeList.TextColor
                moreInfo.TextSize = 14
                moreInfo.TextXAlignment = Enum.TextXAlignment.Left
                
                moreInfoCorner.CornerRadius = UDim.new(0, 4)
                moreInfoCorner.Parent = moreInfo
                
                touch.Name = "touch"
                touch.Parent = buttonElement
                touch.BackgroundTransparency = 1
                touch.Position = UDim2.new(0.02, 0, 0.18, 0)
                touch.Size = UDim2.new(0, 21, 0, 21)
                touch.Image = "rbxassetid://3926305904"
                touch.ImageColor3 = themeList.SchemeColor
                touch.ImageRectOffset = Vector2.new(84, 204)
                touch.ImageRectSize = Vector2.new(36, 36)
                touch.ImageTransparency = 0
                
                btnInfo.Name = "btnInfo"
                btnInfo.Parent = buttonElement
                btnInfo.BackgroundTransparency = 1
                btnInfo.Position = UDim2.new(0.0967, 0, 0.2727, 0)
                btnInfo.Size = UDim2.new(0, 314, 0, 14)
                btnInfo.Font = Enum.Font.FredokaOne
                btnInfo.Text = bname
                btnInfo.RichText = true
                btnInfo.TextColor3 = themeList.TextColor
                btnInfo.TextSize = 14
                btnInfo.TextXAlignment = Enum.TextXAlignment.Left
                
                updateSectionFrame()
                UpdateSize()
                
                local ms = game.Players.LocalPlayer:GetMouse()
                local btn = buttonElement
                local sample = Sample
                local isHovering = false
                
                local clickConn = btn.MouseButton1Click:Connect(function()
                    if not focusing then
                        safeCall(callback)
                        if btn and btn.Parent then
                            local c = sample:Clone()
                            c.Parent = btn
                            local success, x, y = pcall(function() 
                                return ms.X - c.AbsolutePosition.X, ms.Y - c.AbsolutePosition.Y 
                            end)
                            if success then c.Position = UDim2.new(0, x, 0, y) end
                            local size = btn.AbsoluteSize.X >= btn.AbsoluteSize.Y and (btn.AbsoluteSize.X * 1.5) or (btn.AbsoluteSize.Y * 1.5)
                            c:TweenSizeAndPosition(UDim2.new(0, size, 0, size), UDim2.new(0.5, -size/2, 0.5, -size/2), 'Out', 'Quad', 0.35, true, nil)
                            for i = 1, 10 do
                                c.ImageTransparency = c.ImageTransparency + 0.05
                                task.wait(0.35 / 12)
                            end
                            c:Destroy()
                        end
                    else
                        for _, v in pairs(infoContainer:GetChildren()) do
                            if v and v.Parent then Utility:TweenObject(v, {Position = UDim2.new(0, 0, 2, 0)}, 0.2) end
                            focusing = false
                        end
                        if blurFrame and blurFrame.Parent then Utility:TweenObject(blurFrame, {BackgroundTransparency = 1}, 0.2) end
                    end
                end)
                AddConnection(clickConn)
                
                local enterConn = btn.MouseEnter:Connect(function()
                    if not focusing and btn and btn.Parent then
                        local twe = tween:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(math.clamp(themeList.ElementColor.R * 255 + 8, 0, 255), math.clamp(themeList.ElementColor.G * 255 + 9, 0, 255), math.clamp(themeList.ElementColor.B * 255 + 10, 0, 255))})
                        twe:Play()
                        isHovering = true
                    end
                end)
                AddConnection(enterConn)
                
                local leaveConn = btn.MouseLeave:Connect(function()
                    if not focusing and btn and btn.Parent then
                        local twe = tween:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = themeList.ElementColor})
                        twe:Play()
                        isHovering = false
                    end
                end)
                AddConnection(leaveConn)
                
                local viewConn = viewInfo.MouseButton1Click:Connect(function()
                    if not viewDe then
                        viewDe = true
                        focusing = true
                        for _, v in pairs(infoContainer:GetChildren()) do
                            if v and v ~= moreInfo and v.Parent then Utility:TweenObject(v, {Position = UDim2.new(0, 0, 2, 0)}, 0.2) end
                        end
                        if moreInfo and moreInfo.Parent then Utility:TweenObject(moreInfo, {Position = UDim2.new(0, 0, 0, 0)}, 0.2) end
                        if blurFrame and blurFrame.Parent then Utility:TweenObject(blurFrame, {BackgroundTransparency = 0.5}, 0.2) end
                        if btn and btn.Parent then Utility:TweenObject(btn, {BackgroundColor3 = themeList.ElementColor}, 0.2) end
                        task.wait(1.5)
                        focusing = false
                        if moreInfo and moreInfo.Parent then Utility:TweenObject(moreInfo, {Position = UDim2.new(0, 0, 2, 0)}, 0.2) end
                        if blurFrame and blurFrame.Parent then Utility:TweenObject(blurFrame, {BackgroundTransparency = 1}, 0.2) end
                        viewDe = false
                    end
                end)
                AddConnection(viewConn)
                
                local function UpdateButtonTheme()
                    if not buttonElement or not buttonElement.Parent then return end
                    if not isHovering then buttonElement.BackgroundColor3 = themeList.ElementColor end
                    if viewInfo then viewInfo.ImageColor3 = themeList.SchemeColor end
                    if Sample then Sample.ImageColor3 = themeList.SchemeColor end
                    if moreInfo then 
                        moreInfo.BackgroundColor3 = Color3.fromRGB(math.clamp(themeList.SchemeColor.R * 255 - 14, 0, 255), math.clamp(themeList.SchemeColor.G * 255 - 17, 0, 255), math.clamp(themeList.SchemeColor.B * 255 - 13, 0, 255))
                        moreInfo.TextColor3 = themeList.TextColor
                    end
                    if touch then touch.ImageColor3 = themeList.SchemeColor end
                    if btnInfo then btnInfo.TextColor3 = themeList.TextColor end
                end
                
                local themeConn = ThemeEvent.Event:Connect(UpdateButtonTheme)
                AddConnection(themeConn)
                UpdateButtonTheme()
                
                local ButtonFunction = {}
                function ButtonFunction:UpdateButton(newTitle)
                    if btnInfo then btnInfo.Text = newTitle end
                end
                return ButtonFunction
            end
            
            function Elements:NewTextBox(tname, tTip, callback)
                tname = tname or "TextBox"
                tTip = tTip or "Enter a value"
                callback = callback or function() end
                
                local textboxElement = Instance.new("TextButton")
                local UICorner = Instance.new("UICorner")
                local viewInfo = Instance.new("ImageButton")
                local write = Instance.new("ImageLabel")
                local TextBox = Instance.new("TextBox")
                local textBoxCorner = Instance.new("UICorner")
                local togName = Instance.new("TextLabel")
                
                textboxElement.Name = "textboxElement"
                textboxElement.Parent = sectionInners
                textboxElement.BackgroundColor3 = themeList.ElementColor
                textboxElement.ClipsDescendants = true
                textboxElement.Size = UDim2.new(0, 352, 0, 33)
                textboxElement.AutoButtonColor = false
                textboxElement.Font = Enum.Font.FredokaOne
                textboxElement.Text = ""
                textboxElement.TextColor3 = Color3.fromRGB(0, 0, 0)
                textboxElement.TextSize = 14
                
                UICorner.CornerRadius = UDim.new(0, 4)
                UICorner.Parent = textboxElement
                
                viewInfo.Name = "viewInfo"
                viewInfo.Parent = textboxElement
                viewInfo.BackgroundTransparency = 1
                viewInfo.Position = UDim2.new(0.93, 0, 0.152, 0)
                viewInfo.Size = UDim2.new(0, 23, 0, 23)
                viewInfo.Image = "rbxassetid://3926305904"
                viewInfo.ImageColor3 = themeList.SchemeColor
                viewInfo.ImageRectOffset = Vector2.new(764, 764)
                viewInfo.ImageRectSize = Vector2.new(36, 36)
                
                write.Name = "write"
                write.Parent = textboxElement
                write.BackgroundTransparency = 1
                write.Position = UDim2.new(0.02, 0, 0.18, 0)
                write.Size = UDim2.new(0, 21, 0, 21)
                write.Image = "rbxassetid://3926305904"
                write.ImageColor3 = themeList.SchemeColor
                write.ImageRectOffset = Vector2.new(324, 604)
                write.ImageRectSize = Vector2.new(36, 36)
                
                TextBox.Parent = textboxElement
                TextBox.BackgroundColor3 = themeList.ElementColor:lerp(Color3.new(0, 0, 0), 0.2)
                TextBox.BorderSizePixel = 0
                TextBox.Position = UDim2.new(0.48875, 0, 0.21212, 0)
                TextBox.Size = UDim2.new(0, 150, 0, 18)
                TextBox.ClearTextOnFocus = false
                TextBox.Font = Enum.Font.FredokaOne
                TextBox.PlaceholderColor3 = Color3.fromRGB(180, 180, 180)
                TextBox.PlaceholderText = "Type here"
                TextBox.Text = ""
                TextBox.TextColor3 = themeList.TextColor
                TextBox.TextSize = 12
                
                textBoxCorner.CornerRadius = UDim.new(0, 4)
                textBoxCorner.Parent = TextBox
                
                togName.Name = "togName"
                togName.Parent = textboxElement
                togName.BackgroundTransparency = 1
                togName.Position = UDim2.new(0.0967, 0, 0.2727, 0)
                togName.Size = UDim2.new(0, 138, 0, 14)
                togName.Font = Enum.Font.FredokaOne
                togName.Text = tname
                togName.RichText = true
                togName.TextColor3 = themeList.TextColor
                togName.TextSize = 14
                togName.TextXAlignment = Enum.TextXAlignment.Left
                
                local moreInfo = Instance.new("TextLabel")
                local moreInfoCorner = Instance.new("UICorner")
                
                moreInfo.Name = "TipMore"
                moreInfo.Parent = infoContainer
                moreInfo.BackgroundColor3 = Color3.fromRGB(math.clamp(themeList.SchemeColor.R * 255 - 14, 0, 255), math.clamp(themeList.SchemeColor.G * 255 - 17, 0, 255), math.clamp(themeList.SchemeColor.B * 255 - 13, 0, 255))
                moreInfo.Position = UDim2.new(0, 0, 2, 0)
                moreInfo.Size = UDim2.new(0, 353, 0, 33)
                moreInfo.ZIndex = 9
                moreInfo.Font = Enum.Font.FredokaOne
                moreInfo.RichText = true
                moreInfo.Text = "  " .. tTip
                moreInfo.TextColor3 = themeList.TextColor
                moreInfo.TextSize = 14
                moreInfo.TextXAlignment = Enum.TextXAlignment.Left
                
                moreInfoCorner.CornerRadius = UDim.new(0, 4)
                moreInfoCorner.Parent = moreInfo
                
                updateSectionFrame()
                UpdateSize()
                
                local btn = textboxElement
                local isHovering = false
                
                local clickConn = btn.MouseButton1Click:Connect(function()
                    if focusing then
                        for _, v in pairs(infoContainer:GetChildren()) do
                            if v and v.Parent then Utility:TweenObject(v, {Position = UDim2.new(0, 0, 2, 0)}, 0.2) end
                            focusing = false
                        end
                        if blurFrame and blurFrame.Parent then Utility:TweenObject(blurFrame, {BackgroundTransparency = 1}, 0.2) end
                    end
                end)
                AddConnection(clickConn)
                
                local enterConn = btn.MouseEnter:Connect(function()
                    if not focusing and btn and btn.Parent then
                        local twe = tween:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(math.clamp(themeList.ElementColor.R * 255 + 8, 0, 255), math.clamp(themeList.ElementColor.G * 255 + 9, 0, 255), math.clamp(themeList.ElementColor.B * 255 + 10, 0, 255))})
                        twe:Play()
                        isHovering = true
                    end
                end)
                AddConnection(enterConn)
                
                local leaveConn = btn.MouseLeave:Connect(function()
                    if not focusing and btn and btn.Parent then
                        local twe = tween:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = themeList.ElementColor})
                        twe:Play()
                        isHovering = false
                    end
                end)
                AddConnection(leaveConn)
                
                local focusLostConn = TextBox.FocusLost:Connect(function(enterPressed)
                    if focusing then
                        for _, v in pairs(infoContainer:GetChildren()) do
                            if v and v.Parent then Utility:TweenObject(v, {Position = UDim2.new(0, 0, 2, 0)}, 0.2) end
                            focusing = false
                        end
                        if blurFrame and blurFrame.Parent then Utility:TweenObject(blurFrame, {BackgroundTransparency = 1}, 0.2) end
                    end
                    if enterPressed then
                        safeCall(callback, TextBox.Text)
                        task.wait(0.18)
                        TextBox.Text = ""
                    end
                end)
                AddConnection(focusLostConn)
                
                local viewConn = viewInfo.MouseButton1Click:Connect(function()
                    if not viewDe then
                        viewDe = true
                        focusing = true
                        for _, v in pairs(infoContainer:GetChildren()) do
                            if v and v ~= moreInfo and v.Parent then Utility:TweenObject(v, {Position = UDim2.new(0, 0, 2, 0)}, 0.2) end
                        end
                        if moreInfo and moreInfo.Parent then Utility:TweenObject(moreInfo, {Position = UDim2.new(0, 0, 0, 0)}, 0.2) end
                        if blurFrame and blurFrame.Parent then Utility:TweenObject(blurFrame, {BackgroundTransparency = 0.5}, 0.2) end
                        if btn and btn.Parent then Utility:TweenObject(btn, {BackgroundColor3 = themeList.ElementColor}, 0.2) end
                        task.wait(1.5)
                        focusing = false
                        if moreInfo and moreInfo.Parent then Utility:TweenObject(moreInfo, {Position = UDim2.new(0, 0, 2, 0)}, 0.2) end
                        if blurFrame and blurFrame.Parent then Utility:TweenObject(blurFrame, {BackgroundTransparency = 1}, 0.2) end
                        viewDe = false
                    end
                end)
                AddConnection(viewConn)
                
                local function UpdateTextBoxTheme()
                    if not textboxElement or not textboxElement.Parent then return end
                    if not isHovering then textboxElement.BackgroundColor3 = themeList.ElementColor end
                    if TextBox then 
                        TextBox.BackgroundColor3 = themeList.ElementColor:lerp(Color3.new(0, 0, 0), 0.2)
                        TextBox.TextColor3 = themeList.TextColor
                    end
                    if viewInfo then viewInfo.ImageColor3 = themeList.SchemeColor end
                    if moreInfo then
                        moreInfo.BackgroundColor3 = Color3.fromRGB(math.clamp(themeList.SchemeColor.R * 255 - 14, 0, 255), math.clamp(themeList.SchemeColor.G * 255 - 17, 0, 255), math.clamp(themeList.SchemeColor.B * 255 - 13, 0, 255))
                        moreInfo.TextColor3 = themeList.TextColor
                    end
                    if write then write.ImageColor3 = themeList.SchemeColor end
                    if togName then togName.TextColor3 = themeList.TextColor end
                end
                
                local themeConn = ThemeEvent.Event:Connect(UpdateTextBoxTheme)
                AddConnection(themeConn)
                UpdateTextBoxTheme()
                
                local TextBoxFunction = {}
                return TextBoxFunction
            end
            
            function Elements:NewToggle(tname, nTip, callback)
                tname = tname or "Toggle"
                nTip = nTip or "Toggle state"
                callback = callback or function() end
                local toggled = false
                
                local toggleElement = Instance.new("TextButton")
                local UICorner = Instance.new("UICorner")
                local toggleDisabled = Instance.new("ImageLabel")
                local toggleEnabled = Instance.new("ImageLabel")
                local togName = Instance.new("TextLabel")
                local viewInfo = Instance.new("ImageButton")
                local Sample = Instance.new("ImageLabel")
                
                toggleElement.Name = "toggleElement"
                toggleElement.Parent = sectionInners
                toggleElement.BackgroundColor3 = themeList.ElementColor
                toggleElement.ClipsDescendants = true
                toggleElement.Size = UDim2.new(0, 352, 0, 33)
                toggleElement.AutoButtonColor = false
                toggleElement.Font = Enum.Font.FredokaOne
                toggleElement.Text = ""
                toggleElement.TextColor3 = Color3.fromRGB(0, 0, 0)
                toggleElement.TextSize = 14
                
                UICorner.CornerRadius = UDim.new(0, 4)
                UICorner.Parent = toggleElement
                
                toggleDisabled.Name = "toggleDisabled"
                toggleDisabled.Parent = toggleElement
                toggleDisabled.BackgroundTransparency = 1
                toggleDisabled.Position = UDim2.new(0.02, 0, 0.18, 0)
                toggleDisabled.Size = UDim2.new(0, 21, 0, 21)
                toggleDisabled.Image = "rbxassetid://3926309567"
                toggleDisabled.ImageColor3 = themeList.SchemeColor
                toggleDisabled.ImageRectOffset = Vector2.new(628, 420)
                toggleDisabled.ImageRectSize = Vector2.new(48, 48)
                
                toggleEnabled.Name = "toggleEnabled"
                toggleEnabled.Parent = toggleElement
                toggleEnabled.BackgroundTransparency = 1
                toggleEnabled.Position = UDim2.new(0.02, 0, 0.18, 0)
                toggleEnabled.Size = UDim2.new(0, 21, 0, 21)
                toggleEnabled.Image = "rbxassetid://3926309567"
                toggleEnabled.ImageColor3 = themeList.SchemeColor
                toggleEnabled.ImageRectOffset = Vector2.new(784, 420)
                toggleEnabled.ImageRectSize = Vector2.new(48, 48)
                toggleEnabled.ImageTransparency = 1
                
                togName.Name = "togName"
                togName.Parent = toggleElement
                togName.BackgroundTransparency = 1
                togName.Position = UDim2.new(0.0967, 0, 0.2727, 0)
                togName.Size = UDim2.new(0, 288, 0, 14)
                togName.Font = Enum.Font.FredokaOne
                togName.Text = tname
                togName.RichText = true
                togName.TextColor3 = themeList.TextColor
                togName.TextSize = 14
                togName.TextXAlignment = Enum.TextXAlignment.Left
                
                viewInfo.Name = "viewInfo"
                viewInfo.Parent = toggleElement
                viewInfo.BackgroundTransparency = 1
                viewInfo.Position = UDim2.new(0.93, 0, 0.152, 0)
                viewInfo.Size = UDim2.new(0, 23, 0, 23)
                viewInfo.Image = "rbxassetid://3926305904"
                viewInfo.ImageColor3 = themeList.SchemeColor
                viewInfo.ImageRectOffset = Vector2.new(764, 764)
                viewInfo.ImageRectSize = Vector2.new(36, 36)
                
                Sample.Name = "Sample"
                Sample.Parent = toggleElement
                Sample.BackgroundTransparency = 1
                Sample.Image = "rbxassetid://4560909609"
                Sample.ImageColor3 = themeList.SchemeColor
                Sample.ImageTransparency = 0.6
                
                local moreInfo = Instance.new("TextLabel")
                local moreInfoCorner = Instance.new("UICorner")
                
                moreInfo.Name = "TipMore"
                moreInfo.Parent = infoContainer
                moreInfo.BackgroundColor3 = Color3.fromRGB(math.clamp(themeList.SchemeColor.R * 255 - 14, 0, 255), math.clamp(themeList.SchemeColor.G * 255 - 17, 0, 255), math.clamp(themeList.SchemeColor.B * 255 - 13, 0, 255))
                moreInfo.Position = UDim2.new(0, 0, 2, 0)
                moreInfo.Size = UDim2.new(0, 353, 0, 33)
                moreInfo.ZIndex = 9
                moreInfo.Font = Enum.Font.FredokaOne
                moreInfo.RichText = true
                moreInfo.Text = "  " .. nTip
                moreInfo.TextColor3 = themeList.TextColor
                moreInfo.TextSize = 14
                moreInfo.TextXAlignment = Enum.TextXAlignment.Left
                
                moreInfoCorner.CornerRadius = UDim.new(0, 4)
                moreInfoCorner.Parent = moreInfo
                
                updateSectionFrame()
                UpdateSize()
                
                local ms = game.Players.LocalPlayer:GetMouse()
                local btn = toggleElement
                local sample = Sample
                local img = toggleEnabled
                local isHovering = false
                
                local clickConn = btn.MouseButton1Click:Connect(function()
                    if not focusing then
                        if not toggled then
                            local twe = tween:Create(img, TweenInfo.new(0.11), {ImageTransparency = 0})
                            twe:Play()
                            if btn and btn.Parent then
                                local c = sample:Clone()
                                c.Parent = btn
                                local success, x, y = pcall(function() 
                                    return ms.X - c.AbsolutePosition.X, ms.Y - c.AbsolutePosition.Y 
                                end)
                                if success then c.Position = UDim2.new(0, x, 0, y) end
                                local size = btn.AbsoluteSize.X >= btn.AbsoluteSize.Y and (btn.AbsoluteSize.X * 1.5) or (btn.AbsoluteSize.Y * 1.5)
                                c:TweenSizeAndPosition(UDim2.new(0, size, 0, size), UDim2.new(0.5, -size/2, 0.5, -size/2), 'Out', 'Quad', 0.35, true, nil)
                                for i = 1, 10 do
                                    c.ImageTransparency = c.ImageTransparency + 0.05
                                    task.wait(0.35 / 12)
                                end
                                c:Destroy()
                            end
                        else
                            local twe = tween:Create(img, TweenInfo.new(0.11), {ImageTransparency = 1})
                            twe:Play()
                            if btn and btn.Parent then
                                local c = sample:Clone()
                                c.Parent = btn
                                local success, x, y = pcall(function() 
                                    return ms.X - c.AbsolutePosition.X, ms.Y - c.AbsolutePosition.Y 
                                end)
                                if success then c.Position = UDim2.new(0, x, 0, y) end
                                local size = btn.AbsoluteSize.X >= btn.AbsoluteSize.Y and (btn.AbsoluteSize.X * 1.5) or (btn.AbsoluteSize.Y * 1.5)
                                c:TweenSizeAndPosition(UDim2.new(0, size, 0, size), UDim2.new(0.5, -size/2, 0.5, -size/2), 'Out', 'Quad', 0.35, true, nil)
                                for i = 1, 10 do
                                    c.ImageTransparency = c.ImageTransparency + 0.05
                                    task.wait(0.35 / 12)
                                end
                                c:Destroy()
                            end
                        end
                        toggled = not toggled
                        safeCall(callback, toggled)
                    else
                        for _, v in pairs(infoContainer:GetChildren()) do
                            if v and v.Parent then Utility:TweenObject(v, {Position = UDim2.new(0, 0, 2, 0)}, 0.2) end
                            focusing = false
                        end
                        if blurFrame and blurFrame.Parent then Utility:TweenObject(blurFrame, {BackgroundTransparency = 1}, 0.2) end
                    end
                end)
                AddConnection(clickConn)
                
                local enterConn = btn.MouseEnter:Connect(function()
                    if not focusing and btn and btn.Parent then
                        local twe = tween:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(math.clamp(themeList.ElementColor.R * 255 + 8, 0, 255), math.clamp(themeList.ElementColor.G * 255 + 9, 0, 255), math.clamp(themeList.ElementColor.B * 255 + 10, 0, 255))})
                        twe:Play()
                        isHovering = true
                    end
                end)
                AddConnection(enterConn)
                
                local leaveConn = btn.MouseLeave:Connect(function()
                    if not focusing and btn and btn.Parent then
                        local twe = tween:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = themeList.ElementColor})
                        twe:Play()
                        isHovering = false
                    end
                end)
                AddConnection(leaveConn)
                
                local viewConn = viewInfo.MouseButton1Click:Connect(function()
                    if not viewDe then
                        viewDe = true
                        focusing = true
                        for _, v in pairs(infoContainer:GetChildren()) do
                            if v and v ~= moreInfo and v.Parent then Utility:TweenObject(v, {Position = UDim2.new(0, 0, 2, 0)}, 0.2) end
                        end
                        if moreInfo and moreInfo.Parent then Utility:TweenObject(moreInfo, {Position = UDim2.new(0, 0, 0, 0)}, 0.2) end
                        if blurFrame and blurFrame.Parent then Utility:TweenObject(blurFrame, {BackgroundTransparency = 0.5}, 0.2) end
                        if btn and btn.Parent then Utility:TweenObject(btn, {BackgroundColor3 = themeList.ElementColor}, 0.2) end
                        task.wait(1.5)
                        focusing = false
                        if moreInfo and moreInfo.Parent then Utility:TweenObject(moreInfo, {Position = UDim2.new(0, 0, 2, 0)}, 0.2) end
                        if blurFrame and blurFrame.Parent then Utility:TweenObject(blurFrame, {BackgroundTransparency = 1}, 0.2) end
                        viewDe = false
                    end
                end)
                AddConnection(viewConn)
                
                local function UpdateToggleTheme()
                    if not toggleElement or not toggleElement.Parent then return end
                    if not isHovering then toggleElement.BackgroundColor3 = themeList.ElementColor end
                    if toggleDisabled then toggleDisabled.ImageColor3 = themeList.SchemeColor end
                    if toggleEnabled then toggleEnabled.ImageColor3 = themeList.SchemeColor end
                    if togName then togName.TextColor3 = themeList.TextColor end
                    if viewInfo then viewInfo.ImageColor3 = themeList.SchemeColor end
                    if Sample then Sample.ImageColor3 = themeList.SchemeColor end
                    if moreInfo then
                        moreInfo.BackgroundColor3 = Color3.fromRGB(math.clamp(themeList.SchemeColor.R * 255 - 14, 0, 255), math.clamp(themeList.SchemeColor.G * 255 - 17, 0, 255), math.clamp(themeList.SchemeColor.B * 255 - 13, 0, 255))
                        moreInfo.TextColor3 = themeList.TextColor
                    end
                end
                
                local themeConn = ThemeEvent.Event:Connect(UpdateToggleTheme)
                AddConnection(themeConn)
                UpdateToggleTheme()
                
                local ToggleFunction = {}
                function ToggleFunction:UpdateToggle(newText, newState)
                    if newText then togName.Text = newText end
                    if newState ~= nil then
                        toggled = newState
                        local twe = tween:Create(img, TweenInfo.new(0.11), {ImageTransparency = toggled and 0 or 1})
                        twe:Play()
                        safeCall(callback, toggled)
                    end
                end
                return ToggleFunction
            end
            
            function Elements:NewSlider(slidInf, slidTip, maxvalue, minvalue, callback)
                slidInf = slidInf or "Slider"
                slidTip = slidTip or "Slider tip here"
                maxvalue = maxvalue or 500
                minvalue = minvalue or 16
                callback = callback or function() end
                
                local sliderElement = Instance.new("TextButton")
                local UICorner = Instance.new("UICorner")
                local togName = Instance.new("TextLabel")
                local viewInfo = Instance.new("ImageButton")
                local sliderBtn = Instance.new("TextButton")
                local sliderBtnCorner = Instance.new("UICorner")
                local sliderDrag = Instance.new("Frame")
                local sliderDragCorner = Instance.new("UICorner")
                local write = Instance.new("ImageLabel")
                local val = Instance.new("TextLabel")
                local isDragging = false
                local uis = game:GetService("UserInputService")
                local currentValue = minvalue
                local moveConn = nil
                local releaseConn = nil
                
                sliderElement.Name = "sliderElement"
                sliderElement.Parent = sectionInners
                sliderElement.BackgroundColor3 = themeList.ElementColor
                sliderElement.ClipsDescendants = true
                sliderElement.Size = UDim2.new(0, 352, 0, 33)
                sliderElement.AutoButtonColor = false
                sliderElement.Font = Enum.Font.FredokaOne
                sliderElement.Text = ""
                sliderElement.TextColor3 = Color3.fromRGB(0, 0, 0)
                sliderElement.TextSize = 14
                
                UICorner.CornerRadius = UDim.new(0, 4)
                UICorner.Parent = sliderElement
                
                togName.Name = "togName"
                togName.Parent = sliderElement
                togName.BackgroundTransparency = 1
                togName.Position = UDim2.new(0.0967, 0, 0.2727, 0)
                togName.Size = UDim2.new(0, 138, 0, 14)
                togName.Font = Enum.Font.FredokaOne
                togName.Text = slidInf
                togName.RichText = true
                togName.TextColor3 = themeList.TextColor
                togName.TextSize = 14
                togName.TextXAlignment = Enum.TextXAlignment.Left
                
                viewInfo.Name = "viewInfo"
                viewInfo.Parent = sliderElement
                viewInfo.BackgroundTransparency = 1
                viewInfo.Position = UDim2.new(0.93, 0, 0.152, 0)
                viewInfo.Size = UDim2.new(0, 23, 0, 23)
                viewInfo.Image = "rbxassetid://3926305904"
                viewInfo.ImageColor3 = themeList.SchemeColor
                viewInfo.ImageRectOffset = Vector2.new(764, 764)
                viewInfo.ImageRectSize = Vector2.new(36, 36)
                
                sliderBtn.Name = "sliderBtn"
                sliderBtn.Parent = sliderElement
                sliderBtn.BackgroundColor3 = Color3.fromRGB(math.clamp(themeList.ElementColor.R * 255 + 5, 0, 255), math.clamp(themeList.ElementColor.G * 255 + 5, 0, 255), math.clamp(themeList.ElementColor.B * 255 + 5, 0, 255))
                sliderBtn.BorderSizePixel = 0
                sliderBtn.Position = UDim2.new(0.48875, 0, 0.39394, 0)
                sliderBtn.Size = UDim2.new(0, 149, 0, 6)
                sliderBtn.AutoButtonColor = false
                sliderBtn.Font = Enum.Font.FredokaOne
                sliderBtn.Text = ""
                sliderBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
                sliderBtn.TextSize = 14
                
                sliderBtnCorner.CornerRadius = UDim.new(0, 4)
                sliderBtnCorner.Parent = sliderBtn
                
                sliderDrag.Name = "sliderDrag"
                sliderDrag.Parent = sliderBtn
                sliderDrag.BackgroundColor3 = themeList.SchemeColor
                sliderDrag.BorderColor3 = Color3.fromRGB(74, 99, 135)
                sliderDrag.BorderSizePixel = 0
                sliderDrag.Size = UDim2.new(0, 50, 1, 0)
                
                sliderDragCorner.CornerRadius = UDim.new(0, 4)
                sliderDragCorner.Parent = sliderDrag
                
                write.Name = "write"
                write.Parent = sliderElement
                write.BackgroundTransparency = 1
                write.Position = UDim2.new(0.02, 0, 0.18, 0)
                write.Size = UDim2.new(0, 21, 0, 21)
                write.Image = "rbxassetid://3926307971"
                write.ImageColor3 = themeList.SchemeColor
                write.ImageRectOffset = Vector2.new(404, 164)
                write.ImageRectSize = Vector2.new(36, 36)
                
                val.Name = "val"
                val.Parent = sliderElement
                val.BackgroundTransparency = 1
                val.Position = UDim2.new(0.35239, 0, 0.27273, 0)
                val.Size = UDim2.new(0, 41, 0, 14)
                val.Font = Enum.Font.FredokaOne
                val.Text = tostring(minvalue)
                val.TextColor3 = themeList.TextColor
                val.TextSize = 14
                val.TextTransparency = 1
                val.TextXAlignment = Enum.TextXAlignment.Right
                
                local moreInfo = Instance.new("TextLabel")
                local moreInfoCorner = Instance.new("UICorner")
                
                moreInfo.Name = "TipMore"
                moreInfo.Parent = infoContainer
                moreInfo.BackgroundColor3 = Color3.fromRGB(math.clamp(themeList.SchemeColor.R * 255 - 14, 0, 255), math.clamp(themeList.SchemeColor.G * 255 - 17, 0, 255), math.clamp(themeList.SchemeColor.B * 255 - 13, 0, 255))
                moreInfo.Position = UDim2.new(0, 0, 2, 0)
                moreInfo.Size = UDim2.new(0, 353, 0, 33)
                moreInfo.ZIndex = 9
                moreInfo.Font = Enum.Font.FredokaOne
                moreInfo.RichText = true
                moreInfo.Text = "  " .. slidTip
                moreInfo.TextColor3 = themeList.TextColor
                moreInfo.TextSize = 14
                moreInfo.TextXAlignment = Enum.TextXAlignment.Left
                
                moreInfoCorner.CornerRadius = UDim.new(0, 4)
                moreInfoCorner.Parent = moreInfo
                
                updateSectionFrame()
                UpdateSize()
                
                local function updateSlider(inpObj)
                    if not sliderDrag or not sliderDrag.Parent then return end
                    if not sliderBtn or not sliderBtn.Parent then return end
                    local mouseX = inpObj.Position.X
                    local btnPos = sliderBtn.AbsolutePosition.X
                    local btnWidth = sliderBtn.AbsoluteSize.X
                    if btnWidth <= 0 then return end
                    local newPos = math.clamp(mouseX - btnPos, 0, btnWidth)
                    local percent = newPos / btnWidth
                    local value = math.floor(minvalue + (maxvalue - minvalue) * percent)
                    value = math.clamp(value, minvalue, maxvalue)
                    
                    sliderDrag.Size = UDim2.new(percent, 0, 1, 0)
                    val.Text = tostring(value)
                    currentValue = value
                    safeCall(callback, value)
                end
                
                local sliderDownConn = sliderBtn.InputBegan:Connect(function(inpObj)
                    if inpObj.UserInputType == Enum.UserInputType.MouseButton1 or inpObj.UserInputType == Enum.UserInputType.Touch then
                        if focusing then
                            for _, v in pairs(infoContainer:GetChildren()) do
                                if v and v.Parent then Utility:TweenObject(v, {Position = UDim2.new(0, 0, 2, 0)}, 0.2) end
                            end
                            focusing = false
                            if blurFrame and blurFrame.Parent then Utility:TweenObject(blurFrame, {BackgroundTransparency = 1}, 0.2) end
                            return
                        end
                        isDragging = true
                        val.TextTransparency = 0
                        updateSlider(inpObj)
                    end
                end)
                AddConnection(sliderDownConn)
                
                moveConn = uis.InputChanged:Connect(function(inpObj)
                    if isDragging and (inpObj.UserInputType == Enum.UserInputType.MouseMovement or inpObj.UserInputType == Enum.UserInputType.Touch) then
                        updateSlider(inpObj)
                    end
                end)
                AddConnection(moveConn)
                
                releaseConn = uis.InputEnded:Connect(function(inpObj)
                    if (inpObj.UserInputType == Enum.UserInputType.MouseButton1 or inpObj.UserInputType == Enum.UserInputType.Touch) and isDragging then
                        isDragging = false
                        val.TextTransparency = 1
                    end
                end)
                AddConnection(releaseConn)
                
                local isHovering = false
                
                local enterConn = sliderElement.MouseEnter:Connect(function()
                    if not focusing and sliderElement and sliderElement.Parent then
                        local twe = tween:Create(sliderElement, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(math.clamp(themeList.ElementColor.R * 255 + 8, 0, 255), math.clamp(themeList.ElementColor.G * 255 + 9, 0, 255), math.clamp(themeList.ElementColor.B * 255 + 10, 0, 255))})
                        twe:Play()
                        isHovering = true
                    end
                end)
                AddConnection(enterConn)
                
                local leaveConn = sliderElement.MouseLeave:Connect(function()
                    if not focusing and sliderElement and sliderElement.Parent then
                        local twe = tween:Create(sliderElement, TweenInfo.new(0.1), {BackgroundColor3 = themeList.ElementColor})
                        twe:Play()
                        isHovering = false
                    end
                end)
                AddConnection(leaveConn)
                
                local viewConn = viewInfo.MouseButton1Click:Connect(function()
                    if not viewDe then
                        viewDe = true
                        focusing = true
                        for _, v in pairs(infoContainer:GetChildren()) do
                            if v and v ~= moreInfo and v.Parent then Utility:TweenObject(v, {Position = UDim2.new(0, 0, 2, 0)}, 0.2) end
                        end
                        if moreInfo and moreInfo.Parent then Utility:TweenObject(moreInfo, {Position = UDim2.new(0, 0, 0, 0)}, 0.2) end
                        if blurFrame and blurFrame.Parent then Utility:TweenObject(blurFrame, {BackgroundTransparency = 0.5}, 0.2) end
                        if sliderElement and sliderElement.Parent then Utility:TweenObject(sliderElement, {BackgroundColor3 = themeList.ElementColor}, 0.2) end
                        task.wait(1.5)
                        focusing = false
                        if moreInfo and moreInfo.Parent then Utility:TweenObject(moreInfo, {Position = UDim2.new(0, 0, 2, 0)}, 0.2) end
                        if blurFrame and blurFrame.Parent then Utility:TweenObject(blurFrame, {BackgroundTransparency = 1}, 0.2) end
                        viewDe = false
                    end
                end)
                AddConnection(viewConn)
                
                local function UpdateSliderTheme()
                    if not sliderElement or not sliderElement.Parent then return end
                    if not isHovering then sliderElement.BackgroundColor3 = themeList.ElementColor end
                    if moreInfo then
                        moreInfo.TextColor3 = themeList.TextColor
                        moreInfo.BackgroundColor3 = Color3.fromRGB(math.clamp(themeList.SchemeColor.R * 255 - 14, 0, 255), math.clamp(themeList.SchemeColor.G * 255 - 17, 0, 255), math.clamp(themeList.SchemeColor.B * 255 - 13, 0, 255))
                    end
                    if val then val.TextColor3 = themeList.TextColor end
                    if write then write.ImageColor3 = themeList.SchemeColor end
                    if togName then togName.TextColor3 = themeList.TextColor end
                    if viewInfo then viewInfo.ImageColor3 = themeList.SchemeColor end
                    if sliderBtn then 
                        sliderBtn.BackgroundColor3 = Color3.fromRGB(math.clamp(themeList.ElementColor.R * 255 + 5, 0, 255), math.clamp(themeList.ElementColor.G * 255 + 5, 0, 255), math.clamp(themeList.ElementColor.B * 255 + 5, 0, 255))
                    end
                    if sliderDrag then sliderDrag.BackgroundColor3 = themeList.SchemeColor end
                end
                
                local themeConn = ThemeEvent.Event:Connect(UpdateSliderTheme)
                AddConnection(themeConn)
                UpdateSliderTheme()
                
                local SliderFunction = {}
                function SliderFunction:SetValue(value)
                    value = math.clamp(value, minvalue, maxvalue)
                    currentValue = value
                    local percent = (value - minvalue) / (maxvalue - minvalue)
                    sliderDrag.Size = UDim2.new(percent, 0, 1, 0)
                    val.Text = tostring(value)
                    safeCall(callback, value)
                end
                return SliderFunction
            end
            
            function Elements:NewDropdown(dropname, dropinf, list, callback)
                local DropFunction = {}
                dropname = dropname or "Dropdown"
                list = list or {}
                dropinf = dropinf or "Dropdown info"
                callback = callback or function() end
                
                local opened = false
                
                local dropFrame = Instance.new("Frame")
                local dropOpen = Instance.new("TextButton")
                local listImg = Instance.new("ImageLabel")
                local itemTextbox = Instance.new("TextLabel")
                local viewInfo = Instance.new("ImageButton")
                local UICorner = Instance.new("UICorner")
                local UIListLayout = Instance.new("UIListLayout")
                local Sample = Instance.new("ImageLabel")
                
                local ms = game.Players.LocalPlayer:GetMouse()
                Sample.Name = "Sample"
                Sample.Parent = dropOpen
                Sample.BackgroundTransparency = 1
                Sample.Image = "rbxassetid://4560909609"
                Sample.ImageColor3 = themeList.SchemeColor
                Sample.ImageTransparency = 0.6
                
                dropFrame.Name = "dropFrame"
                dropFrame.Parent = sectionInners
                dropFrame.BackgroundColor3 = themeList.Background
                dropFrame.BorderSizePixel = 0
                dropFrame.Position = UDim2.new(0, 0, 1.2357, 0)
                dropFrame.Size = UDim2.new(0, 352, 0, 33)
                dropFrame.ClipsDescendants = true
                
                local sample = Sample
                local btn = dropOpen
                
                dropOpen.Name = "dropOpen"
                dropOpen.Parent = dropFrame
                dropOpen.BackgroundColor3 = themeList.ElementColor
                dropOpen.Size = UDim2.new(0, 352, 0, 33)
                dropOpen.AutoButtonColor = false
                dropOpen.Font = Enum.Font.FredokaOne
                dropOpen.Text = ""
                dropOpen.TextColor3 = Color3.fromRGB(0, 0, 0)
                dropOpen.TextSize = 14
                dropOpen.ClipsDescendants = true
                
                local dropClickConn = dropOpen.MouseButton1Click:Connect(function()
                    if not focusing then
                        if opened then
                            opened = false
                            dropFrame:TweenSize(UDim2.new(0, 352, 0, 33), "InOut", "Linear", 0.08)
                            task.wait(0.1)
                            updateSectionFrame()
                            UpdateSize()
                            if btn and btn.Parent then
                                local c = sample:Clone()
                                c.Parent = btn
                                local success, x, y = pcall(function() 
                                    return ms.X - c.AbsolutePosition.X, ms.Y - c.AbsolutePosition.Y 
                                end)
                                if success then c.Position = UDim2.new(0, x, 0, y) end
                                local size = btn.AbsoluteSize.X >= btn.AbsoluteSize.Y and (btn.AbsoluteSize.X * 1.5) or (btn.AbsoluteSize.Y * 1.5)
                                c:TweenSizeAndPosition(UDim2.new(0, size, 0, size), UDim2.new(0.5, -size/2, 0.5, -size/2), 'Out', 'Quad', 0.35, true, nil)
                                for i = 1, 10 do
                                    c.ImageTransparency = c.ImageTransparency + 0.05
                                    task.wait(0.35 / 12)
                                end
                                c:Destroy()
                            end
                        else
                            opened = true
                            local contentSize = UIListLayout.AbsoluteContentSize
                            dropFrame:TweenSize(UDim2.new(0, 352, 0, contentSize.Y), "InOut", "Linear", 0.08, true)
                            task.wait(0.1)
                            updateSectionFrame()
                            UpdateSize()
                            if btn and btn.Parent then
                                local c = sample:Clone()
                                c.Parent = btn
                                local success, x, y = pcall(function() 
                                    return ms.X - c.AbsolutePosition.X, ms.Y - c.AbsolutePosition.Y 
                                end)
                                if success then c.Position = UDim2.new(0, x, 0, y) end
                                local size = btn.AbsoluteSize.X >= btn.AbsoluteSize.Y and (btn.AbsoluteSize.X * 1.5) or (btn.AbsoluteSize.Y * 1.5)
                                c:TweenSizeAndPosition(UDim2.new(0, size, 0, size), UDim2.new(0.5, -size/2, 0.5, -size/2), 'Out', 'Quad', 0.35, true, nil)
                                for i = 1, 10 do
                                    c.ImageTransparency = c.ImageTransparency + 0.05
                                    task.wait(0.35 / 12)
                                end
                                c:Destroy()
                            end
                        end
                    else
                        for _, v in pairs(infoContainer:GetChildren()) do
                            if v and v.Parent then Utility:TweenObject(v, {Position = UDim2.new(0, 0, 2, 0)}, 0.2) end
                            focusing = false
                        end
                        if blurFrame and blurFrame.Parent then Utility:TweenObject(blurFrame, {BackgroundTransparency = 1}, 0.2) end
                    end
                end)
                AddConnection(dropClickConn)
                
                listImg.Name = "listImg"
                listImg.Parent = dropOpen
                listImg.BackgroundTransparency = 1
                listImg.Position = UDim2.new(0.02, 0, 0.18, 0)
                listImg.Size = UDim2.new(0, 21, 0, 21)
                listImg.Image = "rbxassetid://3926305904"
                listImg.ImageColor3 = themeList.SchemeColor
                listImg.ImageRectOffset = Vector2.new(644, 364)
                listImg.ImageRectSize = Vector2.new(36, 36)
                
                itemTextbox.Name = "itemTextbox"
                itemTextbox.Parent = dropOpen
                itemTextbox.BackgroundTransparency = 1
                itemTextbox.Position = UDim2.new(0.097, 0, 0.273, 0)
                itemTextbox.Size = UDim2.new(0, 138, 0, 14)
                itemTextbox.Font = Enum.Font.FredokaOne
                itemTextbox.Text = dropname
                itemTextbox.RichText = true
                itemTextbox.TextColor3 = themeList.TextColor
                itemTextbox.TextSize = 14
                itemTextbox.TextXAlignment = Enum.TextXAlignment.Left
                
                viewInfo.Name = "viewInfo"
                viewInfo.Parent = dropOpen
                viewInfo.BackgroundTransparency = 1
                viewInfo.Position = UDim2.new(0.93, 0, 0.152, 0)
                viewInfo.Size = UDim2.new(0, 23, 0, 23)
                viewInfo.Image = "rbxassetid://3926305904"
                viewInfo.ImageColor3 = themeList.SchemeColor
                viewInfo.ImageRectOffset = Vector2.new(764, 764)
                viewInfo.ImageRectSize = Vector2.new(36, 36)
                
                UICorner.CornerRadius = UDim.new(0, 4)
                UICorner.Parent = dropOpen
                
                UIListLayout.Parent = dropFrame
                UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
                UIListLayout.Padding = UDim.new(0, 3)
                
                updateSectionFrame()
                UpdateSize()
                
                local moreInfo = Instance.new("TextLabel")
                local moreInfoCorner = Instance.new("UICorner")
                
                moreInfo.Name = "TipMore"
                moreInfo.Parent = infoContainer
                moreInfo.BackgroundColor3 = Color3.fromRGB(math.clamp(themeList.SchemeColor.R * 255 - 14, 0, 255), math.clamp(themeList.SchemeColor.G * 255 - 17, 0, 255), math.clamp(themeList.SchemeColor.B * 255 - 13, 0, 255))
                moreInfo.Position = UDim2.new(0, 0, 2, 0)
                moreInfo.Size = UDim2.new(0, 353, 0, 33)
                moreInfo.ZIndex = 9
                moreInfo.Font = Enum.Font.FredokaOne
                moreInfo.Text = "  " .. dropinf
                moreInfo.TextColor3 = themeList.TextColor
                moreInfo.TextSize = 14
                moreInfo.TextXAlignment = Enum.TextXAlignment.Left
                
                moreInfoCorner.CornerRadius = UDim.new(0, 4)
                moreInfoCorner.Parent = moreInfo
                
                local isHovering = false
                
                local enterConn = dropOpen.MouseEnter:Connect(function()
                    if not focusing and dropOpen and dropOpen.Parent then
                        local twe = tween:Create(dropOpen, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(math.clamp(themeList.ElementColor.R * 255 + 8, 0, 255), math.clamp(themeList.ElementColor.G * 255 + 9, 0, 255), math.clamp(themeList.ElementColor.B * 255 + 10, 0, 255))})
                        twe:Play()
                        isHovering = true
                    end
                end)
                AddConnection(enterConn)
                
                local leaveConn = dropOpen.MouseLeave:Connect(function()
                    if not focusing and dropOpen and dropOpen.Parent then
                        local twe = tween:Create(dropOpen, TweenInfo.new(0.1), {BackgroundColor3 = themeList.ElementColor})
                        twe:Play()
                        isHovering = false
                    end
                end)
                AddConnection(leaveConn)
                
                local viewConn = viewInfo.MouseButton1Click:Connect(function()
                    if not viewDe then
                        viewDe = true
                        focusing = true
                        for _, v in pairs(infoContainer:GetChildren()) do
                            if v and v ~= moreInfo and v.Parent then Utility:TweenObject(v, {Position = UDim2.new(0, 0, 2, 0)}, 0.2) end
                        end
                        if moreInfo and moreInfo.Parent then Utility:TweenObject(moreInfo, {Position = UDim2.new(0, 0, 0, 0)}, 0.2) end
                        if blurFrame and blurFrame.Parent then Utility:TweenObject(blurFrame, {BackgroundTransparency = 0.5}, 0.2) end
                        if dropOpen and dropOpen.Parent then Utility:TweenObject(dropOpen, {BackgroundColor3 = themeList.ElementColor}, 0.2) end
                        task.wait(1.5)
                        focusing = false
                        if moreInfo and moreInfo.Parent then Utility:TweenObject(moreInfo, {Position = UDim2.new(0, 0, 2, 0)}, 0.2) end
                        if blurFrame and blurFrame.Parent then Utility:TweenObject(blurFrame, {BackgroundTransparency = 1}, 0.2) end
                        viewDe = false
                    end
                end)
                AddConnection(viewConn)
                
                local function UpdateDropdownTheme()
                    if not dropOpen or not dropOpen.Parent then return end
                    if not isHovering then dropOpen.BackgroundColor3 = themeList.ElementColor end
                    if Sample then Sample.ImageColor3 = themeList.SchemeColor end
                    if dropFrame then dropFrame.BackgroundColor3 = themeList.Background end
                    if listImg then listImg.ImageColor3 = themeList.SchemeColor end
                    if itemTextbox then itemTextbox.TextColor3 = themeList.TextColor end
                    if viewInfo then viewInfo.ImageColor3 = themeList.SchemeColor end
                    if moreInfo then
                        moreInfo.BackgroundColor3 = Color3.fromRGB(math.clamp(themeList.SchemeColor.R * 255 - 14, 0, 255), math.clamp(themeList.SchemeColor.G * 255 - 17, 0, 255), math.clamp(themeList.SchemeColor.B * 255 - 13, 0, 255))
                        moreInfo.TextColor3 = themeList.TextColor
                    end
                end
                
                local themeConn = ThemeEvent.Event:Connect(UpdateDropdownTheme)
                AddConnection(themeConn)
                UpdateDropdownTheme()
                
                for i, v in ipairs(list) do
                    local optionSelect = Instance.new("TextButton")
                    local optionCorner = Instance.new("UICorner")
                    local Sample1 = Instance.new("ImageLabel")
                    
                    Sample1.Name = "Sample1"
                    Sample1.Parent = optionSelect
                    Sample1.BackgroundTransparency = 1
                    Sample1.Image = "rbxassetid://4560909609"
                    Sample1.ImageColor3 = themeList.SchemeColor
                    Sample1.ImageTransparency = 0.6
                    
                    local sample1 = Sample1
                    optionSelect.Name = "optionSelect"
                    optionSelect.Parent = dropFrame
                    optionSelect.BackgroundColor3 = themeList.ElementColor
                    optionSelect.Position = UDim2.new(0, 0, 0.2353, 0)
                    optionSelect.Size = UDim2.new(0, 352, 0, 33)
                    optionSelect.AutoButtonColor = false
                    optionSelect.Font = Enum.Font.FredokaOne
                    optionSelect.Text = "  " .. v
                    optionSelect.TextColor3 = Color3.fromRGB(math.clamp(themeList.TextColor.R * 255 - 6, 0, 255), math.clamp(themeList.TextColor.G * 255 - 6, 0, 255), math.clamp(themeList.TextColor.B * 255 - 6, 0, 255))
                    optionSelect.TextSize = 14
                    optionSelect.TextXAlignment = Enum.TextXAlignment.Left
                    optionSelect.ClipsDescendants = true
                    
                    local optionClickConn = optionSelect.MouseButton1Click:Connect(function()
                        if not focusing then
                            opened = false
                            safeCall(callback, v)
                            itemTextbox.Text = v
                            dropFrame:TweenSize(UDim2.new(0, 352, 0, 33), 'InOut', 'Linear', 0.08)
                            task.wait(0.1)
                            updateSectionFrame()
                            UpdateSize()
                            if optionSelect and optionSelect.Parent then
                                local c = sample1:Clone()
                                c.Parent = optionSelect
                                local success, x, y = pcall(function() 
                                    return ms.X - c.AbsolutePosition.X, ms.Y - c.AbsolutePosition.Y 
                                end)
                                if success then c.Position = UDim2.new(0, x, 0, y) end
                                local size = optionSelect.AbsoluteSize.X >= optionSelect.AbsoluteSize.Y and (optionSelect.AbsoluteSize.X * 1.5) or (optionSelect.AbsoluteSize.Y * 1.5)
                                c:TweenSizeAndPosition(UDim2.new(0, size, 0, size), UDim2.new(0.5, -size/2, 0.5, -size/2), 'Out', 'Quad', 0.35, true, nil)
                                for i = 1, 10 do
                                    c.ImageTransparency = c.ImageTransparency + 0.05
                                    task.wait(0.35 / 12)
                                end
                                c:Destroy()
                            end
                        else
                            for _, v in pairs(infoContainer:GetChildren()) do
                                if v and v.Parent then Utility:TweenObject(v, {Position = UDim2.new(0, 0, 2, 0)}, 0.2) end
                                focusing = false
                            end
                            if blurFrame and blurFrame.Parent then Utility:TweenObject(blurFrame, {BackgroundTransparency = 1}, 0.2) end
                        end
                    end)
                    AddConnection(optionClickConn)
                    
                    optionCorner.CornerRadius = UDim.new(0, 4)
                    optionCorner.Parent = optionSelect
                    
                    local optHover = false
                    local optEnterConn = optionSelect.MouseEnter:Connect(function()
                        if not focusing and optionSelect and optionSelect.Parent then
                            local twe = tween:Create(optionSelect, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(math.clamp(themeList.ElementColor.R * 255 + 8, 0, 255), math.clamp(themeList.ElementColor.G * 255 + 9, 0, 255), math.clamp(themeList.ElementColor.B * 255 + 10, 0, 255))})
                            twe:Play()
                            optHover = true
                        end
                    end)
                    AddConnection(optEnterConn)
                    
                    local optLeaveConn = optionSelect.MouseLeave:Connect(function()
                        if not focusing and optionSelect and optionSelect.Parent then
                            local twe = tween:Create(optionSelect, TweenInfo.new(0.1), {BackgroundColor3 = themeList.ElementColor})
                            twe:Play()
                            optHover = false
                        end
                    end)
                    AddConnection(optLeaveConn)
                    
                    local function UpdateOptionTheme()
                        if not optionSelect or not optionSelect.Parent then return end
                        if not optHover then optionSelect.BackgroundColor3 = themeList.ElementColor end
                        optionSelect.TextColor3 = Color3.fromRGB(math.clamp(themeList.TextColor.R * 255 - 6, 0, 255), math.clamp(themeList.TextColor.G * 255 - 6, 0, 255), math.clamp(themeList.TextColor.B * 255 - 6, 0, 255))
                        if Sample1 then Sample1.ImageColor3 = themeList.SchemeColor end
                    end
                    
                    local themeConn = ThemeEvent.Event:Connect(UpdateOptionTheme)
                    AddConnection(themeConn)
                    UpdateOptionTheme()
                end
                
                function DropFunction:Refresh(newList)
                    newList = newList or {}
                    for i, v in pairs(dropFrame:GetChildren()) do
                        if v.Name == "optionSelect" then v:Destroy() end
                    end
                    for i, v in ipairs(newList) do
                        local optionSelect = Instance.new("TextButton")
                        local optionCorner = Instance.new("UICorner")
                        local Sample11 = Instance.new("ImageLabel")
                        
                        Sample11.Name = "Sample11"
                        Sample11.Parent = optionSelect
                        Sample11.BackgroundTransparency = 1
                        Sample11.Image = "rbxassetid://4560909609"
                        Sample11.ImageColor3 = themeList.SchemeColor
                        Sample11.ImageTransparency = 0.6
                        
                        local sample11 = Sample11
                        optionSelect.Name = "optionSelect"
                        optionSelect.Parent = dropFrame
                        optionSelect.BackgroundColor3 = themeList.ElementColor
                        optionSelect.Position = UDim2.new(0, 0, 0.2353, 0)
                        optionSelect.Size = UDim2.new(0, 352, 0, 33)
                        optionSelect.AutoButtonColor = false
                        optionSelect.Font = Enum.Font.FredokaOne
                        optionSelect.Text = "  " .. v
                        optionSelect.TextColor3 = Color3.fromRGB(math.clamp(themeList.TextColor.R * 255 - 6, 0, 255), math.clamp(themeList.TextColor.G * 255 - 6, 0, 255), math.clamp(themeList.TextColor.B * 255 - 6, 0, 255))
                        optionSelect.TextSize = 14
                        optionSelect.TextXAlignment = Enum.TextXAlignment.Left
                        optionSelect.ClipsDescendants = true
                        optionCorner.CornerRadius = UDim.new(0, 4)
                        optionCorner.Parent = optionSelect
                        
                        local optClickConn = optionSelect.MouseButton1Click:Connect(function()
                            if not focusing then
                                opened = false
                                safeCall(callback, v)
                                itemTextbox.Text = v
                                dropFrame:TweenSize(UDim2.new(0, 352, 0, 33), 'InOut', 'Linear', 0.08)
                                task.wait(0.1)
                                updateSectionFrame()
                                UpdateSize()
                                if optionSelect and optionSelect.Parent then
                                    local c = sample11:Clone()
                                    c.Parent = optionSelect
                                    local success, x, y = pcall(function() 
                                        return ms.X - c.AbsolutePosition.X, ms.Y - c.AbsolutePosition.Y 
                                    end)
                                    if success then c.Position = UDim2.new(0, x, 0, y) end
                                    local size = optionSelect.AbsoluteSize.X >= optionSelect.AbsoluteSize.Y and (optionSelect.AbsoluteSize.X * 1.5) or (optionSelect.AbsoluteSize.Y * 1.5)
                                    c:TweenSizeAndPosition(UDim2.new(0, size, 0, size), UDim2.new(0.5, -size/2, 0.5, -size/2), 'Out', 'Quad', 0.35, true, nil)
                                    for i = 1, 10 do
                                        c.ImageTransparency = c.ImageTransparency + 0.05
                                        task.wait(0.35 / 12)
                                    end
                                    c:Destroy()
                                end
                            else
                                for _, v in pairs(infoContainer:GetChildren()) do
                                    if v and v.Parent then Utility:TweenObject(v, {Position = UDim2.new(0, 0, 2, 0)}, 0.2) end
                                    focusing = false
                                end
                                if blurFrame and blurFrame.Parent then Utility:TweenObject(blurFrame, {BackgroundTransparency = 1}, 0.2) end
                            end
                        end)
                        AddConnection(optClickConn)
                        
                        local optHover = false
                        local optEnterConn = optionSelect.MouseEnter:Connect(function()
                            if not focusing and optionSelect and optionSelect.Parent then
                                local twe = tween:Create(optionSelect, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(math.clamp(themeList.ElementColor.R * 255 + 8, 0, 255), math.clamp(themeList.ElementColor.G * 255 + 9, 0, 255), math.clamp(themeList.ElementColor.B * 255 + 10, 0, 255))})
                                twe:Play()
                                optHover = true
                            end
                        end)
                        AddConnection(optEnterConn)
                        
                        local optLeaveConn = optionSelect.MouseLeave:Connect(function()
                            if not focusing and optionSelect and optionSelect.Parent then
                                local twe = tween:Create(optionSelect, TweenInfo.new(0.1), {BackgroundColor3 = themeList.ElementColor})
                                twe:Play()
                                optHover = false
                            end
                        end)
                        AddConnection(optLeaveConn)
                        
                        local function UpdateOptionTheme()
                            if not optionSelect or not optionSelect.Parent then return end
                            if not optHover then optionSelect.BackgroundColor3 = themeList.ElementColor end
                            optionSelect.TextColor3 = Color3.fromRGB(math.clamp(themeList.TextColor.R * 255 - 6, 0, 255), math.clamp(themeList.TextColor.G * 255 - 6, 0, 255), math.clamp(themeList.TextColor.B * 255 - 6, 0, 255))
                            if Sample11 then Sample11.ImageColor3 = themeList.SchemeColor end
                        end
                        
                        local themeConn = ThemeEvent.Event:Connect(UpdateOptionTheme)
                        AddConnection(themeConn)
                        UpdateOptionTheme()
                    end
                    if opened then
                        local contentSize = UIListLayout.AbsoluteContentSize
                        dropFrame:TweenSize(UDim2.new(0, 352, 0, contentSize.Y), "InOut", "Linear", 0.08, true)
                        task.wait(0.1)
                        updateSectionFrame()
                        UpdateSize()
                    else
                        dropFrame:TweenSize(UDim2.new(0, 352, 0, 33), "InOut", "Linear", 0.08)
                        task.wait(0.1)
                        updateSectionFrame()
                        UpdateSize()
                    end
                end
                return DropFunction
            end
            
            function Elements:NewKeybind(keytext, keyinf, first, callback)
                keytext = keytext or "KeybindText"
                keyinf = keyinf or "Keybind info"
                callback = callback or function() end
                local oldKey = first.Name
                
                local keybindElement = Instance.new("TextButton")
                local UICorner = Instance.new("UICorner")
                local togName = Instance.new("TextLabel")
                local viewInfo = Instance.new("ImageButton")
                local touch = Instance.new("ImageLabel")
                local Sample = Instance.new("ImageLabel")
                local togName_2 = Instance.new("TextLabel")
                
                local ms = game.Players.LocalPlayer:GetMouse()
                local uis = game:GetService("UserInputService")
                local waitingForKey = false
                
                local moreInfo = Instance.new("TextLabel")
                local moreInfoCorner = Instance.new("UICorner")
                
                local sample = Sample
                
                keybindElement.Name = "keybindElement"
                keybindElement.Parent = sectionInners
                keybindElement.BackgroundColor3 = themeList.ElementColor
                keybindElement.ClipsDescendants = true
                keybindElement.Size = UDim2.new(0, 352, 0, 33)
                keybindElement.AutoButtonColor = false
                keybindElement.Font = Enum.Font.FredokaOne
                keybindElement.Text = ""
                keybindElement.TextColor3 = Color3.fromRGB(0, 0, 0)
                keybindElement.TextSize = 14
                
                local keybindClickConn = keybindElement.MouseButton1Click:Connect(function()
                    if not focusing then
                        waitingForKey = true
                        togName_2.Text = ". . ."
                        local keyPressed
                        local function onInputBegan(input, processed)
                            if not processed and waitingForKey then
                                if input.KeyCode ~= Enum.KeyCode.Unknown then
                                    keyPressed = input.KeyCode.Name
                                    oldKey = input.KeyCode.Name
                                    togName_2.Text = oldKey
                                    waitingForKey = false
                                end
                            end
                        end
                        local inputConn = uis.InputBegan:Connect(onInputBegan)
                        AddConnection(inputConn)
                        task.wait(0.1)
                        local startTime = tick()
                        repeat task.wait() until not waitingForKey or tick() - startTime > 10
                        waitingForKey = false
                        if not keyPressed then
                            togName_2.Text = oldKey
                        end
                        if keybindElement and keybindElement.Parent then
                            local c = sample:Clone()
                            c.Parent = keybindElement
                            local success, x, y = pcall(function() 
                                return ms.X - c.AbsolutePosition.X, ms.Y - c.AbsolutePosition.Y 
                            end)
                            if success then c.Position = UDim2.new(0, x, 0, y) end
                            local size = keybindElement.AbsoluteSize.X >= keybindElement.AbsoluteSize.Y and (keybindElement.AbsoluteSize.X * 1.5) or (keybindElement.AbsoluteSize.Y * 1.5)
                            c:TweenSizeAndPosition(UDim2.new(0, size, 0, size), UDim2.new(0.5, -size/2, 0.5, -size/2), 'Out', 'Quad', 0.35, true, nil)
                            for i = 1, 10 do
                                c.ImageTransparency = c.ImageTransparency + 0.05
                                task.wait(0.35 / 12)
                            end
                            c:Destroy()
                        end
                    else
                        for _, v in pairs(infoContainer:GetChildren()) do
                            if v and v.Parent then Utility:TweenObject(v, {Position = UDim2.new(0, 0, 2, 0)}, 0.2) end
                            focusing = false
                        end
                        if blurFrame and blurFrame.Parent then Utility:TweenObject(blurFrame, {BackgroundTransparency = 1}, 0.2) end
                    end
                end)
                AddConnection(keybindClickConn)
                
                local inputBeganConn = uis.InputBegan:Connect(function(current, processed)
                    if not processed and not focusing and not waitingForKey then
                        if current.KeyCode.Name == oldKey then 
                            safeCall(callback)
                        end
                    end
                end)
                AddConnection(inputBeganConn)
                
                moreInfo.Name = "TipMore"
                moreInfo.Parent = infoContainer
                moreInfo.BackgroundColor3 = Color3.fromRGB(math.clamp(themeList.SchemeColor.R * 255 - 14, 0, 255), math.clamp(themeList.SchemeColor.G * 255 - 17, 0, 255), math.clamp(themeList.SchemeColor.B * 255 - 13, 0, 255))
                moreInfo.Position = UDim2.new(0, 0, 2, 0)
                moreInfo.Size = UDim2.new(0, 353, 0, 33)
                moreInfo.ZIndex = 9
                moreInfo.Font = Enum.Font.FredokaOne
                moreInfo.Text = "  " .. keyinf
                moreInfo.TextColor3 = themeList.TextColor
                moreInfo.TextSize = 14
                moreInfo.TextXAlignment = Enum.TextXAlignment.Left
                
                moreInfoCorner.CornerRadius = UDim.new(0, 4)
                moreInfoCorner.Parent = moreInfo
                
                Sample.Name = "Sample"
                Sample.Parent = keybindElement
                Sample.BackgroundTransparency = 1
                Sample.Image = "rbxassetid://4560909609"
                Sample.ImageColor3 = themeList.SchemeColor
                Sample.ImageTransparency = 0.6
                
                togName.Name = "togName"
                togName.Parent = keybindElement
                togName.BackgroundTransparency = 1
                togName.Position = UDim2.new(0.0967, 0, 0.2727, 0)
                togName.Size = UDim2.new(0, 222, 0, 14)
                togName.Font = Enum.Font.FredokaOne
                togName.Text = keytext
                togName.RichText = true
                togName.TextColor3 = themeList.TextColor
                togName.TextSize = 14
                togName.TextXAlignment = Enum.TextXAlignment.Left
                
                viewInfo.Name = "viewInfo"
                viewInfo.Parent = keybindElement
                viewInfo.BackgroundTransparency = 1
                viewInfo.Position = UDim2.new(0.93, 0, 0.152, 0)
                viewInfo.Size = UDim2.new(0, 23, 0, 23)
                viewInfo.Image = "rbxassetid://3926305904"
                viewInfo.ImageColor3 = themeList.SchemeColor
                viewInfo.ImageRectOffset = Vector2.new(764, 764)
                viewInfo.ImageRectSize = Vector2.new(36, 36)
                
                local viewConn = viewInfo.MouseButton1Click:Connect(function()
                    if not viewDe then
                        viewDe = true
                        focusing = true
                        for _, v in pairs(infoContainer:GetChildren()) do
                            if v and v ~= moreInfo and v.Parent then Utility:TweenObject(v, {Position = UDim2.new(0, 0, 2, 0)}, 0.2) end
                        end
                        if moreInfo and moreInfo.Parent then Utility:TweenObject(moreInfo, {Position = UDim2.new(0, 0, 0, 0)}, 0.2) end
                        if blurFrame and blurFrame.Parent then Utility:TweenObject(blurFrame, {BackgroundTransparency = 0.5}, 0.2) end
                        if keybindElement and keybindElement.Parent then Utility:TweenObject(keybindElement, {BackgroundColor3 = themeList.ElementColor}, 0.2) end
                        task.wait(1.5)
                        focusing = false
                        if moreInfo and moreInfo.Parent then Utility:TweenObject(moreInfo, {Position = UDim2.new(0, 0, 2, 0)}, 0.2) end
                        if blurFrame and blurFrame.Parent then Utility:TweenObject(blurFrame, {BackgroundTransparency = 1}, 0.2) end
                        viewDe = false
                    end
                end)
                AddConnection(viewConn)
                
                updateSectionFrame()
                UpdateSize()
                
                local isHovering = false
                
                local enterConn = keybindElement.MouseEnter:Connect(function()
                    if not focusing and keybindElement and keybindElement.Parent then
                        local twe = tween:Create(keybindElement, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(math.clamp(themeList.ElementColor.R * 255 + 8, 0, 255), math.clamp(themeList.ElementColor.G * 255 + 9, 0, 255), math.clamp(themeList.ElementColor.B * 255 + 10, 0, 255))})
                        twe:Play()
                        isHovering = true
                    end
                end)
                AddConnection(enterConn)
                
                local leaveConn = keybindElement.MouseLeave:Connect(function()
                    if not focusing and keybindElement and keybindElement.Parent then
                        local twe = tween:Create(keybindElement, TweenInfo.new(0.1), {BackgroundColor3 = themeList.ElementColor})
                        twe:Play()
                        isHovering = false
                    end
                end)
                AddConnection(leaveConn)
                
                UICorner.CornerRadius = UDim.new(0, 4)
                UICorner.Parent = keybindElement
                
                touch.Name = "touch"
                touch.Parent = keybindElement
                touch.BackgroundTransparency = 1
                touch.Position = UDim2.new(0.02, 0, 0.18, 0)
                touch.Size = UDim2.new(0, 21, 0, 21)
                touch.Image = "rbxassetid://3926305904"
                touch.ImageColor3 = themeList.SchemeColor
                touch.ImageRectOffset = Vector2.new(364, 284)
                touch.ImageRectSize = Vector2.new(36, 36)
                
                togName_2.Name = "togName"
                togName_2.Parent = keybindElement
                togName_2.BackgroundTransparency = 1
                togName_2.Position = UDim2.new(0.72739, 0, 0.27273, 0)
                togName_2.Size = UDim2.new(0, 70, 0, 14)
                togName_2.Font = Enum.Font.FredokaOne
                togName_2.Text = oldKey
                togName_2.TextColor3 = themeList.SchemeColor
                togName_2.TextSize = 14
                togName_2.TextXAlignment = Enum.TextXAlignment.Right
                
                local function UpdateKeybindTheme()
                    if not keybindElement or not keybindElement.Parent then return end
                    if not isHovering then keybindElement.BackgroundColor3 = themeList.ElementColor end
                    if togName_2 then togName_2.TextColor3 = themeList.SchemeColor end
                    if touch then touch.ImageColor3 = themeList.SchemeColor end
                    if viewInfo then viewInfo.ImageColor3 = themeList.SchemeColor end
                    if togName then togName.TextColor3 = themeList.TextColor end
                    if Sample then Sample.ImageColor3 = themeList.SchemeColor end
                    if moreInfo then
                        moreInfo.TextColor3 = themeList.TextColor
                        moreInfo.BackgroundColor3 = Color3.fromRGB(math.clamp(themeList.SchemeColor.R * 255 - 14, 0, 255), math.clamp(themeList.SchemeColor.G * 255 - 17, 0, 255), math.clamp(themeList.SchemeColor.B * 255 - 13, 0, 255))
                    end
                end
                
                local themeConn = ThemeEvent.Event:Connect(UpdateKeybindTheme)
                AddConnection(themeConn)
                UpdateKeybindTheme()
                
                local KeybindFunction = {}
                function KeybindFunction:SetKey(newKey)
                    oldKey = newKey
                    togName_2.Text = newKey
                end
                return KeybindFunction
            end
            
            function Elements:NewColorPicker(colText, colInf, defcolor, callback)
                colText = colText or "ColorPicker"
                callback = callback or function() end
                defcolor = defcolor or Color3.fromRGB(255, 255, 255)
                local h, s, v = Color3.toHSV(defcolor)
                local colorOpened = false
                
                local colorElement = Instance.new("TextButton")
                local UICorner = Instance.new("UICorner")
                local colorHeader = Instance.new("Frame")
                local headerCorner = Instance.new("UICorner")
                local touch = Instance.new("ImageLabel")
                local togName = Instance.new("TextLabel")
                local viewInfo = Instance.new("ImageButton")
                local colorCurrent = Instance.new("Frame")
                local currentCorner = Instance.new("UICorner")
                local UIListLayout = Instance.new("UIListLayout")
                local colorInners = Instance.new("Frame")
                local innersCorner = Instance.new("UICorner")
                local rgb = Instance.new("ImageButton")
                local rgbCorner = Instance.new("UICorner")
                local rbgcircle = Instance.new("ImageLabel")
                local darkness = Instance.new("ImageButton")
                local darknessCorner = Instance.new("UICorner")
                local darkcircle = Instance.new("ImageLabel")
                local toggleDisabled = Instance.new("ImageLabel")
                local toggleEnabled = Instance.new("ImageLabel")
                local onrainbow = Instance.new("TextButton")
                local rainbowLabel = Instance.new("TextLabel")
                
                local Sample = Instance.new("ImageLabel")
                Sample.Name = "Sample"
                Sample.Parent = colorHeader
                Sample.BackgroundTransparency = 1
                Sample.Image = "rbxassetid://4560909609"
                Sample.ImageColor3 = themeList.SchemeColor
                Sample.ImageTransparency = 0.6
                
                local btn = colorHeader
                local sample = Sample
                
                colorElement.Name = "colorElement"
                colorElement.Parent = sectionInners
                colorElement.BackgroundColor3 = themeList.ElementColor
                colorElement.BackgroundTransparency = 0
                colorElement.ClipsDescendants = true
                colorElement.Size = UDim2.new(0, 352, 0, 33)
                colorElement.AutoButtonColor = false
                colorElement.Font = Enum.Font.FredokaOne
                colorElement.Text = ""
                colorElement.TextColor3 = Color3.fromRGB(0, 0, 0)
                colorElement.TextSize = 14
                
                local ms = game.Players.LocalPlayer:GetMouse()
                
                local colorClickConn = colorElement.MouseButton1Click:Connect(function()
                    if not focusing then
                        if colorOpened then
                            colorOpened = false
                            colorElement:TweenSize(UDim2.new(0, 352, 0, 33), "InOut", "Linear", 0.08)
                            task.wait(0.1)
                            updateSectionFrame()
                            UpdateSize()
                            if btn and btn.Parent then
                                local c = sample:Clone()
                                c.Parent = btn
                                local success, x, y = pcall(function() 
                                    return ms.X - c.AbsolutePosition.X, ms.Y - c.AbsolutePosition.Y 
                                end)
                                if success then c.Position = UDim2.new(0, x, 0, y) end
                                local size = btn.AbsoluteSize.X >= btn.AbsoluteSize.Y and (btn.AbsoluteSize.X * 1.5) or (btn.AbsoluteSize.Y * 1.5)
                                c:TweenSizeAndPosition(UDim2.new(0, size, 0, size), UDim2.new(0.5, -size/2, 0.5, -size/2), 'Out', 'Quad', 0.35, true, nil)
                                for i = 1, 10 do
                                    c.ImageTransparency = c.ImageTransparency + 0.05
                                    task.wait(0.35 / 12)
                                end
                                c:Destroy()
                            end
                        else
                            colorOpened = true
                            colorElement:TweenSize(UDim2.new(0, 352, 0, 141), "InOut", "Linear", 0.08, true)
                            task.wait(0.1)
                            updateSectionFrame()
                            UpdateSize()
                            if btn and btn.Parent then
                                local c = sample:Clone()
                                c.Parent = btn
                                local success, x, y = pcall(function() 
                                    return ms.X - c.AbsolutePosition.X, ms.Y - c.AbsolutePosition.Y 
                                end)
                                if success then c.Position = UDim2.new(0, x, 0, y) end
                                local size = btn.AbsoluteSize.X >= btn.AbsoluteSize.Y and (btn.AbsoluteSize.X * 1.5) or (btn.AbsoluteSize.Y * 1.5)
                                c:TweenSizeAndPosition(UDim2.new(0, size, 0, size), UDim2.new(0.5, -size/2, 0.5, -size/2), 'Out', 'Quad', 0.35, true, nil)
                                for i = 1, 10 do
                                    c.ImageTransparency = c.ImageTransparency + 0.05
                                    task.wait(0.35 / 12)
                                end
                                c:Destroy()
                            end
                        end
                    else
                        for _, v in pairs(infoContainer:GetChildren()) do
                            if v and v.Parent then Utility:TweenObject(v, {Position = UDim2.new(0, 0, 2, 0)}, 0.2) end
                            focusing = false
                        end
                        if blurFrame and blurFrame.Parent then Utility:TweenObject(blurFrame, {BackgroundTransparency = 1}, 0.2) end
                    end
                end)
                AddConnection(colorClickConn)
                
                UICorner.CornerRadius = UDim.new(0, 4)
                UICorner.Parent = colorElement
                
                colorHeader.Name = "colorHeader"
                colorHeader.Parent = colorElement
                colorHeader.BackgroundColor3 = themeList.ElementColor
                colorHeader.Size = UDim2.new(0, 352, 0, 33)
                colorHeader.ClipsDescendants = true
                
                headerCorner.CornerRadius = UDim.new(0, 4)
                headerCorner.Parent = colorHeader
                
                touch.Name = "touch"
                touch.Parent = colorHeader
                touch.BackgroundTransparency = 1
                touch.Position = UDim2.new(0.02, 0, 0.18, 0)
                touch.Size = UDim2.new(0, 21, 0, 21)
                touch.Image = "rbxassetid://3926305904"
                touch.ImageColor3 = themeList.SchemeColor
                touch.ImageRectOffset = Vector2.new(44, 964)
                touch.ImageRectSize = Vector2.new(36, 36)
                
                togName.Name = "togName"
                togName.Parent = colorHeader
                togName.BackgroundTransparency = 1
                togName.Position = UDim2.new(0.0967, 0, 0.2727, 0)
                togName.Size = UDim2.new(0, 288, 0, 14)
                togName.Font = Enum.Font.FredokaOne
                togName.Text = colText
                togName.TextColor3 = themeList.TextColor
                togName.TextSize = 14
                togName.RichText = true
                togName.TextXAlignment = Enum.TextXAlignment.Left
                
                local moreInfo = Instance.new("TextLabel")
                local moreInfoCorner = Instance.new("UICorner")
                
                moreInfo.Name = "TipMore"
                moreInfo.Parent = infoContainer
                moreInfo.BackgroundColor3 = Color3.fromRGB(math.clamp(themeList.SchemeColor.R * 255 - 14, 0, 255), math.clamp(themeList.SchemeColor.G * 255 - 17, 0, 255), math.clamp(themeList.SchemeColor.B * 255 - 13, 0, 255))
                moreInfo.Position = UDim2.new(0, 0, 2, 0)
                moreInfo.Size = UDim2.new(0, 353, 0, 33)
                moreInfo.ZIndex = 9
                moreInfo.Font = Enum.Font.FredokaOne
                moreInfo.Text = "  " .. colInf
                moreInfo.TextColor3 = themeList.TextColor
                moreInfo.TextSize = 14
                moreInfo.TextXAlignment = Enum.TextXAlignment.Left
                
                moreInfoCorner.CornerRadius = UDim.new(0, 4)
                moreInfoCorner.Parent = moreInfo
                
                viewInfo.Name = "viewInfo"
                viewInfo.Parent = colorHeader
                viewInfo.BackgroundTransparency = 1
                viewInfo.Position = UDim2.new(0.93, 0, 0.152, 0)
                viewInfo.Size = UDim2.new(0, 23, 0, 23)
                viewInfo.Image = "rbxassetid://3926305904"
                viewInfo.ImageColor3 = themeList.SchemeColor
                viewInfo.ImageRectOffset = Vector2.new(764, 764)
                viewInfo.ImageRectSize = Vector2.new(36, 36)
                
                colorCurrent.Name = "colorCurrent"
                colorCurrent.Parent = colorHeader
                colorCurrent.BackgroundColor3 = defcolor
                colorCurrent.Position = UDim2.new(0.7926, 0, 0.2121, 0)
                colorCurrent.Size = UDim2.new(0, 42, 0, 18)
                
                currentCorner.CornerRadius = UDim.new(0, 4)
                currentCorner.Parent = colorCurrent
                
                UIListLayout.Parent = colorElement
                UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
                UIListLayout.Padding = UDim.new(0, 3)
                
                colorInners.Name = "colorInners"
                colorInners.Parent = colorElement
                colorInners.BackgroundColor3 = themeList.ElementColor
                colorInners.Position = UDim2.new(0, 0, 0.2553, 0)
                colorInners.Size = UDim2.new(0, 352, 0, 105)
                
                innersCorner.CornerRadius = UDim.new(0, 4)
                innersCorner.Parent = colorInners
                
                rgb.Name = "rgb"
                rgb.Parent = colorInners
                rgb.BackgroundTransparency = 1
                rgb.Position = UDim2.new(0.01989, 0, 0.0476, 0)
                rgb.Size = UDim2.new(0, 211, 0, 93)
                rgb.Image = "rbxassetid://6523286724"
                
                rgbCorner.CornerRadius = UDim.new(0, 4)
                rgbCorner.Parent = rgb
                
                rbgcircle.Name = "rbgcircle"
                rbgcircle.Parent = rgb
                rbgcircle.BackgroundTransparency = 1
                rbgcircle.Size = UDim2.new(0, 14, 0, 14)
                rbgcircle.Image = "rbxassetid://3926309567"
                rbgcircle.ImageColor3 = Color3.fromRGB(0, 0, 0)
                rbgcircle.ImageRectOffset = Vector2.new(628, 420)
                rbgcircle.ImageRectSize = Vector2.new(48, 48)
                
                darkness.Name = "darkness"
                darkness.Parent = colorInners
                darkness.BackgroundTransparency = 1
                darkness.Position = UDim2.new(0.63636, 0, 0.0476, 0)
                darkness.Size = UDim2.new(0, 18, 0, 93)
                darkness.Image = "rbxassetid://6523291212"
                
                darknessCorner.CornerRadius = UDim.new(0, 4)
                darknessCorner.Parent = darkness
                
                darkcircle.Name = "darkcircle"
                darkcircle.Parent = darkness
                darkcircle.AnchorPoint = Vector2.new(0.5, 0)
                darkcircle.BackgroundTransparency = 1
                darkcircle.Size = UDim2.new(0, 14, 0, 14)
                darkcircle.Image = "rbxassetid://3926309567"
                darkcircle.ImageColor3 = Color3.fromRGB(0, 0, 0)
                darkcircle.ImageRectOffset = Vector2.new(628, 420)
                darkcircle.ImageRectSize = Vector2.new(48, 48)
                
                toggleDisabled.Name = "toggleDisabled"
                toggleDisabled.Parent = colorInners
                toggleDisabled.BackgroundTransparency = 1
                toggleDisabled.Position = UDim2.new(0.70466, 0, 0.06571, 0)
                toggleDisabled.Size = UDim2.new(0, 21, 0, 21)
                toggleDisabled.Image = "rbxassetid://3926309567"
                toggleDisabled.ImageColor3 = themeList.SchemeColor
                toggleDisabled.ImageRectOffset = Vector2.new(628, 420)
                toggleDisabled.ImageRectSize = Vector2.new(48, 48)
                
                toggleEnabled.Name = "toggleEnabled"
                toggleEnabled.Parent = colorInners
                toggleEnabled.BackgroundTransparency = 1
                toggleEnabled.Position = UDim2.new(0.705, 0, 0.066, 0)
                toggleEnabled.Size = UDim2.new(0, 21, 0, 21)
                toggleEnabled.Image = "rbxassetid://3926309567"
                toggleEnabled.ImageColor3 = themeList.SchemeColor
                toggleEnabled.ImageRectOffset = Vector2.new(784, 420)
                toggleEnabled.ImageRectSize = Vector2.new(48, 48)
                toggleEnabled.ImageTransparency = 1
                
                onrainbow.Name = "onrainbow"
                onrainbow.Parent = toggleEnabled
                onrainbow.BackgroundTransparency = 1
                onrainbow.Size = UDim2.new(1, 0, 1, 0)
                onrainbow.Font = Enum.Font.FredokaOne
                onrainbow.Text = ""
                onrainbow.TextColor3 = Color3.fromRGB(0, 0, 0)
                onrainbow.TextSize = 14
                
                rainbowLabel.Name = "togName"
                rainbowLabel.Parent = colorInners
                rainbowLabel.BackgroundTransparency = 1
                rainbowLabel.Position = UDim2.new(0.78, 0, 0.1, 0)
                rainbowLabel.Size = UDim2.new(0, 278, 0, 14)
                rainbowLabel.Font = Enum.Font.FredokaOne
                rainbowLabel.Text = "Rainbow"
                rainbowLabel.TextColor3 = themeList.TextColor
                rainbowLabel.TextSize = 14
                rainbowLabel.TextXAlignment = Enum.TextXAlignment.Left
                
                updateSectionFrame()
                UpdateSize()
                
                local uis = game:GetService("UserInputService")
                local rs = game:GetService("RunService")
                local colorpicker = false
                local darknesss = false
                local dark = darkness
                local cursor = rbgcircle
                local cursor2 = darkcircle
                local color = {h, s, v}
                local rainbow = false
                local rainbowconnection = nil
                local counter = 0
                
                local function zigzag(X)
                    return math.acos(math.cos(X * math.pi)) / math.pi
                end
                
                local function updateColor(input)
                    if colorpicker then
                        local x = input.Position.X - rgb.AbsolutePosition.X
                        local y = input.Position.Y - rgb.AbsolutePosition.Y
                        local maxX, maxY = rgb.AbsoluteSize.X, rgb.AbsoluteSize.Y
                        if maxX <= 0 or maxY <= 0 then return end
                        
                        x = math.clamp(x / maxX, 0, 1)
                        y = math.clamp(y / maxY, 0, 1)
                        
                        local cx = cursor.AbsoluteSize.X / 2
                        local cy = cursor.AbsoluteSize.Y / 2
                        cursor.Position = UDim2.new(x, -cx, y, -cy)
                        
                        color = {1 - x, 1 - y, color[3]}
                        local realcolor = Color3.fromHSV(color[1], color[2], color[3])
                        colorCurrent.BackgroundColor3 = realcolor
                        safeCall(callback, realcolor)
                    elseif darknesss then
                        local y = input.Position.Y - dark.AbsolutePosition.Y
                        local maxY = dark.AbsoluteSize.Y
                        if maxY <= 0 then return end
                        
                        y = math.clamp(y / maxY, 0, 1)
                        
                        local cy = cursor2.AbsoluteSize.Y / 2
                        cursor2.Position = UDim2.new(0.5, 0, y, -cy)
                        cursor2.ImageColor3 = Color3.fromHSV(0, 0, y)
                        
                        color = {color[1], color[2], 1 - y}
                        local realcolor = Color3.fromHSV(color[1], color[2], color[3])
                        colorCurrent.BackgroundColor3 = realcolor
                        safeCall(callback, realcolor)
                    end
                end
                
                local function setcolor(tbl)
                    local cx = cursor.AbsoluteSize.X / 2
                    local cy = cursor.AbsoluteSize.Y / 2
                    color = {tbl[1], tbl[2], tbl[3]}
                    cursor.Position = UDim2.new(1 - color[1], -cx, 1 - color[2], -cy)
                    cursor2.Position = UDim2.new(0.5, 0, 1 - color[3], -cy)
                    local realcolor = Color3.fromHSV(color[1], color[2], color[3])
                    colorCurrent.BackgroundColor3 = realcolor
                end
                
                local function setrgbcolor(tbl)
                    local cx = cursor.AbsoluteSize.X / 2
                    local cy = cursor.AbsoluteSize.Y / 2
                    color = {tbl[1], tbl[2], color[3]}
                    cursor.Position = UDim2.new(1 - color[1], -cx, 1 - color[2], -cy)
                    local realcolor = Color3.fromHSV(color[1], color[2], color[3])
                    colorCurrent.BackgroundColor3 = realcolor
                    safeCall(callback, realcolor)
                end
                
                local function togglerainbow()
                    if rainbow then
                        local twe = tween:Create(toggleEnabled, TweenInfo.new(0.1), {ImageTransparency = 1})
                        twe:Play()
                        rainbow = false
                        if rainbowconnection then
                            rainbowconnection:Disconnect()
                            for idx, conn in ipairs(ActiveConnections) do
                                if conn == rainbowconnection then
                                    table.remove(ActiveConnections, idx)
                                    break
                                end
                            end
                            rainbowconnection = nil
                        end
                    else
                        local twe = tween:Create(toggleEnabled, TweenInfo.new(0.1), {ImageTransparency = 0})
                        twe:Play()
                        rainbow = true
                        rainbowconnection = rs.RenderStepped:Connect(function()
                            setrgbcolor({zigzag(counter), 1, 1})
                            counter = counter + 0.01
                        end)
                        AddConnection(rainbowconnection)
                    end
                end
                
                local rainbowClickConn = onrainbow.MouseButton1Click:Connect(togglerainbow)
                AddConnection(rainbowClickConn)
                
                local rgbDownConn = rgb.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        colorpicker = true
                        updateColor(input)
                    end
                end)
                AddConnection(rgbDownConn)
                
                local darkDownConn = dark.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        darknesss = true
                        updateColor(input)
                    end
                end)
                AddConnection(darkDownConn)
                
                local pickMoveConn = uis.InputChanged:Connect(function(input)
                    if (colorpicker or darknesss) and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        updateColor(input)
                    end
                end)
                AddConnection(pickMoveConn)
                
                local pickEndConn = uis.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        colorpicker = false
                        darknesss = false
                    end
                end)
                AddConnection(pickEndConn)
                
                local viewConn = viewInfo.MouseButton1Click:Connect(function()
                    if not viewDe then
                        viewDe = true
                        focusing = true
                        for _, v in pairs(infoContainer:GetChildren()) do
                            if v and v ~= moreInfo and v.Parent then Utility:TweenObject(v, {Position = UDim2.new(0, 0, 2, 0)}, 0.2) end
                        end
                        if moreInfo and moreInfo.Parent then Utility:TweenObject(moreInfo, {Position = UDim2.new(0, 0, 0, 0)}, 0.2) end
                        if blurFrame and blurFrame.Parent then Utility:TweenObject(blurFrame, {BackgroundTransparency = 0.5}, 0.2) end
                        if colorElement and colorElement.Parent then Utility:TweenObject(colorElement, {BackgroundColor3 = themeList.ElementColor}, 0.2) end
                        task.wait(1.5)
                        focusing = false
                        if moreInfo and moreInfo.Parent then Utility:TweenObject(moreInfo, {Position = UDim2.new(0, 0, 2, 0)}, 0.2) end
                        if blurFrame and blurFrame.Parent then Utility:TweenObject(blurFrame, {BackgroundTransparency = 1}, 0.2) end
                        viewDe = false
                    end
                end)
                AddConnection(viewConn)
                
                local isHovering = false
                
                local enterConn = colorElement.MouseEnter:Connect(function()
                    if not focusing and colorElement and colorElement.Parent then
                        local twe = tween:Create(colorElement, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(math.clamp(themeList.ElementColor.R * 255 + 8, 0, 255), math.clamp(themeList.ElementColor.G * 255 + 9, 0, 255), math.clamp(themeList.ElementColor.B * 255 + 10, 0, 255))})
                        twe:Play()
                        isHovering = true
                    end
                end)
                AddConnection(enterConn)
                
                local leaveConn = colorElement.MouseLeave:Connect(function()
                    if not focusing and colorElement and colorElement.Parent then
                        local twe = tween:Create(colorElement, TweenInfo.new(0.1), {BackgroundColor3 = themeList.ElementColor})
                        twe:Play()
                        isHovering = false
                    end
                end)
                AddConnection(leaveConn)
                
                local function UpdateColorPickerTheme()
                    if not colorElement or not colorElement.Parent then return end
                    if not isHovering then colorElement.BackgroundColor3 = themeList.ElementColor end
                    if touch then touch.ImageColor3 = themeList.SchemeColor end
                    if colorHeader then colorHeader.BackgroundColor3 = themeList.ElementColor end
                    if togName then togName.TextColor3 = themeList.TextColor end
                    if moreInfo then
                        moreInfo.BackgroundColor3 = Color3.fromRGB(math.clamp(themeList.SchemeColor.R * 255 - 14, 0, 255), math.clamp(themeList.SchemeColor.G * 255 - 17, 0, 255), math.clamp(themeList.SchemeColor.B * 255 - 13, 0, 255))
                        moreInfo.TextColor3 = themeList.TextColor
                    end
                    if viewInfo then viewInfo.ImageColor3 = themeList.SchemeColor end
                    if colorInners then colorInners.BackgroundColor3 = themeList.ElementColor end
                    if toggleDisabled then toggleDisabled.ImageColor3 = themeList.SchemeColor end
                    if toggleEnabled then toggleEnabled.ImageColor3 = themeList.SchemeColor end
                    if rainbowLabel then rainbowLabel.TextColor3 = themeList.TextColor end
                    if Sample then Sample.ImageColor3 = themeList.SchemeColor end
                end
                
                local themeConn = ThemeEvent.Event:Connect(UpdateColorPickerTheme)
                AddConnection(themeConn)
                UpdateColorPickerTheme()
                
                setcolor({h, s, v})
                
                local ColorPickerFunction = {}
                function ColorPickerFunction:SetColor(color)
                    local h2, s2, v2 = Color3.toHSV(color)
                    setcolor({h2, s2, v2})
                end
                return ColorPickerFunction
            end
            
            function Elements:NewLabel(title)
                local label = Instance.new("TextLabel")
                local UICorner = Instance.new("UICorner")
                
                label.Name = "label"
                label.Parent = sectionInners
                label.BackgroundColor3 = themeList.SchemeColor
                label.BorderSizePixel = 0
                label.ClipsDescendants = true
                label.Size = UDim2.new(0, 352, 0, 33)
                label.Font = Enum.Font.FredokaOne
                label.Text = "  " .. title
                label.RichText = true
                label.TextColor3 = themeList.TextColor
                label.TextSize = 14
                label.TextXAlignment = Enum.TextXAlignment.Left
                
                UICorner.CornerRadius = UDim.new(0, 4)
                UICorner.Parent = label
                
                updateSectionFrame()
                UpdateSize()
                
                local function UpdateLabelTheme()
                    if not label or not label.Parent then return end
                    label.BackgroundColor3 = themeList.SchemeColor
                    label.TextColor3 = themeList.TextColor
                end
                
                local themeConn = ThemeEvent.Event:Connect(UpdateLabelTheme)
                AddConnection(themeConn)
                UpdateLabelTheme()
                
                local labelFunc = {}
                function labelFunc:UpdateLabel(newText)
                    if label and label.Text ~= "  " .. newText then
                        label.Text = "  " .. newText
                    end
                end
                return labelFunc
            end
            
            function Elements:NewToggleUI(tname, nTip)
                tname = tname or "Toggle UI"
                nTip = nTip or "Click to toggle the UI"
                
                local toggleElement = Instance.new("TextButton")
                local UICorner = Instance.new("UICorner")
                local togName = Instance.new("TextLabel")
                
                toggleElement.Name = "toggleUIElement"
                toggleElement.Parent = sectionInners
                toggleElement.BackgroundColor3 = themeList.ElementColor
                toggleElement.ClipsDescendants = true
                toggleElement.Size = UDim2.new(0, 352, 0, 33)
                toggleElement.AutoButtonColor = false
                toggleElement.Font = Enum.Font.FredokaOne
                toggleElement.Text = ""
                toggleElement.TextColor3 = Color3.fromRGB(0, 0, 0)
                toggleElement.TextSize = 14
                
                UICorner.CornerRadius = UDim.new(0, 4)
                UICorner.Parent = toggleElement
                
                togName.Name = "togName"
                togName.Parent = toggleElement
                togName.BackgroundTransparency = 1
                togName.Position = UDim2.new(0.05, 0, 0.2727, 0)
                togName.Size = UDim2.new(0, 300, 0, 14)
                togName.Font = Enum.Font.FredokaOne
                togName.Text = "🔘 " .. tname
                togName.RichText = true
                togName.TextColor3 = themeList.TextColor
                togName.TextSize = 14
                togName.TextXAlignment = Enum.TextXAlignment.Left
                
                local btn = toggleElement
                local isHovering = false
                
                local function PressF()
                    local success, vim = pcall(function()
                        return game:GetService("VirtualInputManager")
                    end)
                    if success and vim then
                        vim:SendKeyEvent(true, Enum.KeyCode.F, false, game)
                        task.wait(0.05)
                        vim:SendKeyEvent(false, Enum.KeyCode.F, false, game)
                        return true
                    end
                    SpecialUI:ToggleUI()
                    return true
                end
                
                local clickConn = btn.MouseButton1Click:Connect(function()
                    PressF()
                end)
                AddConnection(clickConn)
                
                local enterConn = btn.MouseEnter:Connect(function()
                    if not focusing and btn and btn.Parent then
                        local twe = tween:Create(btn, TweenInfo.new(0.1), {
                            BackgroundColor3 = Color3.fromRGB(
                                math.clamp(themeList.ElementColor.R * 255 + 8, 0, 255),
                                math.clamp(themeList.ElementColor.G * 255 + 9, 0, 255),
                                math.clamp(themeList.ElementColor.B * 255 + 10, 0, 255)
                            )
                        })
                        twe:Play()
                        isHovering = true
                    end
                end)
                AddConnection(enterConn)
                
                local leaveConn = btn.MouseLeave:Connect(function()
                    if not focusing and btn and btn.Parent then
                        local twe = tween:Create(btn, TweenInfo.new(0.1), {
                            BackgroundColor3 = themeList.ElementColor
                        })
                        twe:Play()
                        isHovering = false
                    end
                end)
                AddConnection(leaveConn)
                
                local function UpdateToggleUITheme()
                    if not toggleElement or not toggleElement.Parent then return end
                    if not isHovering then
                        toggleElement.BackgroundColor3 = themeList.ElementColor
                    end
                    if togName then
                        togName.TextColor3 = themeList.TextColor
                    end
                end
                
                local themeConn = ThemeEvent.Event:Connect(UpdateToggleUITheme)
                AddConnection(themeConn)
                UpdateToggleUITheme()
                
                local ToggleUIFunction = {}
                function ToggleUIFunction:UpdateText(newText)
                    if togName then
                        togName.Text = "🔘 " .. newText
                    end
                end
                function ToggleUIFunction:Press()
                    PressF()
                end
                return ToggleUIFunction
            end
            
            function Elements:NewHomeCard(config)
                config = config or {}
                local buttons = config.buttons or {}
                local numButtons = math.min(#buttons, 2)
                
                local mainRect = Instance.new("Frame")
                mainRect.Parent = sectionInners
                mainRect.BackgroundColor3 = themeList.ElementColor
                mainRect.BackgroundTransparency = 0.15
                mainRect.Size = UDim2.new(0, 352, 0, 110)
                mainRect.ClipsDescendants = true
                
                local rectCorner = Instance.new("UICorner")
                rectCorner.CornerRadius = UDim.new(0, 6)
                rectCorner.Parent = mainRect
                
                local avatarSquare = Instance.new("Frame")
                avatarSquare.Parent = mainRect
                avatarSquare.Position = UDim2.new(0, 15, 0.5, -40)
                avatarSquare.Size = UDim2.new(0, 80, 0, 80)
                avatarSquare.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
                avatarSquare.BackgroundTransparency = 0.3
                
                local avatarCorner = Instance.new("UICorner")
                avatarCorner.CornerRadius = UDim.new(0, 6)
                avatarCorner.Parent = avatarSquare
                
                local avatarImage = Instance.new("ImageLabel")
                avatarImage.Parent = avatarSquare
                avatarImage.Size = UDim2.new(1, 0, 1, 0)
                avatarImage.Position = UDim2.new(0, 0, 0, 0)
                avatarImage.BackgroundTransparency = 1
                avatarImage.ScaleType = Enum.ScaleType.Fit
                
                local userId = game.Players.LocalPlayer.UserId
                local success, thumb = pcall(function()
                    return game:GetService("Players"):GetUserThumbnailAsync(
                        userId,
                        Enum.ThumbnailType.HeadShot,
                        Enum.ThumbnailSize.Size150x150
                    )
                end)
                if success and thumb then
                    avatarImage.Image = thumb
                else
                    avatarImage.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
                end
                
                local rightFrame = Instance.new("Frame")
                rightFrame.Parent = mainRect
                rightFrame.BackgroundTransparency = 1
                rightFrame.Position = UDim2.new(0, 110, 0.5, -45)
                rightFrame.Size = UDim2.new(0, 227, 0, 90)
                
                local rightLayout = Instance.new("UIListLayout")
                rightLayout.Parent = rightFrame
                rightLayout.SortOrder = Enum.SortOrder.LayoutOrder
                rightLayout.Padding = UDim.new(0, 4)
                rightLayout.VerticalAlignment = Enum.VerticalAlignment.Center
                
                local welcomeText = Instance.new("TextLabel")
                welcomeText.Parent = rightFrame
                welcomeText.BackgroundTransparency = 1
                welcomeText.Size = UDim2.new(1, 0, 0, 14)
                welcomeText.Font = Enum.Font.FredokaOne
                welcomeText.Text = "Welcome,"
                welcomeText.TextColor3 = themeList.TextColor
                welcomeText.TextSize = 12
                welcomeText.TextXAlignment = Enum.TextXAlignment.Left
                welcomeText.TextTransparency = 0.5
                welcomeText.LayoutOrder = 1
                
                local usernameText = Instance.new("TextLabel")
                usernameText.Parent = rightFrame
                usernameText.BackgroundTransparency = 1
                usernameText.Size = UDim2.new(1, 0, 0, 22)
                usernameText.Font = Enum.Font.FredokaOne
                usernameText.Text = game.Players.LocalPlayer.Name
                usernameText.TextColor3 = themeList.SchemeColor
                usernameText.TextSize = 18
                usernameText.TextXAlignment = Enum.TextXAlignment.Left
                usernameText.LayoutOrder = 2
                
                local buttonFrame = Instance.new("Frame")
                buttonFrame.Parent = rightFrame
                buttonFrame.BackgroundTransparency = 1
                buttonFrame.Size = UDim2.new(1, 0, 0, 28)
                buttonFrame.LayoutOrder = 3
                
                local buttonLayout = Instance.new("UIListLayout")
                buttonLayout.Parent = buttonFrame
                buttonLayout.SortOrder = Enum.SortOrder.LayoutOrder
                buttonLayout.FillDirection = Enum.FillDirection.Horizontal
                buttonLayout.Padding = UDim.new(0, 8)
                buttonLayout.VerticalAlignment = Enum.VerticalAlignment.Center
                
                local spaceReserved = (numButtons - 1) * 8
                local buttonWidth = numButtons > 0 and ((227 - spaceReserved) / numButtons) or 0
                
                for i, btnData in ipairs(buttons) do
                    if i <= 2 then
                        local btn = Instance.new("TextButton")
                        btn.Parent = buttonFrame
                        btn.BackgroundColor3 = themeList.SchemeColor
                        btn.BackgroundTransparency = 0.2
                        btn.Size = UDim2.new(0, buttonWidth, 0, 26)
                        btn.Font = Enum.Font.FredokaOne
                        btn.Text = btnData.text or "Button"
                        btn.TextColor3 = themeList.TextColor
                        btn.TextSize = 11
                        btn.AutoButtonColor = false
                        
                        local btnCorner = Instance.new("UICorner")
                        btnCorner.CornerRadius = UDim.new(0, 4)
                        btnCorner.Parent = btn
                        
                        btn.MouseEnter:Connect(function()
                            tween:Create(btn, TweenInfo.new(0.15), {BackgroundTransparency = 0}):Play()
                        end)
                        btn.MouseLeave:Connect(function()
                            tween:Create(btn, TweenInfo.new(0.15), {BackgroundTransparency = 0.2}):Play()
                        end)
                        btn.MouseButton1Click:Connect(btnData.callback or function() end)
                    end
                end
                
                local function UpdateHomeTheme()
                    if not mainRect or not mainRect.Parent then return end
                    mainRect.BackgroundColor3 = themeList.ElementColor
                    if welcomeText then welcomeText.TextColor3 = themeList.TextColor end
                    if usernameText then usernameText.TextColor3 = themeList.SchemeColor end
                    for _, v in pairs(buttonFrame:GetChildren()) do
                        if v:IsA("TextButton") then
                            v.BackgroundColor3 = themeList.SchemeColor
                            v.TextColor3 = themeList.TextColor
                        end
                    end
                end
                
                local themeConn = ThemeEvent.Event:Connect(UpdateHomeTheme)
                AddConnection(themeConn)
                UpdateHomeTheme()
                
                local HomeFunction = {}
                function HomeFunction:UpdateUsername(newName)
                    usernameText.Text = newName or game.Players.LocalPlayer.Name
                end
                function HomeFunction:RefreshAvatar()
                    local newThumb = game:GetService("Players"):GetUserThumbnailAsync(
                        userId,
                        Enum.ThumbnailType.HeadShot,
                        Enum.ThumbnailSize.Size150x150
                    )
                    avatarImage.Image = newThumb
                end
                return HomeFunction
            end
            
            function Elements:NewConsolePlayer()
                local consoleFrame = Instance.new("Frame")
                consoleFrame.Parent = sectionInners
                consoleFrame.BackgroundColor3 = themeList.Background
                consoleFrame.BackgroundTransparency = 0.8
                consoleFrame.Size = UDim2.new(0, 352, 0, 120)
                consoleFrame.ClipsDescendants = true
                
                local consoleCorner = Instance.new("UICorner")
                consoleCorner.CornerRadius = UDim.new(0, 6)
                consoleCorner.Parent = consoleFrame
                
                local consoleOutput = Instance.new("ScrollingFrame")
                consoleOutput.Parent = consoleFrame
                consoleOutput.BackgroundTransparency = 1
                consoleOutput.Position = UDim2.new(0.02, 0, 0.05, 0)
                consoleOutput.Size = UDim2.new(0.96, 0, 0.9, 0)
                consoleOutput.ScrollBarThickness = 5
                consoleOutput.CanvasSize = UDim2.new(0, 0, 0, 0)
                consoleOutput.BorderSizePixel = 0
                consoleOutput.Active = true
                consoleOutput.ScrollBarImageColor3 = themeList.SchemeColor
                
                local consoleLayout = Instance.new("UIListLayout")
                consoleLayout.Parent = consoleOutput
                consoleLayout.SortOrder = Enum.SortOrder.LayoutOrder
                consoleLayout.Padding = UDim.new(0, 2)
                
                local consoleLines = {}
                local maxLines = 50
                
                local function PrintToConsole(message, color)
                    color = color or themeList.TextColor
                    local line = Instance.new("TextLabel")
                    line.Parent = consoleOutput
                    line.BackgroundTransparency = 1
                    line.Size = UDim2.new(1, 0, 0, 18)
                    line.Font = Enum.Font.FredokaOne
                    line.Text = "> " .. tostring(message)
                    line.TextColor3 = color
                    line.TextSize = 11
                    line.TextXAlignment = Enum.TextXAlignment.Left
                    line.TextTransparency = 0.2
                    
                    table.insert(consoleLines, line)
                    if #consoleLines > maxLines then
                        local old = table.remove(consoleLines, 1)
                        if old then old:Destroy() end
                    end
                    
                    task.spawn(function()
                        task.wait()
                        if consoleLayout and consoleOutput then
                            local totalHeight = consoleLayout.AbsoluteContentSize.Y
                            consoleOutput.CanvasSize = UDim2.new(0, 0, 0, totalHeight + 10)
                            consoleOutput.CanvasPosition = Vector2.new(0, totalHeight)
                        end
                    end)
                end
                
                local function UpdateConsoleTheme()
                    if not consoleFrame or not consoleFrame.Parent then return end
                    consoleFrame.BackgroundColor3 = themeList.Background
                    consoleOutput.ScrollBarImageColor3 = themeList.SchemeColor
                    for _, line in ipairs(consoleLines) do
                        if line and line.Parent then
                            line.TextColor3 = themeList.TextColor
                        end
                    end
                end
                
                local themeConn = ThemeEvent.Event:Connect(UpdateConsoleTheme)
                AddConnection(themeConn)
                UpdateConsoleTheme()
                
                PrintToConsole("SpecialUI Sundae v1.0.0 loaded!", themeList.SchemeColor)
                PrintToConsole("Welcome " .. game.Players.LocalPlayer.Name .. "!", themeList.TextColor)
                
                local ConsoleFunction = {}
                function ConsoleFunction:Print(message, color)
                    PrintToConsole(message, color or themeList.TextColor)
                end
                function ConsoleFunction:Info(message)
                    PrintToConsole("ℹ️ " .. message, Color3.fromRGB(100, 200, 255))
                end
                function ConsoleFunction:Success(message)
                    PrintToConsole("✅ " .. message, Color3.fromRGB(0, 255, 100))
                end
                function ConsoleFunction:Warning(message)
                    PrintToConsole("⚠️ " .. message, Color3.fromRGB(255, 200, 0))
                end
                function ConsoleFunction:Error(message)
                    PrintToConsole("❌ " .. message, Color3.fromRGB(255, 50, 50))
                end
                function ConsoleFunction:Clear()
                    for _, line in ipairs(consoleLines) do
                        line:Destroy()
                    end
                    consoleLines = {}
                    consoleOutput.CanvasSize = UDim2.new(0, 0, 0, 0)
                end
                function ConsoleFunction:SetMaxLines(newMax)
                    maxLines = newMax or 50
                end
                return ConsoleFunction
            end
            
            return Elements
        end
        return Sections
    end
    
    function Tabs:NewDropdownTab(tabName, tabInf, options, callback)
        tabName = tabName or "Dropdown"
        options = options or {}
        callback = callback or function() end
        
        local mainTab = Tabs:NewTab(tabName)
        local selectorSection = mainTab:NewSection("Select Category", false)
        
        local sectionsByOption = {}
        for _, opt in ipairs(options) do
            sectionsByOption[opt] = {}
        end
        
        local currentOption = options[1] or ""
        
        local SubTabs = {}
        
        function SubTabs:NewSectionInOption(optionName, sectionName)
            local sec = mainTab:NewSection(sectionName or "Section", false)
            
            if sectionsByOption[optionName] then
                table.insert(sectionsByOption[optionName], sec)
            else
                sectionsByOption[optionName] = {sec}
            end
            
            if optionName ~= currentOption then
                if sec._frame then sec._frame.Visible = false end
            end
            
            return sec
        end
        
        local dropFunc = selectorSection:NewDropdown("Category", tabInf or "Select a category", options, function(selected)
            currentOption = selected
            for optName, secList in pairs(sectionsByOption) do
                local isVisible = (optName == selected)
                for _, sec in ipairs(secList) do
                    if sec._frame then
                        sec._frame.Visible = isVisible
                    end
                end
            end
            
            task.spawn(function()
                task.wait()
                if mainTab._updateSize then
                    mainTab._updateSize()
                end
            end)
            
            safeCall(callback, selected)
        end)
        
        if #options > 0 then
            task.spawn(function()
                task.wait(0.18)
                dropFunc.Refresh(options)
            end)
        end
        
        function SubTabs:GetOption(optionName)
            local MockTab = {}
            function MockTab:NewSection(sectionName)
                return SubTabs:NewSectionInOption(optionName, sectionName)
            end
            return MockTab
        end
        
        return SubTabs
    end
    
    return Tabs
end

function SpecialUI:Destroy()
    for _, conn in pairs(ActiveConnections) do
        if conn and typeof(conn) == "RBXScriptConnection" then
            pcall(function() conn:Disconnect() end)
        end
    end
    table.clear(ActiveConnections)

    for instanceId, conns in pairs(DraggingConnections) do
        for _, conn in ipairs(conns) do
            if conn and typeof(conn) == "RBXScriptConnection" then
                pcall(function() conn:Disconnect() end)
            end
        end
    end
    table.clear(DraggingConnections)

    for i = #ActiveObjects, 1, -1 do
        local obj = ActiveObjects[i]
        if obj and typeof(obj) == "Instance" and obj.Parent then
            pcall(function() obj:Destroy() end)
        end
        ActiveObjects[i] = nil
    end
    table.clear(ActiveObjects)

    if ThemeEvent then
        pcall(function() ThemeEvent:Destroy() end)
        ThemeEvent = nil
    end

    if MainInstance and MainInstance.Parent then
        pcall(function() MainInstance:Destroy() end)
        MainInstance = nil
    end

    local gui = game.CoreGui:FindFirstChild(LibName)
    if gui then
        pcall(function() gui:Destroy() end)
    end

    Pages = nil
    tabFrames = nil
    infoContainer = nil
    blurFrame = nil
    LibName = nil
    CurrentThemeName = "Dark"
    CurrentThemeTable = nil
end

return SpecialUI
