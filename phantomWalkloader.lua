-- ==========================================
-- PHANTOMWALK PRO | ULTIMATE LOADER V3.1
-- Developer: Kucing garong .. utf8.char(128572)
-- Features: Username Detection, Custom Splash, Anti-Alien
-- ==========================================

local player = game:GetService("Players").LocalPlayer
local HttpService = game:GetService("HttpService")
local myName = player.Name 

-- ==========================================
-- ⚙️ [ AREA PENGATURAN EL KAPITAN ] ⚙️
-- WAJIB ISI DENGAN USERNAME ASLI ROBLOX!
-- ==========================================

local elKapitanName = "kenalin_r" -- Ganti dengan Username Bos Rangga
local ayangName = "catcatkitty098"    -- Ganti dengan Username Nyonya Ratu

-- 💌 Pesan khusus yang muncul di bawah nama Nyonya Ratu
local pesanBuatAyang = "mangat ayyyy! " .. utf8.char(10084) .. utf8.char(128150)

-- 🌟 Daftar Spesial Member (Format: ["Username"] = "Nama Sambutan")
local specialMembers = {
    ["OmGifar133"] = utf8.char(128081) .. " OM GIFAR " .. utf8.char(128081),
    ["myanxiety21"] = "DUTA BASECAMP",
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

-- 💎 Daftar VIP Member Permanen (Masuk tanpa Key)
local vipMembers = {
    ["KawanVIPSatu"] = true,
    ["KawanVIPDua"] = true
}

-- 🆓 Daftar Free Member (Masuk tanpa Key, tapi terdeteksi Free)
local freeMembers = {
    ["BocilGratisan1"] = true,
    ["BocilGratisan2"] = true
}

local scriptLink = "https://raw.githubusercontent.com/PhantomWalk-PRO-1/PW-Data/main/PhantomWalk_Main.lua"
local saveFileName = "PhantomWalk_Auth.json"

-- ==========================================
-- 🚀 FUNGSI MESIN LOADER & UI
-- ==========================================

local sg = Instance.new("ScreenGui", game.CoreGui)
sg.Name = "PhantomAuthPro"

local function executeMain()
    local r = request or http_request or (http and http.request)
    local mainCode = ""
    pcall(function()
        if r then mainCode = r({Url = scriptLink .. "?v=" .. math.random(1,999), Method = "GET"}).Body
        else mainCode = game:HttpGet(scriptLink .. "?v=" .. math.random(1,999)) end
    end)
    sg:Destroy()
    if mainCode ~= "" then loadstring(mainCode)() end
end

-- 🎨 FUNGSI TEMPLATE SPLASH WELCOME
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
-- 🕵️ DETEKSI IDENTITAS PLAYER (VIA USERNAME)
-- ==========================================

if myName == elKapitanName then
    showSplash("EL KAPITAN!! " .. utf8.char(128572), " WELCOME BACK BOSSS...", Color3.fromRGB(255, 220, 50))
    return
elseif myName == ayangName then
    showSplash("NYONYA RATU!! " .. utf8.char(128081), pesanBuatAyang, Color3.fromRGB(255, 105, 180))
    return
elseif specialMembers[myName] then
    showSplash("SPESIAL MEMBER\n" .. specialMembers[myName], "WELCOME BACK BROO!", Color3.fromRGB(100, 200, 255))
    return
elseif vipMembers[myName] then
    showSplash("VIP MEMBER " .. utf8.char(11088), "WELCOME BACK BROO!", Color3.fromRGB(255, 215, 0))
    return
elseif freeMembers[myName] then
    showSplash("FREE MEMBER", "Akses Gratis Terbatas Diberikan...", Color3.fromRGB(150, 150, 150))
    return
end

-- ==========================================
-- 🔐 SISTEM LOGIN KEYAUTH (PEMBELI BIASA)
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
infoLabel.Text = "Menghubungkan ke server pusat..."
infoLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
infoLabel.Font = Enum.Font.Gotham
infoLabel.TextSize = 12

local txtKey = Instance.new("TextBox", frame)
txtKey.Size = UDim2.new(0.8, 0, 0, 40)
txtKey.Position = UDim2.new(0.1, 0, 0.45, 0)
txtKey.BackgroundColor3 = Color3.fromRGB(30, 20, 45)
txtKey.TextColor3 = Color3.fromRGB(255, 255, 255)
txtKey.PlaceholderText = "Masukkan License Key..."
txtKey.Visible = false
Instance.new("UICorner", txtKey).CornerRadius = UDim.new(0, 8)

local btnLogin = Instance.new("TextButton", frame)
btnLogin.Size = UDim2.new(0.8, 0, 0, 40)
btnLogin.Position = UDim2.new(0.1, 0, 0.7, 0)
btnLogin.BackgroundColor3 = Color3.fromRGB(160, 110, 220)
btnLogin.Text = " TUNGGU BENTAR PRENNX..."
btnLogin.TextColor3 = Color3.fromRGB(255, 255, 255)
btnLogin.Font = Enum.Font.GothamBold
Instance.new("UICorner", btnLogin).CornerRadius = UDim.new(0, 8)

task.spawn(function()
    local Name = "PhantomWalk-PRO-1"
    local Ownerid = "drBGNk4DVL"
    local Version = "1.0"
    local sessionid = ""
    local hwid = game:GetService("RbxAnalyticsService"):GetClientId()

    local function request_get(url)
        local req = request or http_request or (http and http.request)
        if req then return req({Url = url, Method = "GET"}).Body end
        return game:HttpGet(url)
    end

    local initRes = request_get("https://keyauth.win/api/1.2/?type=init&ver="..Version.."&name="..Name.."&ownerid="..Ownerid)
    local initData = HttpService:JSONDecode(initRes)
    if not initData.success then infoLabel.Text = "Server Error: " .. initData.message return end
    sessionid = initData.sessionid

    local savedKey = ""
    pcall(function()
        if isfile(saveFileName) then
            local fileContent = readfile(saveFileName)
            local data = HttpService:JSONDecode(fileContent)
            savedKey = data.Key
        end
    end)

    local function tryLogin(key)
        btnLogin.Text = "Mengecek License..."
        local licRes = request_get("https://keyauth.win/api/1.2/?type=license&key="..key.."&hwid="..hwid.."&sessionid="..sessionid.."&name="..Name.."&ownerid="..Ownerid.."&ver="..Version)
        local licData = HttpService:JSONDecode(licRes)

        if licData.success then
            pcall(function() writefile(saveFileName, HttpService:JSONEncode({Key = key})) end)
            local expiry = os.date("%d-%m-%Y", tonumber(licData.info.expiry))
            
            frame:Destroy()
            showSplash("VIP MEMBER " .. utf8.char(11088), "License Valid! Aktif Hingga: " .. expiry, Color3.fromRGB(255, 215, 0))
        else
            infoLabel.Text = "Gagal: " .. (licData.message or "Key Salah!")
            btnLogin.Text = "LOGIN & EXECUTE"
            txtKey.Visible = true
        end
    end

    if savedKey ~= "" then
        infoLabel.Text = "Mendeteksi HWID... Mencoba Auto-Login"
        tryLogin(savedKey)
    else
        infoLabel.Text = "Silahkan masukkan License Key kamu"
        btnLogin.Text = "LOGIN & EXECUTE"
        txtKey.Visible = true
    end

    btnLogin.MouseButton1Click:Connect(function()
        if txtKey.Text ~= "" then tryLogin(txtKey.Text) end
    end)
end)
