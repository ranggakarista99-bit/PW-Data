-- ==========================================
-- PHANTOMWALK-PRO-1 | UI-FIRST LOADER
-- Developer: Bos Rangga 😼
-- ==========================================

local player = game:GetService("Players").LocalPlayer
local myUserId = 8459930744 
local queenId = 518969839  
local scriptLink = "https://raw.githubusercontent.com/PhantomWalk-PRO-1/PW-Data/refs/heads/main/PhantomWalk_Main.lua"

-- 1. JALUR VIP
if player.UserId == myUserId or player.UserId == queenId then
    loadstring(game:HttpGet(scriptLink))()
    return 
end

-- 2. MUNCULKAN UI LEBIH DULU (Biar pasti kelihatan)
local sg = Instance.new("ScreenGui", game.CoreGui)
sg.Name = "PhantomAuth"

local frame = Instance.new("Frame", sg)
frame.Size = UDim2.new(0, 350, 0, 200)
frame.Position = UDim2.new(0.5, -175, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(15, 10, 20)
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 50)
title.BackgroundTransparency = 1
title.Text = "MEMUAT SISTEM..."
title.TextColor3 = Color3.fromRGB(255, 215, 0)
title.Font = Enum.Font.GothamBold
title.TextSize = 16

local txtKey = Instance.new("TextBox", frame)
txtKey.Size = UDim2.new(0.8, 0, 0, 40)
txtKey.Position = UDim2.new(0.1, 0, 0.35, 0)
txtKey.BackgroundColor3 = Color3.fromRGB(30, 20, 40)
txtKey.TextColor3 = Color3.fromRGB(255, 255, 255)
txtKey.PlaceholderText = "Sabar, sedang konek ke server..."
txtKey.TextEditable = false 
Instance.new("UICorner", txtKey).CornerRadius = UDim.new(0, 6)

local btnLogin = Instance.new("TextButton", frame)
btnLogin.Size = UDim2.new(0.8, 0, 0, 40)
btnLogin.Position = UDim2.new(0.1, 0, 0.65, 0)
btnLogin.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
btnLogin.Text = "TUNGGU SEBENTAR"
btnLogin.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", btnLogin).CornerRadius = UDim.new(0, 6)

-- 3. JALANKAN KEYAUTH DI LATAR BELAKANG
task.spawn(function()
    local Name = "PhantomWalk-PRO-1"
    local Ownerid = "drBGNk4DVL"
    local Secret = "7701abd392686be2e893a03ad30d4370842d6ce11949275976ca1ba311c4ef6e"
    local Version = "1.0"

    local success, KeyAuthScript = pcall(function()
        return game:HttpGet("https://raw.githubusercontent.com/KeyAuth/KeyAuth-Roblox/main/keyauth.lua")
    end)

    if not success then
        title.Text = "KONEKSI DIBLOKIR ISP!"
        title.TextColor3 = Color3.fromRGB(255, 0, 0)
        return
    end

    local envSuccess, KeyAuth = pcall(function()
        return loadstring(KeyAuthScript)()
    end)

    if envSuccess and KeyAuth then
        KeyAuth.api.name = Name
        KeyAuth.api.ownerid = Ownerid
        KeyAuth.api.secret = Secret
        KeyAuth.api.version = Version
        
        local initSuccess = pcall(function() KeyAuth.api:init() end)

        if not initSuccess then
            title.Text = "ERROR: DELTA MENOLAK KEYAUTH"
            title.TextColor3 = Color3.fromRGB(255, 0, 0)
            return
        end

        -- KETIKA SUKSES, AKTIFKAN UI UNTUK INPUT KEY
        title.Text = "PHANTOMWALK-PRO-1 LOGIN"
        title.TextColor3 = Color3.fromRGB(160, 110, 220)
        txtKey.PlaceholderText = "Masukkan License Key..."
        txtKey.TextEditable = true
        btnLogin.Text = "LOGIN & EXECUTE"
        btnLogin.BackgroundColor3 = Color3.fromRGB(160, 110, 220)

        btnLogin.MouseButton1Click:Connect(function()
            btnLogin.Text = "Checking..."
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
        title.Text = "ERROR: LOADSTRING GAGAL"
        title.TextColor3 = Color3.fromRGB(255, 0, 0)
    end
end)
