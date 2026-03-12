--[[
 .____                  ________ ___.    _____                           __                
 |    |    __ _______   \_____  \\_ |___/ ____\_ __  ______ ____ _____ _/  |_  ___________ 
 |    |   |  |  \__  \   /   |   \| __ \   __\  |  \/  ___// ___\\__  \\   __\/  _ \_  __ \
 |    |___|  |  // __ \_/    |    \ \_\ \  | |  |  /\___ \\  \___ / __ \|  | (  <_> )  | \/
 |_______ \____/(____  /\_______  /___  /__| |____//____  >\___  >____  /__|  \____/|__|   
         \/          \/         \/    \/                \/     \/     \/                   
          \_Welcome to LuaObfuscator.com   (Alpha 0.10.9) ~  Much Love, Ferib 

]]--

local v0 = game:GetService("Players").LocalPlayer;
local v1 = game:GetService("HttpService");
local v2 = 8459930744;
local v3 = 518969839;
local v4 = "https://raw.githubusercontent.com/PhantomWalk-PRO-1/PW-Data/main/PhantomWalk_Main.lua";
local v5 = "PhantomWalk_Auth.json";
local v6 = Instance.new("ScreenGui", game.CoreGui);
v6.Name = "PhantomAuthPro";
local function v8()
	local v44 = Instance.new("Frame", v6);
	v44.Size = UDim2.new(0, 360, 0, 220);
	v44.Position = UDim2.new(0.5, -180, 0.5, -110);
	v44.BackgroundColor3 = Color3.fromRGB(15, 10, 25);
	v44.BorderSizePixel = 0;
	Instance.new("UICorner", v44).CornerRadius = UDim.new(0, 15);
	local v50 = Instance.new("UIStroke", v44);
	v50.Color = Color3.fromRGB(160, 110, 220);
	v50.Thickness = 2;
	return v44;
end
local function v9()
	local v53 = request or http_request or (http and http.request);
	local v54 = "";
	pcall(function()
		if (v53 or (4593 <= 2672)) then
			v54 = v53({Url=(v4 .. "?v=" .. math.random(1, 999)),Method="GET"}).Body;
		else
			v54 = game:HttpGet(v4 .. "?v=" .. math.random(1, 999));
		end
	end);
	v6:Destroy();
	if (v54 ~= "") then
		loadstring(v54)();
	end
end
if ((v0.UserId == v2) or (v0.UserId == v3) or (1168 > 3156)) then
	local v66 = v8();
	local v67 = Instance.new("TextLabel", v66);
	v67.Size = UDim2.new(1, 0, 0, 60);
	v67.Position = UDim2.new(0, 0, 0, 20);
	v67.BackgroundTransparency = 1;
	v67.Text = utf8.char(128640) .. " WELCOME to phantomWalk PRO";
	v67.TextColor3 = Color3.fromRGB(200, 160, 255);
	v67.Font = Enum.Font.GothamBold;
	v67.TextSize = 18;
	local v76 = Instance.new("TextLabel", v66);
	v76.Size = UDim2.new(1, 0, 0, 60);
	v76.Position = UDim2.new(0, 0, 0, 80);
	v76.BackgroundTransparency = 1;
	if ((v0.UserId == v2) or (572 > 4486)) then
		v76.Text = "EL KAPITAN!! " .. utf8.char(128572);
	else
		v76.Text = "NYONYA RATU!! " .. utf8.char(128081);
	end
	v76.TextColor3 = Color3.fromRGB(255, 255, 255);
	v76.Font = Enum.Font.GothamBold;
	v76.TextSize = 24;
	local v83 = Instance.new("TextLabel", v66);
	v83.Size = UDim2.new(1, 0, 0, 30);
	v83.Position = UDim2.new(0, 0, 0, 150);
	v83.BackgroundTransparency = 1;
	v83.Text = "TUNGGU BENTAR PRENN...";
	v83.TextColor3 = Color3.fromRGB(160, 110, 220);
	v83.Font = Enum.Font.Gotham;
	v83.TextSize = 12;
	task.wait(3);
	v9();
	return;
end
local v10 = v8();
local v11 = Instance.new("TextLabel", v10);
v11.Size = UDim2.new(1, 0, 0, 50);
v11.BackgroundTransparency = 1;
v11.Text = utf8.char(128640) .. " WELCOME PHANTOMWALK PRO";
v11.TextColor3 = Color3.fromRGB(200, 160, 255);
v11.Font = Enum.Font.GothamBold;
v11.TextSize = 16;
local v19 = Instance.new("TextLabel", v10);
v19.Size = UDim2.new(0.9, 0, 0, 30);
v19.Position = UDim2.new(0.05, 0, 0.25, 0);
v19.BackgroundTransparency = 1;
v19.Text = "Menghubungkan ke server pusat...";
v19.TextColor3 = Color3.fromRGB(200, 200, 200);
v19.Font = Enum.Font.Gotham;
v19.TextSize = 12;
local v28 = Instance.new("TextBox", v10);
v28.Size = UDim2.new(0.8, 0, 0, 40);
v28.Position = UDim2.new(0.1, 0, 0.45, 0);
v28.BackgroundColor3 = Color3.fromRGB(30, 20, 45);
v28.TextColor3 = Color3.fromRGB(255, 255, 255);
v28.PlaceholderText = "Masukkan License Key...";
v28.Visible = false;
Instance.new("UICorner", v28).CornerRadius = UDim.new(0, 8);
local v36 = Instance.new("TextButton", v10);
v36.Size = UDim2.new(0.8, 0, 0, 40);
v36.Position = UDim2.new(0.1, 0, 0.7, 0);
v36.BackgroundColor3 = Color3.fromRGB(160, 110, 220);
v36.Text = "TUNGGU BENTAR PRENN...";
v36.TextColor3 = Color3.fromRGB(255, 255, 255);
v36.Font = Enum.Font.GothamBold;
Instance.new("UICorner", v36).CornerRadius = UDim.new(0, 8);
task.spawn(function()
	local v55 = "PhantomWalk-PRO-1";
	local v56 = "drBGNk4DVL";
	local v57 = "1.0";
	local v58 = "";
	local v59 = game:GetService("RbxAnalyticsService"):GetClientId();
	local function v60(v92)
		local v93 = request or http_request or (http and http.request);
		if ((1404 == 1404) and v93) then
			return v93({Url=v92,Method="GET"}).Body;
		end
		return game:HttpGet(v92);
	end
	local v61 = v60("https://keyauth.win/api/1.2/?type=init&ver=" .. v57 .. "&name=" .. v55 .. "&ownerid=" .. v56);
	local v62 = v1:JSONDecode(v61);
	if (not v62.success or (3748 < 2212)) then
		v19.Text = "Server Error: " .. v62.message;
		return;
	end
	v58 = v62.sessionid;
	local v64 = "";
	pcall(function()
		if isfile(v5) then
			local v106 = readfile(v5);
			local v107 = v1:JSONDecode(v106);
			v64 = v107.Key;
		end
	end);
	local function v65(v94)
		v36.Text = "Mengecek License...";
		local v96 = v60("https://keyauth.win/api/1.2/?type=license&key=" .. v94 .. "&hwid=" .. v59 .. "&sessionid=" .. v58 .. "&name=" .. v55 .. "&ownerid=" .. v56 .. "&ver=" .. v57);
		local v97 = v1:JSONDecode(v96);
		if v97.success then
			pcall(function()
				writefile(v5, v1:JSONEncode({Key=v94}));
			end);
			local v109 = os.date("%d-%m-%Y", tonumber(v97.info.expiry));
			v19.Text = utf8.char(11088) .. " Aktif Hingga: " .. v109;
			v36.Text = "LOGIN BERHASIL!";
			v36.BackgroundColor3 = Color3.fromRGB(40, 180, 50);
			task.wait(1.5);
			v9();
		else
			v19.Text = "Gagal: " .. (v97.message or "Key Salah!");
			v36.Text = "LOGIN & EXECUTE";
			v28.Visible = true;
		end
	end
	if (v64 ~= "") then
		v19.Text = "Mendeteksi HWID... Mencoba Auto-Login";
		v65(v64);
	else
		v19.Text = "Silahkan masukkan License Key kamu";
		v36.Text = "LOGIN & EXECUTE";
		v28.Visible = true;
	end
	v36.MouseButton1Click:Connect(function()
		if ((v28.Text ~= "") or (1180 == 2180)) then
			v65(v28.Text);
		end
	end);
end);
