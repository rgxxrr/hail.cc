--==================================================
-- SAFE GUI PARENT
--==================================================
local CoreGui = gethui and gethui() or game:GetService("CoreGui")

--==================================================
-- SERVICES
--==================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local SoundService = game:GetService("SoundService")

--==================================================
-- SETTINGS
--==================================================
local Settings = {
	BoxESP = false,
	NameESP = false,
	Aimbot = false,
	Triggerbot = false,

	AimBind = Enum.UserInputType.MouseButton2,
	TriggerBind = Enum.UserInputType.MouseButton1,
	MenuKey = Enum.KeyCode.Insert,

	AimFOV = 150,
	Smoothness = 0.18,

	VisualHitbox = false,
	HitboxX = 150,
	HitboxY = 20
}

local MenuVisible = true

--==================================================
-- INPUT CHECK
--==================================================
local function IsBindDown(bind)
	if bind.EnumType == Enum.KeyCode then
		return UIS:IsKeyDown(bind)
	else
		return UIS:IsMouseButtonPressed(bind)
	end
end

--==================================================
-- GUI + SOUNDS
--==================================================
local Gui = Instance.new("ScreenGui", CoreGui)
Gui.Name = "hail.cc"

local function MakeSound(id, vol)
	local s = Instance.new("Sound")
	s.SoundId = "rbxassetid://" .. id
	s.Volume = vol
	s.Parent = SoundService
	return s
end

local S_Toggle = MakeSound(9118823107, 0.4)
local S_Tab    = MakeSound(9118826048, 0.35)
local S_Open   = MakeSound(9118828565, 0.45)
task.spawn(function() S_Open:Play() end)

--==================================================
-- MAIN FRAME
--==================================================
local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.new(0,420,0,500)
Main.Position = UDim2.new(0.5,-210,0.5,-250)
Main.BackgroundColor3 = Color3.fromRGB(8,8,8)
Main.Active = true
Main.Draggable = true
Main.ClipsDescendants = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0,18)

local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Color3.fromRGB(200,40,40)
Stroke.Thickness = 1.5

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1,0,0,40)
Title.BackgroundTransparency = 1
Title.Text = "hail.cc"
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 28
Title.TextColor3 = Color3.fromRGB(220,50,50)

--==================================================
-- TABS
--==================================================
local CurrentTab

local function CreateTabButton(text,x)
	local b = Instance.new("TextButton", Main)
	b.Size = UDim2.new(0,120,0,32)
	b.Position = UDim2.new(0,x,0,44)
	b.Text = text
	b.Font = Enum.Font.GothamSemibold
	b.TextSize = 14
	b.BackgroundColor3 = Color3.fromRGB(18,18,18)
	b.TextColor3 = Color3.new(1,1,1)
	Instance.new("UICorner", b)
	b.MouseButton1Click:Connect(function() S_Tab:Play() end)
	return b
end

local function CreateTab()
	local f = Instance.new("Frame", Main)
	f.Size = UDim2.new(1,0,1,-90)
	f.Position = UDim2.new(0,0,0,90)
	f.BackgroundTransparency = 1
	f.Visible = false
	return f
end

local VisualTab = CreateTab()
local AimTab = CreateTab()
local SettingsTab = CreateTab()

local TabWidth, TabSpacing = 120, 16
local StartX = (420 - ((TabWidth*3)+(TabSpacing*2))) / 2

local VisualBtn   = CreateTabButton("Visuals",StartX)
local AimTabBtn   = CreateTabButton("Aimbot",StartX+TabWidth+TabSpacing)
local SettingsBtn = CreateTabButton("Settings",StartX+(TabWidth+TabSpacing)*2)

VisualTab.Visible = true
CurrentTab = VisualTab

VisualBtn.MouseButton1Click:Connect(function() CurrentTab.Visible=false VisualTab.Visible=true CurrentTab=VisualTab end)
AimTabBtn.MouseButton1Click:Connect(function() CurrentTab.Visible=false AimTab.Visible=true CurrentTab=AimTab end)
SettingsBtn.MouseButton1Click:Connect(function() CurrentTab.Visible=false SettingsTab.Visible=true CurrentTab=SettingsTab end)

--==================================================
-- BUTTON + SLIDER HELPERS
--==================================================
local function Button(parent,text,y)
	local b = Instance.new("TextButton", parent)
	b.Size = UDim2.new(0.9,0,0,36)
	b.Position = UDim2.new(0.05,0,0,y)
	b.Text = text
	b.Font = Enum.Font.GothamMedium
	b.TextSize = 15
	b.BackgroundColor3 = Color3.fromRGB(20,20,20)
	b.TextColor3 = Color3.new(1,1,1)
	Instance.new("UICorner", b)
	b.MouseButton1Click:Connect(function() S_Toggle:Play() end)
	return b
end

local function Slider(parent,text,y,min,max,default,callback)
	local f = Instance.new("Frame", parent)
	f.Size = UDim2.new(0.9,0,0,52)
	f.Position = UDim2.new(0.05,0,0,y)
	f.BackgroundColor3 = Color3.fromRGB(20,20,20)
	Instance.new("UICorner", f)

	local lbl = Instance.new("TextLabel", f)
	lbl.Size = UDim2.new(1,0,0,20)
	lbl.BackgroundTransparency = 1
	lbl.Text = text..": "..default
	lbl.Font = Enum.Font.GothamMedium
	lbl.TextSize = 14
	lbl.TextColor3 = Color3.new(1,1,1)

	local bar = Instance.new("Frame", f)
	bar.Size = UDim2.new(0.9,0,0,6)
	bar.Position = UDim2.new(0.05,0,0,32)
	bar.BackgroundColor3 = Color3.fromRGB(35,35,35)
	Instance.new("UICorner", bar)

	local fill = Instance.new("Frame", bar)
	fill.Size = UDim2.new((default-min)/(max-min),0,1,0)
	fill.BackgroundColor3 = Color3.fromRGB(220,50,50)
	Instance.new("UICorner", fill)

	local dragging = false

	bar.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
	end)
	UIS.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
	end)
	UIS.InputChanged:Connect(function(i)
		if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
			local r = math.clamp((i.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X,0,1)
			local v = math.floor(min + (max-min)*r)
			fill.Size = UDim2.new(r,0,1,0)
			lbl.Text = text..": "..v
			callback(v)
		end
	end)
end

--==================================================
-- VISUAL TAB
--==================================================
local BoxBtn  = Button(VisualTab,"Box ESP: OFF",10)
local NameBtn = Button(VisualTab,"Name ESP: OFF",56)

--==================================================
-- AIM TAB
--==================================================
local AimBtn    = Button(AimTab,"Aimbot: OFF",10)
local AimKeyBtn = Button(AimTab,"   Aim Key: RMB",54)

local TrigBtn    = Button(AimTab,"Triggerbot: OFF",110)
local TrigKeyBtn = Button(AimTab,"   Trigger Key: LMB",154)

local VisHitBtn = Button(AimTab,"Visual Hitbox: OFF",200)

Slider(AimTab,"Hitbox X",250,5,300,Settings.HitboxX,function(v) Settings.HitboxX=v end)
Slider(AimTab,"Hitbox Y",310,5,300,Settings.HitboxY,function(v) Settings.HitboxY=v end)
Slider(AimTab,"Aim Smoothness",370,1,100,math.floor(Settings.Smoothness*100),function(v)
	Settings.Smoothness = v/100
end)

AimKeyBtn.Visible=false
TrigKeyBtn.Visible=false

--==================================================
-- SETTINGS TAB
--==================================================
local MenuKeyBtn = Button(SettingsTab,"Menu Key: INSERT",10)

--==================================================
-- ESP SYSTEM
--==================================================
local ESP = {}

local function CreateESP(p)
	if p == LocalPlayer then return end

	local box = Drawing.new("Square")
	box.Thickness = 1.5
	box.Filled = false
	box.Color = Color3.fromRGB(255,70,70)
	box.Visible = false

	local name = Drawing.new("Text")
	name.Center = true
	name.Outline = true
	name.Size = 16 -- FIX: readable size
	name.Color = Color3.new(1,1,1)
	name.Visible = false

	ESP[p] = {Box = box, Name = name}
end

for _,p in ipairs(Players:GetPlayers()) do
	CreateESP(p)
end

Players.PlayerAdded:Connect(CreateESP)

Players.PlayerRemoving:Connect(function(p)
	if ESP[p] then
		ESP[p].Box:Remove()
		ESP[p].Name:Remove()
		ESP[p] = nil
	end
end)

RunService.RenderStepped:Connect(function()
	for p,e in pairs(ESP) do
		local c = p.Character
		local hrp = c and c:FindFirstChild("HumanoidRootPart")
		local head = c and c:FindFirstChild("Head")
		local hum = c and c:FindFirstChild("Humanoid")

		if not (hrp and head and hum and hum.Health > 0) then
			e.Box.Visible = false
			e.Name.Visible = false
			continue
		end

		-- FIX: use top & bottom for proper box sizing
		local topPos, topVis = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
		local botPos, botVis = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))

		if not (topVis and botVis) then
			e.Box.Visible = false
			e.Name.Visible = false
			continue
		end

		local height = math.clamp(math.abs(topPos.Y - botPos.Y), 35, 400)
		local width = height * 0.55

		e.Box.Size = Vector2.new(width, height)
		e.Box.Position = Vector2.new(
			topPos.X - width / 2,
			topPos.Y
		)
		e.Box.Visible = Settings.BoxESP

		e.Name.Text = p.DisplayName
		e.Name.Position = Vector2.new(
			topPos.X,
			topPos.Y - 18
		)
		e.Name.Visible = Settings.NameESP
	end
end)

--==================================================
-- AIMBOT
--==================================================
RunService.RenderStepped:Connect(function()
	if Settings.Aimbot and IsBindDown(Settings.AimBind) then
		local best,dist=nil,math.huge
		for _,p in ipairs(Players:GetPlayers()) do
			if p~=LocalPlayer then
				local hrp=p.Character and p.Character:FindFirstChild("HumanoidRootPart")
				local hum=p.Character and p.Character:FindFirstChild("Humanoid")
				if hrp and hum and hum.Health>0 then
					local pos,vis=Camera:WorldToViewportPoint(hrp.Position)
					if vis then
						local d=(Vector2.new(pos.X,pos.Y)-UIS:GetMouseLocation()).Magnitude
						if d<Settings.AimFOV and d<dist then
							dist=d
							best=hrp
						end
					end
				end
			end
		end
		if best then
			Camera.CFrame = Camera.CFrame:Lerp(
				CFrame.new(Camera.CFrame.Position,best.Position),
				Settings.Smoothness
			)
		end
	end
end)

--==================================================
-- VISUAL HITBOX + TRIGGERBOT
--==================================================
local Hitbox = Drawing.new("Square")
Hitbox.Color = Color3.fromRGB(255,60,60)
Hitbox.Thickness = 1
Hitbox.Filled = false
Hitbox.Visible = false

RunService.RenderStepped:Connect(function()
	local m = UIS:GetMouseLocation()

	if Settings.VisualHitbox then
		Hitbox.Size = Vector2.new(Settings.HitboxX*2,Settings.HitboxY*2)
		Hitbox.Position = Vector2.new(m.X-Settings.HitboxX,m.Y-Settings.HitboxY)
		Hitbox.Visible = true
	else
		Hitbox.Visible = false
	end

	if Settings.Triggerbot and IsBindDown(Settings.TriggerBind) then
		for _,p in ipairs(Players:GetPlayers()) do
			if p~=LocalPlayer then
				local hrp=p.Character and p.Character:FindFirstChild("HumanoidRootPart")
				local hum=p.Character and p.Character:FindFirstChild("Humanoid")
				if hrp and hum and hum.Health>0 then
					local pos,vis=Camera:WorldToViewportPoint(hrp.Position)
					if vis and math.abs(pos.X-m.X)<=Settings.HitboxX and math.abs(pos.Y-m.Y)<=Settings.HitboxY then
						VIM:SendMouseButtonEvent(0,0,0,true,game,0)
						VIM:SendMouseButtonEvent(0,0,0,false,game,0)
						break
					end
				end
			end
		end
	end
end)

--==================================================
-- TOGGLES + KEYBINDS
--==================================================
AimBtn.MouseButton1Click:Connect(function()
	Settings.Aimbot=not Settings.Aimbot
	AimBtn.Text="Aimbot: "..(Settings.Aimbot and "ON" or "OFF")
	AimKeyBtn.Visible=Settings.Aimbot
end)

TrigBtn.MouseButton1Click:Connect(function()
	Settings.Triggerbot=not Settings.Triggerbot
	TrigBtn.Text="Triggerbot: "..(Settings.Triggerbot and "ON" or "OFF")
	TrigKeyBtn.Visible=Settings.Triggerbot
end)

VisHitBtn.MouseButton1Click:Connect(function()
	Settings.VisualHitbox=not Settings.VisualHitbox
	VisHitBtn.Text="Visual Hitbox: "..(Settings.VisualHitbox and "ON" or "OFF")
end)

BoxBtn.MouseButton1Click:Connect(function()
	Settings.BoxESP=not Settings.BoxESP
	BoxBtn.Text="Box ESP: "..(Settings.BoxESP and "ON" or "OFF")
end)

NameBtn.MouseButton1Click:Connect(function()
	Settings.NameESP=not Settings.NameESP
	NameBtn.Text="Name ESP: "..(Settings.NameESP and "ON" or "OFF")
end)

local waitAim,waitTrig,waitMenu=false,false,false

AimKeyBtn.MouseButton1Click:Connect(function()
	AimKeyBtn.Text="   Press key..."
	waitAim=true
end)

TrigKeyBtn.MouseButton1Click:Connect(function()
	TrigKeyBtn.Text="   Press key..."
	waitTrig=true
end)

MenuKeyBtn.MouseButton1Click:Connect(function()
	MenuKeyBtn.Text="Menu Key: ..."
	waitMenu=true
end)

UIS.InputBegan:Connect(function(i,gp)
	if gp then return end

	if waitAim then
		Settings.AimBind=i.KeyCode~=Enum.KeyCode.Unknown and i.KeyCode or i.UserInputType
		AimKeyBtn.Text="   Aim Key: "..Settings.AimBind.Name
		waitAim=false
		return
	end

	if waitTrig then
		Settings.TriggerBind=i.KeyCode~=Enum.KeyCode.Unknown and i.KeyCode or i.UserInputType
		TrigKeyBtn.Text="   Trigger Key: "..Settings.TriggerBind.Name
		waitTrig=false
		return
	end

	if waitMenu and i.KeyCode~=Enum.KeyCode.Unknown then
		Settings.MenuKey=i.KeyCode
		MenuKeyBtn.Text="Menu Key: "..i.KeyCode.Name
		waitMenu=false
		return
	end

	if i.KeyCode==Settings.MenuKey then
		MenuVisible=not MenuVisible
		Main.Visible=MenuVisible
	end
end)

--==================================================
-- CREDIT
--==================================================
local Credit = Instance.new("TextLabel", Main)
Credit.Size = UDim2.new(0,120,0,18)
Credit.Position = UDim2.new(1,-125,1,-22)
Credit.BackgroundTransparency = 1
Credit.Text = "HAIL PUBLIC @RGXR"
Credit.Font = Enum.Font.GothamMedium
Credit.TextSize = 12
Credit.TextColor3 = Color3.fromRGB(120,120,120)
Credit.TextXAlignment = Enum.TextXAlignment.Right





UIS.InputBegan:Connect(function(input,gp)
	if gp then return end
	if waitAim then
		Settings.AimBind=input.KeyCode~=Enum.KeyCode.Unknown and input.KeyCode or input.UserInputType
		AimKeyBtn.Text="   Aim Key: "..Settings.AimBind.Name
		waitAim=false
	elseif waitTrig then
		Settings.TriggerBind=input.KeyCode~=Enum.KeyCode.Unknown and input.KeyCode or input.UserInputType
		TrigKeyBtn.Text="   Trigger Key: "..Settings.TriggerBind.Name
		waitTrig=false
	end
end)
