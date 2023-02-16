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

print(statemachine:enter(SwitchOn))
print(statemachine:enter(SwitchOn))
print(statemachine:enter(SwitchOff))
