local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Variables
local isRecording = false
local isPlaying = false
local isAutoRepeat = false
local isPausedRecording = false
local isPausedPlaying = false
local currentRecording = {}
local recordings = {}
local recordingName = ""
local fileName = "ilhansiexther.json"
local recordConnection = nil
local playConnection = nil
local pausedFrameIndex = 1
local currentReorderFrame = nil
local savedPosition = nil

-- Color Scheme - Dark Modern
local colors = {
    background = Color3.fromRGB(18, 18, 22),
    surface = Color3.fromRGB(25, 25, 30),
    surfaceLight = Color3.fromRGB(32, 32, 38),
    accent = Color3.fromRGB(70, 130, 255),
    accentDark = Color3.fromRGB(14, 165, 233),
    text = Color3.fromRGB(241, 245, 249),
    textDim = Color3.fromRGB(148, 163, 184),
    success = Color3.fromRGB(34, 197, 94),
    warning = Color3.fromRGB(251, 146, 60),
    danger = Color3.fromRGB(239, 68, 68),
    stroke = Color3.fromRGB(70, 130, 255),
}

-- Helper function to convert CFrame rotation to saveable format
local function serializeCFrame(cf)
    local x, y, z, r00, r01, r02, r10, r11, r12, r20, r21, r22 = cf:GetComponents()
    return {x, y, z, r00, r01, r02, r10, r11, r12, r20, r21, r22}
end

local function deserializeCFrame(data)
    return CFrame.new(unpack(data))
end

local function serializeVector3(v)
    return {v.X, v.Y, v.Z}
end

local function deserializeVector3(data)
    return Vector3.new(data[1] or 0, data[2] or 0, data[3] or 0)
end

-- Load recordings from file
local function loadRecordings()
    local success, result = pcall(function()
        return readfile(fileName)
    end)
    
    if success then
        local decoded = HttpService:JSONDecode(result)
        recordings = decoded or {}
        print("Loaded recordings:", #recordings, "recordings found")
    else
        recordings = {}
        print("No existing recordings found, starting fresh")
    end
end

-- Save recordings to file with proper serialization
local function saveRecordings()
    local encoded = HttpService:JSONEncode(recordings)
    writefile(fileName, encoded)
    print("Recordings saved to", fileName)
end

-- Helper function to add stroke
local function addStroke(element, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or colors.stroke
    stroke.Thickness = thickness or 1
    stroke.Transparency = 0
    stroke.Parent = element
    return stroke
end

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoWalkRecorder"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 240, 0, 340)
mainFrame.Position = UDim2.new(0.5, -120, 0.5, -170)
mainFrame.BackgroundColor3 = colors.background
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

addStroke(mainFrame, colors.stroke, 2)

-- Top Bar
local topBar = Instance.new("Frame")
topBar.Name = "TopBar"
topBar.Size = UDim2.new(1, 0, 0, 26)
topBar.BackgroundColor3 = colors.surface
topBar.BorderSizePixel = 0
topBar.Parent = mainFrame

local topCorner = Instance.new("UICorner")
topCorner.CornerRadius = UDim.new(0, 12)
topCorner.Parent = topBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -55, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "SIEXTHER AUTO WALK"
titleLabel.TextColor3 = colors.accent
titleLabel.TextSize = 11
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = topBar

-- Minimize Button
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Name = "MinimizeBtn"
minimizeBtn.Size = UDim2.new(0, 22, 0, 22)
minimizeBtn.Position = UDim2.new(1, -46, 0, 2)
minimizeBtn.BackgroundColor3 = colors.surfaceLight
minimizeBtn.Text = "−"
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.TextSize = 13
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.BorderSizePixel = 0
minimizeBtn.Parent = topBar

local minimizeCorner = Instance.new("UICorner")
minimizeCorner.CornerRadius = UDim.new(0, 6)
minimizeCorner.Parent = minimizeBtn

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Name = "CloseBtn"
closeBtn.Size = UDim2.new(0, 22, 0, 22)
closeBtn.Position = UDim2.new(1, -22, 0, 2)
closeBtn.BackgroundColor3 = colors.danger
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 11
minimizeBtn.Font = Enum.Font.GothamBold
closeBtn.BorderSizePixel = 0
closeBtn.Parent = topBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeBtn


-- Content Frame
local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1, -14, 1, -32)
contentFrame.Position = UDim2.new(0, 7, 0, 29)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- Recording Name Input
local nameLabel = Instance.new("TextLabel")
nameLabel.Size = UDim2.new(1, 0, 0, 16)
nameLabel.Position = UDim2.new(0, 0, 0, 0)
nameLabel.BackgroundTransparency = 1
nameLabel.Text = "Nama Rekaman:"
nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
nameLabel.TextSize = 9
nameLabel.Font = Enum.Font.Gotham
nameLabel.TextXAlignment = Enum.TextXAlignment.Left
nameLabel.Parent = contentFrame

local nameInput = Instance.new("TextBox")
nameInput.Size = UDim2.new(1, 0, 0, 24)
nameInput.Position = UDim2.new(0, 0, 0, 18)
nameInput.BackgroundColor3 = colors.surface
nameInput.Text = ""
nameInput.PlaceholderText = "Masukkan nama..."
nameInput.PlaceholderColor3 = colors.textDim
nameInput.TextColor3 = colors.text
nameInput.TextSize = 9
nameInput.Font = Enum.Font.Gotham
nameInput.BorderSizePixel = 0
nameInput.Parent = contentFrame

local nameCorner = Instance.new("UICorner")
nameCorner.CornerRadius = UDim.new(0, 6)
nameCorner.Parent = nameInput


-- Status Label
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0, 20)
statusLabel.Position = UDim2.new(0, 0, 0, 45)
statusLabel.BackgroundColor3 = colors.surface
statusLabel.Text = "Status: Siap"
statusLabel.TextColor3 = colors.success
statusLabel.TextSize = 9
statusLabel.Font = Enum.Font.GothamBold
statusLabel.BorderSizePixel = 0
statusLabel.Parent = contentFrame

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 6)
statusCorner.Parent = statusLabel


-- Record Button
local recordBtn = Instance.new("TextButton")
recordBtn.Size = UDim2.new(0.31, -2, 0, 28)
recordBtn.Position = UDim2.new(0, 0, 0, 68)
recordBtn.BackgroundColor3 = colors.danger
recordBtn.Text = "🔴 REKAM"
recordBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
recordBtn.TextSize = 9
recordBtn.Font = Enum.Font.GothamBold
recordBtn.BorderSizePixel = 0
recordBtn.Parent = contentFrame

local recordCorner = Instance.new("UICorner")
recordCorner.CornerRadius = UDim.new(0, 6)
recordCorner.Parent = recordBtn


-- Pause Button
local pauseBtn = Instance.new("TextButton")
pauseBtn.Size = UDim2.new(0.31, -2, 0, 28)
pauseBtn.Position = UDim2.new(0.34, 0, 0, 68)
pauseBtn.BackgroundColor3 = colors.warning
pauseBtn.Text = "⏸ PAUSE"
pauseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
pauseBtn.TextSize = 9
pauseBtn.Font = Enum.Font.GothamBold
pauseBtn.Visible = false
pauseBtn.BorderSizePixel = 0
pauseBtn.Parent = contentFrame

local pauseCorner = Instance.new("UICorner")
pauseCorner.CornerRadius = UDim.new(0, 6)
pauseCorner.Parent = pauseBtn


-- Stop Button
local stopBtn = Instance.new("TextButton")
stopBtn.Size = UDim2.new(0.31, -2, 0, 28)
stopBtn.Position = UDim2.new(0.68, 0, 0, 68)
stopBtn.BackgroundColor3 = colors.surfaceLight
stopBtn.Text = "⏹ STOP"
stopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
stopBtn.TextSize = 9
stopBtn.Font = Enum.Font.GothamBold
stopBtn.BorderSizePixel = 0
stopBtn.Parent = contentFrame

local stopCorner = Instance.new("UICorner")
stopCorner.CornerRadius = UDim.new(0, 6)
stopCorner.Parent = stopBtn


-- Auto Repeat Button
local autoRepeatBtn = Instance.new("TextButton")
autoRepeatBtn.Size = UDim2.new(1, 0, 0, 28)
autoRepeatBtn.Position = UDim2.new(0, 0, 0, 99)
autoRepeatBtn.BackgroundColor3 = colors.accent
autoRepeatBtn.Text = "🔁 AUTO PLAY"
autoRepeatBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
autoRepeatBtn.TextSize = 10
autoRepeatBtn.Font = Enum.Font.GothamBold
autoRepeatBtn.BorderSizePixel = 0
autoRepeatBtn.Parent = contentFrame

local autoRepeatCorner = Instance.new("UICorner")
autoRepeatCorner.CornerRadius = UDim.new(0, 6)
autoRepeatCorner.Parent = autoRepeatBtn


-- Recordings List Label
local listLabel = Instance.new("TextLabel")
listLabel.Size = UDim2.new(1, 0, 0, 16)
listLabel.Position = UDim2.new(0, 0, 0, 130)
listLabel.BackgroundTransparency = 1
listLabel.Text = "Daftar Rekaman:"
listLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
listLabel.TextSize = 9
listLabel.Font = Enum.Font.Gotham
listLabel.TextXAlignment = Enum.TextXAlignment.Left
listLabel.Parent = contentFrame

-- Recordings ScrollFrame
local recordingsScroll = Instance.new("ScrollingFrame")
recordingsScroll.Size = UDim2.new(1, 0, 0, 160)
recordingsScroll.Position = UDim2.new(0, 0, 0, 149)
recordingsScroll.BackgroundColor3 = colors.surface
recordingsScroll.BorderSizePixel = 0
recordingsScroll.ScrollBarThickness = 3
recordingsScroll.ScrollBarImageColor3 = colors.accent
recordingsScroll.Parent = contentFrame

local scrollCorner = Instance.new("UICorner")
scrollCorner.CornerRadius = UDim.new(0, 6)
scrollCorner.Parent = recordingsScroll


local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 3)
listLayout.Parent = recordingsScroll

-- Functions
local function updateStatus(text, color)
    statusLabel.Text = "Status: " .. text
    statusLabel.TextColor3 = color
end

local function closeAllReorderFrames()
    if currentReorderFrame then
        currentReorderFrame.Visible = false
        currentReorderFrame = nil
    end
end

local function refreshRecordingsList()
    for _, child in ipairs(recordingsScroll:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end

    for i, rec in ipairs(recordings) do
        local recFrame = Instance.new("Frame")
        recFrame.Size = UDim2.new(1, -8, 0, 26)
        recFrame.BackgroundColor3 = colors.surfaceLight
        recFrame.BorderSizePixel = 0
        recFrame.Parent = recordingsScroll
        
        local recCorner = Instance.new("UICorner")
        recCorner.CornerRadius = UDim.new(0, 6)
        recCorner.Parent = recFrame
        
        

        local recLabel = Instance.new("TextLabel")
        recLabel.Size = UDim2.new(1, -125, 1, 0)
        recLabel.Position = UDim2.new(0, 5, 0, 0)
        recLabel.BackgroundTransparency = 1
        recLabel.Text = rec.name
        recLabel.TextColor3 = colors.text
        recLabel.TextSize = 8
        recLabel.Font = Enum.Font.Gotham
        recLabel.TextXAlignment = Enum.TextXAlignment.Left
        recLabel.TextTruncate = Enum.TextTruncate.AtEnd
        recLabel.Parent = recFrame

        -- Menu Button
        local menuBtn = Instance.new("TextButton")
        menuBtn.Size = UDim2.new(0, 26, 0, 18)
        menuBtn.Position = UDim2.new(1, -120, 0.5, -9)
        menuBtn.BackgroundColor3 = colors.surface
        menuBtn.Text = "↑↓"
        menuBtn.TextColor3 = colors.accent
        menuBtn.TextSize = 11
        menuBtn.Font = Enum.Font.GothamBold
        menuBtn.BorderSizePixel = 0
        menuBtn.Parent = recFrame

        local menuCorner = Instance.new("UICorner")
        menuCorner.CornerRadius = UDim.new(0, 4)
        menuCorner.Parent = menuBtn
        
        

        -- Reorder Frame
        local reorderFrame = Instance.new("Frame")
        reorderFrame.Name = "ReorderFrame"
        reorderFrame.Size = UDim2.new(0, 20, 0, 40)
        reorderFrame.Position = UDim2.new(1, -142, 0.5, -20)
        reorderFrame.BackgroundColor3 = colors.surface
        reorderFrame.BorderSizePixel = 0
        reorderFrame.Visible = false
        reorderFrame.ZIndex = 10
        reorderFrame.Parent = recFrame

        local reorderCorner = Instance.new("UICorner")
        reorderCorner.CornerRadius = UDim.new(0, 4)
        reorderCorner.Parent = reorderFrame
        
        

        -- Up Button
        local upBtn = Instance.new("TextButton")
        upBtn.Size = UDim2.new(1, 0, 0, 18)
        upBtn.Position = UDim2.new(0, 0, 0, 0)
        upBtn.BackgroundColor3 = colors.success
        upBtn.Text = "↑"
        upBtn.TextColor3 = colors.text
        upBtn.TextSize = 13
        upBtn.Font = Enum.Font.GothamBold
        upBtn.ZIndex = 11
        upBtn.BorderSizePixel = 0
        upBtn.Parent = reorderFrame

        local upCorner = Instance.new("UICorner")
        upCorner.CornerRadius = UDim.new(0, 3)
        upCorner.Parent = upBtn

        -- Down Button
        local downBtn = Instance.new("TextButton")
        downBtn.Size = UDim2.new(1, 0, 0, 18)
        downBtn.Position = UDim2.new(0, 0, 0, 20)
        downBtn.BackgroundColor3 = colors.danger
        downBtn.Text = "↓"
        downBtn.TextColor3 = colors.text
        downBtn.TextSize = 13
        downBtn.Font = Enum.Font.GothamBold
        downBtn.ZIndex = 11
        downBtn.BorderSizePixel = 0
        downBtn.Parent = reorderFrame

        local downCorner = Instance.new("UICorner")
        downCorner.CornerRadius = UDim.new(0, 3)
        downCorner.Parent = downBtn

        -- Play Button
        local playBtn = Instance.new("TextButton")
        playBtn.Size = UDim2.new(0, 44, 0, 18)
        playBtn.Position = UDim2.new(1, -92, 0.5, -9)
        playBtn.BackgroundColor3 = colors.success
        playBtn.Text = "PLAY"
        playBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        playBtn.TextSize = 8
        playBtn.Font = Enum.Font.GothamBold
        playBtn.BorderSizePixel = 0
        playBtn.Parent = recFrame

        local playCorner = Instance.new("UICorner")
        playCorner.CornerRadius = UDim.new(0, 4)
        playCorner.Parent = playBtn
        
        

        -- Delete Button
        local deleteBtn = Instance.new("TextButton")
        deleteBtn.Size = UDim2.new(0, 44, 0, 18)
        deleteBtn.Position = UDim2.new(1, -46, 0.5, -9)
        deleteBtn.BackgroundColor3 = colors.danger
        deleteBtn.Text = "HAPUS"
        deleteBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        deleteBtn.TextSize = 8
        deleteBtn.Font = Enum.Font.GothamBold
        deleteBtn.BorderSizePixel = 0
        deleteBtn.Parent = recFrame

        local deleteCorner = Instance.new("UICorner")
        deleteCorner.CornerRadius = UDim.new(0, 4)
        deleteCorner.Parent = deleteBtn    

        -- Menu Button Click
        menuBtn.MouseButton1Click:Connect(function()
            if currentReorderFrame == reorderFrame then
                reorderFrame.Visible = false
                currentReorderFrame = nil
            else
                closeAllReorderFrames()
                reorderFrame.Visible = true
                currentReorderFrame = reorderFrame
            end
        end)

        -- Up Button Click
        upBtn.MouseButton1Click:Connect(function()
            if i > 1 then
                local temp = recordings[i]
                recordings[i] = recordings[i - 1]
                recordings[i - 1] = temp
                saveRecordings()
                refreshRecordingsList()
                updateStatus("Rekaman dinaikkan", colors.success)
            end
        end)

        -- Down Button Click
        downBtn.MouseButton1Click:Connect(function()
            if i < #recordings then
                local temp = recordings[i]
                recordings[i] = recordings[i + 1]
                recordings[i + 1] = temp
                saveRecordings()
                refreshRecordingsList()
                updateStatus("Rekaman diturunkan", colors.success)
            end
        end)

        playBtn.MouseButton1Click:Connect(function()
            if not isPlaying and not isRecording then
                playRecording(rec)
            end
        end)

        deleteBtn.MouseButton1Click:Connect(function()
            table.remove(recordings, i)
            saveRecordings()
            refreshRecordingsList()
            updateStatus("Rekaman dihapus", colors.warning)
        end)
    end
    
    recordingsScroll.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 5)
end

local function startRecording()
    if nameInput.Text == "" then
        updateStatus("Masukkan nama rekaman!", colors.danger)
        return
    end
    
    isRecording = true
    isPausedRecording = false
    currentRecording = {
        name = nameInput.Text,
        startPosition = serializeCFrame(rootPart.CFrame),
        frames = {}
    }
    updateStatus("Merekam... Frame: 0", colors.danger)
    recordBtn.BackgroundColor3 = colors.surfaceLight
    pauseBtn.Visible = true
    pauseBtn.Text = "⏸ PAUSE"
    pauseBtn.BackgroundColor3 = colors.warning
    
    local frameCount = 0
    recordConnection = RunService.Heartbeat:Connect(function()
        if not isRecording then
            recordConnection:Disconnect()
            return
        end
        
        if isPausedRecording then
            return
        end
        
        frameCount = frameCount + 1
        local frameData = {
            position = serializeVector3(rootPart.CFrame.Position),
            rotation = serializeCFrame(rootPart.CFrame),
            velocity = serializeVector3(rootPart.Velocity),
            jumping = humanoid:GetState() == Enum.HumanoidStateType.Jumping or humanoid:GetState() == Enum.HumanoidStateType.Freefall,
            moveDirection = serializeVector3(humanoid.MoveDirection)
        }
        table.insert(currentRecording.frames, frameData)
        
        if frameCount % 10 == 0 then
            updateStatus("Merekam... Frame: " .. frameCount, colors.danger)
        end
    end)
end

local function togglePauseRecording()
    if isRecording then
        isPausedRecording = not isPausedRecording
        
        if isPausedRecording then
            pauseBtn.Text = "▶ LANJUT"
            pauseBtn.BackgroundColor3 = colors.success
            updateStatus("Rekaman di-pause", colors.warning)
        else
            pauseBtn.Text = "⏸ PAUSE"
            pauseBtn.BackgroundColor3 = colors.warning
            updateStatus("Merekam... Frame: " .. #currentRecording.frames, colors.danger)
        end
    elseif isPlaying then
        isPausedPlaying = not isPausedPlaying
        
        if isPausedPlaying then
            pauseBtn.Text = "▶ LANJUT"
            pauseBtn.BackgroundColor3 = colors.success
            updateStatus("Playback di-pause", colors.warning)
        else
            pauseBtn.Text = "⏸ PAUSE"
            pauseBtn.BackgroundColor3 = colors.warning
            updateStatus("Memutar...", colors.accent)
        end
    end
end

local function stopRecording()
    if isRecording then
        isRecording = false
        isPausedRecording = false
        
        if recordConnection then
            recordConnection:Disconnect()
        end
        
        if #currentRecording.frames > 0 then
            table.insert(recordings, currentRecording)
            saveRecordings()
            refreshRecordingsList()
            updateStatus("Rekaman tersimpan: " .. #currentRecording.frames .. " frame", colors.success)
        else
            updateStatus("Rekaman kosong", colors.warning)
        end
        
        recordBtn.BackgroundColor3 = colors.danger
        pauseBtn.Visible = false
        nameInput.Text = ""
    end
    
    if isPlaying then
        isPlaying = false
        isPausedPlaying = false
        if playConnection then
            playConnection:Disconnect()
        end
        pauseBtn.Visible = false
        updateStatus("Pemutaran dihentikan", colors.warning)
    end
    
    if isAutoRepeat then
        isAutoRepeat = false
        autoRepeatBtn.BackgroundColor3 = colors.accent
        autoRepeatBtn.Text = "🔁 AUTO PLAY"
    end
end

function playRecording(rec)
    if isRecording or isPlaying then
        return
    end
    
    isPlaying = true
    isPausedPlaying = false
    pausedFrameIndex = 1
    
    character = player.Character
    if not character then
        return
    end
    
    humanoid = character:FindFirstChild("Humanoid")
    rootPart = character:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not rootPart then
        isPlaying = false
        return
    end
    
    pauseBtn.Visible = true
    pauseBtn.Text = "⏸ PAUSE"
    pauseBtn.BackgroundColor3 = colors.warning
    updateStatus("Memulai: " .. rec.name, colors.accent)
    
    rootPart.CFrame = deserializeCFrame(rec.startPosition)
    wait(0.1)
    
    playConnection = RunService.Heartbeat:Connect(function()
        character = player.Character
        if not character then
            playConnection:Disconnect()
            isPlaying = false
            pauseBtn.Visible = false
            return
        end
        
        humanoid = character:FindFirstChild("Humanoid")
        rootPart = character:FindFirstChild("HumanoidRootPart")
        
        if not isPlaying or pausedFrameIndex > #rec.frames or not humanoid or not rootPart then
            playConnection:Disconnect()
            isPlaying = false
            pauseBtn.Visible = false
            if humanoid and rootPart then
                humanoid:MoveTo(rootPart.Position)
            end
            if not isAutoRepeat then
                updateStatus("Selesai", colors.success)
            end
            return
        end
        
        if isPausedPlaying then
            return
        end
        
        local frame = rec.frames[pausedFrameIndex]
        rootPart.CFrame = deserializeCFrame(frame.rotation)
        rootPart.Velocity = deserializeVector3(frame.velocity)
        
        if frame.jumping and humanoid:GetState() ~= Enum.HumanoidStateType.Jumping then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
        
        local moveDir = deserializeVector3(frame.moveDirection)
        if moveDir.Magnitude > 0 then
            humanoid:MoveTo(rootPart.Position + moveDir * 10)
        end
        
        pausedFrameIndex = pausedFrameIndex + 1
        
        if pausedFrameIndex % 30 == 0 then
            updateStatus("Memutar... " .. math.floor((pausedFrameIndex/#rec.frames)*100) .. "%", colors.accent)
        end
    end)
end

local function autoRepeatRecordings()
    if isRecording or isPlaying or #recordings == 0 then
        if #recordings == 0 then
            updateStatus("Tidak ada rekaman", colors.warning)
        end
        return
    end
    
    isAutoRepeat = true
    autoRepeatBtn.BackgroundColor3 = colors.danger
    autoRepeatBtn.Text = "⏹ STOP REPEAT"
    
    spawn(function()
        local loopCount = 0
        while isAutoRepeat do
            loopCount = loopCount + 1
            for i, rec in ipairs(recordings) do
                if not isAutoRepeat then
                    break
                end
                updateStatus("Loop " .. loopCount .. ": " .. rec.name, Color3.fromRGB(168, 85, 247))
                playRecording(rec)
                while isPlaying do
                    wait(0.1)
                end
                if not isAutoRepeat then
                    break
                end
                wait(1)
            end
            if not isAutoRepeat then
                break
            end
            wait(2)
        end
    end)
end

-- Button Events
recordBtn.MouseButton1Click:Connect(function()
    if not isRecording then
        startRecording()
    end
end)

pauseBtn.MouseButton1Click:Connect(function()
    togglePauseRecording()
end)

stopBtn.MouseButton1Click:Connect(function()
    stopRecording()
end)

autoRepeatBtn.MouseButton1Click:Connect(function()
    if isAutoRepeat then
        isAutoRepeat = false
        isPlaying = false
        autoRepeatBtn.BackgroundColor3 = colors.accent
        autoRepeatBtn.Text = "🔁 AUTO PLAY"
        updateStatus("Auto Play dihentikan", colors.warning)
    else
        autoRepeatRecordings()
    end
end)

closeBtn.MouseButton1Click:Connect(function()
    stopRecording()
    screenGui:Destroy()
end)

-- [[ BARU ]] Minimize dengan memory posisi
local isMinimized = false
minimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    
    if isMinimized then
        -- [[ BARU ]] Simpan posisi terakhir sebelum minimize
        savedPosition = mainFrame.Position
        
        -- [[ BARU ]] Hapus stroke dari mainFrame
        for _, child in ipairs(mainFrame:GetChildren()) do
            if child:IsA("UIStroke") then
                child:Destroy()
            end
        end
        
        -- Langsung sembunyikan tanpa animasi
        contentFrame.Visible = false
        topBar.Visible = false
        mainFrame.Size = UDim2.new(0, 45, 0, 45)
        mainFrame.Position = UDim2.new(0, 15, 0.5, -22.5)
        mainFrame.Draggable = false
        mainFrame.BackgroundColor3 = colors.surfaceLight -- [[ BARU ]] Buat lebih gelap
        mainCorner.CornerRadius = UDim.new(1, 0)
        
        local cameraBtn = Instance.new("TextButton")
        cameraBtn.Name = "CameraButton"
        cameraBtn.Size = UDim2.new(1, 0, 1, 0)
        cameraBtn.BackgroundColor3 = colors.surfaceLight -- [[ BARU ]] Background gelap
        cameraBtn.BackgroundTransparency = 0 -- [[ BARU ]] Pastikan tidak transparan
        cameraBtn.Text = "🎥"
        cameraBtn.TextColor3 = colors.text -- [[ BARU ]] Warna text sesuai scheme
        cameraBtn.TextSize = 27
        cameraBtn.Font = Enum.Font.GothamBold
        cameraBtn.BorderSizePixel = 0
        cameraBtn.Parent = mainFrame
        
        -- [[ BARU ]] Tambahkan corner untuk button agar bulat
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(1, 0)
        btnCorner.Parent = cameraBtn
        
        cameraBtn.MouseButton1Click:Connect(function()
            isMinimized = false
            cameraBtn:Destroy()
            mainCorner.CornerRadius = UDim.new(0, 12)
            mainFrame.Draggable = true
            mainFrame.BackgroundColor3 = colors.background -- [[ BARU ]] Kembalikan warna background
            -- [[ BARU ]] Kembalikan stroke ke mainFrame
            addStroke(mainFrame, colors.stroke, 2)
            -- Langsung tampilkan tanpa animasi
            mainFrame.Size = UDim2.new(0, 240, 0, 340)
            -- [[ BARU ]] Kembalikan ke posisi terakhir yang disimpan
            if savedPosition then
                mainFrame.Position = savedPosition
            else
                mainFrame.Position = UDim2.new(0.5, -120, 0.5, -170)
            end
            contentFrame.Visible = true
            topBar.Visible = true
        end)
    end
end)

player.CharacterAdded:Connect(function(char)
    character = char
    humanoid = char:WaitForChild("Humanoid")
    rootPart = char:WaitForChild("HumanoidRootPart")
    
    if isRecording then
        isRecording = false
        isPausedRecording = false
        if recordConnection then
            recordConnection:Disconnect()
        end
        recordBtn.BackgroundColor3 = colors.danger
        pauseBtn.Visible = false
        updateStatus("Rekaman stop (Respawn)", colors.warning)
    end
    
    if isAutoRepeat then
        updateStatus("Auto Play: Respawn...", Color3.fromRGB(168, 85, 247))
    end
end)

-- Close reorder frames when clicking outside
UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        closeAllReorderFrames()
    end
end)

-- Initialize
loadRecordings()
refreshRecordingsList()
updateStatus("Siap", colors.success)
