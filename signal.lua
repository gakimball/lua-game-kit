--- @class Signal
Signal = {}
Signal.__index = Signal

function Signal.new(initialValue)
  return setmetatable({
    value = initialValue,
    subscribers = {},
  }, Signal)
end

function Signal:set(value)
  self.value = value
end
