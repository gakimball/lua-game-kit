--- @class State
State = {}
State.__index = State

function State.new()
  return setmetatable({}, State)
end

--- @param nextState State
function State:canGoTo(nextState)
  return true
end

function State:update()
end

--
--

--- @class StateMachine
--- @field currentState State | nil
StateMachine = {}
StateMachine.__index = StateMachine

function StateMachine.new()
  return setmetatable({
    currentState = nil
  }, StateMachine)
end

--- @param nextState State
function StateMachine:enter(nextState)
  if not self.currentState or self.currentState:canGoTo(nextState) then
    self.currentState = nextState.new()
    self:onChangeState(nextState)
    return true
  end

  return false
end

function StateMachine:update()
  if self.currentState then
    self.currentState:update()
  end
end

--- @param newState State
function StateMachine:onChangeState(newState) end
