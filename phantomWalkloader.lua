-- ==========================================
-- PHANTOMWALK PRO | ULTIMATE LOADER V4.1 (RAINBOW MASTERPIECE)
-- Developer: Kucing garong .. utf8.char(128572)
-- Features: Auto-Detect, Async Download, Random Theme Colors, Jumbo Clean Text, & Fixed Looping Dots
-- ==========================================

local player = game:GetService("Players").LocalPlayer
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local myName = player.Name 

-- ==========================================
-- 🎨 [ MESIN WARNA DINAMIS ] 🎨
-- ==========================================
-- Berisi 10 warna premium yang akan diacak setiap kali script di-execute!
local colorPalette = {
    Color3.fromRGB(255, 215, 0),   -- Emas Sultan
    Color3.fromRGB(255, 105, 180), -- Pink Nyonya
    Color3.fromRGB(0, 255, 255),   -- Biru Es
    Color3.fromRGB(57, 255, 20),   -- Hijau Toxic
    Color3.fromRGB(220, 20, 60),   -- Merah Darah
    Color3.fromRGB(191, 0, 255),   -- Ungu Janda
    Color3.fromRGB(255, 140, 0),   -- Jingga Senja
    Color3.fromRGB(100, 200, 255), -- Biru Langit
    Color3.fromRGB(152, 255, 152), -- Hijau Mint
    Color3.fromRGB(255, 182, 193)  -- Merah Muda Pastel
}
math.randomseed(tick() % 1 * 1000000)
local THEME_COLOR = colorPalette[math.random(1, #colorPalette)]

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
    ["Anomali_9950"] = utf8.char(128081) .. " CIE ABIS NGE DATE NIH BOSS " .. utf8.char(128081),
    ["A50"] = "BEST PRENNN",
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
-- 🚀 FUNGSI MESIN LOADER & UI ANIMASI
-- ==========================================
local sg = Instance.new("ScreenGui", game.CoreGui)
sg.Name = "PhantomAuthPro"

-- Fungsi khusus untuk mengetik huruf satu per satu
local function typewriteText(label, textStr, speed)
    label.Text = textStr
    label.MaxVisibleGraphemes = 0
    
    local graphemeCount = 0
    for _ in utf8.graphemes(textStr) do
        graphemeCount = graphemeCount + 1
    end
    
    for i = 1, graphemeCount do
        label.MaxVisibleGraphemes = i
        task.wait(speed or 0.04) 
    end
end

local function showSplash(midText, bottomText, textColor)
    
    -- Pre-loading script secara Async (diam-diam di background)
    local mainCode = ""
    local downloadComplete = false
    task.spawn(function()
        pcall(function()
            local r = request or http_request or (http and http.request)
            if r then mainCode = r({Url = scriptLink .. "?v=" .. math.random(1,9999), Method = "GET"}).Body
            else mainCode = game:HttpGet(scriptLink .. "?v=" .. math.random(1,9999)) end
        end)
        downloadComplete = true 
    end)

    local frame = Instance.new("Frame", sg)
    frame.Size = UDim2.new(0, 380, 0, 240)
    frame.Position = UDim2.new(0.5, -190, 0.5, -120)
    frame.BackgroundColor3 = Color3.fromRGB(15, 10, 25)
    frame.BackgroundTransparency = 1 
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
    title.TextSize = 18 
    title.TextTransparency = 1

    local midLabel = Instance.new("TextLabel", frame)
    midLabel.Size = UDim2.new(1, 0, 0, 60)
    midLabel.Position = UDim2.new(0, 0, 0, 80)
    midLabel.BackgroundTransparency = 1
    midLabel.Text = ""
    midLabel.TextColor3 = textColor 
    midLabel.Font = Enum.Font.GothamBlack 
    midLabel.TextSize = 36 -- Sambutan Raksasa

    local bottomLabel = Instance.new("TextLabel", frame)
    bottomLabel.Size = UDim2.new(1, 0, 0, 30)
    bottomLabel.Position = UDim2.new(0, 0, 0, 165)
    bottomLabel.BackgroundTransparency = 1
    bottomLabel.Text = ""
    bottomLabel.TextColor3 = textColor 
    bottomLabel.Font = Enum.Font.GothamBold
    bottomLabel.TextSize = 16 

    -- 🎬 TAHAP 1: Fade-In Latar Belakang & Judul
    local fadeInfo = TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(frame, fadeInfo, {BackgroundTransparency = 0}):Play()
    TweenService:Create(stroke, fadeInfo, {Transparency = 0}):Play()
    TweenService:Create(title, fadeInfo, {TextTransparency = 0}):Play()
    
    task.wait(0.7) 

    -- 🎬 TAHAP 2: Ketikan Sambutan Nama (Waktu total 4 detik)
    task.spawn(function()
        typewriteText(midLabel, midText, 0.05) 
        task.wait(0.2) 
        typewriteText(bottomLabel, bottomText, 0.03) 
    end)

    task.wait(4) 
    
    -- 🎬 TAHAP 3: Transisi Mulus ke "please wait"
    local fadeFast = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(midLabel, fadeFast, {TextTransparency = 1}):Play()
    TweenService:Create(bottomLabel, fadeFast, {TextTransparency = 1}):Play()
    
    task.wait(0.3)
    
    -- Mengecilkan Ukuran untuk Layar Loading & Tetap Memakai Warna Tema
    midLabel.TextSize = 28 
    bottomLabel.TextSize = 14
    
    midLabel.TextTransparency = 0
    bottomLabel.TextTransparency = 0
    
    -- 🎬 TAHAP 4: Mengetik "please wait"
    task.spawn(function()
        typewriteText(midLabel, "please wait", 0.05)
        task.wait(0.1)
        typewriteText(bottomLabel, "Loading PhantomWalk API...", 0.03)
    end)
    
    task.wait(1.5)
    
    -- 🎬 TAHAP 5: Animasi Titik Berulang 
    midLabel.MaxVisibleGraphemes = -1 -- KUNCI RAHASIA: Membuka limit huruf agar titiknya muncul!
    local dots = 0
    
    while not downloadComplete do
        dots = (dots + 1) % 5 
        local dotStr = string.rep(" .", dots)
        midLabel.Text = "please wait" .. dotStr
        task.wait(0.3)
        
        if not sg.Parent then break end 
    end
    
    -- Penutup estetik sebelum memudar
    midLabel.Text = "please wait . . . ."
    task.wait(0.4) 

    -- 🎬 TAHAP 6: Fade-Out Mulus & Eksekusi Script
    TweenService:Create(frame, fadeInfo, {BackgroundTransparency = 1}):Play()
    TweenService:Create(stroke, fadeInfo, {Transparency = 1}):Play()
    TweenService:Create(title, fadeInfo, {TextTransparency = 1}):Play()
    TweenService:Create(midLabel, fadeInfo, {TextTransparency = 1}):Play()
    TweenService:Create(bottomLabel, fadeInfo, {TextTransparency = 1}):Play()
    
    task.wait(0.6)
    sg:Destroy()
    
    if mainCode ~= "" then 
        -- ☠️ [EL KAPITAN PATCH]: THE SECRET HANDSHAKE ☠️
        -- Ini sandi yang akan dikirim ke main_lua biar pemainnya gak di-kick!
        _G.PhantomVIP_Unlock = "PW_AUTH_X99_ZULU_8821_KAPITAN_V28_SECURE"
        
        loadstring(mainCode)() 
    end
end

-- ==========================================
-- 🕵️ DETEKSI IDENTITAS PLAYER
-- ==========================================
if myName == elKapitanName then
    showSplash("EL KAPITAN!! " .. utf8.char(128572), "Akses Permanen VIP", THEME_COLOR) return
elseif myName == ayangName then
    showSplash("NYONYA RATU!! " .. utf8.char(128081), pesanBuatAyang, THEME_COLOR) return
elseif specialMembers[myName] then
    showSplash(specialMembers[myName], "Akses Permanen VIP", THEME_COLOR) return
elseif vipMembers[myName] then
    showSplash("VIP MEMBER " .. utf8.char(128081) .. utf8.char(128142), "Akses Permanen Terverifikasi", THEME_COLOR) return
elseif freeMembers[myName] then
    showSplash("FREE MEMBER", "Akses Gratis Terbatas", THEME_COLOR) return
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

    local resultG = fetchWithTimeout(globalKeyURL .. "?v=" .. math.random(1,9999), 4)
    if resultG then
        local serverKey = string.gsub(resultG, "%s+", "")
        local userKey = string.gsub(inputKey, "%s+", "")
        if userKey == serverKey and serverKey ~= "" then
            frame:Destroy()
            showSplash("VIP MEMBER " .. utf8.char(128081) .. utf8.char(128142), "Status: GLOBAL KEY (Darurat)", THEME_COLOR)
            return
        end
    end

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
        
        showSplash("VIP MEMBER " .. utf8.char(128081) .. utf8.char(128142), sisaWaktuTeks, THEME_COLOR)
    else
        infoLabel.Text = "GAGAL: " .. (licData and licData.message or "Key Salah / Invalid!")
        btnLogin.Text = "LOGIN & EXECUTE"
    end
end)

pcall(function()
    if isfile(saveFileName) then
        local fileContent = readfile(saveFileName)
        local data = HttpService:JSONDecode(fileContent)
        if data.Key then
            txtKey.Text = data.Key
        end
    end
end)
