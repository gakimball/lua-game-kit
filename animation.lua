--- @class Animation
--- @field base_id number ID of initial sprite.
--- @field frames number Number of frames.
--- @field loop boolean Animation should loop.
--- @field speed number Speed of animation.
Animation = {}
Animation.__index = Animation

--- Create a new animation
--- @param base_id number ID of initial sprite.
--- @param frames number Number of frames.
--- @param loop boolean Animation should loop.
--- @param speed number Speed of animation.
function Animation.new(base_id, frames, loop, speed)
  return setmetatable({
    base_id = base_id,
    current_id = base_id,
    frames = frames,
    loop = loop,
    speed = speed,
  }, Animation)
end

--- Advance the animation; call this once per frame.
function Animation:tick()
  local next_id = self.current_id + 1 / self.speed

  if next_id >= self.base_id + self.frames - 1 then
    if self.loop then
      next_id = self.base_id
    else
      next_id = self.current_id
    end
  end

  self.current_id = next_id
end

function Animation:sprite()
  return self.current_id
end
