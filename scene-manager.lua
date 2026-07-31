--- @class SceneUpdateContext
--- @field removeMe fun(): nil
--- @field isTopScene boolean

--- @class SceneDrawContext
--- @field isTopScene boolean

--- @class Scene<T, I>
--- @field init fun(arg: I): T
--- @field update? fun(state: T, context: SceneUpdateContext): nil
--- @field handleInput? fun(state: T, context: SceneUpdateContext): boolean
--- @field onDestroy? fun(state: T): nil
--- @field draw fun(state: T, context: SceneDrawContext): nil

--- @class SceneInstance
--- @field defn Scene
--- @field state any

--- @class SceneManager
--- @field scenes SceneInstance[]
SceneManager = {}
SceneManager.__index = SceneManager

function SceneManager.new()
  return setmetatable({
    scenes = {}
  }, SceneManager)
end

function SceneManager:update()
  local handledInput = false
  --- @type number[]
  local toRemove = {}

  for i = #self.scenes, 1, -1 do
    local scene = self.scenes[i]
    local context = {
      isTopScene = i == #self.scenes,
      removeMe = function() table.insert(toRemove, i) end,
    }

    if not handledInput and scene.defn.handleInput then
      handledInput = scene.defn.handleInput(scene.state, context)
    end

    if scene.defn.update then scene.defn.update(scene.state, context) end
  end
end

function SceneManager:draw()
  for i = 1, #self.scenes do
    local scene = self.scenes[i]

    scene.defn.draw(scene.state, {
      isTopScene = i == #self.scenes,
    })
  end
end

--- @generic T
--- @generic I
--- @param scene Scene<T, I>
--- @param arg? I
function SceneManager:replaceScene(scene, arg)
  self:unloadScene(#self.scenes)
  self:addScene(scene, arg)
end

--- @generic T
--- @generic I
--- @param scene Scene<T, I>
--- @param arg? I
function SceneManager:addScene(scene, arg)
  table.insert(self.scenes, {
    defn = scene,
    state = scene.init(arg),
  })
end

--- @param scene Scene
function SceneManager:removeScene(scene)
  for i = #self.scenes, 1, -1 do
    if self.scenes[i].defn == scene then
      self:unloadScene(i)
      break
    end
  end
end

--- @private
--- @param index number
function SceneManager:unloadScene(index)
  --- @type SceneInstance
  local removed = table.remove(self.scenes, index)
  if removed.defn.onDestroy then
    removed.defn.onDestroy(removed.state)
  end
end
