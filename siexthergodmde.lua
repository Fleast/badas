-- SIEXTHER
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FEGodModeGui"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 280, 0, 260)
mainFrame.Position = UDim2.new(0.5, -140, 0.5, -130)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

-- Header
local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 40)
header.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
header.BorderSizePixel = 0
header.Parent = mainFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 12)
headerCorner.Parent = header

local headerFix = Instance.new("Frame")
headerFix.Size = UDim2.new(1, 0, 0, 12)
headerFix.Position = UDim2.new(0, 0, 1, -12)
headerFix.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
headerFix.BorderSizePixel = 0
headerFix.Parent = header

-- Title
local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, -90, 1, 0)
title.Position = UDim2.new(0, 12, 0, 0)
title.BackgroundTransparency = 1
title.Text = "SIEXTHER IMMUNITY"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 16
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

-- Minimize Button
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Name = "MinimizeBtn"
minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
minimizeBtn.Position = UDim2.new(1, -65, 0.5, -15)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
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
closeBtn.Position = UDim2.new(1, -30, 0.5, -15)
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
contentFrame.Size = UDim2.new(1, -24, 1, -55)
contentFrame.Position = UDim2.new(0, 12, 0, 48)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- God Mode Button
local godModeBtn = Instance.new("TextButton")
godModeBtn.Name = "GodModeBtn"
godModeBtn.Size = UDim2.new(1, 0, 0, 45)
godModeBtn.Position = UDim2.new(0, 0, 0, 0)
godModeBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 100)
godModeBtn.Text = "🛡️ God Mode: OFF"
godModeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
godModeBtn.TextSize = 15
godModeBtn.Font = Enum.Font.GothamBold
godModeBtn.BorderSizePixel = 0
godModeBtn.Parent = contentFrame

local godModeBtnCorner = Instance.new("UICorner")
godModeBtnCorner.CornerRadius = UDim.new(0, 7)
godModeBtnCorner.Parent = godModeBtn

-- Unlimited Stamina Button
local staminaBtn = Instance.new("TextButton")
staminaBtn.Name = "StaminaBtn"
staminaBtn.Size = UDim2.new(1, 0, 0, 42)
staminaBtn.Position = UDim2.new(0, 0, 0, 52)
staminaBtn.BackgroundColor3 = Color3.fromRGB(100, 80, 200)
staminaBtn.Text = "⚡ Unlimited Stamina: OFF"
staminaBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
staminaBtn.TextSize = 14
staminaBtn.Font = Enum.Font.GothamBold
staminaBtn.BorderSizePixel = 0
staminaBtn.Parent = contentFrame

local staminaBtnCorner = Instance.new("UICorner")
staminaBtnCorner.CornerRadius = UDim.new(0, 7)
staminaBtnCorner.Parent = staminaBtn

-- No Hunger Button
local hungerBtn = Instance.new("TextButton")
hungerBtn.Name = "HungerBtn"
hungerBtn.Size = UDim2.new(1, 0, 0, 42)
hungerBtn.Position = UDim2.new(0, 0, 0, 100)
hungerBtn.BackgroundColor3 = Color3.fromRGB(255, 150, 50)
hungerBtn.Text = "🍖 No Hunger: OFF"
hungerBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
hungerBtn.TextSize = 14
hungerBtn.Font = Enum.Font.GothamBold
hungerBtn.BorderSizePixel = 0
hungerBtn.Parent = contentFrame

local hungerBtnCorner = Instance.new("UICorner")
hungerBtnCorner.CornerRadius = UDim.new(0, 7)
hungerBtnCorner.Parent = hungerBtn

-- No Thirst Button
local thirstBtn = Instance.new("TextButton")
thirstBtn.Name = "ThirstBtn"
thirstBtn.Size = UDim2.new(1, 0, 0, 42)
thirstBtn.Position = UDim2.new(0, 0, 0, 148)
thirstBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
thirstBtn.Text = "💧 No Thirst: OFF"
thirstBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
thirstBtn.TextSize = 14
thirstBtn.Font = Enum.Font.GothamBold
thirstBtn.BorderSizePixel = 0
thirstBtn.Parent = contentFrame

local thirstBtnCorner = Instance.new("UICorner")
thirstBtnCorner.CornerRadius = UDim.new(0, 7)
thirstBtnCorner.Parent = thirstBtn

-- Minimized Button
local minimizedBtn = Instance.new("TextButton")
minimizedBtn.Name = "MinimizedBtn"
minimizedBtn.Size = UDim2.new(0, 45, 0, 45)
minimizedBtn.Position = UDim2.new(0, 20, 0, 20)
minimizedBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
minimizedBtn.Text = "🛡️"
minimizedBtn.TextColor3 = Color3.fromRGB(100, 200, 255)
minimizedBtn.TextSize = 30
minimizedBtn.Font = Enum.Font.GothamBold
minimizedBtn.BorderSizePixel = 0
minimizedBtn.Visible = false
minimizedBtn.Parent = screenGui

local minimizedBtnCorner = Instance.new("UICorner")
minimizedBtnCorner.CornerRadius = UDim.new(1, 0)
minimizedBtnCorner.Parent = minimizedBtn

-- Variables
local godModeEnabled = false
local staminaEnabled = false
local hungerEnabled = false
local thirstEnabled = false

local godModeConnection
local staminaConnection
local hungerConnection
local thirstConnection
local characterAddedConnection

-- Functions
local function setupGodMode(character)
    if not godModeEnabled then return end
    
    local humanoid = character:WaitForChild("Humanoid")
    
    -- Set max health sangat tinggi
    humanoid.MaxHealth = math.huge
    humanoid.Health = math.huge
    
    -- Disable semua damage
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
    
    -- Block health changes
    local healthChangedConnection
    healthChangedConnection = humanoid.HealthChanged:Connect(function(health)
        if godModeEnabled and health < humanoid.MaxHealth then
            humanoid.Health = humanoid.MaxHealth
        end
    end)
    
    -- Prevent dying
    humanoid.Died:Connect(function()
        if godModeEnabled then
            wait(0.1)
            humanoid.Health = humanoid.MaxHealth
            humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
    end)
    
    -- Block damage from taking damage event
    humanoid:GetPropertyChangedSignal("Health"):Connect(function()
        if godModeEnabled and humanoid.Health < humanoid.MaxHealth then
            humanoid.Health = humanoid.MaxHealth
        end
    end)
    
    -- Infinite health loop untuk character ini
    local charGodConnection
    charGodConnection = RunService.Heartbeat:Connect(function()
        if not godModeEnabled then
            charGodConnection:Disconnect()
            return
        end
        
        if humanoid and humanoid.Parent then
            humanoid.Health = humanoid.MaxHealth
            
            -- Pastikan tidak dalam state mati
            if humanoid:GetState() == Enum.HumanoidStateType.Dead then
                humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
        else
            charGodConnection:Disconnect()
        end
    end)
end

local function toggleGodMode()
    godModeEnabled = not godModeEnabled
    
    if godModeEnabled then
        godModeBtn.Text = "🛡️ God Mode: ON"
        godModeBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 100)
        
        -- Setup god mode untuk character saat ini
        local character = player.Character
        if character then
            setupGodMode(character)
        end
        
        -- Setup god mode untuk setiap respawn
        characterAddedConnection = player.CharacterAdded:Connect(function(character)
            if godModeEnabled then
                setupGodMode(character)
            end
        end)
        
        -- God Mode Loop tambahan
        godModeConnection = RunService.Heartbeat:Connect(function()
            local character = player.Character
            if character then
                local humanoid = character:FindFirstChild("Humanoid")
                if humanoid then
                    if humanoid.Health < humanoid.MaxHealth then
                        humanoid.Health = humanoid.MaxHealth
                    end
                    
                    -- Prevent fall damage and ragdoll
                    if humanoid:GetState() == Enum.HumanoidStateType.FallingDown or 
                       humanoid:GetState() == Enum.HumanoidStateType.Ragdoll then
                        humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
                    end
                end
            end
        end)
    else
        godModeBtn.Text = "🛡️ God Mode: OFF"
        godModeBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 100)
        
        if godModeConnection then
            godModeConnection:Disconnect()
            godModeConnection = nil
        end
        
        if characterAddedConnection then
            characterAddedConnection:Disconnect()
            characterAddedConnection = nil
        end
        
        -- Reset humanoid ke normal
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.MaxHealth = 100
                humanoid.Health = 100
                humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
                humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
                humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
            end
        end
    end
end

local function toggleStamina()
    staminaEnabled = not staminaEnabled
    
    if staminaEnabled then
        staminaBtn.Text = "⚡ Unlimited Stamina: ON"
        staminaBtn.BackgroundColor3 = Color3.fromRGB(150, 120, 255)
        
        -- Stamina Loop
        staminaConnection = RunService.Heartbeat:Connect(function()
            local character = player.Character
            if character then
                -- Try common stamina attribute names
                if character:GetAttribute("Stamina") then
                    character:SetAttribute("Stamina", 100)
                end
                if character:GetAttribute("stamina") then
                    character:SetAttribute("stamina", 100)
                end
                
                -- Try humanoid stamina
                local humanoid = character:FindFirstChild("Humanoid")
                if humanoid then
                    if humanoid:GetAttribute("Stamina") then
                        humanoid:SetAttribute("Stamina", 100)
                    end
                    if humanoid:GetAttribute("stamina") then
                        humanoid:SetAttribute("stamina", 100)
                    end
                end
            end
        end)
    else
        staminaBtn.Text = "⚡ Unlimited Stamina: OFF"
        staminaBtn.BackgroundColor3 = Color3.fromRGB(100, 80, 200)
        
        if staminaConnection then
            staminaConnection:Disconnect()
            staminaConnection = nil
        end
    end
end

local function toggleHunger()
    hungerEnabled = not hungerEnabled
    
    if hungerEnabled then
        hungerBtn.Text = "🍖 No Hunger: ON"
        hungerBtn.BackgroundColor3 = Color3.fromRGB(255, 180, 80)
        
        -- Hunger Loop
        hungerConnection = RunService.Heartbeat:Connect(function()
            local character = player.Character
            if character then
                -- Try common hunger attribute names
                if character:GetAttribute("Hunger") then
                    character:SetAttribute("Hunger", 100)
                end
                if character:GetAttribute("hunger") then
                    character:SetAttribute("hunger", 100)
                end
                if character:GetAttribute("Food") then
                    character:SetAttribute("Food", 100)
                end
                if character:GetAttribute("food") then
                    character:SetAttribute("food", 100)
                end
                
                -- Try humanoid hunger
                local humanoid = character:FindFirstChild("Humanoid")
                if humanoid then
                    if humanoid:GetAttribute("Hunger") then
                        humanoid:SetAttribute("Hunger", 100)
                    end
                    if humanoid:GetAttribute("hunger") then
                        humanoid:SetAttribute("hunger", 100)
                    end
                end
            end
        end)
    else
        hungerBtn.Text = "🍖 No Hunger: OFF"
        hungerBtn.BackgroundColor3 = Color3.fromRGB(255, 150, 50)
        
        if hungerConnection then
            hungerConnection:Disconnect()
            hungerConnection = nil
        end
    end
end

local function toggleThirst()
    thirstEnabled = not thirstEnabled
    
    if thirstEnabled then
        thirstBtn.Text = "💧 No Thirst: ON"
        thirstBtn.BackgroundColor3 = Color3.fromRGB(80, 180, 255)
        
        -- Thirst Loop
        thirstConnection = RunService.Heartbeat:Connect(function()
            local character = player.Character
            if character then
                -- Try common thirst attribute names
                if character:GetAttribute("Thirst") then
                    character:SetAttribute("Thirst", 100)
                end
                if character:GetAttribute("thirst") then
                    character:SetAttribute("thirst", 100)
                end
                if character:GetAttribute("Water") then
                    character:SetAttribute("Water", 100)
                end
                if character:GetAttribute("water") then
                    character:SetAttribute("water", 100)
                end
                
                -- Try humanoid thirst
                local humanoid = character:FindFirstChild("Humanoid")
                if humanoid then
                    if humanoid:GetAttribute("Thirst") then
                        humanoid:SetAttribute("Thirst", 100)
                    end
                    if humanoid:GetAttribute("thirst") then
                        humanoid:SetAttribute("thirst", 100)
                    end
                end
            end
        end)
    else
        thirstBtn.Text = "💧 No Thirst: OFF"
        thirstBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
        
        if thirstConnection then
            thirstConnection:Disconnect()
            thirstConnection = nil
        end
    end
end

-- Button Events
godModeBtn.MouseButton1Click:Connect(toggleGodMode)
staminaBtn.MouseButton1Click:Connect(toggleStamina)
hungerBtn.MouseButton1Click:Connect(toggleHunger)
thirstBtn.MouseButton1Click:Connect(toggleThirst)

closeBtn.MouseButton1Click:Connect(function()
    -- Disable all features first
    godModeEnabled = false
    staminaEnabled = false
    hungerEnabled = false
    thirstEnabled = false
    
    -- Disconnect all connections before closing
    if godModeConnection then godModeConnection:Disconnect() end
    if characterAddedConnection then characterAddedConnection:Disconnect() end
    if staminaConnection then staminaConnection:Disconnect() end
    if hungerConnection then hungerConnection:Disconnect() end
    if thirstConnection then thirstConnection:Disconnect() end
    
    -- Reset humanoid to normal
    local character = player.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.MaxHealth = 100
            humanoid.Health = 100
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
        end
    end
    
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

-- Dragging System for Main Frame
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

-- Dragging for Minimized Button
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
        if button == godModeBtn and godModeEnabled then
            button.BackgroundColor3 = Color3.fromRGB(50, 200, 100)
        elseif button == staminaBtn and staminaEnabled then
            button.BackgroundColor3 = Color3.fromRGB(150, 120, 255)
        elseif button == hungerBtn and hungerEnabled then
            button.BackgroundColor3 = Color3.fromRGB(255, 180, 80)
        elseif button == thirstBtn and thirstEnabled then
            button.BackgroundColor3 = Color3.fromRGB(80, 180, 255)
        else
            button.BackgroundColor3 = normalColor
        end
    end)
end

addHoverEffect(godModeBtn, Color3.fromRGB(50, 150, 100), Color3.fromRGB(60, 180, 120))
addHoverEffect(staminaBtn, Color3.fromRGB(100, 80, 200), Color3.fromRGB(120, 100, 220))
addHoverEffect(hungerBtn, Color3.fromRGB(255, 150, 50), Color3.fromRGB(255, 170, 80))
addHoverEffect(thirstBtn, Color3.fromRGB(50, 150, 255), Color3.fromRGB(70, 170, 255))
addHoverEffect(minimizeBtn, Color3.fromRGB(100, 200, 255), Color3.fromRGB(120, 220, 255))
addHoverEffect(closeBtn, Color3.fromRGB(220, 50, 50), Color3.fromRGB(240, 70, 70))
addHoverEffect(minimizedBtn, Color3.fromRGB(40, 40, 55), Color3.fromRGB(60, 60, 80))

