local Screen = setmetatable({}, {
__index = function(_, key)
    local cam = workspace.CurrentCamera
    local size = cam and cam.ViewportSize or Vector2.new(1920, 1080)
    if key == "Width" then
        return size.X
    elseif key == "Height" then
        return size.Y
    elseif key == "Size" then
        return size
    end
end})

function scale(axis, value)
    if axis == "X" then
        return value * (Screen.Width / 1920)
    elseif axis == "Y" then
        return value * (Screen.Height / 1080)
    end
end

-- Services
cloneref = cloneref or function(...) return ... end
local Services = setmetatable({}, {
    __index = function(_, name)
        return cloneref(game:GetService(name))
    end
})

local Players = Services.Players
local RunService = Services.RunService
local TweenService = Services.TweenService

local player = Players.LocalPlayer

-- Music folder path
local MUSIC_FOLDER = "./IlhanSiexther"

-- Music player state
local musicList = {}
local currentIndex = 1
local currentSound = nil
local isPlaying = false
local isPaused = false
local isShuffleMode = false
local playedSongs = {}
local shufflePlaylist = {}

-- Helper functions
local function corner(parent, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r)
    c.Parent = parent
    return c
end

local function createGradient(parent, colors)
    local gradient = Instance.new("UIGradient")
    gradient.Color = colors
    gradient.Rotation = 90
    gradient.Parent = parent
    return gradient
end

-- Load music from folder
local function loadMusicList()
    musicList = {}
    
    local success, files = pcall(function()
        if not isfolder or not listfiles then
            return {}
        end
        
        if not isfolder(MUSIC_FOLDER) then
            makefolder(MUSIC_FOLDER)
        end
        
        return listfiles(MUSIC_FOLDER)
    end)
    
    if success and files then
        for _, filepath in ipairs(files) do
            local filename = filepath:match("([^/\\]+)$")
            if filename:match("%.mp3$") or filename:match("%.ogg$") or filename:match("%.wav$") then
                table.insert(musicList, {
                    name = filename:gsub("%.[^.]+$", ""),
                    path = filepath
                })
            end
        end
    end
    
    if #musicList == 0 then
        table.insert(musicList, {
            name = "No Music Found",
            path = nil
        })
    end
end

-- Create shuffle playlist
local function createShufflePlaylist()
    shufflePlaylist = {}
    local tempList = {}
    
    for i = 1, #musicList do
        table.insert(tempList, i)
    end
    
    for i = #tempList, 2, -1 do
        local j = math.random(1, i)
        tempList[i], tempList[j] = tempList[j], tempList[i]
    end
    
    shufflePlaylist = tempList
    playedSongs = {}
end

-- Get next index with improved shuffle
local function getNextIndex()
    if isShuffleMode then
        if #playedSongs >= #musicList then
            createShufflePlaylist()
        end
        
        for _, idx in ipairs(shufflePlaylist) do
            local alreadyPlayed = false
            for _, played in ipairs(playedSongs) do
                if played == idx then
                    alreadyPlayed = true
                    break
                end
            end
            
            if not alreadyPlayed then
                return idx
            end
        end
        
        createShufflePlaylist()
        return shufflePlaylist[1]
    else
        return currentIndex >= #musicList and 1 or currentIndex + 1
    end
end

-- === GUI ===
local CoreGui = Services.CoreGui
local gui = Instance.new("ScreenGui")
gui.Name = "IlhanSiextherMusicPlayer"
gui.Parent = CoreGui
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.ResetOnSpawn = false

-- Mini button (minimized state)
local miniBtn = Instance.new("TextButton")
miniBtn.Name = "MiniBtn"
miniBtn.Size = UDim2.new(0, scale("X", 60), 0, scale("Y", 60))
miniBtn.Position = UDim2.new(0.95, -scale("X", 60), 0.05, 0)
miniBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
miniBtn.Text = "🎵"
miniBtn.TextScaled = true
miniBtn.Font = Enum.Font.GothamBold
miniBtn.TextColor3 = Color3.new(1, 1, 1)
miniBtn.Visible = false
miniBtn.Active = true
miniBtn.Draggable = true
miniBtn.Parent = gui
miniBtn.ZIndex = 999
miniBtn.BorderSizePixel = 0
corner(miniBtn, 30)

-- Glow effect for mini button
local miniGlow = Instance.new("Frame")
miniGlow.Size = UDim2.new(1.4, 0, 1.4, 0)
miniGlow.Position = UDim2.new(-0.2, 0, -0.2, 0)
miniGlow.BackgroundColor3 = Color3.fromRGB(90, 90, 110)
miniGlow.BackgroundTransparency = 0.7
miniGlow.ZIndex = 998
miniGlow.BorderSizePixel = 0
miniGlow.Parent = miniBtn
corner(miniGlow, 42)

-- Main frame
local main = Instance.new("Frame")
main.Size = UDim2.new(0, scale("X", 400), 0, scale("Y", 560))
main.Position = UDim2.new(0.5, -scale("X", 200), 0.5, -scale("Y", 280))
main.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
main.Active = true
main.Draggable = true
main.Parent = gui
main.BorderSizePixel = 0
corner(main, 16)

createGradient(main, ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 35)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 20))
})

-- Title bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, scale("Y", 40))
titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
titleBar.Active = true
titleBar.Parent = main
titleBar.BorderSizePixel = 0
corner(titleBar, 14)

createGradient(titleBar, ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 55)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 25, 35))
})

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0.6, 0, 1, 0)
title.Position = UDim2.new(0, scale("X", 15), 0, 0)
title.BackgroundTransparency = 1
title.Text = "SIEXTHER MUSIC PLAYER"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = scale("Y", 14)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

-- Minimize button
local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, scale("X", 28), 0, scale("Y", 28))
minBtn.Position = UDim2.new(1, -scale("X", 68), 0.5, -scale("Y", 14))
minBtn.BackgroundColor3 = Color3.fromRGB(255, 180, 50)
minBtn.Text = "−"
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = scale("Y", 20)
minBtn.TextColor3 = Color3.new(1, 1, 1)
minBtn.BorderSizePixel = 0
minBtn.Parent = titleBar
corner(minBtn, 6)

-- Close button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, scale("X", 28), 0, scale("Y", 28))
closeBtn.Position = UDim2.new(1, -scale("X", 34), 0.5, -scale("Y", 14))
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
closeBtn.Text = "×"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = scale("Y", 22)
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.BorderSizePixel = 0
closeBtn.Parent = titleBar
corner(closeBtn, 6)

closeBtn.MouseButton1Click:Connect(function()
    if currentSound then
        currentSound:Stop()
        currentSound:Destroy()
    end
    gui:Destroy()
end)

-- Minimize functionality
local isMinimized = false
minBtn.MouseButton1Click:Connect(function()
    isMinimized = true
    main.Visible = false
    miniBtn.Visible = true
    miniBtn.Size = UDim2.new(0, 0, 0, 0)
    TweenService:Create(miniBtn, TweenInfo.new(0.3, Enum.EasingStyle.Back), 
        {Size = UDim2.new(0, scale("X", 60), 0, scale("Y", 60))}):Play()
end)

miniBtn.MouseButton1Click:Connect(function()
    isMinimized = false
    local tw = TweenService:Create(miniBtn, TweenInfo.new(0.2, Enum.EasingStyle.Back), 
        {Size = UDim2.new(0, 0, 0, 0)})
    tw.Completed:Connect(function()
        miniBtn.Visible = false
        main.Visible = true
    end)
    tw:Play()
end)

-- RGB Visualizer Container
local visualizerContainer = Instance.new("Frame")
visualizerContainer.Size = UDim2.new(1, -scale("X", 40), 0, scale("Y", 120))
visualizerContainer.Position = UDim2.new(0, scale("X", 20), 0, scale("Y", 60))
visualizerContainer.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
visualizerContainer.BorderSizePixel = 0
visualizerContainer.Parent = main
corner(visualizerContainer, 12)

-- Create visualizer bars
local bars = {}
local barCount = 20
for i = 1, barCount do
    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(1 / barCount, -scale("X", 2), 0, scale("Y", 10))
    bar.Position = UDim2.new((i - 1) / barCount, scale("X", 1), 1, -scale("Y", 10))
    bar.BackgroundColor3 = Color3.fromHSV(i / barCount, 1, 1)
    bar.BorderSizePixel = 0
    bar.AnchorPoint = Vector2.new(0, 1)
    bar.Parent = visualizerContainer
    corner(bar, 4)
    
    table.insert(bars, bar)
end

-- Album art / Animation display
local albumArt = Instance.new("Frame")
albumArt.Size = UDim2.new(0, scale("X", 150), 0, scale("Y", 150))
albumArt.Position = UDim2.new(0.5, -scale("X", 75), 0, scale("Y", 200))
albumArt.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
albumArt.BorderSizePixel = 0
albumArt.Parent = main
corner(albumArt, 75)

createGradient(albumArt, ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(60, 60, 80)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 30, 50))
})

local albumIcon = Instance.new("TextLabel")
albumIcon.Size = UDim2.new(1, 0, 1, 0)
albumIcon.BackgroundTransparency = 1
albumIcon.Text = "🎵"
albumIcon.TextScaled = true
albumIcon.Font = Enum.Font.GothamBold
albumIcon.TextColor3 = Color3.new(1, 1, 1)
albumIcon.Parent = albumArt

-- Song info
local songTitle = Instance.new("TextLabel")
songTitle.Size = UDim2.new(1, -scale("X", 40), 0, scale("Y", 30))
songTitle.Position = UDim2.new(0, scale("X", 20), 0, scale("Y", 370))
songTitle.BackgroundTransparency = 1
songTitle.Text = "No Song Playing"
songTitle.TextColor3 = Color3.new(1, 1, 1)
songTitle.Font = Enum.Font.GothamBold
songTitle.TextSize = scale("Y", 16)
songTitle.TextScaled = true
songTitle.Parent = main

local songArtist = Instance.new("TextLabel")
songArtist.Size = UDim2.new(1, -scale("X", 40), 0, scale("Y", 20))
songArtist.Position = UDim2.new(0, scale("X", 20), 0, scale("Y", 405))
songArtist.BackgroundTransparency = 1
songArtist.Text = "HANN.SIEXTHER"
songArtist.TextColor3 = Color3.fromRGB(180, 180, 180)
songArtist.Font = Enum.Font.Gotham
songArtist.TextSize = scale("Y", 12)
songArtist.Parent = main

-- Progress bar
local progressBg = Instance.new("Frame")
progressBg.Size = UDim2.new(1, -scale("X", 40), 0, scale("Y", 6))
progressBg.Position = UDim2.new(0, scale("X", 20), 0, scale("Y", 440))
progressBg.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
progressBg.BorderSizePixel = 0
progressBg.Parent = main
corner(progressBg, 3)

local progressBar = Instance.new("Frame")
progressBar.Size = UDim2.new(0, 0, 1, 0)
progressBar.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
progressBar.BorderSizePixel = 0
progressBar.Parent = progressBg
corner(progressBar, 3)

createGradient(progressBar, ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 100, 100)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(100, 255, 100)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 100, 255))
})

-- Time labels
local timeLabel = Instance.new("TextLabel")
timeLabel.Size = UDim2.new(0.5, 0, 0, scale("Y", 18))
timeLabel.Position = UDim2.new(0, scale("X", 20), 0, scale("Y", 450))
timeLabel.BackgroundTransparency = 1
timeLabel.Text = "0:00"
timeLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
timeLabel.Font = Enum.Font.Gotham
timeLabel.TextSize = scale("Y", 11)
timeLabel.TextXAlignment = Enum.TextXAlignment.Left
timeLabel.Parent = main

local durationLabel = Instance.new("TextLabel")
durationLabel.Size = UDim2.new(0.5, 0, 0, scale("Y", 18))
durationLabel.Position = UDim2.new(0.5, 0, 0, scale("Y", 450))
durationLabel.BackgroundTransparency = 1
durationLabel.Text = "0:00"
durationLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
durationLabel.Font = Enum.Font.Gotham
durationLabel.TextSize = scale("Y", 11)
durationLabel.TextXAlignment = Enum.TextXAlignment.Right
durationLabel.Parent = main

-- UNIFIED COLOR SCHEME FOR ALL BUTTONS
local BUTTON_COLOR_NORMAL = Color3.fromRGB(70, 70, 90)
local BUTTON_COLOR_ACTIVE = Color3.fromRGB(90, 90, 120)
local BUTTON_COLOR_PLAY = Color3.fromRGB(80, 100, 200)

local controlsFrame = Instance.new("Frame")
controlsFrame.Size = UDim2.new(1, -scale("X", 40), 0, scale("Y", 70))
controlsFrame.Position = UDim2.new(0, scale("X", 20), 0, scale("Y", 475))
controlsFrame.BackgroundTransparency = 1
controlsFrame.Parent = main

local function createControlButton(text, position, color, size)
    local btn = Instance.new("TextButton")
    btn.Size = size or UDim2.new(0, scale("X", 45), 0, scale("Y", 45))
    btn.Position = position
    btn.AnchorPoint = Vector2.new(0.5, 0.5)
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = scale("Y", 18)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.BorderSizePixel = 0
    btn.Parent = controlsFrame
    corner(btn, size and size.X.Offset / 2 or 22.5)
    
    createGradient(btn, ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.new(color.R * 1.2, color.G * 1.2, color.B * 1.2)),
        ColorSequenceKeypoint.new(1, color)
    })
    
    return btn
end

-- All buttons now use unified color scheme
local shuffleBtn = createControlButton("🔀", UDim2.new(0.1, 0, 0.5, 0), BUTTON_COLOR_NORMAL, UDim2.new(0, scale("X", 40), 0, scale("Y", 40)))
local prevBtn = createControlButton("⏮", UDim2.new(0.3, 0, 0.5, 0), BUTTON_COLOR_NORMAL)
local playPauseBtn = createControlButton("▶", UDim2.new(0.5, 0, 0.5, 0), BUTTON_COLOR_PLAY, UDim2.new(0, scale("X", 60), 0, scale("Y", 60)))
local nextBtn = createControlButton("⏭", UDim2.new(0.7, 0, 0.5, 0), BUTTON_COLOR_NORMAL)
local showPlaylistBtn = createControlButton("📋", UDim2.new(0.9, 0, 0.5, 0), BUTTON_COLOR_NORMAL, UDim2.new(0, scale("X", 40), 0, scale("Y", 40)))

-- Format time function
local function formatTime(seconds)
    local mins = math.floor(seconds / 60)
    local secs = math.floor(seconds % 60)
    return string.format("%d:%02d", mins, secs)
end

-- Play music function dengan audio realistis (Reverb, EQ, Compressor)
local function playMusic(index)
    if currentSound then
        currentSound:Stop()
        currentSound:Destroy()
    end
    
    currentIndex = index or currentIndex
    
    if currentIndex < 1 then
        currentIndex = #musicList
    elseif currentIndex > #musicList then
        currentIndex = 1
    end
    
    -- Track lagu yang sudah diputar
    if isShuffleMode then
        local alreadyInList = false
        for _, played in ipairs(playedSongs) do
            if played == currentIndex then
                alreadyInList = true
                break
            end
        end
        if not alreadyInList then
            table.insert(playedSongs, currentIndex)
        end
    end
    
    local music = musicList[currentIndex]
    
    if not music.path then
        songTitle.Text = "No Music Found"
        return
    end
    
    songTitle.Text = music.name
    
    -- Create sound group untuk efek audio
    local soundGroup = Instance.new("SoundGroup")
    soundGroup.Name = "MusicSoundGroup"
    soundGroup.Parent = Services.SoundService
    
    -- Reverb effect untuk suara bergema alami
    local reverb = Instance.new("ReverbSoundEffect")
    reverb.DryLevel = -6  -- Suara asli
    reverb.WetLevel = -3  -- Suara reverb (bergema)
    reverb.DecayTime = 2.5  -- Durasi gema
    reverb.Density = 0.8  -- Kepadatan gema
    reverb.Diffusion = 0.7  -- Penyebaran gema
    reverb.Parent = soundGroup
    
    -- Equalizer untuk kualitas audio lebih baik
    local eq = Instance.new("EqualizerSoundEffect")
    eq.HighGain = 2  -- Boost high frequencies
    eq.MidGain = 0   -- Keep mid balanced
    eq.LowGain = 4   -- Boost bass
    eq.Parent = soundGroup
    
    -- Compressor untuk volume stabil
    local compressor = Instance.new("CompressorSoundEffect")
    compressor.Threshold = -20  -- Level kompresi
    compressor.Ratio = 8        -- Rasio kompresi
    compressor.Attack = 0.01    -- Response time
    compressor.Release = 0.1    -- Recovery time
    compressor.GainMakeup = 6   -- Boost volume setelah kompresi
    compressor.Parent = soundGroup
    
    local sound = Instance.new("Sound")
    sound.Parent = workspace
    sound.SoundGroup = soundGroup
    
    local success = pcall(function()
        if getcustomasset then
            sound.SoundId = getcustomasset(music.path)
        else
            sound.SoundId = "rbxasset://" .. music.path
        end
    end)
    
    if not success then
        songTitle.Text = "Failed to load: " .. music.name
        soundGroup:Destroy()
        return
    end
    
    currentSound = sound
    sound.Volume = 0.6  -- Sedikit dinaikkan karena compressor
    sound.RollOffMode = Enum.RollOffMode.Linear
    sound.RollOffMinDistance = 50
    sound.RollOffMaxDistance = 500
    sound:Play()
    isPlaying = true
    isPaused = false
    playPauseBtn.Text = "⏸"
    
    sound.Ended:Connect(function()
        soundGroup:Destroy()
        playMusic(getNextIndex())
    end)
end

-- Control button functions
playPauseBtn.MouseButton1Click:Connect(function()
    if not currentSound then
        playMusic(currentIndex)
        return
    end
    
    if isPlaying and not isPaused then
        currentSound:Pause()
        isPaused = true
        playPauseBtn.Text = "▶"
    else
        currentSound:Resume()
        isPaused = false
        isPlaying = true
        playPauseBtn.Text = "⏸"
    end
end)

nextBtn.MouseButton1Click:Connect(function()
    playMusic(getNextIndex())
end)

prevBtn.MouseButton1Click:Connect(function()
    if isShuffleMode then
        local unplayedSongs = {}
        for i = 1, #musicList do
            local isPlayed = false
            for _, played in ipairs(playedSongs) do
                if played == i then
                    isPlayed = true
                    break
                end
            end
            if not isPlayed then
                table.insert(unplayedSongs, i)
            end
        end
        
        if #unplayedSongs > 0 then
            playMusic(unplayedSongs[math.random(1, #unplayedSongs)])
        else
            createShufflePlaylist()
            playMusic(shufflePlaylist[1])
        end
    else
        playMusic(currentIndex - 1)
    end
end)

-- Shuffle button with visual feedback
shuffleBtn.MouseButton1Click:Connect(function()
    isShuffleMode = not isShuffleMode
    
    if isShuffleMode then
        shuffleBtn.BackgroundColor3 = BUTTON_COLOR_ACTIVE
        createShufflePlaylist()
    else
        shuffleBtn.BackgroundColor3 = BUTTON_COLOR_NORMAL
        playedSongs = {}
        shufflePlaylist = {}
    end
    
    for _, obj in ipairs(shuffleBtn:GetChildren()) do
        if obj:IsA("UIGradient") then
            obj:Destroy()
        end
    end
    createGradient(shuffleBtn, ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.new(shuffleBtn.BackgroundColor3.R * 1.2, 
                                                shuffleBtn.BackgroundColor3.G * 1.2, 
                                                shuffleBtn.BackgroundColor3.B * 1.2)),
        ColorSequenceKeypoint.new(1, shuffleBtn.BackgroundColor3)
    })
end)

-- Visualizer animation
local hueOffset = 0
RunService.RenderStepped:Connect(function(dt)
    hueOffset = (hueOffset + dt * 0.5) % 1
    
    if isPlaying and not isPaused then
        if currentSound and currentSound.TimeLength > 0 then
            local progress = currentSound.TimePosition / currentSound.TimeLength
            progressBar.Size = UDim2.new(progress, 0, 1, 0)
            timeLabel.Text = formatTime(currentSound.TimePosition)
            durationLabel.Text = formatTime(currentSound.TimeLength)
        end
        
        for i, bar in ipairs(bars) do
            local height = math.random(20, 100)
            local targetSize = UDim2.new(1 / barCount, -scale("X", 2), 0, scale("Y", height))
            
            TweenService:Create(bar, TweenInfo.new(0.1), {Size = targetSize}):Play()
            
            local hue = ((i / barCount) + hueOffset) % 1
            bar.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
        end
        
        albumArt.Rotation = albumArt.Rotation + 30 * dt
        
        if miniBtn.Visible then
            local sc = 1 + math.sin(tick() * 3) * 0.05
            miniGlow.Size = UDim2.new(1.4 * sc, 0, 1.4 * sc, 0)
            miniGlow.Position = UDim2.new(-0.2 * sc, 0, -0.2 * sc, 0)
            miniGlow.BackgroundTransparency = 0.6 + math.sin(tick() * 2) * 0.1
        end
    else
        for i, bar in ipairs(bars) do
            TweenService:Create(bar, TweenInfo.new(0.3), {
                Size = UDim2.new(1 / barCount, -scale("X", 2), 0, scale("Y", 10))
            }):Play()
        end
    end
end)

-- Playlist overlay
local playlistOverlay = Instance.new("Frame")
playlistOverlay.Size = UDim2.new(1, 0, 1, 0)
playlistOverlay.Position = UDim2.new(0, 0, 0, 0)
playlistOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
playlistOverlay.BackgroundTransparency = 0.5
playlistOverlay.Visible = false
playlistOverlay.BorderSizePixel = 0
playlistOverlay.Parent = main
playlistOverlay.ZIndex = 100

local playlistFrame = Instance.new("ScrollingFrame")
playlistFrame.Size = UDim2.new(0.9, 0, 0.7, 0)
playlistFrame.Position = UDim2.new(0.05, 0, 0.15, 0)
playlistFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
playlistFrame.ScrollBarThickness = 6
playlistFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
playlistFrame.BorderSizePixel = 0
playlistFrame.Parent = playlistOverlay
playlistFrame.ZIndex = 101
corner(playlistFrame, 12)

local playlistTitle = Instance.new("TextLabel")
playlistTitle.Size = UDim2.new(1, -scale("X", 20), 0, scale("Y", 40))
playlistTitle.Position = UDim2.new(0, scale("X", 10), 0, scale("Y", 10))
playlistTitle.BackgroundTransparency = 1
playlistTitle.Text = "SIEXTHER - PLAYLIST"
playlistTitle.TextColor3 = Color3.new(1, 1, 1)
playlistTitle.Font = Enum.Font.GothamBold
playlistTitle.TextSize = scale("Y", 16)
playlistTitle.TextXAlignment = Enum.TextXAlignment.Left
playlistTitle.Parent = playlistFrame
playlistTitle.ZIndex = 102

local closePlaylistBtn = Instance.new("TextButton")
closePlaylistBtn.Size = UDim2.new(0, scale("X", 30), 0, scale("Y", 30))
closePlaylistBtn.Position = UDim2.new(1, -scale("X", 40), 0, scale("Y", 15))
closePlaylistBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
closePlaylistBtn.Text = "×"
closePlaylistBtn.Font = Enum.Font.GothamBold
closePlaylistBtn.TextSize = scale("Y", 20)
closePlaylistBtn.TextColor3 = Color3.new(1, 1, 1)
closePlaylistBtn.BorderSizePixel = 0
closePlaylistBtn.Parent = playlistFrame
closePlaylistBtn.ZIndex = 102
corner(closePlaylistBtn, 15)

-- Playlist items container
local playlistItemsFrame = Instance.new("Frame")
playlistItemsFrame.Size = UDim2.new(1, -scale("X", 20), 1, -scale("Y", 60))
playlistItemsFrame.Position = UDim2.new(0, scale("X", 10), 0, scale("Y", 50))
playlistItemsFrame.BackgroundTransparency = 1
playlistItemsFrame.Parent = playlistFrame
playlistItemsFrame.ZIndex = 101

-- Initialize
loadMusicList()

-- Create playlist items
local playlistLayout = Instance.new("UIListLayout")
playlistLayout.Padding = UDim.new(0, 4)
playlistLayout.Parent = playlistItemsFrame

for i, music in ipairs(musicList) do
    local item = Instance.new("TextButton")
    item.Size = UDim2.new(1, 0, 0, scale("Y", 35))
    item.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    item.Text = i .. ". " .. music.name
    item.TextColor3 = Color3.new(1, 1, 1)
    item.Font = Enum.Font.Gotham
    item.TextSize = scale("Y", 12)
    item.TextXAlignment = Enum.TextXAlignment.Left
    item.TextTruncate = Enum.TextTruncate.AtEnd
    item.BorderSizePixel = 0
    item.Parent = playlistItemsFrame
    item.ZIndex = 102
    corner(item, 6)
    
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 10)
    padding.Parent = item
    
    item.MouseButton1Click:Connect(function()
        playMusic(i)
        playlistOverlay.Visible = false
    end)
end

playlistFrame.CanvasSize = UDim2.new(0, 0, 0, playlistLayout.AbsoluteContentSize.Y + 60)

-- Show/hide playlist functionality
showPlaylistBtn.MouseButton1Click:Connect(function()
    playlistOverlay.Visible = not playlistOverlay.Visible
end)

closePlaylistBtn.MouseButton1Click:Connect(function()
    playlistOverlay.Visible = false
end)

-- Click outside to close playlist
playlistOverlay.MouseButton1Click:Connect(function()
    playlistOverlay.Visible = false
end)

-- Prevent clicks on playlist frame from closing it
playlistFrame.MouseButton1Click:Connect(function()
    -- Do nothing, just prevent event propagation
end)

