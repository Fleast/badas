aa = game:GetObjects("rbxassetid://01997056190")[1]
aa.Parent = game.CoreGui
wait(0.2)

-- Load Custom Notification System
loadstring(game:HttpGet("https://raw.githubusercontent.com/Fleast/hankill/refs/heads/main/Notify.lua"))()

-- Custom Notify Function
local function CustomNotify(title, content)
    getgenv().Notify({
        Title = title,
        Content = content,
        Duration = 2
    })
end

-- Styling Modern Dark Theme
local function styleModern()
    local PopupFrame = aa.PopupFrame
    local GUI = PopupFrame.PopupFrame
    
    -- Main Frame Styling
    PopupFrame.BackgroundTransparency = 1
    
    GUI.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    GUI.BorderSizePixel = 0
    
    -- Create outer stroke
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(70, 130, 255)
    stroke.Thickness = 2
    stroke.Parent = GUI
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = GUI
    
    -- Style semua TextButtons
    for _, child in pairs(GUI:GetDescendants()) do
        if child:IsA("TextButton") then
            child.BackgroundColor3 = Color3.fromRGB(30, 35, 45)
            child.TextColor3 = Color3.fromRGB(200, 200, 200)
            child.BorderSizePixel = 0
            child.Font = Enum.Font.GothamBold
            child.TextSize = 14
            
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 6)
            btnCorner.Parent = child
            
            local btnStroke = Instance.new("UIStroke")
            btnStroke.Color = Color3.fromRGB(50, 55, 65)
            btnStroke.Thickness = 1
            btnStroke.Parent = child
        end
        
        if child:IsA("TextLabel") or child:IsA("TextBox") then
            child.BackgroundColor3 = Color3.fromRGB(25, 30, 38)
            child.TextColor3 = Color3.fromRGB(200, 200, 200)
            child.BorderSizePixel = 0
            child.Font = Enum.Font.GothamBold
            child.TextSize = 14

            if child.Text == "Edge's Audio Logger" then
                child.Text = "Scan Audio"
            end
        end
        
        if child:IsA("ScrollingFrame") then
            child.BackgroundColor3 = Color3.fromRGB(15, 18, 22)
            child.BorderSizePixel = 0
            child.ScrollBarThickness = 4
            child.ScrollBarImageColor3 = Color3.fromRGB(70, 130, 255)
        end
    end
    
    -- Posisikan tombol Close (X) dan Minimize (-) di pojok kanan
    if GUI:FindFirstChild("Close") then
        GUI.Close.Position = UDim2.new(1, -25, 0, 5)
        GUI.Close.AnchorPoint = Vector2.new(1, 0)
    end
    
    if GUI:FindFirstChild("Minimize") then
        GUI.Minimize.Position = UDim2.new(1, -50, 0, 5)
        GUI.Minimize.AnchorPoint = Vector2.new(1, 0)
    end
end

styleModern()

GUI = aa.PopupFrame.PopupFrame
pos = 0

-- Posisikan frame di atas
aa.PopupFrame.Position = UDim2.new(0.5, -190, 0, 20)
 
ignore = {
	"rbxasset://sounds/action_get_up.mp3",
	"rbxasset://sounds/uuhhh.mp3",
	"rbxasset://sounds/action_falling.mp3",
	"rbxasset://sounds/action_jump.mp3",
	"rbxasset://sounds/action_jump_land.mp3",
	"rbxasset://sounds/impact_water.mp3",
	"rbxasset://sounds/action_swim.mp3",
	"rbxassetid://3398620867",
	"rbxasset://sounds/action_footsteps_plastic.mp3"
}

-- Floating button untuk minimize
local floatingButton = Instance.new("TextButton")
floatingButton.Name = "FloatingButton"
floatingButton.Size = UDim2.new(0, 41, 0, 41)
floatingButton.Position = UDim2.new(1, -60, 0.5, -19)
floatingButton.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
floatingButton.Text = "🎵"
floatingButton.TextSize = 20
floatingButton.Font = Enum.Font.GothamBold
floatingButton.TextColor3 = Color3.fromRGB(255, 255, 255)
floatingButton.BorderSizePixel = 0
floatingButton.Visible = false
floatingButton.Parent = aa

local fbCorner = Instance.new("UICorner")
fbCorner.CornerRadius = UDim.new(0, 12)
fbCorner.Parent = floatingButton


-- Close Button (X) - tanpa animasi
GUI.Close.MouseButton1Click:connect(function()
	aa:Destroy()
end)
 
-- Minimize Button dengan floating - tanpa animasi
local min = false
GUI.Minimize.MouseButton1Click:connect(function()
	if min == false then
		GUI.Parent.Visible = false
		floatingButton.Visible = true
		min = true
	else
		floatingButton.Visible = false
		GUI.Parent.Visible = true
		min = false
	end
end)

-- Floating button restore - tanpa animasi
floatingButton.MouseButton1Click:Connect(function()
	floatingButton.Visible = false
	GUI.Parent.Visible = true
	min = false
end)

function printTable(tbl)
	if type(tbl) ~= 'table' then return nil end
	local depthCount = -15
 
	local function run(val, inPrefix)
		depthCount = depthCount + 15
		for i,v in pairs(val) do
			if type(v) == 'table' then
				GUI.Store.Text = GUI.Store.Text..'\n'..string.rep(' ', depthCount) .. ' [' .. tostring(i) .. '] = {'
				run(v, false)
				wait()
			else
				GUI.Store.Text = GUI.Store.Text..'\n'..string.rep(' ', depthCount) .. ' [' .. tostring(i) .. '] = ' .. tostring(v)
				wait()
			end
		end
		depthCount = depthCount - 15
	end
	run(tbl, true)
end
 
function refreshlist()
	pos = 0
	GUI.Logs.CanvasSize = UDim2.new(0,0,0,0)
	for i,v in pairs(GUI.Logs:GetChildren()) do
		v.Position = UDim2.new(0,0,0, pos)
		GUI.Logs.CanvasSize = UDim2.new(0,0,0, pos+20)
		pos = pos+20
	end
end
 
function FindTable(Table, Name)
	for i,v in pairs(Table) do
		if v == Name then
			return true
		end end
	return false
end
 
function writefileExploit()
	if writefile then
		return true
	end
end
 
writeaudio = {}
running = false
GUI.SS.MouseButton1Click:connect(function()
	if writefileExploit() then
		if running == false then
			GUI.Load.Visible = true running = true
			GUI.Load.Size = UDim2.new(0, 360, 0, 20)
			wait(0.3)
			
			for _, child in pairs(GUI.Logs:GetChildren()) do
				if child:FindFirstChild('ImageButton') then local bttn = child:FindFirstChild('ImageButton')
					if bttn.BackgroundTransparency == 0 then
						writeaudio[#writeaudio + 1] = {NAME = child.NAME.Value, ID = child.ID.Value}
					end
				end
			end
			
			GUI.Store.Visible = true
			printTable(writeaudio)
			wait(0.2)
			
			local filename = 0
			local function write()
				local file
				pcall(function() file = readfile("Audios"..filename..".txt") end)
				if file then
					filename = filename+1
					write()
				else
					local text = tostring(GUI.Store.Text)
					text = text:gsub('\n', '\r\n')
					writefile("Audios"..filename..".txt", text)
				end
			end
			
			write()
			for rep = 1,10 do
			GUI.Load.BackgroundTransparency = GUI.Load.BackgroundTransparency + 0.1
			wait(0.05)
			end
			
			GUI.Load.Visible = false
			GUI.Load.BackgroundTransparency = 0
			GUI.Load.Size = UDim2.new(0, 0, 0, 20)
			running = false
			GUI.Store.Visible = false
			GUI.Store.Text = ''
			writeaudio = {}
			
			CustomNotify('Scan Audio', 'Saved audios\n(Audios'..filename..'.txt)')
		end
	else
		CustomNotify('Scan Audio', 'Exploit cannot writefile :(')
	end
end)
 
GUI.SA.MouseButton1Click:connect(function()
	if writefileExploit() then
		if running == false then
			GUI.Load.Visible = true running = true
			GUI.Load.Size = UDim2.new(0, 360, 0, 20)
			wait(0.3)
			for _, child in pairs(GUI.Logs:GetChildren()) do
				writeaudio[#writeaudio + 1] = {NAME = child.NAME.Value, ID = child.ID.Value}
			end
			GUI.Store.Visible = true
			printTable(writeaudio)
			wait(0.2)
			local filename = 0
			
			local function write()
				local file
				pcall(function() file = readfile("Audios"..filename..".txt") end)
				if file then
					filename = filename+1
					write()
				else
					local text = tostring(GUI.Store.Text)
					text = text:gsub('\n', '\r\n')
					writefile("Audios"..filename..".txt", text)
				end
			end
			
			write()
			for rep = 1,10 do
				GUI.Load.BackgroundTransparency = GUI.Load.BackgroundTransparency + 0.1
				wait(0.05)
			end
			
			GUI.Load.Visible = false
			GUI.Load.BackgroundTransparency = 0
			GUI.Load.Size = UDim2.new(0, 0, 0, 20)
			running = false
			GUI.Store.Visible = false
			GUI.Store.Text = ''
			
			writeaudio = {}
			CustomNotify('Scan Audio', 'Saved audios\n(Audios'..filename..'.txt)')
		end
	else
		CustomNotify('Scan Audio', 'Exploit cannot writefile :(')
	end
end)
 
selectedaudio = nil
function getaudio(place)
	if running == false then
		GUI.Load.Visible = true running = true
		GUI.Load.Size = UDim2.new(0, 360, 0, 20)
		wait(0.3)
		for _, child in pairs(place:GetDescendants()) do
			spawn(function()
				if child:IsA("Sound") and not GUI.Logs:FindFirstChild(child.SoundId) and not FindTable(ignore,child.SoundId) then
					local id = string.match(child.SoundId, "rbxasset://sounds.+") or string.match(child.SoundId, "&hash=.+") or string.match(child.SoundId, "%d+")
					if id ~= nil then		
						local newsound = GUI.Audio:Clone()
						if string.sub(id, 1, 6) == "&hash=" or string.sub(id, 1, 7) == "&0hash=" then
							id = string.sub(id, (string.sub(id, 1, 6) == "&hash=" and 7) or (string.sub(id, 1, 7) == "&0hash=" and 8), string.len(id))
							newsound.ImageButton.Image = 'rbxassetid://1453863294'
						end
						
						newsound.Parent = GUI.Logs
						newsound.Name = child.SoundId
						newsound.Visible = true
						newsound.Position = UDim2.new(0, 0, 0, pos)
						GUI.Logs.CanvasSize = UDim2.new(0,0,0, pos+20)
						pos = pos + 20
						
						local function findname()
							Asset = game:GetService("MarketplaceService"):GetProductInfo(id)
						end
						
						local audioname = 'error'
						local success, message = pcall(findname)
						if success then
    						newsound.TextLabel.Text = Asset.Name
							audioname = Asset.Name
						else
							newsound.TextLabel.Text = child.Name
							audioname = child.Name
						end
						
						local data = Instance.new('StringValue') data.Parent = newsound data.Value = child.SoundId data.Name = 'ID'
						local data2 = Instance.new('StringValue') data2.Parent = newsound data2.Value = audioname data2.Name = 'NAME'
						local soundselected = false
						newsound.ImageButton.MouseButton1Click:Connect(function()
							if GUI.Info.Visible ~= true then
								if soundselected == false then soundselected = true
									newsound.ImageButton.BackgroundTransparency = 0
								else soundselected = false
									newsound.ImageButton.BackgroundTransparency = 1
								end
							end
						end)
						
						newsound.Click.MouseButton1Click:Connect(function()
							if GUI.Info.Visible ~= true then
								GUI.Info.TextLabel.Text = "Name: " ..audioname.. "\nID: " .. child.SoundId .. "\nWorkspace Name: " .. child.Name .. "\nVolume: " .. child.Volume .. "\nPlaybackSpeed: " .. child.PlaybackSpeed .. "\nPitch: " .. child.Pitch
								
								if child:FindFirstChildOfClass("EchoSoundEffect") then
                                  local echo = child:FindFirstChildOfClass("EchoSoundEffect")
                                  GUI.Info.TextLabel.Text = GUI.Info.TextLabel.Text .. "\n\nEcho Sound Effect Properties:\nDelay: " .. echo.Delay .. "\nDry Level: " .. echo.DryLevel .. "\nFeedback: " .. echo.Feedback .. "\nWet Level: " .. echo.WetLevel
                                end
								
								selectedaudio = child.SoundId
								GUI.Info.Visible = true
							end
						end)
					end
				end
			end)
		end
	end
	
	for rep = 1,10 do
		GUI.Load.BackgroundTransparency = GUI.Load.BackgroundTransparency + 0.1
		wait(0.05)
	end
	
	GUI.Load.Visible = false
	GUI.Load.BackgroundTransparency = 0
	GUI.Load.Size = UDim2.new(0, 0, 0, 20)
	running = false
end
 
GUI.All.MouseButton1Click:connect(function() getaudio(game) end)
GUI.Workspace.MouseButton1Click:connect(function() getaudio(workspace) end)
GUI.Lighting.MouseButton1Click:connect(function() getaudio(game:GetService('Lighting')) end)
GUI.SoundS.MouseButton1Click:connect(function() getaudio(game:GetService('SoundService')) end)

GUI.Clr.MouseButton1Click:connect(function()
	for _, child in pairs(GUI.Logs:GetChildren()) do
		if child:FindFirstChild('ImageButton') then local bttn = child:FindFirstChild('ImageButton')
			if bttn.BackgroundTransparency == 1 then
				bttn.Parent:Destroy()
				refreshlist()
			end
		end
	end
end)

GUI.ClrS.MouseButton1Click:connect(function()
	for _, child in pairs(GUI.Logs:GetChildren()) do
		if child:FindFirstChild('ImageButton') then local bttn = child:FindFirstChild('ImageButton')
			if bttn.BackgroundTransparency == 0 then
				bttn.Parent:Destroy()
				refreshlist()
			end
		end
	end
end)

autoscan = false
GUI.AutoScan.MouseButton1Click:connect(function()
	if autoscan == false then autoscan = true
		GUI.AutoScan.BackgroundTransparency = 0.5
		CustomNotify('Scan Audio', 'Auto Scan ENABLED')
	else autoscan = false
		GUI.AutoScan.BackgroundTransparency = 0
		CustomNotify('Scan Audio', 'Auto Scan DISABLED')
	end
end)
 
game.DescendantAdded:connect(function(added)
	task.wait()
	if autoscan == true and added:IsA('Sound') and not GUI.Logs:FindFirstChild(added.SoundId) and not FindTable(ignore,added.SoundId) then
		local id = string.match(added.SoundId, "rbxasset://sounds.+") or string.match(added.SoundId, "&hash=.+") or string.match(added.SoundId, "%d+")
		if id ~= nil then		
			local newsound = GUI.Audio:Clone()
				if string.sub(id, 1, 6) == "&hash=" or string.sub(id, 1, 7) == "&0hash=" then
					id = string.sub(id, (string.sub(id, 1, 6) == "&hash=" and 7) or (string.sub(id, 1, 7) == "&0hash=" and 8), string.len(id))
					newsound.ImageButton.Image = 'rbxassetid://1453863294'
				end
				
				local scrolldown = false
				newsound.Parent = GUI.Logs
				newsound.Name = added.SoundId
				newsound.Visible = true
				newsound.Position = UDim2.new(0, 0, 0, pos)
				
				if GUI.Logs.CanvasPosition.Y == GUI.Logs.CanvasSize.Y.Offset - 230 then
					scrolldown = true
				end
				
				GUI.Logs.CanvasSize = UDim2.new(0,0,0, pos+20)
				pos = pos+20
				
				local function findname()
					Asset = game:GetService("MarketplaceService"):GetProductInfo(id)
				end
				
				local audioname = 'error'
				local success, message = pcall(findname)
				if success then
    				newsound.TextLabel.Text = Asset.Name
					audioname = Asset.Name
				else 
					newsound.TextLabel.Text = added.Name
					audioname = added.Name
				end
				
				local data = Instance.new('StringValue') data.Parent = newsound data.Value = added.SoundId data.Name = 'ID'
				local data2 = Instance.new('StringValue') data2.Parent = newsound data2.Value = audioname data2.Name = 'NAME'
				local soundselected = false
				newsound.ImageButton.MouseButton1Click:Connect(function()
					if GUI.Info.Visible ~= true then
						if soundselected == false then soundselected = true
							newsound.ImageButton.BackgroundTransparency = 0
						else soundselected = false
							newsound.ImageButton.BackgroundTransparency = 1
						end
					end
				end)
				
				newsound.Click.MouseButton1Click:Connect(function()
					if GUI.Info.Visible ~= true then
						GUI.Info.TextLabel.Text = "Name: " ..audioname.. "\nID: " .. added.SoundId .. "\nWorkspace Name: " .. added.Name .. "\nVolume: " .. added.Volume .. "\nPlaybackSpeed: " .. added.PlaybackSpeed .. "\nPitch: " .. added.Pitch
						
						for _, ss in next, added:GetChildren() do
						  if ss:IsA("SoundEffect") then
						    GUI.Info.TextLabel.Text = GUI.Info.TextLabel.Text .. "\n" .. ss.ClassName
						  end
						end
						
						if added:FindFirstChildOfClass("EchoSoundEffect") then
                          local echo = added:FindFirstChildOfClass("EchoSoundEffect")
                          GUI.Info.TextLabel.Text = GUI.Info.TextLabel.Text .. "\n\nEcho Sound Effect Properties:\nDelay: " .. echo.Delay .. "\nDry Level: " .. echo.DryLevel .. "\nFeedback: " .. echo.Feedback .. "\nWet Level: " .. echo.WetLevel
                        end
						
						selectedaudio = added.SoundId
						GUI.Info.Visible = true
					end
				end)
				
			if scrolldown == true then
				GUI.Logs.CanvasPosition = Vector2.new(0, 9999999999999999999999999999999999999999999, 0, 0)
			end
		end
	end
end)
 
GUI.Info.Copy.MouseButton1Click:Connect(function()
	if pcall(function() Synapse:Copy(selectedaudio) end) then	
	else
		local clip = setclipboard or Clipboard.set
		clip(selectedaudio)
	end
	
	CustomNotify('Scan Audio', 'Copied to clipboard')
end)
 
GUI.Info.Close.MouseButton1Click:Connect(function()
	GUI.Info.Visible = false
	for _, sound in pairs(game:GetService('Players').LocalPlayer.PlayerGui:GetChildren()) do
		if sound.Name == 'SampleSound' then
			sound:Destroy()
		end
	end
	GUI.Info.Listen.Text = 'Listen'
end)
 
GUI.Info.Listen.MouseButton1Click:Connect(function()
	if GUI.Info.Listen.Text == 'Listen' then
		local samplesound = Instance.new('Sound') samplesound.Parent = game:GetService('Players').LocalPlayer.PlayerGui
		samplesound.Looped = true samplesound.SoundId = selectedaudio samplesound:Play() samplesound.Name = 'SampleSound'
		samplesound.Volume = 1
		GUI.Info.Listen.Text = 'Stop'
	else
		for _, sound in pairs(game:GetService('Players').LocalPlayer.PlayerGui:GetChildren()) do
			if sound.Name == 'SampleSound' then
				sound:Destroy()
			end
		end
		GUI.Info.Listen.Text = 'Listen'
	end
end)
 
function drag(gui)
	spawn(function()
		local UserInputService = game:GetService("UserInputService")
		local dragging
		local dragInput
		local dragStart
		local startPos
		local function update(input)
			local delta = input.Position - dragStart
			gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
		gui.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = gui.Position
		input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)
gui.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)
end)
end

drag(aa.PopupFrame)
drag(floatingButton)