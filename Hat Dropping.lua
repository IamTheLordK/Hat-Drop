local Char = game.Players.LocalPlayer.Character
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

for _, V in Hats do if V:GetChildren()[1]:GetJoints()[1].Part1 == Char.Head then sethiddenproperty(V, "BackendAccoutrementState", 2) end end

local A = Instance.new("Animation")
A.AnimationId = "rbxassetid://" .. (Char.Humanoid.RigType == Enum.HumanoidRigType.R15 and 507767968 or 220512718)
local Track = Char.Humanoid:LoadAnimation(A)
Track:Play(0, 1, 0)
Track.TimePosition = Char.Humanoid.RigType == Enum.HumanoidRigType.R15 and .1 or .72

task.spawn(function()
 while Root.Parent do task.wait()
  Root.CFrame = CFrame.new(Root.Position.X, Char.Humanoid.RigType == Enum.HumanoidRigType.R15 and D - 0.7 or D - 4, Root.Position.Z)
  game.Players.LocalPlayer.SimulationRadius = 999
  Root.Velocity = Vector3.new(0, 15, 0)
 end
end)

task.wait(.3)
Char.Humanoid:ChangeState(15)
Char.ChildRemoved:Wait()

local Success = false
repeat task.wait()
for _, V in Hats do sethiddenproperty(V, "BackendAccoutrementState", 2)
local H = V:FindFirstChild("Handle") if H and H.CanCollide then Success = true end end
until Success or game.Players.LocalPlayer.Character ~= Char

workspace.FallenPartsDestroyHeight = D

if not Success then print("failed") else warn("success")
 for _, V in Hats do
  local H = V:FindFirstChild("Handle") if H then 
   H.CFrame = Old.CFrame
  end
 end
end
