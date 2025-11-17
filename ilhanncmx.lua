-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")

-- Wait for LocalPlayer
while not Players.LocalPlayer or not Players.LocalPlayer:FindFirstChild("PlayerScripts") do
    RunService.Heartbeat:Wait()
end

-- Variables
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local IsMobile = UserInputService.TouchEnabled and not UserInputService.MouseEnabled
local PlayerControls

pcall(function()
    PlayerControls = require(LocalPlayer.PlayerScripts:WaitForChild("PlayerModule")):GetControls()
end)

-- State Variables
local FreecamEnabled = false
local ChatHidden = false
local VignetteEnabled = false

-- Speed Settings
local CameraSpeedMultiplier = 1
local WalkSpeed = 16
local MouseSensitivity = 50

-- Mobile Controls
local MobileUpPressed = false
local MobileDownPressed = false

-- Camera Variables
local CameraRotation = Vector2.new()

-- Original Lighting Settings
local OriginalLighting = {
    Time = Lighting.ClockTime,
    Brightness = Lighting.Brightness,
    FogEnd = Lighting.FogEnd
}

-- Touch Variables
local IsMovingUI = false
local CurrentTouchInput = nil
local LastTouchPosition = Vector2.new(0, 0)

-- Connections
local RenderSteppedConnection = nil
local Connections = {}
local CreatedInstances = {}

-- Cleanup Function
local function Cleanup()
    if RenderSteppedConnection then
        RenderSteppedConnection:Disconnect()
        RenderSteppedConnection = nil
    end
    
    for _, connection in ipairs(Connections) do
        pcall(function() connection:Disconnect() end)
    end
    table.clear(Connections)
    
    pcall(function()
        CoreGui:FindFirstChild("VcineControlGui"):Destroy()
        CoreGui:FindFirstChild("VcineUtilityGui"):Destroy()
    end)
    
    Camera.CameraType = Enum.CameraType.Custom
    UserInputService.MouseBehavior = Enum.MouseBehavior.Default
    
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 16
    end
    
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, true)
    
    Lighting.ClockTime = OriginalLighting.Time
    Lighting.Brightness = OriginalLighting.Brightness
    Lighting.FogEnd = OriginalLighting.FogEnd
    
    if Lighting:FindFirstChild("VignetteEffect") then
        Lighting.VignetteEffect.Enabled = false
    end
    
    for _, instance in ipairs(CreatedInstances) do
        pcall(function() instance:Destroy() end)
    end
    table.clear(CreatedInstances)
end

-- Toggle Chat Visibility
local function SetChatHidden(hidden)
    ChatHidden = hidden
    pcall(function()
        StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, not hidden)
    end)
end

-- Camera Movement Update
local function UpdateCamera(deltaTime)
    if not FreecamEnabled then return end
    
    local speed = CameraSpeedMultiplier * 50
    local moveVector = Vector3.new()
    
    if PlayerControls then
        moveVector = PlayerControls:GetMoveVector()
    end
    
    if IsMobile then
        if MobileUpPressed then
            moveVector += Vector3.new(0, 1, 0)
        end
        if MobileDownPressed then
            moveVector += Vector3.new(0, -1, 0)
        end
    else
        if UserInputService:IsKeyDown(Enum.KeyCode.E) then
            moveVector += Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Q) then
            moveVector += Vector3.new(0, -1, 0)
        end
    end
    
    if not IsMobile then
        local canRotate = not IsMovingUI
        if canRotate then
            local mouseDelta = UserInputService:GetMouseDelta()
            if mouseDelta.Magnitude > 0.01 then
                local sensitivity = MouseSensitivity * 0.005
                CameraRotation += Vector2.new(
                    -math.rad(mouseDelta.Y * sensitivity),
                    -math.rad(mouseDelta.X * sensitivity)
                )
                CameraRotation = Vector2.new(
                    math.clamp(CameraRotation.X, -math.pi/2, math.pi/2),
                    CameraRotation.Y
                )
            end
        end
    end
    
    local rotation = CFrame.fromEulerAnglesYXZ(CameraRotation.X, CameraRotation.Y, 0)
    local position = Camera.CFrame.Position
    
    if moveVector.Magnitude > 0.01 then
        position += rotation:VectorToWorldSpace(moveVector.Unit) * speed * deltaTime
    end
    
    Camera.CFrame = CFrame.new(position) * rotation
end

-- Toggle Freecam
local function SetFreecam(enabled, mobileUpButton, mobileDownButton)
    FreecamEnabled = enabled
    
    if enabled then
        local _, yaw, pitch = Camera.CFrame:toEulerAnglesYXZ()
        CameraRotation = Vector2.new(pitch, yaw)
        
        Camera.CameraType = Enum.CameraType.Scriptable
        
        if not IsMobile then
            UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
        end
        
        RenderSteppedConnection = RunService.RenderStepped:Connect(UpdateCamera)
        
        if IsMobile and mobileUpButton and mobileDownButton then
            mobileUpButton.Visible = true
            mobileDownButton.Visible = true
        end
    else
        if RenderSteppedConnection then
            RenderSteppedConnection:Disconnect()
            RenderSteppedConnection = nil
        end
        
        Camera.CameraType = Enum.CameraType.Custom
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        
        if IsMobile and mobileUpButton and mobileDownButton then
            mobileUpButton.Visible = false
            mobileDownButton.Visible = false
            MobileUpPressed = false
            MobileDownPressed = false
            CurrentTouchInput = nil
        end
    end
end

-- Set WalkSpeed
local function SetWalkSpeed(speed)
    WalkSpeed = speed
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = speed
    end
end

-- Set Camera Speed
local function SetCameraSpeed(speed)
    CameraSpeedMultiplier = speed / 20
end

-- Set Mouse Sensitivity
local function SetSensitivity(sensitivity)
    MouseSensitivity = sensitivity
end

-- Set Field of View
local function SetFieldOfView(fov)
    pcall(function()
        Camera.FieldOfView = fov
    end)
end

-- Set Time of Day
local function SetTimeOfDay(time)
    Lighting.ClockTime = time
end

-- Set Brightness
local function SetBrightness(brightness)
    Lighting.Brightness = (brightness / 100) * 5
end

-- Toggle Vignette Effect
local function SetVignette(enabled)
    VignetteEnabled = enabled
    
    local vignetteEffect = Lighting:FindFirstChild("VignetteEffect")
    if not vignetteEffect then
        vignetteEffect = Instance.new("ColorCorrectionEffect")
        vignetteEffect.Name = "VignetteEffect"
        vignetteEffect.Brightness = -0.15
        vignetteEffect.Contrast = 0.1
        vignetteEffect.Saturation = -0.1
        vignetteEffect.Parent = Lighting
        table.insert(CreatedInstances, vignetteEffect)
    end
    
    vignetteEffect.Enabled = enabled
end

-- Create Main GUI
local function CreateGUI()
    local controlGui = Instance.new("ScreenGui")
    controlGui.Name = "VcineControlGui"
    controlGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    controlGui.ResetOnSpawn = false
    controlGui.Parent = CoreGui
    table.insert(CreatedInstances, controlGui)
    
    local utilityGui = Instance.new("ScreenGui")
    utilityGui.Name = "VcineUtilityGui"
    utilityGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    utilityGui.ResetOnSpawn = false
    utilityGui.Parent = CoreGui
    table.insert(CreatedInstances, utilityGui)
    
    -- Main Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 200, 0, 320)
    mainFrame.Position = UDim2.new(0.5, -100, 0.5, -160)
    mainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 16)
    
    local mainStroke = Instance.new("UIStroke", mainFrame)
    mainStroke.Color = Color3.fromRGB(70, 130, 255)
    mainStroke.Thickness = 2
    
    mainFrame.Parent = controlGui
    
    -- Title Bar
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 32)
    titleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    titleBar.BorderSizePixel = 0
    Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 16)
    titleBar.Parent = mainFrame
    
    local titleText = Instance.new("TextLabel")
    titleText.Size = UDim2.new(1, -30, 1, 0)
    titleText.Position = UDim2.new(0, 10, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text = "SIEXTHER FREECAM"
    titleText.Font = Enum.Font.GothamBold
    titleText.TextColor3 = Color3.fromRGB(70, 130, 255)
    titleText.TextSize = 14
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Parent = titleBar
    
    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 22, 0, 22)
    closeButton.Position = UDim2.new(1, -27, 0.5, -11)
    closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    closeButton.Text = "X"
    closeButton.Font = Enum.Font.GothamBold
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextSize = 12
    Instance.new("UICorner", closeButton).CornerRadius = UDim.new(0, 5)
    closeButton.Parent = titleBar
    table.insert(Connections, closeButton.MouseButton1Click:Connect(Cleanup))
    
    -- Scrolling Frame
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Size = UDim2.new(1, 0, 1, -32)
    scrollFrame.Position = UDim2.new(0, 0, 0, 32)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.BorderSizePixel = 0
    scrollFrame.ScrollBarThickness = 4
    scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(70, 130, 255)
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 350)
    scrollFrame.Parent = mainFrame
    
    -- Dragging functionality
    local isDragging = false
    local dragStart = nil
    local startPos = nil
    
    table.insert(Connections, titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            IsMovingUI = true
            isDragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
        end
    end))
    
    -- Toggle Button
    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0, 40, 0, 40)
    toggleButton.Position = UDim2.new(1, -50, 0, 10)
    toggleButton.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
    toggleButton.Text = "CAM"
    toggleButton.Font = Enum.Font.GothamBold
    toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.TextSize = 18
    Instance.new("UICorner", toggleButton).CornerRadius = UDim.new(0, 10)
    
    
    toggleButton.Parent = utilityGui
    table.insert(Connections, toggleButton.MouseButton1Click:Connect(function()
        mainFrame.Visible = not mainFrame.Visible
    end))
    
    -- Mobile Up/Down Buttons
    local mobileUpButton, mobileDownButton
    if IsMobile then
        mobileUpButton = Instance.new("TextButton")
        mobileUpButton.Size = UDim2.new(0, 50, 0, 50)
        mobileUpButton.Position = UDim2.new(1, -65, 1, -130)
        mobileUpButton.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
        mobileUpButton.BackgroundTransparency = 0.5
        mobileUpButton.Text = "▲"
        mobileUpButton.Font = Enum.Font.GothamBold
        mobileUpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        mobileUpButton.TextSize = 25
        mobileUpButton.Visible = false
        Instance.new("UICorner", mobileUpButton).CornerRadius = UDim.new(0, 10)
        
        
        mobileUpButton.Parent = utilityGui
        
        table.insert(Connections, mobileUpButton.InputBegan:Connect(function()
            MobileUpPressed = true
        end))
        table.insert(Connections, mobileUpButton.InputEnded:Connect(function()
            MobileUpPressed = false
        end))
        
        mobileDownButton = Instance.new("TextButton")
        mobileDownButton.Size = UDim2.new(0, 50, 0, 50)
        mobileDownButton.Position = UDim2.new(1, -65, 1, -70)
        mobileDownButton.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
        mobileDownButton.BackgroundTransparency = 0.5
        mobileDownButton.Text = "▼"
        mobileDownButton.Font = Enum.Font.GothamBold
        mobileDownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        mobileDownButton.TextSize = 25
        mobileDownButton.Visible = false
        Instance.new("UICorner", mobileDownButton).CornerRadius = UDim.new(0, 10)
        
        
        
        mobileDownButton.Parent = utilityGui
        
        table.insert(Connections, mobileDownButton.InputBegan:Connect(function()
            MobileDownPressed = true
        end))
        table.insert(Connections, mobileDownButton.InputEnded:Connect(function()
            MobileDownPressed = false
        end))
    end
    
    -- Visual Effects Frame (Posisi di kanan)
    local visualFrame = Instance.new("Frame")
    visualFrame.Size = UDim2.new(0, 200, 0, 280)
    visualFrame.Position = UDim2.new(0.5, 110, 0.5, -140) -- Dipindah ke kanan
    visualFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
    visualFrame.BorderSizePixel = 0
    visualFrame.ClipsDescendants = true
    visualFrame.Visible = false
    Instance.new("UICorner", visualFrame).CornerRadius = UDim.new(0, 16)
    
    local visualStroke = Instance.new("UIStroke", visualFrame)
    visualStroke.Color = Color3.fromRGB(70, 130, 255)
    visualStroke.Thickness = 2
    
    visualFrame.Parent = controlGui
    
    -- Visual Frame Title Bar
    local visualTitleBar = Instance.new("Frame")
    visualTitleBar.Size = UDim2.new(1, 0, 0, 32)
    visualTitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    visualTitleBar.BorderSizePixel = 0
    Instance.new("UICorner", visualTitleBar).CornerRadius = UDim.new(0, 16)
    visualTitleBar.Parent = visualFrame
    
    local visualTitleText = Instance.new("TextLabel")
    visualTitleText.Size = UDim2.new(1, -30, 1, 0)
    visualTitleText.Position = UDim2.new(0, 10, 0, 0)
    visualTitleText.BackgroundTransparency = 1
    visualTitleText.Text = "VISUALS & EFFECTS"
    visualTitleText.Font = Enum.Font.GothamBold
    visualTitleText.TextColor3 = Color3.fromRGB(70, 130, 255)
    visualTitleText.TextSize = 12
    visualTitleText.TextXAlignment = Enum.TextXAlignment.Left
    visualTitleText.Parent = visualTitleBar
    
    local visualCloseButton = Instance.new("TextButton")
    visualCloseButton.Size = UDim2.new(0, 22, 0, 22)
    visualCloseButton.Position = UDim2.new(1, -27, 0.5, -11)
    visualCloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    visualCloseButton.Text = "X"
    visualCloseButton.Font = Enum.Font.GothamBold
    visualCloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    visualCloseButton.TextSize = 12
    Instance.new("UICorner", visualCloseButton).CornerRadius = UDim.new(0, 5)
    visualCloseButton.Parent = visualTitleBar
    table.insert(Connections, visualCloseButton.MouseButton1Click:Connect(function()
        visualFrame.Visible = false
    end))
    
    -- Visual Scrolling Frame
    local visualScrollFrame = Instance.new("ScrollingFrame")
    visualScrollFrame.Size = UDim2.new(1, 0, 1, -32)
    visualScrollFrame.Position = UDim2.new(0, 0, 0, 32)
    visualScrollFrame.BackgroundTransparency = 1
    visualScrollFrame.BorderSizePixel = 0
    visualScrollFrame.ScrollBarThickness = 4
    visualScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(70, 130, 255)
    visualScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 230)
    visualScrollFrame.Parent = visualFrame
    
    -- Control Creation Functions
    local yOffset = 10
    local visualYOffset = 10
    
    local function CreateSectionLabel(text, isVisual)
        local targetFrame = isVisual and visualScrollFrame or scrollFrame
        local offset = isVisual and visualYOffset or yOffset
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -20, 0, 16)
        label.Position = UDim2.new(0, 10, 0, offset)
        label.BackgroundTransparency = 1
        label.Font = Enum.Font.GothamBold
        label.TextColor3 = Color3.fromRGB(70, 130, 255)
        label.Text = text
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.TextSize = 12
        label.Parent = targetFrame
        
        if isVisual then
            visualYOffset += 20
        else
            yOffset += 20
        end
    end
    
    local function CreateFillSlider(labelText, minValue, maxValue, defaultValue, callback, isVisual)
        local targetFrame = isVisual and visualScrollFrame or scrollFrame
        local offset = isVisual and visualYOffset or yOffset
        
        local container = Instance.new("Frame")
        container.Size = UDim2.new(1, -20, 0, 50)
        container.Position = UDim2.new(0, 10, 0, offset)
        container.BackgroundTransparency = 1
        container.Parent = targetFrame
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.65, 0, 0, 16)
        label.BackgroundTransparency = 1
        label.Font = Enum.Font.GothamBold
        label.TextColor3 = Color3.fromRGB(200, 200, 200)
        label.TextSize = 11
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Text = labelText
        label.Parent = container
        
        local textBox = Instance.new("TextBox")
        textBox.Size = UDim2.new(0.3, 0, 0, 20)
        textBox.Position = UDim2.new(0.7, 0, 0, -2)
        textBox.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        textBox.BorderSizePixel = 0
        textBox.Font = Enum.Font.GothamBold
        textBox.TextColor3 = Color3.fromRGB(70, 130, 255)
        textBox.TextSize = 11
        textBox.Text = tostring(math.floor(defaultValue))
        textBox.ClearTextOnFocus = false
        Instance.new("UICorner", textBox).CornerRadius = UDim.new(0, 4)
        textBox.Parent = container
        
        local trackBg = Instance.new("Frame")
        trackBg.Size = UDim2.new(1, 0, 0, 8)
        trackBg.Position = UDim2.new(0, 0, 0, 26)
        trackBg.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
        Instance.new("UICorner", trackBg).CornerRadius = UDim.new(0, 4)
        trackBg.Parent = container
        
        -- Fill bar
        local fillBar = Instance.new("Frame")
        fillBar.Size = UDim2.new(0, 0, 1, 0)
        fillBar.BackgroundColor3 = Color3.fromRGB(70, 130, 255)
        fillBar.BorderSizePixel = 0
        Instance.new("UICorner", fillBar).CornerRadius = UDim.new(0, 4)
        fillBar.Parent = trackBg
        
        local isDraggingSlider = false
        
        local function UpdateSlider(inputPosition)
            local relativeX = inputPosition.X - trackBg.AbsolutePosition.X
            local percent = math.clamp(relativeX / trackBg.AbsoluteSize.X, 0, 1)
            local value = minValue + (maxValue - minValue) * percent
            fillBar.Size = UDim2.new(percent, 0, 1, 0)
            textBox.Text = tostring(math.floor(value))
            if callback then callback(value) end
        end
        
        -- Initialize
        local initialPercent = (defaultValue - minValue) / (maxValue - minValue)
        fillBar.Size = UDim2.new(initialPercent, 0, 1, 0)
        textBox.Text = tostring(math.floor(defaultValue))
        
        table.insert(Connections, textBox.FocusLost:Connect(function()
            local value = tonumber(textBox.Text)
            if value then
                value = math.clamp(value, minValue, maxValue)
                textBox.Text = tostring(math.floor(value))
                local percent = (value - minValue) / (maxValue - minValue)
                fillBar.Size = UDim2.new(percent, 0, 1, 0)
                if callback then callback(value) end
            else
                local currentPercent = fillBar.Size.X.Scale
                local currentValue = minValue + (maxValue - minValue) * currentPercent
                textBox.Text = tostring(math.floor(currentValue))
            end
        end))
        
        local inputBegan = function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or 
               input.UserInputType == Enum.UserInputType.Touch then
                isDraggingSlider = true
                IsMovingUI = true
                UpdateSlider(input.Position)
            end
        end
        
        table.insert(Connections, trackBg.InputBegan:Connect(inputBegan))
        
        table.insert(Connections, UserInputService.InputEnded:Connect(function(input)
            if (input.UserInputType == Enum.UserInputType.MouseButton1 or 
                input.UserInputType == Enum.UserInputType.Touch) and isDraggingSlider then
                isDraggingSlider = false
                IsMovingUI = false
            end
        end))
        
        table.insert(Connections, UserInputService.InputChanged:Connect(function(input)
            if isDraggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or 
                                     input.UserInputType == Enum.UserInputType.Touch) then
                UpdateSlider(input.Position)
            end
        end))
        
        if isVisual then
            visualYOffset += 55
        else
            yOffset += 55
        end
    end
    
    local function CreateToggle(labelText, defaultValue, callback, isVisual)
        local targetFrame = isVisual and visualScrollFrame or scrollFrame
        local offset = isVisual and visualYOffset or yOffset
        
        local state = defaultValue
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(1, -20, 0, 26)
        button.Position = UDim2.new(0, 10, 0, offset)
        button.Font = Enum.Font.GothamBold
        button.TextColor3 = Color3.fromRGB(220, 220, 220)
        button.TextSize = 11
        Instance.new("UICorner", button).CornerRadius = UDim.new(0, 6)
        button.Parent = targetFrame
        
        local function UpdateToggle()
            button.Text = labelText .. ": " .. (state and "ON" or "OFF")
            button.BackgroundColor3 = state and Color3.fromRGB(70, 130, 255) or Color3.fromRGB(40, 40, 45)
        end
        
        table.insert(Connections, button.MouseButton1Click:Connect(function()
            state = not state
            UpdateToggle()
            if callback then callback(state) end
        end))
        
        UpdateToggle()
        
        if isVisual then
            visualYOffset += 31
        else
            yOffset += 31
        end
    end
    
    -- Drag handling
    table.insert(Connections, UserInputService.InputChanged:Connect(function(input)
        if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or 
                          input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end))
    
    table.insert(Connections, UserInputService.InputEnded:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or 
            input.UserInputType == Enum.UserInputType.Touch) and isDragging then
            isDragging = false
            IsMovingUI = false
        end
    end))
    
    -- Create Main Controls (tanpa label section)
    CreateToggle("Freecam", FreecamEnabled, function(enabled)
        SetFreecam(enabled, mobileUpButton, mobileDownButton)
    end, false)
    
    CreateFillSlider("Walkspeed", 0, 100, WalkSpeed, SetWalkSpeed, false)
    CreateFillSlider("Camera Speed", 1, 100, CameraSpeedMultiplier * 20, SetCameraSpeed, false)
    CreateFillSlider("Sensitivity", 1, 100, MouseSensitivity, SetSensitivity, false)
    CreateFillSlider("Field of View", 1, 120, Camera.FieldOfView, SetFieldOfView, false)
    
    -- Button to open Visual & Effects
    yOffset += 8
    local openVisualButton = Instance.new("TextButton")
    openVisualButton.Size = UDim2.new(1, -20, 0, 30)
    openVisualButton.Position = UDim2.new(0, 10, 0, yOffset)
    openVisualButton.BackgroundColor3 = Color3.fromRGB(70, 130, 255)
    openVisualButton.Text = "OPEN VISUALS & EFFECTS"
    openVisualButton.Font = Enum.Font.GothamBold
    openVisualButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    openVisualButton.TextSize = 11
    Instance.new("UICorner", openVisualButton).CornerRadius = UDim.new(0, 6)
    openVisualButton.Parent = scrollFrame
    table.insert(Connections, openVisualButton.MouseButton1Click:Connect(function()
        visualFrame.Visible = not visualFrame.Visible
    end))
    
    -- Create Visual Controls
    CreateSectionLabel("Lighting", true)
    CreateFillSlider("Time", 0, 24, Lighting.ClockTime, SetTimeOfDay, true)
    CreateFillSlider("Brightness", 0, 100, Lighting.Brightness * 20, SetBrightness, true)
    
    visualYOffset += 8
    CreateSectionLabel("Effects", true)
    CreateToggle("Hide Chat", ChatHidden, SetChatHidden, true)
    CreateToggle("Vignette", VignetteEnabled, SetVignette, true)
    
    -- Toggle Key (PC Only)
    if not IsMobile then
        table.insert(Connections, UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if not gameProcessed and input.KeyCode == Enum.KeyCode.Insert then
                mainFrame.Visible = not mainFrame.Visible
            end
        end))
    end
    
    -- Character Added Handler
    local function OnCharacterAdded(character)
        pcall(function()
            character:WaitForChild("Humanoid").WalkSpeed = WalkSpeed
        end)
    end
    
    if LocalPlayer.Character then
        OnCharacterAdded(LocalPlayer.Character)
    end
    table.insert(Connections, LocalPlayer.CharacterAdded:Connect(OnCharacterAdded))
    
    -- Mobile Touch Camera Controls
    if IsMobile then
        table.insert(Connections, UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed or IsMovingUI or not FreecamEnabled then return end
            
            if input.UserInputType == Enum.UserInputType.Touch then
                if input.Position.X > Camera.ViewportSize.X / 2 then
                    CurrentTouchInput = input
                    LastTouchPosition = input.Position
                end
            end
        end))
        
        table.insert(Connections, UserInputService.InputChanged:Connect(function(input, gameProcessed)
            if gameProcessed or IsMovingUI or not FreecamEnabled then return end
            
            if input == CurrentTouchInput then
                local delta = input.Position - LastTouchPosition
                LastTouchPosition = input.Position
                local sensitivity = MouseSensitivity * 0.005
                CameraRotation += Vector2.new(
                    -math.rad(delta.Y * sensitivity),
                    -math.rad(delta.X * sensitivity)
                )
                CameraRotation = Vector2.new(
                    math.clamp(CameraRotation.X, -math.pi/2, math.pi/2),
                    CameraRotation.Y
                )
            end
        end))
        
        table.insert(Connections, UserInputService.InputEnded:Connect(function(input)
            if input == CurrentTouchInput then
                CurrentTouchInput = nil
            end
        end))
    end
end

-- Initialize Script
Cleanup()
CreateGUI()