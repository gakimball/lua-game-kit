--- @alias PhysicsDirection
--- | 0
--- | 1
--- | -1

--- @class PhysicsBody
PhysicsBody = {
  --- Width
  w = 1,
  --- Height
  h = 1,
  --- X position
  x = 0,
  --- Y position
  y = 0,
  --- X-axis velocity
  dx = 0,
  --- Y-axis velocity
  dy = 0,
  --- Max velocity
  dmax = 0,
  --- X-axis acceleration
  ax = 0,
  --- Y-axis acceleration
  ay = 0,
  --- Deacceleration factor
  drag = 0.8,

  --- @param props PhysicsBody
  new = function(props)
    return setmetatable(props, PhysicsBody)
  end,

  --- @param self PhysicsBody
  --- @param move_x PhysicsDirection
  --- @param move_y PhysicsDirection
  move = function(self, move_x, move_y)
    local ddx = self.ax * move_x
    local ddy = self.ay * move_y

    local dx = math.max(
      math.min(self.dx + ddx, self.dmax),
      -self.dmax
    )
    local dy = math.max(
      math.min(self.dy + ddy, self.dmax),
      -self.dmax
    )

    if ddx == 0 then dx = dx * self.drag end
    if ddy == 0 then dy = dy * self.drag end

    self.dx = dx
    self.dy = dy

    self.x = self.x + self.dx
    self.y = self.y + self.dy
  end,

  --- @param self PhysicsBody
  --- @param target PhysicsBody
  collides = function(self, target)
    return self.x < target.x + target.w
        and self.x + self.w > target.x
        and self.y < target.y + target.h
        and self.y + self.h > target.y
  end,
}

PhysicsBody.__index = PhysicsBody
