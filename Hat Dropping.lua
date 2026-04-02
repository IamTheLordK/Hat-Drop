local Char = game:GetService("Players").LocalPlayer.Character
local Root = Char.HumanoidRootPart
local Hats = Char.Humanoid:GetAccessories()

local D = workspace.FallenPartsDestroyHeight

local Old = Instance.new("Part", workspace)
Old.Size = Vector3.zero
Old.Anchored = true
Old.CanCollide = false
Old.CFrame = Root.CFrame

for _, V in Hats do if V:GetChildren()[1]:GetJoints()[1].Part1 == Char.Head then sethiddenproperty(V, "BackendAccoutrementState", 2) end end

workspace.FallenPartsDestroyHeight = 0/0

local A = Instance.new("Animation")
A.AnimationId = "rbxassetid://" .. (Char.Humanoid.RigType == Enum.HumanoidRigType.R15 and 507767968 or 220512718)
local Track = Char.Humanoid:LoadAnimation(A)
Track:Play(0, 1, 0)
Track.TimePosition = Char.Humanoid.RigType == Enum.HumanoidRigType.R15 and .1 or .72

task.spawn(function()
while Root.Parent do game:GetService("RunService").PostSimulation:Wait()
 Root.CFrame = CFrame.new(Root.Position.X, Char.Humanoid.RigType == Enum.HumanoidRigType.R15 and D - 0.7 or D - 4, Root.Position.Z)
 Root.Velocity = Vector3.new(0, 26, 0)
 game:GetService("Players").LocalPlayer.SimulationRadius = 999
end
end)

task.wait(.45)
Char.Humanoid:ChangeState(15)
Char.ChildRemoved:Wait()

local Success = false
repeat
for _, V in Hats do
 local H = V:FindFirstChild("Handle")
 sethiddenproperty(V, "BackendAccoutrementState", 2) if H then
  H.AssemblyLinearVelocity = Vector3.new(0, 30, 0)
  if H.CanCollide then Success = true break end
 end
end
if game:GetService("Players").LocalPlayer.Character ~= Char then break end
task.wait()
until Success

workspace.FallenPartsDestroyHeight = D

if not Success then print("failed") else warn("success")
for _, V in Hats do
 local H = V:FindFirstChild("Handle") if H then
  workspace.CurrentCamera.CameraSubject = Old
   H.CFrame = Old.CFrame
  end
 end
end
