--🔥 Siexther BlackHole (Material Dark UI) 🔥

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

local angle = 1
local radius = 10
local blackHoleActive = false

-- Player Setup
local function setupPlayer()
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    local Folder = Instance.new("Folder", Workspace)
    Folder.Name = "SiextherBlackHole"
    local Part = Instance.new("Part", Folder)
    local Attachment1 = Instance.new("Attachment", Part)
    Part.Anchored = true
    Part.CanCollide = false
    Part.Transparency = 1

    return humanoidRootPart, Attachment1
end

local humanoidRootPart, Attachment1 = setupPlayer()

-- Network Control
if not getgenv().Network then
    getgenv().Network = {
        BaseParts = {},
        Velocity = Vector3.new(14.46, 14.46, 14.46)
    }

    Network.RetainPart = function(part)
        if typeof(part) == "Instance" and part:IsA("BasePart") and part:IsDescendantOf(Workspace) then
            table.insert(Network.BaseParts, part)
            part.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0)
            part.CanCollide = false
        end
    end

    local function EnablePartControl()
        LocalPlayer.ReplicationFocus = Workspace
        RunService.Heartbeat:Connect(function()
            sethiddenproperty(LocalPlayer, "SimulationRadius", math.huge)
            for _, part in pairs(Network.BaseParts) do
                if part:IsDescendantOf(Workspace) then
                    part.Velocity = Network.Velocity
                end
            end
        end)
    end

    EnablePartControl()
end

-- BlackHole Force Function
local function ForcePart(v)
    if v:IsA("Part") and not v.Anchored and not v.Parent:FindFirstChild("Humanoid") and not v.Parent:FindFirstChild("Head") and v.Name ~= "Handle" then
        for _, x in next, v:GetChildren() do
            if x:IsA("BodyAngularVelocity") or x:IsA("BodyForce") or x:IsA("BodyGyro") or x:IsA("BodyPosition") or x:IsA("BodyThrust") or x:IsA("BodyVelocity") or x:IsA("RocketPropulsion") then
                x:Destroy()
            end
        end
        v.CanCollide = false
        
        local Torque = Instance.new("Torque", v)
        Torque.Torque = Vector3.new(1000000, 1000000, 1000000)
        local AlignPosition = Instance.new("AlignPosition", v)
        local Attachment2 = Instance.new("Attachment", v)
        Torque.Attachment0 = Attachment2
        AlignPosition.MaxForce = math.huge
        AlignPosition.MaxVelocity = math.huge
        AlignPosition.Responsiveness = 500
        AlignPosition.Attachment0 = Attachment2
        AlignPosition.Attachment1 = Attachment1
    end
end

---------------------------------------------------------------------
-- Toggle Blackhole (dengan update warna tombol)
---------------------------------------------------------------------
local ToggleButton

local function updateToggleColor()
    if blackHoleActive then
        ToggleButton.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
        ToggleButton.Text = "Blackhole: ON"
    else
        ToggleButton.BackgroundColor3 = Color3.fromRGB(44, 44, 44)
        ToggleButton.Text = "Blackhole: OFF"
    end
end

local function toggleBlackHole()
    blackHoleActive = not blackHoleActive
    updateToggleColor()
    
    if blackHoleActive then
        for _, v in next, Workspace:GetDescendants() do
            ForcePart(v)
        end

        Workspace.DescendantAdded:Connect(function(v)
            if blackHoleActive then
                ForcePart(v)
            end
        end)

        spawn(function()
            while blackHoleActive and RunService.RenderStepped:Wait() do
                angle = angle + math.rad(2)
                local offsetX = math.cos(angle) * radius
                local offsetZ = math.sin(angle) * radius
                Attachment1.WorldCFrame = humanoidRootPart.CFrame * CFrame.new(offsetX, 0, offsetZ)
            end
        end)
    else
        Attachment1.WorldCFrame = CFrame.new(0, -1000, 0)
    end
end

LocalPlayer.CharacterAdded:Connect(function()
    humanoidRootPart, Attachment1 = setupPlayer()
    if blackHoleActive then
        toggleBlackHole()
    end
end)

---------------------------------------------------------------------
-- 🧱 Custom Material Dark UI (tema dark + sedikit transparan)
---------------------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "SiextherBlackHoleUI"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 300, 0, 170)
Frame.Position = UDim2.new(0.36, 0, 0.28, 0)
Frame.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
Frame.BackgroundTransparency = 0.18
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.Name = "MainFrame"

local UICorner = Instance.new("UICorner", Frame)
UICorner.CornerRadius = UDim.new(0, 10)

local TopBar = Instance.new("Frame", Frame)
TopBar.Size = UDim2.new(1, 0, 0, 36)
TopBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TopBar.BackgroundTransparency = 0.12
TopBar.BorderSizePixel = 0
local TopBarCorner = Instance.new("UICorner", TopBar)
TopBarCorner.CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(1, -70, 1, 0)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "🔥 Siexther BlackHole 🔥"
Title.Font = Enum.Font.GothamBold
Title.TextColor3 = Color3.fromRGB(240, 240, 240)
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left

-- ✖ Close Button
local Close = Instance.new("TextButton", TopBar)
Close.Size = UDim2.new(0, 28, 0, 28)
Close.Position = UDim2.new(1, -34, 0, 4)
Close.Text = "✖"
Close.BackgroundColor3 = Color3.fromRGB(70, 18, 18)
Close.TextColor3 = Color3.fromRGB(255, 255, 255)
Close.Font = Enum.Font.GothamBold
Close.TextSize = 18
local CloseCorner = Instance.new("UICorner", Close)
CloseCorner.CornerRadius = UDim.new(0, 6)
Close.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- ➖ Minimize Button (di kiri tombol ✖)
local Minimize = Instance.new("TextButton", TopBar)
Minimize.Size = UDim2.new(0, 28, 0, 28)
Minimize.Position = UDim2.new(1, -68, 0, 4)
Minimize.Text = "–"
Minimize.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Minimize.TextColor3 = Color3.fromRGB(255, 255, 255)
Minimize.Font = Enum.Font.GothamBold
Minimize.TextSize = 18
local MinCorner = Instance.new("UICorner", Minimize)
MinCorner.CornerRadius = UDim.new(0, 6)

local minimized = false
local Content = Instance.new("Frame", Frame)
Content.Size = UDim2.new(1, 0, 1, -36)
Content.Position = UDim2.new(0, 0, 0, 36)
Content.BackgroundTransparency = 1

Minimize.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        Content.Visible = false
        Frame.Size = UDim2.new(0, 300, 0, 40)
    else
        Content.Visible = true
        Frame.Size = UDim2.new(0, 300, 0, 170)
    end
end)

-- Toggle Button
ToggleButton = Instance.new("TextButton", Content)
ToggleButton.Size = UDim2.new(0.92, 0, 0, 38)
ToggleButton.Position = UDim2.new(0.04, 0, 0.06, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(44, 44, 44)
ToggleButton.BackgroundTransparency = 0.06
ToggleButton.TextColor3 = Color3.fromRGB(245, 245, 245)
ToggleButton.Font = Enum.Font.Gotham
ToggleButton.TextSize = 16
local ToggleCorner = Instance.new("UICorner", ToggleButton)
ToggleCorner.CornerRadius = UDim.new(0, 8)
ToggleButton.MouseButton1Click:Connect(toggleBlackHole)
updateToggleColor()

-- Radius Slider
local SliderLabel = Instance.new("TextLabel", Content)
SliderLabel.Text = "Radius: " .. radius
SliderLabel.Size = UDim2.new(0.5, 0, 0, 24)
SliderLabel.Position = UDim2.new(0.04, 0, 0.37, 0)
SliderLabel.BackgroundTransparency = 1
SliderLabel.Font = Enum.Font.Gotham
SliderLabel.TextColor3 = Color3.fromRGB(205, 205, 205)
SliderLabel.TextSize = 14
SliderLabel.TextXAlignment = Enum.TextXAlignment.Left

local SliderBar = Instance.new("Frame", Content)
SliderBar.Size = UDim2.new(0.92, 0, 0, 28)
SliderBar.Position = UDim2.new(0.04, 0, 0.54, 0)
SliderBar.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
SliderBar.BackgroundTransparency = 0.06
local SliderBarCorner = Instance.new("UICorner", SliderBar)
SliderBarCorner.CornerRadius = UDim.new(0, 6)

local Decrease = Instance.new("TextButton", SliderBar)
Decrease.Size = UDim2.new(0, 34, 1, -4)
Decrease.Position = UDim2.new(0, 6, 0, 2)
Decrease.Text = "–"
Decrease.Font = Enum.Font.Gotham
Decrease.TextSize = 20
Decrease.TextColor3 = Color3.fromRGB(230, 230, 230)
Decrease.BackgroundTransparency = 1

local Increase = Instance.new("TextButton", SliderBar)
Increase.Size = UDim2.new(0, 34, 1, -4)
Increase.Position = UDim2.new(1, -40, 0, 2)
Increase.Text = "+"
Increase.Font = Enum.Font.Gotham
Increase.TextSize = 20
Increase.TextColor3 = Color3.fromRGB(230, 230, 230)
Increase.BackgroundTransparency = 1

local Fill = Instance.new("Frame", SliderBar)
Fill.Size = UDim2.new(math.clamp(radius / 100, 0.03, 1), 0, 0.7, 0)
Fill.Position = UDim2.new(0.15, 0, 0.15, 0)
Fill.BackgroundColor3 = Color3.fromRGB(96, 125, 139)
local FillCorner = Instance.new("UICorner", Fill)
FillCorner.CornerRadius = UDim.new(0, 6)

Increase.MouseButton1Click:Connect(function()
    radius = math.clamp(radius + 5, 1, 100)
    SliderLabel.Text = "Radius: " .. radius
    Fill.Size = UDim2.new(math.clamp(radius / 100, 0.03, 1), 0, 0.7, 0)
end)

Decrease.MouseButton1Click:Connect(function()
    radius = math.clamp(radius - 5, 1, 100)
    SliderLabel.Text = "Radius: " .. radius
    Fill.Size = UDim2.new(math.clamp(radius / 100, 0.03, 1), 0, 0.7, 0)
end)

local SliderBtn = Instance.new("TextButton", Content)
SliderBtn.Size = UDim2.new(0.92, 0, 0, 22)
SliderBtn.Position = UDim2.new(0.04, 0, 0.78, 0)
SliderBtn.BackgroundTransparency = 1
SliderBtn.Text = "HANN.SIEXTHER"
SliderBtn.Font = Enum.Font.Gotham
SliderBtn.TextSize = 12
SliderBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
SliderBtn.MouseButton1Click:Connect(function()
    radius = math.clamp(radius + 5, 1, 100)
    SliderLabel.Text = "Radius: " .. radius
    Fill.Size = UDim2.new(math.clamp(radius / 100, 0.03, 1), 0, 0.7, 0)
end)

---------------------------------------------------------------------
-- Jalankan blackhole otomatis
---------------------------------------------------------------------
toggleBlackHole()
