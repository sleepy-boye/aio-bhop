-- Services
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

-- Player Info
local lP = game:GetService("Players").LocalPlayer
local pN = lP.Name
local pC = game.Workspace.Characters:WaitForChild(pN)

-- Display Gui
local nG = Instance.new("ScreenGui", lP.PlayerGui)
local gF = Instance.new("Frame", nG); gF.BackgroundTransparency = 1; gF.Position = UDim2.new(0.0075,0,0.62,0); gF.Size = UDim2.new(0.2,0,0.18,0)
local gTB1 = Instance.new("TextBox", gF); gTB1.Name = "Box1"; gTB1.BackgroundTransparency = 1; gTB1.Size = UDim2.new(1,0,0.2,0); gTB1.Position = UDim2.new(0,0,0,0); gTB1.Text = ""; gTB1.TextXAlignment = "Left"; gTB1.TextColor3 = Color3.new(255,255,255); gTB1.TextSize = 24; gTB1.Font = Enum.Font.SourceSansBold
local gTB2 = Instance.new("TextBox", gF); gTB2.Name = "Box2"; gTB2.BackgroundTransparency = 1; gTB2.Size = UDim2.new(1,0,0.2,0); gTB2.Position = UDim2.new(0,0,0.2,0); gTB2.Text = ""; gTB2.TextXAlignment = "Left"; gTB2.TextColor3 = Color3.new(255,255,255); gTB2.TextSize = 24; gTB2.Font = Enum.Font.SourceSansBold
local gTB3 = Instance.new("TextBox", gF); gTB3.Name = "Box3"; gTB3.BackgroundTransparency = 1; gTB3.Size = UDim2.new(1,0,0.2,0); gTB3.Position = UDim2.new(0,0,0.4,0); gTB3.Text = ""; gTB3.TextXAlignment = "Left"; gTB3.TextColor3 = Color3.new(255,255,255); gTB3.TextSize = 24; gTB3.Font = Enum.Font.SourceSansBold
local gTB4 = Instance.new("TextBox", gF); gTB4.Name = "Box4"; gTB4.BackgroundTransparency = 1; gTB4.Size = UDim2.new(1,0,0.2,0); gTB4.Position = UDim2.new(0,0,0.6,0); gTB4.Text = ""; gTB4.TextXAlignment = "Left"; gTB4.TextColor3 = Color3.new(255,255,255); gTB4.TextSize = 24; gTB4.Font = Enum.Font.SourceSansBold
local gTB5 = Instance.new("TextBox", gF); gTB5.Name = "Box5"; gTB5.BackgroundTransparency = 1; gTB5.Size = UDim2.new(1,0,0.2,0); gTB5.Position = UDim2.new(0,0,0.8,0); gTB5.Text = ""; gTB5.TextXAlignment = "Left"; gTB5.TextColor3 = Color3.new(255,255,255); gTB5.TextSize = 24; gTB5.Font = Enum.Font.SourceSansBold

-- Variables
local rH = -3.5
local isJumping = false
local recentlyJumped = false
local timer = nil
local strafeValue = 0
local numJumps = 0
local numStrafes = 0
local syncPercent = 0

-- Speed and Timer Gui

local allguis = game.Players.LocalPlayer.PlayerGui:GetDescendants()

local function getspeedgui()
	for i,v in pairs(allguis) do
		if v.ClassName == "TextLabel" and string.find(v.Text,"u/s") then
			return(v)
		end
	end
end
repeat
	allguis = game.Players.LocalPlayer.PlayerGui:GetDescendants()
	wait(1)
	speedgui = getspeedgui()
until speedgui

local function gettimegui()
	for i,v in pairs(allguis) do
		if v.ClassName == "TextLabel" and string.find(v.Text,"Time: ") then
			return(v)
		end
	end
end
repeat
	allguis = game.Players.LocalPlayer.PlayerGui:GetDescendants()
	wait(1)
	timegui = gettimegui()
until timegui

RS.RenderStepped:Connect(function()
	if tonumber(timegui.Text:sub(13,15)) > 0 or tonumber(timegui.Text:sub(10,11)) > 0 or tonumber(timegui.Text:sub(7,8)) > 0 then
		local ray = Ray.new(pC.Torso.CFrame.Position, Vector3.new(0, rH, 0))
		local hit = workspace:FindPartOnRayWithIgnoreList(ray, {pC})
		
		if hit and UIS:IsKeyDown(Enum.KeyCode.Space) and recentlyJumped == false then
			
			isJumping = true
			
			UIS.InputChanged:Connect(function(input)
				local delta = input.Delta
				if delta.X > 0 and strafeValue == 0 and isJumping == true and UIS:IsKeyDown(Enum.KeyCode.Space) then
					strafeValue = 1
					numStrafes = numStrafes + 1
				elseif delta.X < 0 and strafeValue == 1 and isJumping == true and UIS:IsKeyDown(Enum.KeyCode.Space) then
					strafeValue = 0
					numStrafes = numStrafes + 1
				end
			end)
			
			recentlyJumped = true
			numJumps = numJumps + 1
			
			if numJumps == 1 then
				gTB1.Text = ""
				gTB2.Text = ""
				gTB3.Text = ""
				gTB4.Text = ""
				gTB5.Text = "J: " .. numJumps + 1 .. " | Spd: " .. tonumber(speedgui.Text:sub(0,-4)) .. " | Strafes: " .. numStrafes
				print("J: " .. numJumps + 1 .. " | Spd: " .. tonumber(speedgui.Text:sub(0,-4)) .. " | Strafes: " .. numStrafes)
			elseif numJumps == 2 then
				gTB1.Text = ""
				gTB2.Text = ""
				gTB3.Text = ""
				gTB4.Text = gTB5.Text
				gTB5.Text = "J: " .. numJumps + 1 .. " | Spd: " .. tonumber(speedgui.Text:sub(0,-4)) .. " | Strafes: " .. numStrafes
				print("J: " .. numJumps + 1 .. " | Spd: " .. tonumber(speedgui.Text:sub(0,-4)) .. " | Strafes: " .. numStrafes)
			elseif numJumps == 3 then
				gTB1.Text = ""
				gTB2.Text = ""
				gTB3.Text = gTB4.Text
				gTB4.Text = gTB5.Text
				gTB5.Text = "J: " .. numJumps + 1 .. " | Spd: " .. tonumber(speedgui.Text:sub(0,-4)) .. " | Strafes: " .. numStrafes
				print("J: " .. numJumps + 1 .. " | Spd: " .. tonumber(speedgui.Text:sub(0,-4)) .. " | Strafes: " .. numStrafes)
			elseif numJumps == 4 then
				gTB1.Text = ""
				gTB2.Text = gTB3.Text
				gTB3.Text = gTB4.Text
				gTB4.Text = gTB5.Text
				gTB5.Text = "J: " .. numJumps + 1 .. " | Spd: " .. tonumber(speedgui.Text:sub(0,-4)) .. " | Strafes: " .. numStrafes
				print("J: " .. numJumps + 1 .. " | Spd: " .. tonumber(speedgui.Text:sub(0,-4)) .. " | Strafes: " .. numStrafes)
			elseif numJumps == 5 then
				gTB1.Text = gTB2.Text
				gTB2.Text = gTB3.Text
				gTB3.Text = gTB4.Text
				gTB4.Text = gTB5.Text
				gTB5.Text = "J: " .. numJumps + 1 .. " | Spd: " .. tonumber(speedgui.Text:sub(0,-4)) .. " | Strafes: " .. numStrafes
				print("J: " .. numJumps + 1 .. " | Spd: " .. tonumber(speedgui.Text:sub(0,-4)) .. " | Strafes: " .. numStrafes)
			else
				gTB1.Text = gTB2.Text
				gTB2.Text = gTB3.Text
				gTB3.Text = gTB4.Text
				gTB4.Text = gTB5.Text
				gTB5.Text = "J: " .. numJumps + 1 .. " | Spd: " .. tonumber(speedgui.Text:sub(0,-4)) .. " | Strafes: " .. numStrafes
				print("J: " .. numJumps + 1 .. " | Spd: " .. tonumber(speedgui.Text:sub(0,-4)) .. " | Strafes: " .. numStrafes)
			end
			
			wait(0.15)
			recentlyJumped = false
			numStrafes = 0
		end
	else
		numJumps = 0
		numStrafes = 0
		isJumping = false
	end
end)
