-- Services
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

-- Player Info
local player = game.Players.LocalPlayer; local pName = player.Name; local pC = game.Workspace.Characters:WaitForChild(pName)

-- CoreGuis
local allguis = game.Players.LocalPlayer.PlayerGui:GetDescendants()
local function gettimegui() for i,v in pairs(allguis) do if v.ClassName == "TextLabel" and string.find(v.Text,"Time: ") then return(v) end end end repeat allguis = game.Players.LocalPlayer.PlayerGui:GetDescendants() wait(1) timegui = gettimegui() until timegui
--local function getspecgui() for i,v in pairs(allguis) do if v.ClassName == "TextLabel" and string.find(v.Text,"Change View") then return(v) end end end repeat allguis = game.Players.LocalPlayer.PlayerGui:GetDescendants() wait(1) specgui = getspecgui() until specgui

-- StyleGui
local newGui = Instance.new("ScreenGui"); newGui.Parent = player.PlayerGui
local daFrame = Instance.new("Frame"); daFrame .BackgroundTransparency = 1; daFrame.Parent = newGui; daFrame.Position = UDim2.new(0,0,0.2,0); daFrame.Size = UDim2.new(0.2,0,0.3,0)
local daButton = Instance.new("TextButton"); daButton.BackgroundTransparency = 1; daButton.Parent = daFrame; daButton.Font = Enum.Font.SourceSansBold; daButton.Text = "-- { Reroll : 3 Left } --"; daButton.TextSize = 26; daButton.Position = UDim2.new(0.25,0,0.5,0); daButton.Size = UDim2.new(0.5,0,0.25,0)
local daText = Instance.new("TextLabel"); daText.BackgroundTransparency = 1; daText.Parent = daFrame; daText.Font = Enum.Font.SourceSansBold; daText.Text = "- { Current Style : x } -"; daText.TextSize = 26; daText.Position = UDim2.new(0,0,0.25,0); daText.Size = UDim2.new(1,0,0.25,0)

-- Variables
local pFOV = 94.9
local pSens = 0.2
local rerollStages = {2, 3} -- Insert stages where you want to add a reroll to player on
local hardStages = {} -- Insert stages you want to only have set styles on
local curStyle = "Auto"; local rerollStyle; local randomVal = 0; local rerolledThisStage = false; local rerollCount = 3; 
local mapName; local rayHeight = -5; local curStage = 1; local isSpec = false; local isRunning = false; local resetRecently = false; local daKeys = {}
local gainVar; local curStrafeDir = 1; local curFOV = 94.9; local fovCons = 0;

-- Grab Map Name
for i,v in pairs(game.Workspace:GetDescendants()) do
    if v:IsA("StringValue") and v.Parent:IsA("Model") then
        mapName = v.Parent.Name
    end
end

-- getgc Call and Keys and Gain Functions
for i,v in pairs(getgc(true)) do
    if type(v) == 'table' then
        if rawget(v, 'Call') then
            call = rawget(v, 'Call')
        end
        if rawget(v, "keys") and rawget(v, "id") then
            daKeys[v["id"]] = v
        end
    end
    if type(v) == 'function' then
        pcall(function()
            for u,b in pairs(debug.getconstants(v)) do
                if b == 2.7 and u == 1 and debug.getinfo(v)['nups'] == 1 then
                    gainVar = v
                end
            end
        end)
    end
end

-- Establish setGain
local function setGain(num)
    debug.setconstant(gainVar, 1, 2.7 * num)
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
    call('Chatted', '/timescale ' .. num)
end

-- Estasblish FOV
local function setFOV(num)
    call('Chatted', '/fov ' .. num)
    call('Chatted', '/sens ' .. ((pFOV/num) * pSens))
end

-- Establish Lighting
local function setLightMode(num)
    if num == 1 then -- Natural Light
        game.Lighting.FogColor = Color3.new(0,0,0)
      game.Lighting.FogEnd = 5000
     game.Lighting.Brightness = 1
    elseif num == 2 then -- Foggy Nights Mode
        game.Lighting.FogColor = Color3.new(0,0,0)
        game.Lighting.FogEnd = 17.5
        game.Lighting.Brightness = 1
    elseif num == 3 then -- Flashlight Mode
    elseif num == 4 then -- Landing Light Dark Mode
    end
end

--[[ EACH STYLE ODDS MEANING
    s1 = Half-Sideways, s2 = Auto, s3 = Backwards, s4 = A-Only, s5 = W-Only
    s6 = Sideways, s7 = Foggy Nights, s8 = Faste, s9 = Slow, s10 = Timescale 0.5
    s11 = Timescale 1.5, s12 = D-Only, s13 = 60 FOV, s14 = Gain w/ time, s15 = Velocity Cap 
    s16 = Gain faster right strafes, s17 = Gain faster left strafes, s18 = Invis, s19 = Turbo, s20 = Flashlight
    s21 = Landing Light, s22 = Drunk Mode (FOV In and Out)

    TURBO = SLOW AND THEN PRESS BUTTON FOR A SHORT BOOST OF SPEED (ON A TIMER)
]]

-- Style odds, but revolutionised
local styleWeights = {
    HSW = 20,
    Auto = 20,
    Backwards = 20,
    ["A-Only"] = 20, --has a dash in it
    ["W-Only"] = 20,
    Sideways = 20,
    ["Foggy Nights"] = 20,
    Faste = 20,
    Slow = 20,
    ["Timescale 0.5x"] = 20,
    ["Timescale 1.333x"] = 20,
    ["D-Only"] = 20,
    ["FOV 60"] = 20,
    ["Gain with Time"] = 0, --Nonfunctional
    ["Velocity Cap"] = 0, --Nonfunctional
    ["Right Faste"] = 20,
    ["Left Faste"] = 20,
    ["Invisible Blocks"] = 0, --Nonfunctional
    Turbo = 0, --Nonfunctional
    Flashlight = 0, --Nonfunctional
    ["Landing Light"] = 0, --Nonfunctional
    ["Drunk Mode"] = 20,
}

-- Style settings
local styleSettings = {
    --If keys is not set, the handler assumes the value is {1,1,1,1}
    --If gains, light, or tscale are not set, the handler assumes the value is 1
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
    ["Gain with Time"] = {}, --Nonfunctional
    ["Velocity Cap"] = {}, -- Nonfunctional
    ["Right Faste"] = {},
    ["Left Faste"] = {},
    ["Invisible Blocks"] = {}, --Nonfunctional
    Turbo = {}, --Nonfunctional
    Flashlight = {}, --Nonfunctional
    ["Landing Light"] = {}, --Nonfunctional
    ["Drunk Mode"] = {},
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

-- Randomize Style Function
local function randomizeStyle(allowSameStyle)
    local satisfied = allowSameStyle
    local chosenStyle = pickFromWeight(styleWeights)
    while not satisfied do
        chosenStyle = pickFromWeight(styleWeights)
        if chosenStyle ~= curStyle then
            satisfied = true
        end
    end
    curStyle = chosenStyle
    local styleInfo = styleSettings[curStyle]
    local keyTable = styleInfo["keys"] or {1,1,1,1}
    call('Chatted','Rolled '..curStyle..'!')
    setKeys(keyTable[1],keyTable[2],keyTable[3],keyTable[4])
    setGain(styleInfo["gains"] or 1)
    setLightMode(styleInfo["light"] or 1)
    setTimeScale(styleInfo["tscale"] or 1)
    setFOV(styleInfo["fov"] or pFOV)
    --Style bending isnt required, as it is handled in RenderStepped
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
    elseif curStyle == "Drunk Mode" then
        if curFOV > 50 and curFOV <= 94.9 and fovCons == 0 then
            curFOV = curFOV - 0.1
            setFOV(curFOV)
        elseif curFOV >= 50 and curFOV < 94.9 and fovCons == 1 then
            curFOV = curFOV + 0.1
            setFOV(curFOV)
        elseif curFOV == 50 and fovCons == 0 then
            fovCons = 1
            setFOV(50)
        elseif curFOV == 94.9 and fovCons == 1 then
            fovCons = 0
            setFOV(94.9)
        end
    else
        -- Do Nothing
    end
end)

-- Main Function
RS.RenderStepped:Connect(function()
    daText.Text = "- { Current Style : " .. curStyle .. " } -"
    daButton.Text = "-- { Reroll : " .. rerollCount .. " Left } --"

    if isRunning == true then
        rayFunction()
    else
        -- Nothing
    end

    if (tonumber(timegui.Text:sub(13,15)) > 0 or tonumber(timegui.Text:sub(10,11)) > 0 or tonumber(timegui.Text:sub(7,8)) > 0) and isRunning == false then
        isRunning = true
        resetRecently = false
        print("New run has started!")
    elseif tonumber(timegui.Text:sub(13,15)) == 0 and tonumber(timegui.Text:sub(10,11)) == 0 and tonumber(timegui.Text:sub(7,8)) == 0 and isRunning == true and resetRecently == false then
        resetRecently = true
        isRunning = false
        print("Reset")
        curStage = 1
        rerollCount = 3
        rerolledThisStage = false
        print(curStage)
    end
end)
