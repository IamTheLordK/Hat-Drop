**ENSURE YOUR EXECUTOR HAS [`sethiddenproperty`](https://docs.sunc.su/Reflection/sethiddenproperty/)**

simplified version of [ShownApe](https://github.com/ShownApe) Hat Drop. why write 300 lines when 100 does the exact same thing? though being simplified doesnt always mean better, obviously.

## How It Works

Hat Drop exploits Roblox's accessory physics reevaluation behavior around [`Character.ChildRemoved`](https://create.roblox.com/docs/reference/engine/classes/Instance#ChildRemoved).

the method uses [`BackendAccoutrementState`](https://robloxapi.github.io/ref/class/Accoutrement.html) as an internal trigger while Roblox is reevaluating the Accessories.

the general sequence is:

1. save `FallenPartsDestroyHeight`
2. temporarily set `FallenPartsDestroyHeight` to `0/0` (`NaN`)
3. play the animation while positioning the Character at FPDH
4. call `Humanoid:ChangeState(15)`
5. wait for `Character.ChildRemoved`
6. repeatedly write `BackendAccoutrementState` to all Accessories
7. wait until a Handle becomes collidable
8. restore `FallenPartsDestroyHeight`

### FallenPartsDestroyHeight Purpose

* temporarily set to `0/0` (`NaN`)
* allows the Character to be positioned at `FallenPartsDestroyHeight`
* prevents the normal void cleanup from removing the Character's limbs
* restored after the drop completes

### ChildRemoved Trigger

`Character.ChildRemoved` is used as the synchronization point for the accessory physics reevaluation caused by `Humanoid:ChangeState(15)`.

after the event fires, the script starts repeatedly writing `BackendAccoutrementState` while checking for collision.

## BackendAccoutrementState

Roblox exposes the following internal values:

```text
NOTHING = 0
HAS_HANDLE = 1
IN_WORKSPACE = 2
IN_CHARACTER = 3
EQUIPPED = 4
```

for this exploit, the important distinction is that `4` is the normal equipped state.

testing showed that writing other states can trigger the relevant accessory processing, so the method does not depend on one specific value.

## Verification

the script repeatedly:

1. writes `BackendAccoutrementState`
2. checks the Accessory Handle
3. gives the Handle upward velocity
4. checks `CanCollide`
5. stops when collision is detected
6. aborts if the Character changes

once successful, the dropped Handles are moved to the saved position.

## Credits

full credit to [**ShownApe**](https://github.com/ShownApe) for the explanations, reverse-engineering, and original concept. helped me understand the entire system. i interpreted the method my own way with my indentation and style, but the core mechanics are his work.

this wouldnt exist without his help. respect.

[`Own testing place`](https://www.roblox.com/pt/games/85054550685240/Desync-Stuff)
