-- Made by Anders and Aidan
-- Custom Command: /setdefs (For changing the default FOV and Sens for each randomization)

-- Services
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local debris = game:GetService('Debris')

-- Player Info
local player = game.Players.LocalPlayer; local pName = player.Name; local pC = game.Workspace.Characters:WaitForChild(pName); 
local pCam = game.Workspace.Camera local mouse = player:GetMouse(); mouse.TargetFilter = workspace.Characters

-- CoreGuis
local allguis = game.Players.LocalPlayer.PlayerGui:GetDescendants()
local function gettimegui() for i,v in pairs(allguis) do if v.ClassName == "TextLabel" and string.find(v.Text,"Time: ") then return(v) end end end repeat allguis = game.Players.LocalPlayer.PlayerGui:GetDescendants() wait(0.1) timegui = gettimegui() until timegui
local function getspeedgui() for i,v in pairs(allguis) do if v.ClassName == "TextLabel" and string.find(v.Text,"u/s") then return(v) end end end repeat allguis = game.Players.LocalPlayer.PlayerGui:GetDescendants() wait(0.1) speedgui = getspeedgui() until speedgui
--local function getspecgui() for i,v in pairs(allguis) do if v.ClassName == "TextLabel" and string.find(v.Text,"Change View") then return(v) end end end repeat allguis = game.Players.LocalPlayer.PlayerGui:GetDescendants() wait(0.1) specgui = getspecgui() until specgui

-- StyleGui
local newGui = Instance.new("ScreenGui"); newGui.Parent = player.PlayerGui
local daFrame = Instance.new("Frame"); daFrame .BackgroundTransparency = 1; daFrame.Parent = newGui; daFrame.Position = UDim2.new(0,0,0.2,0); daFrame.Size = UDim2.new(0.2,0,0.3,0)
local daButton = Instance.new("TextButton"); daButton.BackgroundTransparency = 1; daButton.Parent = daFrame; daButton.Font = Enum.Font.SourceSansBold; daButton.Text = "-- { Reroll : 3 Left } --"; daButton.TextSize = 26; daButton.Position = UDim2.new(0.25,0,0.5,0); daButton.Size = UDim2.new(0.5,0,0.25,0)
local daText = Instance.new("TextLabel"); daText.BackgroundTransparency = 1; daText.Parent = daFrame; daText.Font = Enum.Font.SourceSansBold; daText.Text = "- { Current Style : x } -"; daText.TextSize = 26; daText.Position = UDim2.new(0,0,0.25,0); daText.Size = UDim2.new(1,0,0.25,0)

-- Variables
local rerollStages = {2, 3} -- Insert stages where you want to add a reroll to player on
local hardStages = {} -- Insert stages you want to only have set styles on
local pFOV; local pSens; local curStyle = "Auto"; local randomVal = 0; local rerolledThisStage = false; local rerollCount = 3; local pBlock; local pLight;
local rayHeight = -5; local curStage = 1; local isSpec = false; local isRunning = false; local resetRecently = false; local daKeys = {}
local gainVar; local gravVar; local originalGrav; local curStrafeDir = 1; local curFOV; local fovCons = 0; local timeGain = 0.5; local timeGainBuffer = false;
local remotecall; local remoteadd; local remotesubscribe; local characterTransparency = 1; local movementHook; local sv; local pVelocity;
local defaultAmbient; local defaultBrightness; local defaultOAmbient; local defaultFogColor; local defaultFogEnd;

-- Camera Hooking and Third Person
local mt = getrawmetatable(game)
local old__newindex = mt.__newindex
setreadonly(mt,false)
mt.__newindex = newcclosure(function(obj,property,val)
    if curStyle == "Third Person" and property == "CoordinateFrame" and obj == pCam then
        val += val.LookVector * -7
    end
    return old__newindex(obj,property,val)
end)
setreadonly(mt,true)

-- Grab Map --CURRENTLY UNUSED, however may be needed for builderman
local function map()
    for _,v in next,workspace:GetChildren() do
        if v:FindFirstChild("Creator") and v:FindFirstChild("DisplayName") then
            return v
        end
    end
end

-- Set Lighting Defaults
local function setLightDefaults()
    local l = game.Lighting
    defaultAmbient = l.Ambient
    defaultBrightness = l.Brightness
    defaultOAmbient = l.OutdoorAmbient
    defaultFogEnd = l.FogEnd
    defaultFogColor = l.FogColor
end

-- getgc Functions and Tables
for i,v in pairs(getgc(true)) do
    if type(v) == 'table' then
        if rawget(v, "keys") and rawget(v, "id") then
            daKeys[v["id"]] = v
        end
        if rawget(v,'Player') then
            for u,b in pairs(v) do
                if u == "CurrentCamera" then
                    pInfo = v
                    pFOV = pInfo.BaseFOV
                    pSens = pInfo.Sensitivity
                    curFOV = pFOV
                end
            end
        end
        if rawget(v,"Call") and rawget(v,"Add") and rawget(v,"InitLast") and not remotecall then
            remotecall = v["Call"]
            remoteadd = v["Add"]
            remotesubscribe = v["Subscribe"]
        end
        if rawget(v,"Call") and rawget(v,"Add") and not rawget(v,"InitLast") and not localcall then
            localcall = v["Call"]
            localsubscribe = v["Subscribe"]
            localadd = v["Add"]
        end
        if rawget(v,"GetAngles") and rawget(v,"GetVelocity") then
            movementHook = v
        end
    end
    if type(v) == 'function' then
        pcall(function()
            for u,b in pairs(debug.getconstants(v)) do
                if b == 2.7 and u == 1 and debug.getinfo(v)['nups'] == 1 then
                    gainVar = v
                end
            end
            for u,b in pairs(debug.getupvalues(v)) do
                if (b == -50 or b == -100) and debug.getinfo(v)['nups'] == 1 then --Surf has grav 50, bhop grav 100
                    gravVar = v
                    originalGrav = b
                end
            end
        end)
    end
end

-- Grab Velocity
pVelocity = movementHook.GetVelocity(player)
for _,f in pairs(getgc()) do
    if type(f) == "function" then
        pcall(function()
            if debug.getinfo(f)['source']:find("Movement") then
                for a,b in pairs(debug.getupvalues(f)) do
                    if b == pVelocity and a == 1 then
                        sv = f
                        break
                    end
                end
            end
        end)
    end
end

-- Detect Map Change
localsubscribe("PartData", function()
    wait()
    setLightDefaults()
end)

-- Add Commands
local function addCommand(name,validValues,func)
    remoteadd(tostring(func),func)
    remotecall("AddClientCommand",name,validValues,tostring(func))
end

-- Custom Commands
addCommand("setdefs", {}, function()
    pFOV = pInfo.BaseFOV
    pSens = pInfo.Sensitivity
end)

-- Establish setGain
local function setGain(num)
    debug.setconstant(gainVar, 1, 2.7 * num)
end

-- Establish setGravity
local function setGravity(num)
    debug.setupvalue(gravVar,1,originalGrav*num)
end

-- Establish setKeys
local function setKeys(num1,num2,num3,num4)
    for i,v in pairs(daKeys) do
        --print("Setting",i)
        v["keys"] = {
            w = num1,
            a = num2,
            s = num3,
            d = num4
        }
    end
end

-- Establish Timesacle
local function setTimeScale(num)
    remotecall('Chatted', '/timescale ' .. num)
end

-- Estasblish FOV
local function setFOV(num)
    remotecall('Chatted', '/fov ' .. num)
    remotecall('Chatted', '/sens ' .. ((pFOV/num) * pSens))
end

-- Establish Lighting
local function setLightMode(num)
    if num == 1 then -- Natural Light
        game.Lighting.Ambient = defaultAmbient
        game.Lighting.Brightness = defaultBrightness
        game.Lighting.FogColor = defaultFogColor
        game.Lighting.FogEnd = defaultFogEnd
        game.Lighting.OutdoorAmbient = defaultOAmbient
    elseif num == 2 then -- Foggy Nights Mode
        game.Lighting.Ambient = Color3.fromRGB(0,0,0)
        game.Lighting.Brightness = 1
        game.Lighting.FogColor = Color3.new(0,0,0)
        game.Lighting.FogEnd = 17.5
        game.Lighting.OutdoorAmbient = Color3.fromRGB(173,173,173)
    elseif num == 3 then -- Flashlight Mode
        game.Lighting.Ambient = Color3.fromRGB(0,0,0)
        game.Lighting.Brightness = 0
        game.Lighting.FogEnd = 5000
        game.Lighting.OutdoorAmbient = Color3.fromRGB(0,0,0)
        game.Lighting.TimeOfDay = "22:00:00"
    elseif num == 4 then -- Landing Light Dark Mode
    end
end

-- Change Player Visibility (For Third Person)
local function setPlayerVisibility(num)
    characterTransparency = num
    for _,part in next,pC:GetChildren() do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            part.Transparency = num
        end
    end
end

-- Revolutionized Style Odds [ 20 FUNCTIONAL :: 30 TOTAL ]
local styleWeights = {
    HSW = 10,
    Auto = 10,
    Backwards = 1,
    ["A-Only"] = 7,
    ["W-Only"] = 2,
    Sideways = 3,
    ["Foggy Nights"] = 6,
    Faste = 5,
    Slow = 6,
    ["Timescale 0.5x"] = 6, -- Timescale removed on main
    ["Timescale 1.333x"] = 4, -- Timescale removed on main
    ["D-Only"] = 4,
    ["FOV 60"] = 4,
    ["Gain with Time"] = 5, -- 0.5x & every 0.1 sec increases 0.02 until speed < 18
    ["Velocity Cap"] = 7, -- 40 Cap
    ["Right Faste"] = 5, -- L: 0.5x, R: 3x
    ["Left Faste"] = 5, -- L: 3x, R: 0.5x
    ["Invisible Blocks"] = 0, -- NF
    Turbo = 0,  -- NF
    Flashlight = 0,  -- NF
    ["Landing Light"] = 0,  -- NF
    ["Drunk Mode"] = 0, -- NF
    ["Low Gravity"] = 6,
    ["Third Person"] = 6,
    ["Bomber Man"] = 0, -- NF
    ["Quake Pro"] = 4,
    ["Atom Eve"] = 0,  -- NF
    ["Builderman"] = 0,  -- NF
    ["Slowfall"] = 4,
    ["Double Jump"] = 0, -- NF
}

-- Style settings
local styleSettings = {
    --If keys is not set, the handler assumes the value is {1,1,1,1}
    --If gains, light, grav, or tscale are not set, the handler assumes the value is 1
    --If fov is not set, the handler assumes the value is pFOV
    HSW = {keys={2,1,1,1}},
    Auto = {}, --Pure default, can just have empty :troll:
    Backwards = {keys={0,1,0,1}},
    ["A-Only"] = {keys={0,2,0,0}},
    ["W-Only"] = {keys={1,0,0,0}},
    Sideways = {keys={1,0,1,0}},
    ["Foggy Nights"] = {light=2},
    Faste = {gains=3},
    Slow = {gains=0.5},
    ["Timescale 0.5x"] = {tscale=0.5},
    ["Timescale 1.333x"] = {tscale=1.333},
    ["D-Only"] = {keys={0,0,0,1}},
    ["FOV 60"] = {fov=60},
    ["Gain with Time"] = {},
    ["Velocity Cap"] = {},
    ["Right Faste"] = {},
    ["Left Faste"] = {},
    ["Invisible Blocks"] = {},  -- NF
    Turbo = {},  -- NF
    Flashlight = {},  -- NF
    ["Landing Light"] = {}, -- NF
    ["Drunk Mode"] = {}, -- NF
    ["Low Gravity"] = {grav=.6},
    ["Third Person"] = {},
    ["Bomber Man"] = {}, -- NF
    ["Quake Pro"] = {gains=-math.huge},
    ["Atom Eve"] = {}, -- NF
    ["Builderman"] = {}, -- NF
    ["Slowfall"] = {},
    ["Double Jump"] = {}, -- NF
}

-- To pick styles
local function pickFromWeight(weightTable)
    local totalWeight = 0
    for _,weight in next,weightTable do
        totalWeight += weight
    end
    local chosenWeight = math.random(1,totalWeight)
    for index,weight in next,weightTable do
        chosenWeight -= weight
        if chosenWeight < 1 then
            return index
        end
    end
end

-- Change Style Function
local function changeToStyle(style)
    curStyle = style
    local styleInfo = styleSettings[style]
    local keyTable = styleInfo["keys"] or {1,1,1,1}
    remotecall('Chatted','Rolled '..style..'!')
    setKeys(keyTable[1],keyTable[2],keyTable[3],keyTable[4])
    setGain(styleInfo["gains"] or 1)
    setLightMode(styleInfo["light"] or 1)
    setTimeScale(styleInfo["tscale"] or 1)
    setFOV(styleInfo["fov"] or pFOV)
    setGravity(styleInfo["grav"] or 1)
end

-- Randomize Style Function
local function randomizeStyle(satisfied)
    local chosenStyle = pickFromWeight(styleWeights)
    while not satisfied do
        chosenStyle = pickFromWeight(styleWeights)
        if chosenStyle ~= curStyle then
            satisfied = true
        end
    end
    changeToStyle(chosenStyle)
end

-- Click Reroll Button
daButton.MouseButton1Down:Connect(function()
    if rerolledThisStage == false and rerollCount > 0 then
        rerollCount = rerollCount - 1 
        randomizeStyle()
        rerolledThisStage = true
        daButton.Text = "-- { Reroll : " .. rerollCount .. " Left } --"
    else
        print("Already rerolled this stage!")
    end
end)

-- Ray Function
local function rayFunction()
    local ray = Ray.new(pC.Torso.CFrame.Position, Vector3.new(0, rayHeight, 0))
    local hit = workspace:FindPartOnRayWithIgnoreList(ray, {pC})

    if hit then
        if string.find(hit.Name, "Spawn") then
            if curStage < tonumber(hit.Name:sub(6,8)) then
                for i,v in pairs(rerollStages) do
                    if tonumber(hit.Name:sub(6,8)) == v then
                        rerollCount = rerollCount + 1
                    end
                end
                curStage = tonumber(hit.Name:sub(6,8))
                print("------------------")
                print("Reached Stage " .. curStage)
                print("------------------")
                rerolledThisStage = false
                randomizeStyle(true)
            else
                --print("Already passed stage " .. tonumber(hit.Name:sub(6,8)))
            end
        end
    else
        -- Do Nothing
    end
end

-- Style Bender
UIS.InputChanged:Connect(function(input)
    local delta = input.Delta
    if curStyle == "Left Faste" then
        if UIS:IsKeyDown(Enum.KeyCode.Space) and delta.X > 0 and curStrafeDir == 1 and curStyle == "Left Faste" then
            print("Strafing right")
            setGain(0.5)
            curStrafeDir = 0
        elseif UIS:IsKeyDown(Enum.KeyCode.Space) and delta.X < 0 and curStrafeDir == 0 and curStyle == "Left Faste" then
            print("Strafing left")
            setGain(3)
            curStrafeDir = 1
        end
    elseif curStyle == "Right Faste" then
        if UIS:IsKeyDown(Enum.KeyCode.Space) and delta.X > 0 and curStrafeDir == 0 and curStyle == "Right Faste" then
            print("Strafing right")
            setGain(3)
            curStrafeDir = 1
        elseif UIS:IsKeyDown(Enum.KeyCode.Space) and delta.X < 0 and curStrafeDir == 1 and curStyle == "Right Faste" then
            print("Strafing left")
            setGain(0.5)
            curStrafeDir = 0
        end
    else
        -- Do Nothing
    end
end)

-- Bomb Style Logic
mouse.Button1Down:Connect(function()
    if curStyle ~= "Quake Pro" then
        return
    end
    local hitFeedback = Instance.new("Part",workspace.Characters)
    hitFeedback.Anchored = true
    hitFeedback.Name = "QuakePro Hit Feedback"
    hitFeedback.Size = Vector3.new(.35,.35,.35)
    hitFeedback.Position = mouse.Hit.p
    hitFeedback.Transparency = .2
    hitFeedback.Color = Color3.new(.2,.2,1)
    debris:AddItem(hitFeedback,1)
    local maxDistanceLimit = 30
    local distanceToOrigin = (mouse.Origin.p-mouse.Hit.p).magnitude
    if distanceToOrigin >= maxDistanceLimit then
        return --Too far
    end
    hitFeedback.Color = Color3.new(1,.2,.2)
    local launchDistance = math.asin((maxDistanceLimit-distanceToOrigin)/maxDistanceLimit)*maxDistanceLimit
    local launchDistanceVector = (-mouse.Origin.LookVector)*launchDistance
    setupvalue(sv,1,getupvalue(sv,1)+launchDistanceVector)
end)

setLightDefaults()
-- Main Function
RS.RenderStepped:Connect(function()
    daText.Text = "- { Current Style : " .. curStyle .. " } -"
    daButton.Text = "-- { Reroll : " .. rerollCount .. " Left } --"

    if isRunning == true then
        rayFunction()
        local currentVel = getupvalue(sv,1)
        local velX = currentVel.X
        local velY = currentVel.Y
        local velZ = currentVel.Z

        if curStyle == "Gain with Time" then
            if (tonumber(speedgui.Text:sub(1,5))) > 18 and string.len(speedgui.Text) > 8 and timeGainBuffer == false then
                timeGain = timeGain + 0.02
                setGain(timeGain)
                timeGainBuffer = true
                wait(0.1)
                timeGainBuffer = false
            elseif (tonumber(speedgui.Text:sub(1,5))) <= 18 then
                setGain(0.5)
                timeGain = 0.5
                timeGainBuffer = false
            end
        end

        if curStyle == "Velocity Cap" then
            if velX > 40 then
                currentVel = Vector3.new(40,velY,velZ)
            end
            if velX < -40 then
                currentVel = Vector3.new(-40,velY,velZ)
            end
            if velZ > 40 then
                currentVel = Vector3.new(velX,velY,40)
            end
            if velZ < -40 then
                currentVel = Vector3.new(velX,velY,-40)
            end
            setupvalue(sv,1,currentVel)
        end

        if curStyle == "Slowfall" then
            if velY < 0 then
                setGravity (0.4)
            else
                setGravity(1)
            end
        end

        if curStyle == "Third Person" and characterTransparency == 1 then
            setPlayerVisibility(0)
        elseif not(curStyle == "Third Person") and characterTransparency == 0 then
            setPlayerVisibility(1)
        end
            
        if curStyle == "Drunk Mode" then
            if curFOV > 50 and curFOV <= pFOV and fovCons == 0 then
                curFOV = curFOV - 0.1
                setFOV(curFOV)
            elseif curFOV >= 50 and curFOV < pFOV and fovCons == 1 then
                curFOV = curFOV + 0.1
                setFOV(curFOV)
            elseif curFOV == 50 and fovCons == 0 then
                fovCons = 1
                setFOV(50)
            elseif curFOV == pFOV and fovCons == 1 then
                fovCons = 0
                setFOV(pFOV)
            end
        end
    else
        -- Nothing
    end

    if (tonumber(timegui.Text:sub(13,15)) > 0 or tonumber(timegui.Text:sub(10,11)) > 0 or tonumber(timegui.Text:sub(7,8)) > 0) and not isRunning then
        isRunning = true
        resetRecently = false
        print("New run has started!")
    elseif tonumber(timegui.Text:sub(13,15)) == 0 and tonumber(timegui.Text:sub(10,11)) == 0 and tonumber(timegui.Text:sub(7,8)) == 0 and isRunning and not resetRecently then
        resetRecently = true
        isRunning = false
        print("Reset")
        curStage = 1
        rerollCount = 3
        rerolledThisStage = false
        print(curStage)
    end
end)
