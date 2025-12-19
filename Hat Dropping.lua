local Char = game.Players.LocalPlayer.Character
local Root = Char:WaitForChild("HumanoidRootPart")
local Hats = Char.Humanoid:GetAccessories()

local D = workspace.FallenPartsDestroyHeight

for _, v in pairs(Hats) do if v:GetChildren()[1]:GetJoints()[1].Part1 == Char.Head then sethiddenproperty(v, "BackendAccoutrementState", 2) end end

game.Players.LocalPlayer.SimulationRadius = 999
workspace.FallenPartsDestroyHeight = 0/0

local A = Instance.new("Animation")
A.AnimationId = "rbxassetid://" .. (Char.Humanoid.RigType == Enum.HumanoidRigType.R15 and 507767968 or 220512718)
local Track = Char.Humanoid:LoadAnimation(A)
Track:Play(0, 1, 0)
Track.TimePosition = Char.Humanoid.RigType == Enum.HumanoidRigType.R15 and .1 or .72

spawn(function()
 while Root.Parent do
  Root.CFrame = CFrame.new(Root.Position.X, Char.Humanoid.RigType == Enum.HumanoidRigType.R15 and D - 0.7 or D - 4, Root.Position.Z)
  Root.Velocity = Vector3.new(0, 26, 0)
  game:GetService("RunService").PostSimulation:Wait()
 end
end)

wait(.45) Char.Humanoid:ChangeState(15) wait(.1)

local Success = false
repeat for _, v in pairs(Hats) do local H = v:FindFirstChild("Handle") sethiddenproperty(v, "BackendAccoutrementState", 2) if H then H.AssemblyLinearVelocity = Vector3.new(0, 30, 0) if H and H.CanCollide then Success = true break end end end if game.Players.LocalPlayer.Character ~= Char then break end task.wait() until Success

workspace.FallenPartsDestroyHeight = D

if not Success then print("failed") else warn("sucess")
 for _, v in pairs(Hats) do
  local H = v:FindFirstChild("Handle") if H then
   workspace.CurrentCamera.CameraSubject = workspace.T3
   H.CFrame = workspace.T3.CFrame
  end
 end
end
