---------------------------------------------------------------------

--- { SERVICES, VARIABLES, GENERAL SETUP } ---

---------------------------------------------------------------------

local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local lP = game:GetService("Players").LocalPlayer
local pN = lP.Name
local pC = game.Workspace.Characters:WaitForChild(pN)

local nG = Instance.new("ScreenGui", lP.PlayerGui); nG.Enabled = false
local gF = Instance.new("Frame", nG); gF.BackgroundTransparency = 1; gF.Position = UDim2.new(0.0075,0,0.62,0); gF.Size = UDim2.new(0.2,0,0.18,0)
local gTB1 = Instance.new("TextBox", gF); gTB1.Name = "Box1"; gTB1.BackgroundTransparency = 1; gTB1.Size = UDim2.new(1,0,0.2,0); gTB1.Position = UDim2.new(0,0,0,0); gTB1.Text = ""; gTB1.TextXAlignment = "Left"; gTB1.TextColor3 = Color3.new(255,255,255); gTB1.TextSize = 24; gTB1.Font = Enum.Font.SourceSansBold
local gTB2 = Instance.new("TextBox", gF); gTB2.Name = "Box2"; gTB2.BackgroundTransparency = 1; gTB2.Size = UDim2.new(1,0,0.2,0); gTB2.Position = UDim2.new(0,0,0.2,0); gTB2.Text = ""; gTB2.TextXAlignment = "Left"; gTB2.TextColor3 = Color3.new(255,255,255); gTB2.TextSize = 24; gTB2.Font = Enum.Font.SourceSansBold
local gTB3 = Instance.new("TextBox", gF); gTB3.Name = "Box3"; gTB3.BackgroundTransparency = 1; gTB3.Size = UDim2.new(1,0,0.2,0); gTB3.Position = UDim2.new(0,0,0.4,0); gTB3.Text = ""; gTB3.TextXAlignment = "Left"; gTB3.TextColor3 = Color3.new(255,255,255); gTB3.TextSize = 24; gTB3.Font = Enum.Font.SourceSansBold
local gTB4 = Instance.new("TextBox", gF); gTB4.Name = "Box4"; gTB4.BackgroundTransparency = 1; gTB4.Size = UDim2.new(1,0,0.2,0); gTB4.Position = UDim2.new(0,0,0.6,0); gTB4.Text = ""; gTB4.TextXAlignment = "Left"; gTB4.TextColor3 = Color3.new(255,255,255); gTB4.TextSize = 24; gTB4.Font = Enum.Font.SourceSansBold
local gTB5 = Instance.new("TextBox", gF); gTB5.Name = "Box5"; gTB5.BackgroundTransparency = 1; gTB5.Size = UDim2.new(1,0,0.2,0); gTB5.Position = UDim2.new(0,0,0.8,0); gTB5.Text = ""; gTB5.TextXAlignment = "Left"; gTB5.TextColor3 = Color3.new(255,255,255); gTB5.TextSize = 24; gTB5.Font = Enum.Font.SourceSansBold

local localcall = nil
local localadd = nil
local remotecall = nil
local remoteadd = nil

local pdC = false
local iR = false
local rJ = false

local rH = -3.5
local guiP = 0
local sV = 0
local nS = 0
local nJ = 0
local gS = 0
local tS = 0
local sP = 0

local allguis = game.Players.LocalPlayer.PlayerGui:GetDescendants()
local function getspeedgui() for i,v in pairs(allguis) do if v.ClassName == "TextLabel" and string.find(v.Text,"u/s") then return(v) end end end repeat allguis = game.Players.LocalPlayer.PlayerGui:GetDescendants(); wait(1); speedgui = getspeedgui(); until speedgui
local function gettimegui() for i,v in pairs(allguis) do if v.ClassName == "TextLabel" and string.find(v.Text,"Time: ") then return(v) end end end repeat allguis = game.Players.LocalPlayer.PlayerGui:GetDescendants() wait(1)	timegui = gettimegui() until timegui

---------------------------------------------------------------------

--- { CUSTOM COMMANDS } ---

---------------------------------------------------------------------

for i,v in pairs(getgc(true)) do
	if type(v) == "table" then
		if rawget(v,"Call") and rawget(v,"Add") and rawget(v,"InitLast") and not remotecall then
			remotecall = v["Call"]
			remoteadd = v["Add"]
		end
		if rawget(v,"Call") and rawget(v,"Add") and not rawget(v,"InitLast") and not localcall then
			localcall = v["Call"]
			localadd = v["Add"]
		end
		if remotecall and localcall then
			break
		end
	end
end

local function addCommand(name,validValues,func)
	remoteadd(tostring(func),func)
	remotecall("AddClientCommand",name,validValues,tostring(func))
end

addCommand("jahGui", {}, function()
	pdC = not pdC
	if pdC == true then
		nG.Enabled = true
	else
		nG.Enabled = false
		gTB1.Text = ""
		gTB2.Text = ""
		gTB3.Text = ""
		gTB4.Text = ""
		gTB5.Text = ""
	end
end)

addCommand("cG", {}, function()
	if guiP == 0 then
		guiP = 1
		lP.PlayerGui.QBox.Frame.ImageLabel.Position = UDim2.new(1,-1170,1,-790)
	elseif guiP == 1 then
		guiP = 0
		lP.PlayerGui.QBox.Frame.ImageLabel.Position = UDim2.new(1,-1170,1,-805)
	end
end)

addCommand("tG", {"Number"}, function(num)
	lP.PlayerGui.QBox.Frame.ImageLabel.ImageTransparency = num
	lP.PlayerGui.QBox.Frame.ImageLabel.ImageLabel.ImageTransparency = num
end)

---------------------------------------------------------------------

--- { CUSTOM FUNCTIONS and UIS } ---

---------------------------------------------------------------------


UIS.InputChanged:Connect(function(input)
	local delta = input.Delta
	if UIS:IsKeyDown(Enum.KeyCode.Space) and delta.X > 0 then
		if sV == 0 then
			sV = 2
			nS = nS + 1
		elseif sV == 1 then
			sV = 2
			nS = nS + 1
		end

		if UIS:IsKeyDown(Enum.KeyCode.D) then
			gS = gS + 1
			tS = tS + 1
			sP = gS/tS
		else
			tS = tS + 1
			sP = gS/tS
		end
	elseif UIS:IsKeyDown(Enum.KeyCode.Space) and delta.X < 0 then
		if sV == 0 then
			sV = 1
			nS = nS + 1
		elseif sV == 2 then
			sV = 1
			nS = nS + 1
		end

		if UIS:IsKeyDown(Enum.KeyCode.A) then
			gS = gS + 1
			tS = tS + 1
			sP = gS/tS
		else
			tS = tS + 1
			sP = gS/tS
		end
	elseif UIS:IsKeyDown(Enum.KeyCode.Space) and delta.X == 0 then
		-- Nothing
	end
end)


UIS.InputBegan:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.Space and iR == false and pdC == true then
		iR = true
		nJ = nJ + 1
		gTB1.Text = ""
		gTB2.Text = ""
		gTB3.Text = ""
		gTB4.Text = ""
		gTB5.TextColor3 = Color3.new(255,255,255)
		gTB5.Text = "J: " .. nJ .. "| Sync: " .. (math.floor((sP * 10^4) + 0.5)/(10^2)) .. "% | Spd: " .. tonumber(speedgui.Text:sub(0,-4)) .. " | Strafes: " .. nS
		print("")
		print("--------- { NEW RUN } ---------")
		print("")
		print("J: " .. nJ .. "| Sync: " .. (math.floor((sP * 10^4) + 0.5)/(10^2)) .. "% | Spd: " .. tonumber(speedgui.Text:sub(0,-4)) .. " | Strafes: " .. nS)
	elseif input.KeyCode == Enum.KeyCode.Space and iR == true and pdC == true then

	end	
end)

local function pogDog()
	if tonumber(timegui.Text:sub(13,15)) > 0 or tonumber(timegui.Text:sub(10,11)) > 0 or tonumber(timegui.Text:sub(7,8)) > 0 then
		local ray = Ray.new(pC.Torso.CFrame.Position, Vector3.new(0, rH, 0))
		local hit = workspace:FindPartOnRayWithIgnoreList(ray, {pC})

		if hit and rJ == false and iR == true and UIS:IsKeyDown(Enum.KeyCode.Space) then
			rJ = true

			if nJ == 0 then
				nJ = nJ + 2
				gTB1.Text = ""
				gTB2.Text = ""
				gTB3.Text = ""
				gTB4.Text = gTB5.Text
				gTB1.TextColor3 = Color3.new(255,255,255)
				gTB2.TextColor3 = Color3.new(255,255,255)
				gTB3.TextColor3 = Color3.new(255,255,255)
				gTB4.TextColor3 = Color3.new(255,255,255)
				gTB5.TextColor3 = Color3.new(255,255,255)
				gTB5.Text = "J: " .. nJ .. "| Sync: " .. (math.floor((sP * 10^4) + 0.5)/(10^2)) .. "% | Spd: " .. tonumber(speedgui.Text:sub(0,-4)) .. " | Strafes: " .. nS
				print("J: " .. nJ .. "| Sync: " .. (math.floor((sP * 10^4) + 0.5)/(10^2)) .. "% | Spd: " .. tonumber(speedgui.Text:sub(0,-4)) .. " | Strafes: " .. nS)
			elseif nJ == 1 then
				nJ = nJ + 1
				gTB1.Text = ""
				gTB2.Text = ""
				gTB3.Text = gTB4.Text
				gTB4.Text = gTB5.Text
				gTB1.TextColor3 = Color3.new(255,255,255)
				gTB2.TextColor3 = Color3.new(255,255,255)
				gTB3.TextColor3 = Color3.new(255,255,255)
				gTB4.TextColor3 = Color3.new(255,255,255)
				gTB5.TextColor3 = Color3.new(255,255,255)
				gTB5.Text = "J: " .. nJ .. "| Sync: " .. (math.floor((sP * 10^4) + 0.5)/(10^2)) .. "% | Spd: " .. tonumber(speedgui.Text:sub(0,-4)) .. " | Strafes: " .. nS
				print("J: " .. nJ .. "| Sync: " .. (math.floor((sP * 10^4) + 0.5)/(10^2)) .. "% | Spd: " .. tonumber(speedgui.Text:sub(0,-4)) .. " | Strafes: " .. nS)
			elseif nJ == 2 then
				nJ = nJ + 1
				gTB1.Text = ""
				gTB2.Text = gTB3.Text
				gTB3.Text = gTB4.Text
				gTB4.Text = gTB5.Text
				gTB1.TextColor3 = Color3.new(255,255,255)
				gTB2.TextColor3 = Color3.new(255,255,255)
				gTB3.TextColor3 = Color3.new(255,255,255)
				gTB4.TextColor3 = Color3.new(255,255,255)
				gTB5.TextColor3 = Color3.new(255,255,255)
				gTB5.Text = "J: " .. nJ .. "| Sync: " .. (math.floor((sP * 10^4) + 0.5)/(10^2)) .. "% | Spd: " .. tonumber(speedgui.Text:sub(0,-4)) .. " | Strafes: " .. nS
				print("J: " .. nJ .. "| Sync: " .. (math.floor((sP * 10^4) + 0.5)/(10^2)) .. "% | Spd: " .. tonumber(speedgui.Text:sub(0,-4)) .. " | Strafes: " .. nS)
			elseif nJ == 3 then
				nJ = nJ + 1
				gTB1.Text = gTB2.Text
				gTB2.Text = gTB3.Text
				gTB3.Text = gTB4.Text
				gTB4.Text = gTB5.Text
				gTB1.TextColor3 = Color3.new(255,255,255)
				gTB2.TextColor3 = Color3.new(255,255,255)
				gTB3.TextColor3 = Color3.new(255,255,255)
				gTB4.TextColor3 = Color3.new(255,255,255)
				gTB5.TextColor3 = Color3.new(255,255,255)
				gTB5.Text = "J: " .. nJ .. "| Sync: " .. (math.floor((sP * 10^4) + 0.5)/(10^2)) .. "% | Spd: " .. tonumber(speedgui.Text:sub(0,-4)) .. " | Strafes: " .. nS
				print("J: " .. nJ .. "| Sync: " .. (math.floor((sP * 10^4) + 0.5)/(10^2)) .. "% | Spd: " .. tonumber(speedgui.Text:sub(0,-4)) .. " | Strafes: " .. nS)
			elseif nJ == 4 then
				nJ = nJ + 1
				gTB1.Text = gTB2.Text
				gTB2.Text = gTB3.Text
				gTB3.Text = gTB4.Text
				gTB4.Text = gTB5.Text
				gTB1.TextColor3 = Color3.new(255,255,255)
				gTB2.TextColor3 = Color3.new(255,255,255)
				gTB3.TextColor3 = Color3.new(255,255,255)
				gTB4.TextColor3 = Color3.new(255,255,255)
				gTB5.TextColor3 = Color3.new(255,255,255)
				gTB5.Text = "J: " .. nJ .. "| Sync: " .. (math.floor((sP * 10^4) + 0.5)/(10^2)) .. "% | Spd: " .. tonumber(speedgui.Text:sub(0,-4)) .. " | Strafes: " .. nS
				print("J: " .. nJ .. "| Sync: " .. (math.floor((sP * 10^4) + 0.5)/(10^2)) .. "% | Spd: " .. tonumber(speedgui.Text:sub(0,-4)) .. " | Strafes: " .. nS)
			elseif nJ == 5 then
				nJ = nJ + 1
				gTB1.Text = gTB2.Text
				gTB2.Text = gTB3.Text
				gTB3.Text = gTB4.Text
				gTB4.Text = gTB5.Text
				gTB1.TextColor3 = Color3.new(255,255,255)
				gTB2.TextColor3 = Color3.new(255,255,255)
				gTB3.TextColor3 = Color3.new(255,255,255)
				gTB4.TextColor3 = Color3.new(255,255,255)
				gTB5.TextColor3 = Color3.new(0,255,0)
				gTB5.Text = "J: " .. nJ .. "| Sync: " .. (math.floor((sP * 10^4) + 0.5)/(10^2)) .. "% | Spd: " .. tonumber(speedgui.Text:sub(0,-4)) .. " | Strafes: " .. nS
				print("*** SIXTH JUMP *** " .. "J: " .. nJ .. "| Sync: " .. (math.floor((sP * 10^4) + 0.5)/(10^2)) .. "% | Spd: " .. tonumber(speedgui.Text:sub(0,-4)) .. " | Strafes: " .. nS)
			elseif nJ == 6 then
				nJ = nJ + 1
				gTB1.Text = gTB2.Text
				gTB2.Text = gTB3.Text
				gTB3.Text = gTB4.Text
				gTB4.Text = gTB5.Text
				gTB1.TextColor3 = Color3.new(255,255,255)
				gTB2.TextColor3 = Color3.new(255,255,255)
				gTB3.TextColor3 = Color3.new(255,255,255)
				gTB4.TextColor3 = Color3.new(0,255,0)
				gTB5.TextColor3 = Color3.new(255,255,255)
				gTB5.Text = "J: " .. nJ .. "| Sync: " .. (math.floor((sP * 10^4) + 0.5)/(10^2)) .. "% | Spd: " .. tonumber(speedgui.Text:sub(0,-4)) .. " | Strafes: " .. nS
				print("J: " .. nJ .. "| Sync: " .. (math.floor((sP * 10^4) + 0.5)/(10^2)) .. "% | Spd: " .. tonumber(speedgui.Text:sub(0,-4)) .. " | Strafes: " .. nS)
			elseif nJ == 7 then
				nJ = nJ + 1
				gTB1.Text = gTB2.Text
				gTB2.Text = gTB3.Text
				gTB3.Text = gTB4.Text
				gTB4.Text = gTB5.Text
				gTB1.TextColor3 = Color3.new(255,255,255)
				gTB2.TextColor3 = Color3.new(255,255,255)
				gTB3.TextColor3 = Color3.new(0,255,0)
				gTB4.TextColor3 = Color3.new(255,255,255)
				gTB5.TextColor3 = Color3.new(255,255,255)
				gTB5.Text = "J: " .. nJ .. "| Sync: " .. (math.floor((sP * 10^4) + 0.5)/(10^2)) .. "% | Spd: " .. tonumber(speedgui.Text:sub(0,-4)) .. " | Strafes: " .. nS
				print("J: " .. nJ .. "| Sync: " .. (math.floor((sP * 10^4) + 0.5)/(10^2)) .. "% | Spd: " .. tonumber(speedgui.Text:sub(0,-4)) .. " | Strafes: " .. nS)
			elseif nJ == 8 then
				nJ = nJ + 1
				gTB1.Text = gTB2.Text
				gTB2.Text = gTB3.Text
				gTB3.Text = gTB4.Text
				gTB4.Text = gTB5.Text
				gTB1.TextColor3 = Color3.new(255,255,255)
				gTB2.TextColor3 = Color3.new(0,255,0)
				gTB3.TextColor3 = Color3.new(255,255,255)
				gTB4.TextColor3 = Color3.new(255,255,255)
				gTB5.TextColor3 = Color3.new(255,255,255)
				gTB5.Text = "J: " .. nJ .. "| Sync: " .. (math.floor((sP * 10^4) + 0.5)/(10^2)) .. "% | Spd: " .. tonumber(speedgui.Text:sub(0,-4)) .. " | Strafes: " .. nS
				print("J: " .. nJ .. "| Sync: " .. (math.floor((sP * 10^4) + 0.5)/(10^2)) .. "% | Spd: " .. tonumber(speedgui.Text:sub(0,-4)) .. " | Strafes: " .. nS)
			elseif nJ == 9 then
				nJ = nJ + 1
				gTB1.Text = gTB2.Text
				gTB2.Text = gTB3.Text
				gTB3.Text = gTB4.Text
				gTB4.Text = gTB5.Text
				gTB1.TextColor3 = Color3.new(0,255,0)
				gTB2.TextColor3 = Color3.new(255,255,255)
				gTB3.TextColor3 = Color3.new(255,255,255)
				gTB4.TextColor3 = Color3.new(255,255,255)
				gTB5.TextColor3 = Color3.new(255,255,255)
				gTB5.Text = "J: " .. nJ .. "| Sync: " .. (math.floor((sP * 10^4) + 0.5)/(10^2)) .. "% | Spd: " .. tonumber(speedgui.Text:sub(0,-4)) .. " | Strafes: " .. nS
				print("J: " .. nJ .. "| Sync: " .. (math.floor((sP * 10^4) + 0.5)/(10^2)) .. "% | Spd: " .. tonumber(speedgui.Text:sub(0,-4)) .. " | Strafes: " .. nS)
			elseif nJ > 3 and nJ ~= 5 then
				nJ = nJ + 1
				gTB2.Text = "--------------------------"
				gTB3.Text = gTB4.Text
				gTB4.Text = gTB5.Text
				gTB1.TextColor3 = Color3.new(0,255,0)
				gTB2.TextColor3 = Color3.new(255,255,255)
				gTB3.TextColor3 = Color3.new(255,255,255)
				gTB4.TextColor3 = Color3.new(255,255,255)
				gTB5.TextColor3 = Color3.new(255,255,255)
				gTB5.Text = "J: " .. nJ .. "| Sync: " .. (math.floor((sP * 10^4) + 0.5)/(10^2)) .. "% | Spd: " .. tonumber(speedgui.Text:sub(0,-4)) .. " | Strafes: " .. nS
				print("J: " .. nJ .. "| Sync: " .. (math.floor((sP * 10^4) + 0.5)/(10^2)) .. "% | Spd: " .. tonumber(speedgui.Text:sub(0,-4)) .. " | Strafes: " .. nS)
			end

			wait(0.15)
			rJ = false
			nS = 0
		end

		iR = true
	else
		iR = false
		nJ = 0
		nS = 0
		sV = 0
		gS = 0
		tS = 0
		sP = 0
	end
end

RS.RenderStepped:Connect(function()
	if pdC == true then
		pogDog()
	end

	for i,v in pairs(game.Workspace:GetChildren()) do
		if v:IsA("Model") and string.find(v.Name, "Bot") then
			v.Parent = game.Workspace.Characters
		end
	end
end)
