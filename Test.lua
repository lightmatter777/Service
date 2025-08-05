--// Marcus Hub - Free Version
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
    Name = "Marcus Hub | Free Version",
    LoadingTitle = "Initializing Free Tools...",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "MarcusFree",
        FileName = "Config"
    },
    Discord = {
        Enabled = true,
        Invite = "yourdiscord", -- optional
        RememberJoins = true
    },
    KeySystem = false,
})

--// Sections
local CombatTab = Window:CreateTab("⚔️ Combat")
local MovementTab = Window:CreateTab("🏃 Movement")
local MiscTab = Window:CreateTab("🧰 Misc")

--// Aimbot (basic)
local AimbotEnabled = false
local AimbotKey = Enum.KeyCode.Q -- changeable later
local AimPart = "Head"
local AimbotFOV = 100

CombatTab:CreateToggle({
    Name = "Basic Aimbot",
    CurrentValue = false,
    Callback = function(value)
        AimbotEnabled = value
    end,
})

--// Aimbot function
local function getClosestPlayer()
    local closest, distance = nil, math.huge
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild(AimPart) then
            local part = player.Character[AimPart]
            local screenPos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(part.Position)
            if onScreen then
                local dist = (Vector2.new(screenPos.X, screenPos.Y) - UIS:GetMouseLocation()).Magnitude
                if dist < distance and dist < AimbotFOV then
                    distance = dist
                    closest = part
                end
            end
        end
    end
    return closest
end

RunService.RenderStepped:Connect(function()
    if AimbotEnabled then
        if UIS:IsKeyDown(AimbotKey) or UIS.TouchEnabled then
            local target = getClosestPlayer()
            if target then
                workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, target.Position)
            end
        end
    end
end)

--// Speed / Jump (mobile safe)
local WalkSpeed = 16
local JumpPower = 50
local SpeedToggle = false

MovementTab:CreateSlider({
    Name = "WalkSpeed",
    Range = {16, 100},
    Increment = 2,
    CurrentValue = 16,
    Callback = function(val)
        WalkSpeed = val
    end,
})

MovementTab:CreateSlider({
    Name = "JumpPower",
    Range = {50, 150},
    Increment = 5,
    CurrentValue = 50,
    Callback = function(val)
        JumpPower = val
    end,
})

MovementTab:CreateToggle({
    Name = "Enable Speed/Jump",
    CurrentValue = false,
    Callback = function(val)
        SpeedToggle = val
    end,
})

RunService.RenderStepped:Connect(function()
    if SpeedToggle and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
        if hum then
            hum.WalkSpeed = WalkSpeed
            hum.JumpPower = JumpPower
        end
    end
end)

--// Infinite Jump
MovementTab:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Callback = function(state)
        _G.InfiniteJump = state
    end
})

UIS.JumpRequest:Connect(function()
    if _G.InfiniteJump then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

--// Click TP
MiscTab:CreateToggle({
    Name = "Click TP (Hold T + Click)",
    CurrentValue = false,
    Callback = function(state)
        _G.ClickTP = state
    end,
})

UIS.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 and _G.ClickTP and UIS:IsKeyDown(Enum.KeyCode.T) then
        local mouse = LocalPlayer:GetMouse()
        if mouse then
            LocalPlayer.Character:MoveTo(mouse.Hit.p + Vector3.new(0, 3, 0))
        end
    end
end)

--// Info
MiscTab:CreateLabel("✅ Mobile + PC Support")
MiscTab:CreateParagraph({Title = "Silent Aim", Content = "Premium only. Upgrade to unlock."})
