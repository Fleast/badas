
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local lp = Players.LocalPlayer
local mouse = lp:GetMouse()

-- Avatar Persistence System
local AvatarData = {
    currentUsername = nil,
    currentUserId = nil,
    currentDescription = nil,
    isEnabled = false
}

-- Save/Load Functions
local function saveAvatarData()
    if not AvatarData.isEnabled then return end
    
    local data = {
        username = AvatarData.currentUsername,
        userId = AvatarData.currentUserId,
        enabled = AvatarData.isEnabled
    }
    
    local success, encoded = pcall(function()
        return HttpService:JSONEncode(data)
    end)
    
    if success then
        writefile("ilhanava.json", encoded)
        print("✅ Avatar data saved to ilhanava.json")
    else
        warn("❌ Failed to save avatar data")
    end
end

local function loadAvatarData()
    if not isfile or not readfile then
        warn("⚠️ File functions not available")
        return false
    end
    
    if not isfile("ilhanava.json") then
        print("ℹ️ No saved avatar data found")
        return false
    end
    
    local success, content = pcall(function()
        return readfile("ilhanava.json")
    end)
    
    if not success then
        warn("❌ Failed to read avatar data")
        return false
    end
    
    local success2, data = pcall(function()
        return HttpService:JSONDecode(content)
    end)
    
    if success2 and data.username and data.enabled then
        AvatarData.currentUsername = data.username
        AvatarData.currentUserId = data.userId
        AvatarData.isEnabled = data.enabled
        print("✅ Loaded saved avatar: " .. data.username)
        return true
    end
    
    return false
end

local function clearAvatarData()
    AvatarData.currentUsername = nil
    AvatarData.currentUserId = nil
    AvatarData.currentDescription = nil
    AvatarData.isEnabled = false
    
    if writefile then
        local success = pcall(function()
            writefile("ilhanava.json", HttpService:JSONEncode({enabled = false}))
        end)
        if success then
            print("🗑️ Avatar data cleared")
        end
    end
end

-- UI State Management
local UIState = {
    isOpen = false,
    isAnimating = false
}

-- Drag Function (Universal untuk semua frame)
local function makeDraggable(frame)
    local dragging = false
    local dragInput
    local dragStart
    local startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

-- Toggle Button Creation Function
local function createToggleButton()
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Name = "ToggleButton"
    ToggleButton.Size = UDim2.new(0, 45, 0, 45)
    ToggleButton.Position = UDim2.new(0, 15, 0, 15)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    ToggleButton.BorderSizePixel = 0
    ToggleButton.Text = "🎮"
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleButton.TextScaled = true
    ToggleButton.Font = Enum.Font.GothamBold
    ToggleButton.ZIndex = 10
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 22)
    ToggleCorner.Parent = ToggleButton
    
    -- Make toggle button draggable
    makeDraggable(ToggleButton)
    
    return ToggleButton
end

-- Compact UI Creation Function
local function createUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "RobloxAccountLoader"
    ScreenGui.Parent = lp.PlayerGui
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Toggle Button
    local ToggleButton = createToggleButton()
    ToggleButton.Parent = ScreenGui
    
    -- Main Frame - Compact design (initially hidden)
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 320, 0, 370)
    MainFrame.Position = UDim2.new(0.5, -160, 0.5, -185)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    MainFrame.Visible = false
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 12)
    MainCorner.Parent = MainFrame
    
    -- Make main frame draggable
    makeDraggable(MainFrame)
    
    -- Title Bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 35)
    TitleBar.Position = UDim2.new(0, 0, 0, 0)
    TitleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainFrame
    
    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 12)
    TitleCorner.Parent = TitleBar
    
    -- Title Text
    local TitleText = Instance.new("TextLabel")
    TitleText.Name = "TitleText"
    TitleText.Size = UDim2.new(1, -45, 1, 0)
    TitleText.Position = UDim2.new(0, 10, 0, 0)
    TitleText.BackgroundTransparency = 1
    TitleText.Text = "SIEXTHER CHANGER AVATAR"
    TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleText.Font = Enum.Font.GothamBold
    TitleText.TextSize = 16
    TitleText.TextXAlignment = Enum.TextXAlignment.Left
    TitleText.Parent = TitleBar
    
    -- Close Button (X)
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -33, 0, 2.5)
    CloseButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    CloseButton.BorderSizePixel = 0
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.TextSize = 18
    CloseButton.Parent = TitleBar
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 10)
    CloseCorner.Parent = CloseButton
    
    -- Username Input Section
    local InputFrame = Instance.new("Frame")
    InputFrame.Name = "InputFrame"
    InputFrame.Size = UDim2.new(1, -20, 0, 30)
    InputFrame.Position = UDim2.new(0, 10, 0, 45)
    InputFrame.BackgroundTransparency = 1
    InputFrame.Parent = MainFrame
    
    -- Username Input
    local UsernameInput = Instance.new("TextBox")
    UsernameInput.Name = "UsernameInput"
    UsernameInput.Size = UDim2.new(0.68, -3, 1, 0)
    UsernameInput.Position = UDim2.new(0, 0, 0, 0)
    UsernameInput.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    UsernameInput.BorderSizePixel = 0
    UsernameInput.Text = ""
    UsernameInput.PlaceholderText = "Enter username..."
    UsernameInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    UsernameInput.Font = Enum.Font.Gotham
    UsernameInput.TextSize = 14
    UsernameInput.Parent = InputFrame
    
    local UsernameCorner = Instance.new("UICorner")
    UsernameCorner.CornerRadius = UDim.new(0, 8)
    UsernameCorner.Parent = UsernameInput
    
    -- Submit Button
    local SubmitButton = Instance.new("TextButton")
    SubmitButton.Name = "SubmitButton"
    SubmitButton.Size = UDim2.new(0.32, -3, 1, 0)
    SubmitButton.Position = UDim2.new(0.68, 0, 0, 0)
    SubmitButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    SubmitButton.BorderSizePixel = 0
    SubmitButton.Text = "SUBMIT"
    SubmitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    SubmitButton.Font = Enum.Font.GothamBold
    SubmitButton.TextSize = 14
    SubmitButton.Parent = InputFrame
    
    local SubmitCorner = Instance.new("UICorner")
    SubmitCorner.CornerRadius = UDim.new(0, 8)
    SubmitCorner.Parent = SubmitButton
    
    -- Persistence Toggle Frame
    local PersistenceFrame = Instance.new("Frame")
    PersistenceFrame.Name = "PersistenceFrame"
    PersistenceFrame.Size = UDim2.new(1, -20, 0, 30)
    PersistenceFrame.Position = UDim2.new(0, 10, 0, 82)
    PersistenceFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    PersistenceFrame.BorderSizePixel = 0
    PersistenceFrame.Parent = MainFrame
    
    local PersistenceCorner = Instance.new("UICorner")
    PersistenceCorner.CornerRadius = UDim.new(0, 8)
    PersistenceCorner.Parent = PersistenceFrame
    
    -- Persistence Label
    local PersistenceLabel = Instance.new("TextLabel")
    PersistenceLabel.Name = "PersistenceLabel"
    PersistenceLabel.Size = UDim2.new(0.7, 0, 1, 0)
    PersistenceLabel.Position = UDim2.new(0, 10, 0, 0)
    PersistenceLabel.BackgroundTransparency = 1
    PersistenceLabel.Text = "🔒 Keep Avatar After Death"
    PersistenceLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    PersistenceLabel.Font = Enum.Font.GothamBold
    PersistenceLabel.TextSize = 12
    PersistenceLabel.TextXAlignment = Enum.TextXAlignment.Left
    PersistenceLabel.Parent = PersistenceFrame
    
    -- Reset Button
    local ResetButton = Instance.new("TextButton")
    ResetButton.Name = "ResetButton"
    ResetButton.Size = UDim2.new(0.28, -5, 0, 24)
    ResetButton.Position = UDim2.new(0.72, 0, 0, 3)
    ResetButton.BackgroundColor3 = Color3.fromRGB(255, 100, 50)
    ResetButton.BorderSizePixel = 0
    ResetButton.Text = "RESET"
    ResetButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ResetButton.Font = Enum.Font.GothamBold
    ResetButton.TextSize = 11
    ResetButton.Parent = PersistenceFrame
    
    local ResetCorner = Instance.new("UICorner")
    ResetCorner.CornerRadius = UDim.new(0, 6)
    ResetCorner.Parent = ResetButton
    
    -- Player List Label
    local PlayerListLabel = Instance.new("TextLabel")
    PlayerListLabel.Name = "PlayerListLabel"
    PlayerListLabel.Size = UDim2.new(1, -20, 0, 25)
    PlayerListLabel.Position = UDim2.new(0, 10, 0, 120)
    PlayerListLabel.BackgroundTransparency = 1
    PlayerListLabel.Text = "👥 SELECT PLAYER"
    PlayerListLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    PlayerListLabel.Font = Enum.Font.GothamBold
    PlayerListLabel.TextSize = 14
    PlayerListLabel.TextXAlignment = Enum.TextXAlignment.Left
    PlayerListLabel.Parent = MainFrame
    
    -- Scrolling Frame for Players
    local PlayerScrollFrame = Instance.new("ScrollingFrame")
    PlayerScrollFrame.Name = "PlayerScrollFrame"
    PlayerScrollFrame.Size = UDim2.new(1, -20, 0, 200)
    PlayerScrollFrame.Position = UDim2.new(0, 10, 0, 148)
    PlayerScrollFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    PlayerScrollFrame.BorderSizePixel = 0
    PlayerScrollFrame.ScrollBarThickness = 6
    PlayerScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
    PlayerScrollFrame.Parent = MainFrame
    
    local PlayerScrollCorner = Instance.new("UICorner")
    PlayerScrollCorner.CornerRadius = UDim.new(0, 8)
    PlayerScrollCorner.Parent = PlayerScrollFrame
    
    -- List Layout for Players
    local PlayerListLayout = Instance.new("UIListLayout")
    PlayerListLayout.Name = "PlayerListLayout"
    PlayerListLayout.SortOrder = Enum.SortOrder.Name
    PlayerListLayout.Padding = UDim.new(0, 5)
    PlayerListLayout.Parent = PlayerScrollFrame
    
    -- Padding for scroll frame
    local PlayerScrollPadding = Instance.new("UIPadding")
    PlayerScrollPadding.PaddingTop = UDim.new(0, 5)
    PlayerScrollPadding.PaddingBottom = UDim.new(0, 5)
    PlayerScrollPadding.PaddingLeft = UDim.new(0, 5)
    PlayerScrollPadding.PaddingRight = UDim.new(0, 5)
    PlayerScrollPadding.Parent = PlayerScrollFrame
    
    -- Status Display
    local StatusText = Instance.new("TextLabel")
    StatusText.Name = "StatusText"
    StatusText.Size = UDim2.new(1, -20, 0, 15)
    StatusText.Position = UDim2.new(0, 10, 0, 353)
    StatusText.BackgroundTransparency = 1
    StatusText.Text = "HANN.SIEXTHER"
    StatusText.TextColor3 = Color3.fromRGB(150, 150, 150)
    StatusText.Font = Enum.Font.Gotham
    StatusText.TextSize = 11
    StatusText.TextXAlignment = Enum.TextXAlignment.Center
    StatusText.Parent = MainFrame
    
    return ScreenGui, MainFrame, UsernameInput, StatusText, ToggleButton, SubmitButton, CloseButton, PlayerScrollFrame, PersistenceLabel, ResetButton
end

-- Advanced Avatar Loading Function with Persistence
local function loadAvatar(username, enablePersistence)
    if not username or username == "" then
        return false, "Username tidak boleh kosong!"
    end
    
    local success, userId = pcall(function()
        return Players:GetUserIdFromNameAsync(username)
    end)
    
    if not success then
        return false, "Username tidak ditemukan"
    end
    
    if not lp.Character then
        return false, "Character tidak ada!"
    end
    
    local success2, humanoidDesc = pcall(function()
        return Players:GetHumanoidDescriptionFromUserId(userId)
    end)
    
    if not success2 then
        return false, "Gagal mendapatkan avatar"
    end
    
    -- Save description for persistence
    if enablePersistence then
        AvatarData.currentUsername = username
        AvatarData.currentUserId = userId
        AvatarData.currentDescription = humanoidDesc
        AvatarData.isEnabled = true
        saveAvatarData()
    end
    
    local success_clear = pcall(function()
        for _, accessory in pairs(lp.Character:GetChildren()) do
            if accessory:IsA("Accessory") then
                accessory:Destroy()
            end
        end
        
        for _, clothing in pairs(lp.Character:GetChildren()) do
            if clothing:IsA("Shirt") or clothing:IsA("Pants") or clothing:IsA("ShirtGraphic") then
                clothing:Destroy()
            end
        end
        
        wait(0.1)
    end)
    
    if not success_clear then
        return false, "Gagal membersihkan avatar lama"
    end
    
    local success3 = pcall(function()
        lp.Character.Humanoid:ApplyDescriptionClientServer(humanoidDesc)
        wait(0.5)
    end)
    
    if not success3 then
        return false, "Gagal mengubah avatar"
    end
    
    return true, "Avatar changed to: " .. username
end

-- Apply saved avatar function
local function applySavedAvatar()
    if not AvatarData.isEnabled or not AvatarData.currentUsername then
        return false
    end
    
    if not lp.Character or not lp.Character:FindFirstChild("Humanoid") then
        return false
    end
    
    print("🔄 Reapplying saved avatar: " .. AvatarData.currentUsername)
    
    -- Get fresh description
    local success, humanoidDesc = pcall(function()
        return Players:GetHumanoidDescriptionFromUserId(AvatarData.currentUserId)
    end)
    
    if not success then
        warn("❌ Failed to get saved avatar description")
        return false
    end
    
    -- Clear current avatar
    pcall(function()
        for _, accessory in pairs(lp.Character:GetChildren()) do
            if accessory:IsA("Accessory") then
                accessory:Destroy()
            end
        end
        
        for _, clothing in pairs(lp.Character:GetChildren()) do
            if clothing:IsA("Shirt") or clothing:IsA("Pants") or clothing:IsA("ShirtGraphic") then
                clothing:Destroy()
            end
        end
    end)
    
    wait(0.2)
    
    -- Apply saved avatar
    local success2 = pcall(function()
        lp.Character.Humanoid:ApplyDescriptionClientServer(humanoidDesc)
    end)
    
    if success2 then
        print("✅ Saved avatar reapplied successfully")
        return true
    else
        warn("❌ Failed to reapply saved avatar")
        return false
    end
end

-- Update Player List Function with Profile Pictures
local function updatePlayerList(scrollFrame, usernameInput, statusText, persistenceLabel)
    -- Clear existing buttons
    for _, child in pairs(scrollFrame:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    -- Get all players
    local players = Players:GetPlayers()
    
    -- Create button for each player
    for i, player in ipairs(players) do
        -- Player Container Frame
        local PlayerContainer = Instance.new("Frame")
        PlayerContainer.Name = player.Name .. "Container"
        PlayerContainer.Size = UDim2.new(1, -10, 0, 50)
        PlayerContainer.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        PlayerContainer.BorderSizePixel = 0
        PlayerContainer.Parent = scrollFrame
        
        local ContainerCorner = Instance.new("UICorner")
        ContainerCorner.CornerRadius = UDim.new(0, 8)
        ContainerCorner.Parent = PlayerContainer
        
        -- Player Button (Clickable Area)
        local PlayerButton = Instance.new("TextButton")
        PlayerButton.Name = player.Name
        PlayerButton.Size = UDim2.new(1, 0, 1, 0)
        PlayerButton.Position = UDim2.new(0, 0, 0, 0)
        PlayerButton.BackgroundTransparency = 1
        PlayerButton.Text = ""
        PlayerButton.Parent = PlayerContainer
        
-- Avatar Image (Profile Picture) - ULTRA FAST LOADING 48x48
local AvatarImage = Instance.new("ImageLabel")
AvatarImage.Name = "AvatarImage"
AvatarImage.Size = UDim2.new(0, 40, 0, 40)
AvatarImage.Position = UDim2.new(0, 5, 0, 5)
AvatarImage.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
AvatarImage.BorderSizePixel = 0
-- ULTRA FAST: Using rbxthumb protocol for instant loading
AvatarImage.Image = "rbxthumb://type=AvatarHeadShot&id=" .. player.UserId .. "&w=48&h=48"
AvatarImage.ScaleType = Enum.ScaleType.Fit
AvatarImage.Parent = PlayerContainer
        
        local AvatarCorner = Instance.new("UICorner")
        AvatarCorner.CornerRadius = UDim.new(0, 6)
        AvatarCorner.Parent = AvatarImage
        
        -- Player Name Label
        local PlayerNameLabel = Instance.new("TextLabel")
        PlayerNameLabel.Name = "PlayerNameLabel"
        PlayerNameLabel.Size = UDim2.new(1, -55, 0, 20)
        PlayerNameLabel.Position = UDim2.new(0, 50, 0, 8)
        PlayerNameLabel.BackgroundTransparency = 1
        PlayerNameLabel.Text = player.Name .. (player == lp and " (You)" or "")
        PlayerNameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        PlayerNameLabel.Font = Enum.Font.GothamBold
        PlayerNameLabel.TextSize = 13
        PlayerNameLabel.TextXAlignment = Enum.TextXAlignment.Left
        PlayerNameLabel.TextTruncate = Enum.TextTruncate.AtEnd
        PlayerNameLabel.Parent = PlayerContainer
        
        -- Display Name Label
        local DisplayNameLabel = Instance.new("TextLabel")
        DisplayNameLabel.Name = "DisplayNameLabel"
        DisplayNameLabel.Size = UDim2.new(1, -55, 0, 16)
        DisplayNameLabel.Position = UDim2.new(0, 50, 0, 27)
        DisplayNameLabel.BackgroundTransparency = 1
        DisplayNameLabel.Text = "@" .. player.Name
        DisplayNameLabel.TextColor3 = Color3.fromRGB(130, 130, 130)
        DisplayNameLabel.Font = Enum.Font.Gotham
        DisplayNameLabel.TextSize = 11
        DisplayNameLabel.TextXAlignment = Enum.TextXAlignment.Left
        DisplayNameLabel.TextTruncate = Enum.TextTruncate.AtEnd
        DisplayNameLabel.Parent = PlayerContainer
        
        -- Button Click
        PlayerButton.MouseButton1Click:Connect(function()
            usernameInput.Text = player.Name
            
            -- Auto load avatar with persistence enabled
            statusText.Text = "⏳ Loading " .. player.Name .. "'s avatar..."
            statusText.TextColor3 = Color3.fromRGB(255, 200, 0)
            
            local success, message = loadAvatar(player.Name, true)
            
            if success then
                statusText.Text = "✅ " .. message .. " (Persistent)"
                statusText.TextColor3 = Color3.fromRGB(0, 255, 100)
                persistenceLabel.Text = "🔒 Active: " .. player.Name
                persistenceLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
                
                wait(3)
                statusText.Text = "HANN.SIEXTHER"
                statusText.TextColor3 = Color3.fromRGB(150, 150, 150)
            else
                statusText.Text = "❌ " .. message
                statusText.TextColor3 = Color3.fromRGB(255, 80, 80)
                
                wait(3)
                statusText.Text = "HANN.SIEXTHER"
                statusText.TextColor3 = Color3.fromRGB(150, 150, 150)
            end
        end)
        
        -- Hover Effects
        PlayerButton.MouseEnter:Connect(function()
            TweenService:Create(PlayerContainer, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
        end)
        
        PlayerButton.MouseLeave:Connect(function()
            TweenService:Create(PlayerContainer, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}):Play()
        end)
    end
    
    -- Update canvas size
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, #players * 55 + 10)
end

-- Animation Functions
local function animateUI(frame, isOpening)
    if UIState.isAnimating then return end
    
    UIState.isAnimating = true
    
    local targetSize, targetPosition
    
    if isOpening then
        targetSize = UDim2.new(0, 320, 0, 370)
        targetPosition = UDim2.new(0.5, -160, 0.5, -185)
        frame.Visible = true
    else
        targetSize = UDim2.new(0, 0, 0, 0)
        targetPosition = UDim2.new(0.5, 0, 0.5, 0)
    end
    
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    
    local sizeTween = TweenService:Create(frame, tweenInfo, {Size = targetSize})
    local positionTween = TweenService:Create(frame, tweenInfo, {Position = targetPosition})
    
    sizeTween:Play()
    positionTween:Play()
    
    if not isOpening then
        sizeTween.Completed:Connect(function()
            frame.Visible = false
            UIState.isAnimating = false
        end)
    else
        sizeTween.Completed:Connect(function()
            UIState.isAnimating = false
        end)
    end
end

-- Toggle UI Function
local function toggleUI(mainFrame, toggleButton)
    if UIState.isAnimating then return end
    
    UIState.isOpen = not UIState.isOpen
    
    if UIState.isOpen then
        animateUI(mainFrame, true)
        toggleButton.Text = "❌"
        toggleButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    else
        animateUI(mainFrame, false)
        toggleButton.Text = "🎮"
        toggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    end
end

-- Destroy Script Function
local function destroyScript(screenGui)
    -- Fade out animation
    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    
    for _, child in pairs(screenGui:GetDescendants()) do
        if child:IsA("GuiObject") then
            TweenService:Create(child, tweenInfo, {BackgroundTransparency = 1}):Play()
            if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox") then
                TweenService:Create(child, tweenInfo, {TextTransparency = 1}):Play()
            end
            if child:IsA("ImageLabel") or child:IsA("ImageButton") then
                TweenService:Create(child, tweenInfo, {ImageTransparency = 1}):Play()
            end
        end
    end
    
    -- Wait for animation to complete then destroy
    wait(0.5)
    screenGui:Destroy()
    print("🔴 Avatar Changer Script Destroyed!")
end

-- Main Script
local ScreenGui, MainFrame, UsernameInput, StatusText, ToggleButton, SubmitButton, CloseButton, PlayerScrollFrame, PersistenceLabel, ResetButton = createUI()

-- Load saved avatar data on startup
local hasSavedData = loadAvatarData()
if hasSavedData and AvatarData.currentUsername then
    PersistenceLabel.Text = "🔒 Active: " .. AvatarData.currentUsername
    PersistenceLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
    
    -- Apply saved avatar after a short delay
    task.wait(2)
    if lp.Character and lp.Character:FindFirstChild("Humanoid") then
        applySavedAvatar()
    end
end

-- Initial player list update
updatePlayerList(PlayerScrollFrame, UsernameInput, StatusText, PersistenceLabel)

-- Character respawn handler - Auto reapply avatar
lp.CharacterAdded:Connect(function(character)
    print("🔄 Character respawned, checking for saved avatar...")
    
    -- Wait for character to fully load
    character:WaitForChild("Humanoid")
    task.wait(1)
    
    -- Reapply saved avatar if persistence is enabled
    if AvatarData.isEnabled and AvatarData.currentUsername then
        print("🔄 Reapplying avatar: " .. AvatarData.currentUsername)
        applySavedAvatar()
    else
        print("ℹ️ No saved avatar to apply")
    end
end)

-- Toggle Button Functionality
ToggleButton.MouseButton1Click:Connect(function()
    toggleUI(MainFrame, ToggleButton)
end)

-- Close Button Functionality - NOW DESTROYS SCRIPT
CloseButton.MouseButton1Click:Connect(function()
    -- Show confirmation in status text
    StatusText.Text = "⚠️ Destroying script..."
    StatusText.TextColor3 = Color3.fromRGB(255, 100, 0)
    wait(0.3)
    
    -- Destroy the entire script
    destroyScript(ScreenGui)
end)

-- Submit Button Functionality
SubmitButton.MouseButton1Click:Connect(function()
    local username = UsernameInput.Text
    if username and username ~= "" then
        UsernameInput.Text = ""
        StatusText.Text = "⏳ Loading avatar..."
        StatusText.TextColor3 = Color3.fromRGB(255, 200, 0)
        
        -- Load avatar with persistence enabled
        local success, message = loadAvatar(username, true)
        
        if success then
            StatusText.Text = "✅ " .. message .. " (Persistent)"
            StatusText.TextColor3 = Color3.fromRGB(0, 255, 100)
            PersistenceLabel.Text = "🔒 Active: " .. username
            PersistenceLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
            
            wait(3)
            StatusText.Text = "HANN.SIEXTHER"
            StatusText.TextColor3 = Color3.fromRGB(150, 150, 150)
        else
            StatusText.Text = "❌ " .. message
            StatusText.TextColor3 = Color3.fromRGB(255, 80, 80)
            
            wait(3)
            StatusText.Text = "HANN.SIEXTHER"
            StatusText.TextColor3 = Color3.fromRGB(150, 150, 150)
        end
    end
end)

-- Reset Button Functionality
ResetButton.MouseButton1Click:Connect(function()
    -- Disable persistence
    clearAvatarData()
    
    -- Update UI
    PersistenceLabel.Text = "🔒 Keep Avatar After Death"
    PersistenceLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    
    StatusText.Text = "🗑️ Avatar persistence disabled"
    StatusText.TextColor3 = Color3.fromRGB(255, 150, 0)
    
    -- Reset to default avatar
    if lp.Character and lp.Character:FindFirstChild("Humanoid") then
        local success = pcall(function()
            -- Clear all accessories and clothing
            for _, accessory in pairs(lp.Character:GetChildren()) do
                if accessory:IsA("Accessory") then
                    accessory:Destroy()
                end
            end
            
            for _, clothing in pairs(lp.Character:GetChildren()) do
                if clothing:IsA("Shirt") or clothing:IsA("Pants") or clothing:IsA("ShirtGraphic") then
                    clothing:Destroy()
                end
            end
            
            wait(0.2)
            
            -- Apply default avatar
            local defaultDesc = Players:GetHumanoidDescriptionFromUserId(lp.UserId)
            lp.Character.Humanoid:ApplyDescriptionClientServer(defaultDesc)
        end)
        
        if success then
            StatusText.Text = "✅ Reset to default avatar"
            StatusText.TextColor3 = Color3.fromRGB(0, 255, 100)
        else
            StatusText.Text = "⚠️ Persistence disabled (respawn to reset)"
            StatusText.TextColor3 = Color3.fromRGB(255, 200, 0)
        end
    end
    
    wait(3)
    StatusText.Text = "HANN.SIEXTHER"
    StatusText.TextColor3 = Color3.fromRGB(150, 150, 150)
end)

-- Hover Effects
ToggleButton.MouseEnter:Connect(function()
    if not UIState.isOpen then
        ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    end
end)

ToggleButton.MouseLeave:Connect(function()
    if not UIState.isOpen then
        ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    end
end)

SubmitButton.MouseEnter:Connect(function()
    SubmitButton.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
end)

SubmitButton.MouseLeave:Connect(function()
    SubmitButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
end)

CloseButton.MouseEnter:Connect(function()
    CloseButton.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
end)

CloseButton.MouseLeave:Connect(function()
    CloseButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
end)

ResetButton.MouseEnter:Connect(function()
    ResetButton.BackgroundColor3 = Color3.fromRGB(255, 120, 70)
end)

ResetButton.MouseLeave:Connect(function()
    ResetButton.BackgroundColor3 = Color3.fromRGB(255, 100, 50)
end)

-- Enter key functionality
UsernameInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local username = UsernameInput.Text
        if username and username ~= "" then
            UsernameInput.Text = ""
            StatusText.Text = "⏳ Loading avatar..."
            StatusText.TextColor3 = Color3.fromRGB(255, 200, 0)
            
            -- Load avatar with persistence enabled
            local success, message = loadAvatar(username, true)
            
            if success then
                StatusText.Text = "✅ " .. message .. " (Persistent)"
                StatusText.TextColor3 = Color3.fromRGB(0, 255, 100)
                PersistenceLabel.Text = "🔒 Active: " .. username
                PersistenceLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
                
                wait(3)
                StatusText.Text = "HANN.SIEXTHER"
                StatusText.TextColor3 = Color3.fromRGB(150, 150, 150)
            else
                StatusText.Text = "❌ " .. message
                StatusText.TextColor3 = Color3.fromRGB(255, 80, 80)
                
                wait(3)
                StatusText.Text = "HANN.SIEXTHER"
                StatusText.TextColor3 = Color3.fromRGB(150, 150, 150)
            end
        end
    end
end)

-- Keyboard Shortcut (F1)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F1 then
        toggleUI(MainFrame, ToggleButton)
    end
end)

-- Update player list when players join/leave
Players.PlayerAdded:Connect(function()
    wait(0.5) -- Wait for player to fully load
    updatePlayerList(PlayerScrollFrame, UsernameInput, StatusText, PersistenceLabel)
end)

Players.PlayerRemoving:Connect(function()
    wait(0.1)
    updatePlayerList(PlayerScrollFrame, UsernameInput, StatusText, PersistenceLabel)
end)

-- Periodic check to ensure avatar persistence (every 5 seconds)
task.spawn(function()
    while wait(5) do
        if AvatarData.isEnabled and lp.Character and lp.Character:FindFirstChild("Humanoid") then
            -- Check if avatar is still correct by verifying accessories count
            local currentAccessories = 0
            for _, child in pairs(lp.Character:GetChildren()) do
                if child:IsA("Accessory") then
                    currentAccessories = currentAccessories + 1
                end
            end
            
            -- If no accessories but we should have saved avatar, reapply
            if currentAccessories == 0 and AvatarData.currentDescription then
                print("⚠️ Avatar detected as reset, reapplying...")
                applySavedAvatar()
            end
        end
    end
end)
