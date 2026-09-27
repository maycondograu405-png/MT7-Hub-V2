--========================================================--
--                     MT7 CONTROL                       --
--      LocalScript - StarterPlayerScripts               --
--========================================================--

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

local Player = Players.LocalPlayer

--========================================================--
-- CONFIG
--========================================================--

local BASE_SPEED = 16
local MAX_MULTIPLIER = 400

local speedEnabled = false
local fpsEnabled = false
local collisionEnabled = false
local texturesDisabled = false

local speedMultiplier = 1

-- Cores
local PURPLE = Color3.fromRGB(170, 65, 255)
local PURPLE_DARK = Color3.fromRGB(85, 25, 130)

local BLACK = Color3.fromRGB(7, 7, 10)
local DARK = Color3.fromRGB(13, 13, 18)
local WHITE = Color3.fromRGB(240, 240, 245)
local GRAY = Color3.fromRGB(145, 145, 155)

--========================================================--
-- GUI
--========================================================--

local Gui = Instance.new("ScreenGui")
Gui.Name = "MT7"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.Parent = Player:WaitForChild("PlayerGui")

--========================================================--
-- BOTÃO FLUTUANTE
--========================================================--

local Float = Instance.new("TextButton")
Float.Name = "MT7_Button"
Float.Size = UDim2.fromOffset(68, 68)
Float.Position = UDim2.new(0, 18, 0.5, -34)
Float.BackgroundColor3 = BLACK
Float.Text = "MT7"
Float.TextColor3 = PURPLE
Float.TextSize = 20
Float.Font = Enum.Font.GothamBold
Float.AutoButtonColor = false
Float.Parent = Gui

local FloatCorner = Instance.new("UICorner")
FloatCorner.CornerRadius = UDim.new(0, 14)
FloatCorner.Parent = Float

local FloatStroke = Instance.new("UIStroke")
FloatStroke.Color = PURPLE
FloatStroke.Thickness = 2
FloatStroke.Parent = Float

--========================================================--
-- PAINEL PRINCIPAL
--========================================================--

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.fromScale(0.70, 0.70)
Main.Position = UDim2.fromScale(0.15, 0.15)
Main.BackgroundColor3 = BLACK
Main.Visible = false
Main.Parent = Gui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 18)
MainCorner.Parent = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = PURPLE
MainStroke.Thickness = 2
MainStroke.Parent = Main

local Scale = Instance.new("UIScale")
Scale.Scale = 0.75
Scale.Parent = Main

--========================================================--
-- TÍTULO
--========================================================--

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -30, 0, 45)
Title.Position = UDim2.fromOffset(15, 8)
Title.BackgroundTransparency = 1
Title.Text = "MT7"
Title.TextColor3 = PURPLE
Title.TextSize = 27
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Main

local SubTitle = Instance.new("TextLabel")
SubTitle.Size = UDim2.new(1, -30, 0, 20)
SubTitle.Position = UDim2.fromOffset(16, 42)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "CONTROL PANEL"
SubTitle.TextColor3 = GRAY
SubTitle.TextSize = 10
SubTitle.Font = Enum.Font.GothamMedium
SubTitle.TextXAlignment = Enum.TextXAlignment.Left
SubTitle.Parent = Main

--========================================================--
-- FECHAR
--========================================================--

local Close = Instance.new("TextButton")
Close.Size = UDim2.fromOffset(38, 38)
Close.Position = UDim2.new(1, -50, 0, 12)
Close.BackgroundColor3 = DARK
Close.Text = "×"
Close.TextColor3 = PURPLE
Close.TextSize = 25
Close.Font = Enum.Font.GothamBold
Close.AutoButtonColor = false
Close.Parent = Main

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 10)
CloseCorner.Parent = Close

local CloseStroke = Instance.new("UIStroke")
CloseStroke.Color = PURPLE
CloseStroke.Thickness = 1.5
CloseStroke.Parent = Close

--========================================================--
-- FUNÇÃO PARA CRIAR BOTÕES
--========================================================--

local function CreateToggle(text, y)
    local Button = Instance.new("TextButton")

    Button.Size = UDim2.new(1, -36, 0, 52)
    Button.Position = UDim2.new(0, 18, 0, y)
    Button.BackgroundColor3 = DARK
    Button.Text = text .. "   OFF"
    Button.TextColor3 = WHITE
    Button.TextSize = 13
    Button.Font = Enum.Font.GothamBold
    Button.AutoButtonColor = false
    Button.Parent = Main

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 12)
    Corner.Parent = Button

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = PURPLE_DARK
    Stroke.Thickness = 1.5
    Stroke.Parent = Button

    return Button
end

local FPSButton = CreateToggle("FPS BOOSTER", 78)
local SpeedButton = CreateToggle("VELOCIDADE", 136)
local CollisionButton = CreateToggle("ANTI-COLISÃO", 194)
local TextureButton = CreateToggle("TEXTURAS INÚTEIS", 252)

--========================================================--
-- SLIDER DE VELOCIDADE
--========================================================--

local SliderBackground = Instance.new("Frame")
SliderBackground.Size = UDim2.new(1, -55, 0, 6)
SliderBackground.Position = UDim2.new(0, 28, 0, 316)
SliderBackground.BackgroundColor3 = Color3.fromRGB(45, 40, 50)
SliderBackground.Parent = Main

local SliderCorner = Instance.new("UICorner")
SliderCorner.CornerRadius = UDim.new(1, 0)
SliderCorner.Parent = SliderBackground

local SliderFill = Instance.new("Frame")
SliderFill.Size = UDim2.new(0, 0, 1, 0)
SliderFill.BackgroundColor3 = PURPLE
SliderFill.Parent = SliderBackground

local FillCorner = Instance.new("UICorner")
FillCorner.CornerRadius = UDim.new(1, 0)
FillCorner.Parent = SliderFill

local Knob = Instance.new("TextButton")
Knob.Size = UDim2.fromOffset(18, 18)
Knob.Position = UDim2.new(0, -9, 0.5, -9)
Knob.BackgroundColor3 = PURPLE
Knob.Text = ""
Knob.AutoButtonColor = false
Knob.Parent = SliderBackground

local KnobCorner = Instance.new("UICorner")
KnobCorner.CornerRadius = UDim.new(1, 0)
KnobCorner.Parent = Knob

local SpeedText = Instance.new("TextLabel")
SpeedText.Size = UDim2.new(1, -30, 0, 25)
SpeedText.Position = UDim2.fromOffset(15, 326)
SpeedText.BackgroundTransparency = 1
SpeedText.Text = "MULTIPLICADOR: 1x / 400x"
SpeedText.TextColor3 = GRAY
SpeedText.TextSize = 11
SpeedText.Font = Enum.Font.GothamBold
SpeedText.Parent = Main

--========================================================--
-- SLIDER MOBILE
--========================================================--

local dragging = false

local function SetSliderFromX(x)
    local left = SliderBackground.AbsolutePosition.X
    local width = SliderBackground.AbsoluteSize.X

    local percent = math.clamp((x - left) / width, 0, 1)

    speedMultiplier = math.max(
        1,
        math.floor(1 + percent * (MAX_MULTIPLIER - 1))
    )

    SliderFill.Size = UDim2.new(percent, 0, 1, 0)
    Knob.Position = UDim2.new(percent, -9, 0.5, -9)

    SpeedText.Text =
        "MULTIPLICADOR: " ..
        speedMultiplier ..
        "x / " ..
        MAX_MULTIPLIER ..
        "x"
end

SliderBackground.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        dragging = true
        SetSliderFromX(input.Position.X)
    end
end)

Knob.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        dragging = true
    end
end)

RunService.RenderStepped:Connect(function()
    if dragging then
        local mouse = Player:GetMouse()
        SetSliderFromX(mouse.X)
    end
end)

game:GetService("UserInputService").InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        dragging = false
    end
end)

--========================================================--
-- PERSONAGEM
--========================================================--

local function GetCharacter()
    return Player.Character
end

local function GetHumanoid()
    local Character = GetCharacter()

    if Character then
        return Character:FindFirstChildOfClass("Humanoid")
    end
end

--========================================================--
-- VELOCIDADE
--========================================================--

local function UpdateSpeed()
    local Humanoid = GetHumanoid()

    if not Humanoid then
        return
    end

    if speedEnabled then
        -- BASE_SPEED × multiplicador
        Humanoid.WalkSpeed = BASE_SPEED * speedMultiplier
    else
        Humanoid.WalkSpeed = BASE_SPEED
    end
end

SpeedButton.Activated:Connect(function()

    speedEnabled = not speedEnabled

    if speedEnabled then
        SpeedButton.Text = "VELOCIDADE   ON"
        SpeedButton.TextColor3 = PURPLE
    else
        SpeedButton.Text = "VELOCIDADE   OFF"
        SpeedButton.TextColor3 = WHITE
    end

    UpdateSpeed()
end)

--========================================================--
-- ANTI-COLISÃO
--========================================================--

local function UpdateCollision()

    local Character = GetCharacter()

    if not Character then
        return
    end

    for _, Object in ipairs(Character:GetDescendants()) do

        if Object:IsA("BasePart") then

            if collisionEnabled then
                Object.CanCollide = false
            else
                Object.CanCollide = true
            end

        end
    end
end

CollisionButton.Activated:Connect(function()

    collisionEnabled = not collisionEnabled

    if collisionEnabled then
        CollisionButton.Text = "ANTI-COLISÃO   ON"
        CollisionButton.TextColor3 = PURPLE
    else
        CollisionButton.Text = "ANTI-COLISÃO   OFF"
        CollisionButton.TextColor3 = WHITE
    end

    UpdateCollision()
end)

--========================================================--
-- FPS BOOSTER
--========================================================--

local function FPSBoost()

    Lighting.GlobalShadows = false
    Lighting.FogEnd = 100000

    for _, Object in ipairs(workspace:GetDescendants()) do

        if Object:IsA("ParticleEmitter")
            or Object:IsA("Trail")
            or Object:IsA("Beam") then

            Object.Enabled = false

        elseif Object:IsA("BasePart") then

            Object.CastShadow = false

        end
    end
end

FPSButton.Activated:Connect(function()

    fpsEnabled = not fpsEnabled

    if fpsEnabled then

        FPSButton.Text = "FPS BOOSTER   ON"
        FPSButton.TextColor3 = PURPLE

        FPSBoost()

    else

        FPSButton.Text = "FPS BOOSTER   OFF"
        FPSButton.TextColor3 = WHITE

    end
end)

--========================================================--
-- DESATIVAR TEXTURAS
--========================================================--

local function DisableTextures()

    for _, Object in ipairs(workspace:GetDescendants()) do

        if Object:IsA("Texture")
            or Object:IsA("Decal") then

            Object.Transparency = 1

        elseif Object:IsA("MeshPart") then

            Object.TextureID = ""

        end
    end
end

TextureButton.Activated:Connect(function()

    texturesDisabled = not texturesDisabled

    if texturesDisabled then

        TextureButton.Text = "TEXTURAS INÚTEIS   ON"
        TextureButton.TextColor3 = PURPLE

        DisableTextures()

    else

        TextureButton.Text = "TEXTURAS INÚTEIS   OFF"
        TextureButton.TextColor3 = WHITE

    end
end)

--========================================================--
-- ANIMAÇÕES
--========================================================--

local function OpenPanel()

    Main.Visible = true
    Scale.Scale = 0.75

    TweenService:Create(
        Scale,
        TweenInfo.new(
            0.28,
            Enum.EasingStyle.Back,
            Enum.EasingDirection.Out
        ),
        {Scale = 1}
    ):Play()
end

local function ClosePanel()

    local Tween = TweenService:Create(
        Scale,
        TweenInfo.new(
            0.18,
            Enum.EasingStyle.Quad,
            Enum.EasingDirection.In
        ),
        {Scale = 0.75}
    )

    Tween:Play()

    Tween.Completed:Connect(function()
        Main.Visible = false
    end)
end

Float.Activated:Connect(function()

    if Main.Visible then
        ClosePanel()
    else
        OpenPanel()
    end

end)

Close.Activated:Connect(ClosePanel)

--========================================================--
-- RESPAWN
--========================================================--

Player.CharacterAdded:Connect(function()

    task.wait(0.5)

    UpdateSpeed()

    if collisionEnabled then
        UpdateCollision()
    end

end)

--========================================================--
-- FIM MT7
--========================================================--
