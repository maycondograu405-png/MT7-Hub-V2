--[[
    MT7 UI — Prototype v1
    Interface de teste / demonstração

    Inclui:
    • Botão flutuante MT7 arrastável
    • Menu abrir/fechar
    • Abas
    • Speed 1–500
    • Slider + entrada manual
    • 4 temas
    • Egg ESP (visual/simulado)
    • Auto Steal (visual/simulado)
    • Fly / Tween / Go To Pet (controles simulados)
    • Performance / FPS (indicador)
    • Asset ID para imagem
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

--------------------------------------------------
-- CONFIG
--------------------------------------------------

local Config = {
    Speed = 100,
    Theme = "Ocean",
    ImageId = "",
    AutoSteal = false,
    EggESP = false,
    ExpensiveOnly = false,
    Fly = false,
    Tween = false,
    PetMove = false,
    Performance = false
}

local Themes = {
    Ocean = Color3.fromRGB(40, 140, 255),
    Purple = Color3.fromRGB(150, 80, 255),
    Crimson = Color3.fromRGB(235, 65, 75),
    Emerald = Color3.fromRGB(45, 190, 120)
}

--------------------------------------------------
-- GUI
--------------------------------------------------

local Gui = Instance.new("ScreenGui")
Gui.Name = "MT7_UI"
Gui.ResetOnSpawn = false
Gui.Parent = PlayerGui

--------------------------------------------------
-- FLOATING BUTTON
--------------------------------------------------

local Floating = Instance.new("TextButton")
Floating.Name = "MT7Button"
Floating.Size = UDim2.fromOffset(64, 64)
Floating.Position = UDim2.new(0, 20, 0.5, -32)
Floating.BackgroundColor3 = Themes[Config.Theme]
Floating.Text = "MT7"
Floating.TextColor3 = Color3.new(1, 1, 1)
Floating.TextScaled = true
Floating.Font = Enum.Font.GothamBold
Floating.Parent = Gui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(1, 0)
Corner.Parent = Floating

--------------------------------------------------
-- MAIN WINDOW
--------------------------------------------------

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.fromOffset(360, 470)
Main.Position = UDim2.new(0.5, -180, 0.5, -235)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Main.Visible = false
Main.Parent = Gui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = Main

--------------------------------------------------
-- TITLE
--------------------------------------------------

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -20, 0, 45)
Title.Position = UDim2.fromOffset(10, 5)
Title.BackgroundTransparency = 1
Title.Text = "MT7  •  TEST PANEL"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextSize = 20
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Main

--------------------------------------------------
-- CONTENT
--------------------------------------------------

local Content = Instance.new("ScrollingFrame")
Content.Size = UDim2.new(1, -20, 1, -60)
Content.Position = UDim2.fromOffset(10, 55)
Content.BackgroundTransparency = 1
Content.ScrollBarThickness = 4
Content.CanvasSize = UDim2.new()
Content.Parent = Main

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 8)
Layout.Parent = Content

--------------------------------------------------
-- HELPERS
--------------------------------------------------

local function AddButton(text, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 0, 42)
    Button.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
    Button.Text = text
    Button.TextColor3 = Color3.new(1, 1, 1)
    Button.TextSize = 15
    Button.Font = Enum.Font.GothamMedium
    Button.Parent = Content

    local C = Instance.new("UICorner")
    C.CornerRadius = UDim.new(0, 8)
    C.Parent = Button

    Button.MouseButton1Click:Connect(callback)

    return Button
end

local function AddSection(text)
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 0, 30)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Themes[Config.Theme]
    Label.TextSize = 16
    Label.Font = Enum.Font.GothamBold
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Content
end

--------------------------------------------------
-- AUTO STEAL
--------------------------------------------------

AddSection("🥚 AUTO STEAL")

local AutoButton

AutoButton = AddButton("Auto Steal: OFF", function()
    Config.AutoSteal = not Config.AutoSteal

    AutoButton.Text =
        "Auto Steal: " ..
        (Config.AutoSteal and "ON" or "OFF")
end)

--------------------------------------------------
-- EGG ESP
--------------------------------------------------

AddSection("👁️ EGG ESP")

local ESPButton

ESPButton = AddButton("Egg ESP: OFF", function()
    Config.EggESP = not Config.EggESP

    ESPButton.Text =
        "Egg ESP: " ..
        (Config.EggESP and "ON" or "OFF")
end)

local ExpensiveButton

ExpensiveButton = AddButton("Somente caros: OFF", function()
    Config.ExpensiveOnly = not Config.ExpensiveOnly

    ExpensiveButton.Text =
        "Somente caros: " ..
        (Config.ExpensiveOnly and "ON" or "OFF")
end)

--------------------------------------------------
-- SPEED
--------------------------------------------------

AddSection("⚡ SPEED")

local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size = UDim2.new(1, 0, 0, 35)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "Velocidade: 100"
SpeedLabel.TextColor3 = Color3.new(1, 1, 1)
SpeedLabel.TextSize = 15
SpeedLabel.Font = Enum.Font.GothamMedium
SpeedLabel.Parent = Content

local SpeedBox = Instance.new("TextBox")
SpeedBox.Size = UDim2.new(1, 0, 0, 42)
SpeedBox.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
SpeedBox.Text = "100"
SpeedBox.PlaceholderText = "Digite 1–500"
SpeedBox.TextColor3 = Color3.new(1, 1, 1)
SpeedBox.TextSize = 15
SpeedBox.Font = Enum.Font.Gotham
SpeedBox.ClearTextOnFocus = false
SpeedBox.Parent = Content

local BoxCorner = Instance.new("UICorner")
BoxCorner.CornerRadius = UDim.new(0, 8)
BoxCorner.Parent = SpeedBox

SpeedBox.FocusLost:Connect(function()
    local Value = tonumber(SpeedBox.Text)

    if not Value then
        Value = Config.Speed
    end

    Value = math.clamp(math.floor(Value), 1, 500)

    Config.Speed = Value
    SpeedBox.Text = tostring(Value)
    SpeedLabel.Text = "Velocidade: " .. Value
end)

--------------------------------------------------
-- MOVEMENT CONTROLS
--------------------------------------------------

AddSection("🐾 PET / MOVIMENTO")

local FlyButton
FlyButton = AddButton("Fly: OFF", function()
    Config.Fly = not Config.Fly
    FlyButton.Text = "Fly: " .. (Config.Fly and "ON" or "OFF")
end)

local TweenButton
TweenButton = AddButton("Tween: OFF", function()
    Config.Tween = not Config.Tween
    TweenButton.Text = "Tween: " .. (Config.Tween and "ON" or "OFF")
end)

local PetButton
PetButton = AddButton("Go To Pet: OFF", function()
    Config.PetMove = not Config.PetMove
    PetButton.Text =
        "Go To Pet: " ..
        (Config.PetMove and "ON" or "OFF")
end)

--------------------------------------------------
-- PERFORMANCE
--------------------------------------------------

AddSection("🚀 PERFORMANCE")

local PerformanceButton

PerformanceButton = AddButton("Performance Mode: OFF", function()
    Config.Performance = not Config.Performance

    PerformanceButton.Text =
        "Performance Mode: " ..
        (Config.Performance and "ON" or "OFF")
end)

--------------------------------------------------
-- THEMES
--------------------------------------------------

AddSection("🎨 TEMAS")

local function ApplyTheme(Name)
    Config.Theme = Name

    local Color = Themes[Name]

    Floating.BackgroundColor3 = Color
    Title.TextColor3 = Color

    for _, Object in ipairs(Content:GetChildren()) do
        if Object:IsA("TextLabel") and Object.Text ~= "" then
            if Object.Text:find("🥚")
                or Object.Text:find("👁️")
                or Object.Text:find("⚡")
                or Object.Text:find("🐾")
                or Object.Text:find("🚀")
                or Object.Text:find("🎨") then

                Object.TextColor3 = Color
            end
        end
    end
end

AddButton("🔵 Ocean", function()
    ApplyTheme("Ocean")
end)

AddButton("🟣 Purple", function()
    ApplyTheme("Purple")
end)

AddButton("🔴 Crimson", function()
    ApplyTheme("Crimson")
end)

AddButton("🟢 Emerald", function()
    ApplyTheme("Emerald")
end)

--------------------------------------------------
-- IMAGE ID
--------------------------------------------------

AddSection("🖼️ IMAGEM DO PAINEL")

local ImageBox = Instance.new("TextBox")
ImageBox.Size = UDim2.new(1, 0, 0, 42)
ImageBox.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
ImageBox.Text = ""
ImageBox.PlaceholderText = "Asset ID da imagem"
ImageBox.TextColor3 = Color3.new(1, 1, 1)
ImageBox.TextSize = 14
ImageBox.Font = Enum.Font.Gotham
ImageBox.ClearTextOnFocus = false
ImageBox.Parent = Content

local ImageCorner = Instance.new("UICorner")
ImageCorner.CornerRadius = UDim.new(0, 8)
ImageCorner.Parent = ImageBox

AddButton("Aplicar imagem", function()
    local ID = tonumber(ImageBox.Text)

    if ID then
        Config.ImageId = tostring(ID)
        print("MT7 Image ID:", Config.ImageId)
    end
end)

--------------------------------------------------
-- FLOATING BUTTON
--------------------------------------------------

Floating.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

--------------------------------------------------
-- SIMPLE DRAG SYSTEM
--------------------------------------------------

local UIS = game:GetService("UserInputService")

local dragging = false
local dragStart
local startPos

Floating.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseButton1 then

        dragging = true
        dragStart = input.Position
        startPos = Floating.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging then
        local Delta = input.Position - dragStart

        Floating.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + Delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + Delta.Y
        )
    end
end)

--------------------------------------------------
-- FPS DISPLAY
--------------------------------------------------

local FPS = 0
local Frames = 0
local Last = os.clock()

local FPSLabel = Instance.new("TextLabel")
FPSLabel.Size = UDim2.new(1, 0, 0, 30)
FPSLabel.BackgroundTransparency = 1
FPSLabel.Text = "FPS: --"
FPSLabel.TextColor3 = Color3.new(1, 1, 1)
FPSLabel.TextSize = 14
FPSLabel.Font = Enum.Font.Gotham
FPSLabel.Parent = Content

RunService.RenderStepped:Connect(function()
    Frames += 1

    local Now = os.clock()

    if Now - Last >= 1 then
        FPS = Frames
        Frames = 0
        Last = Now

        FPSLabel.Text = "FPS: " .. FPS
    end
end)

--------------------------------------------------
-- INITIALIZE
--------------------------------------------------

ApplyTheme("Ocean")

print("MT7 UI carregada com sucesso.")
