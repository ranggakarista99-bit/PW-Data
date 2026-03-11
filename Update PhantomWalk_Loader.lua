-- ==========================================
-- PHANTOMWALK-PRO-1 | LOADER SUPER PROXY
-- Developer: kucing garong 😼
-- ==========================================

local player = game:GetService("Players").LocalPlayer
local myUserId = 8459930744 
local ayangId = 518969839  

-- FUNGSI PENEMBUS BLOKIR TINGKAT DEWA
local function fetchScript(urlList)
    for i, url in ipairs(urlList) do
        local success, result = pcall(function()
            return game:HttpGet(url)
        end)
        if success and result and string.len(result) > 50 and not string.match(result, "404: Not Found") then
            return result, i 
        end
    end
    return nil, 0
end

-- PROXY JALUR BAWAH TANAH UNTUK MAIN LUA
local mainLuaPlans = {
    "https://api.allorigins.win/raw?url=https://raw.githubusercontent.com/PhantomWalk-PRO-1/PW-Data/main/PhantomWalk_Main.lua", -- Plan A: AllOrigins (Sangat Kuat)
    "https://raw.kkgithub.com/PhantomWalk-PRO-1/PW-Data/main/PhantomWalk_Main.lua", -- Plan B: KKGitHub (Mirror China)
    "https://corsproxy.io/?https://raw.githubusercontent.com/PhantomWalk-PRO-1/PW-Data/main/PhantomWalk_Main.lua" -- Plan C: CorsProxy
}

-- PROXY JALUR BAWAH TANAH UNTUK KEYAUTH
local keyAuthPlans = {
    "https://api.allorigins.win/raw?url=https://raw.githubusercontent.com/KeyAuth/KeyAuth-Roblox/main/keyauth.lua",
    "https://raw.kkgithub.com/KeyAuth/KeyAuth-Roblox/main/keyauth.lua",
    "https://corsproxy.io/?https://raw.githubusercontent.com/KeyAuth/KeyAuth-Roblox/main/keyauth.lua"
}

-- ==========================================
-- 1. JALUR VIP KHUSUS
-- ==========================================
if player.UserId == myUserId or player.UserId == ayangId then
    local mainScript, planUsed = fetchScript(mainLuaPlans)
    if mainScript then
        print("Akses VIP Diterima! Tembus via Plan: " .. planUsed)
        loadstring(mainScript)()
    else
        warn("BOS, SEMUA PROXY DIBLOKIR ISP!")
    end
    return 
end

-- ==========================================
-- 2. UI LOGIN 
-- ==========================================
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
title.Text = "MENDOBRAK BLOKIR ISP..."
title.TextColor3 = Color3.fromRGB(255, 215, 0)
title.Font = Enum.Font.GothamBold
title.TextSize = 16

local txtKey = Instance.new("TextBox", frame)
txtKey.Size = UDim2.new(0.8, 0, 0, 40)
txtKey.Position = UDim2.new(0.1, 0, 0.35, 0)
txtKey.BackgroundColor3 = Color3.fromRGB(30, 20, 40)
txtKey.TextColor3 = Color3.fromRGB(255, 255, 255)
txtKey.PlaceholderText = "Sabar, kucing garong sedang kerja..."
txtKey.TextEditable = false 
Instance.new("UICorner", txtKey).CornerRadius = UDim.new(0, 6)

local btnLogin = Instance.new("TextButton", frame)
btnLogin.Size = UDim2.new(0.8, 0, 0, 40)
btnLogin.Position = UDim2.new(0.1, 0, 0.65, 0)
btnLogin.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
btnLogin.Text = "TUNGGU SEBENTAR"
btnLogin.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", btnLogin).CornerRadius = UDim.new(0, 6)

-- ==========================================
-- 3. PROSES KEYAUTH 
-- ==========================================
task.spawn(function()
    local Name = "PhantomWalk-PRO-1"
    local Ownerid = "drBGNk4DVL"
    local Secret = "7701abd392686be2e893a03ad30d4370842d6ce11949275976ca1ba311c4ef6e"
    local Version = "1.0"

    local keyAuthRaw, planUsed = fetchScript(keyAuthPlans)

    if not keyAuthRaw then
        title.Text = "KONEKSI MATI TOTAL (PROXY GAGAL)!"
        title.TextColor3 = Color3.fromRGB(255, 0, 0)
        return
    end

    local envSuccess, KeyAuth = pcall(function() return loadstring(keyAuthRaw)() end)

    if envSuccess and KeyAuth then
        KeyAuth.api.name = Name
        KeyAuth.api.ownerid = Ownerid
        KeyAuth.api.secret = Secret
        KeyAuth.api.version = Version
        
        local initSuccess = pcall(function() KeyAuth.api:init() end)

        if not initSuccess then
            title.Text = "ERROR: DELTA MENOLAK INIT"
            title.TextColor3 = Color3.fromRGB(255, 0, 0)
            return
        end

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
                btnLogin.Text = "BERHASIL!"
                btnLogin.BackgroundColor3 = Color3.fromRGB(40, 150, 50)
                task.wait(1)
                sg:Destroy()
                
                local finalScript, finalPlan = fetchScript(mainLuaPlans)
                if finalScript then
                    loadstring(finalScript)()
                else
                    warn("Gagal menarik skrip utama setelah login!")
                end
            else
                btnLogin.Text = "INVALID KEY!"
                btnLogin.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
                task.wait(2)
                btnLogin.Text = "LOGIN & EXECUTE"
                btnLogin.BackgroundColor3 = Color3.fromRGB(160, 110, 220)
            end
        end)
    else
        title.Text = "GAGAL MEMUAT KEYAUTH SCRIPT"
        title.TextColor3 = Color3.fromRGB(255, 0, 0)
    end
end)
        KeyAuth.api.ownerid = Ownerid
        KeyAuth.api.secret = Secret
        KeyAuth.api.version = Version
        
        local initSuccess = pcall(function() KeyAuth.api:init() end)

        if not initSuccess then
            title.Text = "ERROR: DELTA MENOLAK INIT"
            title.TextColor3 = Color3.fromRGB(255, 0, 0)
            return
        end

        -- JIKA SUKSES TEMBUS, BUKA KUNCI UI
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
                btnLogin.Text = "BERHASIL!"
                btnLogin.BackgroundColor3 = Color3.fromRGB(40, 150, 50)
                task.wait(1)
                sg:Destroy()
                
                -- Tarik Main Lua pakai sistem Multi-Plan juga
                local finalScript, finalPlan = fetchScript(mainLuaPlans)
                if finalScript then
                    loadstring(finalScript)()
                else
                    warn("Gagal menarik skrip utama setelah login!")
                end
            else
                btnLogin.Text = "INVALID KEY!"
                btnLogin.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
                task.wait(2)
                btnLogin.Text = "LOGIN & EXECUTE"
                btnLogin.BackgroundColor3 = Color3.fromRGB(160, 110, 220)
            end
        end)
    else
        title.Text = "GAGAL MEMUAT KEYAUTH SCRIPT"
        title.TextColor3 = Color3.fromRGB(255, 0, 0)
    end
end)
    else
        title.Text = "ERROR: LOADSTRING GAGAL"
        title.TextColor3 = Color3.fromRGB(255, 0, 0)
    end
end)
