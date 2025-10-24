-- ESP Player GUI Script
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Pengaturan ESP
local ESPSettings = {
    Enabled = true,
    ShowName = false,
    ShowHealth = false,
    ShowLine = false,
    ShowBox = false
}

-- Tabel untuk menyimpan ESP objects
local ESPObjects = {}

-- Fungsi untuk membuat GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ESPPlayerGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.CoreGui

-- Frame utama (Ukuran lebih kecil)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 260, 0, 250)
MainFrame.Position = UDim2.new(0.5, -130, 0.5, -125)
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Rounded corners untuk MainFrame
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

-- Header
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 35)
Header.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 10)
HeaderCorner.Parent = Header

-- Fix corner header (agar tidak rounded di bawah)
local HeaderFix = Instance.new("Frame")
HeaderFix.Size = UDim2.new(1, 0, 0, 10)
HeaderFix.Position = UDim2.new(0, 0, 1, -10)
HeaderFix.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
HeaderFix.BorderSizePixel = 0
HeaderFix.Parent = Header

-- Title
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -70, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "SIEXTHER ESP PLAYER"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

-- Button Minimize
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Name = "MinimizeBtn"
MinimizeBtn.Size = UDim2.new(0, 28, 0, 28)
MinimizeBtn.Position = UDim2.new(1, -62, 0.5, -14)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.TextSize = 18
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.BorderSizePixel = 0
MinimizeBtn.Parent = Header

local MinimizeCorner = Instance.new("UICorner")
MinimizeCorner.CornerRadius = UDim.new(0, 6)
MinimizeCorner.Parent = MinimizeBtn

-- Button Close
local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -30, 0.5, -14)
CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 16
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.BorderSizePixel = 0
CloseBtn.Parent = Header

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

-- Container untuk buttons
local Container = Instance.new("Frame")
Container.Name = "Container"
Container.Size = UDim2.new(1, -20, 1, -55)
Container.Position = UDim2.new(0, 10, 0, 45)
Container.BackgroundTransparency = 1
Container.Parent = MainFrame

-- Fungsi untuk membuat toggle button
local function createToggleButton(name, yPos, setting)
    local Button = Instance.new("TextButton")
    Button.Name = name
    Button.Size = UDim2.new(1, 0, 0, 38)
    Button.Position = UDim2.new(0, 0, 0, yPos)
    Button.BackgroundColor3 = ESPSettings[setting] and Color3.fromRGB(50, 180, 80) or Color3.fromRGB(55, 55, 65)
    Button.Text = name
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 14
    Button.Font = Enum.Font.Gotham
    Button.BorderSizePixel = 0
    Button.Parent = Container
    
    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 8)
    BtnCorner.Parent = Button
    
    -- Status indicator
    local StatusText = Instance.new("TextLabel")
    StatusText.Name = "Status"
    StatusText.Size = UDim2.new(0, 50, 1, 0)
    StatusText.Position = UDim2.new(1, -60, 0, 0)
    StatusText.BackgroundTransparency = 1
    StatusText.Text = ESPSettings[setting] and "ON" or "OFF"
    StatusText.TextColor3 = Color3.fromRGB(255, 255, 255)
    StatusText.TextSize = 13
    StatusText.Font = Enum.Font.GothamBold
    StatusText.Parent = Button
    
    Button.MouseButton1Click:Connect(function()
        ESPSettings[setting] = not ESPSettings[setting]
        Button.BackgroundColor3 = ESPSettings[setting] and Color3.fromRGB(50, 180, 80) or Color3.fromRGB(55, 55, 65)
        StatusText.Text = ESPSettings[setting] and "ON" or "OFF"
    end)
    
    return Button
end

-- Buat toggle buttons
createToggleButton("👤 Display Name", 0, "ShowName")
createToggleButton("❤️ Health Bar", 46, "ShowHealth")
createToggleButton("📏 Line to Player", 92, "ShowLine")
createToggleButton("📦 Box ESP", 138, "ShowBox")

-- Button Fire untuk membuka kembali
local FireButton = Instance.new("TextButton")
FireButton.Name = "FireButton"
FireButton.Size = UDim2.new(0, 45, 0, 45)
FireButton.Position = UDim2.new(0, 10, 0, 10)
FireButton.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
FireButton.Text = "👁️"
FireButton.TextSize = 22
FireButton.Font = Enum.Font.GothamBold
FireButton.BorderSizePixel = 0
FireButton.Visible = false
FireButton.Active = true
FireButton.Draggable = true
FireButton.Parent = ScreenGui

local FireCorner = Instance.new("UICorner")
FireCorner.CornerRadius = UDim.new(0, 10)
FireCorner.Parent = FireButton

-- Fungsi minimize
local isMinimized = false
MinimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    MainFrame.Visible = not isMinimized
    FireButton.Visible = isMinimized
end)

-- Fungsi untuk membuka kembali dari fire button
FireButton.MouseButton1Click:Connect(function()
    isMinimized = false
    MainFrame.Visible = true
    FireButton.Visible = false
end)

-- Variable untuk connection
local renderConnection = nil

-- Fungsi close
CloseBtn.MouseButton1Click:Connect(function()
    ESPSettings.Enabled = false
    
    -- Disconnect render loop
    if renderConnection then
        renderConnection:Disconnect()
        renderConnection = nil
    end
    
    -- Remove semua ESP objects
    for _, espObj in pairs(ESPObjects) do
        if espObj.DisplayName then 
            espObj.DisplayName.Visible = false
            espObj.DisplayName:Remove() 
        end
        if espObj.Username then 
            espObj.Username.Visible = false
            espObj.Username:Remove() 
        end
        if espObj.Health then 
            espObj.Health.Visible = false
            espObj.Health:Remove() 
        end
        if espObj.Line then 
            espObj.Line.Visible = false
            espObj.Line:Remove() 
        end
        if espObj.Box then
            for _, boxLine in ipairs(espObj.Box) do
                boxLine.Visible = false
                boxLine:Remove()
            end
        end
    end
    
    -- Clear table
    ESPObjects = {}
    
    -- Destroy GUI
    ScreenGui:Destroy()
    
    print("ESP Player GUI closed successfully!")
end)

-- Fungsi untuk membuat ESP
local function createESP(player)
    if player == LocalPlayer then return end
    
    local esp = {
        DisplayName = nil,
        Username = nil,
        Health = nil,
        Line = nil,
        Box = nil
    }
    
    -- Display Name ESP (Nickname)
    local displayLabel = Drawing.new("Text")
    displayLabel.Visible = false
    displayLabel.Center = true
    displayLabel.Outline = true
    displayLabel.Font = 2
    displayLabel.Size = 14
    displayLabel.Color = Color3.new(1, 1, 1)
    esp.DisplayName = displayLabel
    
    -- Username ESP (@username)
    local usernameLabel = Drawing.new("Text")
    usernameLabel.Visible = false
    usernameLabel.Center = true
    usernameLabel.Outline = true
    usernameLabel.Font = 2
    usernameLabel.Size = 13
    usernameLabel.Color = Color3.new(0.7, 0.7, 0.7)
    esp.Username = usernameLabel
    
    -- Health ESP
    local healthLabel = Drawing.new("Text")
    healthLabel.Visible = false
    healthLabel.Center = true
    healthLabel.Outline = true
    healthLabel.Font = 2
    healthLabel.Size = 12
    healthLabel.Color = Color3.new(0, 1, 0)
    esp.Health = healthLabel
    
    -- Line ESP
    local line = Drawing.new("Line")
    line.Visible = false
    line.Thickness = 1
    line.Color = Color3.new(1, 1, 1)
    esp.Line = line
    
    -- Box ESP (4 lines)
    local box = {}
    for i = 1, 4 do
        local boxLine = Drawing.new("Line")
        boxLine.Visible = false
        boxLine.Thickness = 2
        boxLine.Color = Color3.new(1, 1, 1)
        box[i] = boxLine
    end
    esp.Box = box
    
    ESPObjects[player] = esp
end

-- Update ESP
local function updateESP()
    if not ESPSettings.Enabled then return end
    
    for player, esp in pairs(ESPObjects) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") then
            local hrp = player.Character.HumanoidRootPart
            local humanoid = player.Character.Humanoid
            local head = player.Character:FindFirstChild("Head")
            
            local vector, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            
            if onScreen then
                -- Display Name (Nickname)
                if ESPSettings.ShowName and esp.DisplayName then
                    esp.DisplayName.Visible = true
                    esp.DisplayName.Position = Vector2.new(vector.X, vector.Y - 50)
                    esp.DisplayName.Text = player.DisplayName
                    
                    -- Username (@username)
                    esp.Username.Visible = true
                    esp.Username.Position = Vector2.new(vector.X, vector.Y - 35)
                    esp.Username.Text = "@" .. player.Name
                else
                    esp.DisplayName.Visible = false
                    esp.Username.Visible = false
                end
                
                -- Health
                if ESPSettings.ShowHealth and esp.Health then
                    esp.Health.Visible = true
                    esp.Health.Position = Vector2.new(vector.X, vector.Y - 20)
                    esp.Health.Text = string.format("HP: %d/%d", math.floor(humanoid.Health), math.floor(humanoid.MaxHealth))
                    local healthPercent = humanoid.Health / humanoid.MaxHealth
                    esp.Health.Color = Color3.new(1 - healthPercent, healthPercent, 0)
                else
                    esp.Health.Visible = false
                end
                
                -- Line
                if ESPSettings.ShowLine and esp.Line then
                    esp.Line.Visible = true
                    esp.Line.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                    esp.Line.To = Vector2.new(vector.X, vector.Y)
                else
                    esp.Line.Visible = false
                end
                
                -- Box
                if ESPSettings.ShowBox and esp.Box and head then
                    local headPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                    local legPos = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
                    
                    local height = math.abs(headPos.Y - legPos.Y)
                    local width = height / 2
                    
                    -- Top line
                    esp.Box[1].Visible = true
                    esp.Box[1].From = Vector2.new(vector.X - width / 2, headPos.Y)
                    esp.Box[1].To = Vector2.new(vector.X + width / 2, headPos.Y)
                    
                    -- Bottom line
                    esp.Box[2].Visible = true
                    esp.Box[2].From = Vector2.new(vector.X - width / 2, legPos.Y)
                    esp.Box[2].To = Vector2.new(vector.X + width / 2, legPos.Y)
                    
                    -- Left line
                    esp.Box[3].Visible = true
                    esp.Box[3].From = Vector2.new(vector.X - width / 2, headPos.Y)
                    esp.Box[3].To = Vector2.new(vector.X - width / 2, legPos.Y)
                    
                    -- Right line
                    esp.Box[4].Visible = true
                    esp.Box[4].From = Vector2.new(vector.X + width / 2, headPos.Y)
                    esp.Box[4].To = Vector2.new(vector.X + width / 2, legPos.Y)
                else
                    for _, boxLine in ipairs(esp.Box) do
                        boxLine.Visible = false
                    end
                end
            else
                esp.DisplayName.Visible = false
                esp.Username.Visible = false
                esp.Health.Visible = false
                esp.Line.Visible = false
                for _, boxLine in ipairs(esp.Box) do
                    boxLine.Visible = false
                end
            end
        else
            esp.DisplayName.Visible = false
            esp.Username.Visible = false
            esp.Health.Visible = false
            esp.Line.Visible = false
            for _, boxLine in ipairs(esp.Box) do
                boxLine.Visible = false
            end
        end
    end
end

-- Initialize ESP untuk semua player
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        createESP(player)
    end
end

-- Player added
Players.PlayerAdded:Connect(function(player)
    createESP(player)
end)

-- Player removed
Players.PlayerRemoving:Connect(function(player)
    if ESPObjects[player] then
        if ESPObjects[player].DisplayName then ESPObjects[player].DisplayName:Remove() end
        if ESPObjects[player].Username then ESPObjects[player].Username:Remove() end
        if ESPObjects[player].Health then ESPObjects[player].Health:Remove() end
        if ESPObjects[player].Line then ESPObjects[player].Line:Remove() end
        if ESPObjects[player].Box then
            for _, boxLine in ipairs(ESPObjects[player].Box) do
                boxLine:Remove()
            end
        end
        ESPObjects[player] = nil
    end
end)

-- Update loop
renderConnection = RunService.RenderStepped:Connect(updateESP)