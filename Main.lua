-- OPEN SOURCE BY @emilispy on discord

print("Auto orca made by @emilispy, Enjoy!")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Keybind = Enum.KeyCode.P
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")
local enabled = false
local orcasPool
local bodyVelocity
local AutoOrcaGui = Instance.new("ScreenGui")
local TextLabel = Instance.new("TextLabel")

AutoOrcaGui.Name = "AutoOrcaGui"
AutoOrcaGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
AutoOrcaGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

TextLabel.Parent = AutoOrcaGui
TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.BackgroundTransparency = 1.000
TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel.BorderSizePixel = 0
TextLabel.Position = UDim2.new(0.69942075, 0, 0.948629558, 0)
TextLabel.Size = UDim2.new(0, 178, 0, 34)
TextLabel.Font = Enum.Font.SourceSansBold
TextLabel.Text = "[🐟] Press 'P' start/stop!"
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.TextScaled = true
TextLabel.TextSize = 14.000
TextLabel.TextWrapped = true

local function enableFloating()
    if not bodyVelocity then
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Velocity = Vector3.new(0, 0.1, 0) -- Slight upward force to keep floating
        bodyVelocity.MaxForce = Vector3.new(0, math.huge, 0) -- Apply force only in the Y direction
        bodyVelocity.Parent = humanoidRootPart
    end
end

local function disableFloating()
    if bodyVelocity then
        bodyVelocity:Destroy()
        bodyVelocity = nil
    end
end

local function followOrcasPool()
    if not orcasPool or not orcasPool:IsDescendantOf(workspace) then
        humanoid.PlatformStand = true -- Prevents falling
        humanoidRootPart.Position = Vector3.new(0, 900, 0) -- Move player to the sky
        enableFloating()
        TextLabel.Text = "[⌛] Waiting.."
        return
    end

    humanoid.PlatformStand = true
    humanoidRootPart.CFrame = orcasPool.CFrame + Vector3.new(0, 50, 0) -- Further increased height above the object
    enableFloating()
    TextLabel.Text = "[✅] Active!"

    local connection
    connection = RunService.Heartbeat:Connect(function()
        if not orcasPool or not orcasPool:IsDescendantOf(workspace) then
            connection:Disconnect()
            followOrcasPool()
            return
        end
        humanoidRootPart.CFrame = orcasPool.CFrame + Vector3.new(0, 80, 0) -- Keep floating higher above
    end)
end

local function toggleEnabled()
    enabled = not enabled
    print("Script enabled:", enabled)
    TextLabel.Text = enabled and "[✅] Active!" or "[⌛] Waiting.."

    if enabled then
        while enabled do
            orcasPool = workspace:FindFirstChild("zones"):FindFirstChild("fishing"):FindFirstChild("Orcas Pool")
            followOrcasPool()
            wait(1)
        end
    else
        humanoid.PlatformStand = false
        disableFloating()
        TextLabel.Text = "[⌛] Waiting.."
    end
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Keybind then
        toggleEnabled()
    end
end)
