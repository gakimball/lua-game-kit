# lua-game-kit

> Collection of utilities for use in games

Ideally usable in any Lua-based engine, such as PICO-8, TIC-80, LÖVE, or the PlayDate. (I've only used these in the first two, though.)

# Animation

```lua
require('animation')

local anim = Animation.new(
  -- ID of the first sprite in the animation
  1,
  -- Number of frames
  -- In this example, the animation would cycle through sprites 1, 2, 3, 4
  4,
  -- Animation should loop when finished
  true,
  -- Speed of animation in frames
  -- If game is 60FPS, 20 would be 3 frames per second
  20,
)

function _update()
  -- Should be called once per frame
  anim:tick()
end

function _draw()
  -- `sprite()` returns the ID of the sprite to draw for this frame
  spr(anim:sprite(), 0, 0)
end
```

# Physics

```lua
local obj1 = PhysicsBody.new({
  x = 0,
  y = 0,
  w = 8,
  h = 8,
  dx = 1,
  dy = 1,
})
local obj2 = PhysicsBody.new({
  x = 0,
  y = 0,
  w = 4,
  h = 4,
  dx = 2,
  dy = 2,
})

-- Move down
obj1:move(0, 1)

-- Move left
obj1:move(-1, 0)

-- Check if two objects collide
obj1:collides(obj2)
```

- `PhysicsBody`: class representing one body in a world.
  - `x`: X position.
  - `y`: Y position.
  - `w`: Width.
  - `h`: Height.
  - `dx`: Current X velocity. (Don't set this directly; the library will change it depending on the body's acceleration and current heading.)
  - `dy`: Current Y velocity. (Don't set this directly either.)
  - `ax`: X acceleration when moving horizontally.
  - `ay`: Y acceleration when moving vertically.
  - `drag`: Decimal value to gradually slow down body when not moving.
  - `move(self, x, y): nil`: Call this once per frame to update a body's speed and position, even if the user is not inputting a direction. For X and Y, pass 0, -1, or 1 depending on the desired direction.
  - `collides(self, target): boolean`: Check if one body collides with another.


# State machine

```lua
require('state-machine')

--- @class SwitchOn: State
SwitchOn = {
  new = function()
    return setmetatable({
      canGoTo = function(self, nextState)
        return nextState == SwitchOff
      end,
    }, State)
  end,
}

--- @class SwitchOff: State
SwitchOff = {
  new = function()
    return setmetatable({
      canGoTo = function(self, nextState)
        return nextState == SwitchOn
      end,
    }, State)
  end,
}

local statemachine = StateMachine.new()

-- Valid: nil => SwitchOn
print(statemachine:enter(SwitchOn))
-- Invalid: SwitchOn => SwitchOn
print(statemachine:enter(SwitchOn))
-- Invalid: SwitchOn => SwitchOff
print(statemachine:enter(SwitchOff))
```

- `State`: base class for individual states. Create a subclass for each state. Override these methods to customize the state:
  - `canGoTo(self, nextState): boolean`: should return `true` if this state can transition to `nextState`.
  - `update(self): nil`: tick function to call on each frame while this is the active state. (Don't call this directly; the `StateMachine` class does that.)
- `StateMachine`: class representing a state machine.
  - `enter(self, nextState): bool`: attempt a state transition, assuming the current/next state are compatible. Returns `true` if the transition happens.
  - `update(self): nil`: call this on every frame to tick the current state. If your states don't have any logic, then you don't need to call this.
  - `onChangeState(self, newState): nil`: override this method to set up an event listener that fires after a state change.

# License

MIT &copy; [Geoff Kimball](https://geoffkimball.com)
