-- ==========================================
-- PHANTOMWALK PRO | ULTIMATE LOADER V3.5 (TYPEWRITER EDITION)
-- Developer: Kucing garong .. utf8.char(128572)
-- Features: Auto-Detect, KeyAuth API, Expiry Tracker, & Typewriter Cinematic UI
-- ==========================================

local player = game:GetService("Players").LocalPlayer
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
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
    ["anomali_99550"] = utf8.char(128081) .. " CIE ABIS NGE DATE " .. utf8.char(128081),
    ["Anom950"] = "BEST PRENNN",
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
-- 🚀 FUNGSI MESIN LOADER & UI ANIMASI (TYPEWRITER)
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

-- Fungsi khusus untuk mengetik huruf satu per satu dengan aman (termasuk emoji)
local function typewriteText(label, textStr, speed)
    label.Text = textStr
    label.MaxVisibleGraphemes = 0
    
    local graphemeCount = 0
    for _ in utf8.graphemes(textStr) do
        graphemeCount = graphemeCount + 1
    end
    
    for i = 1, graphemeCount do
        label.MaxVisibleGraphemes = i
        task.wait(speed or 0.04) -- Kecepatan ketik per huruf
    end
end

local function showSplash(midText, bottomText, textColor)
    local frame = Instance.new("Frame", sg)
    frame.Size = UDim2.new(0, 360, 0, 220)
    frame.Position = UDim2.new(0.5, -180, 0.5, -110)
    frame.BackgroundColor3 = Color3.fromRGB(15, 10, 25)
    frame.BackgroundTransparency = 1 -- Mulai dari transparan penuh
    frame.BorderSizePixel = 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 15)

    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = Color3.fromRGB(160, 110, 220)
    stroke.Thickness = 2
    stroke.Transparency = 1
    
    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1, 0, 0, 50)
    title.Position = UDim2.new(0, 0, 0, 15)
    title.BackgroundTransparency = 1
    title.Text = utf8.char(128640) .. " WELCOME TO PHANTOMWALK PRO"
    title.TextColor3 = Color3.fromRGB(200, 160, 255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 16
    title.TextTransparency = 1

    local midLabel = Instance.new("TextLabel", frame)
    midLabel.Size = UDim2.new(1, 0, 0, 60)
    midLabel.Position = UDim2.new(0, 0, 0, 75)
    midLabel.BackgroundTransparency = 1
    midLabel.Text = ""
    midLabel.TextColor3 = textColor or Color3.fromRGB(255, 255, 255)
    midLabel.Font = Enum.Font.GothamBold
    midLabel.TextSize = 22
    
    -- Menambahkan efek Glow/Bayangan Estetik
    local glow = Instance.new("UIStroke", midLabel)
    glow.Color = textColor or Color3.fromRGB(255, 255, 255)
    glow.Transparency = 0.7
    glow.Thickness = 1

    local bottomLabel = Instance.new("TextLabel", frame)
    bottomLabel.Size = UDim2.new(1, 0, 0, 30)
    bottomLabel.Position = UDim2.new(0, 0, 0, 150)
    bottomLabel.BackgroundTransparency = 1
    bottomLabel.Text = ""
    bottomLabel.TextColor3 = Color3.fromRGB(200, 255, 150) 
    bottomLabel.Font = Enum.Font.GothamBold
    bottomLabel.TextSize = 14

    -- 🎬 TAHAP 1: Fade-In Latar Belakang & Judul
    local fadeInfo = TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(frame, fadeInfo, {BackgroundTransparency = 0}):Play()
    TweenService:Create(stroke, fadeInfo, {Transparency = 0}):Play()
    TweenService:Create(title, fadeInfo, {TextTransparency = 0}):Play()
    
    task.wait(0.7) -- Tunggu panel muncul sempurna

    -- 🎬 TAHAP 2: Eksekusi Efek Mesin Ketik (Typewriter)
    task.spawn(function()
        typewriteText(midLabel, midText, 0.05) -- Ketik teks utama
        task.wait(0.2) -- Jeda dramatis sebelum sisa waktu muncul
        typewriteText(bottomLabel, bottomText, 0.03) -- Ketik teks sisa waktu agak lebih cepat
    end)

    task.wait(4.5) -- Waktu tunggu ditambah agar pemain puas baca animasinya
    
    -- 🎬 TAHAP 3: Fade-Out Mulus Sebelum Masuk Menu
    TweenService:Create(frame, fadeInfo, {BackgroundTransparency = 1}):Play()
    TweenService:Create(stroke, fadeInfo, {Transparency = 1}):Play()
    TweenService:Create(title, fadeInfo, {TextTransparency = 1}):Play()
    TweenService:Create(midLabel, fadeInfo, {TextTransparency = 1}):Play()
    TweenService:Create(bottomLabel, fadeInfo, {TextTransparency = 1}):Play()
    TweenService:Create(glow, fadeInfo, {Transparency = 1}):Play()
    
    task.wait(0.6)
    executeMain()
end

-- ==========================================
-- 🕵️ DETEKSI IDENTITAS PLAYER
-- ==========================================
if myName == elKapitanName then
    showSplash("EL KAPITAN!!\n" .. utf8.char(128572), "Akses Permanen VIP", Color3.fromRGB(255, 220, 50)) return
elseif myName == ayangName then
    showSplash("NYONYA RATU!! " .. utf8.char(128081), pesanBuatAyang, Color3.fromRGB(255, 105, 180)) return
elseif specialMembers[myName] then
    showSplash("SPESIAL MEMBER\n" .. specialMembers[myName], "Akses Permanen VIP", Color3.fromRGB(100, 200, 255)) return
elseif vipMembers[myName] then
    showSplash("VIP MEMBER " .. utf8.char(128081) .. utf8.char(128142), "Akses Permanen Terverifikasi", Color3.fromRGB(255, 215, 0)) return
elseif freeMembers[myName] then
    showSplash("FREE MEMBER", "Akses Gratis Terbatas", Color3.fromRGB(150, 150, 150)) return
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
            -- Format Pembeli Darurat
            showSplash("VIP MEMBER " .. utf8.char(128081) .. utf8.char(128142), "Status: GLOBAL KEY (Darurat)", Color3.fromRGB(255, 215, 0))
            return
        end
    end

    -- TAHAP 2: Cek KeyAuth (Timeout 6 Detik)
    infoLabel.Text = "Menghubungi Keamanan KeyAuth..."
    
    local Name = "PhantomWalk-PRO-1"
    local Ownerid = "drBGNk4DVL"
    local Version = "1.0"
    
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

    local hwid = game:GetService("RbxAnalyticsService"):GetClientId()
    local licRes = fetchWithTimeout("https://keyauth.win/api/1.2/?type=license&key="..inputKey.."&hwid="..hwid.."&sessionid="..initData.sessionid.."&name="..Name.."&ownerid="..Ownerid.."&ver="..Version, 6)
    
    if not licRes or licRes == "" then
        infoLabel.Text = "GAGAL: KeyAuth Tidak Merespon!"
        btnLogin.Text = "LOGIN & EXECUTE"
        return
    end

    local s2, licData = pcall(function() return HttpService:JSONDecode(licRes) end)
    if s2 and licData.success then
        
        -- MESIN PENGHITUNG WAKTU (EXPIRY TRACKER)
        local sisaWaktuTeks = "Sisa Waktu: Tidak Diketahui"
        pcall(function()
            local subs = licData.info.subscriptions[1]
            local expiryUnix = tonumber(subs.expiry)
            local waktuSekarang = os.time()
            local sisaDetik = expiryUnix - waktuSekarang
            
            if sisaDetik < 0 then
                sisaWaktuTeks = "Sisa Waktu: EXPIRED!"
            elseif sisaDetik > 31536000 then 
                sisaWaktuTeks = "Sisa Waktu: Lifetime (Permanen)"
            else
                local hari = math.floor(sisaDetik / 86400)
                local jam = math.floor((sisaDetik % 86400) / 3600)
                local menit = math.floor((sisaDetik % 3600) / 60)
                
                if hari > 0 then
                    sisaWaktuTeks = "Sisa Waktu: " .. hari .. " Hari " .. jam .. " Jam"
                else
                    sisaWaktuTeks = "Sisa Waktu: " .. jam .. " Jam " .. menit .. " Menit"
                end
            end
        end)

        pcall(function() writefile(saveFileName, HttpService:JSONEncode({Key = inputKey})) end)
        frame:Destroy()
        
        -- FORMAT PEMBELI REGULER DENGAN ANIMASI
        showSplash("VIP MEMBER " .. utf8.char(128081) .. utf8.char(128142), sisaWaktuTeks, Color3.fromRGB(255, 215, 0))
    else
        infoLabel.Text = "GAGAL: " .. (licData and licData.message or "Key Salah / Invalid!")
        btnLogin.Text = "LOGIN & EXECUTE"
    end
end)

-- Auto-Login Cek
pcall(function()
    if isfile(saveFileName) then
        local fileContent = readfile(saveFileName)
        local data = HttpService:JSONDecode(fileContent)
        if data.Key then
            txtKey.Text = data.Key
        end
    end
end)
