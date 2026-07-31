Direction = {
  NORTH = 0,
  SOUTH = 1,
  EAST = 2,
  WEST = 3,
}

Vector = {}
Vector.__index = Vector

function Vector.new(x, y)
  return setmetatable({
    x = x or 0,
    y = y or 0,
  }, Vector)
end

Vector.__add = function(a, b)
  local av = toVector(a)
  local bv = toVector(b)
  return Vector.new(
    av.x + bv.x,
    av.y + bv.y
  )
end

Vector.__sub = function(a, b)
  local av = toVector(a)
  local bv = toVector(b)
  return Vector.new(
    av.x - bv.x,
    av.y - bv.y
  )
end

Vector.__mul = function(a, b)
  local av = toVector(a)
  local bv = toVector(b)
  return Vector.new(
    av.x * bv.x,
    av.y * bv.y
  )
end

Vector.__div = function(a, b)
  local av = toVector(a)
  local bv = toVector(b)
  return Vector.new(
    av.x / bv.x,
    av.y / bv.y
  )
end

function getVectorOffsets(vec)
  return {
    {
      direction = Direction.NORTH,
      vector = vec + Vector.new(0, -1),
    },
    {
      direction = Direction.SOUTH,
      vector = vec + Vector.new(0, 1),
    },
    {
      direction = Direction.WEST,
      vector = vec + Vector.new(-1, 0),
    },
    {
      direction = Direction.EAST,
      vector = vec + Vector.new(1, 0),
    },
  }
end

function getVectorOffsetsWithDiagonals(vec)
  local base = getVectorOffsets(vec)
  local out = {}

  for _, item in ipairs(base) do
    table.insert(out, {
      directions = { item.direction },
      vector = item.vector,
    })
  end

  table.insert(out, {
    directions = { Direction.NORTH, Direction.WEST },
    vector = vec + Vector.new(-1, -1),
  })
  table.insert(out, {
    directions = { Direction.SOUTH, Direction.EAST },
    vector = vec + Vector.new(1, 1),
  })
  table.insert(out, {
    directions = { Direction.NORTH, Direction.EAST },
    vector = vec + Vector.new(-1, 1),
  })
  table.insert(out, {
    directions = { Direction.SOUTH, Direction.WEST },
    vector = vec + Vector.new(1, -1),
  })

  return out
end

function addVectorInDirection(vec, value, dir)
  if dir == Direction.NORTH then return vec + Vector.new(0, -1) end
  if dir == Direction.SOUTH then return vec + Vector.new(0, 1) end
  if dir == Direction.EAST then return vec + Vector.new(1, 0) end
  if dir == Direction.WEST then return vec + Vector.new(-1, 0) end
  return vec
end

function getTaxiDistance(a, b)
  return math.abs(a.x - b.x) + math.abs(a.y - b.y)
end

function getDirection(dx, dy)
  if dx > 0 then return Direction.EAST end
  if dx < 0 then return Direction.WEST end
  if dy > 0 then return Direction.SOUTH end
  return Direction.NORTH
end

function toVector(value)
  if getmetatable(value) == Vector then
    return value
  end

  if type(value) == 'number' then
    return Vector.new(value, value)
  end

  error('Cannot use ' .. type(value) .. ' in vector math')
end
