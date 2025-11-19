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
local currentFrameIndex = 0
local showRecordingsList = false
local isMinimized = false

-- Color Scheme
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
    buttonDark = Color3.fromRGB(35, 35, 45),
}

-- Helper functions
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

local function saveRecordings()
    local encoded = HttpService:JSONEncode(recordings)
    writefile(fileName, encoded)
    print("Recordings saved to", fileName)
end

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

-- Toggle Button
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.new(0, 44, 0, 44)
toggleButton.Position = UDim2.new(0, 15, 0.5, -22)
toggleButton.BackgroundColor3 = colors.buttonDark
toggleButton.Text = "🎥"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextSize = 24
toggleButton.Font = Enum.Font.GothamBold
toggleButton.BorderSizePixel = 0
toggleButton.Parent = screenGui

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 10)
toggleCorner.Parent = toggleButton

addStroke(toggleButton, Color3.fromRGB(60, 60, 70), 2)

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 220, 0, 210)
mainFrame.Position = UDim2.new(0.5, -110, 0.5, -105)
mainFrame.BackgroundColor3 = colors.background
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Visible = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = mainFrame

addStroke(mainFrame, colors.stroke, 2)

-- Top Bar
local topBar = Instance.new("Frame")
topBar.Name = "TopBar"
topBar.Size = UDim2.new(1, 0, 0, 24)
topBar.BackgroundColor3 = colors.surface
topBar.BorderSizePixel = 0
topBar.Parent = mainFrame

local topCorner = Instance.new("UICorner")
topCorner.CornerRadius = UDim.new(0, 10)
topCorner.Parent = topBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -30, 1, 0)
titleLabel.Position = UDim2.new(0, 8, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "SIEXTHER AUTO WALK"
titleLabel.TextColor3 = colors.accent
titleLabel.TextSize = 10
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = topBar

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Name = "CloseBtn"
closeBtn.Size = UDim2.new(0, 20, 0, 20)
closeBtn.Position = UDim2.new(1, -20, 0, 2)
closeBtn.BackgroundColor3 = colors.danger
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 10
closeBtn.Font = Enum.Font.GothamBold
closeBtn.BorderSizePixel = 0
closeBtn.Parent = topBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 5)
closeCorner.Parent = closeBtn

-- Content Frame
local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1, -12, 1, -28)
contentFrame.Position = UDim2.new(0, 6, 0, 26)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- Recording Name Input
local nameLabel = Instance.new("TextLabel")
nameLabel.Size = UDim2.new(1, 0, 0, 14)
nameLabel.Position = UDim2.new(0, 0, 0, 0)
nameLabel.BackgroundTransparency = 1
nameLabel.Text = "Nama Rekaman:"
nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
nameLabel.TextSize = 8
nameLabel.Font = Enum.Font.Gotham
nameLabel.TextXAlignment = Enum.TextXAlignment.Left
nameLabel.Parent = contentFrame

local nameInput = Instance.new("TextBox")
nameInput.Size = UDim2.new(1, 0, 0, 22)
nameInput.Position = UDim2.new(0, 0, 0, 16)
nameInput.BackgroundColor3 = colors.surface
nameInput.Text = ""
nameInput.PlaceholderText = "Masukkan nama..."
nameInput.PlaceholderColor3 = colors.textDim
nameInput.TextColor3 = colors.text
nameInput.TextSize = 8
nameInput.Font = Enum.Font.Gotham
nameInput.BorderSizePixel = 0
nameInput.Parent = contentFrame

local nameCorner = Instance.new("UICorner")
nameCorner.CornerRadius = UDim.new(0, 5)
nameCorner.Parent = nameInput

-- Status Label
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0, 18)
statusLabel.Position = UDim2.new(0, 0, 0, 40)
statusLabel.BackgroundColor3 = colors.surface
statusLabel.Text = "Status: Siap"
statusLabel.TextColor3 = colors.success
statusLabel.TextSize = 8
statusLabel.Font = Enum.Font.GothamBold
statusLabel.BorderSizePixel = 0
statusLabel.Parent = contentFrame

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 5)
statusCorner.Parent = statusLabel

-- Record Button
local recordBtn = Instance.new("TextButton")
recordBtn.Size = UDim2.new(0.31, -2, 0, 26)
recordBtn.Position = UDim2.new(0, 0, 0, 60)
recordBtn.BackgroundColor3 = colors.danger
recordBtn.Text = "🔴 REC"
recordBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
recordBtn.TextSize = 8
recordBtn.Font = Enum.Font.GothamBold
recordBtn.BorderSizePixel = 0
recordBtn.Parent = contentFrame

local recordCorner = Instance.new("UICorner")
recordCorner.CornerRadius = UDim.new(0, 5)
recordCorner.Parent = recordBtn

-- Pause Button
local pauseBtn = Instance.new("TextButton")
pauseBtn.Size = UDim2.new(0.31, -2, 0, 26)
pauseBtn.Position = UDim2.new(0.34, 0, 0, 60)
pauseBtn.BackgroundColor3 = colors.warning
pauseBtn.Text = "⏸"
pauseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
pauseBtn.TextSize = 10
pauseBtn.Font = Enum.Font.GothamBold
pauseBtn.Visible = false
pauseBtn.BorderSizePixel = 0
pauseBtn.Parent = contentFrame

local pauseCorner = Instance.new("UICorner")
pauseCorner.CornerRadius = UDim.new(0, 5)
pauseCorner.Parent = pauseBtn

-- Stop Button
local stopBtn = Instance.new("TextButton")
stopBtn.Size = UDim2.new(0.31, -2, 0, 26)
stopBtn.Position = UDim2.new(0.68, 0, 0, 60)
stopBtn.BackgroundColor3 = colors.surfaceLight
stopBtn.Text = "⏹"
stopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
stopBtn.TextSize = 10
stopBtn.Font = Enum.Font.GothamBold
stopBtn.BorderSizePixel = 0
stopBtn.Parent = contentFrame

local stopCorner = Instance.new("UICorner")
stopCorner.CornerRadius = UDim.new(0, 5)
stopCorner.Parent = stopBtn

-- Frame Navigation Container
local navContainer = Instance.new("Frame")
navContainer.Name = "NavContainer"
navContainer.Size = UDim2.new(1, 0, 0, 26)
navContainer.Position = UDim2.new(0, 0, 0, 88)
navContainer.BackgroundTransparency = 1
navContainer.Visible = false
navContainer.Parent = contentFrame

-- Previous Button
local prevBtn = Instance.new("TextButton")
prevBtn.Size = UDim2.new(0.48, -2, 1, 0)
prevBtn.Position = UDim2.new(0, 0, 0, 0)
prevBtn.BackgroundColor3 = colors.accentDark
prevBtn.Text = "⏮"
prevBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
prevBtn.TextSize = 10
prevBtn.Font = Enum.Font.GothamBold
prevBtn.BorderSizePixel = 0
prevBtn.Parent = navContainer

local prevCorner = Instance.new("UICorner")
prevCorner.CornerRadius = UDim.new(0, 5)
prevCorner.Parent = prevBtn

-- Next Button
local nextBtn = Instance.new("TextButton")
nextBtn.Size = UDim2.new(0.48, -2, 1, 0)
nextBtn.Position = UDim2.new(0.52, 0, 0, 0)
nextBtn.BackgroundColor3 = colors.accentDark
nextBtn.Text = "⏭"
nextBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
nextBtn.TextSize = 10
nextBtn.Font = Enum.Font.GothamBold
nextBtn.BorderSizePixel = 0
nextBtn.Parent = navContainer

local nextCorner = Instance.new("UICorner")
nextCorner.CornerRadius = UDim.new(0, 5)
nextCorner.Parent = nextBtn

-- Auto Repeat Button
local autoRepeatBtn = Instance.new("TextButton")
autoRepeatBtn.Size = UDim2.new(1, 0, 0, 26)
autoRepeatBtn.Position = UDim2.new(0, 0, 0, 116)
autoRepeatBtn.BackgroundColor3 = colors.accent
autoRepeatBtn.Text = "AUTO PLAY"
autoRepeatBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
autoRepeatBtn.TextSize = 9
autoRepeatBtn.Font = Enum.Font.GothamBold
autoRepeatBtn.BorderSizePixel = 0
autoRepeatBtn.Parent = contentFrame

local autoRepeatCorner = Instance.new("UICorner")
autoRepeatCorner.CornerRadius = UDim.new(0, 5)
autoRepeatCorner.Parent = autoRepeatBtn

-- Toggle List Button
local toggleListBtn = Instance.new("TextButton")
toggleListBtn.Size = UDim2.new(1, 0, 0, 26)
toggleListBtn.Position = UDim2.new(0, 0, 0, 144)
toggleListBtn.BackgroundColor3 = colors.surfaceLight
toggleListBtn.Text = "DAFTAR REKAMAN ▶"
toggleListBtn.TextColor3 = colors.text
toggleListBtn.TextSize = 9
toggleListBtn.Font = Enum.Font.GothamBold
toggleListBtn.BorderSizePixel = 0
toggleListBtn.Parent = contentFrame

local toggleListCorner = Instance.new("UICorner")
toggleListCorner.CornerRadius = UDim.new(0, 5)
toggleListCorner.Parent = toggleListBtn

-- Recordings List Frame
local recordingsListFrame = Instance.new("Frame")
recordingsListFrame.Name = "RecordingsListFrame"
recordingsListFrame.Size = UDim2.new(0, 220, 0, 210)
recordingsListFrame.Position = UDim2.new(1, 5, 0, 0)
recordingsListFrame.BackgroundColor3 = colors.background
recordingsListFrame.BorderSizePixel = 0
recordingsListFrame.Visible = false
recordingsListFrame.Parent = mainFrame

local listFrameCorner = Instance.new("UICorner")
listFrameCorner.CornerRadius = UDim.new(0, 10)
listFrameCorner.Parent = recordingsListFrame

addStroke(recordingsListFrame, colors.stroke, 2)

-- List Header
local listHeader = Instance.new("TextLabel")
listHeader.Size = UDim2.new(1, 0, 0, 20)
listHeader.Position = UDim2.new(0, 0, 0, 0)
listHeader.BackgroundColor3 = colors.surface
listHeader.Text = "Daftar Rekaman"
listHeader.TextColor3 = colors.accent
listHeader.TextSize = 9
listHeader.Font = Enum.Font.GothamBold
listHeader.BorderSizePixel = 0
listHeader.Parent = recordingsListFrame

local listHeaderCorner = Instance.new("UICorner")
listHeaderCorner.CornerRadius = UDim.new(0, 10)
listHeaderCorner.Parent = listHeader

-- Recordings ScrollFrame
local recordingsScroll = Instance.new("ScrollingFrame")
recordingsScroll.Size = UDim2.new(1, -12, 1, -26)
recordingsScroll.Position = UDim2.new(0, 6, 0, 22)
recordingsScroll.BackgroundColor3 = colors.surface
recordingsScroll.BorderSizePixel = 0
recordingsScroll.ScrollBarThickness = 3
recordingsScroll.ScrollBarImageColor3 = colors.accent
recordingsScroll.Parent = recordingsListFrame

local scrollCorner = Instance.new("UICorner")
scrollCorner.CornerRadius = UDim.new(0, 5)
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

local function jumpToFrame(targetIndex)
    if not isPausedRecording or #currentRecording.frames == 0 then
        return
    end
    
    targetIndex = math.clamp(targetIndex, 1, #currentRecording.frames)
    currentFrameIndex = targetIndex
    
    local frame = currentRecording.frames[targetIndex]
    if frame and rootPart then
        rootPart.CFrame = deserializeCFrame(frame.rotation)
        rootPart.Velocity = deserializeVector3(frame.velocity)
    end
    
    local framesToRemove = #currentRecording.frames - currentFrameIndex
    if framesToRemove > 0 then
        for i = 1, framesToRemove do
            table.remove(currentRecording.frames)
        end
    end
    
    updateStatus("Frame: " .. currentFrameIndex .. "/" .. #currentRecording.frames, colors.warning)
end

local function refreshRecordingsList()
    for _, child in ipairs(recordingsScroll:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end

    for i, rec in ipairs(recordings) do
        local recFrame = Instance.new("Frame")
        recFrame.Size = UDim2.new(1, -8, 0, 24)
        recFrame.BackgroundColor3 = colors.surfaceLight
        recFrame.BorderSizePixel = 0
        recFrame.Parent = recordingsScroll
        
        local recCorner = Instance.new("UICorner")
        recCorner.CornerRadius = UDim.new(0, 5)
        recCorner.Parent = recFrame

        local recLabel = Instance.new("TextLabel")
        recLabel.Size = UDim2.new(1, -110, 1, 0)
        recLabel.Position = UDim2.new(0, 4, 0, 0)
        recLabel.BackgroundTransparency = 1
        recLabel.Text = rec.name
        recLabel.TextColor3 = colors.text
        recLabel.TextSize = 7
        recLabel.Font = Enum.Font.Gotham
        recLabel.TextXAlignment = Enum.TextXAlignment.Left
        recLabel.TextTruncate = Enum.TextTruncate.AtEnd
        recLabel.Parent = recFrame

        -- Menu Button
        local menuBtn = Instance.new("TextButton")
        menuBtn.Size = UDim2.new(0, 22, 0, 16)
        menuBtn.Position = UDim2.new(1, -106, 0.5, -8)
        menuBtn.BackgroundColor3 = colors.surface
        menuBtn.Text = "↑↓"
        menuBtn.TextColor3 = colors.accent
        menuBtn.TextSize = 10
        menuBtn.Font = Enum.Font.GothamBold
        menuBtn.BorderSizePixel = 0
        menuBtn.Parent = recFrame

        local menuCorner = Instance.new("UICorner")
        menuCorner.CornerRadius = UDim.new(0, 4)
        menuCorner.Parent = menuBtn

        -- Reorder Frame
        local reorderFrame = Instance.new("Frame")
        reorderFrame.Name = "ReorderFrame"
        reorderFrame.Size = UDim2.new(0, 18, 0, 36)
        reorderFrame.Position = UDim2.new(1, -126, 0.5, -18)
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
        upBtn.Size = UDim2.new(1, 0, 0, 16)
        upBtn.Position = UDim2.new(0, 0, 0, 0)
        upBtn.BackgroundColor3 = colors.success
        upBtn.Text = "↑"
        upBtn.TextColor3 = colors.text
        upBtn.TextSize = 12
        upBtn.Font = Enum.Font.GothamBold
        upBtn.ZIndex = 11
        upBtn.BorderSizePixel = 0
        upBtn.Parent = reorderFrame

        local upCorner = Instance.new("UICorner")
        upCorner.CornerRadius = UDim.new(0, 3)
        upCorner.Parent = upBtn

        -- Down Button
        local downBtn = Instance.new("TextButton")
        downBtn.Size = UDim2.new(1, 0, 0, 16)
        downBtn.Position = UDim2.new(0, 0, 0, 18)
        downBtn.BackgroundColor3 = colors.danger
        downBtn.Text = "↓"
        downBtn.TextColor3 = colors.text
        downBtn.TextSize = 12
        downBtn.Font = Enum.Font.GothamBold
        downBtn.ZIndex = 11
        downBtn.BorderSizePixel = 0
        downBtn.Parent = reorderFrame

        local downCorner = Instance.new("UICorner")
        downCorner.CornerRadius = UDim.new(0, 3)
        downCorner.Parent = downBtn

        -- Play Button
        local playBtn = Instance.new("TextButton")
        playBtn.Size = UDim2.new(0, 38, 0, 16)
        playBtn.Position = UDim2.new(1, -82, 0.5, -8)
        playBtn.BackgroundColor3 = colors.success
        playBtn.Text = "▶"
        playBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        playBtn.TextSize = 9
        playBtn.Font = Enum.Font.GothamBold
        playBtn.BorderSizePixel = 0
        playBtn.Parent = recFrame

        local playCorner = Instance.new("UICorner")
        playCorner.CornerRadius = UDim.new(0, 4)
        playCorner.Parent = playBtn

        -- Delete Button
        local deleteBtn = Instance.new("TextButton")
        deleteBtn.Size = UDim2.new(0, 38, 0, 16)
        deleteBtn.Position = UDim2.new(1, -42, 0.5, -8)
        deleteBtn.BackgroundColor3 = colors.danger
        deleteBtn.Text = "✖"
        deleteBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        deleteBtn.TextSize = 9
        deleteBtn.Font = Enum.Font.GothamBold
        deleteBtn.BorderSizePixel = 0
        deleteBtn.Parent = recFrame

        local deleteCorner = Instance.new("UICorner")
        deleteCorner.CornerRadius = UDim.new(0, 4)
        deleteCorner.Parent = deleteBtn

        -- Events
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

        upBtn.MouseButton1Click:Connect(function()
            if i > 1 then
                local temp = recordings[i]
                recordings[i] = recordings[i - 1]
                recordings[i - 1] = temp
                saveRecordings()
                refreshRecordingsList()
                updateStatus("↑ Dinaikkan", colors.success)
            end
        end)

        downBtn.MouseButton1Click:Connect(function()
            if i < #recordings then
                local temp = recordings[i]
                recordings[i] = recordings[i + 1]
                recordings[i + 1] = temp
                saveRecordings()
                refreshRecordingsList()
                updateStatus("↓ Diturunkan", colors.success)
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
            updateStatus("Dihapus", colors.warning)
        end)
    end
    
    recordingsScroll.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 5)
end

local function startRecording()
    if nameInput.Text == "" then
        updateStatus("Masukkan nama!", colors.danger)
        return
    end
    
    isRecording = true
    isPausedRecording = false
    currentFrameIndex = 0
    currentRecording = {
        name = nameInput.Text,
        startPosition = serializeCFrame(rootPart.CFrame),
        frames = {}
    }
    updateStatus("Rekam... Frame: 0", colors.danger)
    recordBtn.BackgroundColor3 = colors.surfaceLight
    pauseBtn.Visible = true
    pauseBtn.Text = "⏸"
    pauseBtn.BackgroundColor3 = colors.warning
    navContainer.Visible = false
    
    recordConnection = RunService.Heartbeat:Connect(function()
        if not isRecording then
            recordConnection:Disconnect()
            return
        end
        
        if isPausedRecording then
            return
        end
        
        currentFrameIndex = currentFrameIndex + 1
        
        -- REKAM SEMUA TERMASUK STATE HUMANOID
        local currentState = humanoid:GetState()
        local frameData = {
            position = serializeVector3(rootPart.CFrame.Position),
            rotation = serializeCFrame(rootPart.CFrame),
            velocity = serializeVector3(rootPart.Velocity),
            humanoidState = currentState.Value -- Rekam state asli (jumping, running, dll)
        }
        table.insert(currentRecording.frames, frameData)
        
        if currentFrameIndex % 10 == 0 then
            updateStatus("Rekam... " .. currentFrameIndex, colors.danger)
        end
    end)
end

local function togglePauseRecording()
    if isRecording then
        isPausedRecording = not isPausedRecording
        
        if isPausedRecording then
            pauseBtn.Text = "▶"
            pauseBtn.BackgroundColor3 = colors.success
            navContainer.Visible = true
            updateStatus("Pause: " .. currentFrameIndex, colors.warning)
        else
            pauseBtn.Text = "⏸"
            pauseBtn.BackgroundColor3 = colors.warning
            navContainer.Visible = false
            updateStatus("Lanjut... " .. #currentRecording.frames, colors.danger)
        end
    elseif isPlaying then
        isPausedPlaying = not isPausedPlaying
        
        if isPausedPlaying then
            pauseBtn.Text = "▶"
            pauseBtn.BackgroundColor3 = colors.success
            updateStatus("Play Pause", colors.warning)
        else
            pauseBtn.Text = "⏸"
            pauseBtn.BackgroundColor3 = colors.warning
            updateStatus("Putar...", colors.accent)
        end
    end
end

local function stopRecording()
    if isRecording then
        isRecording = false
        isPausedRecording = false
        navContainer.Visible = false
        
        if recordConnection then
            recordConnection:Disconnect()
        end
        
        if #currentRecording.frames > 0 then
            table.insert(recordings, currentRecording)
            saveRecordings()
            refreshRecordingsList()
            updateStatus("Tersimpan: " .. #currentRecording.frames .. " frame", colors.success)
        else
            updateStatus("Kosong", colors.warning)
        end
        
        recordBtn.BackgroundColor3 = colors.danger
        pauseBtn.Visible = false
        nameInput.Text = ""
        currentFrameIndex = 0
    end
    
    if isPlaying then
        isPlaying = false
        isPausedPlaying = false
        if playConnection then
            playConnection:Disconnect()
        end
        pauseBtn.Visible = false
        updateStatus("Dihentikan", colors.warning)
    end
    
    if isAutoRepeat then
        isAutoRepeat = false
        autoRepeatBtn.BackgroundColor3 = colors.accent
        autoRepeatBtn.Text = "🔁 AUTO"
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
    pauseBtn.Text = "⏸"
    pauseBtn.BackgroundColor3 = colors.warning
    updateStatus("Mulai: " .. rec.name, colors.accent)
    
    -- Set posisi awal
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
            if not isAutoRepeat then
                updateStatus("Selesai", colors.success)
            end
            return
        end
        
        if isPausedPlaying then
            return
        end
        
        -- PUTAR PERSIS SEPERTI REKAMAN TERMASUK STATE
        local frame = rec.frames[pausedFrameIndex]
        rootPart.CFrame = deserializeCFrame(frame.rotation)
        rootPart.Velocity = deserializeVector3(frame.velocity)
        
        -- Terapkan state yang direkam (jump, running, dll)
        if frame.humanoidState then
            local targetState = Enum.HumanoidStateType:FromValue(frame.humanoidState)
            local currentState = humanoid:GetState()
            
            -- Hanya ubah state jika berbeda untuk menghindari flickering
            if currentState ~= targetState then
                humanoid:ChangeState(targetState)
            end
        end
        
        pausedFrameIndex = pausedFrameIndex + 1
        
        if pausedFrameIndex % 30 == 0 then
            updateStatus("Putar... " .. math.floor((pausedFrameIndex/#rec.frames)*100) .. "%", colors.accent)
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
    autoRepeatBtn.Text = "⏹ STOP"
    
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

-- Toggle Recordings List Function
local function toggleRecordingsList()
    showRecordingsList = not showRecordingsList
    recordingsListFrame.Visible = showRecordingsList
    
    if showRecordingsList then
        toggleListBtn.Text = "TUTUP ◀"
        toggleListBtn.BackgroundColor3 = colors.accent
    else
        toggleListBtn.Text = "DAFTAR REKAMAN ▶"
        toggleListBtn.BackgroundColor3 = colors.surfaceLight
    end
end

-- Toggle Main Frame Function
local function toggleMainFrame()
    isMinimized = not isMinimized
    mainFrame.Visible = not isMinimized
    
    if isMinimized then
        toggleButton.BackgroundColor3 = colors.surfaceLight
        recordingsListFrame.Visible = false
        showRecordingsList = false
    else
        toggleButton.BackgroundColor3 = colors.buttonDark
    end
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

prevBtn.MouseButton1Click:Connect(function()
    if isPausedRecording and currentFrameIndex > 1 then
        jumpToFrame(currentFrameIndex - 10)
    end
end)

nextBtn.MouseButton1Click:Connect(function()
    if isPausedRecording and currentFrameIndex < #currentRecording.frames then
        jumpToFrame(currentFrameIndex + 10)
    end
end)

autoRepeatBtn.MouseButton1Click:Connect(function()
    if isAutoRepeat then
        isAutoRepeat = false
        isPlaying = false
        autoRepeatBtn.BackgroundColor3 = colors.accent
        autoRepeatBtn.Text = "🔁 AUTO"
        updateStatus("Auto Stop", colors.warning)
    else
        autoRepeatRecordings()
    end
end)

toggleListBtn.MouseButton1Click:Connect(function()
    toggleRecordingsList()
end)

toggleButton.MouseButton1Click:Connect(function()
    toggleMainFrame()
end)

closeBtn.MouseButton1Click:Connect(function()
    stopRecording()
    screenGui:Destroy()
end)

player.CharacterAdded:Connect(function(char)
    character = char
    humanoid = char:WaitForChild("Humanoid")
    rootPart = char:WaitForChild("HumanoidRootPart")
    
    if isRecording then
        isRecording = false
        isPausedRecording = false
        navContainer.Visible = false
        if recordConnection then
            recordConnection:Disconnect()
        end
        recordBtn.BackgroundColor3 = colors.danger
        pauseBtn.Visible = false
        updateStatus("Stop (Respawn)", colors.warning)
    end
    
    if isAutoRepeat then
        updateStatus("Auto: Respawn...", Color3.fromRGB(168, 85, 247))
    end
end)

UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        closeAllReorderFrames()
    end
end)

-- Initialize
loadRecordings()
refreshRecordingsList()