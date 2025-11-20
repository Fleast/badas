-- BY @muhmdilhan_
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
local StarterGui = Services.StarterGui

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
local DEFAULT_EMOTE_ID = "93224413172183"

local CurrentTrack
local lastPosition = character.PrimaryPart and character.PrimaryPart.Position or Vector3.new()

-- FreeCam Variables
local freeCamEnabled = false
local freeCamConnection
local keysDown = {}
local rotating = false
local touchPos
local onMobile = not UserInputService.KeyboardEnabled
local freeCamSpeed = 8
local freeCamSens = 0.3
local originalWalkSpeed = 16
local originalJumpPower = 50
local originalJumpHeight = 7.2
local originalCamera = workspace.CurrentCamera.CameraType

freeCamSpeed = freeCamSpeed / 12

if onMobile then
    freeCamSens = freeCamSens * 2
end

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

local function SmoothTween(obj, time, properties)
    local tween = TweenService:Create(obj, TweenInfo.new(time, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), properties)
    tween:Play()
    return tween
end

-- FreeCam Functions
local function freeCamRenderStep()
    local cam = workspace.CurrentCamera
    
    if rotating then
        local delta = UserInputService:GetMouseDelta()
        local cf = cam.CFrame
        local yAngle = cf:ToEulerAngles(Enum.RotationOrder.YZX)
        local newAmount = math.deg(yAngle) + delta.Y
        
        if newAmount > 65 or newAmount < -65 then
            if not (yAngle < 0 and delta.Y < 0) and not (yAngle > 0 and delta.Y > 0) then
                delta = Vector2.new(delta.X, 0)
            end
        end
        
        cf = cf * CFrame.Angles(-math.rad(delta.Y), 0, 0)
        cf = CFrame.Angles(0, -math.rad(delta.X), 0) * (cf - cf.Position) + cf.Position
        cf = CFrame.lookAt(cf.Position, cf.Position + cf.LookVector)
        
        if delta ~= Vector2.new(0, 0) then
            cam.CFrame = cam.CFrame:Lerp(cf, freeCamSens)
        end
        
        UserInputService.MouseBehavior = Enum.MouseBehavior.LockCurrentPosition
    else
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
    end
    
    if keysDown["Enum.KeyCode.W"] then
        cam.CFrame = cam.CFrame * CFrame.new(Vector3.new(0, 0, -freeCamSpeed))
    end
    if keysDown["Enum.KeyCode.A"] then
        cam.CFrame = cam.CFrame * CFrame.new(Vector3.new(-freeCamSpeed, 0, 0))
    end
    if keysDown["Enum.KeyCode.S"] then
        cam.CFrame = cam.CFrame * CFrame.new(Vector3.new(0, 0, freeCamSpeed))
    end
    if keysDown["Enum.KeyCode.D"] then
        cam.CFrame = cam.CFrame * CFrame.new(Vector3.new(freeCamSpeed, 0, 0))
    end
end

local function enableFreeCam()
    if freeCamEnabled then return end
    freeCamEnabled = true
    
    if player.Character then
        local hum = player.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            originalWalkSpeed = hum.WalkSpeed
            originalJumpPower = hum.JumpPower
            originalJumpHeight = hum.JumpHeight
            
            hum.WalkSpeed = 0
            hum.JumpPower = 0
            hum.JumpHeight = 0
        end
    end
    
--    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, true)
    workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
    freeCamConnection = RunService.RenderStepped:Connect(freeCamRenderStep)
end

local function disableFreeCam()
    if not freeCamEnabled then return end
    freeCamEnabled = false
    
    if freeCamConnection then
        freeCamConnection:Disconnect()
        freeCamConnection = nil
    end
    
    if player.Character then
        local hum = player.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = originalWalkSpeed
            hum.JumpPower = originalJumpPower
            hum.JumpHeight = originalJumpHeight
        end
    end
    
--    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, true)
    workspace.CurrentCamera.CameraSubject = player.Character.Humanoid
    workspace.CurrentCamera.CameraType = originalCamera
    
    keysDown = {}
    rotating = false
end

-- Input handling for FreeCam
local validKeys = {"Enum.KeyCode.W", "Enum.KeyCode.A", "Enum.KeyCode.S", "Enum.KeyCode.D"}

UserInputService.InputBegan:Connect(function(Input)
    if not freeCamEnabled then return end
    
    for i, key in pairs(validKeys) do
        if key == tostring(Input.KeyCode) then
            keysDown[key] = true
        end
    end
    
    if Input.UserInputType == Enum.UserInputType.MouseButton2 or 
       (Input.UserInputType == Enum.UserInputType.Touch and UserInputService:GetMouseLocation().X > (workspace.CurrentCamera.ViewportSize.X / 2)) then
        rotating = true
    end
    
    if Input.UserInputType == Enum.UserInputType.Touch then
        if Input.Position.X < workspace.CurrentCamera.ViewportSize.X / 2 then
            touchPos = Input.Position
        end
    end
end)

UserInputService.InputEnded:Connect(function(Input)
    if not freeCamEnabled then return end
    
    for key, v in pairs(keysDown) do
        if key == tostring(Input.KeyCode) then
            keysDown[key] = false
        end
    end
    
    if Input.UserInputType == Enum.UserInputType.MouseButton2 or 
       (Input.UserInputType == Enum.UserInputType.Touch and UserInputService:GetMouseLocation().X > (workspace.CurrentCamera.ViewportSize.X / 2)) then
        rotating = false
    end
    
    if Input.UserInputType == Enum.UserInputType.Touch and touchPos then
        if Input.Position.X < workspace.CurrentCamera.ViewportSize.X / 2 then
            touchPos = nil
            keysDown["Enum.KeyCode.W"] = false
            keysDown["Enum.KeyCode.A"] = false
            keysDown["Enum.KeyCode.S"] = false
            keysDown["Enum.KeyCode.D"] = false
        end
    end
end)

UserInputService.TouchMoved:Connect(function(input)
    if not freeCamEnabled then return end
    
    if touchPos then
        if input.Position.X < workspace.CurrentCamera.ViewportSize.X / 2 then
            if input.Position.Y < touchPos.Y then
                keysDown["Enum.KeyCode.W"] = true
                keysDown["Enum.KeyCode.S"] = false
            else
                keysDown["Enum.KeyCode.W"] = false
                keysDown["Enum.KeyCode.S"] = true
            end
            
            if input.Position.X < (touchPos.X - 15) then
                keysDown["Enum.KeyCode.A"] = true
                keysDown["Enum.KeyCode.D"] = false
            elseif input.Position.X > (touchPos.X + 15) then
                keysDown["Enum.KeyCode.A"] = false
                keysDown["Enum.KeyCode.D"] = true
            else
                keysDown["Enum.KeyCode.A"] = false
                keysDown["Enum.KeyCode.D"] = false
            end
        end
    end
end)

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SiextherByHann.Sxthr"
screenGui.ResetOnSpawn = false
screenGui.Parent = Services.CoreGui

-- MAIN FRAME - Diubah jadi 280x240
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 280, 0, 240)
mainFrame.Position = UDim2.new(0.5, -140, 0.5, -120)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 18, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner", mainFrame)
mainCorner.CornerRadius = UDim.new(0, 12)

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
minimizedBtn.Text = "SX"
minimizedBtn.TextColor3 = Color3.fromRGB(70, 130, 255)
minimizedBtn.Font = Enum.Font.GothamBold
minimizedBtn.TextSize = 25
minimizedBtn.Visible = false
minimizedBtn.Active = true
minimizedBtn.Draggable = true
minimizedBtn.Parent = screenGui
minimizedBtn.ZIndex = 5

-- Gradient Animation untuk Minimized Button
local MinimizedGradient = Instance.new("UIGradient")
MinimizedGradient.Parent = minimizedBtn
MinimizedGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(0.3, Color3.fromRGB(70, 130, 255)),
    ColorSequenceKeypoint.new(0.6, Color3.fromRGB(70, 130, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
})
MinimizedGradient.Offset = Vector2.new(-1, 0)
MinimizedGradient.Rotation = 0

task.spawn(function()
    while minimizedBtn and minimizedBtn.Parent do
        TweenService:Create(MinimizedGradient, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Offset = Vector2.new(1, 0)
        }):Play()
        task.wait(2)
        
        TweenService:Create(MinimizedGradient, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Offset = Vector2.new(-1, 0)
        }):Play()
        task.wait(2)
    end
end)

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

-- Gradient Animation untuk Title
local TitleGradient = Instance.new("UIGradient")
TitleGradient.Parent = title
TitleGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(0.3, Color3.fromRGB(70, 130, 255)),
    ColorSequenceKeypoint.new(0.6, Color3.fromRGB(70, 130, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
})
TitleGradient.Offset = Vector2.new(-1, 0)
TitleGradient.Rotation = 0

task.spawn(function()
    while title and title.Parent do
        TweenService:Create(TitleGradient, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Offset = Vector2.new(1, 0)
        }):Play()
        task.wait(2)
        
        TweenService:Create(TitleGradient, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Offset = Vector2.new(-1, 0)
        }):Play()
        task.wait(2)
    end
end)

-- Play/Stop Toggle Button
local playStopBtn = Instance.new("TextButton")
playStopBtn.Size = UDim2.new(1, -24, 0, 35)
playStopBtn.Position = UDim2.new(0, 12, 0, 45)
playStopBtn.BackgroundColor3 = Color3.fromRGB(25, 30, 40)
playStopBtn.BorderSizePixel = 0
playStopBtn.Text = "AKTIFKAN GLITCH"
playStopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
playStopBtn.Font = Enum.Font.GothamBold
playStopBtn.TextSize = 14
playStopBtn.Parent = mainFrame

local playStopCorner = Instance.new("UICorner", playStopBtn)
playStopCorner.CornerRadius = UDim.new(0, 8)

-- Speed Slider Container
local speedContainer = Instance.new("Frame")
speedContainer.Size = UDim2.new(1, -24, 0, 55)
speedContainer.Position = UDim2.new(0, 12, 0, 88)
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
sliderBar.Position = UDim2.new(0, 10, 0, 32)
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

-- Spin Button (Left Side) - POSISI DIPERBAIKI
local spinBtn = Instance.new("TextButton")
spinBtn.Size = UDim2.new(0.48, -6, 0, 32)
spinBtn.Position = UDim2.new(0, 12, 0, 151)
spinBtn.BackgroundColor3 = Color3.fromRGB(25, 30, 40)
spinBtn.BorderSizePixel = 0
spinBtn.Text = "SPIN"
spinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
spinBtn.Font = Enum.Font.GothamBold
spinBtn.TextSize = 13
spinBtn.Parent = mainFrame

local spinCorner = Instance.new("UICorner", spinBtn)
spinCorner.CornerRadius = UDim.new(0, 8)

-- Swimming Button (Right Side) - POSISI DIPERBAIKI
local swimBtn = Instance.new("TextButton")
swimBtn.Size = UDim2.new(0.48, -6, 0, 32)
swimBtn.Position = UDim2.new(0.52, 0, 0, 151)
swimBtn.BackgroundColor3 = Color3.fromRGB(25, 30, 40)
swimBtn.BorderSizePixel = 0
swimBtn.Text = "SWIM"
swimBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
swimBtn.Font = Enum.Font.GothamBold
swimBtn.TextSize = 13
swimBtn.Parent = mainFrame

local swimCorner = Instance.new("UICorner", swimBtn)
swimCorner.CornerRadius = UDim.new(0, 8)

-- FreeCam Button (Left Side) - POSISI DIPERBAIKI
local freeCamBtn = Instance.new("TextButton")
freeCamBtn.Size = UDim2.new(0.48, -6, 0, 32)
freeCamBtn.Position = UDim2.new(0, 12, 0, 191)
freeCamBtn.BackgroundColor3 = Color3.fromRGB(25, 30, 40)
freeCamBtn.BorderSizePixel = 0
freeCamBtn.Text = "FREECAM"
freeCamBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
freeCamBtn.Font = Enum.Font.GothamBold
freeCamBtn.TextSize = 11
freeCamBtn.Parent = mainFrame

local freeCamCorner = Instance.new("UICorner", freeCamBtn)
freeCamCorner.CornerRadius = UDim.new(0, 8)

local killAllBtn = Instance.new("TextButton")
killAllBtn.Size = UDim2.new(0.48, -6, 0, 32)
killAllBtn.Position = UDim2.new(0.52, 0, 0, 191)
killAllBtn.BackgroundColor3 = Color3.fromRGB(25, 30, 40)
killAllBtn.BorderSizePixel = 0
killAllBtn.Text = "FLING ALL"
killAllBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
killAllBtn.Font = Enum.Font.GothamBold
killAllBtn.TextSize = 11
killAllBtn.Parent = mainFrame

local killAllCorner = Instance.new("UICorner", killAllBtn)
killAllCorner.CornerRadius = UDim.new(0, 8)

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
        playStopBtn.Text = "AKTIFKAN"
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
        spinBtn.Text = "SPIN"
        spinBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 255)
        
        spinConnection = RunService.RenderStepped:Connect(function(dt)
            if character.PrimaryPart then
                character.PrimaryPart.CFrame = character.PrimaryPart.CFrame * CFrame.Angles(0, math.rad(35), 0)
            end
        end)
    else
        isSpinning = false
        spinBtn.Text = "SPIN"
        spinBtn.BackgroundColor3 = Color3.fromRGB(25, 30, 40)
        
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
        swimBtn.BackgroundColor3 = Color3.fromRGB(25, 30, 40)
    else
        startSwimming()
        swimBtn.Text = "SWIM"
        swimBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 255)
    end
end)

-- FreeCam Button Logic
freeCamBtn.MouseButton1Click:Connect(function()
    if freeCamEnabled then
        disableFreeCam()
        freeCamBtn.Text = "FREECAM"
        freeCamBtn.BackgroundColor3 = Color3.fromRGB(25, 30, 40)
    else
        enableFreeCam()
        freeCamBtn.Text = "FREECAM"
        freeCamBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 255)
    end
end)

-- Fling All Function
local function executeKillAll()
    local Targets = {"All"}
    local AllBool = false
    
    local GetPlayer = function(Name)
        Name = Name:lower()
        if Name == "all" or Name == "others" then
            AllBool = true
            return
        elseif Name == "random" then
            local GetPlayers = Players:GetPlayers()
            if table.find(GetPlayers, Player) then 
                table.remove(GetPlayers, table.find(GetPlayers, Player)) 
            end
            return GetPlayers[math.random(#GetPlayers)]
        elseif Name ~= "random" and Name ~= "all" and Name ~= "others" then
            for _, x in next, Players:GetPlayers() do
                if x ~= Player then
                    if x.Name:lower():match("^"..Name) then
                        return x
                    elseif x.DisplayName:lower():match("^"..Name) then
                        return x
                    end
                end
            end
        else
            return
        end
    end
    
    local Message = function(_Title, _Text, Time)
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = _Title, 
            Text = _Text, 
            Duration = Time
        })
    end
    
    local SkidFling = function(TargetPlayer)
        local Character = player.Character
        local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
        local RootPart = Humanoid and Humanoid.RootPart
        
        local TCharacter = TargetPlayer.Character
        local THumanoid
        local TRootPart
        local THead
        local Accessory
        local Handle
        
        if TCharacter:FindFirstChildOfClass("Humanoid") then
            THumanoid = TCharacter:FindFirstChildOfClass("Humanoid")
        end
        if THumanoid and THumanoid.RootPart then
            TRootPart = THumanoid.RootPart
        end
        if TCharacter:FindFirstChild("Head") then
            THead = TCharacter.Head
        end
        if TCharacter:FindFirstChildOfClass("Accessory") then
            Accessory = TCharacter:FindFirstChildOfClass("Accessory")
        end
        if Accessory and Accessory:FindFirstChild("Handle") then
            Handle = Accessory.Handle
        end
        
        if Character and Humanoid and RootPart then
            if RootPart.Velocity.Magnitude < 50 then
                getgenv().OldPos = RootPart.CFrame
            end
            if THumanoid and THumanoid.Sit and not AllBool then
                return 
            end
            if THead then
                workspace.CurrentCamera.CameraSubject = THead
            elseif not THead and Handle then
                workspace.CurrentCamera.CameraSubject = Handle
            elseif THumanoid and TRootPart then
                workspace.CurrentCamera.CameraSubject = THumanoid
            end
            if not TCharacter:FindFirstChildWhichIsA("BasePart") then
                return
            end
            
            local FPos = function(BasePart, Pos, Ang)
                RootPart.CFrame = CFrame.new(BasePart.Position) * Pos * Ang
                Character:SetPrimaryPartCFrame(CFrame.new(BasePart.Position) * Pos * Ang)
                RootPart.Velocity = Vector3.new(9e7, 9e7 * 10, 9e7)
                RootPart.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
            end
            
            local SFBasePart = function(BasePart)
                local TimeToWait = 2
                local Time = tick()
                local Angle = 0
                
                repeat
                    if RootPart and THumanoid then
                        if BasePart.Velocity.Magnitude < 50 then
                            Angle = Angle + 100
                            
                            FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                            task.wait()
                            
                            FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                            task.wait()
                            
                            FPos(BasePart, CFrame.new(2.25, 1.5, -2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                            task.wait()
                            
                            FPos(BasePart, CFrame.new(-2.25, -1.5, 2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                            task.wait()
                            
                            FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection, CFrame.Angles(math.rad(Angle), 0, 0))
                            task.wait()
                            
                            FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection, CFrame.Angles(math.rad(Angle), 0, 0))
                            task.wait()
                        else
                            FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
                            task.wait()
                            
                            FPos(BasePart, CFrame.new(0, -1.5, -THumanoid.WalkSpeed), CFrame.Angles(0, 0, 0))
                            task.wait()
                            
                            FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
                            task.wait()
                            
                            FPos(BasePart, CFrame.new(0, 1.5, TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(90), 0, 0))
                            task.wait()
                            
                            FPos(BasePart, CFrame.new(0, -1.5, -TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(0, 0, 0))
                            task.wait()
                            
                            FPos(BasePart, CFrame.new(0, 1.5, TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(90), 0, 0))
                            task.wait()
                            
                            FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(90), 0, 0))
                            task.wait()
                            
                            FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
                            task.wait()
                            
                            FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(-90), 0, 0))
                            task.wait()
                            
                            FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
                            task.wait()
                        end
                    else
                        break
                    end
                until BasePart.Velocity.Magnitude > 500 or BasePart.Parent ~= TargetPlayer.Character or TargetPlayer.Parent ~= Players or not TargetPlayer.Character == TCharacter or THumanoid.Sit or Humanoid.Health <= 0 or tick() > Time + TimeToWait
            end
            
            workspace.FallenPartsDestroyHeight = 0/0
            
            local BV = Instance.new("BodyVelocity")
            BV.Name = "EpixVel"
            BV.Parent = RootPart
            BV.Velocity = Vector3.new(9e8, 9e8, 9e8)
            BV.MaxForce = Vector3.new(1/0, 1/0, 1/0)
            
            Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
            
            if TRootPart and THead then
                if (TRootPart.CFrame.p - THead.CFrame.p).Magnitude > 5 then
                    SFBasePart(THead)
                else
                    SFBasePart(TRootPart)
                end
            elseif TRootPart and not THead then
                SFBasePart(TRootPart)
            elseif not TRootPart and THead then
                SFBasePart(THead)
            elseif not TRootPart and not THead and Accessory and Handle then
                SFBasePart(Handle)
            else
                return 
            end
            
            BV:Destroy()
            Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
            workspace.CurrentCamera.CameraSubject = Humanoid
            
            repeat
                RootPart.CFrame = getgenv().OldPos * CFrame.new(0, .5, 0)
                Character:SetPrimaryPartCFrame(getgenv().OldPos * CFrame.new(0, .5, 0))
                Humanoid:ChangeState("GettingUp")
                table.foreach(Character:GetChildren(), function(_, x)
                    if x:IsA("BasePart") then
                        x.Velocity, x.RotVelocity = Vector3.new(), Vector3.new()
                    end
                end)
                task.wait()
            until (RootPart.Position - getgenv().OldPos.p).Magnitude < 25
            workspace.FallenPartsDestroyHeight = getgenv().FPDH
        else
            return 
        end
    end
    
    if not Welcome then 
        
    end
    getgenv().Welcome = true
    
    if Targets[1] then 
        for _, x in next, Targets do 
            GetPlayer(x) 
        end 
    else 
        return 
    end
    
    if AllBool then
        for _, x in next, Players:GetPlayers() do
            if x ~= player then
                SkidFling(x)
            end
        end
    end
    
    for _, x in next, Targets do
        if GetPlayer(x) and GetPlayer(x) ~= player then
            if GetPlayer(x).UserId ~= 1414978355 then
                local TPlayer = GetPlayer(x)
                if TPlayer then
                    SkidFling(TPlayer)
                end
            end
        end
    end
end

-- Kill All Button Logic
killAllBtn.MouseButton1Click:Connect(function()
    executeKillAll()
end)

-- Minimize/Maximize Logic dengan Animasi
minimizeBtn.MouseButton1Click:Connect(function()
    SmoothTween(mainFrame, 0.5, {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.3, 0),
        BackgroundTransparency = 1
    })
    
    task.wait(0.5)
    mainFrame.Visible = false
    minimizedBtn.Visible = true
end)

minimizedBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    minimizedBtn.Visible = false
    
    mainFrame.Size = UDim2.new(0, 0, 0, 0)
    mainFrame.Position = UDim2.new(0.5, 0, 0.3, 0)
    mainFrame.BackgroundTransparency = 1
    
    SmoothTween(mainFrame, 0.5, {
        Size = UDim2.new(0, 280, 0, 240),
        Position = UDim2.new(0.5, -140, 0.5, -120),
        BackgroundTransparency = 0
    })
end)



-- Close Button Logic dengan Animasi
closeBtn.MouseButton1Click:Connect(function()
    StopTrack()
    if spinConnection then
        spinConnection:Disconnect()
    end
    stopSwimming()
    if freeCamEnabled then
        disableFreeCam()
    end
    
    SmoothTween(mainFrame, 0.2, {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.3, 0),
        BackgroundTransparency = 1
    })
    
    task.wait(0.2)
    screenGui:Destroy()
end)

RunService.RenderStepped:Connect(function()
    if character.PrimaryPart then
        lastPosition = character.PrimaryPart.Position
    end
end)

-- Handle character respawn for FreeCam
player.CharacterAdded:Connect(function(newChar)
    if freeCamEnabled then
        task.wait(0.1)
        local hum = newChar:WaitForChild("Humanoid")
        hum.WalkSpeed = 0
        hum.JumpPower = 0
        hum.JumpHeight = 0
    end
end)

-- Animasi Buka saat pertama kali dimuat
mainFrame.Position = UDim2.new(0.5, 0, 0.3, 0)
mainFrame.Size = UDim2.new(0, 0, 0, 0)
mainFrame.BackgroundTransparency = 1

SmoothTween(mainFrame, 0.2, {
    Size = UDim2.new(0, 280, 0, 240), 
    Position = UDim2.new(0.5, -140, 0.5, -120),
    BackgroundTransparency = 0
})