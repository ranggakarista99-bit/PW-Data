-- ==========================================
-- PHANTOMWALK PRO | PROFESSIONAL LOADER V2
-- Developer: Kucing garong .. utf8.char(128572)
-- Features: Auto-Login HWID, Expiry Info, Pro UI
-- ==========================================

local player = game:GetService("Players").LocalPlayer
local HttpService = game:GetService("HttpService")
local myUserId = 8459930744 
local ayangId = 518969839  

local scriptLink = "https://raw.githubusercontent.com/PhantomWalk-PRO-1/PW-Data/main/PhantomWalk_Main.lua"
local saveFileName = "PhantomWalk_Auth.json"

-- 1. JALUR VIP KHUSUS
if player.UserId == myUserId or player.UserId == ayangId then
    loadstring(game:HttpGet(scriptLink .. "?v=" .. math.random(1,999)))()
    return 
end

-- 2. SETUP UI PROFESIONAL
local sg = Instance.new("ScreenGui", game.CoreGui)
sg.Name = "PhantomAuthPro"

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
title.BackgroundTransparency = 1
title.Text = utf8.char(128640) .. " WELCOME PHANTOMWALK PRO"
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
btnLogin.Text = "SILAHKAN TUNGGU..."
btnLogin.TextColor3 = Color3.fromRGB(255, 255, 255)
btnLogin.Font = Enum.Font.GothamBold
Instance.new("UICorner", btnLogin).CornerRadius = UDim.new(0, 8)

-- 3. KONEKSI API & LOGIKA AUTO-LOGIN
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

    -- INIT API
    local initRes = request_get("https://keyauth.win/api/1.2/?type=init&ver="..Version.."&name="..Name.."&ownerid="..Ownerid)
    local initData = HttpService:JSONDecode(initRes)
    if not initData.success then infoLabel.Text = "Server Error: " .. initData.message return end
    sessionid = initData.sessionid

    -- CEK FILE HWID (AUTO LOGIN)
    local savedKey = ""
    pcall(function()
        if isfile(saveFileName) then
            local fileContent = readfile(saveFileName)
            local data = HttpService:JSONDecode(fileContent)
            savedKey = data.Key
        end
    end)

    local function executeMain()
        infoLabel.Text = "Menarik Harta Karun..."
        local mainCode = request_get(scriptLink .. "?v=" .. math.random(1,999))
        sg:Destroy()
        loadstring(mainCode)()
    end

    local function tryLogin(key)
        btnLogin.Text = "Mengecek License..."
        local licRes = request_get("https://keyauth.win/api/1.2/?type=license&key="..key.."&hwid="..hwid.."&sessionid="..sessionid.."&name="..Name.."&ownerid="..Ownerid.."&ver="..Version)
        local licData = HttpService:JSONDecode(licRes)

        if licData.success then
            -- SIMPAN HWID KE FILE
            pcall(function() writefile(saveFileName, HttpService:JSONEncode({Key = key})) end)
            
            local expiry = os.date("%d-%m-%Y", tonumber(licData.info.expiry))
            infoLabel.Text = utf8.char(11088) .. " Aktif Hingga: " .. expiry
            btnLogin.Text = "LOGIN BERHASIL!"
            btnLogin.BackgroundColor3 = Color3.fromRGB(40, 180, 50)
            task.wait(1.5)
            executeMain()
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
