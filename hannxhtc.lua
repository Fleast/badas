
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- ========== SETTINGS ==========
local Settings = {
    BringPartRadius = 100,
    BringPartSpeed = 200,
    UnanchorRadius = 500
}

-- ========== VARIABEL STATE ==========
local aktif = false
local character, humanoidRootPart, torso

-- Unanchor Variables
local folder, attachment1, koneksi1

-- BringPart Variables
local blackHoleActive = false
local DescendantAddedConnection
local NetworkConnection
local BringFolder, TargetPart, Attachment1

-- ========== CREATE GUI ==========
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SiextherChoticHan"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

-- Main Frame (Ukuran diperkecil dari 320x240 ke 280x200)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 280, 0, 200)
MainFrame.Position = UDim2.new(0.5, -140, 0.5, -100)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = MainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(70, 130, 255)
mainStroke.Thickness = 2
mainStroke.Parent = MainFrame

-- Navbar (Tinggi dikurangi dari 35 ke 30)
local Navbar = Instance.new("Frame")
Navbar.Size = UDim2.new(1, 0, 0, 30)
Navbar.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
Navbar.Parent = MainFrame

local navCorner = Instance.new("UICorner")
navCorner.CornerRadius = UDim.new(0, 10)
navCorner.Parent = Navbar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -65, 1, 0)
TitleLabel.Position = UDim2.new(0, 8, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "SIEXTHER CHAOTIC"
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 18
TitleLabel.TextColor3 = Color3.fromRGB(70, 130, 255)
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = Navbar

local TitleGradient = Instance.new("UIGradient")
TitleGradient.Parent = TitleLabel
TitleGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(0.3, Color3.fromRGB(70, 130, 255)),
    ColorSequenceKeypoint.new(0.6, Color3.fromRGB(70, 130, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
})
TitleGradient.Offset = Vector2.new(-1, 0)

task.spawn(function()
    while TitleLabel and TitleLabel.Parent do
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

-- Minimize Button (Ukuran dikurangi dari 28 ke 24)
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 24, 0, 24)
MinimizeBtn.Position = UDim2.new(1, -56, 0.5, -12)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
MinimizeBtn.Text = "–"
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextSize = 16
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.Parent = Navbar

local minimizeCorner = Instance.new("UICorner")
minimizeCorner.CornerRadius = UDim.new(0, 5)
minimizeCorner.Parent = MinimizeBtn

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 24, 0, 24)
CloseBtn.Position = UDim2.new(1, -28, 0.5, -12)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
CloseBtn.Text = "X"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 16
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Parent = Navbar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 5)
closeCorner.Parent = CloseBtn

-- Mini Frame (Ukuran dikurangi dari 50 ke 45)
local MiniFrame = Instance.new("TextButton")
MiniFrame.Size = UDim2.new(0, 41, 0, 41)
MiniFrame.Position = UDim2.new(0, 15, 0.5, -22)
MiniFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MiniFrame.Text = "SX"
MiniFrame.Font = Enum.Font.GothamBold
MiniFrame.TextSize = 25
MiniFrame.TextColor3 = Color3.fromRGB(70, 130, 255)
MiniFrame.Visible = false
MiniFrame.Active = true
MiniFrame.Draggable = true
MiniFrame.Parent = ScreenGui

-- Gradient Animation untuk Minimized Button
local MinimizedGradient = Instance.new("UIGradient")
MinimizedGradient.Parent = MiniFrame
MinimizedGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(0.3, Color3.fromRGB(70, 130, 255)),
    ColorSequenceKeypoint.new(0.6, Color3.fromRGB(70, 130, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
})
MinimizedGradient.Offset = Vector2.new(-1, 0)

task.spawn(function()
    while MiniFrame and MiniFrame.Parent do
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

local miniCorner = Instance.new("UICorner")
miniCorner.CornerRadius = UDim.new(0, 12)
miniCorner.Parent = MiniFrame

-- Content Container
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -16, 1, -40)
Content.Position = UDim2.new(0, 8, 0, 35)
Content.BackgroundTransparency = 1
Content.Parent = MainFrame

-- Toggle Button (Tinggi dikurangi dari 45 ke 38)
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(1, 0, 0, 38)
ToggleBtn.Position = UDim2.new(0, 0, 0, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
ToggleBtn.Text = "SIEXTHER | OFF"
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 14
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Parent = Content

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 7)
toggleCorner.Parent = ToggleBtn

-- Radius Label (Ukuran dikurangi dari 20 ke 18)
local RadiusLabel = Instance.new("TextLabel")
RadiusLabel.Size = UDim2.new(1, 0, 0, 18)
RadiusLabel.Position = UDim2.new(0, 0, 0, 48)
RadiusLabel.BackgroundTransparency = 1
RadiusLabel.Text = "RADIUS: 100"
RadiusLabel.Font = Enum.Font.GothamBold
RadiusLabel.TextSize = 11
RadiusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
RadiusLabel.TextXAlignment = Enum.TextXAlignment.Left
RadiusLabel.Parent = Content

-- Radius Slider Background
local RadiusSliderBg = Instance.new("Frame")
RadiusSliderBg.Size = UDim2.new(0.68, 0, 0, 18)
RadiusSliderBg.Position = UDim2.new(0, 0, 0, 68)
RadiusSliderBg.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
RadiusSliderBg.Parent = Content

local radiusSliderCorner = Instance.new("UICorner")
radiusSliderCorner.CornerRadius = UDim.new(1, 0)
radiusSliderCorner.Parent = RadiusSliderBg

-- Radius Slider Fill
local RadiusSliderFill = Instance.new("Frame")
RadiusSliderFill.Size = UDim2.new(0.5, 0, 1, 0)
RadiusSliderFill.BackgroundColor3 = Color3.fromRGB(70, 130, 255)
RadiusSliderFill.Parent = RadiusSliderBg

local radiusFillCorner = Instance.new("UICorner")
radiusFillCorner.CornerRadius = UDim.new(1, 0)
radiusFillCorner.Parent = RadiusSliderFill

-- Radius TextBox (Tinggi dikurangi dari 25 ke 22)
local RadiusTextBox = Instance.new("TextBox")
RadiusTextBox.Size = UDim2.new(0.25, 0, 0, 22)
RadiusTextBox.Position = UDim2.new(0.73, 0, 0, 64)
RadiusTextBox.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
RadiusTextBox.Text = "100"
RadiusTextBox.Font = Enum.Font.GothamBold
RadiusTextBox.TextSize = 11
RadiusTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
RadiusTextBox.Parent = Content

local radiusBoxCorner = Instance.new("UICorner")
radiusBoxCorner.CornerRadius = UDim.new(0, 5)
radiusBoxCorner.Parent = RadiusTextBox

-- Speed Label
local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size = UDim2.new(1, 0, 0, 18)
SpeedLabel.Position = UDim2.new(0, 0, 0, 96)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "SPEED: 200"
SpeedLabel.Font = Enum.Font.GothamBold
SpeedLabel.TextSize = 11
SpeedLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
SpeedLabel.Parent = Content

-- Speed Slider Background
local SpeedSliderBg = Instance.new("Frame")
SpeedSliderBg.Size = UDim2.new(0.68, 0, 0, 18)
SpeedSliderBg.Position = UDim2.new(0, 0, 0, 116)
SpeedSliderBg.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
SpeedSliderBg.Parent = Content

local speedSliderCorner = Instance.new("UICorner")
speedSliderCorner.CornerRadius = UDim.new(1, 0)
speedSliderCorner.Parent = SpeedSliderBg

-- Speed Slider Fill
local SpeedSliderFill = Instance.new("Frame")
SpeedSliderFill.Size = UDim2.new(0.5, 0, 1, 0)
SpeedSliderFill.BackgroundColor3 = Color3.fromRGB(70, 130, 255)
SpeedSliderFill.Parent = SpeedSliderBg

local speedFillCorner = Instance.new("UICorner")
speedFillCorner.CornerRadius = UDim.new(1, 0)
speedFillCorner.Parent = SpeedSliderFill

-- Speed TextBox
local SpeedTextBox = Instance.new("TextBox")
SpeedTextBox.Size = UDim2.new(0.25, 0, 0, 22)
SpeedTextBox.Position = UDim2.new(0.73, 0, 0, 112)
SpeedTextBox.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
SpeedTextBox.Text = "200"
SpeedTextBox.Font = Enum.Font.GothamBold
SpeedTextBox.TextSize = 11
SpeedTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedTextBox.Parent = Content

local speedBoxCorner = Instance.new("UICorner")
speedBoxCorner.CornerRadius = UDim.new(0, 5)
speedBoxCorner.Parent = SpeedTextBox

-- ========== FOOTER TEXT ==========
local FooterText1 = Instance.new("TextLabel")
FooterText1.Size = UDim2.new(1, 0, 0, 16)
FooterText1.Position = UDim2.new(0, 0, 1, -16)
FooterText1.BackgroundTransparency = 1
FooterText1.Text = "MADE WITH 🤍 SIEXTHER"
FooterText1.Font = Enum.Font.GothamBold
FooterText1.TextSize = 12
FooterText1.TextColor3 = Color3.fromRGB(255, 255, 255)
FooterText1.TextTransparency = 0
FooterText1.Parent = Content

local FooterGradient1 = Instance.new("UIGradient")
FooterGradient1.Parent = FooterText1
FooterGradient1.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(0.3, Color3.fromRGB(70, 130, 255)),
    ColorSequenceKeypoint.new(0.6, Color3.fromRGB(70, 130, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
})
FooterGradient1.Offset = Vector2.new(-1, 0)

local FooterText2 = Instance.new("TextLabel")
FooterText2.Size = UDim2.new(1, 0, 0, 16)
FooterText2.Position = UDim2.new(0, 0, 1, -16)
FooterText2.BackgroundTransparency = 1
FooterText2.Text = "DISARANKAN JANGAN UBAH RADIUS & SPEED"
FooterText2.Font = Enum.Font.GothamBold
FooterText2.TextSize = 12
FooterText2.TextColor3 = Color3.fromRGB(255, 255, 255)
FooterText2.TextTransparency = 1
FooterText2.Parent = Content

local FooterGradient2 = Instance.new("UIGradient")
FooterGradient2.Parent = FooterText2
FooterGradient2.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(0.3, Color3.fromRGB(70, 130, 255)),
    ColorSequenceKeypoint.new(0.6, Color3.fromRGB(70, 130, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
})
FooterGradient2.Offset = Vector2.new(-1, 0)

-- Footer Animation (Fade & Gradient)
task.spawn(function()
    while FooterText1 and FooterText1.Parent do
        -- Show Text 1
        TweenService:Create(FooterText1, TweenInfo.new(1, Enum.EasingStyle.Sine), {TextTransparency = 0}):Play()
        TweenService:Create(FooterText2, TweenInfo.new(1, Enum.EasingStyle.Sine), {TextTransparency = 1}):Play()
        
        -- Gradient animation for Text 1
        TweenService:Create(FooterGradient1, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Offset = Vector2.new(1, 0)
        }):Play()
        task.wait(3)
        
        TweenService:Create(FooterGradient1, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Offset = Vector2.new(-1, 0)
        }):Play()
        task.wait(2)
        
        -- Fade out Text 1
        TweenService:Create(FooterText1, TweenInfo.new(1, Enum.EasingStyle.Sine), {TextTransparency = 1}):Play()
        task.wait(1)
        
        -- Show Text 2
        TweenService:Create(FooterText2, TweenInfo.new(1, Enum.EasingStyle.Sine), {TextTransparency = 0}):Play()
        
        -- Gradient animation for Text 2
        TweenService:Create(FooterGradient2, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Offset = Vector2.new(1, 0)
        }):Play()
        task.wait(3)
        
        TweenService:Create(FooterGradient2, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Offset = Vector2.new(-1, 0)
        }):Play()
        task.wait(2)
        
        -- Fade out Text 2
        TweenService:Create(FooterText2, TweenInfo.new(1, Enum.EasingStyle.Sine), {TextTransparency = 1}):Play()
        task.wait(1)
    end
end)

-- ========== SLIDER LOGIC ==========
local function updateRadiusSlider(value)
    local percent = math.clamp((value - 10) / 490, 0, 1)
    RadiusSliderFill.Size = UDim2.new(percent, 0, 1, 0)
    RadiusLabel.Text = "RADIUS: " .. math.floor(value)
    RadiusTextBox.Text = tostring(math.floor(value))
    Settings.BringPartRadius = value
end

local function updateSpeedSlider(value)
    local percent = math.clamp((value - 50) / 450, 0, 1)
    SpeedSliderFill.Size = UDim2.new(percent, 0, 1, 0)
    SpeedLabel.Text = "SPEED: " .. math.floor(value)
    SpeedTextBox.Text = tostring(math.floor(value))
    Settings.BringPartSpeed = value
end

RadiusSliderBg.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        local relativeX = math.clamp((input.Position.X - RadiusSliderBg.AbsolutePosition.X) / RadiusSliderBg.AbsoluteSize.X, 0, 1)
        local value = 10 + (relativeX * 490)
        updateRadiusSlider(value)
    end
end)

SpeedSliderBg.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        local relativeX = math.clamp((input.Position.X - SpeedSliderBg.AbsolutePosition.X) / SpeedSliderBg.AbsoluteSize.X, 0, 1)
        local value = 50 + (relativeX * 450)
        updateSpeedSlider(value)
    end
end)

RadiusTextBox.FocusLost:Connect(function()
    local value = tonumber(RadiusTextBox.Text) or 100
    value = math.clamp(value, 10, 500)
    updateRadiusSlider(value)
end)

SpeedTextBox.FocusLost:Connect(function()
    local value = tonumber(SpeedTextBox.Text) or 200
    value = math.clamp(value, 50, 500)
    updateSpeedSlider(value)
end)

-- ========== UNANCHOR FUNCTIONS ==========
local function scanParts()
    local parts = {}
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if not root then return parts end

    for _, part in pairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") 
        and not part.Anchored 
        and not part:IsDescendantOf(character) then
            local dist = (part.Position - root.Position).Magnitude
            if dist <= Settings.UnanchorRadius then
                table.insert(parts, part)
            end
        end
    end
    return parts
end

local function applyForce(part)
    if not part or not part.Parent then return end
    part.CanCollide = false

    for _, x in next, part:GetChildren() do
        if x:IsA("BodyAngularVelocity") or x:IsA("BodyForce") or x:IsA("BodyGyro") 
        or x:IsA("BodyPosition") or x:IsA("BodyThrust") or x:IsA("BodyVelocity")
        or x:IsA("RocketPropulsion") then
            x:Destroy()
        end
    end

    if not part:FindFirstChildOfClass("Torque") then
        local torque = Instance.new("Torque", part)
        torque.Torque = Vector3.new(100000,100000,100000)
        local align = Instance.new("AlignPosition", part)
        local at2 = Instance.new("Attachment", part)
        torque.Attachment0 = at2
        align.MaxForce = 9e15
        align.MaxVelocity = math.huge
        align.Responsiveness = 200
        align.Attachment0 = at2
        if attachment1 then
            align.Attachment1 = attachment1
        end
    end

    if attachment1 then
        local dist = (part.Position - attachment1.WorldPosition).Magnitude
        if dist <= Settings.UnanchorRadius then
            local arah = (attachment1.WorldPosition - part.Position).Unit
            part.AssemblyLinearVelocity = arah * 200
        end
    end
end

local function mulaiUnanchor()
    folder = Instance.new("Folder", workspace)
    local part = Instance.new("Part", folder)
    part.Anchored = true
    part.CanCollide = false
    part.Transparency = 1
    attachment1 = Instance.new("Attachment", part)

    task.spawn(function()
        settings().Physics.AllowSleep = false
        while aktif and task.wait() do
            for _, pl in next, game.Players:GetPlayers() do
                if pl ~= LocalPlayer then
                    pl.MaximumSimulationRadius = 0
                    sethiddenproperty(pl, "SimulationRadius", 0)
                end
            end
            LocalPlayer.MaximumSimulationRadius = math.pow(math.huge, math.huge)
            setsimulationradius(math.huge)
        end
    end)

    koneksi1 = RunService.Stepped:Connect(function()
        local list = scanParts()
        for _, v in pairs(list) do
            applyForce(v)
        end
    end)
end

local function stopUnanchor()
    if koneksi1 then koneksi1:Disconnect() end
    if folder then folder:Destroy() end
    folder, attachment1 = nil, nil
end

-- ========== BRINGPART FUNCTIONS ==========
if not getgenv().Network then
    getgenv().Network = {
        BaseParts = {},
        Velocity = Vector3.new(14.46, 14.46, 14.46)
    }

    function Network.RetainPart(part)
        if part:IsA("BasePart") and part:IsDescendantOf(Workspace) then
            table.insert(Network.BaseParts, part)
            part.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0)
            part.CanCollide = false
        end
    end
end

local function EnableNetwork()
    if NetworkConnection then return end
    NetworkConnection = RunService.Heartbeat:Connect(function()
        pcall(function()
            sethiddenproperty(LocalPlayer, "SimulationRadius", math.huge)
        end)
    end)
end

local function DisableNetwork()
    if NetworkConnection then
        NetworkConnection:Disconnect()
        NetworkConnection = nil
    end
end

local function ForcePart(v)
    if v:IsA("BasePart") 
    and not v.Anchored 
    and not v.Parent:FindFirstChildOfClass("Humanoid") 
    and not v.Parent:FindFirstChild("Head") 
    and v.Name ~= "Handle" then

        for _, x in ipairs(v:GetChildren()) do
            if x:IsA("BodyMover") or x:IsA("RocketPropulsion") then
                x:Destroy()
            end
        end

        if v:FindFirstChild("Attachment") then v:FindFirstChild("Attachment"):Destroy() end
        if v:FindFirstChild("AlignPosition") then v:FindFirstChild("AlignPosition"):Destroy() end
        if v:FindFirstChild("Torque") then v:FindFirstChild("Torque"):Destroy() end

        v.CanCollide = false
        local Torque = Instance.new("Torque", v)
        Torque.Torque = Vector3.new(100000, 100000, 100000)
        local AlignPosition = Instance.new("AlignPosition", v)
        local Attachment2 = Instance.new("Attachment", v)
        Torque.Attachment0 = Attachment2
        AlignPosition.MaxForce = math.huge
        AlignPosition.MaxVelocity = math.huge
        AlignPosition.Responsiveness = Settings.BringPartSpeed
        AlignPosition.Attachment0 = Attachment2
        AlignPosition.Attachment1 = Attachment1
    end
end

local function OneTimeUnanchor()
    if getgenv().UnanchorCooldown then return end
    getgenv().UnanchorCooldown = true

    task.spawn(function()
        local startTime = tick()

        while tick() - startTime < 1 do
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj:IsA("RopeConstraint") then
                    local part0 = obj.Attachment0 and obj.Attachment0.Parent
                    local part1 = obj.Attachment1 and obj.Attachment1.Parent
                    pcall(function() obj:Destroy() end)
                    if part0 and part0:IsA("BasePart") then part0.Anchored = false end
                    if part1 and part1:IsA("BasePart") then part1.Anchored = false end
                end
            end

            for _, part in pairs(Workspace:GetDescendants()) do
                if part:IsA("BasePart") and not part.Anchored then
                    part.AssemblyLinearVelocity = Vector3.new(
                        math.random(-50, 50),
                        math.random(20, 100),
                        math.random(-50, 50)
                    )
                end
            end

            task.wait(0.2)
        end

        getgenv().UnanchorCooldown = false
    end)
end

local function GetAllPartsRecursive(parent)
    local parts = {}
    for _, obj in ipairs(parent:GetChildren()) do
        if obj:IsA("BasePart") then
            table.insert(parts, obj)
        elseif obj:IsA("Folder") or obj:IsA("Model") then
            for _, childPart in ipairs(GetAllPartsRecursive(obj)) do
                table.insert(parts, childPart)
            end
        end
    end
    return parts
end

local function mulaBringPart()
    BringFolder = Instance.new("Folder", Workspace)
    BringFolder.Name = "BringPartFolder"
    TargetPart = Instance.new("Part", BringFolder)
    TargetPart.Anchored = true
    TargetPart.CanCollide = false
    TargetPart.Transparency = 1
    Attachment1 = Instance.new("Attachment", TargetPart)

    EnableNetwork()
    OneTimeUnanchor()

    for _, v in ipairs(GetAllPartsRecursive(Workspace)) do
        local dist = (v.Position - torso.Position).Magnitude
        if dist <= Settings.BringPartRadius then
            ForcePart(v)
        end
    end

    DescendantAddedConnection = Workspace.DescendantAdded:Connect(function(v)
        if blackHoleActive and v:IsA("BasePart") then
            local dist = (v.Position - torso.Position).Magnitude
            if dist <= Settings.BringPartRadius then
                ForcePart(v)
            end
        end
    end)

    task.spawn(function()
        while blackHoleActive and RunService.RenderStepped:Wait() do
            if torso then
                Attachment1.WorldCFrame = torso.CFrame
            end
        end
    end)
end

local function stopBringPart()
    DisableNetwork()
    if DescendantAddedConnection then
        DescendantAddedConnection:Disconnect()
        DescendantAddedConnection = nil
    end
    if BringFolder then
        BringFolder:Destroy()
        BringFolder = nil
    end
end

-- ========== TOGGLE BUTTON ==========
ToggleBtn.MouseButton1Click:Connect(function()
    aktif = not aktif
    blackHoleActive = aktif

    character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    torso = character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")

    if aktif then
        ToggleBtn.Text = "SIEXTHER | AKTIF"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 255)
        
        mulaiUnanchor()
        mulaBringPart()
    else
        ToggleBtn.Text = "SIEXTHER | OFF"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
        
        stopUnanchor()
        stopBringPart()
    end
end)

-- ========== WINDOW CONTROLS ==========
CloseBtn.MouseButton1Click:Connect(function()
    local tween = TweenService:Create(MainFrame, TweenInfo.new(0.2), {Size = UDim2.new(0, 0, 0, 0)})
    tween:Play()
    tween.Completed:Wait()
    ScreenGui:Destroy()
end)

MinimizeBtn.MouseButton1Click:Connect(function()
    local tween = TweenService:Create(MainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 0, 0, 0)})
    tween:Play()
    tween.Completed:Connect(function()
        MainFrame.Visible = false
        MiniFrame.Visible = true
    end)
end)

MiniFrame.MouseButton1Click:Connect(function()
    MiniFrame.Visible = false
    MainFrame.Visible = true
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    local tween = TweenService:Create(MainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 280, 0, 200)})
    tween:Play()
end)

-- ========== CHARACTER RESPAWN ==========
LocalPlayer.CharacterAdded:Connect(function(newChar)
    if aktif then
        aktif = false
        blackHoleActive = false
        stopUnanchor()
        stopBringPart()
        ToggleBtn.Text = "SIEXTHER | OFF"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    end
end)