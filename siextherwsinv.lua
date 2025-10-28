-- WalkSpeed GUI Script with Persistent Speed and Minimize
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Settings
local Settings = {
    CurrentSpeed = 16,
    DefaultSpeed = 16,
    Enabled = false
}

-- Create GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "WalkSpeedGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.CoreGui

-- Main Frame (Compact Size)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 220, 0, 190)
MainFrame.Position = UDim2.new(0.5, -110, 0.5, -95)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

-- Header
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 35)
Header.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 10)
HeaderCorner.Parent = Header

local HeaderFix = Instance.new("Frame")
HeaderFix.Size = UDim2.new(1, 0, 0, 10)
HeaderFix.Position = UDim2.new(0, 0, 1, -10)
HeaderFix.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
HeaderFix.BorderSizePixel = 0
HeaderFix.Parent = Header

-- Title
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -70, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "SIEXTHER SPEED"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 15
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

-- Minimize Button
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Name = "MinimizeBtn"
MinimizeBtn.Size = UDim2.new(0, 26, 0, 26)
MinimizeBtn.Position = UDim2.new(1, -60, 0.5, -13)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(100, 120, 200)
MinimizeBtn.Text = "—"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.TextSize = 16
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.BorderSizePixel = 0
MinimizeBtn.Parent = Header

local MinimizeCorner = Instance.new("UICorner")
MinimizeCorner.CornerRadius = UDim.new(0, 6)
MinimizeCorner.Parent = MinimizeBtn

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Size = UDim2.new(0, 26, 0, 26)
CloseBtn.Position = UDim2.new(1, -30, 0.5, -13)
CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 14
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.BorderSizePixel = 0
CloseBtn.Parent = Header

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

-- Minimized Button (Floating)
local MinimizedBtn = Instance.new("TextButton")
MinimizedBtn.Name = "MinimizedBtn"
MinimizedBtn.Size = UDim2.new(0, 35, 0, 35)
MinimizedBtn.Position = UDim2.new(1, -68, 0.5, -20)
MinimizedBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
MinimizedBtn.Text = "⚡"
MinimizedBtn.TextColor3 = Color3.fromRGB(255, 200, 100)
MinimizedBtn.TextSize = 20
MinimizedBtn.Font = Enum.Font.GothamBold
MinimizedBtn.BorderSizePixel = 0
MinimizedBtn.Visible = false
MinimizedBtn.Active = true
MinimizedBtn.Draggable = true
MinimizedBtn.Parent = ScreenGui

local MinimizedCorner = Instance.new("UICorner")
MinimizedCorner.CornerRadius = UDim.new(0, 8)
MinimizedCorner.Parent = MinimizedBtn

-- Add shadow effect to minimized button
local MinimizedShadow = Instance.new("Frame")
MinimizedShadow.Name = "Shadow"
MinimizedShadow.Size = UDim2.new(1, 6, 1, 6)
MinimizedShadow.Position = UDim2.new(0, -3, 0, -3)
MinimizedShadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MinimizedShadow.BackgroundTransparency = 0.5
MinimizedShadow.BorderSizePixel = 0
MinimizedShadow.ZIndex = 0
MinimizedShadow.Parent = MinimizedBtn

local ShadowCorner = Instance.new("UICorner")
ShadowCorner.CornerRadius = UDim.new(0, 8)
ShadowCorner.Parent = MinimizedShadow

-- Content Frame
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, -20, 1, -50)
ContentFrame.Position = UDim2.new(0, 10, 0, 40)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

-- Speed Label
local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Name = "SpeedLabel"
SpeedLabel.Size = UDim2.new(1, 0, 0, 20)
SpeedLabel.Position = UDim2.new(0, 0, 0, 5)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "SPEED: 16"
SpeedLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
SpeedLabel.TextSize = 13
SpeedLabel.Font = Enum.Font.GothamBold
SpeedLabel.Parent = ContentFrame

-- Speed Input Box
local SpeedInput = Instance.new("TextBox")
SpeedInput.Name = "SpeedInput"
SpeedInput.Size = UDim2.new(1, 0, 0, 35)
SpeedInput.Position = UDim2.new(0, 0, 0, 30)
SpeedInput.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
SpeedInput.Text = "16"
SpeedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedInput.TextSize = 14
SpeedInput.Font = Enum.Font.Gotham
SpeedInput.PlaceholderText = "Enter speed (1-500)"
SpeedInput.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
SpeedInput.BorderSizePixel = 0
SpeedInput.Parent = ContentFrame

local InputCorner = Instance.new("UICorner")
InputCorner.CornerRadius = UDim.new(0, 8)
InputCorner.Parent = SpeedInput

-- Apply Button
local ApplyBtn = Instance.new("TextButton")
ApplyBtn.Name = "ApplyBtn"
ApplyBtn.Size = UDim2.new(1, 0, 0, 35)
ApplyBtn.Position = UDim2.new(0, 0, 0, 72)
ApplyBtn.BackgroundColor3 = Color3.fromRGB(50, 180, 80)
ApplyBtn.Text = "APPLY SPEED"
ApplyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ApplyBtn.TextSize = 14
ApplyBtn.Font = Enum.Font.GothamBold
ApplyBtn.BorderSizePixel = 0
ApplyBtn.Parent = ContentFrame

local ApplyCorner = Instance.new("UICorner")
ApplyCorner.CornerRadius = UDim.new(0, 8)
ApplyCorner.Parent = ApplyBtn

-- Reset Button
local ResetBtn = Instance.new("TextButton")
ResetBtn.Name = "ResetBtn"
ResetBtn.Size = UDim2.new(1, 0, 0, 35)
ResetBtn.Position = UDim2.new(0, 0, 0, 115)
ResetBtn.BackgroundColor3 = Color3.fromRGB(220, 80, 50)
ResetBtn.Text = "RESET TO DEFAULT"
ResetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ResetBtn.TextSize = 13
ResetBtn.Font = Enum.Font.GothamBold
ResetBtn.BorderSizePixel = 0
ResetBtn.Parent = ContentFrame

local ResetCorner = Instance.new("UICorner")
ResetCorner.CornerRadius = UDim.new(0, 8)
ResetCorner.Parent = ResetBtn

-- Function to update walkspeed
local function updateWalkSpeed()
    local character = LocalPlayer.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = Settings.CurrentSpeed
        end
    end
end

-- Function to apply speed continuously
local speedConnection = nil
local function startSpeedLoop()
    if speedConnection then
        speedConnection:Disconnect()
    end
    
    speedConnection = RunService.Heartbeat:Connect(function()
        if Settings.Enabled then
            updateWalkSpeed()
        end
    end)
end

-- Minimize/Maximize Functions
local function minimizeGUI()
    MainFrame.Visible = false
    MinimizedBtn.Visible = true
end

local function maximizeGUI()
    MinimizedBtn.Visible = false
    MainFrame.Visible = true
end

-- Minimize Button Click
MinimizeBtn.MouseButton1Click:Connect(function()
    minimizeGUI()
    -- Visual feedback
    MinimizeBtn.BackgroundColor3 = Color3.fromRGB(80, 100, 180)
    wait(0.1)
    MinimizeBtn.BackgroundColor3 = Color3.fromRGB(100, 120, 200)
end)

-- Minimized Button Click (Restore)
MinimizedBtn.MouseButton1Click:Connect(function()
    maximizeGUI()
    -- Visual feedback
    MinimizedBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    wait(0.1)
    MinimizedBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
end)

-- Apply Button Click
ApplyBtn.MouseButton1Click:Connect(function()
    local inputText = SpeedInput.Text
    local speed = tonumber(inputText)
    
    if speed and speed >= 1 and speed <= 500 then
        Settings.CurrentSpeed = speed
        Settings.Enabled = true
        SpeedLabel.Text = "SPEED: " .. speed
        updateWalkSpeed()
        startSpeedLoop()
        
        -- Visual feedback
        ApplyBtn.BackgroundColor3 = Color3.fromRGB(30, 140, 60)
        wait(0.1)
        ApplyBtn.BackgroundColor3 = Color3.fromRGB(50, 180, 80)
    else
        -- Error feedback
        ApplyBtn.Text = "INVALID! (1-500)"
        ApplyBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
        wait(1)
        ApplyBtn.Text = "APPLY SPEED"
        ApplyBtn.BackgroundColor3 = Color3.fromRGB(50, 180, 80)
    end
end)

-- Reset Button Click
ResetBtn.MouseButton1Click:Connect(function()
    Settings.CurrentSpeed = Settings.DefaultSpeed
    Settings.Enabled = false
    SpeedInput.Text = tostring(Settings.DefaultSpeed)
    SpeedLabel.Text = "SPEED: " .. Settings.DefaultSpeed
    updateWalkSpeed()
    
    if speedConnection then
        speedConnection:Disconnect()
        speedConnection = nil
    end
    
    -- Visual feedback
    ResetBtn.BackgroundColor3 = Color3.fromRGB(180, 60, 40)
    wait(0.1)
    ResetBtn.BackgroundColor3 = Color3.fromRGB(220, 80, 50)
end)

-- Close Button Click
CloseBtn.MouseButton1Click:Connect(function()
    Settings.Enabled = false
    if speedConnection then
        speedConnection:Disconnect()
        speedConnection = nil
    end
    ScreenGui:Destroy()
end)

-- Handle character respawn
LocalPlayer.CharacterAdded:Connect(function(character)
    if Settings.Enabled then
        local humanoid = character:WaitForChild("Humanoid", 5)
        if humanoid then
            task.wait(0.1)
            updateWalkSpeed()
        end
    end
end)

-- Input validation
SpeedInput:GetPropertyChangedSignal("Text"):Connect(function()
    local text = SpeedInput.Text
    SpeedInput.Text = text:gsub("[^%d]", "")
end)

-- Enter key to apply
SpeedInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        ApplyBtn.MouseButton1Click:Fire()
    end
end)
