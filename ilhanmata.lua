-- Modern Spectator GUI with Simple Transitions
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Variabel untuk spectating
local currentSpectateIndex = 0
local spectatingPlayers = {}
local isSpectating = false
local originalCamera = workspace.CurrentCamera.CameraType
local connection
local randomMode = false
local randomConnection

-- FreeCam Variables
local freeCamEnabled = false
local freeCamConnection
local keysDown = {}
local rotating = false
local touchPos
local onMobile = not UserInputService.KeyboardEnabled
local freeCamSpeed = 5
local freeCamSens = 0.3
local originalWalkSpeed = 16
local originalJumpPower = 50
local originalJumpHeight = 7.2

freeCamSpeed = freeCamSpeed / 10

if onMobile then
    freeCamSens = freeCamSens * 2
end

local function getSpectatablePlayers()
    local players = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
            table.insert(players, p)
        end
    end
    return players
end

-- Simple instant transition (no animation to avoid bugs)
local function playSimpleTransition(callback)
    -- Just switch target instantly
    if callback then
        callback()
    end
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
    
    if isSpectating then
        stopSpectate()
    end
    
    if player.Character then
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            originalWalkSpeed = humanoid.WalkSpeed
            originalJumpPower = humanoid.JumpPower
            originalJumpHeight = humanoid.JumpHeight
            
            humanoid.WalkSpeed = 0
            humanoid.JumpPower = 0
            humanoid.JumpHeight = 0
        end
    end
    
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
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
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = originalWalkSpeed
            humanoid.JumpPower = originalJumpPower
            humanoid.JumpHeight = originalJumpHeight
        end
    end
    
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, true)
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

local function startSpectate(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then return end
    
    isSpectating = true
    workspace.CurrentCamera.CameraSubject = targetPlayer.Character.Humanoid
    workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
end

local function stopSpectate()
    isSpectating = false
    workspace.CurrentCamera.CameraSubject = player.Character.Humanoid
    workspace.CurrentCamera.CameraType = originalCamera
    if connection then
        connection:Disconnect()
        connection = nil
    end
    currentSpectateIndex = 0
end

local function teleportToPlayer()
    if #spectatingPlayers > 0 and currentSpectateIndex > 0 then
        local targetPlayer = spectatingPlayers[currentSpectateIndex]
        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
            end
        end
    end
end

-- Membuat GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SpectatorGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Frame utama modern dark dengan blue stroke
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 300, 0, 180)
mainFrame.Position = UDim2.new(0.5, -150, 0.1, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(70, 130, 255)
mainStroke.Thickness = 2
mainStroke.Parent = mainFrame

-- Header tanpa stroke
local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 35)
header.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
header.BorderSizePixel = 0
header.Parent = mainFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 12)
headerCorner.Parent = header

local headerFix = Instance.new("Frame")
headerFix.Size = UDim2.new(1, 0, 0, 12)
headerFix.Position = UDim2.new(0, 0, 1, -12)
headerFix.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
headerFix.BorderSizePixel = 0
headerFix.Parent = header

-- Title
local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, -75, 1, 0)
title.Position = UDim2.new(0, 12, 0, 0)
title.BackgroundTransparency = 1
title.Text = "SIEXTHER SPECTATOR"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 14
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

-- Button Minimize
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Name = "MinimizeBtn"
minimizeBtn.Size = UDim2.new(0, 28, 0, 24)
minimizeBtn.Position = UDim2.new(1, -60, 0, 5)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
minimizeBtn.Text = "_"
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.TextSize = 16
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.BorderSizePixel = 0
minimizeBtn.Parent = header

local minimizeCorner = Instance.new("UICorner")
minimizeCorner.CornerRadius = UDim.new(0, 6)
minimizeCorner.Parent = minimizeBtn

-- Button Close
local closeBtn = Instance.new("TextButton")
closeBtn.Name = "CloseBtn"
closeBtn.Size = UDim2.new(0, 28, 0, 24)
closeBtn.Position = UDim2.new(1, -28, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 14
closeBtn.Font = Enum.Font.GothamBold
closeBtn.BorderSizePixel = 0
closeBtn.Parent = header

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeBtn

-- Content Frame
local contentFrame = Instance.new("Frame")
contentFrame.Name = "Content"
contentFrame.Size = UDim2.new(1, -20, 1, -45)
contentFrame.Position = UDim2.new(0, 10, 0, 40)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- Player Name Label
local playerLabel = Instance.new("TextLabel")
playerLabel.Name = "PlayerLabel"
playerLabel.Size = UDim2.new(1, 0, 0, 25)
playerLabel.Position = UDim2.new(0, 0, 0, 0)
playerLabel.BackgroundTransparency = 1
playerLabel.Text = "Select a player"
playerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
playerLabel.TextSize = 14
playerLabel.Font = Enum.Font.Gotham
playerLabel.Parent = contentFrame

-- Control Frame
local controlFrame = Instance.new("Frame")
controlFrame.Name = "Controls"
controlFrame.Size = UDim2.new(1, 0, 0, 32)
controlFrame.Position = UDim2.new(0, 0, 0, 30)
controlFrame.BackgroundTransparency = 1
controlFrame.Parent = contentFrame

-- Button Previous
local prevBtn = Instance.new("TextButton")
prevBtn.Name = "PrevBtn"
prevBtn.Size = UDim2.new(0, 70, 0, 32)
prevBtn.Position = UDim2.new(0, 0, 0, 0)
prevBtn.BackgroundColor3 = Color3.fromRGB(25, 30, 40)
prevBtn.Text = "<"
prevBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
prevBtn.TextSize = 22
prevBtn.Font = Enum.Font.GothamBold
prevBtn.BorderSizePixel = 0
prevBtn.Parent = controlFrame

local prevCorner = Instance.new("UICorner")
prevCorner.CornerRadius = UDim.new(0, 8)
prevCorner.Parent = prevBtn

-- Button STOP
local stopBtn = Instance.new("TextButton")
stopBtn.Name = "StopBtn"
stopBtn.Size = UDim2.new(0, 125, 0, 32)
stopBtn.Position = UDim2.new(0.5, -62.5, 0, 0)
stopBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
stopBtn.Text = "STOP"
stopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
stopBtn.TextSize = 18
stopBtn.Font = Enum.Font.GothamBold
stopBtn.Visible = false
stopBtn.BorderSizePixel = 0
stopBtn.Parent = controlFrame

local stopCorner = Instance.new("UICorner")
stopCorner.CornerRadius = UDim.new(0, 8)
stopCorner.Parent = stopBtn

-- Button Next
local nextBtn = Instance.new("TextButton")
nextBtn.Name = "NextBtn"
nextBtn.Size = UDim2.new(0, 70, 0, 32)
nextBtn.Position = UDim2.new(1, -70, 0, 0)
nextBtn.BackgroundColor3 = Color3.fromRGB(25, 30, 40)
nextBtn.Text = ">"
nextBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
nextBtn.TextSize = 22
nextBtn.Font = Enum.Font.GothamBold
nextBtn.BorderSizePixel = 0
nextBtn.Parent = controlFrame

local nextCorner = Instance.new("UICorner")
nextCorner.CornerRadius = UDim.new(0, 8)
nextCorner.Parent = nextBtn

-- Action Frame Row 1
local actionFrame1 = Instance.new("Frame")
actionFrame1.Name = "Actions1"
actionFrame1.Size = UDim2.new(1, 0, 0, 32)
actionFrame1.Position = UDim2.new(0, 0, 0, 68)
actionFrame1.BackgroundTransparency = 1
actionFrame1.Parent = contentFrame

-- Button Teleport
local teleportBtn = Instance.new("TextButton")
teleportBtn.Name = "TeleportBtn"
teleportBtn.Size = UDim2.new(0.48, 0, 0, 32)
teleportBtn.Position = UDim2.new(0, 0, 0, 0)
teleportBtn.BackgroundColor3 = Color3.fromRGB(25, 30, 40)
teleportBtn.Text = "📍 TP"
teleportBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
teleportBtn.TextSize = 14
teleportBtn.Font = Enum.Font.GothamBold
teleportBtn.BorderSizePixel = 0
teleportBtn.Parent = actionFrame1

local teleportCorner = Instance.new("UICorner")
teleportCorner.CornerRadius = UDim.new(0, 8)
teleportCorner.Parent = teleportBtn

-- Button Random Mode
local randomBtn = Instance.new("TextButton")
randomBtn.Name = "RandomBtn"
randomBtn.Size = UDim2.new(0.48, 0, 0, 32)
randomBtn.Position = UDim2.new(0.52, 0, 0, 0)
randomBtn.BackgroundColor3 = Color3.fromRGB(25, 30, 40)
randomBtn.Text = "🎲 Random"
randomBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
randomBtn.TextSize = 13
randomBtn.Font = Enum.Font.GothamBold
randomBtn.BorderSizePixel = 0
randomBtn.Parent = actionFrame1

local randomCorner = Instance.new("UICorner")
randomCorner.CornerRadius = UDim.new(0, 8)
randomCorner.Parent = randomBtn

-- Action Frame Row 2
local actionFrame2 = Instance.new("Frame")
actionFrame2.Name = "Actions2"
actionFrame2.Size = UDim2.new(1, 0, 0, 32)
actionFrame2.Position = UDim2.new(0, 0, 0, 106)
actionFrame2.BackgroundTransparency = 1
actionFrame2.Parent = contentFrame

-- Button FreeCam
local freeCamBtn = Instance.new("TextButton")
freeCamBtn.Name = "FreeCamBtn"
freeCamBtn.Size = UDim2.new(1, 0, 0, 32)
freeCamBtn.Position = UDim2.new(0, 0, 0, 0)
freeCamBtn.BackgroundColor3 = Color3.fromRGB(25, 30, 40)
freeCamBtn.Text = "🎥 FreeCam: OFF"
freeCamBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
freeCamBtn.TextSize = 14
freeCamBtn.Font = Enum.Font.GothamBold
freeCamBtn.BorderSizePixel = 0
freeCamBtn.Parent = actionFrame2

local freeCamCorner = Instance.new("UICorner")
freeCamCorner.CornerRadius = UDim.new(0, 8)
freeCamCorner.Parent = freeCamBtn

-- Button Minimized
local minimizedBtn = Instance.new("TextButton")
minimizedBtn.Name = "MinimizedBtn"
minimizedBtn.Size = UDim2.new(0, 41, 0, 41)
minimizedBtn.Position = UDim2.new(1, -70, 0.5, -22)
minimizedBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
minimizedBtn.Text = "👁️"
minimizedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizedBtn.TextSize = 20
minimizedBtn.Font = Enum.Font.GothamBold
minimizedBtn.Visible = false
minimizedBtn.Active = true
minimizedBtn.Draggable = true
minimizedBtn.BorderSizePixel = 0
minimizedBtn.Parent = screenGui

local minimizedCorner = Instance.new("UICorner")
minimizedCorner.CornerRadius = UDim.new(0, 12)
minimizedCorner.Parent = minimizedBtn


-- Fungsi update
local function updateStopButtonVisibility()
    stopBtn.Visible = isSpectating
end

local function updatePlayerLabel()
    if #spectatingPlayers > 0 and currentSpectateIndex > 0 then
        local targetPlayer = spectatingPlayers[currentSpectateIndex]
        if targetPlayer then
            local modeText = randomMode and " [RANDOM]" or ""
            playerLabel.Text = "Spectating: " .. targetPlayer.Name .. modeText
        end
    else
        playerLabel.Text = "Select a player"
    end
    updateStopButtonVisibility()
end

-- Navigasi dengan simple transition
local function navigateSpectate(direction)
    spectatingPlayers = getSpectatablePlayers()
    
    if #spectatingPlayers == 0 then
        playerLabel.Text = "No players available"
        stopSpectate()
        updateStopButtonVisibility()
        return
    end
    
    playSimpleTransition(function()
        currentSpectateIndex = currentSpectateIndex + direction
        
        if currentSpectateIndex > #spectatingPlayers then
            currentSpectateIndex = 1
        elseif currentSpectateIndex < 1 then
            currentSpectateIndex = #spectatingPlayers
        end
        
        local targetPlayer = spectatingPlayers[currentSpectateIndex]
        startSpectate(targetPlayer)
    end)
    
    updatePlayerLabel()
end

-- Random mode
local function toggleRandomMode()
    randomMode = not randomMode
    
    if randomMode then
        randomBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 255)
        randomBtn.Text = "⏸️ Stop"
        
        randomConnection = task.spawn(function()
            while randomMode do
                spectatingPlayers = getSpectatablePlayers()
                
                if #spectatingPlayers > 0 then
                    playSimpleTransition(function()
                        currentSpectateIndex = math.random(1, #spectatingPlayers)
                        local targetPlayer = spectatingPlayers[currentSpectateIndex]
                        startSpectate(targetPlayer)
                    end)
                    
                    updatePlayerLabel()
                    wait(4)
                else
                    playerLabel.Text = "No players available"
                    updateStopButtonVisibility()
                    wait(1)
                end
            end
        end)
    else
        randomBtn.BackgroundColor3 = Color3.fromRGB(25, 30, 40)
        randomBtn.Text = "🎲 Random"
        if randomConnection then
            task.cancel(randomConnection)
        end
        updatePlayerLabel()
    end
end

-- Toggle FreeCam
local function toggleFreeCam()
    if freeCamEnabled then
        disableFreeCam()
        freeCamBtn.Text = "🎥 FreeCam: OFF"
        freeCamBtn.BackgroundColor3 = Color3.fromRGB(25, 30, 40)
    else
        enableFreeCam()
        freeCamBtn.Text = "🎥 FreeCam: ON"
        freeCamBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 255)
    end
end

-- Event handlers
prevBtn.MouseButton1Click:Connect(function()
    if not randomMode and not freeCamEnabled then
        navigateSpectate(-1)
    end
end)

nextBtn.MouseButton1Click:Connect(function()
    if not randomMode and not freeCamEnabled then
        navigateSpectate(1)
    end
end)

stopBtn.MouseButton1Click:Connect(function()
    if randomMode then
        toggleRandomMode()
    end
    stopSpectate()
    playerLabel.Text = "Select a player"
    updateStopButtonVisibility()
end)

teleportBtn.MouseButton1Click:Connect(function()
    if not freeCamEnabled then
        teleportToPlayer()
    end
end)

randomBtn.MouseButton1Click:Connect(function()
    if not freeCamEnabled then
        toggleRandomMode()
    end
end)

freeCamBtn.MouseButton1Click:Connect(function()
    toggleFreeCam()
end)

closeBtn.MouseButton1Click:Connect(function()
    if randomMode then
        toggleRandomMode()
    end
    if freeCamEnabled then
        disableFreeCam()
    end
    stopSpectate()
    mainFrame.Visible = false
    minimizedBtn.Visible = false
end)

minimizeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    minimizedBtn.Visible = true
end)

minimizedBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    minimizedBtn.Visible = false
end)

-- Hover effects
local function addHoverEffect(button, normalColor, hoverColor)
    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = hoverColor
    end)
    
    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = normalColor
    end)
end

addHoverEffect(prevBtn, Color3.fromRGB(25, 30, 40), Color3.fromRGB(45, 50, 60))
addHoverEffect(nextBtn, Color3.fromRGB(25, 30, 40), Color3.fromRGB(45, 50, 60))
addHoverEffect(stopBtn, Color3.fromRGB(200, 50, 50), Color3.fromRGB(220, 70, 70))
addHoverEffect(closeBtn, Color3.fromRGB(200, 50, 50), Color3.fromRGB(220, 70, 70))
addHoverEffect(minimizeBtn, Color3.fromRGB(25, 25, 30), Color3.fromRGB(45, 45, 50))
addHoverEffect(minimizedBtn, Color3.fromRGB(15, 15, 20), Color3.fromRGB(35, 35, 40))
addHoverEffect(teleportBtn, Color3.fromRGB(25, 30, 40), Color3.fromRGB(45, 50, 60))
addHoverEffect(randomBtn, Color3.fromRGB(25, 30, 40), Color3.fromRGB(45, 50, 60))
addHoverEffect(freeCamBtn, Color3.fromRGB(25, 30, 40), Color3.fromRGB(45, 50, 60))

-- Handle character respawn
player.CharacterAdded:Connect(function(character)
    if freeCamEnabled then
        wait(0.1)
        local humanoid = character:WaitForChild("Humanoid")
        humanoid.WalkSpeed = 0
        humanoid.JumpPower = 0
        humanoid.JumpHeight = 0
    end
end)