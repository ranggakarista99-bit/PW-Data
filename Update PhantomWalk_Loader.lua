-- ==========================================
-- PHANTOMWALK-PRO-1 | LOADER FINAL (NO TXT)
-- Developer: EL CAPITAN 😼
-- Special Access: EL NYONYA RATU👑
-- ==========================================

local player = game:GetService("Players").LocalPlayer
local myUserId = 8459930744 -- ID EL CAPITAN
local queenId = 518969839  -- ID EL NYONYA RATU👑

-- LINK HARTA KARUN (MAIN LUA) - PASTI .LUA
local scriptLink = "https://raw.githubusercontent.com/PhantomWalk-PRO-1/PW-Data/refs/heads/main/PhantomWalk_Main.lua"

-- FUNGSI POP-UP WELCOME
local function showWelcome(text, color)
    local sg = Instance.new("ScreenGui", game.CoreGui)
    local txt = Instance.new("TextLabel", sg)
    txt.Size = UDim2.new(0, 400, 0, 50)
    txt.Position = UDim2.new(0.5, -200, 0.1, 0)
    txt.Text = text
    txt.TextSize = 18
    txt.TextColor3 = color
    txt.Font = Enum.Font.GothamBold
    txt.BackgroundTransparency = 1
    txt.TextStrokeTransparency = 0.5
    
    local ts = game:GetService("TweenService")
    ts:Create(txt, TweenInfo.new(1, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -200, 0.15, 0)}):Play()
    task.delay(3, function()
        game:GetService("TweenService"):Create(txt, TweenInfo.new(1), {TextTransparency = 1, TextStrokeTransparency = 1}):Play()
        task.delay(1, function() sg:Destroy() end)
    end)
end

-- ==========================================
-- 1. JALUR VIP (EL CAPITAN & EL NYONYA RATU)
-- ==========================================
if player.UserId == myUserId then
    showWelcome("Akses Developer Diterima. Selamat datang, EL CAPITAN! 😼🔥", Color3.fromRGB(255, 215, 0))
    loadstring(game:HttpGet(scriptLink))()
    return 
elseif player.UserId == queenId then
    showWelcome("Akses Khusus Diterima. Selamat datang, EL NYONYA RATU👑💖", Color3.fromRGB(255, 105, 180))
    loadstring(game:HttpGet(scriptLink))()
    return
end

-- ==========================================
-- 2. SETUP KEYAUTH (SISTEM JUAL BELI)
-- ==========================================
local Name = "PhantomWalk-PRO-1"
local Ownerid = "drBGNk4DVL"
local Secret = "7701abd392686be2e893a03ad30d4370842d6ce11949275976ca1ba311c4ef6e"
local Version = "1.0"

local success, KeyAuthScript = pcall(function()
    return game:HttpGet("https://raw.githubusercontent.com/KeyAuth/KeyAuth-Roblox/main/keyauth.lua")
end)

if not success then
    warn("Gagal menghubungi server KeyAuth. Coba gunakan VPN!")
    return
end

local KeyAuth = loadstring(KeyAuthScript)()
KeyAuth.api.name = Name
KeyAuth.api.ownerid = Ownerid
KeyAuth.api.secret = Secret
KeyAuth.api.version = Version
KeyAuth.api:init()

-- ==========================================
-- 3. UI LOGIN PREMIUM
-- ==========================================
local sg = Instance.new("ScreenGui", game.CoreGui)
sg.Name = "PhantomAuth"

local frame = Instance.new("Frame", sg)
frame.Size = UDim2.new(0, 350, 0, 200)
frame.Position = UDim2.new(0.5, -175, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(15, 10, 20)
frame.BorderSizePixel = 0
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 50)
title.BackgroundTransparency = 1
title.Text = "PHANTOMWALK-PRO-1 LOGIN"
title.TextColor3 = Color3.fromRGB(160, 110, 220)
title.Font = Enum.Font.GothamBold
title.TextSize = 16

local txtKey = Instance.new("TextBox", frame)
txtKey.Size = UDim2.new(0.8, 0, 0, 40)
txtKey.Position = UDim2.new(0.1, 0, 0.35, 0)
txtKey.BackgroundColor3 = Color3.fromRGB(30, 20, 40)
txtKey.TextColor3 = Color3.fromRGB(255, 255, 255)
txtKey.PlaceholderText = "Masukkan License Key..."
txtKey.Font = Enum.Font.Gotham
txtKey.TextSize = 12
txtKey.BorderSizePixel = 0
Instance.new("UICorner", txtKey).CornerRadius = UDim.new(0, 6)

local btnLogin = Instance.new("TextButton", frame)
btnLogin.Size = UDim2.new(0.8, 0, 0, 40)
btnLogin.Position = UDim2.new(0.1, 0, 0.65, 0)
btnLogin.BackgroundColor3 = Color3.fromRGB(160, 110, 220)
btnLogin.Text = "LOGIN & EXECUTE"
btnLogin.TextColor3 = Color3.fromRGB(255, 255, 255)
btnLogin.Font = Enum.Font.GothamBold
btnLogin.TextSize = 14
btnLogin.BorderSizePixel = 0
Instance.new("UICorner", btnLogin).CornerRadius = UDim.new(0, 6)

btnLogin.MouseButton1Click:Connect(function()
    btnLogin.Text = "Checking License..."
    KeyAuth.api:license(txtKey.Text)

    if KeyAuth.api.success then
        btnLogin.Text = "SUCCESS!"
        btnLogin.BackgroundColor3 = Color3.fromRGB(40, 150, 50)
        task.wait(1)
        sg:Destroy()
        loadstring(game:HttpGet(scriptLink))()
    else
        btnLogin.Text = "INVALID KEY!"
        btnLogin.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        task.wait(2)
        btnLogin.Text = "LOGIN & EXECUTE"
        btnLogin.BackgroundColor3 = Color3.fromRGB(160, 110, 220)
    end
end)
    else
        btnLogin.Text = "INVALID KEY!"
        btnLogin.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        task.wait(2)
        btnLogin.Text = "LOGIN & EXECUTE"
        btnLogin.BackgroundColor3 = Color3.fromRGB(160, 110, 220)
    end
end)
