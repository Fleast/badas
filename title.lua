-- Custom Title RGB GUI Script
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- Variabel untuk title
local titleGui
local titleLabel
local rgbConnection
local rgbSpeed = 1
local hue = 0

-- Fungsi untuk membuat title di atas kepala
local function createTitle(text)
    -- Hapus title lama jika ada
    if titleGui then
        titleGui:Destroy()
    end
    
    -- Buat BillboardGui
    titleGui = Instance.new("BillboardGui")
    titleGui.Name = "CustomTitle"
    titleGui.Adornee = character:FindFirstChild("Head")
    titleGui.Size = UDim2.new(0, 200, 0, 50)
    titleGui.StudsOffset = Vector3.new(0, 2.5, 0)
    titleGui.AlwaysOnTop = true
    titleGui.Parent = character
    
    -- Buat TextLabel
    titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 1, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = text
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 20
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextStrokeTransparency = 0.5
    titleLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    titleLabel.Parent = titleGui
end

-- Fungsi untuk update RGB
local function startRGB()
    if rgbConnection then
        rgbConnection:Disconnect()
    end
    
    rgbConnection = RunService.Heartbeat:Connect(function(delta)
        if titleLabel then
            hue = (hue + (rgbSpeed * delta * 100)) % 360
            titleLabel.TextColor3 = Color3.fromHSV(hue / 360, 1, 1)
        end
    end)
end

-- Fungsi untuk stop RGB
local function stopRGB()
    if rgbConnection then
        rgbConnection:Disconnect()
        rgbConnection = nil
    end
end

-- Membuat GUI Control Panel
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CustomTitleGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Frame utama
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 300, 0, 180)
mainFrame.Position = UDim2.new(0.5, -150, 0.3, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
mainFrame.BackgroundTransparency = 0.15
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = mainFrame

-- Header
local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 30)
header.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
header.BackgroundTransparency = 0.15
header.BorderSizePixel = 0
header.Parent = mainFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 10)
headerCorner.Parent = header

local headerFix = Instance.new("Frame")
headerFix.Size = UDim2.new(1, 0, 0, 10)
headerFix.Position = UDim2.new(0, 0, 1, -10)
headerFix.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
headerFix.BackgroundTransparency = 0.15
headerFix.BorderSizePixel = 0
headerFix.Parent = header

-- Title
local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, -65, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "SIEXTHER CUSTOM TITLE"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 14
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

-- Button Minimize
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Name = "MinimizeBtn"
minimizeBtn.Size = UDim2.new(0, 25, 0, 22)
minimizeBtn.Position = UDim2.new(1, -54, 0, 4)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
minimizeBtn.BackgroundTransparency = 0.15
minimizeBtn.Text = "_"
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.TextSize = 16
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.Parent = header

local minimizeCorner = Instance.new("UICorner")
minimizeCorner.CornerRadius = UDim.new(0, 5)
minimizeCorner.Parent = minimizeBtn

-- Button Close
local closeBtn = Instance.new("TextButton")
closeBtn.Name = "CloseBtn"
closeBtn.Size = UDim2.new(0, 25, 0, 22)
closeBtn.Position = UDim2.new(1, -25, 0, 4)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.BackgroundTransparency = 0.15
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 14
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = header

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 5)
closeCorner.Parent = closeBtn

-- Content Frame
local contentFrame = Instance.new("Frame")
contentFrame.Name = "Content"
contentFrame.Size = UDim2.new(1, -20, 1, -40)
contentFrame.Position = UDim2.new(0, 10, 0, 35)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- Text Input Label
local inputLabel = Instance.new("TextLabel")
inputLabel.Size = UDim2.new(1, 0, 0, 20)
inputLabel.Position = UDim2.new(0, 0, 0, 0)
inputLabel.BackgroundTransparency = 1
inputLabel.Text = "Title Text:"
inputLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
inputLabel.TextSize = 13
inputLabel.Font = Enum.Font.GothamBold
inputLabel.TextXAlignment = Enum.TextXAlignment.Left
inputLabel.Parent = contentFrame

-- Text Input Box
local textInput = Instance.new("TextBox")
textInput.Name = "TextInput"
textInput.Size = UDim2.new(1, 0, 0, 32)
textInput.Position = UDim2.new(0, 0, 0, 22)
textInput.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
textInput.BackgroundTransparency = 0.15
textInput.BorderSizePixel = 0
textInput.Text = "HANN.SIEXTHED"
textInput.TextColor3 = Color3.fromRGB(255, 255, 255)
textInput.TextSize = 14
textInput.Font = Enum.Font.Gotham
textInput.PlaceholderText = "Enter your title..."
textInput.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
textInput.ClearTextOnFocus = false
textInput.Parent = contentFrame

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 6)
inputCorner.Parent = textInput

-- RGB Speed Label
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(1, 0, 0, 20)
speedLabel.Position = UDim2.new(0, 0, 0, 62)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "RGB Speed:"
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.TextSize = 13
speedLabel.Font = Enum.Font.GothamBold
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.Parent = contentFrame

-- Speed Buttons Container
local speedContainer = Instance.new("Frame")
speedContainer.Name = "SpeedContainer"
speedContainer.Size = UDim2.new(1, 0, 0, 28)
speedContainer.Position = UDim2.new(0, 0, 0, 84)
speedContainer.BackgroundTransparency = 1
speedContainer.Parent = contentFrame

-- Speed values
local speedValues = {
    {text = "Normal", value = 1},
    {text = "x2", value = 2},
    {text = "x5", value = 5},
    {text = "x10", value = 10},
    {text = "x50", value = 50}
}

local speedButtons = {}
local currentSpeedIndex = 1

-- Create speed buttons
for i, speedData in ipairs(speedValues) do
    local btn = Instance.new("TextButton")
    btn.Name = "SpeedBtn" .. i
    btn.Size = UDim2.new(0.18, 0, 1, 0)
    btn.Position = UDim2.new((i-1) * 0.204, 0, 0, 0)
    btn.BackgroundColor3 = i == 1 and Color3.fromRGB(50, 120, 200) or Color3.fromRGB(45, 45, 45)
    btn.BackgroundTransparency = 0.15
    btn.BorderSizePixel = 0
    btn.Text = speedData.text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamBold
    btn.Parent = speedContainer
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 5)
    btnCorner.Parent = btn
    
    speedButtons[i] = btn
    
    -- Button click event
    btn.MouseButton1Click:Connect(function()
        -- Reset all buttons
        for j, otherBtn in ipairs(speedButtons) do
            otherBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        end
        
        -- Highlight selected button
        btn.BackgroundColor3 = Color3.fromRGB(50, 120, 200)
        currentSpeedIndex = i
        rgbSpeed = speedData.value
    end)
    
    -- Hover effect
    btn.MouseEnter:Connect(function()
        if i ~= currentSpeedIndex then
            btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        end
    end)
    
    btn.MouseLeave:Connect(function()
        if i ~= currentSpeedIndex then
            btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        end
    end)
end

-- Apply Button
local applyBtn = Instance.new("TextButton")
applyBtn.Name = "ApplyBtn"
applyBtn.Size = UDim2.new(1, 0, 0, 35)
applyBtn.Position = UDim2.new(0, 0, 1, -35)
applyBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 100)
applyBtn.BackgroundTransparency = 0.15
applyBtn.Text = "APPLY TITLE"
applyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
applyBtn.TextSize = 14
applyBtn.Font = Enum.Font.GothamBold
applyBtn.Parent = contentFrame

local applyCorner = Instance.new("UICorner")
applyCorner.CornerRadius = UDim.new(0, 8)
applyCorner.Parent = applyBtn

-- Button Minimized
local minimizedBtn = Instance.new("TextButton")
minimizedBtn.Name = "MinimizedBtn"
minimizedBtn.Size = UDim2.new(0, 45, 0, 45)
minimizedBtn.Position = UDim2.new(0.5, -22, 0.3, 0)
minimizedBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
minimizedBtn.BackgroundTransparency = 0.15
minimizedBtn.Text = "👑"
minimizedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizedBtn.TextSize = 24
minimizedBtn.Font = Enum.Font.GothamBold
minimizedBtn.Visible = false
minimizedBtn.Active = true
minimizedBtn.Draggable = true
minimizedBtn.Parent = screenGui

local minimizedCorner2 = Instance.new("UICorner")
minimizedCorner2.CornerRadius = UDim.new(0, 22)
minimizedCorner2.Parent = minimizedBtn

-- Apply Button Event
applyBtn.MouseButton1Click:Connect(function()
    local titleText = textInput.Text
    if titleText ~= "" then
        createTitle(titleText)
        startRGB()
    end
end)

-- Close Button Event
closeBtn.MouseButton1Click:Connect(function()
    stopRGB()
    if titleGui then
        titleGui:Destroy()
    end
    mainFrame.Visible = false
    minimizedBtn.Visible = false
end)

-- Minimize/Maximize Events
minimizeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    minimizedBtn.Visible = true
end)

minimizedBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    minimizedBtn.Visible = false
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

addHoverEffect(applyBtn, Color3.fromRGB(50, 200, 100), Color3.fromRGB(70, 220, 120))
addHoverEffect(closeBtn, Color3.fromRGB(200, 50, 50), Color3.fromRGB(220, 70, 70))
addHoverEffect(minimizeBtn, Color3.fromRGB(50, 50, 50), Color3.fromRGB(70, 70, 70))
addHoverEffect(minimizedBtn, Color3.fromRGB(35, 35, 35), Color3.fromRGB(55, 55, 55))

-- Handle Character Respawn
player.CharacterAdded:Connect(function(char)
    character = char
    humanoidRootPart = char:WaitForChild("HumanoidRootPart")
    
    -- Reapply title jika ada
    if textInput.Text ~= "" then
        wait(1)
        createTitle(textInput.Text)
        startRGB()
    end
end)