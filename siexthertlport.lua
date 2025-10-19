-- Player Teleport GUI Script
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")

-- Create ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TeleportGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 280, 0, 360)
MainFrame.Position = UDim2.new(0.5, -140, 0.5, -180)
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
MainFrame.BackgroundTransparency = 0.15
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

-- Shadow Effect
local Shadow = Instance.new("ImageLabel")
Shadow.Name = "Shadow"
Shadow.BackgroundTransparency = 1
Shadow.Position = UDim2.new(0, -15, 0, -15)
Shadow.Size = UDim2.new(1, 30, 1, 30)
Shadow.ZIndex = 0
Shadow.Image = "rbxasset://textures/ui/Controls/shadow.png"
Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
Shadow.ImageTransparency = 0.5
Shadow.ScaleType = Enum.ScaleType.Slice
Shadow.SliceCenter = Rect.new(10, 10, 118, 118)
Shadow.Parent = MainFrame

-- Top Bar
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 35)
TopBar.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
TopBar.BackgroundTransparency = 0.15
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 10)
TopCorner.Parent = TopBar

local TopBarBottom = Instance.new("Frame")
TopBarBottom.Size = UDim2.new(1, 0, 0, 10)
TopBarBottom.Position = UDim2.new(0, 0, 1, -10)
TopBarBottom.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
TopBarBottom.BackgroundTransparency = 0.15
TopBarBottom.BorderSizePixel = 0
TopBarBottom.Parent = TopBar

-- Title
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -80, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "🎮 Teleport"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

-- Minimize Button
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Size = UDim2.new(0, 25, 0, 25)
MinimizeButton.Position = UDim2.new(1, -60, 0.5, -12.5)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
MinimizeButton.Text = "−"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.TextSize = 18
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.Parent = TopBar

local MinimizeCorner = Instance.new("UICorner")
MinimizeCorner.CornerRadius = UDim.new(0, 5)
MinimizeCorner.Parent = MinimizeButton

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 25, 0, 25)
CloseButton.Position = UDim2.new(1, -30, 0.5, -12.5)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
CloseButton.Text = "×"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 20
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = TopBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 5)
CloseCorner.Parent = CloseButton

-- Search Box
local SearchBox = Instance.new("TextBox")
SearchBox.Name = "SearchBox"
SearchBox.Size = UDim2.new(1, -20, 0, 30)
SearchBox.Position = UDim2.new(0, 10, 0, 45)
SearchBox.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
SearchBox.BackgroundTransparency = 0.15
SearchBox.BorderSizePixel = 0
SearchBox.PlaceholderText = "🔍 Search player..."
SearchBox.Text = ""
SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SearchBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
SearchBox.TextSize = 13
SearchBox.Font = Enum.Font.Gotham
SearchBox.Parent = MainFrame

local SearchCorner = Instance.new("UICorner")
SearchCorner.CornerRadius = UDim.new(0, 6)
SearchCorner.Parent = SearchBox

-- Player List Frame
local ListFrame = Instance.new("ScrollingFrame")
ListFrame.Name = "ListFrame"
ListFrame.Size = UDim2.new(1, -20, 1, -90)
ListFrame.Position = UDim2.new(0, 10, 0, 80)
ListFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
ListFrame.BackgroundTransparency = 0.15
ListFrame.BorderSizePixel = 0
ListFrame.ScrollBarThickness = 5
ListFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 120)
ListFrame.Parent = MainFrame

local ListCorner = Instance.new("UICorner")
ListCorner.CornerRadius = UDim.new(0, 6)
ListCorner.Parent = ListFrame

local ListLayout = Instance.new("UIListLayout")
ListLayout.Padding = UDim.new(0, 4)
ListLayout.SortOrder = Enum.SortOrder.Name
ListLayout.Parent = ListFrame

-- Minimized Button (Fire Emoji)
local MinimizedButton = Instance.new("TextButton")
MinimizedButton.Name = "MinimizedButton"
MinimizedButton.Size = UDim2.new(0, 45, 0, 45)
MinimizedButton.Position = UDim2.new(0, 10, 0, 10)
MinimizedButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MinimizedButton.Text = "⚡"
MinimizedButton.TextSize = 24
MinimizedButton.Font = Enum.Font.GothamBold
MinimizedButton.Visible = false
MinimizedButton.Parent = ScreenGui

local MinimizedCorner = Instance.new("UICorner")
MinimizedCorner.CornerRadius = UDim.new(1, 0)
MinimizedCorner.Parent = MinimizedButton

-- Dragging functionality
local dragging, dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TopBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- Teleport Function
local function teleportToPlayer(targetPlayer)
    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame
        end
    end
end

-- Update Player List
local function updatePlayerList()
    for _, child in pairs(ListFrame:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    local searchText = SearchBox.Text:lower()
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if searchText == "" or player.Name:lower():find(searchText) or player.DisplayName:lower():find(searchText) then
                local PlayerButton = Instance.new("TextButton")
                PlayerButton.Name = player.Name
                PlayerButton.Size = UDim2.new(1, -10, 0, 35)
                PlayerButton.BackgroundColor3 = Color3.fromRGB(55, 55, 70)
                PlayerButton.BackgroundTransparency = 0.15
                PlayerButton.Text = player.DisplayName .. " (@" .. player.Name .. ")"
                PlayerButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                PlayerButton.TextSize = 12
                PlayerButton.Font = Enum.Font.Gotham
                PlayerButton.Parent = ListFrame
                
                local ButtonCorner = Instance.new("UICorner")
                ButtonCorner.CornerRadius = UDim.new(0, 5)
                ButtonCorner.Parent = PlayerButton
                
                PlayerButton.MouseButton1Click:Connect(function()
                    teleportToPlayer(player)
                    PlayerButton.BackgroundColor3 = Color3.fromRGB(80, 200, 120)
                    wait(0.3)
                    PlayerButton.BackgroundColor3 = Color3.fromRGB(55, 55, 70)
                end)
                
                PlayerButton.MouseEnter:Connect(function()
                    PlayerButton.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
                end)
                
                PlayerButton.MouseLeave:Connect(function()
                    PlayerButton.BackgroundColor3 = Color3.fromRGB(55, 55, 70)
                end)
            end
        end
    end
    
    ListFrame.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 5)
end

-- Search functionality
SearchBox:GetPropertyChangedSignal("Text"):Connect(updatePlayerList)

-- Close Button
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Minimize/Maximize functionality
local isMinimized = false

MinimizeButton.MouseButton1Click:Connect(function()
    isMinimized = true
    MainFrame.Visible = false
    MinimizedButton.Visible = true
end)

MinimizedButton.MouseButton1Click:Connect(function()
    isMinimized = false
    MainFrame.Visible = true
    MinimizedButton.Visible = false
end)

-- Button hover effects
CloseButton.MouseEnter:Connect(function()
    CloseButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
end)

CloseButton.MouseLeave:Connect(function()
    CloseButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
end)

MinimizeButton.MouseEnter:Connect(function()
    MinimizeButton.BackgroundColor3 = Color3.fromRGB(255, 220, 80)
end)

MinimizeButton.MouseLeave:Connect(function()
    MinimizeButton.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
end)

-- Update player list on player join/leave
Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(updatePlayerList)

-- Initial update
updatePlayerList()