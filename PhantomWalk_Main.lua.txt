-- ==========================================
-- PHANTOMWALK PRO | V1.8.8 (COMMERCIAL EDITION)
-- Developer: Kucing garong 😼
-- Theme: Solid Dark Purple + Spider Web Overlay (Video Accurate)
-- Feature: Absolute POV Camera, Analog Override, Obstacle Stop
-- Exclusive: Teleport Hub, Fly Mode, Copy Avatar, Reverse, el mundur
-- Patch: Restored V1.8.1 Solid UI Backing, Pastel Purple Sliders, Fire Minimize
-- ==========================================
local players = game:GetService("Players")
local runService = game:GetService("RunService")
local coreGui = game:GetService("CoreGui")
local tweenService = game:GetService("TweenService")
local httpService = game:GetService("HttpService")
local uis = game:GetService("UserInputService")
local workspace = game:GetService("Workspace")

local player = players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- ==========================================
-- DATABASE & FILE SYSTEM
-- ==========================================
local savedPaths = {} 
local savedWaypoints = {} 
local fileNamesToTry = {"CaptainErr_Autowalk_Paths.json", "PhantomWalk_Pro_Data.json"}

local function serializeFrames(fToSer)
    local s = {}
    for _, f in ipairs(fToSer) do
        table.insert(s, {Time = f.Time, MoveDir = {X = f.MoveDir.X, Y = f.MoveDir.Y, Z = f.MoveDir.Z}, Pos = {X = f.Pos.X, Y = f.Pos.Y, Z = f.Pos.Z}, Look = {X = f.Look.X, Y = f.Look.Y, Z = f.Look.Z}, Jump = f.Jump})
    end return s
end

local function deserializeFrames(s)
    local d = {}
    for _, f in ipairs(s) do
        if f.Time and f.Pos then
            table.insert(d, {Time = f.Time, MoveDir = Vector3.new(f.MoveDir.X, f.MoveDir.Y, f.MoveDir.Z), Pos = Vector3.new(f.Pos.X, f.Pos.Y, f.Pos.Z), Look = Vector3.new(f.Look.X, f.Look.Y, f.Look.Z), Jump = f.Jump})
        end
    end return d
end

local function saveToFile()
    pcall(function()
        if writefile then
            local data = { Paths = {}, Waypoints = {} }
            for n, d in pairs(savedPaths) do data.Paths[n] = serializeFrames(d) end
            for _, wp in ipairs(savedWaypoints) do table.insert(data.Waypoints, {Name = wp.Name, Pos = {X = wp.Pos.X, Y = wp.Pos.Y, Z = wp.Pos.Z}}) end
            writefile("PhantomWalk_Pro_Data.json", httpService:JSONEncode(data))
        end
    end)
end

local function loadFromFile()
    for _, fname in ipairs(fileNamesToTry) do
        pcall(function()
            if readfile and isfile and isfile(fname) then
                local data = httpService:JSONDecode(readfile(fname))
                if data.Paths then
                    for n, d in pairs(data.Paths) do savedPaths[n] = deserializeFrames(d) end
                    if data.Waypoints then
                        for _, wp in ipairs(data.Waypoints) do table.insert(savedWaypoints, {Name = wp.Name, Pos = Vector3.new(wp.Pos.X, wp.Pos.Y, wp.Pos.Z)}) end
                    end
                else
                    for n, d in pairs(data) do 
                        if type(d) == "table" and #d > 0 then savedPaths[n] = deserializeFrames(d) end
                    end
                end
            end
        end)
    end
end
loadFromFile()

local function getFreshCharacter()
    character = player.Character or player.CharacterAdded:Wait()
    if character then
        humanoid = character:FindFirstChild("Humanoid") or character:WaitForChild("Humanoid", 2)
        rootPart = character:FindFirstChild("HumanoidRootPart") or character:WaitForChild("HumanoidRootPart", 2)
    end
end

-- VARIABEL CORE 
local frames = {}
local isRecording, isPlaying, isUndoing = false, false, false
local recordConn, playConn, jumpEvent, tpLoopTask, flyConn, parachuteConn
local recordStartTime = 0 
local isVisualizerOn = false 
local currentPathColor = Color3.fromRGB(150, 230, 255) 
local isAntiFallOn = false 
local isWalkBackwards = false 
local isReversePlay = false 
local isLoopingTP = false 
local isSpeedSuper = false 
local isDraggingFly = false

-- Variabel Fly Mode
local isFlying = false
local flySpeed = 50

local SPIDER_WEB_BG = "rbxthumb://type=Asset&id=122843202332263&w=420&h=420"
local originalMouseLock = player.DevEnableMouseLock

local function togglePlayerControls(enable)
    pcall(function()
        local pm = require(player.PlayerScripts:WaitForChild("PlayerModule")):GetControls()
        if enable then pm:Enable() player.DevEnableMouseLock = originalMouseLock
        else pm:Disable() originalMouseLock = player.DevEnableMouseLock player.DevEnableMouseLock = false end
    end)
end

local function isTryingToMoveAnalog()
    local success, moveVec = pcall(function() return require(player.PlayerScripts:WaitForChild("PlayerModule")):GetControls():GetMoveVector() end)
    return (success and moveVec and moveVec.Magnitude > 0)
end

local function setCFrameWithCameraPOV(targetCFrame)
    local cam = workspace.CurrentCamera
    local relCam = rootPart.CFrame:ToObjectSpace(cam.CFrame)
    character:PivotTo(targetCFrame)
    cam.CFrame = rootPart.CFrame:ToWorldSpace(relCam)
end

-- ==========================================
-- UI SYSTEM (CLEAN SOLID V1.8.1 THEME)
-- ==========================================
local guiName = "PhantomWalkPro"
if coreGui:FindFirstChild(guiName) then coreGui[guiName]:Destroy() end

local sg = Instance.new("ScreenGui", coreGui)
sg.Name = guiName
local colorWhite = Color3.fromRGB(255, 255, 255)
local colorDark = Color3.fromRGB(15, 10, 20)
local sliderFillColor = Color3.fromRGB(160, 110, 220) -- Ungu pastel

-- PANEL MINIMIZE (FIRE PHANTOM BUNDAR)
local minMenu = Instance.new("ImageButton", sg)
minMenu.Size = UDim2.new(0, 60, 0, 60)
minMenu.Position = UDim2.new(0.5, -30, 0, 15)
minMenu.BackgroundColor3 = Color3.fromRGB(20, 10, 15)
minMenu.Image = SPIDER_WEB_BG
minMenu.ImageTransparency = 0.3
minMenu.Visible = false
minMenu.Draggable = true
Instance.new("UICorner", minMenu).CornerRadius = UDim.new(1, 0) 

local minStroke = Instance.new("UIStroke", minMenu)
minStroke.Color = Color3.fromRGB(255, 50, 0)
minStroke.Thickness = 2

local fireGradient = Instance.new("UIGradient", minMenu)
fireGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 30, 0)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 120, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 220, 0))
})
fireGradient.Rotation = -45

local minText = Instance.new("TextLabel", minMenu)
minText.Size = UDim2.new(1, 0, 1, 0)
minText.BackgroundTransparency = 1
minText.Text = "Phantom"
minText.TextColor3 = colorWhite
minText.Font = Enum.Font.GothamBold
minText.TextSize = 11
minText.TextStrokeTransparency = 0.2
minText.TextStrokeColor3 = Color3.fromRGB(20, 0, 0)

-- MAIN FRAME (SOLID DARK BACKGROUND SEPERTI DI V1.8.1)
local mainFrame = Instance.new("Frame", sg)
mainFrame.Size = UDim2.new(0, 600, 0, 350)
mainFrame.Position = UDim2.new(0.5, -300, 0.5, -175)
mainFrame.BackgroundColor3 = colorDark 
mainFrame.BackgroundTransparency = 0 -- SOLID
mainFrame.Active = true 
mainFrame.Draggable = true
mainFrame.ClipsDescendants = true
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)

local bgImage = Instance.new("ImageLabel", mainFrame)
bgImage.Size = UDim2.new(1, 0, 1, 0)
bgImage.BackgroundTransparency = 1
bgImage.Image = SPIDER_WEB_BG
bgImage.ScaleType = Enum.ScaleType.Crop
bgImage.ImageTransparency = 0.65 -- Default transparency laba-laba

local titleLabel = Instance.new("TextLabel", mainFrame)
titleLabel.Size = UDim2.new(1, -50, 0, 40)
titleLabel.Position = UDim2.new(0, 20, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "PhantomWalk Pro | V1.8.8"
titleLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 16
titleLabel.TextXAlignment = Enum.TextXAlignment.Left

local btnMinimize = Instance.new("TextButton", mainFrame)
btnMinimize.Size = UDim2.new(0, 30, 0, 30)
btnMinimize.Position = UDim2.new(1, -40, 0, 5)
btnMinimize.BackgroundColor3 = Color3.fromRGB(50, 20, 60)
btnMinimize.Text = "-"
btnMinimize.TextColor3 = colorWhite
btnMinimize.Font = Enum.Font.GothamBold
btnMinimize.TextSize = 20
Instance.new("UICorner", btnMinimize).CornerRadius = UDim.new(0, 6)

btnMinimize.MouseButton1Click:Connect(function() mainFrame.Visible = false minMenu.Visible = true end)
minMenu.MouseButton1Click:Connect(function() mainFrame.Visible = true minMenu.Visible = false end)

local sidebar = Instance.new("ScrollingFrame", mainFrame)
sidebar.Size = UDim2.new(0, 150, 1, -40)
sidebar.Position = UDim2.new(0, 0, 0, 40)
sidebar.BackgroundColor3 = Color3.fromRGB(10, 5, 15)
sidebar.BackgroundTransparency = 0.4 
sidebar.ScrollBarThickness = 2
local sidebarLayout = Instance.new("UIListLayout", sidebar)
sidebarLayout.Padding = UDim.new(0, 5)
sidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local contentArea = Instance.new("Frame", mainFrame)
contentArea.Size = UDim2.new(1, -160, 1, -50)
contentArea.Position = UDim2.new(0, 155, 0, 45)
contentArea.BackgroundTransparency = 1

local tabs = {}
local function createTabMenu(name)
    local btn = Instance.new("TextButton", sidebar)
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(30, 20, 40)
    btn.Text = name
    btn.TextColor3 = colorWhite
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    local tabFrame = Instance.new("Frame", contentArea)
    tabFrame.Size = UDim2.new(1, 0, 1, 0)
    tabFrame.BackgroundTransparency = 1
    tabFrame.Visible = false
    
    tabs[name] = {Button = btn, Frame = tabFrame}
    btn.MouseButton1Click:Connect(function()
        for k, v in pairs(tabs) do
            v.Frame.Visible = (k == name)
            v.Button.BackgroundColor3 = (k == name) and Color3.fromRGB(80, 40, 100) or Color3.fromRGB(30, 20, 40)
        end
    end)
    return tabFrame
end

local controlTab = createTabMenu("🎮 Main Control")
local speedTab = createTabMenu("⚡ Speed Autowalk")
local pathTab = createTabMenu("📂 Path Manager")
local fiturTab = createTabMenu("⭐ Fitur")
local temaTab = createTabMenu("🎨 Bar Tema")
local tutTab = createTabMenu("📚 Tutorial")
local infoTab = createTabMenu("ℹ️ Info")

sidebar.CanvasSize = UDim2.new(0, 0, 0, 7 * 40)
tabs["🎮 Main Control"].Frame.Visible = true
tabs["🎮 Main Control"].Button.BackgroundColor3 = Color3.fromRGB(80, 40, 100)

-- ==========================================
-- FLOATING PANELS
-- ==========================================
local function createHorizontalPanel(posX, width, height)
    local panel = Instance.new("Frame", sg)
    panel.Size = UDim2.new(0, width, 0, height) 
    panel.Position = UDim2.new(0.5, posX, 0.5, -150)
    panel.BackgroundColor3 = Color3.fromRGB(20, 15, 25)
    panel.BackgroundTransparency = 0.15 
    panel.Active = true 
    panel.Draggable = true 
    panel.Visible = false 
    Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 8)

    local contentContainer = Instance.new("Frame", panel)
    contentContainer.Size = UDim2.new(1, 0, 1, 0)
    contentContainer.BackgroundTransparency = 1
    
    local layout = Instance.new("UIListLayout", contentContainer)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.Padding = UDim.new(0, 5)

    local spacer = Instance.new("Frame", contentContainer)
    spacer.Size = UDim2.new(1, 0, 0, 2)
    spacer.BackgroundTransparency = 1
    spacer.LayoutOrder = 0

    local status = Instance.new("TextLabel", contentContainer)
    status.Size = UDim2.new(1, 0, 0, 20)
    status.BackgroundTransparency = 1
    status.Text = "Status: Idle (0 fr)"
    status.TextColor3 = colorWhite
    status.Font = Enum.Font.GothamBold
    status.TextSize = 13
    status.LayoutOrder = 1

    return panel, status, contentContainer, layout
end

local function createIconTextBtn(parent, icon, text, color, customWidth)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0, customWidth or 48, 1, 0)
    btn.BackgroundColor3 = color
    btn.Text = ""
    btn.Active = true 
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    local ico = Instance.new("TextLabel", btn)
    ico.Size = UDim2.new(1, 0, 0.6, 0)
    ico.BackgroundTransparency = 1
    ico.Text = icon
    ico.TextSize = 20
    
    local txt = Instance.new("TextLabel", btn)
    txt.Size = UDim2.new(1, 0, 0.4, 0)
    txt.Position = UDim2.new(0, 0, 0.6, 0)
    txt.BackgroundTransparency = 1
    txt.Text = text
    txt.TextColor3 = colorWhite
    txt.Font = Enum.Font.GothamBold
    txt.TextSize = 9
    return btn
end

-- PANEL RECORD
local recordPanelUI, recStatus, recContent = createHorizontalPanel(-280, 280, 110)
local pathNameInput = Instance.new("TextBox", recContent)
pathNameInput.Size = UDim2.new(0.8, 0, 0, 25)
pathNameInput.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
pathNameInput.TextColor3 = colorWhite
pathNameInput.PlaceholderText = "Ketik Nama Path di sini..."
pathNameInput.Font = Enum.Font.Gotham
pathNameInput.TextSize = 11
pathNameInput.LayoutOrder = 2
Instance.new("UICorner", pathNameInput).CornerRadius = UDim.new(0, 4)

local recBtnContainer = Instance.new("Frame", recContent)
recBtnContainer.Size = UDim2.new(1, -10, 0, 45)
recBtnContainer.BackgroundTransparency = 1
recBtnContainer.LayoutOrder = 3
local recBtnLayout = Instance.new("UIListLayout", recBtnContainer)
recBtnLayout.FillDirection = Enum.FillDirection.Horizontal
recBtnLayout.Padding = UDim.new(0, 5)
recBtnLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local btnRec = createIconTextBtn(recBtnContainer, "🔴", "REC", Color3.fromRGB(120, 30, 40))
local btnStopRec = createIconTextBtn(recBtnContainer, "⏹️", "STOP", Color3.fromRGB(60, 60, 80))
local btnUndoRec = createIconTextBtn(recBtnContainer, "⏪", "UNDO", Color3.fromRGB(150, 100, 30))
local btnSavePath = createIconTextBtn(recBtnContainer, "💾", "SAVE", Color3.fromRGB(30, 80, 120))
local btnTpEnd = createIconTextBtn(recBtnContainer, "🏁", "TP END", Color3.fromRGB(80, 40, 120))

-- PANEL PLAY
local playPanelUI, playStatus, playContent = createHorizontalPanel(20, 240, 85) 
local playBtnContainer = Instance.new("Frame", playContent)
playBtnContainer.Size = UDim2.new(1, -10, 0, 45)
playBtnContainer.BackgroundTransparency = 1
playBtnContainer.LayoutOrder = 2
local playBtnLayout = Instance.new("UIListLayout", playBtnContainer)
playBtnLayout.FillDirection = Enum.FillDirection.Horizontal
playBtnLayout.Padding = UDim.new(0, 5)
playBtnLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local btnPlay = createIconTextBtn(playBtnContainer, "▶️", "PLAY", Color3.fromRGB(30, 120, 60))
local btnStopPlay = createIconTextBtn(playBtnContainer, "⏹️", "STOP", Color3.fromRGB(60, 60, 80))
local btnReverse = createIconTextBtn(playBtnContainer, "🔄", "REV", Color3.fromRGB(100, 40, 100)) 
local btnMoonwalk = createIconTextBtn(playBtnContainer, "🚶‍♂️", "el mundur", Color3.fromRGB(40, 80, 100), 60) 

local function updateStatus(txt) 
    recStatus.Text = txt 
    playStatus.Text = txt 
end

btnReverse.MouseButton1Click:Connect(function()
    isReversePlay = not isReversePlay
    btnReverse.BackgroundColor3 = isReversePlay and Color3.fromRGB(180, 80, 180) or Color3.fromRGB(100, 40, 100)
end)
btnMoonwalk.MouseButton1Click:Connect(function()
    isWalkBackwards = not isWalkBackwards
    btnMoonwalk.BackgroundColor3 = isWalkBackwards and Color3.fromRGB(80, 160, 200) or Color3.fromRGB(40, 80, 100)
end)

-- Main Control Tab
local btnShowRec = Instance.new("TextButton", controlTab)
btnShowRec.Size = UDim2.new(0.4, 0, 0, 50)
btnShowRec.Position = UDim2.new(0.05, 0, 0.05, 0)
btnShowRec.BackgroundColor3 = Color3.fromRGB(100, 30, 40)
btnShowRec.Text = "Show REC Panel"
btnShowRec.TextColor3 = colorWhite
btnShowRec.Font = Enum.Font.GothamBold
Instance.new("UICorner", btnShowRec).CornerRadius = UDim.new(0, 6)
btnShowRec.MouseButton1Click:Connect(function() recordPanelUI.Visible = not recordPanelUI.Visible end)

local btnShowPlay = Instance.new("TextButton", controlTab)
btnShowPlay.Size = UDim2.new(0.4, 0, 0, 50)
btnShowPlay.Position = UDim2.new(0.55, 0, 0.05, 0)
btnShowPlay.BackgroundColor3 = Color3.fromRGB(30, 100, 60)
btnShowPlay.Text = "Show PLAY Panel"
btnShowPlay.TextColor3 = colorWhite
btnShowPlay.Font = Enum.Font.GothamBold
Instance.new("UICorner", btnShowPlay).CornerRadius = UDim.new(0, 6)
btnShowPlay.MouseButton1Click:Connect(function() playPanelUI.Visible = not playPanelUI.Visible end)

-- Speed Tab
local lblSpeed = Instance.new("TextLabel", speedTab)
lblSpeed.Size = UDim2.new(0.9, 0, 0, 20)
lblSpeed.Position = UDim2.new(0.05, 0, 0.05, 0)
lblSpeed.BackgroundTransparency = 1
lblSpeed.Text = "Mode Kecepatan Autowalk:"
lblSpeed.TextColor3 = colorWhite
lblSpeed.Font = Enum.Font.GothamBold
lblSpeed.TextXAlignment = Enum.TextXAlignment.Left

local btnSpeedNormal = Instance.new("TextButton", speedTab)
btnSpeedNormal.Size = UDim2.new(0.9, 0, 0, 45)
btnSpeedNormal.Position = UDim2.new(0.05, 0, 0.15, 0)
btnSpeedNormal.BackgroundColor3 = Color3.fromRGB(40, 150, 50)
btnSpeedNormal.Text = "NORMAL\n(sesuai rekaman asli)"
btnSpeedNormal.TextColor3 = colorWhite
btnSpeedNormal.Font = Enum.Font.GothamBold
btnSpeedNormal.TextSize = 11
Instance.new("UICorner", btnSpeedNormal).CornerRadius = UDim.new(0, 6)

local btnSpeedSuper = Instance.new("TextButton", speedTab)
btnSpeedSuper.Size = UDim2.new(0.9, 0, 0, 45)
btnSpeedSuper.Position = UDim2.new(0.05, 0, 0.35, 0)
btnSpeedSuper.BackgroundColor3 = Color3.fromRGB(40, 30, 50)
btnSpeedSuper.Text = "SUPER\n(anti kedut kedut)"
btnSpeedSuper.TextColor3 = colorWhite
btnSpeedSuper.Font = Enum.Font.GothamBold
btnSpeedSuper.TextSize = 11
Instance.new("UICorner", btnSpeedSuper).CornerRadius = UDim.new(0, 6)

btnSpeedNormal.MouseButton1Click:Connect(function()
    isSpeedSuper = false
    btnSpeedNormal.BackgroundColor3 = Color3.fromRGB(40, 150, 50)
    btnSpeedSuper.BackgroundColor3 = Color3.fromRGB(40, 30, 50)
end)
btnSpeedSuper.MouseButton1Click:Connect(function()
    isSpeedSuper = true
    btnSpeedSuper.BackgroundColor3 = Color3.fromRGB(200, 120, 30)
    btnSpeedNormal.BackgroundColor3 = Color3.fromRGB(40, 30, 50)
end)

-- Fitur Tab
local fiturScroll = Instance.new("ScrollingFrame", fiturTab)
fiturScroll.Size = UDim2.new(1, 0, 1, 0)
fiturScroll.BackgroundTransparency = 1
fiturScroll.ScrollBarThickness = 4
local fiturLayout = Instance.new("UIListLayout", fiturScroll)
fiturLayout.Padding = UDim.new(0, 5)
fiturLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local function createCollapsible(title, openSizeY)
    local container = Instance.new("Frame", fiturScroll)
    container.Size = UDim2.new(0.95, 0, 0, 35)
    container.BackgroundColor3 = Color3.fromRGB(25, 20, 35)
    container.ClipsDescendants = true
    Instance.new("UICorner", container).CornerRadius = UDim.new(0, 6)
    
    local header = Instance.new("TextButton", container)
    header.Size = UDim2.new(1, 0, 0, 35)
    header.BackgroundTransparency = 1
    header.Text = "  " .. title .. " 🔽"
    header.TextColor3 = colorWhite
    header.Font = Enum.Font.GothamBold
    header.TextXAlignment = Enum.TextXAlignment.Left
    
    local content = Instance.new("Frame", container)
    content.Position = UDim2.new(0, 0, 0, 40)
    content.Size = UDim2.new(1, 0, 1, -40)
    content.BackgroundTransparency = 1
    
    local isOpen = false
    header.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        header.Text = isOpen and ("  " .. title .. " 🔼") or ("  " .. title .. " 🔽")
        container.Size = isOpen and UDim2.new(0.95, 0, 0, openSizeY) or UDim2.new(0.95, 0, 0, 35)
    end)
    return content
end

-- Teleport Hub
local tpHod = createCollapsible("🚀 Teleport Hub", 200)
local tpNameInputHub = Instance.new("TextBox", tpHod)
tpNameInputHub.Size = UDim2.new(0.65, 0, 0, 30)
tpNameInputHub.Position = UDim2.new(0.02, 0, 0, 0)
tpNameInputHub.BackgroundColor3 = Color3.fromRGB(40, 30, 50)
tpNameInputHub.TextColor3 = colorWhite
tpNameInputHub.PlaceholderText = "Nama Waypoint..."
tpNameInputHub.Font = Enum.Font.Gotham
Instance.new("UICorner", tpNameInputHub).CornerRadius = UDim.new(0, 4)

local btnMarkPos = Instance.new("TextButton", tpHod)
btnMarkPos.Size = UDim2.new(0.25, 0, 0, 30)
btnMarkPos.Position = UDim2.new(0.7, 0, 0, 0)
btnMarkPos.BackgroundColor3 = Color3.fromRGB(40, 100, 150)
btnMarkPos.Text = "📍 Mark"
btnMarkPos.TextColor3 = colorWhite
btnMarkPos.Font = Enum.Font.GothamBold
Instance.new("UICorner", btnMarkPos).CornerRadius = UDim.new(0, 4)

local tpListFrame = Instance.new("ScrollingFrame", tpHod)
tpListFrame.Size = UDim2.new(0.95, 0, 0, 80)
tpListFrame.Position = UDim2.new(0.02, 0, 0, 35)
tpListFrame.BackgroundTransparency = 0.5
tpListFrame.BackgroundColor3 = Color3.fromRGB(10, 5, 15)
tpListFrame.ScrollBarThickness = 3
local tpLayout = Instance.new("UIListLayout", tpListFrame)
tpLayout.Padding = UDim.new(0, 5)

local btnLoopTP = Instance.new("TextButton", tpHod)
btnLoopTP.Size = UDim2.new(0.95, 0, 0, 30)
btnLoopTP.Position = UDim2.new(0.02, 0, 0, 125)
btnLoopTP.BackgroundColor3 = Color3.fromRGB(100, 80, 30)
btnLoopTP.Text = "🔄 Auto Loop Teleport: OFF"
btnLoopTP.TextColor3 = colorWhite
btnLoopTP.Font = Enum.Font.GothamBold
Instance.new("UICorner", btnLoopTP).CornerRadius = UDim.new(0, 4)

local function updateTPListUI()
    for _, child in ipairs(tpListFrame:GetChildren()) do if child:IsA("Frame") then child:Destroy() end end
    for i, wp in ipairs(savedWaypoints) do
        local itemFrame = Instance.new("Frame", tpListFrame)
        itemFrame.Size = UDim2.new(1, 0, 0, 25)
        itemFrame.BackgroundTransparency = 1
        
        local lblName = Instance.new("TextLabel", itemFrame)
        lblName.Size = UDim2.new(0.55, 0, 1, 0)
        lblName.BackgroundColor3 = Color3.fromRGB(30, 20, 40)
        lblName.TextColor3 = colorWhite
        lblName.Text = " 📍 " .. wp.Name
        lblName.Font = Enum.Font.Gotham
        lblName.TextXAlignment = Enum.TextXAlignment.Left
        
        local btnTp = Instance.new("TextButton", itemFrame)
        btnTp.Size = UDim2.new(0.2, 0, 1, 0)
        btnTp.Position = UDim2.new(0.57, 0, 0, 0)
        btnTp.BackgroundColor3 = Color3.fromRGB(30, 120, 60)
        btnTp.Text = "GO"
        btnTp.TextColor3 = colorWhite
        
        local btnDel = Instance.new("TextButton", itemFrame)
        btnDel.Size = UDim2.new(0.2, 0, 1, 0)
        btnDel.Position = UDim2.new(0.79, 0, 0, 0)
        btnDel.BackgroundColor3 = Color3.fromRGB(120, 40, 40)
        btnDel.Text = "Del"
        btnDel.TextColor3 = colorWhite
        
        btnTp.MouseButton1Click:Connect(function()
            getFreshCharacter()
            setCFrameWithCameraPOV(CFrame.new(wp.Pos.X, wp.Pos.Y, wp.Pos.Z))
            updateStatus("TP to: " .. wp.Name)
        end)
        btnDel.MouseButton1Click:Connect(function() table.remove(savedWaypoints, i) saveToFile() updateTPListUI() end)
    end
    tpListFrame.CanvasSize = UDim2.new(0, 0, 0, #savedWaypoints * 30)
end

btnMarkPos.MouseButton1Click:Connect(function()
    local name = tpNameInputHub.Text
    if name == "" then name = "Waypoint " .. (#savedWaypoints + 1) end
    getFreshCharacter()
    table.insert(savedWaypoints, {Name = name, Pos = rootPart.Position})
    saveToFile() updateTPListUI() tpNameInputHub.Text = ""
end)

btnLoopTP.MouseButton1Click:Connect(function()
    isLoopingTP = not isLoopingTP
    btnLoopTP.BackgroundColor3 = isLoopingTP and Color3.fromRGB(150, 100, 30) or Color3.fromRGB(100, 80, 30)
    btnLoopTP.Text = isLoopingTP and "🔄 Auto Loop: ON" or "🔄 Auto Loop: OFF"
    if isLoopingTP then
        if #savedWaypoints == 0 then isLoopingTP = false return end
        tpLoopTask = task.spawn(function()
            while isLoopingTP do
                for _, wp in ipairs(savedWaypoints) do
                    if not isLoopingTP then break end
                    getFreshCharacter()
                    setCFrameWithCameraPOV(CFrame.new(wp.Pos.X, wp.Pos.Y, wp.Pos.Z))
                    task.wait(3) 
                end
            end
        end)
    else
        if tpLoopTask then task.cancel(tpLoopTask) end
    end
end)
updateTPListUI()

-- Path Visualizer (ESP)
local espHod = createCollapsible("👁️ Path Visualizer (ESP)", 130)
local btnToggleVis = Instance.new("TextButton", espHod)
btnToggleVis.Size = UDim2.new(0.95, 0, 0, 30)
btnToggleVis.Position = UDim2.new(0.02, 0, 0, 0)
btnToggleVis.BackgroundColor3 = Color3.fromRGB(100, 40, 50)
btnToggleVis.Text = "👁️ Path Visualizer: OFF"
btnToggleVis.TextColor3 = colorWhite
btnToggleVis.Font = Enum.Font.GothamBold
Instance.new("UICorner", btnToggleVis).CornerRadius = UDim.new(0, 4)

local lblColorInfo = Instance.new("TextLabel", espHod)
lblColorInfo.Size = UDim2.new(0.95, 0, 0, 20)
lblColorInfo.Position = UDim2.new(0.02, 0, 0, 35)
lblColorInfo.BackgroundTransparency = 1
lblColorInfo.Text = "🎨 PILIH WARNA ESP:"
lblColorInfo.TextColor3 = colorWhite
lblColorInfo.Font = Enum.Font.GothamBold
lblColorInfo.TextXAlignment = Enum.TextXAlignment.Left

local colorContainer = Instance.new("ScrollingFrame", espHod)
colorContainer.Size = UDim2.new(0.95, 0, 0, 40)
colorContainer.Position = UDim2.new(0.02, 0, 0, 55)
colorContainer.BackgroundTransparency = 1
colorContainer.ScrollBarThickness = 2
colorContainer.CanvasSize = UDim2.new(2.5, 0, 0, 0) 
local colorLayout = Instance.new("UIListLayout", colorContainer)
colorLayout.FillDirection = Enum.FillDirection.Horizontal
colorLayout.Padding = UDim.new(0, 5)

local colors = {
    Color3.fromRGB(255, 0, 0), Color3.fromRGB(0, 255, 0), Color3.fromRGB(0, 0, 255),
    Color3.fromRGB(255, 255, 0), Color3.fromRGB(0, 255, 255), Color3.fromRGB(255, 0, 255),
    Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 128, 0), Color3.fromRGB(128, 0, 255),
    Color3.fromRGB(0, 255, 128), Color3.fromRGB(255, 0, 128), Color3.fromRGB(128, 255, 0)
}
for _, col in ipairs(colors) do
    local cBtn = Instance.new("TextButton", colorContainer)
    cBtn.Size = UDim2.new(0, 30, 0, 30)
    cBtn.BackgroundColor3 = col
    cBtn.Text = ""
    Instance.new("UICorner", cBtn).CornerRadius = UDim.new(1, 0)
    cBtn.MouseButton1Click:Connect(function() currentPathColor = col if isVisualizerOn then drawPathLines() end end)
end

-- Anti-Fall Damage (PARACHUTE SYSTEM GLOBAL)
local afHod = createCollapsible("🪂 Sistem Parasut", 70)
local btnAntiFall = Instance.new("TextButton", afHod)
btnAntiFall.Size = UDim2.new(0.95, 0, 0, 30)
btnAntiFall.Position = UDim2.new(0.02, 0, 0, 5)
btnAntiFall.BackgroundColor3 = Color3.fromRGB(100, 40, 50) 
btnAntiFall.Text = "🪂 Sistem Parasut: OFF"
btnAntiFall.TextColor3 = colorWhite
btnAntiFall.Font = Enum.Font.GothamBold
Instance.new("UICorner", btnAntiFall).CornerRadius = UDim.new(0, 4)

btnAntiFall.MouseButton1Click:Connect(function()
    isAntiFallOn = not isAntiFallOn
    btnAntiFall.BackgroundColor3 = isAntiFallOn and Color3.fromRGB(40, 100, 50) or Color3.fromRGB(100, 40, 50)
    btnAntiFall.Text = isAntiFallOn and "🪂 Sistem Parasut: ON" or "🪂 Sistem Parasut: OFF"
    
    if isAntiFallOn then
        if not parachuteConn then
            parachuteConn = runService.Heartbeat:Connect(function()
                pcall(function()
                    if character and rootPart and humanoid and humanoid.Health > 0 then
                        if rootPart.AssemblyLinearVelocity.Y < -20 then
                            rootPart.AssemblyLinearVelocity = Vector3.new(rootPart.AssemblyLinearVelocity.X, -15, rootPart.AssemblyLinearVelocity.Z)
                        end
                    end
                end)
            end)
        end
    else
        if parachuteConn then
            parachuteConn:Disconnect()
            parachuteConn = nil
        end
    end
end)

-- Fly Mode
local flyHod = createCollapsible("✈️ Fly Mode", 120)
local btnToggleFly = Instance.new("TextButton", flyHod)
btnToggleFly.Size = UDim2.new(0.95, 0, 0, 30)
btnToggleFly.Position = UDim2.new(0.02, 0, 0, 0)
btnToggleFly.BackgroundColor3 = Color3.fromRGB(100, 40, 50)
btnToggleFly.Text = "✈️ Fly Mode: OFF"
btnToggleFly.TextColor3 = colorWhite
btnToggleFly.Font = Enum.Font.GothamBold
Instance.new("UICorner", btnToggleFly).CornerRadius = UDim.new(0, 4)

local lblFlySpeed = Instance.new("TextLabel", flyHod)
lblFlySpeed.Size = UDim2.new(0.95, 0, 0, 20)
lblFlySpeed.Position = UDim2.new(0.02, 0, 0, 35)
lblFlySpeed.BackgroundTransparency = 1
lblFlySpeed.Text = "Kecepatan Fly: 50"
lblFlySpeed.TextColor3 = colorWhite
lblFlySpeed.Font = Enum.Font.GothamBold
lblFlySpeed.TextXAlignment = Enum.TextXAlignment.Left

local flySliderBg = Instance.new("Frame", flyHod)
flySliderBg.Size = UDim2.new(0.95, 0, 0, 15)
flySliderBg.Position = UDim2.new(0.02, 0, 0, 60)
flySliderBg.BackgroundColor3 = Color3.fromRGB(40, 30, 50)
Instance.new("UICorner", flySliderBg).CornerRadius = UDim.new(1, 0)

local flySliderFill = Instance.new("Frame", flySliderBg)
flySliderFill.Size = UDim2.new(50/200, 0, 1, 0) 
flySliderFill.BackgroundColor3 = sliderFillColor
Instance.new("UICorner", flySliderFill).CornerRadius = UDim.new(1, 0)

local flySliderBtn = Instance.new("TextButton", flySliderBg)
flySliderBtn.Size = UDim2.new(1, 0, 1, 0)
flySliderBtn.BackgroundTransparency = 1
flySliderBtn.Text = ""

flySliderBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
        isDraggingFly = true 
    end
end)

local function startFly()
    getFreshCharacter()
    local bv = Instance.new("BodyVelocity")
    local bg = Instance.new("BodyGyro")
    bv.Name = "MacroFlyBV" bg.Name = "MacroFlyBG"
    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bg.D = 100 bg.P = 10000
    bv.Parent = rootPart bg.Parent = rootPart
    
    humanoid.PlatformStand = true 
    
    flyConn = runService.RenderStepped:Connect(function()
        if not isFlying then return end
        local cam = workspace.CurrentCamera
        local moveDir = Vector3.zero
        pcall(function() moveDir = require(player.PlayerScripts:WaitForChild("PlayerModule")):GetControls():GetMoveVector() end)
        
        local targetVec = Vector3.new()
        if moveDir.Magnitude > 0 then
            targetVec = (cam.CFrame.RightVector * moveDir.X) + (cam.CFrame.LookVector * -moveDir.Z)
        end
        if uis:IsKeyDown(Enum.KeyCode.Space) then targetVec = targetVec + Vector3.new(0,1,0) end
        if uis:IsKeyDown(Enum.KeyCode.LeftShift) then targetVec = targetVec + Vector3.new(0,-1,0) end
        
        bv.Velocity = targetVec * flySpeed
        bg.CFrame = cam.CFrame
    end)
end

local function stopFly()
    if flyConn then flyConn:Disconnect() end
    if rootPart:FindFirstChild("MacroFlyBV") then rootPart.MacroFlyBV:Destroy() end
    if rootPart:FindFirstChild("MacroFlyBG") then rootPart.MacroFlyBG:Destroy() end
    
    humanoid.PlatformStand = false
    pcall(function() humanoid:ChangeState(Enum.HumanoidStateType.GettingUp) end)
end

btnToggleFly.MouseButton1Click:Connect(function()
    isFlying = not isFlying
    btnToggleFly.BackgroundColor3 = isFlying and Color3.fromRGB(40, 100, 50) or Color3.fromRGB(100, 40, 50)
    btnToggleFly.Text = isFlying and "✈️ Fly Mode: ON" or "✈️ Fly Mode: OFF"
    if isFlying then startFly() else stopFly() end
end)

-- Copy Avatar (CS)
local copyHod = createCollapsible("🎭 Copy Avatar (CS)", 120)
local txtTargetUser = Instance.new("TextBox", copyHod)
txtTargetUser.Size = UDim2.new(0.95, 0, 0, 30)
txtTargetUser.Position = UDim2.new(0.02, 0, 0, 0)
txtTargetUser.BackgroundColor3 = Color3.fromRGB(40, 30, 50)
txtTargetUser.TextColor3 = colorWhite
txtTargetUser.PlaceholderText = "Username target..."
txtTargetUser.Font = Enum.Font.Gotham
Instance.new("UICorner", txtTargetUser).CornerRadius = UDim.new(0, 4)

local btnCopyAva = Instance.new("TextButton", copyHod)
btnCopyAva.Size = UDim2.new(0.95, 0, 0, 30)
btnCopyAva.Position = UDim2.new(0.02, 0, 0, 35)
btnCopyAva.BackgroundColor3 = Color3.fromRGB(80, 40, 120)
btnCopyAva.Text = "🎭 COPY AVATAR"
btnCopyAva.TextColor3 = colorWhite
btnCopyAva.Font = Enum.Font.GothamBold
Instance.new("UICorner", btnCopyAva).CornerRadius = UDim.new(0, 4)

local lblCopyInfo = Instance.new("TextLabel", copyHod)
lblCopyInfo.Size = UDim2.new(0.95, 0, 0, 30)
lblCopyInfo.Position = UDim2.new(0.02, 0, 0, 70)
lblCopyInfo.BackgroundTransparency = 1
lblCopyInfo.Text = "(Client-Side) Meng-copy fisik karakter dari map (anti error)."
lblCopyInfo.TextColor3 = Color3.fromRGB(200, 200, 200)
lblCopyInfo.Font = Enum.Font.Gotham
lblCopyInfo.TextSize = 10
lblCopyInfo.TextWrapped = true

btnCopyAva.MouseButton1Click:Connect(function()
    local targetName = txtTargetUser.Text
    local targetPlayer = nil
    for _, p in ipairs(players:GetPlayers()) do
        if string.lower(p.Name) == string.lower(targetName) or string.lower(p.DisplayName) == string.lower(targetName) then
            targetPlayer = p break
        end
    end
    
    if targetPlayer and targetPlayer.Character then
        lblCopyInfo.Text = "Menyalin fisik avatar..."
        getFreshCharacter()
        pcall(function()
            for _, v in pairs(character:GetChildren()) do
                if v:IsA("Accessory") or v:IsA("Shirt") or v:IsA("Pants") or v:IsA("ShirtGraphic") or v:IsA("BodyColors") then
                    v:Destroy()
                end
            end
            for _, v in pairs(targetPlayer.Character:GetChildren()) do
                if v:IsA("Accessory") or v:IsA("Shirt") or v:IsA("Pants") or v:IsA("ShirtGraphic") or v:IsA("BodyColors") then
                    v:Clone().Parent = character
                end
            end
            local myHead = character:FindFirstChild("Head")
            local tHead = targetPlayer.Character:FindFirstChild("Head")
            if myHead and tHead then
                local myFace = myHead:FindFirstChildOfClass("Decal")
                local tFace = tHead:FindFirstChildOfClass("Decal")
                if myFace and tFace then myFace.Texture = tFace.Texture
                elseif tFace then tFace:Clone().Parent = myHead end
            end
        end)
        lblCopyInfo.Text = "Sukses menyalin avatar " .. targetPlayer.Name .. "!"
    else
        lblCopyInfo.Text = "Pemain tidak ditemukan/belum load."
    end
end)

-- ==========================================
-- BAR TEMA TAB (MENGADOPSI LOGIKA V1.8.1 ORI)
-- ==========================================
local sliderLabel = Instance.new("TextLabel", temaTab)
sliderLabel.Size = UDim2.new(0.9, 0, 0, 20)
sliderLabel.Position = UDim2.new(0.05, 0, 0.05, 0)
sliderLabel.BackgroundTransparency = 1
sliderLabel.Text = "Geser Transparansi Laba-laba:"
sliderLabel.TextColor3 = colorWhite
sliderLabel.Font = Enum.Font.GothamBold
sliderLabel.TextXAlignment = Enum.TextXAlignment.Left

local sliderBg = Instance.new("Frame", temaTab)
sliderBg.Size = UDim2.new(0.9, 0, 0, 10)
sliderBg.Position = UDim2.new(0.05, 0, 0.15, 0)
sliderBg.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
Instance.new("UICorner", sliderBg).CornerRadius = UDim.new(1, 0)

local sliderBtn = Instance.new("TextButton", sliderBg)
sliderBtn.Size = UDim2.new(0, 20, 0, 20)
sliderBtn.Position = UDim2.new(0.65, -10, 0.5, -10) -- 0.65 Default position
sliderBtn.BackgroundColor3 = sliderFillColor
sliderBtn.Text = ""
Instance.new("UICorner", sliderBtn).CornerRadius = UDim.new(1, 0)

local draggingSlider = false
sliderBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingSlider = true
    end
end)

uis.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingSlider = false
        isDraggingFly = false
    end
end)

uis.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        
        -- Logika Transparansi (HANYA MENGUBAH GAMBAR LABA LABA, BUKAN MAIN FRAME)
        if draggingSlider then
            local pos = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
            sliderBtn.Position = UDim2.new(pos, -10, 0.5, -10)
            -- Main frame TETAP solid 0. Yang berubah hanya gambar laba-laba.
            bgImage.ImageTransparency = pos
        end

        if isDraggingFly then
            local relativeX = math.clamp((input.Position.X - flySliderBg.AbsolutePosition.X) / flySliderBg.AbsoluteSize.X, 0, 1)
            flySliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
            local currentSpd = math.floor(relativeX * 200)
            if currentSpd < 10 then currentSpd = 10 end
            flySpeed = currentSpd
            lblFlySpeed.Text = "Kecepatan Fly: " .. flySpeed
        end
    end
end)

-- Tab Info & Tutorial
local txtTut = Instance.new("TextLabel", tutTab)
txtTut.Size = UDim2.new(0.9, 0, 0.8, 0)
txtTut.Position = UDim2.new(0.05, 0, 0.05, 0)
txtTut.BackgroundTransparency = 1
txtTut.Text = "1. Buka Main Control untuk akses Panel\n2. Gunakan Undo jika jatuh/salah jalan\n3. Saat Play, geser Analog untuk batal"
txtTut.TextColor3 = colorWhite
txtTut.Font = Enum.Font.Gotham
txtTut.TextXAlignment = Enum.TextXAlignment.Left
txtTut.TextYAlignment = Enum.TextYAlignment.Top

local txtInfo = Instance.new("TextLabel", infoTab)
txtInfo.Size = UDim2.new(0.9, 0, 0.8, 0)
txtInfo.Position = UDim2.new(0.05, 0, 0.05, 0)
txtInfo.BackgroundTransparency = 1
txtInfo.Text = "PhantomWalk Pro V1.8.8\nScript Premium Terbaik by Kucing garong 😼."
txtInfo.TextColor3 = colorWhite
txtInfo.Font = Enum.Font.Gotham

-- ==========================================
-- SCRIPT LOGIC (RENDER ESP & ANIMASI FIRE PHANTOM MINIMIZE)
-- ==========================================
runService.RenderStepped:Connect(function()
    if minMenu.Visible then
        fireGradient.Offset = Vector2.new(0, (tick() * 2) % 1 - 0.5)
        minStroke.Transparency = math.random(10, 40) / 100
    end
end)

local renderId = 0
function drawPathLines()
    renderId = renderId + 1
    local currentRender = renderId
    if workspace:FindFirstChild("MacroPathLines") then workspace:FindFirstChild("MacroPathLines"):Destroy() end
    if not isVisualizerOn or #frames == 0 then return end

    local folder = Instance.new("Folder")
    folder.Name = "MacroPathLines"
    folder.Parent = workspace

    task.spawn(function()
        local step = 15 
        local partCount = 0
        for i = 1, #frames - step, step do
            if currentRender ~= renderId then return end 
            local p1 = frames[i].Pos
            local p2 = frames[i+step].Pos
            local dist = (p2 - p1).Magnitude
            if dist > 0.1 then
                local line = Instance.new("Part")
                line.Size = Vector3.new(0.15, 0.15, dist) 
                line.CFrame = CFrame.lookAt(p1, p2) * CFrame.new(0, 0, -dist/2)
                line.Anchored = true
                line.CanCollide = false
                line.CanQuery = false
                line.CastShadow = false
                line.Material = Enum.Material.Neon
                line.Color = currentPathColor 
                line.Transparency = 0.4
                line.Parent = folder
                
                partCount = partCount + 1
                if partCount % 25 == 0 then runService.Heartbeat:Wait() end
            end
        end
    end)
end

btnToggleVis.MouseButton1Click:Connect(function()
    isVisualizerOn = not isVisualizerOn
    btnToggleVis.BackgroundColor3 = isVisualizerOn and Color3.fromRGB(40, 100, 50) or Color3.fromRGB(100, 40, 50)
    btnToggleVis.Text = isVisualizerOn and "👁️ Path Visualizer: ON" or "👁️ Path Visualizer: OFF"
    drawPathLines()
end)

-- PATH MANAGER LOGIC
local pathListFrame = Instance.new("ScrollingFrame", pathTab)
pathListFrame.Size = UDim2.new(0.9, 0, 0.7, 0)
pathListFrame.Position = UDim2.new(0.05, 0, 0.05, 0)
pathListFrame.BackgroundTransparency = 0.5
pathListFrame.BackgroundColor3 = Color3.fromRGB(10, 5, 15)
pathListFrame.ScrollBarThickness = 5
Instance.new("UICorner", pathListFrame).CornerRadius = UDim.new(0, 6)
Instance.new("UIListLayout", pathListFrame).Padding = UDim.new(0, 5)

local btnMergePath = Instance.new("TextButton", pathTab)
btnMergePath.Size = UDim2.new(0.9, 0, 0, 35)
btnMergePath.Position = UDim2.new(0.05, 0, 0.8, 0)
btnMergePath.BackgroundColor3 = Color3.fromRGB(100, 40, 120)
btnMergePath.Text = "🔗 Auto Merge Path Angka"
btnMergePath.TextColor3 = colorWhite
btnMergePath.Font = Enum.Font.GothamBold
Instance.new("UICorner", btnMergePath).CornerRadius = UDim.new(0, 6)

local function updatePathListUI()
    for _, child in ipairs(pathListFrame:GetChildren()) do if child:IsA("Frame") then child:Destroy() end end
    local count = 0
    for name, data in pairs(savedPaths) do
        count = count + 1
        local itemFrame = Instance.new("Frame", pathListFrame)
        itemFrame.Size = UDim2.new(1, 0, 0, 30)
        itemFrame.BackgroundTransparency = 1
        
        local lblName = Instance.new("TextLabel", itemFrame)
        lblName.Size = UDim2.new(0.55, 0, 1, 0)
        lblName.BackgroundColor3 = Color3.fromRGB(30, 20, 40)
        lblName.TextColor3 = colorWhite
        lblName.Text = " 📂 " .. name
        lblName.Font = Enum.Font.Gotham
        lblName.TextXAlignment = Enum.TextXAlignment.Left
        Instance.new("UICorner", lblName).CornerRadius = UDim.new(0, 4)
        
        local btnLoad = Instance.new("TextButton", itemFrame)
        btnLoad.Size = UDim2.new(0.2, 0, 1, 0)
        btnLoad.Position = UDim2.new(0.57, 0, 0, 0)
        btnLoad.BackgroundColor3 = Color3.fromRGB(30, 100, 150)
        btnLoad.Text = "Pilih"
        btnLoad.TextColor3 = colorWhite
        Instance.new("UICorner", btnLoad).CornerRadius = UDim.new(0, 4)
        
        local btnDel = Instance.new("TextButton", itemFrame)
        btnDel.Size = UDim2.new(0.2, 0, 1, 0)
        btnDel.Position = UDim2.new(0.79, 0, 0, 0)
        btnDel.BackgroundColor3 = Color3.fromRGB(120, 40, 40)
        btnDel.Text = "Hapus"
        btnDel.TextColor3 = colorWhite
        Instance.new("UICorner", btnDel).CornerRadius = UDim.new(0, 4)
        
        btnLoad.MouseButton1Click:Connect(function() 
            frames = {}; for _,f in ipairs(data) do table.insert(frames,f) end
            updateStatus("Status: Idle ("..#frames.." fr)") 
            drawPathLines()
        end)
        btnDel.MouseButton1Click:Connect(function() savedPaths[name] = nil saveToFile() updatePathListUI() end)
    end
    pathListFrame.CanvasSize = UDim2.new(0, 0, 0, count * 35)
end
updatePathListUI()

btnSavePath.MouseButton1Click:Connect(function()
    local name = pathNameInput.Text
    if name == "" or #frames == 0 then return end
    savedPaths[name] = {}; for _,f in ipairs(frames) do table.insert(savedPaths[name], f) end
    saveToFile() updatePathListUI() updateStatus("Path Saved!")
end)

btnTpEnd.MouseButton1Click:Connect(function()
    if #frames == 0 then return end
    getFreshCharacter()
    local last = frames[#frames]
    setCFrameWithCameraPOV(CFrame.lookAt(last.Pos, last.Pos + last.Look))
    updateStatus("Status: Idle ("..#frames.." fr)")
end)

btnMergePath.MouseButton1Click:Connect(function()
    local keys = {}
    for k in pairs(savedPaths) do if tonumber(k) then table.insert(keys, tonumber(k)) end end
    table.sort(keys)
    if #keys == 0 then return end
    local merged = {}
    local offset, lastPos, lastLook = 0, nil, nil
    
    for _, k in ipairs(keys) do
        local data = savedPaths[tostring(k)]
        local firstFrame = data[1]
        if lastPos and firstFrame then
            local gapVec = firstFrame.Pos - lastPos
            local gapDist = gapVec.Magnitude
            if gapDist > 1 then
                local walkTime = gapDist / 16 
                local steps = math.floor(walkTime * 60) 
                local flatDir = Vector3.new(gapVec.X, 0, gapVec.Z)
                local walkDir = flatDir.Magnitude > 0 and flatDir.Unit or (lastLook or Vector3.new(0,0,1))
                
                for i = 1, steps do
                    local t = i / steps
                    local currentLook
                    if t < 0.2 then currentLook = lastLook:Lerp(walkDir, t/0.2)
                    elseif t > 0.8 then currentLook = walkDir:Lerp(firstFrame.Look, (t-0.8)/0.2)
                    else currentLook = walkDir end
                    if currentLook.Magnitude > 0.01 then currentLook = currentLook.Unit else currentLook = walkDir end
                    
                    table.insert(merged, {Time = offset + (i/60), MoveDir = walkDir, Pos = lastPos:Lerp(firstFrame.Pos, t), Look = currentLook, Jump = false})
                end
                offset = offset + walkTime
            end
        end
        local lastT = 0
        for _, f in ipairs(data) do
            table.insert(merged, {Time = f.Time + offset, MoveDir = f.MoveDir, Pos = f.Pos, Look = f.Look, Jump = f.Jump})
            lastT = f.Time; lastPos = f.Pos; lastLook = f.Look
        end
        offset = offset + lastT
    end
    frames = merged updateStatus("Status: Idle ("..#frames.." fr)") drawPathLines()
end)

local function stopAll()
    isRecording, isPlaying, isUndoing = false, false, false
    if recordConn then recordConn:Disconnect() end
    if playConn then playConn:Disconnect() end
    if jumpEvent then jumpEvent:Disconnect() end
    
    pcall(function() runService:UnbindFromRenderStep("PhantomAnimPumper") end)
    
    togglePlayerControls(true) 
    if humanoid then 
        pcall(function() humanoid.AutoRotate = true end)
    end
    pcall(function()
        for _, v in pairs(character:GetDescendants()) do
            if v:IsA("BasePart") and v:FindFirstChild("MacroOldTouch") then
                v.CanTouch = v.MacroOldTouch.Value
                v.MacroOldTouch:Destroy()
            end
        end
    end)
    if workspace:FindFirstChild("MacroInvFloor") then workspace:FindFirstChild("MacroInvFloor"):Destroy() end
    updateStatus("Status: Idle ("..#frames.." fr)")
    drawPathLines()
end

-- ==========================================
-- ENGINE CORE (RECORD & PLAY)
-- ==========================================
btnRec.MouseButton1Click:Connect(function()
    if isPlaying or isRecording then return end
    getFreshCharacter() isRecording = true frames = {} updateStatus("🔴 Merekam (0 fr)")
    recordStartTime = tick() 
    local jumped = false
    
    pcall(function()
        for _, v in pairs(character:GetDescendants()) do
            if v:IsA("LocalScript") and v.Name ~= "Animate" and v.Name ~= "Sound" then v.Disabled = true end
            if v:IsA("BasePart") then
                if not v:FindFirstChild("MacroOldTouch") then
                    local oldT = Instance.new("BoolValue") oldT.Name = "MacroOldTouch" oldT.Value = v.CanTouch oldT.Parent = v
                end
                v.CanTouch = false 
            end
        end
    end)
    
    if jumpEvent then jumpEvent:Disconnect() end
    jumpEvent = humanoid.StateChanged:Connect(function(_, new) if new == Enum.HumanoidStateType.Jumping then jumped = true end end)
    
    recordConn = runService.Heartbeat:Connect(function()
        if not character or not humanoid or humanoid.Health <= 0 then stopAll() return end
        if isUndoing then return end 
        
        if rootPart.Position.Y < workspace.FallenPartsDestroyHeight + 50 then stopAll() return end
        
        table.insert(frames, {Time = tick()-recordStartTime, MoveDir = humanoid.MoveDirection, Pos = rootPart.Position, Look = rootPart.CFrame.LookVector, Jump = jumped})
        jumped = false
        
        if #frames % 30 == 0 then updateStatus("🔴 Merekam ("..#frames.." fr)") end
    end)
end)

btnStopRec.MouseButton1Click:Connect(stopAll)

btnUndoRec.MouseButton1Click:Connect(function()
    if not isRecording then updateStatus("⚠️ Harus Merekam!") return end
    if isUndoing then return end
    isUndoing = true
    
    if #frames > 0 then
        local framesToRemove = 0
        local maxUndoFrames = 240 
        local foundJump = false
        local searchLimit = math.max(1, #frames - 300) 
        
        for i = #frames, searchLimit, -1 do
            framesToRemove = framesToRemove + 1
            if frames[i].Jump then foundJump = true end
            if foundJump and not frames[i].Jump and frames[i].MoveDir.Magnitude < 0.1 then framesToRemove = framesToRemove + 10 break end
        end
        if not foundJump then framesToRemove = math.min(maxUndoFrames, #frames) end
        for i = 1, framesToRemove do table.remove(frames, #frames) end
    end
    
    if #frames > 0 then
        local lastF = frames[#frames]
        pcall(function()
            rootPart.Anchored = false humanoid.PlatformStand = false humanoid.Sit = false humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
        end)
        
        setCFrameWithCameraPOV(CFrame.lookAt(lastF.Pos, lastF.Pos + lastF.Look))
        rootPart.AssemblyLinearVelocity = Vector3.zero rootPart.AssemblyAngularVelocity = Vector3.zero
        
        updateStatus("⏪ Menunggu Jalan...") drawPathLines()
        
        task.spawn(function()
            task.wait(0.2) 
            if not isRecording then isUndoing = false return end
            
            local hasMoved = false
            while isRecording and isUndoing do
                if isTryingToMoveAnalog() or humanoid.Jump then hasMoved = true break end
                task.wait(0.05)
            end
            
            if not isRecording then return end
            if hasMoved then
                local currentPos, currentLook, currentMoveDir = rootPart.Position, rootPart.CFrame.LookVector, humanoid.MoveDirection
                local bridgeTime = 0.25
                local steps = math.floor(bridgeTime * 60)
                
                for i = 1, steps do
                    local t = i / steps
                    local bridgeLook = lastF.Look:Lerp(currentLook, t)
                    if bridgeLook.Magnitude > 0.01 then bridgeLook = bridgeLook.Unit else bridgeLook = lastF.Look end
                    table.insert(frames, {Time = lastF.Time + (bridgeTime * t), MoveDir = lastF.MoveDir:Lerp(currentMoveDir, t), Pos = lastF.Pos:Lerp(currentPos, t), Look = bridgeLook, Jump = false})
                end
                recordStartTime = tick() - frames[#frames].Time 
                isUndoing = false 
            end
        end)
    else
        recordStartTime = tick() isUndoing = false updateStatus("🔴 Merekam ("..#frames.." fr)") drawPathLines()
    end
end)

btnStopPlay.MouseButton1Click:Connect(stopAll)

btnPlay.MouseButton1Click:Connect(function()
    if isRecording or isPlaying or #frames == 0 then return end
    getFreshCharacter() isPlaying = true
    
    task.spawn(function()
        updateStatus("▶ Playing")
        
        local baseFrames = frames
        if isReversePlay then
            baseFrames = {}
            local totalTime = frames[#frames].Time
            for i = #frames, 1, -1 do
                local f = frames[i]
                table.insert(baseFrames, {Time = totalTime - f.Time, MoveDir = -f.MoveDir, Pos = f.Pos, Look = -f.Look, Jump = f.Jump})
            end
        end

        local playFrames = {}
        if isSpeedSuper then
            local timeOffset = 0
            for i, f in ipairs(baseFrames) do
                local isIdle = (f.MoveDir.Magnitude < 0.05) and (not f.Jump)
                local dt = 0
                if i > 1 then dt = f.Time - baseFrames[i-1].Time end
                if isIdle then timeOffset = timeOffset + dt end
                table.insert(playFrames, {Time = f.Time - timeOffset, MoveDir = f.MoveDir, Pos = f.Pos, Look = f.Look, Jump = f.Jump})
            end
        else
            playFrames = baseFrames
        end
        
        if #playFrames == 0 then stopAll() return end
        
        local cIdx = 1 
        local cDist = math.huge
        for i, f in ipairs(playFrames) do
            local d = (f.Pos - rootPart.Position).Magnitude
            if d < cDist then cDist = d cIdx = i end
        end
        
        local startF = playFrames[cIdx]
        
        if cDist > 2 then
            humanoid:MoveTo(startF.Pos)
            local timeout = 0
            local stuckTimer = 0
            local lastPosCheck = rootPart.Position
            local reachedTarget = false
            
            while isPlaying and timeout < 5 do
                if not character or not humanoid or humanoid.Health <= 0 then stopAll() return end
                if (Vector3.new(rootPart.Position.X, 0, rootPart.Position.Z) - Vector3.new(startF.Pos.X, 0, startF.Pos.Z)).Magnitude < 1.5 then 
                    reachedTarget = true
                    break 
                end
                task.wait(0.1) timeout = timeout + 0.1
                
                if (rootPart.Position - lastPosCheck).Magnitude < 0.2 then
                    stuckTimer = stuckTimer + 0.1
                    if stuckTimer >= 0.5 then stopAll() updateStatus("Status: Idle (Terhadang Objek)") return end
                else
                    stuckTimer = 0
                end
                lastPosCheck = rootPart.Position
            end
            
            if not reachedTarget and timeout >= 5 then
                stopAll()
                updateStatus("Status: Idle (Gagal capai Path)")
                return
            end
        end
        
        if not isPlaying then return end
        
        local targetStartCFrame = CFrame.new(startF.Pos, startF.Pos + startF.Look)
        rootPart.Anchored = true
        for i = 1, 10 do
            if not isPlaying then break end
            rootPart.CFrame = rootPart.CFrame:Lerp(targetStartCFrame, i/10)
            task.wait(0.02)
        end
        rootPart.Anchored = false

        updateStatus("▶ Playing")
        togglePlayerControls(true) humanoid.AutoRotate = false
        
        if workspace:FindFirstChild("MacroInvFloor") then workspace:FindFirstChild("MacroInvFloor"):Destroy() end
        local invFloor = Instance.new("Part")
        invFloor.Name = "MacroInvFloor"
        invFloor.Size = Vector3.new(0.2, 0.05, 0.2) 
        invFloor.Transparency = 1 
        invFloor.Anchored = true
        invFloor.CanCollide = false
        invFloor.Material = Enum.Material.SmoothPlastic 
        invFloor.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0) 
        invFloor.Parent = workspace

        local startTime = tick()
        local offsetStud = -0.2 
        
        local smoothLook = startF.Look
        local smoothMoveDir = startF.MoveDir
        local activeMoveDir = Vector3.zero

        runService:BindToRenderStep("PhantomAnimPumper", 201, function()
            if isPlaying and humanoid then
                humanoid:Move(activeMoveDir, false)
            end
        end)

        playConn = runService.Heartbeat:Connect(function()
            if not character or not humanoid or humanoid.Health <= 0 then stopAll() return end
            if not isPlaying then return end
            
            if isTryingToMoveAnalog() then stopAll() return end
            
            local elapsedTime = (tick() - startTime) + startF.Time
            local shouldJump = false
            while cIdx < #playFrames and playFrames[cIdx+1].Time <= elapsedTime do
                cIdx = cIdx + 1
                if playFrames[cIdx].Jump then shouldJump = true end
            end
            
            if cIdx >= #playFrames then stopAll() return end
            
            local f = playFrames[cIdx]
            local nextF = playFrames[cIdx+1]
            
            local interpPos = f.Pos
            local interpMoveDir = f.MoveDir
            local interpLook = f.Look
            
            if nextF then
                local dt = nextF.Time - f.Time
                if dt > 0.001 then
                    local alpha = math.clamp((elapsedTime - f.Time) / dt, 0, 1)
                    interpPos = f.Pos:Lerp(nextF.Pos, alpha)
                    interpMoveDir = f.MoveDir:Lerp(nextF.MoveDir, alpha)
                    interpLook = f.Look:Lerp(nextF.Look, alpha).Unit
                end
            end
            
            local currentState = humanoid:GetState()
            local isClimbing = (currentState == Enum.HumanoidStateType.Climbing)
            
            local targetLook = interpLook
            local flatMove = Vector3.new(interpMoveDir.X, 0, interpMoveDir.Z)
            
            if isSpeedSuper then
                if flatMove.Magnitude > 0.1 and not isClimbing then targetLook = flatMove.Unit end
            end
            
            if isWalkBackwards then targetLook = -targetLook end
            smoothLook = smoothLook:Lerp(targetLook, 0.15).Unit 
            
            local finalLook = smoothLook
            local finalMoveDir = interpMoveDir
            
            if isSpeedSuper then
                smoothMoveDir = smoothMoveDir:Lerp(interpMoveDir, 0.15) 
                finalMoveDir = smoothMoveDir
            end
            
            activeMoveDir = finalMoveDir 
            
            local targetPos = interpPos + (finalLook * -offsetStud)
            rootPart.CFrame = CFrame.new(targetPos, targetPos + finalLook)
            
            if finalMoveDir.Magnitude > 0.1 and not isClimbing and currentState ~= Enum.HumanoidStateType.Jumping and currentState ~= Enum.HumanoidStateType.Freefall then
                 humanoid:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
            end

            if f.Jump or shouldJump then
                humanoid.Jump = true humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                rootPart.AssemblyLinearVelocity = Vector3.new(rootPart.AssemblyLinearVelocity.X, 50, rootPart.AssemblyLinearVelocity.Z)
            end
            
            if currentState == Enum.HumanoidStateType.Landed then
                invFloor.CanCollide = true invFloor.CFrame = CFrame.new(targetPos - Vector3.new(0, 3.15, 0)) 
            else
                invFloor.CanCollide = false invFloor.CFrame = CFrame.new(targetPos - Vector3.new(0, 10, 0))
            end
        end)
    end)
end)
