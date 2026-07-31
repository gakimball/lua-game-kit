--- @class EventEmitter
--- @field handlers function[]
EventEmitter = {}
EventEmitter.__index = EventEmitter

function EventEmitter.new()
  return setmetatable({
    handlers = {}
  }, EventEmitter)
end

function EventEmitter:subscribe(handler)
  table.insert(self.handlers, handler)
end

function EventEmitter:emit(event)
  for _, handler in ipairs(self.handlers) do
    handler(event)
  end
end
