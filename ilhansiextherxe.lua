local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Variables
local isRecording = false
local isPlaying = false
local isAutoRepeat = false
local currentRecording = {}
local recordings = {}
local recordingName = ""
local fileName = "ilhansiexther.json"

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
mainFrame.Size = UDim2.new(0, 320, 0, 420)
mainFrame.Position = UDim2.new(0.5, -160, 0.5, -210)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = mainFrame

-- Top Bar
local topBar = Instance.new("Frame")
topBar.Name = "TopBar"
topBar.Size = UDim2.new(1, 0, 0, 30)
topBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
topBar.BorderSizePixel = 0
topBar.Parent = mainFrame

local topCorner = Instance.new("UICorner")
topCorner.CornerRadius = UDim.new(0, 10)
topCorner.Parent = topBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -70, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "SIEXTHER AUTO WALK"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 14
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = topBar

-- Minimize Button
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Name = "MinimizeBtn"
minimizeBtn.Size = UDim2.new(0, 25, 0, 25)
minimizeBtn.Position = UDim2.new(1, -55, 0, 2.5)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
minimizeBtn.Text = "-"
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.TextSize = 18
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.Parent = topBar

local minimizeCorner = Instance.new("UICorner")
minimizeCorner.CornerRadius = UDim.new(0, 5)
minimizeCorner.Parent = minimizeBtn

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Name = "CloseBtn"
closeBtn.Size = UDim2.new(0, 25, 0, 25)
closeBtn.Position = UDim2.new(1, -27, 0, 2.5)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 14
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = topBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 5)
closeCorner.Parent = closeBtn

-- Content Frame
local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1, -20, 1, -40)
contentFrame.Position = UDim2.new(0, 10, 0, 35)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- Recording Name Input
local nameLabel = Instance.new("TextLabel")
nameLabel.Size = UDim2.new(1, 0, 0, 20)
nameLabel.Position = UDim2.new(0, 0, 0, 0)
nameLabel.BackgroundTransparency = 1
nameLabel.Text = "Nama Rekaman:"
nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
nameLabel.TextSize = 12
nameLabel.Font = Enum.Font.Gotham
nameLabel.TextXAlignment = Enum.TextXAlignment.Left
nameLabel.Parent = contentFrame

local nameInput = Instance.new("TextBox")
nameInput.Size = UDim2.new(1, 0, 0, 30)
nameInput.Position = UDim2.new(0, 0, 0, 25)
nameInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
nameInput.Text = ""
nameInput.PlaceholderText = "Masukkan nama rekaman..."
nameInput.TextColor3 = Color3.fromRGB(255, 255, 255)
nameInput.TextSize = 12
nameInput.Font = Enum.Font.Gotham
nameInput.Parent = contentFrame

local nameCorner = Instance.new("UICorner")
nameCorner.CornerRadius = UDim.new(0, 5)
nameCorner.Parent = nameInput

-- Status Label
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0, 25)
statusLabel.Position = UDim2.new(0, 0, 0, 63)
statusLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
statusLabel.Text = "Status: Siap"
statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
statusLabel.TextSize = 12
statusLabel.Font = Enum.Font.GothamBold
statusLabel.Parent = contentFrame

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 5)
statusCorner.Parent = statusLabel

-- Record Button
local recordBtn = Instance.new("TextButton")
recordBtn.Size = UDim2.new(0.48, 0, 0, 35)
recordBtn.Position = UDim2.new(0, 0, 0, 95)
recordBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
recordBtn.Text = "🔴 REKAM"
recordBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
recordBtn.TextSize = 14
recordBtn.Font = Enum.Font.GothamBold
recordBtn.Parent = contentFrame

local recordCorner = Instance.new("UICorner")
recordCorner.CornerRadius = UDim.new(0, 8)
recordCorner.Parent = recordBtn

-- Stop Button
local stopBtn = Instance.new("TextButton")
stopBtn.Size = UDim2.new(0.48, 0, 0, 35)
stopBtn.Position = UDim2.new(0.52, 0, 0, 95)
stopBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
stopBtn.Text = "⏹ STOP"
stopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
stopBtn.TextSize = 14
stopBtn.Font = Enum.Font.GothamBold
stopBtn.Parent = contentFrame

local stopCorner = Instance.new("UICorner")
stopCorner.CornerRadius = UDim.new(0, 8)
stopCorner.Parent = stopBtn

-- Auto Repeat Button (Centered, full width)
local autoRepeatBtn = Instance.new("TextButton")
autoRepeatBtn.Size = UDim2.new(1, 0, 0, 35)
autoRepeatBtn.Position = UDim2.new(0, 0, 0, 138)
autoRepeatBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 200)
autoRepeatBtn.Text = "🔁 AUTO PLAY"
autoRepeatBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
autoRepeatBtn.TextSize = 13
autoRepeatBtn.Font = Enum.Font.GothamBold
autoRepeatBtn.Parent = contentFrame

local autoRepeatCorner = Instance.new("UICorner")
autoRepeatCorner.CornerRadius = UDim.new(0, 8)
autoRepeatCorner.Parent = autoRepeatBtn

-- Recordings List Label
local listLabel = Instance.new("TextLabel")
listLabel.Size = UDim2.new(1, 0, 0, 20)
listLabel.Position = UDim2.new(0, 0, 0, 181)
listLabel.BackgroundTransparency = 1
listLabel.Text = "Daftar Rekaman:"
listLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
listLabel.TextSize = 12
listLabel.Font = Enum.Font.Gotham
listLabel.TextXAlignment = Enum.TextXAlignment.Left
listLabel.Parent = contentFrame

-- Recordings ScrollFrame
local recordingsScroll = Instance.new("ScrollingFrame")
recordingsScroll.Size = UDim2.new(1, 0, 0, 160)
recordingsScroll.Position = UDim2.new(0, 0, 0, 206)
recordingsScroll.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
recordingsScroll.BorderSizePixel = 0
recordingsScroll.ScrollBarThickness = 4
recordingsScroll.Parent = contentFrame

local scrollCorner = Instance.new("UICorner")
scrollCorner.CornerRadius = UDim.new(0, 5)
scrollCorner.Parent = recordingsScroll

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 5)
listLayout.Parent = recordingsScroll

-- Functions
local function updateStatus(text, color)
    statusLabel.Text = "Status: " .. text
    statusLabel.TextColor3 = color
end

local function refreshRecordingsList()
    for _, child in ipairs(recordingsScroll:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    for i, rec in ipairs(recordings) do
        local recFrame = Instance.new("Frame")
        recFrame.Size = UDim2.new(1, -10, 0, 32)
        recFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        recFrame.Parent = recordingsScroll
        
        local recCorner = Instance.new("UICorner")
        recCorner.CornerRadius = UDim.new(0, 5)
        recCorner.Parent = recFrame
        
        local recLabel = Instance.new("TextLabel")
        recLabel.Size = UDim2.new(0.5, 0, 1, 0)
        recLabel.Position = UDim2.new(0, 8, 0, 0)
        recLabel.BackgroundTransparency = 1
        recLabel.Text = rec.name
        recLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        recLabel.TextSize = 11
        recLabel.Font = Enum.Font.Gotham
        recLabel.TextXAlignment = Enum.TextXAlignment.Left
        recLabel.Parent = recFrame
        
        local playBtn = Instance.new("TextButton")
        playBtn.Size = UDim2.new(0, 55, 0, 22)
        playBtn.Position = UDim2.new(0.5, 3, 0.5, -11)
        playBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
        playBtn.Text = "▶ Play"
        playBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        playBtn.TextSize = 10
        playBtn.Font = Enum.Font.GothamBold
        playBtn.Parent = recFrame
        
        local playCorner = Instance.new("UICorner")
        playCorner.CornerRadius = UDim.new(0, 4)
        playCorner.Parent = playBtn
        
        local deleteBtn = Instance.new("TextButton")
        deleteBtn.Size = UDim2.new(0, 55, 0, 22)
        deleteBtn.Position = UDim2.new(1, -58, 0.5, -11)
        deleteBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
        deleteBtn.Text = "🗑 Hapus"
        deleteBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        deleteBtn.TextSize = 10
        deleteBtn.Font = Enum.Font.GothamBold
        deleteBtn.Parent = recFrame
        
        local deleteCorner = Instance.new("UICorner")
        deleteCorner.CornerRadius = UDim.new(0, 4)
        deleteCorner.Parent = deleteBtn
        
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
    currentRecording = {
        name = nameInput.Text,
        startPosition = serializeCFrame(rootPart.CFrame),
        frames = {}
    }
    
    updateStatus("Merekam... Frame: 0", Color3.fromRGB(255, 100, 100))
    recordBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    
    local frameCount = 0
    local recordConnection
    recordConnection = RunService.Heartbeat:Connect(function()
        if not isRecording then
            recordConnection:Disconnect()
            return
        end
        
        frameCount = frameCount + 1
        
        -- Properly serialize all data
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

local function stopRecording()
    if isRecording then
        isRecording = false
        
        if #currentRecording.frames > 0 then
            table.insert(recordings, currentRecording)
            saveRecordings()
            refreshRecordingsList()
            updateStatus("Rekaman tersimpan: " .. #currentRecording.frames .. " frame", Color3.fromRGB(100, 255, 100))
        else
            updateStatus("Rekaman kosong", Color3.fromRGB(255, 200, 50))
        end
        
        recordBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        nameInput.Text = ""
    end
    
    if isPlaying then
        isPlaying = false
        updateStatus("Pemutaran dihentikan", Color3.fromRGB(255, 200, 50))
    end
    
    if isAutoRepeat then
        isAutoRepeat = false
        autoRepeatBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 200)
        autoRepeatBtn.Text = "🔁 AUTO PLAY"
    end
end

function playRecording(rec)
    if isRecording or isPlaying then return end
    
    isPlaying = true
    
    -- Update character references in case of respawn
    character = player.Character
    if not character then return end
    humanoid = character:FindFirstChild("Humanoid")
    rootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not rootPart then 
        isPlaying = false
        return 
    end
    
    updateStatus("Memulai pemutaran: " .. rec.name, Color3.fromRGB(100, 200, 255))
    
    -- Teleport ke posisi awal (deserialize)
    rootPart.CFrame = deserializeCFrame(rec.startPosition)
    wait(0.1)
    
    local frameIndex = 1
    local playConnection
    
    playConnection = RunService.Heartbeat:Connect(function()
        -- Update character references during playback
        character = player.Character
        if not character then 
            playConnection:Disconnect()
            isPlaying = false
            return
        end
        humanoid = character:FindFirstChild("Humanoid")
        rootPart = character:FindFirstChild("HumanoidRootPart")
        
        if not isPlaying or frameIndex > #rec.frames or not humanoid or not rootPart then
            playConnection:Disconnect()
            isPlaying = false
            if humanoid and rootPart then
                humanoid:MoveTo(rootPart.Position)
            end
            
            -- Don't show "Pemutaran selesai" if auto repeat is active
            if not isAutoRepeat then
                updateStatus("Pemutaran selesai", Color3.fromRGB(100, 255, 100))
            end
            return
        end
        
        local frame = rec.frames[frameIndex]
        
        -- Deserialize and apply data
        rootPart.CFrame = deserializeCFrame(frame.rotation)
        rootPart.Velocity = deserializeVector3(frame.velocity)
        
        -- Handle jumping
        if frame.jumping and humanoid:GetState() ~= Enum.HumanoidStateType.Jumping then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
        
        -- Apply movement
        local moveDir = deserializeVector3(frame.moveDirection)
        if moveDir.Magnitude > 0 then
            humanoid:MoveTo(rootPart.Position + moveDir * 10)
        end
        
        frameIndex = frameIndex + 1
        
        if frameIndex % 30 == 0 then
            updateStatus("Memutar... " .. math.floor((frameIndex/#rec.frames)*100) .. "%", Color3.fromRGB(100, 200, 255))
        end
    end)
end

-- Auto Repeat Function (Infinite Loop - Doesn't stop on respawn)
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
        
        -- Infinite loop until manually stopped
        while isAutoRepeat do
            loopCount = loopCount + 1
            
            for i, rec in ipairs(recordings) do
                if not isAutoRepeat then break end
                
                -- Wait for character if respawned
                if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
                    updateStatus("Loop " .. loopCount .. ": Menunggu respawn...", Color3.fromRGB(255, 200, 100))
                    repeat wait(0.5) until player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                    wait(1) -- Extra wait after respawn
                end
                
                if not isAutoRepeat then break end
                
                updateStatus("Loop " .. loopCount .. ": " .. rec.name .. " (" .. i .. "/" .. #recordings .. ")", Color3.fromRGB(200, 100, 255))
                
                -- Play recording
                playRecording(rec)
                
                -- Wait until playback finishes
                while isPlaying do
                    wait(0.1)
                end
                
                -- Check again if auto repeat is still active
                if not isAutoRepeat then break end
                
                -- Wait 1 second before next recording
                wait(1)
            end
            
            -- Check if auto repeat is still active before continuing loop
            if not isAutoRepeat then break end
            
            -- Short pause before repeating entire sequence (2 seconds)
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

stopBtn.MouseButton1Click:Connect(function()
    stopRecording()
end)

-- Auto Repeat Button Event
autoRepeatBtn.MouseButton1Click:Connect(function()
    if isAutoRepeat then
        isAutoRepeat = false
        isPlaying = false
        autoRepeatBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 200)
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

local isMinimized = false
minimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    
    if isMinimized then
        mainFrame.Draggable = false
        contentFrame.Visible = false
        topBar.Visible = false
        
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        local goal = {
            Size = UDim2.new(0, 60, 0, 60),
            Position = UDim2.new(0, 20, 0.5, -30)
        }
        local tween = TweenService:Create(mainFrame, tweenInfo, goal)
        tween:Play()
        
        tween.Completed:Connect(function()
            mainCorner.CornerRadius = UDim.new(1, 0)
            
            local cameraBtn = Instance.new("TextButton")
            cameraBtn.Name = "CameraButton"
            cameraBtn.Size = UDim2.new(1, 0, 1, 0)
            cameraBtn.BackgroundTransparency = 1
            cameraBtn.Text = "🎥"
            cameraBtn.TextSize = 32
            cameraBtn.Font = Enum.Font.GothamBold
            cameraBtn.Parent = mainFrame
            
            cameraBtn.MouseButton1Click:Connect(function()
                isMinimized = false
                cameraBtn:Destroy()
                
                mainCorner.CornerRadius = UDim.new(0, 10)
                mainFrame.Draggable = true
                
                local tweenInfo2 = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
                local goal2 = {
                    Size = UDim2.new(0, 320, 0, 420),
                    Position = UDim2.new(0.5, -160, 0.5, -210)
                }
                local tween2 = TweenService:Create(mainFrame, tweenInfo2, goal2)
                tween2:Play()
                
                tween2.Completed:Connect(function()
                    contentFrame.Visible = true
                    topBar.Visible = true
                end)
            end)
        end)
    end
end)

-- Character respawn handling - UPDATE CHARACTER REFERENCES BUT DON'T STOP AUTO REPEAT
player.CharacterAdded:Connect(function(char)
    character = char
    humanoid = char:WaitForChild("Humanoid")
    rootPart = char:WaitForChild("HumanoidRootPart")
    
    -- Only stop recording if active, but DON'T stop auto repeat
    if isRecording then
        isRecording = false
        recordBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        updateStatus("Rekaman dihentikan (Respawn)", Color3.fromRGB(255, 200, 50))
    end
    
    -- Auto repeat will automatically continue after respawn
    if isAutoRepeat then
        updateStatus("Auto Play: Menunggu respawn selesai...", Color3.fromRGB(200, 100, 255))
    end
end)

-- Initialize
loadRecordings()
refreshRecordingsList()
updateStatus("Siap", Color3.fromRGB(100, 255, 100))
