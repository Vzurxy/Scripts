local Player = game:GetService("Players").LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = Player:GetMouse()
local Character = Player.Character

local Model = Instance.new("Model")
Model.Parent = workspace

local Torso =  Instance.new("Part")
Torso.Name = "Torso"
Torso.CanCollide = false
Torso.Anchored = true
Torso.Parent = Model

local Head = Instance.new("Part")
Head.Name = "Head"
Head.Anchored = true
Head.CanCollide = false
Head.Parent = Model

local Humanoid = Instance.new("Humanoid")
Humanoid.Parent = Model

Torso.Position = Vector3.new(0,9999,0)
Head.Position = Vector3.new(0,9991,0)

Player.Character = Model
wait(5)
Player.Character = Character
wait(6)

game:GetService('RunService').RenderSteppe:Connect(function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CanCollide = true
end)

Character.HumanoidRootPart:Destroy()

local Humanoid = Instance.new("Humanoid")
Humanoid.Parent = Player.Character
Player.Character.Humanoid.Parent = game:GetService("ReplicatedStorage")

local Root = Player.Character["Right Arm"]
Root.Name = "HumanoidRootPart"

Humanoid.HipHeight = 5

Camera.CameraSubject = Character.HumanoidRootPart

for i,v in pairs(Player.Character:GetChildren()) do
    if v.Name ~= Root.Name and v.Name ~="Humanoid" and v.Name ~= "Left Arm" and v.Name ~= "Left Leg" and v.Name ~= "Right Leg" then
        v:Destroy()
    elseif v.Name == "Left Arm" or v.Name == "Left Leg" or v.Name == "Right Leg" then
        local bp = Instance.new("BodyPosition")
        bp.MaxForce = Vector3.new(99999, 99999, 99999)
        bp.Parent = v

        local bg = Instance.new("BodyGyro")
        bg.MaxTorque = Vector3.new(9999999, 9999999, 999999)
        bg.Parent = v

        spawn(function()
            bp.D = 300
            while true do
                bp.Position = Root.Position + Vector3.new(0, 5.1, 0)
                wait()
            end
        end)
    elseif v.Name == Root.Name then
        local bg = Instance.new("BodyGyro")
        bg.MaxTorque = Vector3.new(9999999, 9999999, 999999)
        bg.CFrame = CFrame.Angles(0, 0, math.rad(90))
        bg.Parent = v
    end
end

local Flying = true
local Debounce = true
local Control = {f = 0, b = 0, l = 0, r = 0}
local LastControl = {f = 0, b = 0, l = 0, r = 0}
local MaxSpeed = 120
local Speed = 15

local function Fly()
    local bg = Instance.new("BodyGyro")
    bg.P = 9e4
    bg.MaxTorque = Vector3.new(0, 0, 0)
    bg.CFrame = Root.CFrame
    bg.Parent = Root

    local bv = Instance.new("BodyVelocity")
    bv.Velocity = Vector3.new(0,0,0)
    bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)

    repeat
        wait()
        if Control.l + Control.r ~= 0 or Control.f + Control.b ~= 0 then
            Speed = Speed + 0.2
            if Speed > MaxSpeed then
                Speed = MaxSpeed
            end
        elseif not (Control.l + Control.r ~= 0 or Control.f + Control.b ~= 0) and Speed ~= 0 then
            Speed = Speed-1
            if Speed < 0 then
                Speed = 0
            end
        end

        if (Control.l + Control.r) ~= 0 or (Control.f + Control.b) ~= 0 then
            bv.Velocity = ((Camera.CFrame.LookVector * (Control.f + Control.b)) + ((Camera.CFrame * CFrame.new(Control.l + Control.r, (Control.f + Control.b) *0.2,0).Position) - Camera.CFrame.Position)) * Speed
            LastControl = {f = Control.f, b = Control.b, l = Control.l, r = Control.r}
        elseif (Control.l + Control.r) == 0 and (Control.f + Control.b) == 0 and speed ~= 0 then
            bv.Velocity = ((Camera.CoordinateFrame.lookVector * (lastControl.f+lastControl.b)) + ((Camera.CoordinateFrame * CFrame.new(lastControl.l+lastControl.r,(lastControl.f+lastControl.b)*.2,0).p) - Camera.CFrame.Position)) * Speed
        else
            bv.Velocity = Vector3.new(0,0,0)
        end
    until not Flying

    Control = {f = 0, b = 0, l = 0, r = 0}
    LastControl = {f = 0, b = 0, l = 0, r = 0}
    Speed = 0
    bg:Destroy()
    bv:Destroy()
end

Mouse.KeyDown:connect(function(Key)
    Key = Key:lower()

    if Key == "e" then
        Flying = not Flying
        if not Flying then
            Fly()
        end
    elseif Key == "w" then
        Control.f = 1
    elseif Key == "s" then
        Control.b = -1
    elseif Key == "a" then
        Control.l = -1
    elseif Key == "d" then
        Control.r = 1
    end
end)

mouse.KeyUp:connect(function(Key)
    Key = Key:lower()
    if Key == "w" then
        Control.f = 0
    elseif Key == "s" then
        Control.b = 0
    elseif Key == "a" then
        Control.l = 0
    elseif Key == "d" then
        Control.r = 0
    end
end)

Fly()

for i,v in pairs(Character:GetChildren()) do
    if v.Name == "CharacterMesh" then
        v:Destroy()
    end
end
