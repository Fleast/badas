-- SIEXTHER
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Variables
local following = false
local targetPlayer = nil
local connection = nil
local selectedPlayer = nil
local followMode = "default" -- default, carry, attach, drag

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoFollowGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Main Frame (Lebih kecil)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 240, 0, 360)
mainFrame.Position = UDim2.new(0.5, -120, 0.5, -180)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 8)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(60, 60, 80)
mainStroke.Thickness = 1
mainStroke.Parent = mainFrame

-- Header
local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 32)
header.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
header.BorderSizePixel = 0
header.Parent = mainFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 8)
headerCorner.Parent = header

local headerFix = Instance.new("Frame")
headerFix.Size = UDim2.new(1, 0, 0, 8)
headerFix.Position = UDim2.new(0, 0, 1, -8)
headerFix.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
headerFix.BorderSizePixel = 0
headerFix.Parent = header

-- Title
local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, -65, 1, 0)
title.Position = UDim2.new(0, 8, 0, 0)
title.BackgroundTransparency = 1
title.Text = "SIEXTHER AUTO FOLLOW"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 14
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

-- Minimize Button
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Name = "MinimizeBtn"
minimizeBtn.Size = UDim2.new(0, 24, 0, 24)
minimizeBtn.Position = UDim2.new(1, -56, 0.5, -12)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 180, 50)
minimizeBtn.Text = "—"
minimizeBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
minimizeBtn.TextSize = 14
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.BorderSizePixel = 0
minimizeBtn.Parent = header

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 5)
minCorner.Parent = minimizeBtn

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Name = "CloseBtn"
closeBtn.Size = UDim2.new(0, 24, 0, 24)
closeBtn.Position = UDim2.new(1, -28, 0.5, -12)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 12
closeBtn.Font = Enum.Font.GothamBold
closeBtn.BorderSizePixel = 0
closeBtn.Parent = header

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 5)
closeCorner.Parent = closeBtn

-- Status Label
local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "StatusLabel"
statusLabel.Size = UDim2.new(1, -16, 0, 22)
statusLabel.Position = UDim2.new(0, 8, 0, 40)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Status: Idle"
statusLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
statusLabel.TextSize = 11
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = mainFrame

-- Search Box
local searchBox = Instance.new("TextBox")
searchBox.Name = "SearchBox"
searchBox.Size = UDim2.new(1, -16, 0, 28)
searchBox.Position = UDim2.new(0, 8, 0, 65)
searchBox.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
searchBox.BorderSizePixel = 0
searchBox.PlaceholderText = "🔍 Search player..."
searchBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 120)
searchBox.Text = ""
searchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
searchBox.TextSize = 11
searchBox.Font = Enum.Font.Gotham
searchBox.ClearTextOnFocus = false
searchBox.Parent = mainFrame

local searchCorner = Instance.new("UICorner")
searchCorner.CornerRadius = UDim.new(0, 5)
searchCorner.Parent = searchBox

local searchPadding = Instance.new("UIPadding")
searchPadding.PaddingLeft = UDim.new(0, 6)
searchPadding.PaddingRight = UDim.new(0, 6)
searchPadding.Parent = searchBox

local searchStroke = Instance.new("UIStroke")
searchStroke.Color = Color3.fromRGB(50, 50, 70)
searchStroke.Thickness = 1
searchStroke.Parent = searchBox

-- ScrollFrame for players
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Name = "PlayerList"
scrollFrame.Size = UDim2.new(1, -16, 1, -245)
scrollFrame.Position = UDim2.new(0, 8, 0, 100)
scrollFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 3
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 100)
scrollFrame.Parent = mainFrame

local scrollCorner = Instance.new("UICorner")
scrollCorner.CornerRadius = UDim.new(0, 5)
scrollCorner.Parent = scrollFrame

local scrollStroke = Instance.new("UIStroke")
scrollStroke.Color = Color3.fromRGB(50, 50, 70)
scrollStroke.Thickness = 1
scrollStroke.Parent = scrollFrame

local listLayout = Instance.new("UIListLayout")
listLayout.SortOrder = Enum.SortOrder.Name
listLayout.Padding = UDim.new(0, 3)
listLayout.Parent = scrollFrame

local listPadding = Instance.new("UIPadding")
listPadding.PaddingTop = UDim.new(0, 4)
listPadding.PaddingBottom = UDim.new(0, 4)
listPadding.PaddingLeft = UDim.new(0, 4)
listPadding.PaddingRight = UDim.new(0, 4)
listPadding.Parent = scrollFrame

-- Control Buttons Container
local controlFrame = Instance.new("Frame")
controlFrame.Name = "ControlFrame"
controlFrame.Size = UDim2.new(1, -16, 0, 115)
controlFrame.Position = UDim2.new(0, 8, 1, -123)
controlFrame.BackgroundTransparency = 1
controlFrame.Parent = mainFrame

-- Selected Player Label
local selectedLabel = Instance.new("TextLabel")
selectedLabel.Name = "SelectedLabel"
selectedLabel.Size = UDim2.new(1, 0, 0, 16)
selectedLabel.Position = UDim2.new(0, 0, 0, 0)
selectedLabel.BackgroundTransparency = 1
selectedLabel.Text = "Selected: None"
selectedLabel.TextColor3 = Color3.fromRGB(150, 150, 170)
selectedLabel.TextSize = 10
selectedLabel.Font = Enum.Font.Gotham
selectedLabel.TextXAlignment = Enum.TextXAlignment.Left
selectedLabel.Parent = controlFrame

-- Mode Buttons Container
local modeFrame = Instance.new("Frame")
modeFrame.Name = "ModeFrame"
modeFrame.Size = UDim2.new(1, 0, 0, 56)
modeFrame.Position = UDim2.new(0, 0, 0, 20)
modeFrame.BackgroundTransparency = 1
modeFrame.Parent = controlFrame

-- Mode Label
local modeLabel = Instance.new("TextLabel")
modeLabel.Size = UDim2.new(1, 0, 0, 14)
modeLabel.BackgroundTransparency = 1
modeLabel.Text = "Follow Mode:"
modeLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
modeLabel.TextSize = 9
modeLabel.Font = Enum.Font.GothamBold
modeLabel.TextXAlignment = Enum.TextXAlignment.Left
modeLabel.Parent = modeFrame

-- Mode Buttons (2x2 Grid)
local modeButtons = {}
local modes = {
    {name = "default", icon = "", label = "DEFAULT", color = Color3.fromRGB(80, 120, 200)},
    {name = "carry", icon = "", label = "CARRY", color = Color3.fromRGB(200, 100, 150)},
    {name = "attach", icon = "", label = "TEMPEL", color = Color3.fromRGB(150, 150, 100)},
    {name = "drag", icon = "", label = "SERET", color = Color3.fromRGB(180, 90, 120)}
}

for i, mode in ipairs(modes) do
    local row = math.floor((i - 1) / 2)
    local col = (i - 1) % 2
    
    local btn = Instance.new("TextButton")
    btn.Name = mode.name .. "Btn"
    btn.Size = UDim2.new(0.48, 0, 0, 18)
    btn.Position = UDim2.new(col * 0.52, 0, 0, 16 + row * 21)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    btn.Text = mode.icon .. " " .. mode.label
    btn.TextColor3 = Color3.fromRGB(200, 200, 220)
    btn.TextSize = 9
    btn.Font = Enum.Font.Gotham
    btn.BorderSizePixel = 0
    btn.Parent = modeFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 4)
    btnCorner.Parent = btn
    
    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color = Color3.fromRGB(50, 50, 70)
    btnStroke.Thickness = 1
    btnStroke.Parent = btn
    
    modeButtons[mode.name] = {button = btn, color = mode.color, stroke = btnStroke}
    
    btn.MouseButton1Click:Connect(function()
        followMode = mode.name
        -- Reset all mode buttons
        for _, mBtn in pairs(modeButtons) do
            mBtn.button.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
            mBtn.button.TextColor3 = Color3.fromRGB(200, 200, 220)
            mBtn.stroke.Color = Color3.fromRGB(50, 50, 70)
        end
        -- Highlight selected
        btn.BackgroundColor3 = mode.color
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btnStroke.Color = mode.color
    end)
    
    btn.MouseEnter:Connect(function()
        if followMode ~= mode.name then
            btn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
        end
    end)
    
    btn.MouseLeave:Connect(function()
        if followMode ~= mode.name then
            btn.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
        end
    end)
end

-- Highlight default mode
modeButtons["default"].button.BackgroundColor3 = modes[1].color
modeButtons["default"].button.TextColor3 = Color3.fromRGB(255, 255, 255)
modeButtons["default"].stroke.Color = modes[1].color

-- Toggle Follow Button (Single Button)
local toggleBtn = Instance.new("TextButton")
toggleBtn.Name = "ToggleBtn"
toggleBtn.Size = UDim2.new(1, 0, 0, 36)
toggleBtn.Position = UDim2.new(0, 0, 0, 79)
toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 180, 100)
toggleBtn.Text = "MULAI"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.TextSize = 12
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.BorderSizePixel = 0
toggleBtn.Parent = controlFrame

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 6)
toggleCorner.Parent = toggleBtn

local toggleStroke = Instance.new("UIStroke")
toggleStroke.Color = Color3.fromRGB(70, 200, 120)
toggleStroke.Thickness = 1
toggleStroke.Parent = toggleBtn

-- Modern Dark Fire Button
local fireBtn = Instance.new("TextButton")
fireBtn.Name = "FireBtn"
fireBtn.Size = UDim2.new(0, 45, 0, 45)
fireBtn.Position = UDim2.new(0, 15, 0, 60) -- Di bawah logo Roblox (kiri atas)
fireBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
fireBtn.Text = ""
fireBtn.BorderSizePixel = 0
fireBtn.Visible = false
fireBtn.Active = true
fireBtn.Parent = screenGui

local fireCorner = Instance.new("UICorner")
fireCorner.CornerRadius = UDim.new(0, 10)
fireCorner.Parent = fireBtn

local fireStroke = Instance.new("UIStroke")
fireStroke.Color = Color3.fromRGB(255, 100, 50)
fireStroke.Thickness = 2
fireStroke.Parent = fireBtn

local fireIcon = Instance.new("TextLabel")
fireIcon.Size = UDim2.new(1, 0, 1, 0)
fireIcon.BackgroundTransparency = 1
fireIcon.Text = "🎯"
fireIcon.TextSize = 22
fireIcon.Font = Enum.Font.GothamBold
fireIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
fireIcon.Parent = fireBtn

-- Ultra Smooth Follow Function with Multiple Modes
local function startFollowing()
    if not selectedPlayer or not selectedPlayer.Character then return end
    
    following = true
    targetPlayer = selectedPlayer
    local modeName = followMode == "default" and "Default" or 
                     followMode == "carry" and "Carry" or
                     followMode == "attach" and "Attach" or "Drag"
    statusLabel.Text = "Status: Following " .. (targetPlayer.DisplayName or targetPlayer.Name) .. " [" .. modeName .. "]"
    statusLabel.TextColor3 = Color3.fromRGB(100, 255, 150)
    
    if connection then
        connection:Disconnect()
    end
    
    local lastJumpTime = 0
    local wasInAir = false
    
    connection = RunService.Heartbeat:Connect(function(deltaTime)
        if not following or not targetPlayer or not targetPlayer.Character then
            if connection then
                connection:Disconnect()
                connection = nil
            end
            return
        end
        
        local targetChar = targetPlayer.Character
        local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
        local targetHumanoid = targetChar:FindFirstChild("Humanoid")
        
        if not player.Character or not targetRoot or not targetHumanoid then return end
        
        local myRoot = player.Character:FindFirstChild("HumanoidRootPart")
        local myHumanoid = player.Character:FindFirstChild("Humanoid")
        
        if not myRoot or not myHumanoid then return end
        
        -- Different behavior based on mode
        if followMode == "default" then
            -- Default: Follow behind smoothly
            local followOffset = targetRoot.CFrame.LookVector * -2.5
            local followPos = targetRoot.Position + followOffset
            
            local distance = (myRoot.Position - followPos).Magnitude
            
            if distance > 1.5 then
                myHumanoid:MoveTo(followPos)
                myHumanoid.WalkSpeed = targetHumanoid.WalkSpeed
            else
                myHumanoid.WalkSpeed = targetHumanoid.WalkSpeed * 0.5
            end
            
            -- Jump sync
            local targetIsJumping = targetHumanoid:GetState() == Enum.HumanoidStateType.Jumping or
                                    targetHumanoid:GetState() == Enum.HumanoidStateType.Freefall
            
            local targetVelocity = targetRoot.AssemblyLinearVelocity
            local isMovingUp = targetVelocity.Y > 5
            
            local currentTime = tick()
            if (targetIsJumping or isMovingUp) and not wasInAir then
                if currentTime - lastJumpTime > 0.3 then
                    myHumanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    lastJumpTime = currentTime
                end
            end
            wasInAir = targetIsJumping or isMovingUp
            
            -- Sync states
            if targetHumanoid.Sit ~= myHumanoid.Sit then
                myHumanoid.Sit = targetHumanoid.Sit
            end
            
        elseif followMode == "carry" then
            -- Carry Mode: Positioned on back like being carried
            local carryOffset = targetRoot.CFrame.LookVector * -1.2 + Vector3.new(0, 1, 0)
            local carryPos = targetRoot.Position + carryOffset
            
            myRoot.CFrame = CFrame.new(carryPos, targetRoot.Position + targetRoot.CFrame.LookVector)
            myRoot.AssemblyLinearVelocity = targetRoot.AssemblyLinearVelocity
            myHumanoid.Sit = false
            
        elseif followMode == "attach" then
            -- Attach Mode: Overlay/Replace target position (tiban)
            -- Character positioned exactly at target's position
            myRoot.CFrame = targetRoot.CFrame
            myRoot.AssemblyLinearVelocity = targetRoot.AssemblyLinearVelocity
            myRoot.AssemblyAngularVelocity = targetRoot.AssemblyAngularVelocity
            
            -- Mirror all states perfectly
            myHumanoid.Sit = targetHumanoid.Sit
            myHumanoid.WalkSpeed = targetHumanoid.WalkSpeed
            
            -- Copy exact state
            if targetHumanoid:GetState() ~= myHumanoid:GetState() then
                myHumanoid:ChangeState(targetHumanoid:GetState())
            end
            
        elseif followMode == "drag" then
            -- Drag Mode: Being pulled behind with fake death emote (No bouncing)
            local dragOffset = targetRoot.CFrame.LookVector * -2.8
            local targetDragPos = targetRoot.Position + dragOffset + Vector3.new(0, -1.8, 0)
            
            -- Apply fake death emote (lying down)
            myHumanoid.PlatformStand = true
            
            -- SMOOTH position lock - no bouncing/mental
            local currentPos = myRoot.Position
            local lerpAlpha = 0.35 -- Smooth interpolation
            local newPos = currentPos:Lerp(targetDragPos, lerpAlpha)
            
            -- Direct CFrame update for stability
            local lookDirection = (targetRoot.Position - myRoot.Position).Unit
            myRoot.CFrame = CFrame.new(newPos, newPos + lookDirection) * CFrame.Angles(math.rad(90), 0, 0)
            
            -- Match velocity with reduced jitter
            myRoot.AssemblyLinearVelocity = targetRoot.AssemblyLinearVelocity * 0.95
            myRoot.AssemblyAngularVelocity = Vector3.new(0, 0, 0) -- Stop rotation jitter
            
            -- Apply slight drag force for smoothness
            local distance = (myRoot.Position - targetDragPos).Magnitude
            if distance > 0.5 then
                local dragForce = (targetDragPos - myRoot.Position) * 8
                myRoot.AssemblyLinearVelocity = myRoot.AssemblyLinearVelocity + dragForce
            end
        end
    end)
end

local function stopFollowing()
    following = false
    targetPlayer = nil
    if connection then
        connection:Disconnect()
        connection = nil
    end
    
    -- Reset character state when stopping drag mode
    if player.Character then
        local myHumanoid = player.Character:FindFirstChild("Humanoid")
        if myHumanoid then
            myHumanoid.PlatformStand = false
        end
    end
    
    statusLabel.Text = "Status: Idle"
    statusLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
end

-- Function to create player button
local function createPlayerButton(targetPlayer)
    local displayName = targetPlayer.DisplayName or targetPlayer.Name
    local userName = targetPlayer.Name
    local fullName = displayName .. " (@" .. userName .. ")"
    
    local btn = Instance.new("TextButton")
    btn.Name = targetPlayer.Name
    btn.Size = UDim2.new(1, -8, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    btn.Text = ""
    btn.BorderSizePixel = 0
    btn.ClipsDescendants = true
    btn.Parent = scrollFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 5)
    btnCorner.Parent = btn
    
    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color = Color3.fromRGB(50, 50, 70)
    btnStroke.Thickness = 1
    btnStroke.Transparency = 0.5
    btnStroke.Parent = btn
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, -8, 1, 0)
    nameLabel.Position = UDim2.new(0, 6, 0, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = fullName
    nameLabel.TextColor3 = Color3.fromRGB(220, 220, 240)
    nameLabel.TextSize = 10
    nameLabel.Font = Enum.Font.Gotham
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.TextTruncate = Enum.TextTruncate.AtEnd
    nameLabel.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        selectedPlayer = Players:FindFirstChild(btn.Name)
        selectedLabel.Text = "Selected: " .. displayName
        selectedLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
        
        -- Reset all buttons
        for _, child in pairs(scrollFrame:GetChildren()) do
            if child:IsA("TextButton") then
                child.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
                local stroke = child:FindFirstChildOfClass("UIStroke")
                if stroke then
                    stroke.Color = Color3.fromRGB(50, 50, 70)
                end
            end
        end
        btn.BackgroundColor3 = Color3.fromRGB(45, 60, 80)
        btnStroke.Color = Color3.fromRGB(100, 150, 255)
    end)
    
    -- Hover effect
    btn.MouseEnter:Connect(function()
        if selectedPlayer ~= Players:FindFirstChild(btn.Name) then
            btn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
        end
    end)
    
    btn.MouseLeave:Connect(function()
        if selectedPlayer ~= Players:FindFirstChild(btn.Name) then
            btn.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
        end
    end)
    
    return btn
end

-- Function to update player list
local function updatePlayerList(searchText)
    searchText = searchText and searchText:lower() or ""
    
    for _, child in pairs(scrollFrame:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player then
            local displayName = (plr.DisplayName or plr.Name):lower()
            local userName = plr.Name:lower()
            
            if searchText == "" or displayName:find(searchText, 1, true) or userName:find(searchText, 1, true) then
                createPlayerButton(plr)
            end
        end
    end
    
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 8)
end

-- Toggle Button Event (Single button for START/STOP)
toggleBtn.MouseButton1Click:Connect(function()
    if not following then
        if selectedPlayer then
            startFollowing()
            toggleBtn.Text = "STOP"
            toggleBtn.BackgroundColor3 = Color3.fromRGB(180, 60, 70)
            toggleStroke.Color = Color3.fromRGB(200, 80, 90)
        end
    else
        stopFollowing()
        toggleBtn.Text = "MULAI"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 180, 100)
        toggleStroke.Color = Color3.fromRGB(70, 200, 120)
    end
end)

-- Search functionality
searchBox:GetPropertyChangedSignal("Text"):Connect(function()
    updatePlayerList(searchBox.Text)
end)

-- Draggable main frame
local dragging = false
local dragInput, mousePos, framePos

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        mousePos = input.Position
        framePos = mainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - mousePos
        mainFrame.Position = UDim2.new(
            framePos.X.Scale,
            framePos.X.Offset + delta.X,
            framePos.Y.Scale,
            framePos.Y.Offset + delta.Y
        )
    end
end)

-- Draggable fire button
local fireDragging = false
local fireDragInput, fireMousePos, fireFramePos

fireBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        fireDragging = true
        fireMousePos = input.Position
        fireFramePos = fireBtn.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                fireDragging = false
            end
        end)
    end
end)

fireBtn.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        fireDragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == fireDragInput and fireDragging then
        local delta = input.Position - fireMousePos
        fireBtn.Position = UDim2.new(
            fireFramePos.X.Scale,
            fireFramePos.X.Offset + delta.X,
            fireFramePos.Y.Scale,
            fireFramePos.Y.Offset + delta.Y
        )
    end
end)

fireBtn.MouseButton1Click:Connect(function()
    if not fireDragging then
        mainFrame.Visible = true
        fireBtn.Visible = false
    end
end)

-- Close & Minimize
closeBtn.MouseButton1Click:Connect(function()
    stopFollowing()
    screenGui:Destroy()
end)

minimizeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    fireBtn.Visible = true
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

addHoverEffect(closeBtn, Color3.fromRGB(255, 60, 60), Color3.fromRGB(255, 90, 90))
addHoverEffect(minimizeBtn, Color3.fromRGB(255, 180, 50), Color3.fromRGB(255, 200, 80))
addHoverEffect(fireBtn, Color3.fromRGB(30, 30, 40), Color3.fromRGB(40, 40, 50))

-- Toggle button hover (dynamic based on state)
toggleBtn.MouseEnter:Connect(function()
    if not following then
        toggleBtn.BackgroundColor3 = Color3.fromRGB(70, 200, 120)
    else
        toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 80, 90)
    end
end)

toggleBtn.MouseLeave:Connect(function()
    if not following then
        toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 180, 100)
    else
        toggleBtn.BackgroundColor3 = Color3.fromRGB(180, 60, 70)
    end
end)

-- Initial load
updatePlayerList()

Players.PlayerAdded:Connect(function()
    updatePlayerList(searchBox.Text)
end)

Players.PlayerRemoving:Connect(function()
    wait(0.1)
    updatePlayerList(searchBox.Text)
end)