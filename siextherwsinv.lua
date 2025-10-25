-- GUI WalkSpeed & Invisible Script
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CustomSpeedGui"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 280, 0, 240)
mainFrame.Position = UDim2.new(0.5, -140, 0.5, -120)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Parent = screenGui

-- Corner untuk Main Frame
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

-- Header
local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 40)
header.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
header.BorderSizePixel = 0
header.Parent = mainFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 12)
headerCorner.Parent = header

-- Fix corner di bawah header
local headerFix = Instance.new("Frame")
headerFix.Size = UDim2.new(1, 0, 0, 12)
headerFix.Position = UDim2.new(0, 0, 1, -12)
headerFix.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
headerFix.BorderSizePixel = 0
headerFix.Parent = header

-- Title
local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, -100, 1, 0)
title.Position = UDim2.new(0, 12, 0, 0)
title.BackgroundTransparency = 1
title.Text = "SIEXTHER WALKSPEED"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 16
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

-- Minimize Button
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Name = "MinimizeBtn"
minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
minimizeBtn.Position = UDim2.new(1, -70, 0.5, -15)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
minimizeBtn.Text = "─"
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.TextSize = 18
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.BorderSizePixel = 0
minimizeBtn.Parent = header

local minimizeBtnCorner = Instance.new("UICorner")
minimizeBtnCorner.CornerRadius = UDim.new(0, 7)
minimizeBtnCorner.Parent = minimizeBtn

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Name = "CloseBtn"
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0.5, -15)
closeBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 16
closeBtn.Font = Enum.Font.GothamBold
closeBtn.BorderSizePixel = 0
closeBtn.Parent = header

local closeBtnCorner = Instance.new("UICorner")
closeBtnCorner.CornerRadius = UDim.new(0, 7)
closeBtnCorner.Parent = closeBtn

-- Content Frame
local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1, -24, 1, -60)
contentFrame.Position = UDim2.new(0, 12, 0, 50)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- WalkSpeed Label
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(1, 0, 0, 20)
speedLabel.Position = UDim2.new(0, 0, 0, 5)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "WalkSpeed: 16"
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.TextSize = 14
speedLabel.Font = Enum.Font.GothamSemibold
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.Parent = contentFrame

-- Speed Input
local speedInput = Instance.new("TextBox")
speedInput.Name = "SpeedInput"
speedInput.Size = UDim2.new(0.48, -2, 0, 35)
speedInput.Position = UDim2.new(0, 0, 0, 30)
speedInput.BackgroundColor3 = Color3.fromRGB(55, 55, 70)
speedInput.Text = "16"
speedInput.PlaceholderText = "Speed..."
speedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
speedInput.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
speedInput.TextSize = 14
speedInput.Font = Enum.Font.Gotham
speedInput.ClearTextOnFocus = false
speedInput.BorderSizePixel = 0
speedInput.Parent = contentFrame

local speedInputCorner = Instance.new("UICorner")
speedInputCorner.CornerRadius = UDim.new(0, 7)
speedInputCorner.Parent = speedInput

-- Set Speed Button
local setSpeedBtn = Instance.new("TextButton")
setSpeedBtn.Name = "SetSpeedBtn"
setSpeedBtn.Size = UDim2.new(0.52, -2, 0, 35)
setSpeedBtn.Position = UDim2.new(0.48, 4, 0, 30)
setSpeedBtn.BackgroundColor3 = Color3.fromRGB(80, 150, 255)
setSpeedBtn.Text = "SET"
setSpeedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
setSpeedBtn.TextSize = 14
setSpeedBtn.Font = Enum.Font.GothamBold
setSpeedBtn.BorderSizePixel = 0
setSpeedBtn.Parent = contentFrame

local setSpeedBtnCorner = Instance.new("UICorner")
setSpeedBtnCorner.CornerRadius = UDim.new(0, 7)
setSpeedBtnCorner.Parent = setSpeedBtn

-- Reset Speed Button
local resetSpeedBtn = Instance.new("TextButton")
resetSpeedBtn.Name = "ResetSpeedBtn"
resetSpeedBtn.Size = UDim2.new(1, 0, 0, 35)
resetSpeedBtn.Position = UDim2.new(0, 0, 0, 72)
resetSpeedBtn.BackgroundColor3 = Color3.fromRGB(255, 150, 50)
resetSpeedBtn.Text = "🔄 Reset to Normal"
resetSpeedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
resetSpeedBtn.TextSize = 14
resetSpeedBtn.Font = Enum.Font.GothamBold
resetSpeedBtn.BorderSizePixel = 0
resetSpeedBtn.Parent = contentFrame

local resetSpeedBtnCorner = Instance.new("UICorner")
resetSpeedBtnCorner.CornerRadius = UDim.new(0, 7)
resetSpeedBtnCorner.Parent = resetSpeedBtn

-- Invisible Toggle Button
local invisBtn = Instance.new("TextButton")
invisBtn.Name = "InvisBtn"
invisBtn.Size = UDim2.new(1, 0, 0, 40)
invisBtn.Position = UDim2.new(0, 0, 0, 114)
invisBtn.BackgroundColor3 = Color3.fromRGB(100, 80, 200)
invisBtn.Text = "👻 Invisible: OFF"
invisBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
invisBtn.TextSize = 14
invisBtn.Font = Enum.Font.GothamBold
invisBtn.BorderSizePixel = 0
invisBtn.Parent = contentFrame

local invisBtnCorner = Instance.new("UICorner")
invisBtnCorner.CornerRadius = UDim.new(0, 7)
invisBtnCorner.Parent = invisBtn

-- Status Label
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0, 18)
statusLabel.Position = UDim2.new(0, 0, 1, -20)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Ready"
statusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
statusLabel.TextSize = 12
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextXAlignment = Enum.TextXAlignment.Center
statusLabel.Parent = contentFrame

-- Minimized Button (Initially Hidden)
local minimizedBtn = Instance.new("TextButton")
minimizedBtn.Name = "MinimizedBtn"
minimizedBtn.Size = UDim2.new(0, 30, 0, 30)
minimizedBtn.Position = UDim2.new(0, 20, 0, 20)
minimizedBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
minimizedBtn.Text = "⚡"
minimizedBtn.TextColor3 = Color3.fromRGB(255, 200, 50)
minimizedBtn.TextSize = 30
minimizedBtn.Font = Enum.Font.GothamBold
minimizedBtn.BorderSizePixel = 0
minimizedBtn.Visible = false
minimizedBtn.Parent = screenGui

local minimizedBtnCorner = Instance.new("UICorner")
minimizedBtnCorner.CornerRadius = UDim.new(1, 0)
minimizedBtnCorner.Parent = minimizedBtn

-- Variables
local invisEnabled = false
local originalTransparency = {}

-- Functions
local function updateStatus(text, color)
    statusLabel.Text = text
    statusLabel.TextColor3 = color or Color3.fromRGB(150, 150, 150)
end

local function setWalkSpeed(speed)
    local character = player.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = speed
            speedLabel.Text = "WalkSpeed: " .. speed
            updateStatus("Speed updated to " .. speed, Color3.fromRGB(100, 255, 100))
        end
    end
end

local function toggleInvisible()
    local character = player.Character
    if not character then return end
    
    invisEnabled = not invisEnabled
    
    if invisEnabled then
        invisBtn.Text = "👻 Invisible: ON"
        invisBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 100)
        
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("Decal") then
                originalTransparency[part] = part.Transparency
                part.Transparency = 1
            end
            if part:IsA("Accessory") then
                local handle = part:FindFirstChild("Handle")
                if handle then
                    originalTransparency[handle] = handle.Transparency
                    handle.Transparency = 1
                end
            end
        end
        
        if character:FindFirstChild("Head") then
            local face = character.Head:FindFirstChild("face")
            if face then
                originalTransparency[face] = face.Transparency
                face.Transparency = 1
            end
        end
        
        updateStatus("Invisible mode activated", Color3.fromRGB(100, 255, 100))
    else
        invisBtn.Text = "👻 Invisible: OFF"
        invisBtn.BackgroundColor3 = Color3.fromRGB(100, 80, 200)
        
        for part, transparency in pairs(originalTransparency) do
            if part and part.Parent then
                part.Transparency = transparency
            end
        end
        originalTransparency = {}
        
        updateStatus("Invisible mode deactivated", Color3.fromRGB(255, 150, 100))
    end
end

-- Button Events
setSpeedBtn.MouseButton1Click:Connect(function()
    local speed = tonumber(speedInput.Text)
    if speed then
        setWalkSpeed(speed)
    else
        updateStatus("Invalid speed value!", Color3.fromRGB(255, 100, 100))
    end
end)

resetSpeedBtn.MouseButton1Click:Connect(function()
    speedInput.Text = "16"
    setWalkSpeed(16)
    updateStatus("Speed reset to normal", Color3.fromRGB(100, 255, 100))
end)

invisBtn.MouseButton1Click:Connect(function()
    toggleInvisible()
end)

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

minimizeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    minimizedBtn.Visible = true
end)

minimizedBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    minimizedBtn.Visible = false
end)

-- Dragging System
local dragging = false
local dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- Dragging for minimized button
local draggingMin = false
local dragInputMin, dragStartMin, startPosMin

local function updateMin(input)
    local delta = input.Position - dragStartMin
    minimizedBtn.Position = UDim2.new(startPosMin.X.Scale, startPosMin.X.Offset + delta.X, startPosMin.Y.Scale, startPosMin.Y.Offset + delta.Y)
end

minimizedBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingMin = true
        dragStartMin = input.Position
        startPosMin = minimizedBtn.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                draggingMin = false
            end
        end)
    end
end)

minimizedBtn.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInputMin = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInputMin and draggingMin then
        updateMin(input)
    end
end)

-- Hover Effects
local function addHoverEffect(button, normalColor, hoverColor)
    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = hoverColor
    end)
    
    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = normalColor
    end)
end

addHoverEffect(setSpeedBtn, Color3.fromRGB(80, 150, 255), Color3.fromRGB(100, 170, 255))
addHoverEffect(resetSpeedBtn, Color3.fromRGB(255, 150, 50), Color3.fromRGB(255, 170, 80))
addHoverEffect(invisBtn, Color3.fromRGB(100, 80, 200), Color3.fromRGB(120, 100, 220))
addHoverEffect(minimizeBtn, Color3.fromRGB(255, 200, 50), Color3.fromRGB(255, 220, 100))
addHoverEffect(closeBtn, Color3.fromRGB(220, 50, 50), Color3.fromRGB(240, 70, 70))
addHoverEffect(minimizedBtn, Color3.fromRGB(45, 45, 60), Color3.fromRGB(60, 60, 80))
