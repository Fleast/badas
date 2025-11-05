-- COMPACT ANTI LAG + FPS BOOSTER GUI
-- Modern Dark Theme with Sky Blue Stroke

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")

local LocalPlayer = Players.LocalPlayer

-- FPS Counter
local FPSCounter = {
    lastTime = tick(),
    frames = 0,
    currentFPS = 0
}

-- Settings
local BoostEnabled = false

-- Create GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AntiLagFPSBooster"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.CoreGui

-- Main Frame (Ukuran lebih kecil)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 240, 0, 200)
MainFrame.Position = UDim2.new(0.5, -120, 0.5, -100)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(100, 180, 255)
MainStroke.Thickness = 2
MainStroke.Parent = MainFrame

-- Header
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 45)
Header.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 12)
HeaderCorner.Parent = Header

local HeaderFix = Instance.new("Frame")
HeaderFix.Size = UDim2.new(1, 0, 0, 12)
HeaderFix.Position = UDim2.new(0, 0, 1, -12)
HeaderFix.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
HeaderFix.BorderSizePixel = 0
HeaderFix.Parent = Header

-- Title
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -75, 0.5, 0)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "SEIXTHER ANTI-LAG"
Title.TextColor3 = Color3.fromRGB(100, 180, 255)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

-- FPS Display
local FPSLabel = Instance.new("TextLabel")
FPSLabel.Name = "FPSLabel"
FPSLabel.Size = UDim2.new(1, -75, 0.5, 0)
FPSLabel.Position = UDim2.new(0, 12, 0.5, 0)
FPSLabel.BackgroundTransparency = 1
FPSLabel.Text = "FPS: 0"
FPSLabel.TextColor3 = Color3.fromRGB(100, 255, 150)
FPSLabel.TextSize = 13
FPSLabel.Font = Enum.Font.Gotham
FPSLabel.TextXAlignment = Enum.TextXAlignment.Left
FPSLabel.Parent = Header

-- Minimize Button
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Name = "MinimizeBtn"
MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
MinimizeBtn.Position = UDim2.new(1, -65, 0.5, -15)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.TextSize = 18
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.BorderSizePixel = 0
MinimizeBtn.Parent = Header

local MinimizeCorner = Instance.new("UICorner")
MinimizeCorner.CornerRadius = UDim.new(0, 8)
MinimizeCorner.Parent = MinimizeBtn

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -32, 0.5, -15)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 16
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.BorderSizePixel = 0
CloseBtn.Parent = Header

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseBtn

-- Content Frame
local Content = Instance.new("Frame")
Content.Name = "Content"
Content.Size = UDim2.new(1, -24, 1, -55)
Content.Position = UDim2.new(0, 12, 0, 50)
Content.BackgroundTransparency = 1
Content.Parent = MainFrame

-- Info Card
local InfoCard = Instance.new("Frame")
InfoCard.Name = "InfoCard"
InfoCard.Size = UDim2.new(1, 0, 0, 45)
InfoCard.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
InfoCard.BorderSizePixel = 0
InfoCard.Parent = Content

local InfoCorner = Instance.new("UICorner")
InfoCorner.CornerRadius = UDim.new(0, 8)
InfoCorner.Parent = InfoCard

local InfoStroke = Instance.new("UIStroke")
InfoStroke.Color = Color3.fromRGB(100, 180, 255)
InfoStroke.Thickness = 1
InfoStroke.Transparency = 0.5
InfoStroke.Parent = InfoCard

local InfoText = Instance.new("TextLabel")
InfoText.Size = UDim2.new(1, -16, 1, -8)
InfoText.Position = UDim2.new(0, 8, 0, 4)
InfoText.BackgroundTransparency = 1
InfoText.Text = "UNTUK MEMBALIKKAN GRAPHICS\nSILAHKAN UNTUK KLIK RE-JOIN\nMade By @muhmdilhan_"
InfoText.TextColor3 = Color3.fromRGB(180, 180, 200)
InfoText.TextSize = 11
InfoText.Font = Enum.Font.Gotham
InfoText.TextWrapped = true
InfoText.TextYAlignment = Enum.TextYAlignment.Top
InfoText.Parent = InfoCard

-- Apply Boost Button
local ApplyBtn = Instance.new("TextButton")
ApplyBtn.Name = "ApplyBtn"
ApplyBtn.Size = UDim2.new(1, 0, 0, 45)
ApplyBtn.Position = UDim2.new(0, 0, 0, 55)
ApplyBtn.BackgroundColor3 = Color3.fromRGB(100, 180, 255)
ApplyBtn.Text = "APPLY BOOST"
ApplyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ApplyBtn.TextSize = 15
ApplyBtn.Font = Enum.Font.GothamBold
ApplyBtn.BorderSizePixel = 0
ApplyBtn.Parent = Content

local ApplyCorner = Instance.new("UICorner")
ApplyCorner.CornerRadius = UDim.new(0, 10)
ApplyCorner.Parent = ApplyBtn

-- Status Indicator
local StatusIndicator = Instance.new("Frame")
StatusIndicator.Name = "StatusIndicator"
StatusIndicator.Size = UDim2.new(0, 8, 0, 8)
StatusIndicator.Position = UDim2.new(0, 10, 0.5, -4)
StatusIndicator.BackgroundColor3 = Color3.fromRGB(150, 150, 160)
StatusIndicator.BorderSizePixel = 0
StatusIndicator.Parent = ApplyBtn

local StatusCorner = Instance.new("UICorner")
StatusCorner.CornerRadius = UDim.new(1, 0)
StatusCorner.Parent = StatusIndicator

-- Rejoin Server Button
local RejoinBtn = Instance.new("TextButton")
RejoinBtn.Name = "RejoinBtn"
RejoinBtn.Size = UDim2.new(1, 0, 0, 38)
RejoinBtn.Position = UDim2.new(0, 0, 0, 108)
RejoinBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
RejoinBtn.Text = "REJOIN SERVER"
RejoinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RejoinBtn.TextSize = 13
RejoinBtn.Font = Enum.Font.GothamBold
RejoinBtn.BorderSizePixel = 0
RejoinBtn.Parent = Content

local RejoinCorner = Instance.new("UICorner")
RejoinCorner.CornerRadius = UDim.new(0, 10)
RejoinCorner.Parent = RejoinBtn

local RejoinStroke = Instance.new("UIStroke")
RejoinStroke.Color = Color3.fromRGB(100, 180, 255)
RejoinStroke.Thickness = 1
RejoinStroke.Transparency = 0.5
RejoinStroke.Parent = RejoinBtn

-- Minimized Button
local MinimizedBtn = Instance.new("TextButton")
MinimizedBtn.Name = "MinimizedBtn"
MinimizedBtn.Size = UDim2.new(0, 42, 0, 42)
MinimizedBtn.Position = UDim2.new(1, -70, 0, 20)
MinimizedBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
MinimizedBtn.Text = "⚡"
MinimizedBtn.TextSize = 24
MinimizedBtn.Font = Enum.Font.GothamBold
MinimizedBtn.BorderSizePixel = 0
MinimizedBtn.Visible = false
MinimizedBtn.Active = true
MinimizedBtn.Draggable = true
MinimizedBtn.Parent = ScreenGui

local MinimizedCorner = Instance.new("UICorner")
MinimizedCorner.CornerRadius = UDim.new(0, 12)
MinimizedCorner.Parent = MinimizedBtn

local MinimizedStroke = Instance.new("UIStroke")
MinimizedStroke.Color = Color3.fromRGB(100, 180, 255)
MinimizedStroke.Thickness = 2
MinimizedStroke.Parent = MinimizedBtn

-- ========================================
-- OPTIMIZATION FUNCTIONS
-- ========================================

local function removeTextures()
    for _, obj in pairs(Workspace:GetDescendants()) do
        pcall(function()
            if obj:IsA("Decal") or obj:IsA("Texture") then
                obj.Transparency = 1
            elseif obj:IsA("MeshPart") or obj:IsA("Part") then
                if obj.Material ~= Enum.Material.SmoothPlastic then
                    obj.Material = Enum.Material.SmoothPlastic
                end
            end
        end)
    end
end

local function removeEffects()
    for _, obj in pairs(Workspace:GetDescendants()) do
        pcall(function()
            if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or 
               obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then
                obj.Enabled = false
            end
        end)
    end
    
    for _, obj in pairs(Lighting:GetChildren()) do
        pcall(function()
            if obj:IsA("BloomEffect") or obj:IsA("BlurEffect") or obj:IsA("ColorCorrectionEffect") or
               obj:IsA("SunRaysEffect") or obj:IsA("DepthOfFieldEffect") then
                obj.Enabled = false
            end
        end)
    end
end

local function applyLowGraphics()
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level01
    
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9
    Lighting.Brightness = 2
    
    pcall(function()
        Lighting.Technology = Enum.Technology.Legacy
    end)
end

local function optimizeTerrain()
    local terrain = Workspace.Terrain
    
    terrain.WaterWaveSize = 0
    terrain.WaterWaveSpeed = 0
    terrain.WaterReflectance = 0
    terrain.WaterTransparency = 0
    terrain.Decoration = false
end

local function applyAllOptimizations()
    if BoostEnabled then
        ApplyBtn.Text = "ALREADY ACTIVE"
        task.wait(1)
        ApplyBtn.Text = "BOOST ACTIVE"
        return
    end
    
    ApplyBtn.Text = "BOOST ACTIVE"
    ApplyBtn.BackgroundColor3 = Color3.fromRGB(100, 255, 150)
    StatusIndicator.BackgroundColor3 = Color3.fromRGB(100, 255, 150)
    task.wait(0.1)
    
    removeTextures()
    removeEffects()
    applyLowGraphics()
    optimizeTerrain()
    
    BoostEnabled = true
    
    ApplyBtn.Text = "BOOST ACTIVE"
    ApplyBtn.BackgroundColor3 = Color3.fromRGB(100, 255, 150)
    StatusIndicator.BackgroundColor3 = Color3.fromRGB(100, 255, 150)
end

local function rejoinServer()
    RejoinBtn.Text = "REJOINING..."
    RejoinBtn.BackgroundColor3 = Color3.fromRGB(100, 180, 255)
    
    task.wait(0.5)
    
    local success, errorMsg = pcall(function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
    end)
    
    if not success then
        -- Fallback method
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end
end

-- ========================================
-- BUTTON HANDLERS
-- ========================================

-- Apply Boost Button
ApplyBtn.MouseButton1Click:Connect(function()
    applyAllOptimizations()
end)

-- Rejoin Server Button
RejoinBtn.MouseButton1Click:Connect(function()
    rejoinServer()
end)

-- Minimize/Maximize
local isMinimized = false
MinimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    MainFrame.Visible = not isMinimized
    MinimizedBtn.Visible = isMinimized
end)

MinimizedBtn.MouseButton1Click:Connect(function()
    isMinimized = false
    MainFrame.Visible = true
    MinimizedBtn.Visible = false
end)

-- Close button
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- ========================================
-- FPS COUNTER
-- ========================================

RunService.RenderStepped:Connect(function()
    FPSCounter.frames = FPSCounter.frames + 1
    
    local currentTime = tick()
    if currentTime - FPSCounter.lastTime >= 1 then
        FPSCounter.currentFPS = FPSCounter.frames
        FPSCounter.frames = 0
        FPSCounter.lastTime = currentTime
        
        FPSLabel.Text = string.format("FPS: %d", FPSCounter.currentFPS)
        
        if FPSCounter.currentFPS >= 60 then
            FPSLabel.TextColor3 = Color3.fromRGB(100, 255, 150)
        elseif FPSCounter.currentFPS >= 30 then
            FPSLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
        else
            FPSLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
    end
end)

-- ========================================
-- HOVER EFFECTS
-- ========================================

local function addHoverEffect(button, normalColor)
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(
                math.min(normalColor.R * 255 + 20, 255),
                math.min(normalColor.G * 255 + 20, 255),
                math.min(normalColor.B * 255 + 20, 255)
            )
        }):Play()
    end)
    
    button.MouseLeave:Connect(function()
        if not BoostEnabled or button ~= ApplyBtn then
            TweenService:Create(button, TweenInfo.new(0.2), {
                BackgroundColor3 = normalColor
            }):Play()
        end
    end)
end

addHoverEffect(ApplyBtn, Color3.fromRGB(100, 180, 255))
addHoverEffect(RejoinBtn, Color3.fromRGB(30, 30, 42))
addHoverEffect(CloseBtn, Color3.fromRGB(255, 70, 70))