
local Players, RS, UIS, Camera = game:GetService("Players"), game:GetService("RunService"), game:GetService("UserInputService"), workspace.CurrentCamera
local LocalPlayer, Mouse = Players.LocalPlayer, Players.LocalPlayer:GetMouse()

local Script = getgenv().Script or {}
local Silent = Script.SilentAim or {}
local Camlock = Script.Camlock or {}
local Triggerbot = Script.Triggerbot or {}

local Target = nil
local TriggerEnabled = false

--// FOV Circle
local FOV = Drawing.new("Circle")
FOV.Radius = Silent.FOV or 120
FOV.Color = Color3.fromRGB(255, 255, 255)
FOV.Thickness = 1
FOV.Transparency = 1
FOV.Visible = true
FOV.Filled = false

RS.RenderStepped:Connect(function()
    local pos = UIS:GetMouseLocation()
    FOV.Position = Vector2.new(pos.X, pos.Y + 36)
end)

--// Utilities
--// Resolver velocity calculation
local function CalculateResolverVelocity(part)
    if not part then return Vector3.zero end
    local lastPos = part.Position
    task.wait() -- wait one frame
    local curPos = part.Position
    local delta = RS.RenderStepped:Wait()
    delta = math.clamp(delta, 0.001, 0.033)

    return (curPos - lastPos) / delta
end


local function IsAlive(plr)
    local char = plr.Character
    if not char then return false end
    local hum = char:FindFirstChild("Humanoid")
    local ko = char:FindFirstChild("BodyEffects") and char.BodyEffects:FindFirstChild("K.O")
    return hum and hum.Health > 0 and (not Silent.KOCheck or not ko or not ko.Value)
end

local function IsVisible(part)
    if not Silent.WallCheck then return true end
    local origin = Camera.CFrame.Position
    local direction = (part.Position - origin).Unit * 1000
    local ray = RaycastParams.new()
    ray.FilterType = Enum.RaycastFilterType.Blacklist
    ray.FilterDescendantsInstances = {LocalPlayer.Character}
    local result = workspace:Raycast(origin, direction, ray)
    return not result or result.Instance:IsDescendantOf(part.Parent)
end

local function GetClosestPlayer()
    local closest, distance = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and IsAlive(plr) then
            local part = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
            if part and IsVisible(part) then
                local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local mousePos = UIS:GetMouseLocation()
                    local mag = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
                    if mag < distance and mag <= (Silent.FOV or 120) then
                        closest, distance = plr, mag
                    end
                end
            end
        end
    end
    return closest
end

local function GetPart(plr)
    if not plr.Character then return nil end
    if Silent.ClosestPart then
        local closest, mag = nil, math.huge
        for _, part in ipairs(plr.Character:GetChildren()) do
            if part:IsA("BasePart") then
                local screenPos = Camera:WorldToViewportPoint(part.Position)
                local dist = (Vector2.new(screenPos.X, screenPos.Y) - UIS:GetMouseLocation()).Magnitude
                if dist < mag then
                    closest, mag = part, dist
                end
            end
        end
        return closest
    end
    return plr.Character:FindFirstChild(Silent.HitPart or "UpperTorso")
end

--// Silent Aim Hook
local mt = getrawmetatable(game)
setreadonly(mt, false)
local oldIndex = mt.__index
mt.__index = function(self, key)
    if self == Mouse and (key == "Hit" or key == "Target") and Silent.Enabled then
        local target = (Silent.Type == "FOV") and GetClosestPlayer() or Target
        if target and IsAlive(target) then
            local part = GetPart(target)
            if part then
               local prediction
if Script.Resolver and Script.Resolver.Enabled then
    local velocity = CalculateResolverVelocity(part)
    prediction = velocity * (Silent.Prediction or 0)
else
    prediction = part.Velocity * (Silent.Prediction or 0)
end

                return (key == "Hit" and (part.CFrame.Position + prediction)) or part
            end
        end
    end
    return oldIndex(self, key)
end

--// AimLock Keybind
UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if Camlock.Enabled and input.KeyCode == Camlock.Keybind then
        Target = (Target and nil) or GetClosestPlayer()
        if Target and Silent.HighlightTarget then
            local hl = Instance.new("Highlight", Target.Character)
            hl.FillColor = Color3.fromRGB(128, 128, 128)
            hl.OutlineTransparency = 1
            task.delay(1, function() hl:Destroy() end)
        end
    elseif Triggerbot.Enabled and input.KeyCode == Triggerbot.Keybind then
        TriggerEnabled = not TriggerEnabled
        game.StarterGui:SetCore("SendNotification", {
            Title = "Triggerbot",
            Text = TriggerEnabled and "Enabled" or "Disabled",
            Duration = 2
        })
    end
end)

--// Camlock Logic
RS.RenderStepped:Connect(function()
    if Camlock.Enabled and Target and Target.Character then
        local part = GetPart(Target)
        if part then
            local prediction
if Script.Resolver and Script.Resolver.Enabled then
    local velocity = CalculateResolverVelocity(part)
    prediction = velocity * (Camlock.Prediction or 0)
else
    prediction = part.Velocity * (Camlock.Prediction or 0)
end

            local aimPos = part.Position + prediction
            local camCF = Camera.CFrame
            Camera.CFrame = CFrame.new(camCF.Position, aimPos):Lerp(camCF, Camlock.Smoothness or 0.1)
        end
    end
end)

--// Triggerbot
RS.Heartbeat:Connect(function()
    if not TriggerEnabled then return end
    local target = Mouse.Target
    if not target then return end

    local plr = nil
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character and target:IsDescendantOf(p.Character) then
            plr = p
            break
        end
    end
    if plr and IsAlive(plr) then
        local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildWhichIsA("Tool")
        if tool and not table.find(Triggerbot.Blacklisted or {}, tool.Name) then
            task.wait(Triggerbot.Delay or 0.05)
            tool:Activate()
        end
    end
end)
