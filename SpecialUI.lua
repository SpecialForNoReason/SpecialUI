local SpecialUI = {}

local tween = game:GetService("TweenService")
local tweeninfo = TweenInfo.new
local input = game:GetService("UserInputService")
local run = game:GetService("RunService")
local http = game:GetService("HttpService")

local Utility = {}

local ActiveConnections = {}
local ActiveThreads = {}
local ActiveObjects = {}

local function AddConnection(conn)
    table.insert(ActiveConnections, conn)
    return conn
end

local function AddThread(th)
    table.insert(ActiveThreads, th)
    return th
end

local function AddObject(obj)
    table.insert(ActiveObjects, obj)
    return obj
end

function Utility:TweenObject(obj, properties, duration, ...)
    tween:Create(obj, tweeninfo(duration, ...), properties):Play()
end

local ThemeStyles = {
    Default = {
        SchemeColor = Color3.fromRGB(74, 99, 135),
        Background = Color3.fromRGB(36, 37, 43),
        Header = Color3.fromRGB(28, 29, 34),
        TextColor = Color3.fromRGB(255,255,255),
        ElementColor = Color3.fromRGB(32, 32, 38)
    },
    Dark = {
        SchemeColor = Color3.fromRGB(64, 64, 64),
        Background = Color3.fromRGB(0, 0, 0),
        Header = Color3.fromRGB(0, 0, 0),
        TextColor = Color3.fromRGB(255,255,255),
        ElementColor = Color3.fromRGB(20, 20, 20)
    },
    Light = {
        SchemeColor = Color3.fromRGB(150, 150, 150),
        Background = Color3.fromRGB(255,255,255),
        Header = Color3.fromRGB(200, 200, 200),
        TextColor = Color3.fromRGB(0,0,0),
        ElementColor = Color3.fromRGB(224, 224, 224)
    },
    Blood = {
        SchemeColor = Color3.fromRGB(227, 27, 27),
        Background = Color3.fromRGB(10, 10, 10),
        Header = Color3.fromRGB(5, 5, 5),
        TextColor = Color3.fromRGB(255,255,255),
        ElementColor = Color3.fromRGB(20, 20, 20)
    },
    Grape = {
        SchemeColor = Color3.fromRGB(166, 71, 214),
        Background = Color3.fromRGB(64, 50, 71),
        Header = Color3.fromRGB(36, 28, 41),
        TextColor = Color3.fromRGB(255,255,255),
        ElementColor = Color3.fromRGB(74, 58, 84)
    },
    Ocean = {
        SchemeColor = Color3.fromRGB(86, 76, 251),
        Background = Color3.fromRGB(26, 32, 58),
        Header = Color3.fromRGB(38, 45, 71),
        TextColor = Color3.fromRGB(200, 200, 200),
        ElementColor = Color3.fromRGB(38, 45, 71)
    },
    Midnight = {
        SchemeColor = Color3.fromRGB(26, 189, 158),
        Background = Color3.fromRGB(44, 62, 82),
        Header = Color3.fromRGB(57, 81, 105),
        TextColor = Color3.fromRGB(255, 255, 255),
        ElementColor = Color3.fromRGB(52, 74, 95)
    },
    Sentinel = {
        SchemeColor = Color3.fromRGB(230, 35, 69),
        Background = Color3.fromRGB(32, 32, 32),
        Header = Color3.fromRGB(24, 24, 24),
        TextColor = Color3.fromRGB(119, 209, 138),
        ElementColor = Color3.fromRGB(24, 24, 24)
    },
    Synapse = {
        SchemeColor = Color3.fromRGB(46, 48, 43),
        Background = Color3.fromRGB(13, 15, 12),
        Header = Color3.fromRGB(36, 38, 35),
        TextColor = Color3.fromRGB(152, 99, 53),
        ElementColor = Color3.fromRGB(24, 24, 24)
    },
    Serpent = {
        SchemeColor = Color3.fromRGB(0, 166, 58),
        Background = Color3.fromRGB(31, 41, 43),
        Header = Color3.fromRGB(22, 29, 31),
        TextColor = Color3.fromRGB(255,255,255),
        ElementColor = Color3.fromRGB(22, 29, 31)
    },
    Amoled = {
        SchemeColor = Color3.fromRGB(100, 100, 100),
        Background = Color3.fromRGB(0, 0, 0),
        Header = Color3.fromRGB(0, 0, 0),
        TextColor = Color3.fromRGB(255,255,255),
        ElementColor = Color3.fromRGB(10, 10, 10)
    },
    Lavender = {
        SchemeColor = Color3.fromRGB(180, 136, 255),
        Background = Color3.fromRGB(25, 20, 35),
        Header = Color3.fromRGB(20, 15, 30),
        TextColor = Color3.fromRGB(255,255,255),
        ElementColor = Color3.fromRGB(30, 25, 45)
    },
    Crimson = {
        SchemeColor = Color3.fromRGB(220, 20, 60),
        Background = Color3.fromRGB(15, 15, 20),
        Header = Color3.fromRGB(10, 10, 15),
        TextColor = Color3.fromRGB(255,255,255),
        ElementColor = Color3.fromRGB(20, 20, 25)
    },
    Forest = {
        SchemeColor = Color3.fromRGB(34, 139, 34),
        Background = Color3.fromRGB(20, 30, 20),
        Header = Color3.fromRGB(15, 25, 15),
        TextColor = Color3.fromRGB(255,255,255),
        ElementColor = Color3.fromRGB(25, 35, 25)
    },
    Amber = {
        SchemeColor = Color3.fromRGB(255, 126, 0),
        Background = Color3.fromRGB(25, 20, 15),
        Header = Color3.fromRGB(20, 15, 10),
        TextColor = Color3.fromRGB(255,255,255),
        ElementColor = Color3.fromRGB(30, 25, 20)
    }
}

local function GetTheme(theme)
    if type(theme) == "string" then
        return ThemeStyles[theme] or ThemeStyles.Default
    end
    return theme or ThemeStyles.Default
end

function SpecialUI:DraggingEnabled(frame, parent)
    parent = parent or frame
    local dragging = false
    local dragStart = nil
    local startPos = nil
    local currentInput
    local dragTween = nil

    local function update(input)
        local delta = input.Position - dragStart
        local targetPos = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
        if dragTween then dragTween:Cancel() end
        dragTween = tween:Create(parent, TweenInfo.new(0.15, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), { Position = targetPos })
        dragTween:Play()
    end

    local conn1 = frame.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = i.Position
            startPos = parent.Position
            local conn = i.Changed:Connect(function()
                if i.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
            AddConnection(conn)
        end
    end)
    AddConnection(conn1)

    local conn2 = frame.InputChanged:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
            currentInput = i
        end
    end)
    AddConnection(conn2)

    local conn3 = input.InputChanged:Connect(function(i)
        if dragging and i == currentInput then
            update(i)
        end
    end)
    AddConnection(conn3)
end

local LibName = tostring(math.random(1000, 9999)) .. tostring(math.random(1000, 9999))

function SpecialUI:ToggleUI()
    local gui = game.CoreGui:FindFirstChild(LibName)
    if gui then
        gui.Enabled = not gui.Enabled
    end
end

function SpecialUI.DestroyUI()
    for _, conn in ipairs(ActiveConnections) do
        pcall(function() conn:Disconnect() end)
    end
    for _, thread in ipairs(ActiveThreads) do
        if thread.active ~= nil then
            thread.active = false
        end
    end
    for _, obj in ipairs(ActiveObjects) do
        pcall(function() obj:Destroy() end)
    end
    local gui = game.CoreGui:FindFirstChild(LibName)
    if gui then
        gui:Destroy()
    end
    ActiveConnections = {}
    ActiveThreads = {}
    ActiveObjects = {}
end

function SpecialUI.CreateLib(kavName, themeName)
    local themeList = GetTheme(themeName)
    kavName = kavName or "Library"
    
    for i,v in pairs(game.CoreGui:GetChildren()) do
        if v:IsA("ScreenGui") and v.Name == kavName then
            v:Destroy()
        end
    end
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = LibName
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = game.CoreGui
    AddObject(ScreenGui)
    
    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Parent = ScreenGui
    Main.BackgroundColor3 = themeList.Background
    Main.ClipsDescendants = true
    Main.Position = UDim2.new(0.3365, 0, 0.2755, 0)
    Main.Size = UDim2.new(0, 525, 0, 318)
    AddObject(Main)
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 4)
    MainCorner.Parent = Main
    
    local MainHeader = Instance.new("Frame")
    MainHeader.Name = "MainHeader"
    MainHeader.Parent = Main
    MainHeader.BackgroundColor3 = themeList.Header
    MainHeader.Size = UDim2.new(0, 525, 0, 29)
    
    local headerCover = Instance.new("UICorner")
    headerCover.CornerRadius = UDim.new(0, 4)
    headerCover.Parent = MainHeader
    
    local coverup = Instance.new("Frame")
    coverup.Name = "coverup"
    coverup.Parent = MainHeader
    coverup.BackgroundColor3 = themeList.Header
    coverup.BorderSizePixel = 0
    coverup.Position = UDim2.new(0, 0, 0.7586, 0)
    coverup.Size = UDim2.new(0, 525, 0, 7)
    
    local title = Instance.new("TextLabel")
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
    
    local close = Instance.new("ImageButton")
    close.Name = "close"
    close.Parent = MainHeader
    close.BackgroundTransparency = 1
    close.Position = UDim2.new(0.95, 0, 0.138, 0)
    close.Size = UDim2.new(0, 21, 0, 21)
    close.Image = "rbxassetid://3926305904"
    close.ImageRectOffset = Vector2.new(284, 4)
    close.ImageRectSize = Vector2.new(24, 24)
    local closeConn = close.MouseButton1Click:Connect(function()
        SpecialUI.DestroyUI()
    end)
    AddConnection(closeConn)
    
    local MainSide = Instance.new("Frame")
    MainSide.Name = "MainSide"
    MainSide.Parent = Main
    MainSide.BackgroundColor3 = themeList.Header
    MainSide.Position = UDim2.new(-7.45e-09, 0, 0.09119, 0)
    MainSide.Size = UDim2.new(0, 149, 0, 289)
    
    local sideCorner = Instance.new("UICorner")
    sideCorner.CornerRadius = UDim.new(0, 4)
    sideCorner.Parent = MainSide
    
    local coverup_2 = Instance.new("Frame")
    coverup_2.Name = "coverup"
    coverup_2.Parent = MainSide
    coverup_2.BackgroundColor3 = themeList.Header
    coverup_2.BorderSizePixel = 0
    coverup_2.Position = UDim2.new(0.94994, 0, 0, 0)
    coverup_2.Size = UDim2.new(0, 7, 0, 289)
    
    local tabFrames = Instance.new("Frame")
    tabFrames.Name = "tabFrames"
    tabFrames.Parent = MainSide
    tabFrames.BackgroundTransparency = 1
    tabFrames.Position = UDim2.new(0.0439, 0, -0.00066, 0)
    tabFrames.Size = UDim2.new(0, 135, 0, 283)
    
    local tabListing = Instance.new("UIListLayout")
    tabListing.Parent = tabFrames
    tabListing.SortOrder = Enum.SortOrder.LayoutOrder
    
    local pages = Instance.new("Frame")
    pages.Name = "pages"
    pages.Parent = Main
    pages.BackgroundTransparency = 1
    pages.Position = UDim2.new(0.29905, 0, 0.12264, 0)
    pages.Size = UDim2.new(0, 360, 0, 269)
    
    local Pages = Instance.new("Folder")
    Pages.Name = "Pages"
    Pages.Parent = pages
    
    local infoContainer = Instance.new("Frame")
    infoContainer.Name = "infoContainer"
    infoContainer.Parent = Main
    infoContainer.BackgroundTransparency = 1
    infoContainer.ClipsDescendants = true
    infoContainer.Position = UDim2.new(0.29905, 0, 0.8742, 0)
    infoContainer.Size = UDim2.new(0, 368, 0, 33)
    
    local blurFrame = Instance.new("Frame")
    blurFrame.Name = "blurFrame"
    blurFrame.Parent = pages
    blurFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    blurFrame.BackgroundTransparency = 1
    blurFrame.BorderSizePixel = 0
    blurFrame.Position = UDim2.new(-0.02222, 0, -0.03717, 0)
    blurFrame.Size = UDim2.new(0, 376, 0, 289)
    blurFrame.ZIndex = 999
    
    SpecialUI:DraggingEnabled(MainHeader, Main)
    
    local themeUpdater = AddThread({active = true, thread = task.spawn(function()
        while themeUpdater.active do
            task.wait()
            Main.BackgroundColor3 = themeList.Background
            MainHeader.BackgroundColor3 = themeList.Header
            MainSide.BackgroundColor3 = themeList.Header
            coverup_2.BackgroundColor3 = themeList.Header
            coverup.BackgroundColor3 = themeList.Header
        end
    end)})
    
    function SpecialUI:ChangeColor(prop, color)
        if prop == "Background" then
            themeList.Background = color
        elseif prop == "SchemeColor" then
            themeList.SchemeColor = color
        elseif prop == "Header" then
            themeList.Header = color
        elseif prop == "TextColor" then
            themeList.TextColor = color
        elseif prop == "ElementColor" then
            themeList.ElementColor = color
        end
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
            local cS = pageListing.AbsoluteContentSize
            tween:Create(page, TweenInfo.new(0.15, Enum.EasingStyle.Linear), {
                CanvasSize = UDim2.new(0, cS.X, 0, cS.Y)
            }):Play()
        end
        
        page.Name = "Page"
        page.Parent = Pages
        page.Active = true
        page.BackgroundColor3 = themeList.Background
        page.BorderSizePixel = 0
        page.Position = UDim2.new(0, 0, -0.00372, 0)
        page.Size = UDim2.new(1, 0, 1, 0)
        page.ScrollBarThickness = 5
        page.Visible = false
        page.ScrollBarImageColor3 = Color3.fromRGB(themeList.SchemeColor.R * 255 - 16, themeList.SchemeColor.G * 255 - 15, themeList.SchemeColor.B * 255 - 28)
        
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
                v.Visible = false
            end
            page.Visible = true
            for _, v in pairs(tabFrames:GetChildren()) do
                if v:IsA("TextButton") then
                    Utility:TweenObject(v, {BackgroundTransparency = 1}, 0.2)
                end
            end
            Utility:TweenObject(tabButton, {BackgroundTransparency = 0}, 0.2)
        end)
        AddConnection(tabClickConn)
        
        local Sections = {}
        local focusing = false
        local viewDe = false
        
        local pageUpdater = AddThread({active = true, thread = task.spawn(function()
            while pageUpdater.active do
                task.wait()
                page.BackgroundColor3 = themeList.Background
                page.ScrollBarImageColor3 = Color3.fromRGB(themeList.SchemeColor.R * 255 - 16, themeList.SchemeColor.G * 255 - 15, themeList.SchemeColor.B * 255 - 28)
                tabButton.TextColor3 = themeList.TextColor
                tabButton.BackgroundColor3 = themeList.SchemeColor
            end
        end)})
        
        function Sections:NewSection(secName, hidden)
            secName = secName or "Section"
            local sectionFrame = Instance.new("Frame")
            local sectionlistoknvm = Instance.new("UIListLayout")
            local sectionHead = Instance.new("Frame")
            local sHeadCorner = Instance.new("UICorner")
            local sectionName = Instance.new("TextLabel")
            local sectionInners = Instance.new("Frame")
            local sectionElListing = Instance.new("UIListLayout")
            
            if hidden then
                sectionHead.Visible = false
            else
                sectionHead.Visible = true
            end
            
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
            
            local sectionUpdater = AddThread({active = true, thread = task.spawn(function()
                while sectionUpdater.active do
                    task.wait()
                    sectionFrame.BackgroundColor3 = themeList.Background
                    sectionHead.BackgroundColor3 = themeList.SchemeColor
                    sectionName.TextColor3 = themeList.TextColor
                end
            end)})
            
            local function updateSectionFrame()
                local innerSc = sectionElListing.AbsoluteContentSize
                sectionInners.Size = UDim2.new(1, 0, 0, innerSc.Y)
                local frameSc = sectionlistoknvm.AbsoluteContentSize
                sectionFrame.Size = UDim2.new(0, 352, 0, frameSc.Y)
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
            
            local Elements = {}
            
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
                moreInfo.BackgroundColor3 = Color3.fromRGB(themeList.SchemeColor.R * 255 - 14, themeList.SchemeColor.G * 255 - 17, themeList.SchemeColor.B * 255 - 13)
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
                        callback()
                        local c = sample:Clone()
                        c.Parent = btn
                        local x, y = (ms.X - c.AbsolutePosition.X), (ms.Y - c.AbsolutePosition.Y)
                        c.Position = UDim2.new(0, x, 0, y)
                        local size = btn.AbsoluteSize.X >= btn.AbsoluteSize.Y and (btn.AbsoluteSize.X * 1.5) or (btn.AbsoluteSize.Y * 1.5)
                        c:TweenSizeAndPosition(UDim2.new(0, size, 0, size), UDim2.new(0.5, -size/2, 0.5, -size/2), 'Out', 'Quad', 0.35, true, nil)
                        for i = 1, 10 do
                            c.ImageTransparency = c.ImageTransparency + 0.05
                            task.wait(0.35 / 12)
                        end
                        c:Destroy()
                    else
                        for _, v in pairs(infoContainer:GetChildren()) do
                            Utility:TweenObject(v, {Position = UDim2.new(0, 0, 2, 0)}, 0.2)
                            focusing = false
                        end
                        Utility:TweenObject(blurFrame, {BackgroundTransparency = 1}, 0.2)
                    end
                end)
                AddConnection(clickConn)
                
                local enterConn = btn.MouseEnter:Connect(function()
                    if not focusing then
                        tween:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(themeList.ElementColor.R * 255 + 8, themeList.ElementColor.G * 255 + 9, themeList.ElementColor.B * 255 + 10)}):Play()
                        isHovering = true
                    end
                end)
                AddConnection(enterConn)
                
                local leaveConn = btn.MouseLeave:Connect(function()
                    if not focusing then
                        tween:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = themeList.ElementColor}):Play()
                        isHovering = false
                    end
                end)
                AddConnection(leaveConn)
                
                local viewConn = viewInfo.MouseButton1Click:Connect(function()
                    if not viewDe then
                        viewDe = true
                        focusing = true
                        for _, v in pairs(infoContainer:GetChildren()) do
                            if v ~= moreInfo then
                                Utility:TweenObject(v, {Position = UDim2.new(0, 0, 2, 0)}, 0.2)
                            end
                        end
                        Utility:TweenObject(moreInfo, {Position = UDim2.new(0, 0, 0, 0)}, 0.2)
                        Utility:TweenObject(blurFrame, {BackgroundTransparency = 0.5}, 0.2)
                        Utility:TweenObject(btn, {BackgroundColor3 = themeList.ElementColor}, 0.2)
                        task.wait(1.5)
                        focusing = false
                        Utility:TweenObject(moreInfo, {Position = UDim2.new(0, 0, 2, 0)}, 0.2)
                        Utility:TweenObject(blurFrame, {BackgroundTransparency = 1}, 0.2)
                        viewDe = false
                    end
                end)
                AddConnection(viewConn)
                
                local elementUpdater = AddThread({active = true, thread = task.spawn(function()
                    while elementUpdater.active do
                        task.wait()
                        if not isHovering then
                            buttonElement.BackgroundColor3 = themeList.ElementColor
                        end
                        viewInfo.ImageColor3 = themeList.SchemeColor
                        Sample.ImageColor3 = themeList.SchemeColor
                        moreInfo.BackgroundColor3 = Color3.fromRGB(themeList.SchemeColor.R * 255 - 14, themeList.SchemeColor.G * 255 - 17, themeList.SchemeColor.B * 255 - 13)
                        moreInfo.TextColor3 = themeList.TextColor
                        touch.ImageColor3 = themeList.SchemeColor
                        btnInfo.TextColor3 = themeList.TextColor
                    end
                end)})
                
                local ButtonFunction = {}
                function ButtonFunction:UpdateButton(newTitle)
                    btnInfo.Text = newTitle
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
                moreInfo.BackgroundColor3 = Color3.fromRGB(themeList.SchemeColor.R * 255 - 14, themeList.SchemeColor.G * 255 - 17, themeList.SchemeColor.B * 255 - 13)
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
                            Utility:TweenObject(v, {Position = UDim2.new(0, 0, 2, 0)}, 0.2)
                            focusing = false
                        end
                        Utility:TweenObject(blurFrame, {BackgroundTransparency = 1}, 0.2)
                    end
                end)
                AddConnection(clickConn)
                
                local enterConn = btn.MouseEnter:Connect(function()
                    if not focusing then
                        tween:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(themeList.ElementColor.R * 255 + 8, themeList.ElementColor.G * 255 + 9, themeList.ElementColor.B * 255 + 10)}):Play()
                        isHovering = true
                    end
                end)
                AddConnection(enterConn)
                
                local leaveConn = btn.MouseLeave:Connect(function()
                    if not focusing then
                        tween:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = themeList.ElementColor}):Play()
                        isHovering = false
                    end
                end)
                AddConnection(leaveConn)
                
                local focusLostConn = TextBox.FocusLost:Connect(function(enterPressed)
                    if focusing then
                        for _, v in pairs(infoContainer:GetChildren()) do
                            Utility:TweenObject(v, {Position = UDim2.new(0, 0, 2, 0)}, 0.2)
                            focusing = false
                        end
                        Utility:TweenObject(blurFrame, {BackgroundTransparency = 1}, 0.2)
                    end
                    if enterPressed then
                        callback(TextBox.Text)
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
                            if v ~= moreInfo then
                                Utility:TweenObject(v, {Position = UDim2.new(0, 0, 2, 0)}, 0.2)
                            end
                        end
                        Utility:TweenObject(moreInfo, {Position = UDim2.new(0, 0, 0, 0)}, 0.2)
                        Utility:TweenObject(blurFrame, {BackgroundTransparency = 0.5}, 0.2)
                        Utility:TweenObject(btn, {BackgroundColor3 = themeList.ElementColor}, 0.2)
                        task.wait(1.5)
                        focusing = false
                        Utility:TweenObject(moreInfo, {Position = UDim2.new(0, 0, 2, 0)}, 0.2)
                        Utility:TweenObject(blurFrame, {BackgroundTransparency = 1}, 0.2)
                        viewDe = false
                    end
                end)
                AddConnection(viewConn)
                
                local elementUpdater = AddThread({active = true, thread = task.spawn(function()
                    while elementUpdater.active do
                        task.wait()
                        if not isHovering then
                            textboxElement.BackgroundColor3 = themeList.ElementColor
                        end
                        TextBox.BackgroundColor3 = themeList.ElementColor:lerp(Color3.new(0, 0, 0), 0.2)
                        viewInfo.ImageColor3 = themeList.SchemeColor
                        moreInfo.BackgroundColor3 = Color3.fromRGB(themeList.SchemeColor.R * 255 - 14, themeList.SchemeColor.G * 255 - 17, themeList.SchemeColor.B * 255 - 13)
                        moreInfo.TextColor3 = themeList.TextColor
                        write.ImageColor3 = themeList.SchemeColor
                        togName.TextColor3 = themeList.TextColor
                        TextBox.TextColor3 = themeList.TextColor
                    end
                end)})
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
                moreInfo.BackgroundColor3 = Color3.fromRGB(themeList.SchemeColor.R * 255 - 14, themeList.SchemeColor.G * 255 - 17, themeList.SchemeColor.B * 255 - 13)
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
                            tween:Create(img, TweenInfo.new(0.11), {ImageTransparency = 0}):Play()
                            local c = sample:Clone()
                            c.Parent = btn
                            local x, y = (ms.X - c.AbsolutePosition.X), (ms.Y - c.AbsolutePosition.Y)
                            c.Position = UDim2.new(0, x, 0, y)
                            local size = btn.AbsoluteSize.X >= btn.AbsoluteSize.Y and (btn.AbsoluteSize.X * 1.5) or (btn.AbsoluteSize.Y * 1.5)
                            c:TweenSizeAndPosition(UDim2.new(0, size, 0, size), UDim2.new(0.5, -size/2, 0.5, -size/2), 'Out', 'Quad', 0.35, true, nil)
                            for i = 1, 10 do
                                c.ImageTransparency = c.ImageTransparency + 0.05
                                task.wait(0.35 / 12)
                            end
                            c:Destroy()
                        else
                            tween:Create(img, TweenInfo.new(0.11), {ImageTransparency = 1}):Play()
                            local c = sample:Clone()
                            c.Parent = btn
                            local x, y = (ms.X - c.AbsolutePosition.X), (ms.Y - c.AbsolutePosition.Y)
                            c.Position = UDim2.new(0, x, 0, y)
                            local size = btn.AbsoluteSize.X >= btn.AbsoluteSize.Y and (btn.AbsoluteSize.X * 1.5) or (btn.AbsoluteSize.Y * 1.5)
                            c:TweenSizeAndPosition(UDim2.new(0, size, 0, size), UDim2.new(0.5, -size/2, 0.5, -size/2), 'Out', 'Quad', 0.35, true, nil)
                            for i = 1, 10 do
                                c.ImageTransparency = c.ImageTransparency + 0.05
                                task.wait(0.35 / 12)
                            end
                            c:Destroy()
                        end
                        toggled = not toggled
                        pcall(callback, toggled)
                    else
                        for _, v in pairs(infoContainer:GetChildren()) do
                            Utility:TweenObject(v, {Position = UDim2.new(0, 0, 2, 0)}, 0.2)
                            focusing = false
                        end
                        Utility:TweenObject(blurFrame, {BackgroundTransparency = 1}, 0.2)
                    end
                end)
                AddConnection(clickConn)
                
                local enterConn = btn.MouseEnter:Connect(function()
                    if not focusing then
                        tween:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(themeList.ElementColor.R * 255 + 8, themeList.ElementColor.G * 255 + 9, themeList.ElementColor.B * 255 + 10)}):Play()
                        isHovering = true
                    end
                end)
                AddConnection(enterConn)
                
                local leaveConn = btn.MouseLeave:Connect(function()
                    if not focusing then
                        tween:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = themeList.ElementColor}):Play()
                        isHovering = false
                    end
                end)
                AddConnection(leaveConn)
                
                local viewConn = viewInfo.MouseButton1Click:Connect(function()
                    if not viewDe then
                        viewDe = true
                        focusing = true
                        for _, v in pairs(infoContainer:GetChildren()) do
                            if v ~= moreInfo then
                                Utility:TweenObject(v, {Position = UDim2.new(0, 0, 2, 0)}, 0.2)
                            end
                        end
                        Utility:TweenObject(moreInfo, {Position = UDim2.new(0, 0, 0, 0)}, 0.2)
                        Utility:TweenObject(blurFrame, {BackgroundTransparency = 0.5}, 0.2)
                        Utility:TweenObject(btn, {BackgroundColor3 = themeList.ElementColor}, 0.2)
                        task.wait(1.5)
                        focusing = false
                        Utility:TweenObject(moreInfo, {Position = UDim2.new(0, 0, 2, 0)}, 0.2)
                        Utility:TweenObject(blurFrame, {BackgroundTransparency = 1}, 0.2)
                        viewDe = false
                    end
                end)
                AddConnection(viewConn)
                
                local elementUpdater = AddThread({active = true, thread = task.spawn(function()
                    while elementUpdater.active do
                        task.wait()
                        if not isHovering then
                            toggleElement.BackgroundColor3 = themeList.ElementColor
                        end
                        toggleDisabled.ImageColor3 = themeList.SchemeColor
                        toggleEnabled.ImageColor3 = themeList.SchemeColor
                        togName.TextColor3 = themeList.TextColor
                        viewInfo.ImageColor3 = themeList.SchemeColor
                        Sample.ImageColor3 = themeList.SchemeColor
                        moreInfo.BackgroundColor3 = Color3.fromRGB(themeList.SchemeColor.R * 255 - 14, themeList.SchemeColor.G * 255 - 17, themeList.SchemeColor.B * 255 - 13)
                        moreInfo.TextColor3 = themeList.TextColor
                    end
                end)})
                
                local TogFunction = {}
                function TogFunction:UpdateToggle(newText, isTogOn)
                    if newText then
                        togName.Text = newText
                    end
                    if isTogOn ~= nil then
                        toggled = isTogOn
                        if toggled then
                            tween:Create(img, TweenInfo.new(0.11), {ImageTransparency = 0}):Play()
                        else
                            tween:Create(img, TweenInfo.new(0.11), {ImageTransparency = 1}):Play()
                        end
                        pcall(callback, toggled)
                    end
                end
                return TogFunction
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
                local UIListLayout = Instance.new("UIListLayout")
                local sliderDrag = Instance.new("Frame")
                local sliderDragCorner = Instance.new("UICorner")
                local write = Instance.new("ImageLabel")
                local val = Instance.new("TextLabel")
                
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
                sliderBtn.BackgroundColor3 = Color3.fromRGB(themeList.ElementColor.R * 255 + 5, themeList.ElementColor.G * 255 + 5, themeList.ElementColor.B * 255 + 5)
                sliderBtn.BorderSizePixel = 0
                sliderBtn.Position = UDim2.new(0.48875, 0, 0.39394, 0)
                sliderBtn.Size = UDim2.new(0, 149, 0, 6)
                sliderBtn.AutoButtonColor = false
                sliderBtn.Font = Enum.Font.FredokaOne
                sliderBtn.Text = ""
                sliderBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
                sliderBtn.TextSize = 14
                
                sliderBtnCorner.Parent = sliderBtn
                
                UIListLayout.Parent = sliderBtn
                UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
                UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
                
                sliderDrag.Name = "sliderDrag"
                sliderDrag.Parent = sliderBtn
                sliderDrag.BackgroundColor3 = themeList.SchemeColor
                sliderDrag.BorderColor3 = Color3.fromRGB(74, 99, 135)
                sliderDrag.BorderSizePixel = 0
                sliderDrag.Size = UDim2.new(-0.67114, 100, 1, 0)
                
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
                val.Text = minvalue
                val.TextColor3 = themeList.TextColor
                val.TextSize = 14
                val.TextTransparency = 1
                val.TextXAlignment = Enum.TextXAlignment.Right
                
                local moreInfo = Instance.new("TextLabel")
                local moreInfoCorner = Instance.new("UICorner")
                
                moreInfo.Name = "TipMore"
                moreInfo.Parent = infoContainer
                moreInfo.BackgroundColor3 = Color3.fromRGB(themeList.SchemeColor.R * 255 - 14, themeList.SchemeColor.G * 255 - 17, themeList.SchemeColor.B * 255 - 13)
                moreInfo.Position = UDim2.new(0, 0, 2, 0)
                moreInfo.Size = UDim2.new(0, 353, 0, 33)
                moreInfo.ZIndex = 9
                moreInfo.Font = Enum.Font.FredokaOne
                moreInfo.Text = "  " .. slidTip
                moreInfo.TextColor3 = themeList.TextColor
                moreInfo.TextSize = 14
                moreInfo.RichText = true
                moreInfo.TextXAlignment = Enum.TextXAlignment.Left
                
                moreInfoCorner.CornerRadius = UDim.new(0, 4)
                moreInfoCorner.Parent = moreInfo
                
                updateSectionFrame()
                UpdateSize()
                
                local mouse = game.Players.LocalPlayer:GetMouse()
                local uis = game:GetService("UserInputService")
                local btn = sliderElement
                local isHovering = false
                local moveconnection = nil
                local releaseconnection = nil
                
                local enterConn = btn.MouseEnter:Connect(function()
                    if not focusing then
                        tween:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(themeList.ElementColor.R * 255 + 8, themeList.ElementColor.G * 255 + 9, themeList.ElementColor.B * 255 + 10)}):Play()
                        isHovering = true
                    end
                end)
                AddConnection(enterConn)
                
                local leaveConn = btn.MouseLeave:Connect(function()
                    if not focusing then
                        tween:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = themeList.ElementColor}):Play()
                        isHovering = false
                    end
                end)
                AddConnection(leaveConn)
                
                local elementUpdater = AddThread({active = true, thread = task.spawn(function()
                    while elementUpdater.active do
                        task.wait()
                        if not isHovering then
                            sliderElement.BackgroundColor3 = themeList.ElementColor
                        end
                        moreInfo.TextColor3 = themeList.TextColor
                        moreInfo.BackgroundColor3 = Color3.fromRGB(themeList.SchemeColor.R * 255 - 14, themeList.SchemeColor.G * 255 - 17, themeList.SchemeColor.B * 255 - 13)
                        val.TextColor3 = themeList.TextColor
                        write.ImageColor3 = themeList.SchemeColor
                        togName.TextColor3 = themeList.TextColor
                        viewInfo.ImageColor3 = themeList.SchemeColor
                        sliderBtn.BackgroundColor3 = Color3.fromRGB(themeList.ElementColor.R * 255 + 5, themeList.ElementColor.G * 255 + 5, themeList.ElementColor.B * 255 + 5)
                        sliderDrag.BackgroundColor3 = themeList.SchemeColor
                    end
                end)})
                
                local Value
                local sliderDownConn = sliderBtn.MouseButton1Down:Connect(function()
                    if not focusing then
                        tween:Create(val, TweenInfo.new(0.1), {TextTransparency = 0}):Play()
                        Value = math.floor((((maxvalue - minvalue) / 149) * sliderDrag.AbsoluteSize.X) + minvalue)
                        pcall(callback, Value)
                        sliderDrag:TweenSize(UDim2.new(0, math.clamp(mouse.X - sliderDrag.AbsolutePosition.X, 0, 149), 0, 6), "InOut", "Linear", 0.05, true)
                        moveconnection = mouse.Move:Connect(function()
                            val.Text = Value
                            Value = math.floor((((maxvalue - minvalue) / 149) * sliderDrag.AbsoluteSize.X) + minvalue)
                            pcall(callback, Value)
                            sliderDrag:TweenSize(UDim2.new(0, math.clamp(mouse.X - sliderDrag.AbsolutePosition.X, 0, 149), 0, 6), "InOut", "Linear", 0.05, true)
                        end)
                        AddConnection(moveconnection)
                        releaseconnection = uis.InputEnded:Connect(function(input)
                            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                                Value = math.floor((((maxvalue - minvalue) / 149) * sliderDrag.AbsoluteSize.X) + minvalue)
                                pcall(callback, Value)
                                val.Text = Value
                                tween:Create(val, TweenInfo.new(0.1), {TextTransparency = 1}):Play()
                                sliderDrag:TweenSize(UDim2.new(0, math.clamp(mouse.X - sliderDrag.AbsolutePosition.X, 0, 149), 0, 6), "InOut", "Linear", 0.05, true)
                                if moveconnection then moveconnection:Disconnect() end
                                if releaseconnection then releaseconnection:Disconnect() end
                            end
                        end)
                        AddConnection(releaseconnection)
                    else
                        for _, v in pairs(infoContainer:GetChildren()) do
                            Utility:TweenObject(v, {Position = UDim2.new(0, 0, 2, 0)}, 0.2)
                            focusing = false
                        end
                        Utility:TweenObject(blurFrame, {BackgroundTransparency = 1}, 0.2)
                    end
                end)
                AddConnection(sliderDownConn)
                
                local viewConn = viewInfo.MouseButton1Click:Connect(function()
                    if not viewDe then
                        viewDe = true
                        focusing = true
                        for _, v in pairs(infoContainer:GetChildren()) do
                            if v ~= moreInfo then
                                Utility:TweenObject(v, {Position = UDim2.new(0, 0, 2, 0)}, 0.2)
                            end
                        end
                        Utility:TweenObject(moreInfo, {Position = UDim2.new(0, 0, 0, 0)}, 0.2)
                        Utility:TweenObject(blurFrame, {BackgroundTransparency = 0.5}, 0.2)
                        Utility:TweenObject(btn, {BackgroundColor3 = themeList.ElementColor}, 0.2)
                        task.wait(1.5)
                        focusing = false
                        Utility:TweenObject(moreInfo, {Position = UDim2.new(0, 0, 2, 0)}, 0.2)
                        Utility:TweenObject(blurFrame, {BackgroundTransparency = 1}, 0.2)
                        viewDe = false
                    end
                end)
                AddConnection(viewConn)
            end
            
            function Elements:NewDropdown(dropname, dropinf, list, callback)
                local DropFunction = {}
                dropname = dropname or "Dropdown"
                list = list or {}
                dropinf = dropinf or "Dropdown info"
                callback = callback or function() end
                
                local opened = false
                local DropYSize = 33
                
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
                            local c = sample:Clone()
                            c.Parent = btn
                            local x, y = (ms.X - c.AbsolutePosition.X), (ms.Y - c.AbsolutePosition.Y)
                            c.Position = UDim2.new(0, x, 0, y)
                            local size = btn.AbsoluteSize.X >= btn.AbsoluteSize.Y and (btn.AbsoluteSize.X * 1.5) or (btn.AbsoluteSize.Y * 1.5)
                            c:TweenSizeAndPosition(UDim2.new(0, size, 0, size), UDim2.new(0.5, -size/2, 0.5, -size/2), 'Out', 'Quad', 0.35, true, nil)
                            for i = 1, 10 do
                                c.ImageTransparency = c.ImageTransparency + 0.05
                                task.wait(0.35 / 12)
                            end
                            c:Destroy()
                        else
                            opened = true
                            dropFrame:TweenSize(UDim2.new(0, 352, 0, UIListLayout.AbsoluteContentSize.Y), "InOut", "Linear", 0.08, true)
                            task.wait(0.1)
                            updateSectionFrame()
                            UpdateSize()
                            local c = sample:Clone()
                            c.Parent = btn
                            local x, y = (ms.X - c.AbsolutePosition.X), (ms.Y - c.AbsolutePosition.Y)
                            c.Position = UDim2.new(0, x, 0, y)
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
                            Utility:TweenObject(v, {Position = UDim2.new(0, 0, 2, 0)}, 0.2)
                            focusing = false
                        end
                        Utility:TweenObject(blurFrame, {BackgroundTransparency = 1}, 0.2)
                    end                end)
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
                moreInfo.BackgroundColor3 = Color3.fromRGB(themeList.SchemeColor.R * 255 - 14, themeList.SchemeColor.G * 255 - 17, themeList.SchemeColor.B * 255 - 13)
                moreInfo.Position = UDim2.new(0, 0, 2, 0)
                moreInfo.Size = UDim2.new(0, 353, 0, 33)
                moreInfo.ZIndex = 9
                moreInfo.RichText = true
                moreInfo.Font = Enum.Font.FredokaOne
                moreInfo.Text = "  " .. dropinf
                moreInfo.TextColor3 = themeList.TextColor
                moreInfo.TextSize = 14
                moreInfo.TextXAlignment = Enum.TextXAlignment.Left
                
                moreInfoCorner.CornerRadius = UDim.new(0, 4)
                moreInfoCorner.Parent = moreInfo
                
                local isHovering = false
                
                local enterConn = dropOpen.MouseEnter:Connect(function()
                    if not focusing then
                        tween:Create(dropOpen, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(themeList.ElementColor.R * 255 + 8, themeList.ElementColor.G * 255 + 9, themeList.ElementColor.B * 255 + 10)}):Play()
                        isHovering = true
                    end
                end)
                AddConnection(enterConn)
                
                local leaveConn = dropOpen.MouseLeave:Connect(function()
                    if not focusing then
                        tween:Create(dropOpen, TweenInfo.new(0.1), {BackgroundColor3 = themeList.ElementColor}):Play()
                        isHovering = false
                    end
                end)
                AddConnection(leaveConn)
                
                local viewConn = viewInfo.MouseButton1Click:Connect(function()
                    if not viewDe then
                        viewDe = true
                        focusing = true
                        for _, v in pairs(infoContainer:GetChildren()) do
                            if v ~= moreInfo then
                                Utility:TweenObject(v, {Position = UDim2.new(0, 0, 2, 0)}, 0.2)
                            end
                        end
                        Utility:TweenObject(moreInfo, {Position = UDim2.new(0, 0, 0, 0)}, 0.2)
                        Utility:TweenObject(blurFrame, {BackgroundTransparency = 0.5}, 0.2)
                        Utility:TweenObject(dropOpen, {BackgroundColor3 = themeList.ElementColor}, 0.2)
                        task.wait(1.5)
                        focusing = false
                        Utility:TweenObject(moreInfo, {Position = UDim2.new(0, 0, 2, 0)}, 0.2)
                        Utility:TweenObject(blurFrame, {BackgroundTransparency = 1}, 0.2)
                        viewDe = false
                    end
                end)
                AddConnection(viewConn)
                
                local elementUpdater = AddThread({active = true, thread = task.spawn(function()
                    while elementUpdater.active do
                        task.wait()
                        if not isHovering then
                            dropOpen.BackgroundColor3 = themeList.ElementColor
                        end
                        Sample.ImageColor3 = themeList.SchemeColor
                        dropFrame.BackgroundColor3 = themeList.Background
                        listImg.ImageColor3 = themeList.SchemeColor
                        itemTextbox.TextColor3 = themeList.TextColor
                        viewInfo.ImageColor3 = themeList.SchemeColor
                        moreInfo.BackgroundColor3 = Color3.fromRGB(themeList.SchemeColor.R * 255 - 14, themeList.SchemeColor.G * 255 - 17, themeList.SchemeColor.B * 255 - 13)
                        moreInfo.TextColor3 = themeList.TextColor
                    end
                end)})
                
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
                    DropYSize = DropYSize + 33
                    optionSelect.Name = "optionSelect"
                    optionSelect.Parent = dropFrame
                    optionSelect.BackgroundColor3 = themeList.ElementColor
                    optionSelect.Position = UDim2.new(0, 0, 0.2353, 0)
                    optionSelect.Size = UDim2.new(0, 352, 0, 33)
                    optionSelect.AutoButtonColor = false
                    optionSelect.Font = Enum.Font.FredokaOne
                    optionSelect.Text = "  " .. v
                    optionSelect.TextColor3 = Color3.fromRGB(themeList.TextColor.R * 255 - 6, themeList.TextColor.G * 255 - 6, themeList.TextColor.B * 255 - 6)
                    optionSelect.TextSize = 14
                    optionSelect.TextXAlignment = Enum.TextXAlignment.Left
                    optionSelect.ClipsDescendants = true
                    
                    local optionClickConn = optionSelect.MouseButton1Click:Connect(function()
                        if not focusing then
                            opened = false
                            callback(v)
                            itemTextbox.Text = v
                            dropFrame:TweenSize(UDim2.new(0, 352, 0, 33), 'InOut', 'Linear', 0.08)
                            task.wait(0.1)
                            updateSectionFrame()
                            UpdateSize()
                            local c = sample1:Clone()
                            c.Parent = optionSelect
                            local x, y = (ms.X - c.AbsolutePosition.X), (ms.Y - c.AbsolutePosition.Y)
                            c.Position = UDim2.new(0, x, 0, y)
                            local size = optionSelect.AbsoluteSize.X >= optionSelect.AbsoluteSize.Y and (optionSelect.AbsoluteSize.X * 1.5) or (optionSelect.AbsoluteSize.Y * 1.5)
                            c:TweenSizeAndPosition(UDim2.new(0, size, 0, size), UDim2.new(0.5, -size/2, 0.5, -size/2), 'Out', 'Quad', 0.35, true, nil)
                            for i = 1, 10 do
                                c.ImageTransparency = c.ImageTransparency + 0.05
                                task.wait(0.35 / 12)
                            end
                            c:Destroy()
                        else
                            for _, v in pairs(infoContainer:GetChildren()) do
                                Utility:TweenObject(v, {Position = UDim2.new(0, 0, 2, 0)}, 0.2)
                                focusing = false
                            end
                            Utility:TweenObject(blurFrame, {BackgroundTransparency = 1}, 0.2)
                        end
                    end)
                    AddConnection(optionClickConn)
                    
                    optionCorner.CornerRadius = UDim.new(0, 4)
                    optionCorner.Parent = optionSelect
                    
                    local optHover = false
                    local optEnterConn = optionSelect.MouseEnter:Connect(function()
                        if not focusing then
                            tween:Create(optionSelect, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(themeList.ElementColor.R * 255 + 8, themeList.ElementColor.G * 255 + 9, themeList.ElementColor.B * 255 + 10)}):Play()
                            optHover = true
                        end
                    end)
                    AddConnection(optEnterConn)
                    
                    local optLeaveConn = optionSelect.MouseLeave:Connect(function()
                        if not focusing then
                            tween:Create(optionSelect, TweenInfo.new(0.1), {BackgroundColor3 = themeList.ElementColor}):Play()
                            optHover = false
                        end
                    end)
                    AddConnection(optLeaveConn)
                    
                    local optUpdater = AddThread({active = true, thread = task.spawn(function()
                        while optUpdater.active do
                            task.wait()
                            if not optHover then
                                optionSelect.BackgroundColor3 = themeList.ElementColor
                            end
                            optionSelect.TextColor3 = Color3.fromRGB(themeList.TextColor.R * 255 - 6, themeList.TextColor.G * 255 - 6, themeList.TextColor.B * 255 - 6)
                            Sample1.ImageColor3 = themeList.SchemeColor
                        end
                    end)})
                end
                
                function DropFunction:Refresh(newList)
                    newList = newList or {}
                    for i, v in pairs(dropFrame:GetChildren()) do
                        if v.Name == "optionSelect" then
                            v:Destroy()
                        end
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
                        DropYSize = DropYSize + 33
                        optionSelect.Name = "optionSelect"
                        optionSelect.Parent = dropFrame
                        optionSelect.BackgroundColor3 = themeList.ElementColor
                        optionSelect.Position = UDim2.new(0, 0, 0.2353, 0)
                        optionSelect.Size = UDim2.new(0, 352, 0, 33)
                        optionSelect.AutoButtonColor = false
                        optionSelect.Font = Enum.Font.FredokaOne
                        optionSelect.Text = "  " .. v
                        optionSelect.TextColor3 = Color3.fromRGB(themeList.TextColor.R * 255 - 6, themeList.TextColor.G * 255 - 6, themeList.TextColor.B * 255 - 6)
                        optionSelect.TextSize = 14
                        optionSelect.TextXAlignment = Enum.TextXAlignment.Left
                        optionSelect.ClipsDescendants = true
                        optionCorner.CornerRadius = UDim.new(0, 4)
                        optionCorner.Parent = optionSelect
                        
                        local optClickConn = optionSelect.MouseButton1Click:Connect(function()
                            if not focusing then
                                opened = false
                                callback(v)
                                itemTextbox.Text = v
                                dropFrame:TweenSize(UDim2.new(0, 352, 0, 33), 'InOut', 'Linear', 0.08)
                                task.wait(0.1)
                                updateSectionFrame()
                                UpdateSize()
                                local c = sample11:Clone()
                                c.Parent = optionSelect
                                local x, y = (ms.X - c.AbsolutePosition.X), (ms.Y - c.AbsolutePosition.Y)
                                c.Position = UDim2.new(0, x, 0, y)
                                local size = optionSelect.AbsoluteSize.X >= optionSelect.AbsoluteSize.Y and (optionSelect.AbsoluteSize.X * 1.5) or (optionSelect.AbsoluteSize.Y * 1.5)
                                c:TweenSizeAndPosition(UDim2.new(0, size, 0, size), UDim2.new(0.5, -size/2, 0.5, -size/2), 'Out', 'Quad', 0.35, true, nil)
                                for i = 1, 10 do
                                    c.ImageTransparency = c.ImageTransparency + 0.05
                                    task.wait(0.35 / 12)
                                end
                                c:Destroy()
                            else
                                for _, v in pairs(infoContainer:GetChildren()) do
                                    Utility:TweenObject(v, {Position = UDim2.new(0, 0, 2, 0)}, 0.2)
                                    focusing = false
                                end
                                Utility:TweenObject(blurFrame, {BackgroundTransparency = 1}, 0.2)
                            end
                        end)
                        AddConnection(optClickConn)
                        
                        local optHover = false
                        local optEnterConn = optionSelect.MouseEnter:Connect(function()
                            if not focusing then
                                tween:Create(optionSelect, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(themeList.ElementColor.R * 255 + 8, themeList.ElementColor.G * 255 + 9, themeList.ElementColor.B * 255 + 10)}):Play()
                                optHover = true
                            end
                        end)
                        AddConnection(optEnterConn)
                        
                        local optLeaveConn = optionSelect.MouseLeave:Connect(function()
                            if not focusing then
                                tween:Create(optionSelect, TweenInfo.new(0.1), {BackgroundColor3 = themeList.ElementColor}):Play()
                                optHover = false
                            end
                        end)
                        AddConnection(optLeaveConn)
                        
                        local optUpdater = AddThread({active = true, thread = task.spawn(function()
                            while optUpdater.active do
                                task.wait()
                                if not optHover then
                                    optionSelect.BackgroundColor3 = themeList.ElementColor
                                end
                                optionSelect.TextColor3 = Color3.fromRGB(themeList.TextColor.R * 255 - 6, themeList.TextColor.G * 255 - 6, themeList.TextColor.B * 255 - 6)
                                Sample11.ImageColor3 = themeList.SchemeColor
                            end
                        end)})
                    end
                    if opened then
                        dropFrame:TweenSize(UDim2.new(0, 352, 0, UIListLayout.AbsoluteContentSize.Y), "InOut", "Linear", 0.08, true)
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
                        togName_2.Text = ". . ."
                        local inputBegan = uis.InputBegan:Wait()
                        if inputBegan.KeyCode.Name ~= "Unknown" then
                            togName_2.Text = inputBegan.KeyCode.Name
                            oldKey = inputBegan.KeyCode.Name
                        end
                        local c = sample:Clone()
                        c.Parent = keybindElement
                        local x, y = (ms.X - c.AbsolutePosition.X), (ms.Y - c.AbsolutePosition.Y)
                        c.Position = UDim2.new(0, x, 0, y)
                        local size = keybindElement.AbsoluteSize.X >= keybindElement.AbsoluteSize.Y and (keybindElement.AbsoluteSize.X * 1.5) or (keybindElement.AbsoluteSize.Y * 1.5)
                        c:TweenSizeAndPosition(UDim2.new(0, size, 0, size), UDim2.new(0.5, -size/2, 0.5, -size/2), 'Out', 'Quad', 0.35, true, nil)
                        for i = 1, 10 do
                            c.ImageTransparency = c.ImageTransparency + 0.05
                            task.wait(0.35 / 12)
                        end
                        c:Destroy()
                    else
                        for _, v in pairs(infoContainer:GetChildren()) do
                            Utility:TweenObject(v, {Position = UDim2.new(0, 0, 2, 0)}, 0.2)
                            focusing = false
                        end
                        Utility:TweenObject(blurFrame, {BackgroundTransparency = 1}, 0.2)
                    end
                end)
                AddConnection(keybindClickConn)
                
                local inputBeganConn = uis.InputBegan:Connect(function(current, processed)
                    if not processed then
                        if current.KeyCode.Name == oldKey then
                            callback()
                        end
                    end
                end)
                AddConnection(inputBeganConn)
                
                moreInfo.Name = "TipMore"
                moreInfo.Parent = infoContainer
                moreInfo.BackgroundColor3 = Color3.fromRGB(themeList.SchemeColor.R * 255 - 14, themeList.SchemeColor.G * 255 - 17, themeList.SchemeColor.B * 255 - 13)
                moreInfo.Position = UDim2.new(0, 0, 2, 0)
                moreInfo.Size = UDim2.new(0, 353, 0, 33)
                moreInfo.ZIndex = 9
                moreInfo.RichText = true
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
                            if v ~= moreInfo then
                                Utility:TweenObject(v, {Position = UDim2.new(0, 0, 2, 0)}, 0.2)
                            end
                        end
                        Utility:TweenObject(moreInfo, {Position = UDim2.new(0, 0, 0, 0)}, 0.2)
                        Utility:TweenObject(blurFrame, {BackgroundTransparency = 0.5}, 0.2)
                        Utility:TweenObject(keybindElement, {BackgroundColor3 = themeList.ElementColor}, 0.2)
                        task.wait(1.5)
                        focusing = false
                        Utility:TweenObject(moreInfo, {Position = UDim2.new(0, 0, 2, 0)}, 0.2)
                        Utility:TweenObject(blurFrame, {BackgroundTransparency = 1}, 0.2)
                        viewDe = false
                    end
                end)
                AddConnection(viewConn)
                
                updateSectionFrame()
                UpdateSize()
                
                local isHovering = false
                
                local enterConn = keybindElement.MouseEnter:Connect(function()
                    if not focusing then
                        tween:Create(keybindElement, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(themeList.ElementColor.R * 255 + 8, themeList.ElementColor.G * 255 + 9, themeList.ElementColor.B * 255 + 10)}):Play()
                        isHovering = true
                    end
                end)
                AddConnection(enterConn)
                
                local leaveConn = keybindElement.MouseLeave:Connect(function()
                    if not focusing then
                        tween:Create(keybindElement, TweenInfo.new(0.1), {BackgroundColor3 = themeList.ElementColor}):Play()
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
                
                local elementUpdater = AddThread({active = true, thread = task.spawn(function()
                    while elementUpdater.active do
                        task.wait()
                        if not isHovering then
                            keybindElement.BackgroundColor3 = themeList.ElementColor
                        end
                        togName_2.TextColor3 = themeList.SchemeColor
                        touch.ImageColor3 = themeList.SchemeColor
                        viewInfo.ImageColor3 = themeList.SchemeColor
                        togName.TextColor3 = themeList.TextColor
                        Sample.ImageColor3 = themeList.SchemeColor
                        moreInfo.TextColor3 = themeList.TextColor
                        moreInfo.BackgroundColor3 = Color3.fromRGB(themeList.SchemeColor.R * 255 - 14, themeList.SchemeColor.G * 255 - 17, themeList.SchemeColor.B * 255 - 13)
                    end
                end)})
            end
            
            function Elements:NewColorPicker(colText, colInf, defcolor, callback)
                colText = colText or "ColorPicker"
                callback = callback or function() end
                defcolor = defcolor or Color3.fromRGB(255, 255, 255)
                local h, s, v = Color3.toHSV(defcolor)
                local ms = game.Players.LocalPlayer:GetMouse()
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
                colorElement.BackgroundTransparency = 1
                colorElement.ClipsDescendants = true
                colorElement.Size = UDim2.new(0, 352, 0, 33)
                colorElement.AutoButtonColor = false
                colorElement.Font = Enum.Font.FredokaOne
                colorElement.Text = ""
                colorElement.TextColor3 = Color3.fromRGB(0, 0, 0)
                colorElement.TextSize = 14
                
                local colorClickConn = colorElement.MouseButton1Click:Connect(function()
                    if not focusing then
                        if colorOpened then
                            colorOpened = false
                            colorElement:TweenSize(UDim2.new(0, 352, 0, 33), "InOut", "Linear", 0.08)
                            task.wait(0.1)
                            updateSectionFrame()
                            UpdateSize()
                            local c = sample:Clone()
                            c.Parent = btn
                            local x, y = (ms.X - c.AbsolutePosition.X), (ms.Y - c.AbsolutePosition.Y)
                            c.Position = UDim2.new(0, x, 0, y)
                            local size = btn.AbsoluteSize.X >= btn.AbsoluteSize.Y and (btn.AbsoluteSize.X * 1.5) or (btn.AbsoluteSize.Y * 1.5)
                            c:TweenSizeAndPosition(UDim2.new(0, size, 0, size), UDim2.new(0.5, -size/2, 0.5, -size/2), 'Out', 'Quad', 0.35, true, nil)
                            for i = 1, 10 do
                                c.ImageTransparency = c.ImageTransparency + 0.05
                                task.wait(0.35 / 12)
                            end
                            c:Destroy()
                        else
                            colorOpened = true
                            colorElement:TweenSize(UDim2.new(0, 352, 0, 141), "InOut", "Linear", 0.08, true)
                            task.wait(0.1)
                            updateSectionFrame()
                            UpdateSize()
                            local c = sample:Clone()
                            c.Parent = btn
                            local x, y = (ms.X - c.AbsolutePosition.X), (ms.Y - c.AbsolutePosition.Y)
                            c.Position = UDim2.new(0, x, 0, y)
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
                            Utility:TweenObject(v, {Position = UDim2.new(0, 0, 2, 0)}, 0.2)
                            focusing = false
                        end
                        Utility:TweenObject(blurFrame, {BackgroundTransparency = 1}, 0.2)
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
                moreInfo.BackgroundColor3 = Color3.fromRGB(themeList.SchemeColor.R * 255 - 14, themeList.SchemeColor.G * 255 - 17, themeList.SchemeColor.B * 255 - 13)
                moreInfo.Position = UDim2.new(0, 0, 2, 0)
                moreInfo.Size = UDim2.new(0, 353, 0, 33)
                moreInfo.ZIndex = 9
                moreInfo.Font = Enum.Font.FredokaOne
                moreInfo.Text = "  " .. colInf
                moreInfo.TextColor3 = themeList.TextColor
                moreInfo.TextSize = 14
                moreInfo.RichText = true
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
                
                local plr = game.Players.LocalPlayer
                local mouse = plr:GetMouse()
                local uis = game:GetService("UserInputService")
                local rs = game:GetService("RunService")
                local colorpicker = false
                local darknesss = false
                local dark = darkness
                local cursor = rbgcircle
                local cursor2 = darkcircle
                local color = {1, 1, 1}
                local rainbow = false
                local rainbowconnection
                local counter = 0
                
                local function zigzag(X)
                    return math.acos(math.cos(X * math.pi)) / math.pi
                end
                
                local function mouseLocation()
                    return plr:GetMouse()
                end
                
                local function cp()
                    if colorpicker then
                        local ml = mouseLocation()
                        local x, y = ml.X - rgb.AbsolutePosition.X, ml.Y - rgb.AbsolutePosition.Y
                        local maxX, maxY = rgb.AbsoluteSize.X, rgb.AbsoluteSize.Y
                        if x < 0 then x = 0 end
                        if x > maxX then x = maxX end
                        if y < 0 then y = 0 end
                        if y > maxY then y = maxY end
                        x = x / maxX
                        y = y / maxY
                        local cx = cursor.AbsoluteSize.X / 2
                        local cy = cursor.AbsoluteSize.Y / 2
                        cursor.Position = UDim2.new(x, -cx, y, -cy)
                        color = {1 - x, 1 - y, color[3]}
                        local realcolor = Color3.fromHSV(color[1], color[2], color[3])
                        colorCurrent.BackgroundColor3 = realcolor
                        callback(realcolor)
                    end
                    if darknesss then
                        local ml = mouseLocation()
                        local y = ml.Y - dark.AbsolutePosition.Y
                        local maxY = dark.AbsoluteSize.Y
                        if y < 0 then y = 0 end
                        if y > maxY then y = maxY end
                        y = y / maxY
                        local cy = cursor2.AbsoluteSize.Y / 2
                        cursor2.Position = UDim2.new(0.5, 0, y, -cy)
                        cursor2.ImageColor3 = Color3.fromHSV(0, 0, y)
                        color = {color[1], color[2], 1 - y}
                        local realcolor = Color3.fromHSV(color[1], color[2], color[3])
                        colorCurrent.BackgroundColor3 = realcolor
                        callback(realcolor)
                    end
                end
                
                local function setcolor(tbl)
                    local cx = cursor.AbsoluteSize.X / 2
                    local cy = cursor.AbsoluteSize.Y / 2
                    color = {tbl[1], tbl[2], tbl[3]}
                    cursor.Position = UDim2.new(color[1], -cx, color[2] - 1, -cy)
                    cursor2.Position = UDim2.new(0.5, 0, color[3] - 1, -cy)
                    local realcolor = Color3.fromHSV(color[1], color[2], color[3])
                    colorCurrent.BackgroundColor3 = realcolor
                end
                
                local function setrgbcolor(tbl)
                    local cx = cursor.AbsoluteSize.X / 2
                    local cy = cursor.AbsoluteSize.Y / 2
                    color = {tbl[1], tbl[2], color[3]}
                    cursor.Position = UDim2.new(color[1], -cx, color[2] - 1, -cy)
                    local realcolor = Color3.fromHSV(color[1], color[2], color[3])
                    colorCurrent.BackgroundColor3 = realcolor
                    callback(realcolor)
                end
                
                local function togglerainbow()
                    if rainbow then
                        tween:Create(toggleEnabled, TweenInfo.new(0.1), {ImageTransparency = 1}):Play()
                        rainbow = false
                        if rainbowconnection then
                            rainbowconnection:Disconnect()
                        end
                    else
                        tween:Create(toggleEnabled, TweenInfo.new(0.1), {ImageTransparency = 0}):Play()
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
                
                local mouseMoveConn = mouse.Move:Connect(cp)
                AddConnection(mouseMoveConn)
                
                local rgbDownConn = rgb.MouseButton1Down:Connect(function()
                    colorpicker = true
                end)
                AddConnection(rgbDownConn)
                
                local darkDownConn = dark.MouseButton1Down:Connect(function()
                    darknesss = true
                end)
                AddConnection(darkDownConn)
                
                local inputEndedConn = uis.InputEnded:Connect(function(input)
                    if input.UserInputType.Name == 'MouseButton1' then
                        if darknesss then darknesss = false end
                        if colorpicker then colorpicker = false end
                    end
                end)
                AddConnection(inputEndedConn)
                
                local viewConn = viewInfo.MouseButton1Click:Connect(function()
                    if not viewDe then
                        viewDe = true
                        focusing = true
                        for _, v in pairs(infoContainer:GetChildren()) do
                            if v ~= moreInfo then
                                Utility:TweenObject(v, {Position = UDim2.new(0, 0, 2, 0)}, 0.2)
                            end
                        end
                        Utility:TweenObject(moreInfo, {Position = UDim2.new(0, 0, 0, 0)}, 0.2)
                        Utility:TweenObject(blurFrame, {BackgroundTransparency = 0.5}, 0.2)
                        Utility:TweenObject(colorElement, {BackgroundColor3 = themeList.ElementColor}, 0.2)
                        task.wait(1.5)
                        focusing = false
                        Utility:TweenObject(moreInfo, {Position = UDim2.new(0, 0, 2, 0)}, 0.2)
                        Utility:TweenObject(blurFrame, {BackgroundTransparency = 1}, 0.2)
                        viewDe = false
                    end
                end)
                AddConnection(viewConn)
                
                local isHovering = false
                
                local enterConn = colorElement.MouseEnter:Connect(function()
                    if not focusing then
                        tween:Create(colorElement, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(themeList.ElementColor.R * 255 + 8, themeList.ElementColor.G * 255 + 9, themeList.ElementColor.B * 255 + 10)}):Play()
                        isHovering = true
                    end
                end)
                AddConnection(enterConn)
                
                local leaveConn = colorElement.MouseLeave:Connect(function()
                    if not focusing then
                        tween:Create(colorElement, TweenInfo.new(0.1), {BackgroundColor3 = themeList.ElementColor}):Play()
                        isHovering = false
                    end
                end)
                AddConnection(leaveConn)
                
                local elementUpdater = AddThread({active = true, thread = task.spawn(function()
                    while elementUpdater.active do
                        task.wait()
                        if not isHovering then
                            colorElement.BackgroundColor3 = themeList.ElementColor
                        end
                        touch.ImageColor3 = themeList.SchemeColor
                        colorHeader.BackgroundColor3 = themeList.ElementColor
                        togName.TextColor3 = themeList.TextColor
                        moreInfo.BackgroundColor3 = Color3.fromRGB(themeList.SchemeColor.R * 255 - 14, themeList.SchemeColor.G * 255 - 17, themeList.SchemeColor.B * 255 - 13)
                        moreInfo.TextColor3 = themeList.TextColor
                        viewInfo.ImageColor3 = themeList.SchemeColor
                        colorInners.BackgroundColor3 = themeList.ElementColor
                        toggleDisabled.ImageColor3 = themeList.SchemeColor
                        toggleEnabled.ImageColor3 = themeList.SchemeColor
                        rainbowLabel.TextColor3 = themeList.TextColor
                        Sample.ImageColor3 = themeList.SchemeColor
                    end
                end)})
                
                setcolor({h, s, v})
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
                
                local labelUpdater = AddThread({active = true, thread = task.spawn(function()
                    while labelUpdater.active do
                        task.wait()
                        label.BackgroundColor3 = themeList.SchemeColor
                        label.TextColor3 = themeList.TextColor
                    end
                end)})
                
                local labelFunc = {}
                function labelFunc:UpdateLabel(newText)
                    if label.Text ~= "  " .. newText then
                        label.Text = "  " .. newText
                    end
                end
                return labelFunc
            end
            
            return Elements
        end
        return Sections
    end
    return Tabs
end

return SpecialUI
