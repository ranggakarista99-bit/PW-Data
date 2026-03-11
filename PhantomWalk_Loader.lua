-- ==========================================
-- PHANTOMWALK-PRO-1 | LOADER POLOSAN (TEST)
-- ==========================================

local player = game:GetService("Players").LocalPlayer
local myUserId = 8459930744 -- ID EL CAPITAN
local queenId = 518969839  -- ID EL NYONYA RATU

-- LINK HARTA KARUN GITHUB (Pastikan ini sesuai dengan nama file di GitHub kamu)
local scriptLink = "https://raw.githubusercontent.com/PhantomWalk-PRO-1/PW-Data/refs/heads/main/PhantomWalk_Main.lua.txt"

-- CEK AKSES VIP DULU
if player.UserId == myUserId or player.UserId == queenId then
    print("Selamat datang VIP!")
    loadstring(game:HttpGet(scriptLink))()
    return
end

-- SETUP KEYAUTH
local Name = "PhantomWalk-PRO-1"
local Ownerid = "drBGNk4DVL"
local Secret = "7701abd392686be2e893a03ad30d4370842d6ce11949275976ca1ba311c4ef6e"
local Version = "1.0"

local KeyAuth = loadstring(game:HttpGet("https://raw.githubusercontent.com/KeyAuth/KeyAuth-Roblox/main/keyauth.lua"))()
KeyAuth.api.name = Name
KeyAuth.api.ownerid = Ownerid
KeyAuth.api.secret = Secret
KeyAuth.api.version = Version
KeyAuth.api:init()

-- UI LOGIN SEDERHANA UNTUK TES
local sg = Instance.new("ScreenGui", game.CoreGui)
local frame = Instance.new("Frame", sg)
frame.Size = UDim2.new(0, 300, 0, 150)
frame.Position = UDim2.new(0.5, -150, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

local txt = Instance.new("TextBox", frame)
txt.Size = UDim2.new(0.8, 0, 0, 40)
txt.Position = UDim2.new(0.1, 0, 0.2, 0)
txt.PlaceholderText = "Input Key Di Sini"

local btn = Instance.new("TextButton", frame)
btn.Size = UDim2.new(0.8, 0, 0, 40)
btn.Position = UDim2.new(0.1, 0, 0.6, 0)
btn.Text = "LOGIN"

btn.MouseButton1Click:Connect(function()
    KeyAuth.api:license(txt.Text)
    if KeyAuth.api.success then
        sg:Destroy()
        loadstring(game:HttpGet(scriptLink))()
    else
        btn.Text = "KUNCI SALAH!"
        task.wait(1)
        btn.Text = "LOGIN"
    end
end)
