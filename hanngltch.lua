
function missing(t, f, fallback)
    if type(f) == t then return f end
    return fallback 
end

cloneref = missing("function", cloneref, function(...) return ... end)

local Services = setmetatable({}, {
    __index = function(_, name)
        return cloneref(game:GetService(name))
    end
})

local Players = Services.Players
local RunService = Services.RunService
local UserInputService = Services.UserInputService
local TweenService = Services.TweenService

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
end)

--// Settings
local Settings = {}
Settings["Speed"] = 1

-- Default Emote ID
local DEFAULT_EMOTE_ID = "113633503026070"

local CurrentTrack
local lastPosition = character.PrimaryPart and character.PrimaryPart.Position or Vector3.new()

local function extractIdFromInput(input)
    local num = tonumber(input)
    if num then
        return num
    end
    local assetIdMatch = string.match(input, "rbxassetid://(%d+)")
    if assetIdMatch then
        return tonumber(assetIdMatch)
    end
    local catalogMatch = string.match(input, "roblox%.com/catalog/(%d+)")
    if catalogMatch then
        return tonumber(catalogMatch)
    end
    local libraryMatch = string.match(input, "roblox%.com/library/(%d+)")
    if libraryMatch then
        return tonumber(libraryMatch)
    end
    local assetMatch = string.match(input, "roblox%.com/asset/%?id=(%d+)")
    if assetMatch then
        return tonumber(assetMatch)
    end
    return tonumber(input)
end

local function LoadTrack(id)
    if CurrentTrack then 
        CurrentTrack:Stop(0) 
    end

    local animId
    local ok, result = pcall(function()
        return game:GetObjects("rbxassetid://" .. tostring(id))
    end)

    if ok and result and #result > 0 then
        local anim = result[1]
        if anim:IsA("Animation") then
            animId = anim.AnimationId
        else
            animId = "rbxassetid://" .. tostring(id)
        end
    else
        animId = "rbxassetid://" .. tostring(id)
    end

    local newAnim = Instance.new("Animation")
    newAnim.AnimationId = animId
    local newTrack = humanoid:LoadAnimation(newAnim)
    newTrack.Priority = Enum.AnimationPriority.Action4

    newTrack:Play(0.1, 1, Settings["Speed"])
    
    CurrentTrack = newTrack

    return newTrack
end

local function StopTrack()
    if CurrentTrack then
        CurrentTrack:Stop(0.1)
        CurrentTrack = nil
    end
end

-- Modern Dark UI with Sky Blue Stroke - CENTERED & COMPACT
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "EmotePlayerGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = Services.CoreGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 280, 0, 200)
mainFrame.Position = UDim2.new(0.5, -140, 0.5, -100)  -- Centered
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 18, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner", mainFrame)
mainCorner.CornerRadius = UDim.new(0, 12)

-- Sky Blue Stroke for main frame
local mainStroke = Instance.new("UIStroke", mainFrame)
mainStroke.Color = Color3.fromRGB(70, 130, 255)
mainStroke.Thickness = 2

-- Minimize Button
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
minimizeBtn.Position = UDim2.new(1, -70, 0, 8)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(60, 120, 200)
minimizeBtn.Text = "–"
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 20
minimizeBtn.ZIndex = 10
minimizeBtn.Parent = mainFrame

local minimizeCorner = Instance.new("UICorner", minimizeBtn)
minimizeCorner.CornerRadius = UDim.new(0, 6)

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 8)
closeBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.ZIndex = 10
closeBtn.Parent = mainFrame

local closeCorner = Instance.new("UICorner", closeBtn)
closeCorner.CornerRadius = UDim.new(0, 6)

-- Minimized Button (Hidden by default)
local minimizedBtn = Instance.new("TextButton")
minimizedBtn.Size = UDim2.new(0, 41, 0, 41)
minimizedBtn.Position = UDim2.new(0, 15, 0, 60)
minimizedBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
minimizedBtn.Text = "👾"
minimizedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizedBtn.Font = Enum.Font.GothamBold
minimizedBtn.TextSize = 28
minimizedBtn.Visible = false
minimizedBtn.Active = true
minimizedBtn.Draggable = true
minimizedBtn.Parent = screenGui
minimizedBtn.ZIndex = 5

local minimizedCorner = Instance.new("UICorner", minimizedBtn)
minimizedCorner.CornerRadius = UDim.new(0, 12)


local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -110, 0, 35)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "SIEXTHER GLITCHER"
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextColor3 = Color3.fromRGB(70, 130, 255)
title.Parent = mainFrame

-- Play/Stop Toggle Button
local playStopBtn = Instance.new("TextButton")
playStopBtn.Size = UDim2.new(1, -24, 0, 40)
playStopBtn.Position = UDim2.new(0, 12, 0, 45)
playStopBtn.BackgroundColor3 = Color3.fromRGB(25, 30, 40)
playStopBtn.BorderSizePixel = 0
playStopBtn.Text = "MULAI GLITCH"
playStopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
playStopBtn.Font = Enum.Font.GothamBold
playStopBtn.TextSize = 14
playStopBtn.Parent = mainFrame

local playStopCorner = Instance.new("UICorner", playStopBtn)
playStopCorner.CornerRadius = UDim.new(0, 8)

-- Speed Slider Container
local speedContainer = Instance.new("Frame")
speedContainer.Size = UDim2.new(1, -24, 0, 60)
speedContainer.Position = UDim2.new(0, 12, 0, 95)
speedContainer.BackgroundColor3 = Color3.fromRGB(25, 30, 40)
speedContainer.BorderSizePixel = 0
speedContainer.Parent = mainFrame

local speedCorner = Instance.new("UICorner", speedContainer)
speedCorner.CornerRadius = UDim.new(0, 8)

local speedStroke = Instance.new("UIStroke", speedContainer)
speedStroke.Color = Color3.fromRGB(70, 130, 255)
speedStroke.Thickness = 1
speedStroke.Transparency = 0.5

local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(1, -20, 0, 18)
speedLabel.Position = UDim2.new(0, 10, 0, 6)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = string.format("Speed: %.2f", Settings["Speed"])
speedLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
speedLabel.Font = Enum.Font.GothamMedium
speedLabel.TextSize = 12
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.Parent = speedContainer

local sliderBar = Instance.new("Frame")
sliderBar.Size = UDim2.new(1, -20, 0, 8)
sliderBar.Position = UDim2.new(0, 10, 0, 36)
sliderBar.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
sliderBar.BorderSizePixel = 0
sliderBar.Parent = speedContainer

local sliderCorner = Instance.new("UICorner", sliderBar)
sliderCorner.CornerRadius = UDim.new(1, 0)

local sliderFill = Instance.new("Frame")
sliderFill.Size = UDim2.new(0.2, 0, 1, 0)
sliderFill.BackgroundColor3 = Color3.fromRGB(70, 130, 255)
sliderFill.BorderSizePixel = 0
sliderFill.Parent = sliderBar

local fillCorner = Instance.new("UICorner", sliderFill)
fillCorner.CornerRadius = UDim.new(1, 0)

local thumb = Instance.new("Frame")
thumb.Size = UDim2.new(0, 16, 0, 16)
thumb.AnchorPoint = Vector2.new(0.5, 0.5)
thumb.Position = UDim2.new(0.2, 0, 0.5, 0)
thumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
thumb.BorderSizePixel = 0
thumb.Parent = sliderBar

local thumbCorner = Instance.new("UICorner", thumb)
thumbCorner.CornerRadius = UDim.new(1, 0)

local thumbStroke = Instance.new("UIStroke", thumb)
thumbStroke.Color = Color3.fromRGB(70, 130, 255)
thumbStroke.Thickness = 2

-- Spin Button (Left Side)
local spinBtn = Instance.new("TextButton")
spinBtn.Size = UDim2.new(0.48, 0, 0, 35)
spinBtn.Position = UDim2.new(0, 12, 0, 163)
spinBtn.BackgroundColor3 = Color3.fromRGB(25, 30, 40)
spinBtn.BorderSizePixel = 0
spinBtn.Text = "SPIN"
spinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
spinBtn.Font = Enum.Font.GothamBold
spinBtn.TextSize = 13
spinBtn.Parent = mainFrame

local spinCorner = Instance.new("UICorner", spinBtn)
spinCorner.CornerRadius = UDim.new(0, 8)

-- Swimming Button (Right Side)
local swimBtn = Instance.new("TextButton")
swimBtn.Size = UDim2.new(0.48, 0, 0, 35)
swimBtn.Position = UDim2.new(0.52, 0, 0, 163)
swimBtn.BackgroundColor3 = Color3.fromRGB(25, 30, 40)
swimBtn.BorderSizePixel = 0
swimBtn.Text = "SWIM"
swimBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
swimBtn.Font = Enum.Font.GothamBold
swimBtn.TextSize = 13
swimBtn.Parent = mainFrame

local swimCorner = Instance.new("UICorner", swimBtn)
swimCorner.CornerRadius = UDim.new(0, 8)

-- Speed Slider Logic
local function updateSpeedSlider(value)
    Settings["Speed"] = value
    speedLabel.Text = string.format("Speed Glitch: %.2f", value)
    
    local rel = math.clamp((value - 0) / (5 - 0), 0, 1)
    TweenService:Create(sliderFill, TweenInfo.new(0.15), {Size = UDim2.new(rel, 0, 1, 0)}):Play()
    TweenService:Create(thumb, TweenInfo.new(0.15), {Position = UDim2.new(rel, 0, 0.5, 0)}):Play()

    if CurrentTrack and CurrentTrack.IsPlaying then
        CurrentTrack:AdjustSpeed(Settings["Speed"])
    end
end

local dragging = false
local function updateFromInput(input)
    local relX = math.clamp((input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
    local value = math.floor((0 + (5 - 0) * relX) * 100) / 100
    updateSpeedSlider(value)
end

sliderBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        updateFromInput(input)
    end
end)

thumb.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        updateFromInput(input)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        updateFromInput(input)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
        dragging = false
    end
end)

-- Play/Stop Button Logic
local isPlaying = false

playStopBtn.MouseButton1Click:Connect(function()
    if not isPlaying then
        local id = extractIdFromInput(DEFAULT_EMOTE_ID)
        if id then
            CurrentTrack = LoadTrack(id)
            playStopBtn.Text = "STOP"
            playStopBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
            isPlaying = true
        end
    else
        StopTrack()
        playStopBtn.Text = "MULAI"
        playStopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        isPlaying = false
    end
end)

-- Spin Button Logic
local isSpinning = false
local spinConnection

spinBtn.MouseButton1Click:Connect(function()
    if not isSpinning then
        isSpinning = true
        spinBtn.Text = "STOP"
        spinBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
        
        spinConnection = RunService.RenderStepped:Connect(function(dt)
            if character.PrimaryPart then
                character.PrimaryPart.CFrame = character.PrimaryPart.CFrame * CFrame.Angles(0, math.rad(18), 0)
            end
        end)
    else
        isSpinning = false
        spinBtn.Text = "SPIN"
        spinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        
        if spinConnection then
            spinConnection:Disconnect()
            spinConnection = nil
        end
    end
end)

-- Swimming Logic
local swimming = false
local oldgrav = nil
local gravReset = nil
local swimbeat = nil

local function startSwimming()
    if player and character and humanoid then
        oldgrav = workspace.Gravity
        workspace.Gravity = 0
        
        local function swimDied()
            workspace.Gravity = oldgrav
            swimming = false
            if gravReset then
                gravReset:Disconnect()
            end
            if swimbeat then
                swimbeat:Disconnect()
                swimbeat = nil
            end
            local enums = Enum.HumanoidStateType:GetEnumItems()
            table.remove(enums, table.find(enums, Enum.HumanoidStateType.None))
            for _, v in pairs(enums) do
                humanoid:SetStateEnabled(v, true)
            end
        end
        
        gravReset = humanoid.Died:Connect(swimDied)
        local enums = Enum.HumanoidStateType:GetEnumItems()
        table.remove(enums, table.find(enums, Enum.HumanoidStateType.None))
        for _, v in pairs(enums) do
            humanoid:SetStateEnabled(v, false)
        end
        humanoid:ChangeState(Enum.HumanoidStateType.Swimming)
        
        swimbeat = RunService.Heartbeat:Connect(function()
            pcall(function()
                if character and character:FindFirstChild("HumanoidRootPart") then
                    local rootPart = character.HumanoidRootPart
                    if humanoid.MoveDirection ~= Vector3.new() then
                        rootPart.Velocity = Vector3.new(0, 10, 0)
                    else
                        rootPart.Velocity = Vector3.new()
                    end
                end
            end)
        end)
        
        swimming = true
    end
end

local function stopSwimming()
    if swimming then
        workspace.Gravity = oldgrav
        swimming = false
        if gravReset then
            gravReset:Disconnect()
            gravReset = nil
        end
        if swimbeat then
            swimbeat:Disconnect()
            swimbeat = nil
        end
        local enums = Enum.HumanoidStateType:GetEnumItems()
        table.remove(enums, table.find(enums, Enum.HumanoidStateType.None))
        for _, v in pairs(enums) do
            humanoid:SetStateEnabled(v, true)
        end
    end
end

swimBtn.MouseButton1Click:Connect(function()
    if swimming then
        stopSwimming()
        swimBtn.Text = "SWIM"
        swimBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    else
        startSwimming()
        swimBtn.Text = "STOP"
        swimBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
    end
end)

-- Minimize/Maximize Logic
minimizeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    minimizedBtn.Visible = true
end)

minimizedBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    minimizedBtn.Visible = false
end)

-- Close Button Logic
closeBtn.MouseButton1Click:Connect(function()
    StopTrack()
    if spinConnection then
        spinConnection:Disconnect()
    end
    stopSwimming()
    screenGui:Destroy()
end)

RunService.RenderStepped:Connect(function()
    if character.PrimaryPart then
        lastPosition = character.PrimaryPart.Position
    end
end)