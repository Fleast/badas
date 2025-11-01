local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local player = Players.LocalPlayer

local oldGui = PlayerGui:FindFirstChild("LoadingScreen")
if oldGui then
    oldGui:Destroy()
end

-- [[ BARU ]] Array random greeting messages
local greetingMessages = {
    "Have a nice day✨",
    "Are you okay?",
    "How's ur day??",
    "Im here for you",
    "Always be happy🤍"
}

-- [[ BARU ]] Pilih random greeting
local randomGreeting = greetingMessages[math.random(1, #greetingMessages)]

-- 1. Membuat IlhanSiextherls
local IlhanSiextherls = Instance.new("ScreenGui")
IlhanSiextherls.Name = "LoadingScreen"
IlhanSiextherls.ResetOnSpawn = false
IlhanSiextherls.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
IlhanSiextherls.Parent = PlayerGui

-- 2. Frame Utama
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 450, 0, 250)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.Position = UDim2.new(0.5, 0, 0.42, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BackgroundTransparency = 0.2
mainFrame.ClipsDescendants = false
mainFrame.Parent = IlhanSiextherls

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

-- 3. Avatar Player
local avatarFrame = Instance.new("Frame")
avatarFrame.Name = "AvatarFrame"
avatarFrame.Size = UDim2.new(0, 70, 0, 70)
avatarFrame.Position = UDim2.new(0.5, 0, 0.23, 0)
avatarFrame.AnchorPoint = Vector2.new(0.5, 0.5)
avatarFrame.BackgroundTransparency = 1
avatarFrame.Parent = mainFrame

local avatar = Instance.new("ImageLabel")
avatar.Name = "Avatar"
avatar.Size = UDim2.new(1, 0, 1, 0)
avatar.BackgroundTransparency = 1
avatar.Image = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
avatar.Parent = avatarFrame

local avatarCorner = Instance.new("UICorner")
avatarCorner.CornerRadius = UDim.new(1, 0)
avatarCorner.Parent = avatar

-- 4. Teks Judul
local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0.5, 0, 0.45, 0)
title.AnchorPoint = Vector2.new(0.5, 0.5)
title.Text = "HANN.SIEXTHER"
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 24
title.BackgroundTransparency = 1
title.Parent = mainFrame

-- 5. Teks Sambutan Line 1
local welcomeText1 = Instance.new("TextLabel")
welcomeText1.Name = "WelcomeText1"
welcomeText1.Size = UDim2.new(1, -40, 0, 20)
welcomeText1.Position = UDim2.new(0.5, 0, 0.58, 0)
welcomeText1.AnchorPoint = Vector2.new(0.5, 0.5)
welcomeText1.Text = ""
welcomeText1.Font = Enum.Font.Gotham
welcomeText1.TextColor3 = Color3.fromRGB(200, 200, 200)
welcomeText1.TextSize = 16
welcomeText1.TextWrapped = true
welcomeText1.BackgroundTransparency = 1
welcomeText1.Parent = mainFrame

-- 6. Teks Sambutan Line 2
local welcomeText2 = Instance.new("TextLabel")
welcomeText2.Name = "WelcomeText2"
welcomeText2.Size = UDim2.new(1, -40, 0, 20)
welcomeText2.Position = UDim2.new(0.5, 0, 0.66, 0)
welcomeText2.AnchorPoint = Vector2.new(0.5, 0.5)
welcomeText2.Text = ""
welcomeText2.Font = Enum.Font.Gotham
welcomeText2.TextColor3 = Color3.fromRGB(200, 200, 200)
welcomeText2.TextSize = 16
welcomeText2.TextWrapped = true
welcomeText2.BackgroundTransparency = 1
welcomeText2.Parent = mainFrame

-- 7. Teks Status
local statusText = Instance.new("TextLabel")
statusText.Name = "StatusText"
statusText.Size = UDim2.new(1, -40, 0, 20)
statusText.Position = UDim2.new(0.5, 0, 0.77, 0)
statusText.AnchorPoint = Vector2.new(0.5, 0.5)
statusText.Text = "Initializing..."
statusText.Font = Enum.Font.Gotham
statusText.TextColor3 = Color3.fromRGB(220, 220, 220)
statusText.TextSize = 14
statusText.BackgroundTransparency = 1
statusText.Parent = mainFrame

-- 8. Progress Bar (Latar Belakang)
local barBg = Instance.new("Frame")
barBg.Name = "BarBackground"
barBg.Size = UDim2.new(1, -40, 0, 15)
barBg.Position = UDim2.new(0.5, 0, 0.87, 0)
barBg.AnchorPoint = Vector2.new(0.5, 0.5)
barBg.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
barBg.BackgroundTransparency = 0.5
barBg.Parent = mainFrame

local barBgCorner = Instance.new("UICorner")
barBgCorner.CornerRadius = UDim.new(1, 0)
barBgCorner.Parent = barBg

-- 9. Progress Bar Fill
local barFill = Instance.new("Frame")
barFill.Name = "BarFill"
barFill.Size = UDim2.new(0, 0, 1, 0)
barFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
barFill.Parent = barBg

local barFillCorner = Instance.new("UICorner")
barFillCorner.CornerRadius = UDim.new(1, 0)
barFillCorner.Parent = barFill

-- ✅ GRADIENT DENGAN ANIMASI (Biru Dominan di Kiri, Putih di Kanan)
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 144, 255)),      -- Biru tua di kiri
    ColorSequenceKeypoint.new(0.3, Color3.fromRGB(70, 170, 255)),    -- Biru sedang
    ColorSequenceKeypoint.new(0.7, Color3.fromRGB(135, 206, 250)),   -- Biru muda
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))      -- Putih di kanan
}
gradient.Rotation = 0  -- Horizontal gradient
gradient.Offset = Vector2.new(-1, 0)  -- Start position
gradient.Parent = barFill

-- ✅ ANIMASI GRADIENT LOOP (Kiri-Kanan)
task.spawn(function()
    while barFill and barFill.Parent do
        -- Gerak ke kanan (putih -> biru)
        local toRight = TweenService:Create(
            gradient,
            TweenInfo.new(1.5, Enum.EasingStyle.Linear),
            {Offset = Vector2.new(1, 0)}
        )
        toRight:Play()
        toRight.Completed:Wait()
        
        -- Gerak ke kiri (biru -> putih)
        local toLeft = TweenService:Create(
            gradient,
            TweenInfo.new(1.5, Enum.EasingStyle.Linear),
            {Offset = Vector2.new(-1, 0)}
        )
        toLeft:Play()
        toLeft.Completed:Wait()
    end
end)

-- 10. Teks Persentase
local percentText = Instance.new("TextLabel")
percentText.Name = "PercentText"
percentText.Size = UDim2.new(1, 0, 1, 0)
percentText.Position = UDim2.new(0.5, 0, 0.5, 0)
percentText.AnchorPoint = Vector2.new(0.5, 0.5)
percentText.Text = "0%"
percentText.Font = Enum.Font.GothamBold
percentText.TextColor3 = Color3.fromRGB(255, 255, 255)
percentText.TextSize = 12
percentText.TextStrokeTransparency = 0.5
percentText.BackgroundTransparency = 1
percentText.Parent = barBg

-- Typing Animation Function
local function typeText(textLabel, fullText, speed)
    for i = 1, #fullText do
        if not textLabel or not textLabel.Parent then break end
        textLabel.Text = string.sub(fullText, 1, i)
        task.wait(speed)
    end
end

-- Statuses - Lebih banyak untuk durasi 8 detik
local statuses = {
    [0] = "Initializing...",
    [15] = "Connecting servers...",
    [30] = "Loading resources...",
    [60] = "Initializing systems...",
    [85] = "Finalizing setup...",
    [99] = "Complete!"
}

local DURATION = 8

-- Start typing - [[ DIUBAH ]] Menggunakan random greeting
local line1 = "Hello " .. player.Name .. ", Welcome back! " .. randomGreeting
local line2 = "Made by @muhmdilhan_"

task.spawn(function()
    typeText(welcomeText1, line1, 0.05)
    task.wait(0.2)
    typeText(welcomeText2, line2, 0.05)
end)

-- Progress bar animation
local tweenInfo = TweenInfo.new(DURATION, Enum.EasingStyle.Linear)
local fillTween = TweenService:Create(barFill, tweenInfo, {Size = UDim2.new(1, 0, 1, 0)})
fillTween:Play()

local startTime = tick()
local currentPercent = 0

-- Update loop
while currentPercent < 100 do
    local elapsedTime = tick() - startTime
    currentPercent = math.min(math.floor((elapsedTime / DURATION) * 100), 100)
    
    if percentText and percentText.Parent then
        percentText.Text = currentPercent .. "%"
    end
    
    if statuses[currentPercent] and statusText and statusText.Parent then
        statusText.Text = statuses[currentPercent]
    end
    
    task.wait()
end

task.wait(0.3)

-- Hide old elements
if statusText then statusText.Visible = false end
if percentText then percentText.Visible = false end
if barBg then barBg.Visible = false end
if welcomeText1 then welcomeText1.Visible = false end
if welcomeText2 then welcomeText2.Visible = false end
if title then title.Visible = false end
if avatarFrame then avatarFrame.Visible = false end

-- LANGSUNG DESTROY DENGAN ANIMASI BOUNCE
local bounceInfo = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In)
TweenService:Create(mainFrame, bounceInfo, {Position = UDim2.new(0.5, 0, -0.3, 0)}):Play()
TweenService:Create(mainFrame, bounceInfo, {BackgroundTransparency = 1}):Play()

task.wait(0.5)

-- FORCE DESTROY
if IlhanSiextherls then
    IlhanSiextherls:Destroy()
end

-- DOUBLE CHECK
task.wait(0.1)
local checkGui = PlayerGui:FindFirstChild("LoadingScreen")
if checkGui then
    checkGui:Destroy()
end
