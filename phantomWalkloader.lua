-- ==========================================
-- PHANTOMWALK PRO | ULTIMATE LOADER V3.2 (TIMEOUT EDITION)
-- Developer: Kucing garong .. utf8.char(128572)
-- Features: Auto-Detect, KeyAuth API, GitHub Global Key, & Anti-Stuck Timeout
-- ==========================================

local player = game:GetService("Players").LocalPlayer
local HttpService = game:GetService("HttpService")
local myName = player.Name 

-- ==========================================
-- ⚙️ [ AREA PENGATURAN EL KAPITAN ] ⚙️
-- ==========================================
local elKapitanName = "kenalin_r" 
local ayangName = "catcatkitty098"    
local pesanBuatAyang = "mangat ayyyy! " .. utf8.char(10084) .. utf8.char(128150)

-- 🌟 Daftar Spesial Member
local specialMembers = {
    ["OmGifar133"] = utf8.char(128081) .. " OM GIFAR " .. utf8.char(128081),
    ["Gredd_5"] = utf8.char(128081) .. " KING GRED " .. utf8.char(128081),
    ["Anomali_9950"] = "BEST PRENNN",
    ["jaja"] = "BEST PRENNN",
    ["hsj"] = "BEST PRENNN",
    ["haj"] = "BEST PRENNN",
    ["gahah"] = "BEST PRENNN",
    ["haha"] = "BEST PRENNN",
    ["vsga"] = "BEST PRENNN",
    ["hahh"] = "BEST PRENNN",
    ["ajjai"] = "BEST PRENNN",
}

local vipMembers = {
    ["KawanVIPSatu"] = true,
    ["KawanVIPDua"] = true
}

local freeMembers = {
    ["BocilGratisan1"] = true,
    ["BocilGratisan2"] = true
}

-- 🔗 PENGATURAN LINK DATA
local scriptLink = "https://raw.githubusercontent.com/PhantomWalk-PRO-1/PW-Data/main/PhantomWalk_Main.lua"
local saveFileName = "PhantomWalk_Auth.json"
local globalKeyURL = "https://raw.githubusercontent.com/PhantomWalk-PRO-1/PW-Data/main/KeyHarian.txt"

-- ==========================================
-- 🚀 FUNGSI MESIN LOADER & UI
-- ==========================================
local sg = Instance.new("ScreenGui", game.CoreGui)
sg.Name = "PhantomAuthPro"

local function executeMain()
    local r = request or http_request or (http and http.request)
    local mainCode = ""
    pcall(function()
        if r then mainCode = r({Url = scriptLink .. "?v=" .. math.random(1,9999), Method = "GET"}).Body
        else mainCode = game:HttpGet(scriptLink .. "?v=" .. math.random(1,9999)) end
    end)
    sg:Destroy()
    if mainCode ~= "" then loadstring(mainCode)() end
end

local function showSplash(midText, bottomText, textColor)
    local frame = Instance.new("Frame", sg)
    frame.Size = UDim2.new(0, 360, 0, 220)
    frame.Position = UDim2.new(0.5, -180, 0.5, -110)
    frame.BackgroundColor3 = Color3.fromRGB(15, 10, 25)
    frame.BorderSizePixel = 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 15)

    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = Color3.fromRGB(160, 110, 220)
    stroke.Thickness = 2
    
    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1, 0, 0, 50)
    title.Position = UDim2.new(0, 0, 0, 15)
    title.BackgroundTransparency = 1
    title.Text = utf8.char(128640) .. " WELCOME TO PHANTOMWALK PRO"
    title.TextColor3 = Color3.fromRGB(200, 160, 255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 16

    local midLabel = Instance.new("TextLabel", frame)
    midLabel.Size = UDim2.new(1, 0, 0, 60)
    midLabel.Position = UDim2.new(0, 0, 0, 75)
    midLabel.BackgroundTransparency = 1
    midLabel.Text = midText
    midLabel.TextColor3 = textColor or Color3.fromRGB(255, 255, 255)
    midLabel.Font = Enum.Font.GothamBold
    midLabel.TextSize = 22

    local bottomLabel = Instance.new("TextLabel", frame)
    bottomLabel.Size = UDim2.new(1, 0, 0, 30)
    bottomLabel.Position = UDim2.new(0, 0, 0, 150)
    bottomLabel.BackgroundTransparency = 1
    bottomLabel.Text = bottomText
    bottomLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    bottomLabel.Font = Enum.Font.Gotham
    bottomLabel.TextSize = 13

    task.wait(3) 
    executeMain()
end

-- ==========================================
-- 🕵️ DETEKSI IDENTITAS PLAYER
-- ==========================================
if myName == elKapitanName then
    showSplash("EL KAPITAN!!\n" .. utf8.char(128572), " WELCOME BACK BOSSS...", Color3.fromRGB(255, 220, 50)) return
elseif myName == ayangName then
    showSplash("NYONYA RATU!! " .. utf8.char(128081), pesanBuatAyang, Color3.fromRGB(255, 105, 180)) return
elseif specialMembers[myName] then
    showSplash("SPESIAL MEMBER\n" .. specialMembers[myName], "WELCOME BACK BROO!", Color3.fromRGB(100, 200, 255)) return
elseif vipMembers[myName] then
    showSplash("VIP MEMBER " .. utf8.char(11088), "WELCOME BACK BROO!", Color3.fromRGB(255, 215, 0)) return
elseif freeMembers[myName] then
    showSplash("FREE MEMBER", "Akses Gratis Terbatas Diberikan...", Color3.fromRGB(150, 150, 150)) return
end

-- ==========================================
-- 🔐 SISTEM LOGIN DENGAN TIMEOUT (ANTI-STUCK)
-- ==========================================
local frame = Instance.new("Frame", sg)
frame.Size = UDim2.new(0, 360, 0, 220)
frame.Position = UDim2.new(0.5, -180, 0.5, -110)
frame.BackgroundColor3 = Color3.fromRGB(15, 10, 25)
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 15)

local stroke = Instance.new("UIStroke", frame)
stroke.Color = Color3.fromRGB(160, 110, 220)
stroke.Thickness = 2

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 50)
title.BackgroundTransparency = 1
title.Text = utf8.char(128640) .. " PHANTOMWALK LOGIN"
title.TextColor3 = Color3.fromRGB(200, 160, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 16

local infoLabel = Instance.new("TextLabel", frame)
infoLabel.Size = UDim2.new(0.9, 0, 0, 30)
infoLabel.Position = UDim2.new(0.05, 0, 0.25, 0)
infoLabel.BackgroundTransparency = 1
infoLabel.Text = "Silahkan masukkan License atau Global Key"
infoLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
infoLabel.Font = Enum.Font.Gotham
infoLabel.TextSize = 12

local txtKey = Instance.new("TextBox", frame)
txtKey.Size = UDim2.new(0.8, 0, 0, 40)
txtKey.Position = UDim2.new(0.1, 0, 0.45, 0)
txtKey.BackgroundColor3 = Color3.fromRGB(30, 20, 45)
txtKey.TextColor3 = Color3.fromRGB(255, 255, 255)
txtKey.PlaceholderText = "Masukkan License Key..."
Instance.new("UICorner", txtKey).CornerRadius = UDim.new(0, 8)

local btnLogin = Instance.new("TextButton", frame)
btnLogin.Size = UDim2.new(0.8, 0, 0, 40)
btnLogin.Position = UDim2.new(0.1, 0, 0.7, 0)
btnLogin.BackgroundColor3 = Color3.fromRGB(160, 110, 220)
btnLogin.Text = "LOGIN & EXECUTE"
btnLogin.TextColor3 = Color3.fromRGB(255, 255, 255)
btnLogin.Font = Enum.Font.GothamBold
Instance.new("UICorner", btnLogin).CornerRadius = UDim.new(0, 8)

-- ⚙️ MESIN ANTI-STUCK (TIMEOUT ENGINE)
local function fetchWithTimeout(url, timeoutSecs)
    local result = nil
    local isDone = false
    task.spawn(function()
        pcall(function()
            local req = request or http_request or (http and http.request)
            if req then result = req({Url = url, Method = "GET"}).Body
            else result = game:HttpGet(url) end
        end)
        isDone = true
    end)
    
    local timer = 0
    while not isDone and timer < timeoutSecs do
        task.wait(0.5)
        timer = timer + 0.5
    end
    return result
end

-- 🚀 PROSES KLIK LOGIN
btnLogin.MouseButton1Click:Connect(function()
    local inputKey = txtKey.Text
    if inputKey == "" then 
        infoLabel.Text = "Key tidak boleh kosong!" 
        return 
    end

    btnLogin.Text = "Memeriksa..."
    infoLabel.Text = "Mengecek Server..."

    -- TAHAP 1: Cek GitHub (Timeout 4 Detik)
    local resultG = fetchWithTimeout(globalKeyURL .. "?v=" .. math.random(1,9999), 4)
    if resultG then
        local serverKey = string.gsub(resultG, "%s+", "")
        local userKey = string.gsub(inputKey, "%s+", "")
        if userKey == serverKey and serverKey ~= "" then
            frame:Destroy()
            showSplash("VIP MEMBER " .. utf8.char(11088), "Global Key Valid! Akses Darurat Diberikan.", Color3.fromRGB(255, 215, 0))
            return
        end
    end

    -- TAHAP 2: Cek KeyAuth (Timeout 6 Detik)
    infoLabel.Text = "Menghubungi Keamanan KeyAuth..."
    
    local Name = "PhantomWalk-PRO-1"
    local Ownerid = "drBGNk4DVL"
    local Version = "1.0"
    
    -- Request Init
    local initRes = fetchWithTimeout("https://keyauth.win/api/1.2/?type=init&ver="..Version.."&name="..Name.."&ownerid="..Ownerid, 6)
    if not initRes or initRes == "" then
        infoLabel.Text = "GAGAL: Server KeyAuth Down / Diblokir!"
        btnLogin.Text = "LOGIN & EXECUTE"
        return
    end

    local s1, initData = pcall(function() return HttpService:JSONDecode(initRes) end)
    if not s1 or not initData.success then
        infoLabel.Text = "GAGAL: Koneksi Ditolak oleh KeyAuth."
        btnLogin.Text = "LOGIN & EXECUTE"
        return
    end

    -- Request License
    local hwid = game:GetService("RbxAnalyticsService"):GetClientId()
    local licRes = fetchWithTimeout("https://keyauth.win/api/1.2/?type=license&key="..inputKey.."&hwid="..hwid.."&sessionid="..initData.sessionid.."&name="..Name.."&ownerid="..Ownerid.."&ver="..Version, 6)
    
    if not licRes or licRes == "" then
        infoLabel.Text = "GAGAL: KeyAuth Tidak Merespon (Stuck Dicegah)!"
        btnLogin.Text = "LOGIN & EXECUTE"
        return
    end

    local s2, licData = pcall(function() return HttpService:JSONDecode(licRes) end)
    if s2 and licData.success then
        -- Simpan Key kalau sukses
        pcall(function() writefile(saveFileName, HttpService:JSONEncode({Key = inputKey})) end)
        frame:Destroy()
        showSplash("VIP MEMBER " .. utf8.char(11088), "License KeyAuth Valid!", Color3.fromRGB(255, 215, 0))
    else
        infoLabel.Text = "GAGAL: " .. (licData and licData.message or "Key Salah / Invalid!")
        btnLogin.Text = "LOGIN & EXECUTE"
    end
end)

-- Auto-Login Cek (Di awal)
pcall(function()
    if isfile(saveFileName) then
        local fileContent = readfile(saveFileName)
        local data = HttpService:JSONDecode(fileContent)
        if data.Key then
            txtKey.Text = data.Key
        end
    end
end)
