**ENSURE YOUR EXECUTOR HAS [`sethiddenproperty`](https://docs.sunc.su/Reflection/sethiddenproperty/)**

simplified version of [ShownApe](https://github.com/ShownApe)'s Hat Drop. why write 300 lines when 100 does the exact same thing? though being simplified doesn't always mean better, obviously.

## How It Works

Hat Drop exploits Roblox's accessory physics reevaluation system triggered by [`Character.ChildRemoved`](https://create.roblox.com/docs/reference/engine/classes/Instance#ChildRemoved). the key is applying [`BackendAccoutrementState`](https://robloxapi.github.io/ref/class/Accoutrement.html) ( States 0-3 ) at precise timings before / after the trigger fires.

**FallenPartsDestroyHeight Purpose:**
- set to `0/0` [ NaN ] temporarily, restored after drop completes
- hides Character limbs

**ChildRemoved Trigger:**
Roblox reevaluates accessory physics when **direct children** are removed from Character, after ChangeState(15), takes ~0.1s for ChildRemoved to trigger

## State Order

Head Hats ( attached to Head ):
1. apply State 0-3 **BEFORE** ChildRemoved

NoHead Hats ( shoulder, back, waist - attached to Torso / other ):
1. wait for ChildRemoved trigger / wait(.1) after ChangeState(15)
2. apply State 0-3 to **ALL** Hats **AFTER** trigger fires / 0.1s after ChangeState(15)

this timing separation ensures both Head and NonHead Hats drop consistently. applying State 0-3 to NonHead too early causes Roblox to reset them and fail the drop.

## BackendAccoutrementState Values
```
NOTHING = 0
HAS_HANDLE = 1
IN_WORKSPACE = 2
IN_CHARACTER = 4
EQUIPPED = 5
```

any State != 4 allows drop. States 0-3 all work identically for this exploit.

## Credits

full credit to [**ShownApe**](https://github.com/ShownApe) for the explanations, reverse-engineering, and original concept. helped me understand the entire system. i interpreted the method my own way with my indentation and style, but the core mechanics are his work.

this wouldn't exist without his help. respect.

## Explanation
```lua
local Players = game:GetService("Players")
local Char = Players.LocalPlayer.Character
local Root = Char:WaitForChild("HumanoidRootPart")
local Hats = Char.Humanoid:GetAccessories()
local DestroyH = workspace.FallenPartsDestroyHeight
local G = workspace.Gravity

-- save FallenPartsDestroyHeight because we set it to 0/0 (NaN)
-- this lets us position Character at FallenPartsDestroyHeight without losing limbs
-- restored only after Success / Hat collision detected

-- apply State 0 to Head Hats BEFORE ChildRemoved / death
for _, v in pairs(Hats) do
 if v:GetChildren()[1]:GetJoints()[1].Part1 == Char.Head then
  sethiddenproperty(v, "BackendAccoutrementState", 0)
 end
end

workspace.FallenPartsDestroyHeight = 0/0
workspace.Gravity = 0

local A = Instance.new("Animation")
A.AnimationId = "rbxassetid://" .. (Char.Humanoid.RigType == Enum.HumanoidRigType.R15 and 507767968 or 220512718)
local Track = Char.Humanoid:LoadAnimation(A)
Track:Play(0, 1, 0)
Track.TimePosition = Char.Humanoid.RigType == Enum.HumanoidRigType.R15 and .1 or .72

spawn(function()
 Players.LocalPlayer.SimulationRadius = 999
 while Root.Parent do
  Root.CFrame = CFrame.new(Root.Position.X, Char.Humanoid.RigType == Enum.HumanoidRigType.R15 and DestroyH - .7 or DestroyH - 4, Root.Position.Z)
  Root.Velocity = Vector3.new(0, 26, 0)
  game:GetService("RunService").PostSimulation:Wait()
 end
end)

wait(.45)
Char.Humanoid:ChangeState(15)
Char.ChildRemoved:Wait() -- ~0.1s after ChangeState(15)

-- verification is simple: if Hats exist, apply State 0 and move them upward
-- if Hat has collision, Success = true + break
-- if no collision, wait for Players.LocalPlayer.Character ~= Char (CharacterAdded) and print "failed"

for _, v in pairs(Hats) do sethiddenproperty(v, "BackendAccoutrementState", 0) end

workspace.FallenPartsDestroyHeight = DestroyH

local Success = false
repeat for _, v in pairs(Hats) do local H = v:FindFirstChild("Handle") if H and H.CanCollide then Success = true break end end if Players.LocalPlayer.Character ~= Char then break end wait() until Success

workspace.Gravity = G

if not Success then print("failed") else warn("sucess")
 for _, v in pairs(Hats) do
  local H = v:FindFirstChild("Handle") if H then
   -- T2 is a test BasePart in my game
   workspace.CurrentCamera.CameraSubject = workspace.T2
   H.CFrame = workspace.T2.CFrame
  end
 end
end
```
