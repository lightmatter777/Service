-- Marcus Universal Hub - Stealth Enhanced with Distance ESP + God Mode & Invisibility
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local Mouse = LocalPlayer:GetMouse()

local isMobile = UIS.TouchEnabled and not UIS.KeyboardEnabled

local function randomDelay(base, variance)
    return base + (math.random() * variance * 2) - variance
end

print("🔐 Connecting to Marcus Secure Server...")
wait(1.5)
print("🔗 Handshaking with Verification Node...")
wait(1.5)
print("✅ Authorized! Welcome to Marcus Hub.")

local Window = Rayfield:CreateWindow({
    Name = "🛡 Marcus Universal Hub",
    LoadingTitle = "Marcus Hub",
    LoadingSubtitle = "Stealth Enhanced",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "MarcusHub",
        FileName = "UniversalConfig"
    },
    KeySystem = false,
})

local MainTab = Window:CreateTab("🌍 Universal Features")

-- WalkSpeed
local WalkSpeedValue = 16
MainTab:CreateSlider({
    Name = "WalkSpeed",
    Range = {16, 250},
    Increment = 1,
    Suffix = " Speed",
    CurrentValue = WalkSpeedValue,
    Callback = function(value)
        WalkSpeedValue = value
        pcall(function()
            local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then humanoid.WalkSpeed = WalkSpeedValue end
        end)
    end,
})

-- JumpPower
local JumpPowerValue = 50
MainTab:CreateSlider({
    Name = "JumpPower",
    Range = {50, 250},
    Increment = 1,
    Suffix = " Power",
    CurrentValue = JumpPowerValue,
    Callback = function(value)
        JumpPowerValue = value
        pcall(function()
            local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then humanoid.JumpPower = JumpPowerValue end
        end)
    end,
})

-- Infinite Jump
local infiniteJumpEnabled = false
MainTab:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Callback = function(state)
        infiniteJumpEnabled = state
    end,
})
UIS.JumpRequest:Connect(function()
    if infiniteJumpEnabled then
        pcall(function()
            local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
        end)
    end
end)

-- Fly
local flying = false
local flySpeed = 100
local flyBG, flyBV

MainTab:CreateToggle({
    Name = "Fly (Camera Based)",
    CurrentValue = false,
    Callback = function(state)
        flying = state
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if flying and root then
            flyBG = Instance.new("BodyGyro", root)
            flyBV = Instance.new("BodyVelocity", root)
            flyBG.P = 9e4
            flyBG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
            flyBV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            flyBV.Velocity = Vector3.new(0,0,0)

            RunService:BindToRenderStep("FlyControl", Enum.RenderPriority.Character.Value + 1, function()
                if flying and root then
                    flyBG.CFrame = Camera.CFrame
                    flyBV.Velocity = Camera.CFrame.LookVector * flySpeed
                end
            end)
        else
            RunService:UnbindFromRenderStep("FlyControl")
            if flyBG then flyBG:Destroy() end
            if flyBV then flyBV:Destroy() end
        end
    end,
})

-- Noclip
local noclipEnabled = false
MainTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Callback = function(state)
        noclipEnabled = state
    end,
})
RunService.Stepped:Connect(function()
    if noclipEnabled and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end)

-- ESP
local ESPEnabled = false
local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "MarcusESP"
ESPFolder.Parent = game.CoreGui

local ESPElements = {}

local function removeESP(plr)
    if ESPElements[plr] then
        local e = ESPElements[plr]
        if e.Box then e.Box:Destroy() end
        if e.Billboard then e.Billboard:Destroy() end
        ESPElements[plr] = nil
    end
end

local function createESP(plr)
    if ESPElements[plr] then return end
    if not plr.Character then return end
    local rootPart = plr.Character:FindFirstChild("HumanoidRootPart")
    local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
    if not rootPart or not humanoid then return end

    local box = Instance.new("BoxHandleAdornment")
    box.Adornee = rootPart
    box.AlwaysOnTop = true
    box.ZIndex = 10
    box.Transparency = 0.5
    box.Size = Vector3.new(4, 6, 1)
    box.Color3 = Color3.fromRGB(255, 0, 0)
    box.Parent = ESPFolder

    local billboard = Instance.new("BillboardGui")
    billboard.Adornee = rootPart
    billboard.Size = UDim2.new(5, 0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.Parent = ESPFolder

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextStrokeTransparency = 0
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextScaled = true
    nameLabel.Parent = billboard

    local healthBarBg = Instance.new("Frame")
    healthBarBg.Size = UDim2.new(1, 0, 0.2, 0)
    healthBarBg.Position = UDim2.new(0, 0, 0.6, 0)
    healthBarBg.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    healthBarBg.BorderSizePixel = 0
    healthBarBg.Parent = billboard

    local healthBar = Instance.new("Frame")
    healthBar.Size = UDim2.new(humanoid.Health / humanoid.MaxHealth, 0, 1, 0)
    healthBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    healthBar.BorderSizePixel = 0
    healthBar.Parent = healthBarBg

    ESPElements[plr] = {
        Box = box,
        Billboard = billboard,
        NameLabel = nameLabel,
        HealthBar = healthBar,
        Humanoid = humanoid,
        RootPart = rootPart,
    }
end

RunService.RenderStepped:Connect(function()
    if not ESPEnabled then return end
    for plr, elements in pairs(ESPElements) do
        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
            local rootPart = plr.Character:FindFirstChild("HumanoidRootPart")
            if humanoid and elements.HealthBar then
                elements.HealthBar.Size = UDim2.new(math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1), 0, 1, 0)
            end
            local distance = math.floor((rootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude)
            elements.NameLabel.Text = plr.Name .. " [" .. distance .. "m]"
        else
            removeESP(plr)
        end
    end
end)

MainTab:CreateToggle({
    Name = "ESP (Improved with Distance)",
    CurrentValue = false,
    Callback = function(state)
        ESPEnabled = state
        if ESPEnabled then
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer then
                    createESP(plr)
                end
            end
            Players.PlayerAdded:Connect(function(plr)
                if ESPEnabled then
                    createESP(plr)
                end
            end)
            Players.PlayerRemoving:Connect(function(plr)
                removeESP(plr)
            end)
        else
            for plr, _ in pairs(ESPElements) do
                removeESP(plr)
            end
        end
    end,
})

-- Silent Aim (stealth metamethod hook)
local silentAimEnabled = false
local aimFOV = 100
local aimPart = "Head"

local mt = getrawmetatable(game)
local oldIndex = mt.__index
setreadonly(mt, false)

local hookActive = false

local function getClosestTarget()
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    local closest, closestDist = nil, math.huge
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild(aimPart) then
            local headPos = plr.Character[aimPart].Position
            local screenPos, onScreen = Camera:WorldToViewportPoint(headPos)
            if onScreen then
                local dist = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
                if dist < aimFOV and dist < closestDist then
                    closest = plr
                    closestDist = dist
                end
            end
        end
    end
    return closest
end

local function enableSilentAim(state)
    if state and not hookActive then
        hookActive = true
        mt.__index = newcclosure(function(t,k)
            if t == Mouse and (k == "Target" or k == "TargetFilter") and silentAimEnabled then
                local target = getClosestTarget()
                if target and target.Character and target.Character:FindFirstChild(aimPart) then
                    return target.Character[aimPart]
                end
            end
            return oldIndex(t,k)
        end)
    elseif not state and hookActive then
        hookActive = false
        mt.__index = oldIndex
    end
end

MainTab:CreateToggle({
    Name = "Silent Aim",
    CurrentValue = false,
    Callback = function(state)
        silentAimEnabled = state
        enableSilentAim(state)
    end,
})

-- Triggerbot with randomized delay
local triggerbotEnabled = false
local lastTrigger = 0
local baseTriggerDelay = 0.1
local triggerVariance = 0.05

RunService.RenderStepped:Connect(function()
    if triggerbotEnabled then
        local now = tick()
        if now - lastTrigger >= randomDelay(baseTriggerDelay, triggerVariance) then
            local target = Mouse.Target
            if target and target.Parent and Players:FindFirstChild(target.Parent.Name) and target.Parent ~= LocalPlayer.Character then
                local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
                if tool and tool:FindFirstChild("Fire") then
                    pcall(function() tool.Fire:Invoke() end)
                elseif tool and tool:FindFirstChild("Activate") then
                    pcall(function() tool:Activate() end)
                end
                lastTrigger = now
            end
        end
    end
end)

MainTab:CreateToggle({
    Name = "Triggerbot",
    CurrentValue = false,
    Callback = function(state)
        triggerbotEnabled = state
    end,
})

-- Click TP (supports mobile & pc)
local clickTPEnabled = false
MainTab:CreateToggle({
    Name = "Click TP (Mouse & Touch)",
    CurrentValue = false,
    Callback = function(state)
        clickTPEnabled = state
    end,
})

if not isMobile then
    Mouse.Button1Down:Connect(function()
        if clickTPEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local targetPos = Mouse.Hit and Mouse.Hit.Position
            if targetPos then
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(targetPos + Vector3.new(0, 3, 0))
            end
        end
    end)
else
    UIS.TouchTap:Connect(function(touches, gameProcessed)
        if clickTPEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local touchPos = touches[1]
            if touchPos then
                local ray = Camera:ScreenPointToRay(touchPos.X, touchPos.Y)
                local raycastParams = RaycastParams.new()
                raycastParams.FilterDescendantsInstances = {LocalPlayer.Character}
                raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
                local raycastResult = workspace:Raycast(ray.Origin, ray.Direction * 1000, raycastParams)
                if raycastResult then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(raycastResult.Position + Vector3.new(0, 3, 0))
                end
            end
        end
    end)
end

-- Anti AFK
local antiAFKEnabled = false
MainTab:CreateToggle({
    Name = "Anti AFK",
    CurrentValue = false,
    Callback = function(state)
        antiAFKEnabled = state
        if state then
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end
    end,
})

-- Chat Spammer with randomized interval
local spamEnabled = false
local spamMessage = "MarcusHub Activated!"
local spamInterval = 5

MainTab:CreateToggle({
    Name = "Chat Spammer",
    CurrentValue = false,
    Callback = function(state)
        spamEnabled = state
    end,
})

MainTab:CreateTextbox({
    Name = "Spam Message",
    PlaceholderText = "Type spam message here",
    Callback = function(text)
        spamMessage = text
    end,
})

MainTab:CreateSlider({
    Name = "Spam Interval (Seconds)",
    Range = {1, 30},
    Increment = 1,
    CurrentValue = spamInterval,
    Callback = function(value)
        spamInterval = value
    end,
})

spawn(function()
    while true do
        wait(randomDelay(spamInterval, 1))
        if spamEnabled then
            pcall(function()
                game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("SayMessageRequest"):FireServer(spamMessage, "All")
            end)
        end
    end
end)

-- God Mode (Invincible)
local godModeEnabled = false
MainTab:CreateToggle({
    Name = "God Mode (Invincible)",
    CurrentValue = false,
    Callback = function(state)
        godModeEnabled = state
    end,
})

-- Invisibility
local invisibilityEnabled = false
MainTab:CreateToggle({
    Name = "Invisibility",
    CurrentValue = false,
    Callback = function(state)
        invisibilityEnabled = state
        local char = LocalPlayer.Character
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.LocalTransparencyModifier = state and 1 or 0
                    part.CanCollide = not state
                elseif part:IsA("Decal") then
                    part.Transparency = state and 1 or 0
                elseif part:IsA("ParticleEmitter") or part:IsA("Trail") then
                    part.Enabled = not state
                end
            end
        end
    end,
})

-- Keep God Mode health max every frame
RunService.Heartbeat:Connect(function()
    if godModeEnabled and LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.Health = humanoid.MaxHealth
            humanoid.MaxHealth = 1e9 -- Very high max health to prevent crashes
        end
    end
end)

-- Destroy UI button & cleanup
MainTab:CreateButton({
    Name = "Destroy UI & Cleanup",
    Callback = function()
        -- Remove ESP visuals
        for plr, _ in pairs(ESPElements) do
            removeESP(plr)
        end
        ESPEnabled = false

        -- Disable silent aim hook
        silentAimEnabled = false
        enableSilentAim(false)

        -- Disable triggerbot
        triggerbotEnabled = false

        -- Disable other toggles
        infiniteJumpEnabled = false
        noclipEnabled = false
        flying = false
        RunService:UnbindFromRenderStep("FlyControl")
        godModeEnabled = false
        invisibilityEnabled = false
        local char = LocalPlayer.Character
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.LocalTransparencyModifier = 0
                    part.CanCollide = true
                elseif part:IsA("Decal") then
                    part.Transparency = 0
                elseif part:IsA("ParticleEmitter") or part:IsA("Trail") then
                    part.Enabled = true
                end
            end
        end

        -- Destroy Rayfield UI
        Rayfield:Destroy()
    end,
})

print("🛡 Marcus Universal Hub loaded - stealth optimized & ready.")
