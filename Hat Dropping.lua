local Char = game:GetService("Players").LocalPlayer.Character
local Root = Char.HumanoidRootPart
local Hats = Char.Humanoid:GetAccessories()

local Old = Instance.new("Part", Char)
Old.CFrame = Char.Head.CFrame
Old.CanCollide = false
Old.Transparency = 1
Old.Anchored = true

local D = workspace.FallenPartsDestroyHeight

workspace.CurrentCamera.CameraSubject = Old
workspace.FallenPartsDestroyHeight = 0/0

local A = Instance.new("Animation")
A.AnimationId = "rbxassetid://" .. (Char.Humanoid.RigType == Enum.HumanoidRigType.R15 and 507767968 or 220512718)
local Track = Char.Humanoid:LoadAnimation(A)
Track:Play(0, 1, 0)
Track.TimePosition = Char.Humanoid.RigType == Enum.HumanoidRigType.R15 and 0.1 or 0.72

task.spawn(function()
 while Root.Parent do task.wait()
  Root.CFrame = CFrame.new(Root.Position.X, D + (Char.Humanoid.RigType == Enum.HumanoidRigType.R15 and -0.7 or -4), Root.Position.Z)
  Root.AssemblyLinearVelocity = Vector3.new(0, 26, 0)
  game:GetService("Players").LocalPlayer.SimulationRadius = 999
 end
end)

task.wait(0.5)
Char.Humanoid:ChangeState(15)
Char.ChildRemoved:Wait()

local Success = false

for _, V in Hats do
 local H = V:FindFirstChildWhichIsA("BasePart") if not H then continue end
 H:GetPropertyChangedSignal("CanCollide"):Connect(function() if H.CanCollide then Success = true end end)
 sethiddenproperty(V, "BackendAccoutrementState", 3)
end

repeat task.wait() until Success or not Char.Parent

workspace.FallenPartsDestroyHeight = D

if not Success then print("failed") return end

warn("success")
for _, V in Hats do
 local H = V:FindFirstChildWhichIsA("BasePart") if H then H.CFrame = Old.CFrame end
end
