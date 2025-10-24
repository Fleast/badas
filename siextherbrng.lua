-- SIEXTHER

local Gui = Instance.new("ScreenGui")
local Main = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local TopBar = Instance.new("Frame")
local UICorner_2 = Instance.new("UICorner")
local Label = Instance.new("TextLabel")
local CloseButton = Instance.new("TextButton")
local UICorner_3 = Instance.new("UICorner")
local MinimizeButton = Instance.new("TextButton")
local UICorner_4 = Instance.new("UICorner")
local ContentFrame = Instance.new("Frame")
local UICorner_5 = Instance.new("UICorner")
local SearchBox = Instance.new("TextBox")
local UICorner_6 = Instance.new("UICorner")
local SearchIcon = Instance.new("TextLabel")
local PlayerList = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")
local UIPadding = Instance.new("UIPadding")
local ButtonContainer = Instance.new("Frame")
local UICorner_7 = Instance.new("UICorner")
local Button = Instance.new("TextButton")
local UICorner_8 = Instance.new("UICorner")
local ButtonGradient = Instance.new("UIGradient")
local BringAllButton = Instance.new("TextButton")
local UICorner_9 = Instance.new("UICorner")
local ButtonGradient_2 = Instance.new("UIGradient")
local MinimizedButton = Instance.new("TextButton")
local UICorner_10 = Instance.new("UICorner")
local TargetInfo = Instance.new("TextLabel")
local UICorner_12 = Instance.new("UICorner")

--Properties:

Gui.Name = "IlhanSiextherBring"
Gui.Parent = gethui()
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Main.Name = "Main"
Main.Parent = Gui
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
Main.BackgroundTransparency = 0.1
Main.BorderSizePixel = 0
Main.Position = UDim2.new(0.32, 0, 0.28, 0)
Main.Size = UDim2.new(0.36, 0, 0.5, 0)
Main.Active = true
Main.Draggable = true
Main.ZIndex = 1

UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = Main

TopBar.Name = "TopBar"
TopBar.Parent = Main
TopBar.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
TopBar.BackgroundTransparency = 0.3
TopBar.BorderSizePixel = 0
TopBar.Size = UDim2.new(1, 0, 0.12, 0)
TopBar.ZIndex = 2

UICorner_2.CornerRadius = UDim.new(0, 12)
UICorner_2.Parent = TopBar

Label.Name = "Label"
Label.Parent = TopBar
Label.BackgroundTransparency = 1
Label.Position = UDim2.new(0.02, 0, 0, 0)
Label.Size = UDim2.new(0.7, 0, 1, 0)
Label.Font = Enum.Font.GothamBold
Label.Text = "SIEXTHER BRING"
Label.TextColor3 = Color3.fromRGB(120, 200, 255)
Label.TextScaled = true
Label.TextSize = 18
Label.TextWrapped = true
Label.TextXAlignment = Enum.TextXAlignment.Left
Label.ZIndex = 3

local LabelPadding = Instance.new("UIPadding")
LabelPadding.Parent = Label
LabelPadding.PaddingLeft = UDim.new(0, 15)

MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Parent = TopBar
MinimizeButton.BackgroundColor3 = Color3.fromRGB(255, 180, 0)
MinimizeButton.BorderSizePixel = 0
MinimizeButton.Position = UDim2.new(0.82, 0, 0.2, 0)
MinimizeButton.Size = UDim2.new(0.08, 0, 0.6, 0)
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.Text = "−"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.TextSize = 18
MinimizeButton.ZIndex = 3

UICorner_4.CornerRadius = UDim.new(0, 6)
UICorner_4.Parent = MinimizeButton

CloseButton.Name = "CloseButton"
CloseButton.Parent = TopBar
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 60, 70)
CloseButton.BorderSizePixel = 0
CloseButton.Position = UDim2.new(0.91, 0, 0.2, 0)
CloseButton.Size = UDim2.new(0.08, 0, 0.6, 0)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "×"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 20
CloseButton.ZIndex = 3

UICorner_3.CornerRadius = UDim.new(0, 6)
UICorner_3.Parent = CloseButton

ContentFrame.Name = "ContentFrame"
ContentFrame.Parent = Main
ContentFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
ContentFrame.BackgroundTransparency = 0.4
ContentFrame.BorderSizePixel = 0
ContentFrame.Position = UDim2.new(0.04, 0, 0.15, 0)
ContentFrame.Size = UDim2.new(0.92, 0, 0.82, 0)
ContentFrame.ZIndex = 2

UICorner_5.CornerRadius = UDim.new(0, 10)
UICorner_5.Parent = ContentFrame

SearchBox.Name = "SearchBox"
SearchBox.Parent = ContentFrame
SearchBox.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
SearchBox.BackgroundTransparency = 0.3
SearchBox.BorderSizePixel = 0
SearchBox.Position = UDim2.new(0.05, 0, 0.03, 0)
SearchBox.Size = UDim2.new(0.9, 0, 0.08, 0)
SearchBox.Font = Enum.Font.Gotham
SearchBox.PlaceholderText = "Search players..."
SearchBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 170)
SearchBox.Text = ""
SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SearchBox.TextSize = 14
SearchBox.TextXAlignment = Enum.TextXAlignment.Left
SearchBox.ZIndex = 3

UICorner_6.CornerRadius = UDim.new(0, 8)
UICorner_6.Parent = SearchBox

local SearchPadding = Instance.new("UIPadding")
SearchPadding.Parent = SearchBox
SearchPadding.PaddingLeft = UDim.new(0, 10)
SearchPadding.PaddingRight = UDim.new(0, 10)

PlayerList.Name = "PlayerList"
PlayerList.Parent = ContentFrame
PlayerList.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
PlayerList.BackgroundTransparency = 0.5
PlayerList.BorderSizePixel = 0
PlayerList.Position = UDim2.new(0.05, 0, 0.13, 0)
PlayerList.Size = UDim2.new(0.9, 0, 0.52, 0)
PlayerList.CanvasSize = UDim2.new(0, 0, 0, 0)
PlayerList.ScrollBarThickness = 4
PlayerList.ZIndex = 3

UIListLayout.Parent = PlayerList
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 4)

UIPadding.Parent = PlayerList
UIPadding.PaddingTop = UDim.new(0, 5)
UIPadding.PaddingLeft = UDim.new(0, 5)
UIPadding.PaddingRight = UDim.new(0, 5)

ButtonContainer.Name = "ButtonContainer"
ButtonContainer.Parent = ContentFrame
ButtonContainer.BackgroundTransparency = 1
ButtonContainer.Position = UDim2.new(0.05, 0, 0.67, 0)
ButtonContainer.Size = UDim2.new(0.9, 0, 0.3, 0)
ButtonContainer.ZIndex = 2

TargetInfo.Name = "TargetInfo"
TargetInfo.Parent = ContentFrame
TargetInfo.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
TargetInfo.BackgroundTransparency = 0.3
TargetInfo.BorderSizePixel = 0
TargetInfo.Position = UDim2.new(0.05, 0, 0.56, 0)
TargetInfo.Size = UDim2.new(0.9, 0, 0.09, 0)
TargetInfo.Font = Enum.Font.GothamBold
TargetInfo.Text = "🎯 Target: None"
TargetInfo.TextColor3 = Color3.fromRGB(120, 200, 255)
TargetInfo.TextSize = 14
TargetInfo.TextWrapped = true
TargetInfo.ZIndex = 3
TargetInfo.Visible = false

UICorner_12.CornerRadius = UDim.new(0, 8)
UICorner_12.Parent = TargetInfo

Button.Name = "Button"
Button.Parent = ButtonContainer
Button.BackgroundColor3 = Color3.fromRGB(80, 120, 255)
Button.BorderSizePixel = 0
Button.Position = UDim2.new(0, 0, 0.15, 0)
Button.Size = UDim2.new(1, 0, 0.38, 0)
Button.Font = Enum.Font.GothamBold
Button.Text = "🎯 Bring Single | OFF"
Button.TextColor3 = Color3.fromRGB(255, 255, 255)
Button.TextSize = 16
Button.ZIndex = 3

UICorner_8.CornerRadius = UDim.new(0, 8)
UICorner_8.Parent = Button

ButtonGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 120, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 90, 200))
}
ButtonGradient.Rotation = 45
ButtonGradient.Parent = Button

BringAllButton.Name = "BringAllButton"
BringAllButton.Parent = ButtonContainer
BringAllButton.BackgroundColor3 = Color3.fromRGB(255, 100, 120)
BringAllButton.BorderSizePixel = 0
BringAllButton.Position = UDim2.new(0, 0, 0.58, 0)
BringAllButton.Size = UDim2.new(1, 0, 0.38, 0)
BringAllButton.Font = Enum.Font.GothamBold
BringAllButton.Text = "💀 Bring All Players | OFF"
BringAllButton.TextColor3 = Color3.fromRGB(255, 255, 255)
BringAllButton.TextSize = 16
BringAllButton.ZIndex = 3

UICorner_9.CornerRadius = UDim.new(0, 8)
UICorner_9.Parent = BringAllButton

ButtonGradient_2.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 100, 120)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 60, 90))
}
ButtonGradient_2.Rotation = 45
ButtonGradient_2.Parent = BringAllButton

MinimizedButton.Name = "MinimizedButton"
MinimizedButton.Parent = Gui
MinimizedButton.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
MinimizedButton.BackgroundTransparency = 0.2
MinimizedButton.BorderSizePixel = 0
MinimizedButton.Position = UDim2.new(0.01, 0, 0.45, 0)
MinimizedButton.Size = UDim2.new(0.05, 0, 0.08, 0)
MinimizedButton.Font = Enum.Font.GothamBold
MinimizedButton.Text = "☠️"
MinimizedButton.TextColor3 = Color3.fromRGB(120, 200, 255)
MinimizedButton.TextSize = 28
MinimizedButton.Visible = false
MinimizedButton.ZIndex = 5

UICorner_10.CornerRadius = UDim.new(0, 12)
UICorner_10.Parent = MinimizedButton

-- Scripts:

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")

local character
local humanoidRootPart
local selectedPlayer = nil
local allPlayersTargets = {}

-- Hover effects
local function addHoverEffect(button, normalColor, hoverColor)
	button.MouseEnter:Connect(function()
		TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = hoverColor}):Play()
	end)
	button.MouseLeave:Connect(function()
		TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = normalColor}):Play()
	end)
end

addHoverEffect(CloseButton, Color3.fromRGB(255, 60, 70), Color3.fromRGB(255, 80, 90))
addHoverEffect(MinimizeButton, Color3.fromRGB(255, 180, 0), Color3.fromRGB(255, 200, 50))

-- Toggle visibility
UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
	if input.KeyCode == Enum.KeyCode.RightControl and not gameProcessedEvent then
		if Main.Visible then
			Main.Visible = false
			MinimizedButton.Visible = true
		else
			Main.Visible = true
			MinimizedButton.Visible = false
		end
	end
end)

local Folder = Instance.new("Folder", Workspace)
local Part = Instance.new("Part", Folder)
local Attachment1 = Instance.new("Attachment", Part)
Part.Anchored = true
Part.CanCollide = false
Part.Transparency = 1

if not getgenv().Network then
	getgenv().Network = {
		BaseParts = {},
		Velocity = Vector3.new(14.46262424, 14.46262424, 14.46262424)
	}

	Network.RetainPart = function(Part)
		if Part:IsA("BasePart") and Part:IsDescendantOf(Workspace) then
			table.insert(Network.BaseParts, Part)
			Part.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0)
			Part.CanCollide = false
		end
	end

	local function EnablePartControl()
		LocalPlayer.ReplicationFocus = Workspace
		RunService.Heartbeat:Connect(function()
			sethiddenproperty(LocalPlayer, "SimulationRadius", math.huge)
			for _, Part in pairs(Network.BaseParts) do
				if Part:IsDescendantOf(Workspace) then
					Part.Velocity = Network.Velocity
				end
			end
		end)
	end

	EnablePartControl()
end

local function ForcePart(v)
	if v:IsA("BasePart") and not v.Anchored and not v.Parent:FindFirstChildOfClass("Humanoid") and not v.Parent:FindFirstChild("Head") and v.Name ~= "Handle" then
		for _, x in ipairs(v:GetChildren()) do
			if x:IsA("BodyMover") or x:IsA("RocketPropulsion") then
				x:Destroy()
			end
		end
		if v:FindFirstChild("Attachment") then
			v:FindFirstChild("Attachment"):Destroy()
		end
		if v:FindFirstChild("AlignPosition") then
			v:FindFirstChild("AlignPosition"):Destroy()
		end
		if v:FindFirstChild("Torque") then
			v:FindFirstChild("Torque"):Destroy()
		end
		v.CanCollide = false
		local Torque = Instance.new("Torque", v)
		Torque.Torque = Vector3.new(100000, 100000, 100000)
		local AlignPosition = Instance.new("AlignPosition", v)
		local Attachment2 = Instance.new("Attachment", v)
		Torque.Attachment0 = Attachment2
		AlignPosition.MaxForce = math.huge
		AlignPosition.MaxVelocity = math.huge
		AlignPosition.Responsiveness = 200
		AlignPosition.Attachment0 = Attachment2
		AlignPosition.Attachment1 = Attachment1
	end
end

local blackHoleActive = false
local bringAllActive = false
local DescendantAddedConnection

local function toggleBlackHole()
	blackHoleActive = not blackHoleActive
	if blackHoleActive then
		Button.Text = "🎯 Bring Selected | ON"
		Button.BackgroundColor3 = Color3.fromRGB(50, 255, 100)
		ButtonGradient.Color = ColorSequence.new{
			ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 255, 100)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 200, 80))
		}
		
		for _, v in ipairs(Workspace:GetDescendants()) do
			ForcePart(v)
		end

		DescendantAddedConnection = Workspace.DescendantAdded:Connect(function(v)
			if blackHoleActive then
				ForcePart(v)
			end
		end)

		spawn(function()
			while blackHoleActive and RunService.RenderStepped:Wait() do
				if humanoidRootPart then
					Attachment1.WorldCFrame = humanoidRootPart.CFrame
				end
			end
		end)
	else
		Button.Text = "🎯 Bring Selected | OFF"
		Button.BackgroundColor3 = Color3.fromRGB(80, 120, 255)
		ButtonGradient.Color = ColorSequence.new{
			ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 120, 255)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 90, 200))
		}
		if DescendantAddedConnection then
			DescendantAddedConnection:Disconnect()
		end
	end
end

local currentTargetIndex = 1
local bringAllConnection

local function toggleBringAll()
	bringAllActive = not bringAllActive
	if bringAllActive then
		BringAllButton.Text = "💀 Bring All Players | ON"
		BringAllButton.BackgroundColor3 = Color3.fromRGB(50, 255, 100)
		ButtonGradient_2.Color = ColorSequence.new{
			ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 255, 100)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 200, 80))
		}
		
		-- Get all players except local player
		allPlayersTargets = {}
		for _, player in pairs(Players:GetPlayers()) do
			if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
				table.insert(allPlayersTargets, player)
			end
		end
		
		for _, v in ipairs(Workspace:GetDescendants()) do
			ForcePart(v)
		end

		DescendantAddedConnection = Workspace.DescendantAdded:Connect(function(v)
			if bringAllActive then
				ForcePart(v)
			end
		end)

		-- Cycle through all players randomly/sequentially
		bringAllConnection = RunService.RenderStepped:Connect(function()
			if bringAllActive and #allPlayersTargets > 0 then
				-- Update target every 2 seconds or randomly
				local targetPlayer = allPlayersTargets[currentTargetIndex]
				if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
					Attachment1.WorldCFrame = targetPlayer.Character.HumanoidRootPart.CFrame
					TargetInfo.Text = "🎯 Targeting: " .. targetPlayer.Name
					TargetInfo.Visible = true
				end
				
				-- Cycle to next player
				if tick() % 2 < 0.016 then -- Change every ~2 seconds
					currentTargetIndex = currentTargetIndex + 1
					if currentTargetIndex > #allPlayersTargets then
						currentTargetIndex = 1
					end
				end
			end
		end)
	else
		BringAllButton.Text = "💀 Bring All Players | OFF"
		BringAllButton.BackgroundColor3 = Color3.fromRGB(255, 100, 120)
		ButtonGradient_2.Color = ColorSequence.new{
			ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 100, 120)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 60, 90))
		}
		TargetInfo.Visible = false
		TargetInfo.Text = "🎯 Target: None"
		if DescendantAddedConnection then
			DescendantAddedConnection:Disconnect()
		end
		if bringAllConnection then
			bringAllConnection:Disconnect()
		end
	end
end

local function createPlayerButton(player)
	local playerButton = Instance.new("TextButton")
	playerButton.Name = player.Name
	playerButton.Parent = PlayerList
	playerButton.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
	playerButton.BackgroundTransparency = 0.3
	playerButton.BorderSizePixel = 0
	playerButton.Size = UDim2.new(1, -10, 0, 35)
	playerButton.Font = Enum.Font.Gotham
	playerButton.Text = "👤 " .. player.Name
	playerButton.TextColor3 = Color3.fromRGB(200, 200, 220)
	playerButton.TextSize = 14
	playerButton.TextXAlignment = Enum.TextXAlignment.Left
	playerButton.TextTruncate = Enum.TextTruncate.AtEnd
	playerButton.ZIndex = 4
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = playerButton
	
	local padding = Instance.new("UIPadding")
	padding.Parent = playerButton
	padding.PaddingLeft = UDim.new(0, 12)
	
	-- Hover effect
	playerButton.MouseEnter:Connect(function()
		if selectedPlayer ~= player then
			TweenService:Create(playerButton, TweenInfo.new(0.2), {
				BackgroundColor3 = Color3.fromRGB(60, 60, 80),
				BackgroundTransparency = 0.2
			}):Play()
		end
	end)
	
	playerButton.MouseLeave:Connect(function()
		if selectedPlayer ~= player then
			TweenService:Create(playerButton, TweenInfo.new(0.2), {
				BackgroundColor3 = Color3.fromRGB(45, 45, 60),
				BackgroundTransparency = 0.3
			}):Play()
		end
	end)
	
	playerButton.MouseButton1Click:Connect(function()
		selectedPlayer = player
		for _, btn in pairs(PlayerList:GetChildren()) do
			if btn:IsA("TextButton") then
				TweenService:Create(btn, TweenInfo.new(0.2), {
					BackgroundColor3 = Color3.fromRGB(45, 45, 60),
					BackgroundTransparency = 0.3,
					TextColor3 = Color3.fromRGB(200, 200, 220)
				}):Play()
			end
		end
		TweenService:Create(playerButton, TweenInfo.new(0.2), {
			BackgroundColor3 = Color3.fromRGB(80, 120, 255),
			BackgroundTransparency = 0,
			TextColor3 = Color3.fromRGB(255, 255, 255)
		}):Play()
		print("✅ Selected player:", player.Name)
	end)
	
	return playerButton
end

local function updatePlayerList(searchText)
	for _, child in pairs(PlayerList:GetChildren()) do
		if child:IsA("TextButton") then
			child:Destroy()
		end
	end
	
	local searchLower = string.lower(searchText or "")
	local count = 0
	
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer then
			local nameLower = string.lower(player.Name)
			local displayLower = string.lower(player.DisplayName)
			
			if searchText == "" or string.find(nameLower, searchLower) or string.find(displayLower, searchLower) then
				createPlayerButton(player)
				count = count + 1
			end
		end
	end
	
	PlayerList.CanvasSize = UDim2.new(0, 0, 0, count * 39)
end

-- Initialize
updatePlayerList("")

-- Search
SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
	updatePlayerList(SearchBox.Text)
end)

-- Update on player join/leave
Players.PlayerAdded:Connect(function()
	wait(0.1)
	updatePlayerList(SearchBox.Text)
end)

Players.PlayerRemoving:Connect(function()
	wait(0.1)
	updatePlayerList(SearchBox.Text)
end)

-- Bring Selected Button
Button.MouseButton1Click:Connect(function()
	if selectedPlayer then
		character = selectedPlayer.Character or selectedPlayer.CharacterAdded:Wait()
		humanoidRootPart = character:WaitForChild("HumanoidRootPart")
		toggleBlackHole()
	else
		local originalText = Button.Text
		Button.Text = "⚠️ Select Player First!"
		wait(2)
		Button.Text = originalText
	end
end)

-- Bring All Button
BringAllButton.MouseButton1Click:Connect(function()
	toggleBringAll()
end)

-- Close Button
CloseButton.MouseButton1Click:Connect(function()
	TweenService:Create(Main, TweenInfo.new(0.3), {Size = UDim2.new(0, 0, 0, 0)}):Play()
	wait(0.3)
	Gui:Destroy()
end)

-- Minimize Button
MinimizeButton.MouseButton1Click:Connect(function()
	Main.Visible = false
	MinimizedButton.Visible = true
end)

-- Minimized Button
MinimizedButton.MouseButton1Click:Connect(function()
	Main.Visible = true
	MinimizedButton.Visible = false
end)