--// MT7 - Speed Booster TEST
--// Para uso no seu próprio jogo/place

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

local DEFAULT_SPEED = 16
local MIN_SPEED = 1
local MAX_SPEED = 500

local speed = 100
local enabled = false

--// GUI
local gui = Instance.new("ScreenGui")
gui.Name = "MT7_SpeedTest"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

--// Botão flutuante
local openButton = Instance.new("TextButton")
openButton.Size = UDim2.fromOffset(70, 70)
openButton.Position = UDim2.new(0, 20, 0.5, -35)
openButton.BackgroundColor3 = Color3.fromRGB(5, 5, 8)
openButton.Text = "MT7"
openButton.TextColor3 = Color3.fromRGB(0, 170, 255)
openButton.TextSize = 22
openButton.Font = Enum.Font.GothamBold
openButton.Parent = gui

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(1, 0)
buttonCorner.Parent = openButton

local buttonStroke = Instance.new("UIStroke")
buttonStroke.Color = Color3.fromRGB(0, 170, 255)
buttonStroke.Thickness = 2
buttonStroke.Parent = openButton

--// Painel
local panel = Instance.new("Frame")
panel.Size = UDim2.fromOffset(330, 250)
panel.Position = UDim2.new(0.5, -165, 0.5, -125)
panel.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
panel.Visible = false
panel.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 16)
corner.Parent = panel

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(0, 170, 255)
stroke.Thickness = 2
stroke.Parent = panel

--// Título
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 0, 45)
title.Position = UDim2.fromOffset(10, 5)
title.BackgroundTransparency = 1
title.Text = "⚡ MT7 SPEED BOOSTER"
title.TextColor3 = Color3.fromRGB(0, 170, 255)
title.TextSize = 20
title.Font = Enum.Font.GothamBold
title.Parent = panel

--// Status
local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -20, 0, 30)
status.Position = UDim2.fromOffset(10, 50)
status.BackgroundTransparency = 1
status.Text = "Status: OFF"
status.TextColor3 = Color3.fromRGB(255, 80, 80)
status.TextSize = 16
status.Font = Enum.Font.GothamBold
status.Parent = panel

--// Campo de velocidade
local speedBox = Instance.new("TextBox")
speedBox.Size = UDim2.fromOffset(100, 40)
speedBox.Position = UDim2.fromOffset(20, 90)
speedBox.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
speedBox.Text = tostring(speed)
speedBox.PlaceholderText = "Speed"
speedBox.TextColor3 = Color3.new(1, 1, 1)
speedBox.TextSize = 17
speedBox.Font = Enum.Font.Gotham
speedBox.ClearTextOnFocus = false
speedBox.Parent = panel

local boxCorner = Instance.new("UICorner")
boxCorner.CornerRadius = UDim.new(0, 8)
boxCorner.Parent = speedBox

--// Slider
local sliderBack = Instance.new("Frame")
sliderBack.Size = UDim2.fromOffset(180, 10)
sliderBack.Position = UDim2.fromOffset(135, 105)
sliderBack.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
sliderBack.Parent = panel

local sliderCorner = Instance.new("UICorner")
sliderCorner.CornerRadius = UDim.new(1, 0)
sliderCorner.Parent = sliderBack

local sliderFill = Instance.new("Frame")
sliderFill.Size = UDim2.new((speed - MIN_SPEED) / (MAX_SPEED - MIN_SPEED), 0, 1, 0)
sliderFill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
sliderFill.Parent = sliderBack

local fillCorner = Instance.new("UICorner")
fillCorner.CornerRadius = UDim.new(1, 0)
fillCorner.Parent = sliderFill

--// Botão ON/OFF
local toggle = Instance.new("TextButton")
toggle.Size = UDim2.fromOffset(290, 45)
toggle.Position = UDim2.fromOffset(20, 145)
toggle.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
toggle.Text = "⚡ ATIVAR SPEED"
toggle.TextColor3 = Color3.fromRGB(0, 170, 255)
toggle.TextSize = 17
toggle.Font = Enum.Font.GothamBold
toggle.Parent = panel

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 10)
toggleCorner.Parent = toggle

--// Reset
local reset = Instance.new("TextButton")
reset.Size = UDim2.fromOffset(290, 35)
reset.Position = UDim2.fromOffset(20, 198)
reset.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
reset.Text = "↩ Resetar para 16"
reset.TextColor3 = Color3.new(1, 1, 1)
reset.TextSize = 14
reset.Font = Enum.Font.Gotham
reset.Parent = panel

local resetCorner = Instance.new("UICorner")
resetCorner.CornerRadius = UDim.new(0, 8)
resetCorner.Parent = reset

--// Aplica a velocidade
local function applySpeed()
	local character = player.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")

	if humanoid then
		humanoid.WalkSpeed = enabled and speed or DEFAULT_SPEED
	end
end

--// Atualiza valor
local function setSpeed(value)
	value = tonumber(value)

	if not value then
		speedBox.Text = tostring(speed)
		return
	end

	speed = math.clamp(math.floor(value), MIN_SPEED, MAX_SPEED)
	speedBox.Text = tostring(speed)

	local percent = (speed - MIN_SPEED) / (MAX_SPEED - MIN_SPEED)
	sliderFill.Size = UDim2.new(percent, 0, 1, 0)

	applySpeed()
end

--// Campo numérico
speedBox.FocusLost:Connect(function()
	setSpeed(speedBox.Text)
end)

--// Slider mobile
local draggingSlider = false

local function updateSlider(inputX)
	local relative = math.clamp(
		(inputX - sliderBack.AbsolutePosition.X) / sliderBack.AbsoluteSize.X,
		0,
		1
	)

	local value = MIN_SPEED + ((MAX_SPEED - MIN_SPEED) * relative)
	setSpeed(value)
end

sliderBack.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

		draggingSlider = true
		updateSlider(input.Position.X)
	end
end)

sliderBack.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

		draggingSlider = false
	end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
	if draggingSlider then
		if input.UserInputType == Enum.UserInputType.MouseMovement
			or input.UserInputType == Enum.UserInputType.Touch then

			updateSlider(input.Position.X)
		end
	end
end)

--// Toggle
toggle.Activated:Connect(function()
	enabled = not enabled

	if enabled then
		status.Text = "Status: ON"
		status.TextColor3 = Color3.fromRGB(80, 255, 120)
		toggle.Text = "🟢 SPEED ATIVADA"
	else
		status.Text = "Status: OFF"
		status.TextColor3 = Color3.fromRGB(255, 80, 80)
		toggle.Text = "⚡ ATIVAR SPEED"
	end

	applySpeed()
end)

--// Reset
reset.Activated:Connect(function()
	setSpeed(DEFAULT_SPEED)
end)

--// Respawn
player.CharacterAdded:Connect(function()
	task.wait(0.5)
	applySpeed()
end)

--// Animação abrir/fechar
local scale = Instance.new("UIScale")
scale.Scale = 0.85
scale.Parent = panel

local opened = false

local function openPanel()
	opened = true
	panel.Visible = true
	scale.Scale = 0.85

	TweenService:Create(
		scale,
		TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
		{Scale = 1}
	):Play()
end

local function closePanel()
	opened = false

	local tween = TweenService:Create(
		scale,
		TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
		{Scale = 0.85}
	)

	tween:Play()
	tween.Completed:Connect(function()
		if not opened then
			panel.Visible = false
		end
	end)
end

openButton.Activated:Connect(function()
	if opened then
		closePanel()
	else
		openPanel()
	end
end)
