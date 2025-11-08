--### SIEXTHER ###
local main = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local FrameCorner = Instance.new("UICorner")
local FrameStroke = Instance.new("UIStroke")
local up = Instance.new("TextButton")
local upCorner = Instance.new("UICorner")
local upStroke = Instance.new("UIStroke")
local down = Instance.new("TextButton")
local downCorner = Instance.new("UICorner")
local downStroke = Instance.new("UIStroke")
local onof = Instance.new("TextButton")
local onofCorner = Instance.new("UICorner")
local onofStroke = Instance.new("UIStroke")
local TextLabel = Instance.new("TextLabel")
local TextLabelCorner = Instance.new("UICorner")
local TextLabelStroke = Instance.new("UIStroke")
local plus = Instance.new("TextButton")
local plusCorner = Instance.new("UICorner")
local plusStroke = Instance.new("UIStroke")
local speed = Instance.new("TextLabel")
local speedCorner = Instance.new("UICorner")
local speedStroke = Instance.new("UIStroke")
local mine = Instance.new("TextButton")
local mineCorner = Instance.new("UICorner")
local mineStroke = Instance.new("UIStroke")
local closebutton = Instance.new("TextButton")
local closebuttonCorner = Instance.new("UICorner")
local closebuttonStroke = Instance.new("UIStroke")
local mini = Instance.new("TextButton")
local miniCorner = Instance.new("UICorner")
local miniStroke = Instance.new("UIStroke")
local mini2 = Instance.new("TextButton")
local mini2Corner = Instance.new("UICorner")
local mini2Stroke = Instance.new("UIStroke")

main.Name = "main"
main.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
main.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
main.ResetOnSpawn = false

Frame.Parent = main
Frame.BackgroundColor3 = Color3.fromRGB(18, 18, 22) -- Dark modern background
Frame.BackgroundTransparency = 0.1
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0.100320168, 0, 0.379746825, 0)
Frame.Size = UDim2.new(0, 170, 0, 50) -- Diperkecil dari 190x57 menjadi 170x50

FrameCorner.CornerRadius = UDim.new(0, 12)
FrameCorner.Parent = Frame

FrameStroke.Parent = Frame
FrameStroke.Color = Color3.fromRGB(70, 130, 255) -- Sky blue stroke baru
FrameStroke.Thickness = 2
FrameStroke.Transparency = 0
FrameStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

up.Name = "up"
up.Parent = Frame
up.BackgroundColor3 = Color3.fromRGB(28, 28, 35) -- Dark modern
up.BackgroundTransparency = 0
up.BorderSizePixel = 0
up.Size = UDim2.new(0, 38, 0, 24) -- Diperkecil
up.Font = Enum.Font.GothamBold
up.Text = "UP"
up.TextColor3 = Color3.fromRGB(255, 255, 255)
up.TextSize = 12.000

upCorner.CornerRadius = UDim.new(0, 8)
upCorner.Parent = up

upStroke.Parent = up
upStroke.Color = Color3.fromRGB(70, 130, 255) -- Sky blue stroke baru
upStroke.Thickness = 1.5
upStroke.Transparency = 0.3
upStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

down.Name = "down"
down.Parent = Frame
down.BackgroundColor3 = Color3.fromRGB(28, 28, 35) -- Dark modern
down.BackgroundTransparency = 0
down.BorderSizePixel = 0
down.Position = UDim2.new(0, 0, 0.52, 0)
down.Size = UDim2.new(0, 38, 0, 24) -- Diperkecil
down.Font = Enum.Font.GothamBold
down.Text = "DOWN"
down.TextColor3 = Color3.fromRGB(255, 255, 255)
down.TextSize = 11.000

downCorner.CornerRadius = UDim.new(0, 8)
downCorner.Parent = down

downStroke.Parent = down
downStroke.Color = Color3.fromRGB(70, 130, 255) -- Sky blue stroke baru
downStroke.Thickness = 1.5
downStroke.Transparency = 0.3
downStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

onof.Name = "onof"
onof.Parent = Frame
onof.BackgroundColor3 = Color3.fromRGB(28, 28, 35) -- Dark modern
onof.BackgroundTransparency = 0
onof.BorderSizePixel = 0
onof.Position = UDim2.new(0.694, 0, 0.52, 0)
onof.Size = UDim2.new(0, 52, 0, 24) -- Diperkecil
onof.Font = Enum.Font.GothamBold
onof.Text = "FLY"
onof.TextColor3 = Color3.fromRGB(70, 130, 255) -- Sky blue text
onof.TextSize = 13.000

onofCorner.CornerRadius = UDim.new(0, 8)
onofCorner.Parent = onof

onofStroke.Parent = onof
onofStroke.Color = Color3.fromRGB(70, 130, 255) -- Sky blue stroke baru
onofStroke.Thickness = 2
onofStroke.Transparency = 0
onofStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

TextLabel.Parent = Frame
TextLabel.BackgroundColor3 = Color3.fromRGB(28, 28, 35) -- Dark modern
TextLabel.BackgroundTransparency = 0
TextLabel.BorderSizePixel = 0
TextLabel.Position = UDim2.new(0.459, 0, 0, 0)
TextLabel.Size = UDim2.new(0, 92, 0, 24) -- Diperkecil
TextLabel.Font = Enum.Font.GothamBold
TextLabel.Text = "HANN.SIEXTHER"
TextLabel.TextColor3 = Color3.fromRGB(70, 130, 255) -- Sky blue text
TextLabel.TextScaled = true
TextLabel.TextSize = 12.000
TextLabel.TextWrapped = true

TextLabelCorner.CornerRadius = UDim.new(0, 8)
TextLabelCorner.Parent = TextLabel

TextLabelStroke.Parent = TextLabel
TextLabelStroke.Color = Color3.fromRGB(70, 130, 255) -- Sky blue stroke baru
TextLabelStroke.Thickness = 1.5
TextLabelStroke.Transparency = 0.3
TextLabelStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

plus.Name = "plus"
plus.Parent = Frame
plus.BackgroundColor3 = Color3.fromRGB(28, 28, 35) -- Dark modern
plus.BackgroundTransparency = 0
plus.BorderSizePixel = 0
plus.Position = UDim2.new(0.224, 0, 0, 0)
plus.Size = UDim2.new(0, 40, 0, 24) -- Diperkecil
plus.Font = Enum.Font.GothamBold
plus.Text = "+"
plus.TextColor3 = Color3.fromRGB(255, 255, 255)
plus.TextScaled = true
plus.TextSize = 12.000
plus.TextWrapped = true

plusCorner.CornerRadius = UDim.new(0, 8)
plusCorner.Parent = plus

plusStroke.Parent = plus
plusStroke.Color = Color3.fromRGB(70, 130, 255) -- Sky blue stroke baru
plusStroke.Thickness = 1.5
plusStroke.Transparency = 0.3
plusStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

speed.Name = "speed"
speed.Parent = Frame
speed.BackgroundColor3 = Color3.fromRGB(28, 28, 35) -- Dark modern
speed.BackgroundTransparency = 0
speed.BorderSizePixel = 0
speed.Position = UDim2.new(0.459, 0, 0.52, 0)
speed.Size = UDim2.new(0, 40, 0, 24) -- Diperkecil
speed.Font = Enum.Font.GothamBold
speed.Text = "1"
speed.TextColor3 = Color3.fromRGB(70, 130, 255) -- Sky blue text
speed.TextScaled = true
speed.TextSize = 12.000
speed.TextWrapped = true

speedCorner.CornerRadius = UDim.new(0, 8)
speedCorner.Parent = speed

speedStroke.Parent = speed
speedStroke.Color = Color3.fromRGB(70, 130, 255) -- Sky blue stroke baru
speedStroke.Thickness = 1.5
speedStroke.Transparency = 0.3
speedStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

mine.Name = "mine"
mine.Parent = Frame
mine.BackgroundColor3 = Color3.fromRGB(28, 28, 35) -- Dark modern
mine.BackgroundTransparency = 0
mine.BorderSizePixel = 0
mine.Position = UDim2.new(0.224, 0, 0.52, 0)
mine.Size = UDim2.new(0, 40, 0, 24) -- Diperkecil
mine.Font = Enum.Font.GothamBold
mine.Text = "-"
mine.TextColor3 = Color3.fromRGB(255, 255, 255)
mine.TextScaled = true
mine.TextSize = 12.000
mine.TextWrapped = true

mineCorner.CornerRadius = UDim.new(0, 8)
mineCorner.Parent = mine

mineStroke.Parent = mine
mineStroke.Color = Color3.fromRGB(70, 130, 255) -- Sky blue stroke baru
mineStroke.Thickness = 1.5
mineStroke.Transparency = 0.3
mineStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

closebutton.Name = "Close"
closebutton.Parent = main.Frame
closebutton.BackgroundColor3 = Color3.fromRGB(28, 28, 35) -- Dark modern
closebutton.BackgroundTransparency = 0
closebutton.BorderSizePixel = 0
closebutton.Font = "GothamBold"
closebutton.Size = UDim2.new(0, 38, 0, 24) -- Diperkecil
closebutton.Text = "X"
closebutton.TextColor3 = Color3.fromRGB(255, 85, 85) -- Red text
closebutton.TextSize = 20
closebutton.Position =  UDim2.new(0, 0, -1, 24)

closebuttonCorner.CornerRadius = UDim.new(0, 8)
closebuttonCorner.Parent = closebutton

closebuttonStroke.Parent = closebutton
closebuttonStroke.Color = Color3.fromRGB(255, 85, 85) -- Red stroke
closebuttonStroke.Thickness = 2
closebuttonStroke.Transparency = 0
closebuttonStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

mini.Name = "minimize"
mini.Parent = main.Frame
mini.BackgroundColor3 = Color3.fromRGB(28, 28, 35) -- Dark modern
mini.BackgroundTransparency = 0
mini.BorderSizePixel = 0
mini.Font = "GothamBold"
mini.Size = UDim2.new(0, 38, 0, 24) -- Diperkecil
mini.Text = "-"
mini.TextColor3 = Color3.fromRGB(70, 130, 255) -- Sky blue text
mini.TextSize = 26
mini.Position = UDim2.new(0, 38, -1, 24)

miniCorner.CornerRadius = UDim.new(0, 8)
miniCorner.Parent = mini

miniStroke.Parent = mini
miniStroke.Color = Color3.fromRGB(70, 130, 255) -- Sky blue stroke baru
miniStroke.Thickness = 1.5
miniStroke.Transparency = 0.3
miniStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

mini2.Name = "minimize2"
mini2.Parent = main.Frame
mini2.BackgroundColor3 = Color3.fromRGB(28, 28, 35) -- Dark modern
mini2.BackgroundTransparency = 0
mini2.BorderSizePixel = 0
mini2.Font = "GothamBold"
mini2.Size = UDim2.new(0, 38, 0, 24) -- Diperkecil
mini2.Text = "+"
mini2.TextColor3 = Color3.fromRGB(70, 130, 255) -- Sky blue text
mini2.TextSize = 26
mini2.Position = UDim2.new(0, 38, -1, 48)
mini2.Visible = false

mini2Corner.CornerRadius = UDim.new(0, 8)
mini2Corner.Parent = mini2

mini2Stroke.Parent = mini2
mini2Stroke.Color = Color3.fromRGB(70, 130, 255) -- Sky blue stroke baru
mini2Stroke.Thickness = 1.5
mini2Stroke.Transparency = 0.3
mini2Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

speeds = 1

local speaker = game:GetService("Players").LocalPlayer

local chr = game.Players.LocalPlayer.Character
local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")

nowe = false

loadstring(game:HttpGet("https://raw.githubusercontent.com/Fleast/hankill/refs/heads/main/Notify.lua"))()
    getgenv().Notify({Title = 'SIEXTHER x FLY', Content = 'AKTIF', Duration = 4})

Frame.Active = true
Frame.Draggable = true

onof.MouseButton1Down:connect(function()

	if nowe == true then
		nowe = false

		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming,true)
		speaker.Character.Humanoid:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
	else 
		nowe = true

		for i = 1, speeds do
			spawn(function()
				local hb = game:GetService("RunService").Heartbeat	
				tpwalking = true
				local chr = game.Players.LocalPlayer.Character
				local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
				while tpwalking and hb:Wait() and chr and hum and hum.Parent do
					if hum.MoveDirection.Magnitude > 0 then
						chr:TranslateBy(hum.MoveDirection)
					end
				end
			end)
		end
		game.Players.LocalPlayer.Character.Animate.Disabled = true
		local Char = game.Players.LocalPlayer.Character
		local Hum = Char:FindFirstChildOfClass("Humanoid") or Char:FindFirstChildOfClass("AnimationController")

		for i,v in next, Hum:GetPlayingAnimationTracks() do
			v:AdjustSpeed(0)
		end
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming,false)
		speaker.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Swimming)
	end

	if game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").RigType == Enum.HumanoidRigType.R6 then
		local plr = game.Players.LocalPlayer
		local torso = plr.Character.Torso
		local flying = true
		local deb = true
		local ctrl = {f = 0, b = 0, l = 0, r = 0}
		local lastctrl = {f = 0, b = 0, l = 0, r = 0}
		local maxspeed = 50
		local speed = 0

		local bg = Instance.new("BodyGyro", torso)
		bg.P = 9e4
		bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
		bg.cframe = torso.CFrame
		local bv = Instance.new("BodyVelocity", torso)
		bv.velocity = Vector3.new(0,0.1,0)
		bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
		if nowe == true then
			plr.Character.Humanoid.PlatformStand = true
		end
		while nowe == true or game:GetService("Players").LocalPlayer.Character.Humanoid.Health == 0 do
			game:GetService("RunService").RenderStepped:Wait()

			if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
				speed = speed+.5+(speed/maxspeed)
				if speed > maxspeed then
					speed = maxspeed
				end
			elseif not (ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0) and speed ~= 0 then
				speed = speed-1
				if speed < 0 then
					speed = 0
				end
			end
			if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then
				bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (ctrl.f+ctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(ctrl.l+ctrl.r,(ctrl.f+ctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
				lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
			elseif (ctrl.l + ctrl.r) == 0 and (ctrl.f + ctrl.b) == 0 and speed ~= 0 then
				bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (lastctrl.f+lastctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(lastctrl.l+lastctrl.r,(lastctrl.f+lastctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
			else
				bv.velocity = Vector3.new(0,0,0)
			end
			bg.cframe = game.Workspace.CurrentCamera.CoordinateFrame * CFrame.Angles(-math.rad((ctrl.f+ctrl.b)*50*speed/maxspeed),0,0)
		end
		ctrl = {f = 0, b = 0, l = 0, r = 0}
		lastctrl = {f = 0, b = 0, l = 0, r = 0}
		speed = 0
		bg:Destroy()
		bv:Destroy()
		plr.Character.Humanoid.PlatformStand = false
		game.Players.LocalPlayer.Character.Animate.Disabled = false
		tpwalking = false

	else
		local plr = game.Players.LocalPlayer
		local UpperTorso = plr.Character.UpperTorso
		local flying = true
		local deb = true
		local ctrl = {f = 0, b = 0, l = 0, r = 0}
		local lastctrl = {f = 0, b = 0, l = 0, r = 0}
		local maxspeed = 50
		local speed = 0

		local bg = Instance.new("BodyGyro", UpperTorso)
		bg.P = 9e4
		bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
		bg.cframe = UpperTorso.CFrame
		local bv = Instance.new("BodyVelocity", UpperTorso)
		bv.velocity = Vector3.new(0,0.1,0)
		bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
		if nowe == true then
			plr.Character.Humanoid.PlatformStand = true
		end
		while nowe == true or game:GetService("Players").LocalPlayer.Character.Humanoid.Health == 0 do
			wait()

			if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
				speed = speed+.5+(speed/maxspeed)
				if speed > maxspeed then
					speed = maxspeed
				end
			elseif not (ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0) and speed ~= 0 then
				speed = speed-1
				if speed < 0 then
					speed = 0
				end
			end
			if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then
				bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (ctrl.f+ctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(ctrl.l+ctrl.r,(ctrl.f+ctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
				lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
			elseif (ctrl.l + ctrl.r) == 0 and (ctrl.f + ctrl.b) == 0 and speed ~= 0 then
				bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (lastctrl.f+lastctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(lastctrl.l+lastctrl.r,(lastctrl.f+lastctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
			else
				bv.velocity = Vector3.new(0,0,0)
			end
			bg.cframe = game.Workspace.CurrentCamera.CoordinateFrame * CFrame.Angles(-math.rad((ctrl.f+ctrl.b)*50*speed/maxspeed),0,0)
		end
		ctrl = {f = 0, b = 0, l = 0, r = 0}
		lastctrl = {f = 0, b = 0, l = 0, r = 0}
		speed = 0
		bg:Destroy()
		bv:Destroy()
		plr.Character.Humanoid.PlatformStand = false
		game.Players.LocalPlayer.Character.Animate.Disabled = false
		tpwalking = false
	end
end)

local tis
up.MouseButton1Down:connect(function()
	tis = up.MouseEnter:connect(function()
		while tis do
			wait()
			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0,1,0)
		end
	end)
end)

up.MouseLeave:connect(function()
	if tis then
		tis:Disconnect()
		tis = nil
	end
end)

local dis
down.MouseButton1Down:connect(function()
	dis = down.MouseEnter:connect(function()
		while dis do
			wait()
			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0,-1,0)
		end
	end)
end)

down.MouseLeave:connect(function()
	if dis then
		dis:Disconnect()
		dis = nil
	end
end)

game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function(char)
	wait(0.7)
	game.Players.LocalPlayer.Character.Humanoid.PlatformStand = false
	game.Players.LocalPlayer.Character.Animate.Disabled = false
end)

plus.MouseButton1Down:connect(function()
	speeds = speeds + 1
	speed.Text = speeds
	if nowe == true then

		tpwalking = false
		for i = 1, speeds do
			spawn(function()
				local hb = game:GetService("RunService").Heartbeat	
				tpwalking = true
				local chr = game.Players.LocalPlayer.Character
				local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
				while tpwalking and hb:Wait() and chr and hum and hum.Parent do
					if hum.MoveDirection.Magnitude > 0 then
						chr:TranslateBy(hum.MoveDirection)
					end
				end
			end)
		end
	end
end)

mine.MouseButton1Down:connect(function()
	if speeds == 1 then
		speed.Text = 'cannot be less than 1'
		wait(1)
		speed.Text = speeds
	else
		speeds = speeds - 1
		speed.Text = speeds
		if nowe == true then
			tpwalking = false
			for i = 1, speeds do
				spawn(function()
					local hb = game:GetService("RunService").Heartbeat	
					tpwalking = true
					local chr = game.Players.LocalPlayer.Character
					local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
					while tpwalking and hb:Wait() and chr and hum and hum.Parent do
						if hum.MoveDirection.Magnitude > 0 then
							chr:TranslateBy(hum.MoveDirection)
						end
					end
				end)
			end
		end
	end
end)

closebutton.MouseButton1Click:Connect(function()
	main:Destroy()
end)

mini.MouseButton1Click:Connect(function()
	up.Visible = false
	down.Visible = false
	onof.Visible = false
	plus.Visible = false
	speed.Visible = false
	mine.Visible = false
	mini.Visible = false
	mini2.Visible = true
	main.Frame.BackgroundTransparency = 1
	FrameStroke.Transparency = 1
	closebutton.Position =  UDim2.new(0, 0, -1, 48)
end)

mini2.MouseButton1Click:Connect(function()
	up.Visible = true
	down.Visible = true
	onof.Visible = true
	plus.Visible = true
	speed.Visible = true
	mine.Visible = true
	mini.Visible = true
	mini2.Visible = false
	main.Frame.BackgroundTransparency = 0.1
	FrameStroke.Transparency = 0
	closebutton.Position =  UDim2.new(0, 0, -1, 24)
end)
