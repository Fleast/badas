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
local savedPosition = nil  -- [[ BARU ]] Menyimpan posisi terakhir

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

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoWalkRecorder"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 240, 0, 340)  -- [[ DIUBAH ]] Diperkecil dari 260x380 menjadi 240x340
mainFrame.Position = UDim2.new(0.5, -120, 0.5, -170)  -- [[ DIUBAH ]] Disesuaikan dengan ukuran baru
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BackgroundTransparency = 0.15
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 8)  -- [[ DIUBAH ]] Diperkecil dari 10 menjadi 8
mainCorner.Parent = mainFrame

-- Top Bar
local topBar = Instance.new("Frame")
topBar.Name = "TopBar"
topBar.Size = UDim2.new(1, 0, 0, 26)  -- [[ DIUBAH ]] Diperkecil dari 28 menjadi 26
topBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
topBar.BackgroundTransparency = 0.15
topBar.BorderSizePixel = 0
topBar.Parent = mainFrame

local topCorner = Instance.new("UICorner")
topCorner.CornerRadius = UDim.new(0, 8)
topCorner.Parent = topBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -55, 1, 0)
titleLabel.Position = UDim2.new(0, 6, 0, 0)  -- [[ DIUBAH ]] Padding dikurangi
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "SIEXTHER AUTO WALK"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 11  -- [[ DIUBAH ]] Diperkecil dari 12
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = topBar

-- Minimize Button
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Name = "MinimizeBtn"
minimizeBtn.Size = UDim2.new(0, 22, 0, 22)  -- [[ DIUBAH ]] Diperkecil dari 24x24
minimizeBtn.Position = UDim2.new(1, -46, 0, 2)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
minimizeBtn.BackgroundTransparency = 0.15
minimizeBtn.Text = "−"
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.TextSize = 13  -- [[ DIUBAH ]] Diperkecil dari 14
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.Parent = topBar

local minimizeCorner = Instance.new("UICorner")
minimizeCorner.CornerRadius = UDim.new(0, 4)
minimizeCorner.Parent = minimizeBtn

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Name = "CloseBtn"
closeBtn.Size = UDim2.new(0, 22, 0, 22)  -- [[ DIUBAH ]] Diperkecil dari 24x24
closeBtn.Position = UDim2.new(1, -22, 0, 2)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.BackgroundTransparency = 0.15
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 11  -- [[ DIUBAH ]] Diperkecil dari 12
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = topBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 4)
closeCorner.Parent = closeBtn

-- Content Frame
local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1, -14, 1, -32)  -- [[ DIUBAH ]] Padding dikurangi
contentFrame.Position = UDim2.new(0, 7, 0, 29)  -- [[ DIUBAH ]] Posisi disesuaikan
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- Recording Name Input
local nameLabel = Instance.new("TextLabel")
nameLabel.Size = UDim2.new(1, 0, 0, 16)  -- [[ DIUBAH ]] Diperkecil dari 18
nameLabel.Position = UDim2.new(0, 0, 0, 0)
nameLabel.BackgroundTransparency = 1
nameLabel.Text = "Nama Rekaman:"
nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
nameLabel.TextSize = 9  -- [[ DIUBAH ]] Diperkecil dari 10
nameLabel.Font = Enum.Font.Gotham
nameLabel.TextXAlignment = Enum.TextXAlignment.Left
nameLabel.Parent = contentFrame

local nameInput = Instance.new("TextBox")
nameInput.Size = UDim2.new(1, 0, 0, 24)  -- [[ DIUBAH ]] Diperkecil dari 26
nameInput.Position = UDim2.new(0, 0, 0, 18)  -- [[ DIUBAH ]] Posisi disesuaikan
nameInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
nameInput.BackgroundTransparency = 0.15
nameInput.Text = ""
nameInput.PlaceholderText = "Masukkan nama..."
nameInput.TextColor3 = Color3.fromRGB(255, 255, 255)
nameInput.TextSize = 9  -- [[ DIUBAH ]] Diperkecil dari 10
nameInput.Font = Enum.Font.Gotham
nameInput.Parent = contentFrame

local nameCorner = Instance.new("UICorner")
nameCorner.CornerRadius = UDim.new(0, 4)
nameCorner.Parent = nameInput

-- Status Label
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0, 20)  -- [[ DIUBAH ]] Diperkecil dari 22
statusLabel.Position = UDim2.new(0, 0, 0, 45)  -- [[ DIUBAH ]] Posisi disesuaikan
statusLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
statusLabel.BackgroundTransparency = 0.15
statusLabel.Text = "Status: Siap"
statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
statusLabel.TextSize = 9  -- [[ DIUBAH ]] Diperkecil dari 10
statusLabel.Font = Enum.Font.GothamBold
statusLabel.Parent = contentFrame

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 4)
statusCorner.Parent = statusLabel

-- Record Button
local recordBtn = Instance.new("TextButton")
recordBtn.Size = UDim2.new(0.31, -2, 0, 28)  -- [[ DIUBAH ]] Diperkecil dari 30
recordBtn.Position = UDim2.new(0, 0, 0, 68)  -- [[ DIUBAH ]] Posisi disesuaikan
recordBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
recordBtn.BackgroundTransparency = 0.15
recordBtn.Text = "🔴 REKAM"
recordBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
recordBtn.TextSize = 9  -- [[ DIUBAH ]] Diperkecil dari 10
recordBtn.Font = Enum.Font.GothamBold
recordBtn.Parent = contentFrame

local recordCorner = Instance.new("UICorner")
recordCorner.CornerRadius = UDim.new(0, 6)
recordCorner.Parent = recordBtn

-- Pause Button
local pauseBtn = Instance.new("TextButton")
pauseBtn.Size = UDim2.new(0.31, -2, 0, 28)  -- [[ DIUBAH ]] Diperkecil dari 30
pauseBtn.Position = UDim2.new(0.34, 0, 0, 68)  -- [[ DIUBAH ]] Posisi disesuaikan
pauseBtn.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
pauseBtn.BackgroundTransparency = 0.15
pauseBtn.Text = "⏸ PAUSE"
pauseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
pauseBtn.TextSize = 9  -- [[ DIUBAH ]] Diperkecil dari 10
pauseBtn.Font = Enum.Font.GothamBold
pauseBtn.Visible = false
pauseBtn.Parent = contentFrame

local pauseCorner = Instance.new("UICorner")
pauseCorner.CornerRadius = UDim.new(0, 6)
pauseCorner.Parent = pauseBtn

-- Stop Button
local stopBtn = Instance.new("TextButton")
stopBtn.Size = UDim2.new(0.31, -2, 0, 28)  -- [[ DIUBAH ]] Diperkecil dari 30
stopBtn.Position = UDim2.new(0.68, 0, 0, 68)  -- [[ DIUBAH ]] Posisi disesuaikan
stopBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
stopBtn.BackgroundTransparency = 0.15
stopBtn.Text = "⏹ STOP"
stopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
stopBtn.TextSize = 9  -- [[ DIUBAH ]] Diperkecil dari 10
stopBtn.Font = Enum.Font.GothamBold
stopBtn.Parent = contentFrame

local stopCorner = Instance.new("UICorner")
stopCorner.CornerRadius = UDim.new(0, 6)
stopCorner.Parent = stopBtn

-- Auto Repeat Button
local autoRepeatBtn = Instance.new("TextButton")
autoRepeatBtn.Size = UDim2.new(1, 0, 0, 28)  -- [[ DIUBAH ]] Diperkecil dari 30
autoRepeatBtn.Position = UDim2.new(0, 0, 0, 99)  -- [[ DIUBAH ]] Posisi disesuaikan
autoRepeatBtn.BackgroundColor3 = Color3.fromRGB(135, 206, 250)
autoRepeatBtn.BackgroundTransparency = 0.15
autoRepeatBtn.Text = "🔁 AUTO PLAY"
autoRepeatBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
autoRepeatBtn.TextSize = 10  -- [[ DIUBAH ]] Diperkecil dari 11
autoRepeatBtn.Font = Enum.Font.GothamBold
autoRepeatBtn.Parent = contentFrame

local autoRepeatCorner = Instance.new("UICorner")
autoRepeatCorner.CornerRadius = UDim.new(0, 6)
autoRepeatCorner.Parent = autoRepeatBtn

-- Recordings List Label
local listLabel = Instance.new("TextLabel")
listLabel.Size = UDim2.new(1, 0, 0, 16)  -- [[ DIUBAH ]] Diperkecil dari 18
listLabel.Position = UDim2.new(0, 0, 0, 130)  -- [[ DIUBAH ]] Posisi disesuaikan
listLabel.BackgroundTransparency = 1
listLabel.Text = "Daftar Rekaman:"
listLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
listLabel.TextSize = 9  -- [[ DIUBAH ]] Diperkecil dari 10
listLabel.Font = Enum.Font.Gotham
listLabel.TextXAlignment = Enum.TextXAlignment.Left
listLabel.Parent = contentFrame

-- Recordings ScrollFrame
local recordingsScroll = Instance.new("ScrollingFrame")
recordingsScroll.Size = UDim2.new(1, 0, 0, 160)  -- [[ DIUBAH ]] Diperkecil dari 170
recordingsScroll.Position = UDim2.new(0, 0, 0, 149)  -- [[ DIUBAH ]] Posisi disesuaikan
recordingsScroll.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
recordingsScroll.BackgroundTransparency = 0.15
recordingsScroll.BorderSizePixel = 0
recordingsScroll.ScrollBarThickness = 3  -- [[ DIUBAH ]] Diperkecil dari 4
recordingsScroll.Parent = contentFrame

local scrollCorner = Instance.new("UICorner")
scrollCorner.CornerRadius = UDim.new(0, 4)
scrollCorner.Parent = recordingsScroll

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 3)  -- [[ DIUBAH ]] Diperkecil dari 4
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
        recFrame.Size = UDim2.new(1, -8, 0, 26)  -- [[ DIUBAH ]] Diperkecil dari 28
        recFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        recFrame.BackgroundTransparency = 0.15
        recFrame.Parent = recordingsScroll
        
        local recCorner = Instance.new("UICorner")
        recCorner.CornerRadius = UDim.new(0, 4)
        recCorner.Parent = recFrame

        local recLabel = Instance.new("TextLabel")
        recLabel.Size = UDim2.new(1, -125, 1, 0)  -- [[ DIUBAH ]] Disesuaikan
        recLabel.Position = UDim2.new(0, 5, 0, 0)
        recLabel.BackgroundTransparency = 1
        recLabel.Text = rec.name
        recLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        recLabel.TextSize = 8  -- [[ DIUBAH ]] Diperkecil dari 9
        recLabel.Font = Enum.Font.Gotham
        recLabel.TextXAlignment = Enum.TextXAlignment.Left
        recLabel.TextTruncate = Enum.TextTruncate.AtEnd
        recLabel.Parent = recFrame

        -- Menu Button
        local menuBtn = Instance.new("TextButton")
        menuBtn.Size = UDim2.new(0, 26, 0, 18)  -- [[ DIUBAH ]] Diperkecil dari 28x20
        menuBtn.Position = UDim2.new(1, -120, 0.5, -9)
        menuBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        menuBtn.BackgroundTransparency = 0.15
        menuBtn.Text = "↑↓"
        menuBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        menuBtn.TextSize = 11  -- [[ DIUBAH ]] Diperkecil dari 12
        menuBtn.Font = Enum.Font.GothamBold
        menuBtn.Parent = recFrame

        local menuCorner = Instance.new("UICorner")
        menuCorner.CornerRadius = UDim.new(0, 3)
        menuCorner.Parent = menuBtn

        -- Reorder Frame
        local reorderFrame = Instance.new("Frame")
        reorderFrame.Name = "ReorderFrame"
        reorderFrame.Size = UDim2.new(0, 20, 0, 40)  -- [[ DIUBAH ]] Diperkecil dari 22x44
        reorderFrame.Position = UDim2.new(1, -142, 0.5, -20)
        reorderFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        reorderFrame.BackgroundTransparency = 0.15
        reorderFrame.BorderSizePixel = 1
        reorderFrame.BorderColor3 = Color3.fromRGB(100, 100, 100)
        reorderFrame.Visible = false
        reorderFrame.ZIndex = 10
        reorderFrame.Parent = recFrame

        local reorderCorner = Instance.new("UICorner")
        reorderCorner.CornerRadius = UDim.new(0, 3)
        reorderCorner.Parent = reorderFrame

        -- Up Button
        local upBtn = Instance.new("TextButton")
        upBtn.Size = UDim2.new(1, 0, 0, 18)  -- [[ DIUBAH ]] Diperkecil dari 20
        upBtn.Position = UDim2.new(0, 0, 0, 0)
        upBtn.BackgroundColor3 = Color3.fromRGB(70, 120, 70)
        upBtn.BackgroundTransparency = 0.15
        upBtn.Text = "↑"
        upBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        upBtn.TextSize = 13  -- [[ DIUBAH ]] Diperkecil dari 14
        upBtn.Font = Enum.Font.GothamBold
        upBtn.ZIndex = 11
        upBtn.Parent = reorderFrame

        local upCorner = Instance.new("UICorner")
        upCorner.CornerRadius = UDim.new(0, 2)
        upCorner.Parent = upBtn

        -- Down Button
        local downBtn = Instance.new("TextButton")
        downBtn.Size = UDim2.new(1, 0, 0, 18)  -- [[ DIUBAH ]] Diperkecil dari 20
        downBtn.Position = UDim2.new(0, 0, 0, 20)  -- [[ DIUBAH ]] Posisi disesuaikan
        downBtn.BackgroundColor3 = Color3.fromRGB(120, 70, 70)
        downBtn.BackgroundTransparency = 0.15
        downBtn.Text = "↓"
        downBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        downBtn.TextSize = 13  -- [[ DIUBAH ]] Diperkecil dari 14
        downBtn.Font = Enum.Font.GothamBold
        downBtn.ZIndex = 11
        downBtn.Parent = reorderFrame

        local downCorner = Instance.new("UICorner")
        downCorner.CornerRadius = UDim.new(0, 2)
        downCorner.Parent = downBtn

        -- Play Button
        local playBtn = Instance.new("TextButton")
        playBtn.Size = UDim2.new(0, 44, 0, 18)  -- [[ DIUBAH ]] Diperkecil dari 48x20
        playBtn.Position = UDim2.new(1, -92, 0.5, -9)
        playBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
        playBtn.BackgroundTransparency = 0.15
        playBtn.Text = "▶ Play"
        playBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        playBtn.TextSize = 8  -- [[ DIUBAH ]] Diperkecil dari 9
        playBtn.Font = Enum.Font.GothamBold
        playBtn.Parent = recFrame

        local playCorner = Instance.new("UICorner")
        playCorner.CornerRadius = UDim.new(0, 3)
        playCorner.Parent = playBtn

        -- Delete Button
        local deleteBtn = Instance.new("TextButton")
        deleteBtn.Size = UDim2.new(0, 44, 0, 18)  -- [[ DIUBAH ]] Diperkecil dari 48x20
        deleteBtn.Position = UDim2.new(1, -46, 0.5, -9)
        deleteBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
        deleteBtn.BackgroundTransparency = 0.15
        deleteBtn.Text = "🗑 Hapus"
        deleteBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        deleteBtn.TextSize = 8  -- [[ DIUBAH ]] Diperkecil dari 9
        deleteBtn.Font = Enum.Font.GothamBold
        deleteBtn.Parent = recFrame

        local deleteCorner = Instance.new("UICorner")
        deleteCorner.CornerRadius = UDim.new(0, 3)
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
                updateStatus("Rekaman dinaikkan", Color3.fromRGB(100, 255, 100))
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
                updateStatus("Rekaman diturunkan", Color3.fromRGB(100, 255, 100))
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
            updateStatus("Rekaman dihapus", Color3.fromRGB(255, 200, 50))
        end)
    end
    
    recordingsScroll.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 5)
end

local function startRecording()
    if nameInput.Text == "" then
        updateStatus("Masukkan nama rekaman!", Color3.fromRGB(255, 100, 100))
        return
    end
    
    isRecording = true
    isPausedRecording = false
    currentRecording = {
        name = nameInput.Text,
        startPosition = serializeCFrame(rootPart.CFrame),
        frames = {}
    }
    updateStatus("Merekam... Frame: 0", Color3.fromRGB(255, 100, 100))
    recordBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    pauseBtn.Visible = true
    pauseBtn.Text = "⏸ PAUSE"
    pauseBtn.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
    
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
            updateStatus("Merekam... Frame: " .. frameCount, Color3.fromRGB(255, 100, 100))
        end
    end)
end

local function togglePauseRecording()
    if isRecording then
        isPausedRecording = not isPausedRecording
        
        if isPausedRecording then
            pauseBtn.Text = "▶ LANJUT"
            pauseBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
            updateStatus("Rekaman di-pause", Color3.fromRGB(255, 200, 50))
        else
            pauseBtn.Text = "⏸ PAUSE"
            pauseBtn.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
            updateStatus("Merekam... Frame: " .. #currentRecording.frames, Color3.fromRGB(255, 100, 100))
        end
    elseif isPlaying then
        isPausedPlaying = not isPausedPlaying
        
        if isPausedPlaying then
            pauseBtn.Text = "▶ LANJUT"
            pauseBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
            updateStatus("Playback di-pause", Color3.fromRGB(255, 200, 50))
        else
            pauseBtn.Text = "⏸ PAUSE"
            pauseBtn.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
            updateStatus("Memutar...", Color3.fromRGB(100, 200, 255))
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
            updateStatus("Rekaman tersimpan: " .. #currentRecording.frames .. " frame", Color3.fromRGB(100, 255, 100))
        else
            updateStatus("Rekaman kosong", Color3.fromRGB(255, 200, 50))
        end
        
        recordBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
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
        updateStatus("Pemutaran dihentikan", Color3.fromRGB(255, 200, 50))
    end
    
    if isAutoRepeat then
        isAutoRepeat = false
        autoRepeatBtn.BackgroundColor3 = Color3.fromRGB(135, 206, 250)
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
    pauseBtn.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
    updateStatus("Memulai: " .. rec.name, Color3.fromRGB(100, 200, 255))
    
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
                updateStatus("Selesai", Color3.fromRGB(100, 255, 100))
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
            updateStatus("Memutar... " .. math.floor((pausedFrameIndex/#rec.frames)*100) .. "%", Color3.fromRGB(100, 200, 255))
        end
    end)
end

local function autoRepeatRecordings()
    if isRecording or isPlaying or #recordings == 0 then
        if #recordings == 0 then
            updateStatus("Tidak ada rekaman", Color3.fromRGB(255, 200, 50))
        end
        return
    end
    
    isAutoRepeat = true
    autoRepeatBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    autoRepeatBtn.Text = "⏹ STOP REPEAT"
    
    spawn(function()
        local loopCount = 0
        while isAutoRepeat do
            loopCount = loopCount + 1
            for i, rec in ipairs(recordings) do
                if not isAutoRepeat then
                    break
                end
                updateStatus("Loop " .. loopCount .. ": " .. rec.name, Color3.fromRGB(200, 100, 255))
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
        autoRepeatBtn.BackgroundColor3 = Color3.fromRGB(135, 206, 250)
        autoRepeatBtn.Text = "🔁 AUTO PLAY"
        updateStatus("Auto Play dihentikan", Color3.fromRGB(255, 200, 50))
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
        
        -- Langsung sembunyikan tanpa animasi
        contentFrame.Visible = false
        topBar.Visible = false
        mainFrame.Size = UDim2.new(0, 45, 0, 45)  -- [[ DIUBAH ]] Diperkecil dari 50x50
        mainFrame.Position = UDim2.new(0, 15, 0.5, -22.5)  -- [[ DIUBAH ]] Posisi disesuaikan
        mainFrame.Draggable = false
        mainCorner.CornerRadius = UDim.new(1, 0)
        
        local cameraBtn = Instance.new("TextButton")
        cameraBtn.Name = "CameraButton"
        cameraBtn.Size = UDim2.new(1, 0, 1, 0)
        cameraBtn.BackgroundTransparency = 1
        cameraBtn.Text = "🎥"
        cameraBtn.TextSize = 24  -- [[ DIUBAH ]] Diperkecil dari 28
        cameraBtn.Font = Enum.Font.GothamBold
        cameraBtn.Parent = mainFrame
        
        cameraBtn.MouseButton1Click:Connect(function()
            isMinimized = false
            cameraBtn:Destroy()
            mainCorner.CornerRadius = UDim.new(0, 8)
            mainFrame.Draggable = true
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
        recordBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        pauseBtn.Visible = false
        updateStatus("Rekaman stop (Respawn)", Color3.fromRGB(255, 200, 50))
    end
    
    if isAutoRepeat then
        updateStatus("Auto Play: Respawn...", Color3.fromRGB(200, 100, 255))
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
updateStatus("Siap", Color3.fromRGB(100, 255, 100))