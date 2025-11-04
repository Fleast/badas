-- Enhanced Spectator GUI Script
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

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

local function getSpectatablePlayers()
    local players = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
            table.insert(players, p)
        end
    end
    return players
end

-- Fungsi animasi cinematic transition yang lebih smooth
local function playCinematicTransition(callback)
    local camera = workspace.CurrentCamera
    local originalCFrame = camera.CFrame
    local originalFOV = camera.FieldOfView
    
    -- Simpan posisi dan orientasi asli
    local originalPosition = originalCFrame.Position
    local originalRotation = Vector3.new(
        originalCFrame:ToEulerAnglesXYZ()
    )
    
    -- Buat rotasi ringan untuk efek cinematic
    local rotationAngle = math.rad(15) -- 15 derajat rotasi
    local targetRotation = CFrame.fromEulerAnglesXYZ(
        originalRotation.X + rotationAngle,
        originalRotation.Y + rotationAngle,
        originalRotation.Z
    )
    
    -- Phase 1: Zoom out dengan rotasi ringan (0.4 detik)
    local zoomOutTween = TweenService:Create(camera, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        FieldOfView = originalFOV + 25,
        CFrame = originalCFrame * CFrame.Angles(rotationAngle * 0.3, rotationAngle * 0.5, 0) + originalCFrame.LookVector * -5
    })
    
    -- Phase 2: Transition cepat ke posisi netral (0.2 detik)
    local neutralTween = TweenService:Create(camera, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
        FieldOfView = originalFOV + 30,
        CFrame = originalCFrame + Vector3.new(0, 3, -8) * CFrame.Angles(math.rad(-10), 0, 0)
    })
    
    -- Eksekusi animasi
    zoomOutTween:Play()
    zoomOutTween.Completed:Wait()
    
    -- Callback untuk ganti target di tengah transisi
    if callback then
        callback()
    end
    
    neutralTween:Play()
    neutralTween.Completed:Wait()
    
    -- Phase 3: Smooth zoom in ke target baru (0.6 detik)
    local zoomInTween = TweenService:Create(camera, TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        FieldOfView = originalFOV,
        CFrame = camera.CFrame -- Tetap di posisi terakhir sebelum beralih ke target
    })
    
    zoomInTween:Play()
    zoomInTween.Completed:Wait()
end

-- Fungsi animasi alternatif yang lebih sederhana tapi tetap cinematic
local function playSmoothTransition(callback)
    local camera = workspace.CurrentCamera
    local originalCFrame = camera.CFrame
    local originalFOV = camera.FieldOfView
    
    -- Phase 1: Smooth zoom out dengan elevation ringan
    local phase1 = TweenService:Create(camera, TweenInfo.new(0.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
        FieldOfView = originalFOV + 20,
        CFrame = originalCFrame * CFrame.new(0, 2, -3) * CFrame.Angles(math.rad(-5), 0, 0)
    })
    
    -- Phase 2: Transition (ganti target di sini)
    local phase2 = TweenService:Create(camera, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        FieldOfView = originalFOV + 25,
        CFrame = originalCFrame * CFrame.new(0, 4, -6) * CFrame.Angles(math.rad(-8), math.rad(10), 0)
    })
    
    phase1:Play()
    phase1.Completed:Wait()
    
    -- Ganti target
    if callback then
        callback()
    end
    
    phase2:Play()
    phase2.Completed:Wait()
    
    -- Phase 3: Smooth return ke posisi normal
    local phase3 = TweenService:Create(camera, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        FieldOfView = originalFOV
        -- CFrame akan otomatis mengikuti subject baru
    })
    
    phase3:Play()
end

-- Fungsi animasi cinematic dengan rotasi spiral ringan
local function playSpiralTransition(callback)
    local camera = workspace.CurrentCamera
    local originalCFrame = camera.CFrame
    local originalFOV = camera.FieldOfView
    
    -- Hitung posisi untuk spiral effect
    local startPos = originalCFrame.Position
    local lookVector = originalCFrame.LookVector
    local rightVector = originalCFrame.RightVector
    local upVector = originalCFrame.UpVector
    
    -- Phase 1: Naik dan mundur dengan rotasi ringan
    local phase1 = TweenService:Create(camera, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        FieldOfView = originalFOV + 15,
        CFrame = CFrame.new(
            startPos + upVector * 2 - lookVector * 4 + rightVector * 1.5
        ) * CFrame.Angles(math.rad(-3), math.rad(8), math.rad(2))
    })
    
    -- Phase 2: Posisi tinggi untuk transition
    local phase2 = TweenService:Create(camera, TweenInfo.new(0.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut), {
        FieldOfView = originalFOV + 20,
        CFrame = CFrame.new(
            startPos + upVector * 5 - lookVector * 8 + rightVector * 0.5
        ) * CFrame.Angles(math.rad(-10), math.rad(15), math.rad(1))
    })
    
    phase1:Play()
    phase1.Completed:Wait()
    
    -- Ganti target di antara phase 1 dan 2
    if callback then
        callback()
    end
    
    phase2:Play()
    phase2.Completed:Wait()
    
    -- Phase 3: Smooth descent ke target baru
    local phase3 = TweenService:Create(camera, TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        FieldOfView = originalFOV
    })
    
    phase3:Play()
end

-- Fungsi untuk memulai spectate
local function startSpectate(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then return end
    
    isSpectating = true
    workspace.CurrentCamera.CameraSubject = targetPlayer.Character.Humanoid
    workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
end

-- Fungsi untuk berhenti spectate
local function stopSpectate()
    isSpectating = false
    workspace.CurrentCamera.CameraSubject = player.Character.Humanoid
    workspace.CurrentCamera.CameraType = originalCamera
    if connection then
        connection:Disconnect()
        connection = nil
    end
end

-- Fungsi untuk teleport ke player
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

-- Frame utama
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 280, 0, 130)
mainFrame.Position = UDim2.new(0.5, -140, 0.1, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
mainFrame.BackgroundTransparency = 0.15
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Corner untuk frame utama
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = mainFrame

-- Header
local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 28)
header.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
header.BackgroundTransparency = 0.15
header.BorderSizePixel = 0
header.Parent = mainFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 10)
headerCorner.Parent = header

-- Fix corner pada bagian bawah header
local headerFix = Instance.new("Frame")
headerFix.Size = UDim2.new(1, 0, 0, 10)
headerFix.Position = UDim2.new(0, 0, 1, -10)
headerFix.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
headerFix.BorderSizePixel = 0
headerFix.Parent = header

-- Title
local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, -65, 1, 0)
title.Position = UDim2.new(0, 8, 0, 0)
title.BackgroundTransparency = 1
title.Text = "SIEXTHER SPECTATOR"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 13
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

-- Button Minimize
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Name = "MinimizeBtn"
minimizeBtn.Size = UDim2.new(0, 24, 0, 20)
minimizeBtn.Position = UDim2.new(1, -52, 0, 4)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
minimizeBtn.BackgroundTransparency = 0.15
minimizeBtn.Text = "_"
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.TextSize = 14
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.Parent = header

local minimizeCorner = Instance.new("UICorner")
minimizeCorner.CornerRadius = UDim.new(0, 5)
minimizeCorner.Parent = minimizeBtn

-- Button Close
local closeBtn = Instance.new("TextButton")
closeBtn.Name = "CloseBtn"
closeBtn.Size = UDim2.new(0, 24, 0, 20)
closeBtn.Position = UDim2.new(1, -24, 0, 4)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.BackgroundTransparency = 0.15
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 13
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = header

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 5)
closeCorner.Parent = closeBtn

-- Content Frame
local contentFrame = Instance.new("Frame")
contentFrame.Name = "Content"
contentFrame.Size = UDim2.new(1, -16, 1, -35)
contentFrame.Position = UDim2.new(0, 8, 0, 32)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- Player Name Label
local playerLabel = Instance.new("TextLabel")
playerLabel.Name = "PlayerLabel"
playerLabel.Size = UDim2.new(1, 0, 0, 22)
playerLabel.Position = UDim2.new(0, 0, 0, 0)
playerLabel.BackgroundTransparency = 1
playerLabel.Text = "Select a player"
playerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
playerLabel.TextSize = 14
playerLabel.Font = Enum.Font.Gotham
playerLabel.Parent = contentFrame

-- Control Frame (Navigation)
local controlFrame = Instance.new("Frame")
controlFrame.Name = "Controls"
controlFrame.Size = UDim2.new(1, 0, 0, 30)
controlFrame.Position = UDim2.new(0, 0, 0, 28)
controlFrame.BackgroundTransparency = 1
controlFrame.Parent = contentFrame

-- Button Previous
local prevBtn = Instance.new("TextButton")
prevBtn.Name = "PrevBtn"
prevBtn.Size = UDim2.new(0, 60, 0, 28)
prevBtn.Position = UDim2.new(0, 0, 0, 0)
prevBtn.BackgroundColor3 = Color3.fromRGB(50, 120, 200)
prevBtn.BackgroundTransparency = 0.15
prevBtn.Text = "<"
prevBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
prevBtn.TextSize = 20
prevBtn.Font = Enum.Font.GothamBold
prevBtn.Parent = controlFrame

local prevCorner = Instance.new("UICorner")
prevCorner.CornerRadius = UDim.new(0, 8)
prevCorner.Parent = prevBtn

-- Button Next
local nextBtn = Instance.new("TextButton")
nextBtn.Name = "NextBtn"
nextBtn.Size = UDim2.new(0, 60, 0, 28)
nextBtn.Position = UDim2.new(1, -60, 0, 0)
nextBtn.BackgroundColor3 = Color3.fromRGB(50, 120, 200)
nextBtn.BackgroundTransparency = 0.15
nextBtn.Text = ">"
nextBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
nextBtn.TextSize = 20
nextBtn.Font = Enum.Font.GothamBold
nextBtn.Parent = controlFrame

local nextCorner = Instance.new("UICorner")
nextCorner.CornerRadius = UDim.new(0, 8)
nextCorner.Parent = nextBtn

-- Action Frame (Teleport & Random)
local actionFrame = Instance.new("Frame")
actionFrame.Name = "Actions"
actionFrame.Size = UDim2.new(1, 0, 0, 30)
actionFrame.Position = UDim2.new(0, 0, 1, -30)
actionFrame.BackgroundTransparency = 1
actionFrame.Parent = contentFrame

-- Button Teleport
local teleportBtn = Instance.new("TextButton")
teleportBtn.Name = "TeleportBtn"
teleportBtn.Size = UDim2.new(0.48, 0, 0, 28)
teleportBtn.Position = UDim2.new(0, 0, 0, 0)
teleportBtn.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
teleportBtn.BackgroundTransparency = 0.15
teleportBtn.Text = "📍 TP"
teleportBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
teleportBtn.TextSize = 14
teleportBtn.Font = Enum.Font.GothamBold
teleportBtn.Parent = actionFrame

local teleportCorner = Instance.new("UICorner")
teleportCorner.CornerRadius = UDim.new(0, 8)
teleportCorner.Parent = teleportBtn

-- Button Random Mode
local randomBtn = Instance.new("TextButton")
randomBtn.Name = "RandomBtn"
randomBtn.Size = UDim2.new(0.48, 0, 0, 28)
randomBtn.Position = UDim2.new(0.52, 0, 0, 0)
randomBtn.BackgroundColor3 = Color3.fromRGB(200, 100, 200)
randomBtn.BackgroundTransparency = 0.15
randomBtn.Text = "🎲 Random"
randomBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
randomBtn.TextSize = 13
randomBtn.Font = Enum.Font.GothamBold
randomBtn.Parent = actionFrame

local randomCorner = Instance.new("UICorner")
randomCorner.CornerRadius = UDim.new(0, 8)
randomCorner.Parent = randomBtn

-- Button Minimized (tersembunyi di awal)
local minimizedBtn = Instance.new("TextButton")
minimizedBtn.Name = "MinimizedBtn"
minimizedBtn.Size = UDim2.new(0, 50, 0, 50)
minimizedBtn.Position = UDim2.new(0.5, -25, 0.1, 0)
minimizedBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
minimizedBtn.BackgroundTransparency = 0.15
minimizedBtn.Text = "👁️"
minimizedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizedBtn.TextSize = 28
minimizedBtn.Font = Enum.Font.GothamBold
minimizedBtn.Visible = false
minimizedBtn.Active = true
minimizedBtn.Draggable = true
minimizedBtn.Parent = screenGui

local minimizedCorner = Instance.new("UICorner")
minimizedCorner.CornerRadius = UDim.new(0, 25)
minimizedCorner.Parent = minimizedBtn

-- Fungsi update player label
local function updatePlayerLabel()
    if #spectatingPlayers > 0 and currentSpectateIndex > 0 then
        local targetPlayer = spectatingPlayers[currentSpectateIndex]
        if targetPlayer then
            local modeText = randomMode and " [RANDOM]" or ""
            playerLabel.Text = "Spectating: " .. targetPlayer.Name .. modeText
        end
    else
        playerLabel.Text = "No players available"
    end
end

-- Fungsi untuk navigasi spectator dengan animasi cinematic
local function navigateSpectate(direction)
    spectatingPlayers = getSpectatablePlayers()
    
    if #spectatingPlayers == 0 then
        playerLabel.Text = "No players available"
        stopSpectate()
        return
    end
    
    -- Pilih animasi secara random untuk variasi
    local animTypes = {playSmoothTransition, playSpiralTransition}
    local selectedAnim = animTypes[math.random(1, #animTypes)]
    
    selectedAnim(function()
        currentSpectateIndex = currentSpectateIndex + direction
        
        if currentSpectateIndex > #spectatingPlayers then
            currentSpectateIndex = 1
        elseif currentSpectateIndex < 1 then
            currentSpectateIndex = #spectatingPlayers
        end
        
        local targetPlayer = spectatingPlayers[currentSpectateIndex]
        startSpectate(targetPlayer)
    end)
    
    wait(0.8) -- Wait untuk animasi cinematic yang lebih panjang
    updatePlayerLabel()
end

-- Fungsi random mode
local function toggleRandomMode()
    randomMode = not randomMode
    
    if randomMode then
        randomBtn.BackgroundColor3 = Color3.fromRGB(220, 120, 220)
        randomBtn.Text = "⏸️ Stop"
        
        -- Mulai random spectate
        randomConnection = task.spawn(function()
            while randomMode do
                spectatingPlayers = getSpectatablePlayers()
                
                if #spectatingPlayers > 0 then
                    -- Gunakan animasi cinematic untuk random mode juga
                    playSmoothTransition(function()
                        currentSpectateIndex = math.random(1, #spectatingPlayers)
                        local targetPlayer = spectatingPlayers[currentSpectateIndex]
                        startSpectate(targetPlayer)
                    end)
                    
                    wait(0.8) -- Wait untuk animasi cinematic
                    updatePlayerLabel()
                    wait(4.2) -- Total 5 detik per player
                else
                    playerLabel.Text = "No players available"
                    wait(1)
                end
            end
        end)
    else
        randomBtn.BackgroundColor3 = Color3.fromRGB(200, 100, 200)
        randomBtn.Text = "🎲 Random"
        if randomConnection then
            task.cancel(randomConnection)
        end
        updatePlayerLabel()
    end
end

-- Event handlers
prevBtn.MouseButton1Click:Connect(function()
    if not randomMode then
        navigateSpectate(-1)
    end
end)

nextBtn.MouseButton1Click:Connect(function()
    if not randomMode then
        navigateSpectate(1)
    end
end)

teleportBtn.MouseButton1Click:Connect(function()
    teleportToPlayer()
end)

randomBtn.MouseButton1Click:Connect(function()
    toggleRandomMode()
end)

closeBtn.MouseButton1Click:Connect(function()
    if randomMode then
        toggleRandomMode()
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

addHoverEffect(prevBtn, Color3.fromRGB(50, 120, 200), Color3.fromRGB(70, 140, 220))
addHoverEffect(nextBtn, Color3.fromRGB(50, 120, 200), Color3.fromRGB(70, 140, 220))
addHoverEffect(closeBtn, Color3.fromRGB(200, 50, 50), Color3.fromRGB(220, 70, 70))
addHoverEffect(minimizeBtn, Color3.fromRGB(50, 50, 50), Color3.fromRGB(70, 70, 70))
addHoverEffect(minimizedBtn, Color3.fromRGB(35, 35, 35), Color3.fromRGB(55, 55, 55))
addHoverEffect(teleportBtn, Color3.fromRGB(100, 200, 100), Color3.fromRGB(120, 220, 120))
addHoverEffect(randomBtn, Color3.fromRGB(200, 100, 200), Color3.fromRGB(220, 120, 220))
