local Char = game:GetService("Players").LocalPlayer.Character
local Root = Char.HumanoidRootPart
local Hats = Char.Humanoid:GetAccessories()

local D = workspace.FallenPartsDestroyHeight

workspace.FallenPartsDestroyHeight = 0/0
workspace.CurrentCamera.CameraSubject = workspace:GetChildren()[16] --change

local A = Instance.new("Animation")
A.AnimationId = "rbxassetid://" .. (Char.Humanoid.RigType == Enum.HumanoidRigType.R15 and 507767968 or 220512718)
local Track = Char.Humanoid:LoadAnimation(A)
Track:Play(0, 1, 0)
Track.TimePosition = Char.Humanoid.RigType == Enum.HumanoidRigType.R15 and 0.1 or 0.72

task.spawn(function()
 while Root.Parent do game:GetService("RunService").PostSimulation:Wait()
  Root.CFrame = CFrame.new(Root.Position.X, Char.Humanoid.RigType == Enum.HumanoidRigType.R15 and D - 0.7 or D - 4, Root.Position.Z)
  game:GetService("Players").LocalPlayer.SimulationRadius = 999
  Root.Velocity = Vector3.new(0, 26, 0)
 end
end)

wait(.3)
Char.Humanoid:ChangeState(15)
Char.ChildRemoved:Wait()

local Success = false
repeat game:GetService("RunService").PostSimulation:Wait()
for _, V in Hats do sethiddenproperty(V, "BackendAccoutrementState", 2)
local H = V:FindFirstChildWhichIsA("BasePart") if H and H.CanCollide then Success = true end end
until Success or game:GetService("Players").LocalPlayer.Character ~= Char

workspace.FallenPartsDestroyHeight = D

if not Success then print("failed") else warn("success")
 for _, V in Hats do
  local H = V:FindFirstChildWhichIsA("BasePart") if H then 
   H.CFrame = workspace:GetChildren()[16].CFrame + Vector3.new(0,5,0) --change
  end
 end
end
