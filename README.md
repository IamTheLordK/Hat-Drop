**ENSURE YOUR EXECUTOR HAS `sethiddenproperty`**

simplified version of ShownApe's Hat Drop. why write 300 lines when 100 does the exact same thing? though being simplified doesn't always mean better, obviously.

## How It Works

Hat Drop exploits Roblox's accessory physics reevaluation system triggered by `Character.ChildRemoved`. the key is applying `BackendAccoutrementState` (States 0-3) at precise timings before/after the trigger fires.

**FallenPartsDestroyHeight Purpose:**
- set to `0/0` [ NaN ] temporarily, restored after drop completes
- hides Character limbs

**ChildRemoved Trigger:**
Roblox reevaluates accessory physics when **direct children** are removed from Character, após ChangeState(15), demora 0.1 segundos para que ChildRemoved sejá trigged

## State Order

Head Hats ( attached to Head ):
1. apply State 0-3 **BEFORE** ChildRemoved

NoHead Hats ( shoulder, back, waist - attached to Torso / other ):
1. wait for ChildRemoved trigger / wait(.1) após  ChangeState(15)
2. apply State 0-3 to **ALL** Hats **AFTER** trigger fires / 0.1 segundos após ChangeState(15)

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

full credit to **ShownApe** for the explanations, reverse-engineering, and original concept. helped me understand the entire system. i interpreted the method my own way with my indentation and style, but the core mechanics are his work.

this wouldn't exist without his help. respect.
