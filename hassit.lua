
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Variables
local autoHeadsitEnabled = false
local autoHeadsitConnection = nil
local godModeConnection = nil
local currentTarget = nil
local selectedPlayer = nil

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SIEXTHER HEADSIT"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

-- Create Main Frame (Smaller & Modern Dark)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 240, 0, 300)
mainFrame.Position = UDim2.new(0.5, -120, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
mainFrame.BackgroundTransparency = 0
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Add rounded corners
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

-- Add Blue Stroke to Main Frame
local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(70, 130, 255)
mainStroke.Thickness = 2
mainStroke.Transparency = 0
mainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
mainStroke.Parent = mainFrame

-- Create Top Bar
local topBar = Instance.new("Frame")
topBar.Name = "TopBar"
topBar.Size = UDim2.new(1, 0, 0, 38)
topBar.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
topBar.BackgroundTransparency = 0
topBar.BorderSizePixel = 0
topBar.Parent = mainFrame

local topBarCorner = Instance.new("UICorner")
topBarCorner.CornerRadius = UDim.new(0, 12)
topBarCorner.Parent = topBar

-- Fix bottom corners of topBar
local topBarFix = Instance.new("Frame")
topBarFix.Size = UDim2.new(1, 0, 0, 12)
topBarFix.Position = UDim2.new(0, 0, 1, -12)
topBarFix.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
topBarFix.BackgroundTransparency = 0
topBarFix.BorderSizePixel = 0
topBarFix.Parent = topBar

-- Title
local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, -70, 1, 0)
title.Position = UDim2.new(0, 12, 0, 0)
title.BackgroundTransparency = 1
title.Text = "SIEXTHER HEADSIT"
title.TextColor3 = Color3.fromRGB(70, 130, 255)
title.TextSize = 15
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = topBar

-- Minimize Button
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Name = "MinimizeBtn"
minimizeBtn.Size = UDim2.new(0, 26, 0, 26)
minimizeBtn.Position = UDim2.new(1, -58, 0.5, -13)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
minimizeBtn.Text = "–"
minimizeBtn.TextColor3 = Color3.fromRGB(70, 130, 255)
minimizeBtn.TextSize = 18
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.BorderSizePixel = 0
minimizeBtn.Parent = topBar

local minimizeBtnCorner = Instance.new("UICorner")
minimizeBtnCorner.CornerRadius = UDim.new(0, 6)
minimizeBtnCorner.Parent = minimizeBtn

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Name = "CloseBtn"
closeBtn.Size = UDim2.new(0, 26, 0, 26)
closeBtn.Position = UDim2.new(1, -28, 0.5, -13)
closeBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 70, 90)
closeBtn.TextSize = 14
closeBtn.Font = Enum.Font.GothamBold
closeBtn.BorderSizePixel = 0
closeBtn.Parent = topBar

local closeBtnCorner = Instance.new("UICorner")
closeBtnCorner.CornerRadius = UDim.new(0, 6)
closeBtnCorner.Parent = closeBtn

-- Content Frame
local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1, -20, 1, -48)
contentFrame.Position = UDim2.new(0, 10, 0, 43)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- Status Label
local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "StatusLabel"
statusLabel.Size = UDim2.new(1, 0, 0, 20)
statusLabel.Position = UDim2.new(0, 0, 0, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Status: Disabled"
statusLabel.TextColor3 = Color3.fromRGB(255, 70, 90)
statusLabel.TextSize = 12
statusLabel.Font = Enum.Font.GothamBold
statusLabel.Parent = contentFrame

-- Player List Label
local playerListLabel = Instance.new("TextLabel")
playerListLabel.Name = "PlayerListLabel"
playerListLabel.Size = UDim2.new(1, 0, 0, 16)
playerListLabel.Position = UDim2.new(0, 0, 0, 22)
playerListLabel.BackgroundTransparency = 1
playerListLabel.Text = "Select Player:"
playerListLabel.TextColor3 = Color3.fromRGB(150, 150, 160)
playerListLabel.TextSize = 11
playerListLabel.Font = Enum.Font.Gotham
playerListLabel.TextXAlignment = Enum.TextXAlignment.Left
playerListLabel.Parent = contentFrame

-- Search Box
local searchBox = Instance.new("TextBox")
searchBox.Name = "SearchBox"
searchBox.Size = UDim2.new(1, 0, 0, 30)
searchBox.Position = UDim2.new(0, 0, 0, 40)
searchBox.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
searchBox.BackgroundTransparency = 0
searchBox.BorderSizePixel = 0
searchBox.PlaceholderText = "Search player..."
searchBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 110)
searchBox.Text = ""
searchBox.TextColor3 = Color3.fromRGB(200, 200, 210)
searchBox.TextSize = 11
searchBox.Font = Enum.Font.Gotham
searchBox.ClearTextOnFocus = false
searchBox.TextXAlignment = Enum.TextXAlignment.Left
searchBox.Parent = contentFrame

local searchBoxCorner = Instance.new("UICorner")
searchBoxCorner.CornerRadius = UDim.new(0, 6)
searchBoxCorner.Parent = searchBox

local searchBoxPadding = Instance.new("UIPadding")
searchBoxPadding.PaddingLeft = UDim.new(0, 8)
searchBoxPadding.PaddingRight = UDim.new(0, 8)
searchBoxPadding.Parent = searchBox

-- Player Count Label
local playerCountLabel = Instance.new("TextLabel")
playerCountLabel.Name = "PlayerCountLabel"
playerCountLabel.Size = UDim2.new(1, 0, 0, 14)
playerCountLabel.Position = UDim2.new(0, 0, 0, 74)
playerCountLabel.BackgroundTransparency = 1
playerCountLabel.Text = "Players: 0"
playerCountLabel.TextColor3 = Color3.fromRGB(120, 120, 130)
playerCountLabel.TextSize = 9
playerCountLabel.Font = Enum.Font.Gotham
playerCountLabel.TextXAlignment = Enum.TextXAlignment.Left
playerCountLabel.Parent = contentFrame

-- Player List ScrollFrame
local playerListFrame = Instance.new("ScrollingFrame")
playerListFrame.Name = "PlayerListFrame"
playerListFrame.Size = UDim2.new(1, 0, 0, 95)
playerListFrame.Position = UDim2.new(0, 0, 0, 90)
playerListFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
playerListFrame.BackgroundTransparency = 0
playerListFrame.BorderSizePixel = 0
playerListFrame.ScrollBarThickness = 3
playerListFrame.ScrollBarImageColor3 = Color3.fromRGB(70, 130, 255)
playerListFrame.Parent = contentFrame

local playerListCorner = Instance.new("UICorner")
playerListCorner.CornerRadius = UDim.new(0, 6)
playerListCorner.Parent = playerListFrame

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 3)
listLayout.SortOrder = Enum.SortOrder.Name
listLayout.Parent = playerListFrame

local listPadding = Instance.new("UIPadding")
listPadding.PaddingTop = UDim.new(0, 3)
listPadding.PaddingBottom = UDim.new(0, 3)
listPadding.PaddingLeft = UDim.new(0, 3)
listPadding.PaddingRight = UDim.new(0, 3)
listPadding.Parent = playerListFrame

-- Toggle Button
local toggleBtn = Instance.new("TextButton")
toggleBtn.Name = "ToggleBtn"
toggleBtn.Size = UDim2.new(1, 0, 0, 38)
toggleBtn.Position = UDim2.new(0, 0, 0, 193)
toggleBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 255)
toggleBtn.Text = "Enable Headsit"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.TextSize = 13
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.BorderSizePixel = 0
toggleBtn.Parent = contentFrame

local toggleBtnCorner = Instance.new("UICorner")
toggleBtnCorner.CornerRadius = UDim.new(0, 7)
toggleBtnCorner.Parent = toggleBtn

-- Info Label
local infoLabel = Instance.new("TextLabel")
infoLabel.Name = "InfoLabel"
infoLabel.Size = UDim2.new(1, 0, 0, 16)
infoLabel.Position = UDim2.new(0, 0, 1, -16)
infoLabel.BackgroundTransparency = 1
infoLabel.Text = "Select a player to headsit"
infoLabel.TextColor3 = Color3.fromRGB(130, 130, 140)
infoLabel.TextSize = 10
infoLabel.Font = Enum.Font.Gotham
infoLabel.TextWrapped = true
infoLabel.Parent = contentFrame

-- Minimized Button (Fire)
local fireBtn = Instance.new("TextButton")
fireBtn.Name = "FireBtn"
fireBtn.Size = UDim2.new(0, 41, 0, 41)
fireBtn.Position = UDim2.new(1, -70, 0.5, -22)
fireBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
fireBtn.BackgroundTransparency = 0
fireBtn.Text = "🧑‍🦽"
fireBtn.TextSize = 20
fireBtn.Font = Enum.Font.GothamBold
fireBtn.BorderSizePixel = 0
fireBtn.Visible = false
fireBtn.Active = true
fireBtn.Draggable = true
fireBtn.Parent = screenGui

local fireBtnCorner = Instance.new("UICorner")
fireBtnCorner.CornerRadius = UDim.new(0, 12)
fireBtnCorner.Parent = fireBtn

-- Add glow effect to fire button
local fireBtnStroke = Instance.new("UIStroke")
fireBtnStroke.Color = Color3.fromRGB(70, 130, 255)
fireBtnStroke.Thickness = 3
fireBtnStroke.Transparency = 0.2
fireBtnStroke.Parent = fireBtn

-- Animate fire button glow
spawn(function()
    while wait(0.5) do
        if fireBtn.Visible then
            TweenService:Create(fireBtnStroke, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Transparency = 0.6}):Play()
            wait(0.5)
            TweenService:Create(fireBtnStroke, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Transparency = 0.2}):Play()
        end
    end
end)

-- God Mode Function
local function enableGodMode()
    if godModeConnection then
        godModeConnection:Disconnect()
    end
    
    godModeConnection = RunService.Heartbeat:Connect(function()
        local char = player.Character
        if char and char:FindFirstChild("Humanoid") then
            local humanoid = char.Humanoid
            
            -- Keep health at max
            if humanoid.Health < humanoid.MaxHealth then
                humanoid.Health = humanoid.MaxHealth
            end
            
            -- Prevent damage
            humanoid.MaxHealth = math.huge
            humanoid.Health = math.huge
        end
    end)
end

local function disableGodMode()
    if godModeConnection then
        godModeConnection:Disconnect()
        godModeConnection = nil
    end
    
    -- Reset health to normal
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        local humanoid = char.Humanoid
        humanoid.MaxHealth = 100
        humanoid.Health = 100
    end
end

-- Functions
local function updatePlayerList(searchText)
    searchText = searchText or ""
    searchText = searchText:lower()
    
    -- Clear existing buttons
    for _, child in pairs(playerListFrame:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    local playerCount = 0
    
    -- Add player buttons
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= player then
            local displayName = otherPlayer.DisplayName:lower()
            local userName = otherPlayer.Name:lower()
            
            -- Filter by search text (check both display name and username)
            if searchText == "" or displayName:find(searchText, 1, true) or userName:find(searchText, 1, true) then
                playerCount = playerCount + 1
                
                local playerBtn = Instance.new("TextButton")
                playerBtn.Name = otherPlayer.Name
                playerBtn.Size = UDim2.new(1, -6, 0, 28)
                playerBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
                playerBtn.BackgroundTransparency = 0
                playerBtn.BorderSizePixel = 0
                playerBtn.AutoButtonColor = false
                playerBtn.Parent = playerListFrame
                
                local playerBtnCorner = Instance.new("UICorner")
                playerBtnCorner.CornerRadius = UDim.new(0, 5)
                playerBtnCorner.Parent = playerBtn
                
                -- Display Name (Primary)
                local displayNameLabel = Instance.new("TextLabel")
                displayNameLabel.Size = UDim2.new(1, -10, 0, 14)
                displayNameLabel.Position = UDim2.new(0, 6, 0, 2)
                displayNameLabel.BackgroundTransparency = 1
                displayNameLabel.Text = otherPlayer.DisplayName
                displayNameLabel.TextColor3 = Color3.fromRGB(220, 220, 230)
                displayNameLabel.TextSize = 11
                displayNameLabel.Font = Enum.Font.GothamBold
                displayNameLabel.TextXAlignment = Enum.TextXAlignment.Left
                displayNameLabel.TextTruncate = Enum.TextTruncate.AtEnd
                displayNameLabel.Parent = playerBtn
                
                -- Username (Secondary)
                local userNameLabel = Instance.new("TextLabel")
                userNameLabel.Size = UDim2.new(1, -10, 0, 11)
                userNameLabel.Position = UDim2.new(0, 6, 0, 15)
                userNameLabel.BackgroundTransparency = 1
                userNameLabel.Text = "@" .. otherPlayer.Name
                userNameLabel.TextColor3 = Color3.fromRGB(120, 120, 130)
                userNameLabel.TextSize = 9
                userNameLabel.Font = Enum.Font.Gotham
                userNameLabel.TextXAlignment = Enum.TextXAlignment.Left
                userNameLabel.TextTruncate = Enum.TextTruncate.AtEnd
                userNameLabel.Parent = playerBtn
                
                playerBtn.MouseButton1Click:Connect(function()
                    selectedPlayer = otherPlayer
                    
                    -- Update all buttons
                    for _, btn in pairs(playerListFrame:GetChildren()) do
                        if btn:IsA("TextButton") then
                            btn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
                        end
                    end
                    
                    playerBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 255)
                    infoLabel.Text = "Selected: " .. otherPlayer.DisplayName
                end)
                
                -- Hover effect
                playerBtn.MouseEnter:Connect(function()
                    if selectedPlayer ~= otherPlayer then
                        TweenService:Create(playerBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 45)}):Play()
                    end
                end)
                
                playerBtn.MouseLeave:Connect(function()
                    if selectedPlayer ~= otherPlayer then
                        TweenService:Create(playerBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(25, 25, 35)}):Play()
                    end
                end)
            end
        end
    end
    
    -- Update player count
    playerCountLabel.Text = "Players: " .. playerCount
    
    -- Update canvas size
    playerListFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 6)
end

local function startHeadsit()
    if autoHeadsitConnection then
        autoHeadsitConnection:Disconnect()
    end
    
    if not selectedPlayer then
        infoLabel.Text = "Please select a player first!"
        return
    end
    
    -- Enable God Mode
    enableGodMode()
    
    autoHeadsitConnection = RunService.Heartbeat:Connect(function()
        local char = player.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then
            return
        end
        
        if selectedPlayer and selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("Head") then
            currentTarget = selectedPlayer.Name
            
            -- Sit on head
            local targetHead = selectedPlayer.Character.Head
            char.HumanoidRootPart.CFrame = targetHead.CFrame * CFrame.new(0, 2.5, 0)
            
            -- Make character sit
            if char:FindFirstChild("Humanoid") then
                local humanoid = char.Humanoid
                humanoid.Sit = true
                humanoid.PlatformStand = true
            end
        else
            infoLabel.Text = "Target player not found!"
            infoLabel.TextColor3 = Color3.fromRGB(255, 150, 100)
        end
    end)
end

local function stopHeadsit()
    if autoHeadsitConnection then
        autoHeadsitConnection:Disconnect()
        autoHeadsitConnection = nil
    end
    
    -- Disable God Mode
    disableGodMode()
    
    -- Re-enable movement
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.Sit = false
        char.Humanoid.PlatformStand = false
    end
    
    currentTarget = nil
end

-- Search functionality
searchBox:GetPropertyChangedSignal("Text"):Connect(function()
    updatePlayerList(searchBox.Text)
end)

-- Clear search on focus
searchBox.Focused:Connect(function()
    searchBox.PlaceholderText = "Type to search..."
end)

searchBox.FocusLost:Connect(function()
    searchBox.PlaceholderText = "Search player..."
end)

-- Button Events
toggleBtn.MouseButton1Click:Connect(function()
    if not selectedPlayer then
        infoLabel.Text = "Select a player first!"
        infoLabel.TextColor3 = Color3.fromRGB(255, 150, 100)
        
        -- Flash effect
        TweenService:Create(toggleBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(255, 150, 100)}):Play()
        wait(0.1)
        TweenService:Create(toggleBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(70, 130, 255)}):Play()
        
        wait(2)
        infoLabel.TextColor3 = Color3.fromRGB(130, 130, 140)
        infoLabel.Text = "Select a player to headsit"
        return
    end
    
    autoHeadsitEnabled = not autoHeadsitEnabled
    
    if autoHeadsitEnabled then
        toggleBtn.Text = "Disable"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 90)
        statusLabel.Text = "Status: Active"
        statusLabel.TextColor3 = Color3.fromRGB(70, 255, 130)
        infoLabel.Text = "Headsitting: " .. selectedPlayer.DisplayName
        infoLabel.TextColor3 = Color3.fromRGB(70, 255, 130)
        startHeadsit()
    else
        toggleBtn.Text = "Enable Headsit"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 255)
        statusLabel.Text = "Status: Disabled"
        statusLabel.TextColor3 = Color3.fromRGB(255, 70, 90)
        infoLabel.Text = "Select a player to headsit"
        infoLabel.TextColor3 = Color3.fromRGB(130, 130, 140)
        stopHeadsit()
    end
end)

closeBtn.MouseButton1Click:Connect(function()
    -- Fade out animation
    TweenService:Create(mainFrame, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
    TweenService:Create(mainStroke, TweenInfo.new(0.3), {Transparency = 1}):Play()
    for _, child in pairs(mainFrame:GetDescendants()) do
        if child:IsA("GuiObject") then
            local props = {BackgroundTransparency = 1}
            if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox") then
                props.TextTransparency = 1
            end
            TweenService:Create(child, TweenInfo.new(0.3), props):Play()
        end
    end
    
    wait(0.3)
    stopHeadsit()
    screenGui:Destroy()
end)

minimizeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    fireBtn.Visible = true
end)

fireBtn.MouseButton1Click:Connect(function()
    fireBtn.Visible = false
    mainFrame.Visible = true
end)

-- Hover effects
local function addHoverEffect(btn, normalColor, hoverColor)
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = hoverColor}):Play()
    end)
    
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = normalColor}):Play()
    end)
end

addHoverEffect(closeBtn, Color3.fromRGB(30, 30, 40), Color3.fromRGB(255, 70, 90))
addHoverEffect(minimizeBtn, Color3.fromRGB(30, 30, 40), Color3.fromRGB(70, 130, 255))
addHoverEffect(fireBtn, Color3.fromRGB(15, 15, 20), Color3.fromRGB(70, 130, 255))

toggleBtn.MouseEnter:Connect(function()
    if autoHeadsitEnabled then
        TweenService:Create(toggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 50, 70)}):Play()
    else
        TweenService:Create(toggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(90, 150, 255)}):Play()
    end
end)

toggleBtn.MouseLeave:Connect(function()
    if autoHeadsitEnabled then
        TweenService:Create(toggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 70, 90)}):Play()
    else
        TweenService:Create(toggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(70, 130, 255)}):Play()
    end
end)

-- Initialize player list
updatePlayerList()

-- Update player list when players join/leave
Players.PlayerAdded:Connect(function()
    wait(0.5)
    updatePlayerList(searchBox.Text)
end)

Players.PlayerRemoving:Connect(function(removingPlayer)
    updatePlayerList(searchBox.Text)
    
    -- If the selected player left, reset selection
    if selectedPlayer == removingPlayer then
        selectedPlayer = nil
        if autoHeadsitEnabled then
            autoHeadsitEnabled = false
            toggleBtn.Text = "Enable Headsit"
            toggleBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 255)
            statusLabel.Text = "Status: Disabled"
            statusLabel.TextColor3 = Color3.fromRGB(255, 70, 90)
            infoLabel.Text = "Target player left the game"
            infoLabel.TextColor3 = Color3.fromRGB(255, 150, 100)
            stopHeadsit()
        end
    end
end)
