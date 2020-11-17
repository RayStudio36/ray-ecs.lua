local Comp = require((...):gsub('entity', 'comp'))

---@class Entity
---@field public id number
---@field private _world World
---@field private _singletonName boolean
---@field private _comps table<string, number>
local Entity = Class("Entity")

function Entity:init()
    self.id = 0
    self._world = nil
    self._singletonName = nil
    self._comps = {}
end

---@public
---@param comp Comp
function Entity:addComp(comp)
    if not comp:instanceOf(Comp) then
        Log.error("comp is not an instance of Comp")
        return
    end

    self[comp.name] = comp
    self._comps[comp.name] = 1

    self._world:addEntity(self)
end

---@public
---@param comp Comp
function Entity:removeComp(comp)
    self[comp.name] = nil
    self._comps[comp.name] = nil

    self._world:addEntity(self)
end

---@public
---@return boolean
function Entity:isSingleton()
    return self._singletonName ~= nil
end

---@public
---@return World
function Entity:getWorld()
    return self._world
end

--region Private

---@private
---@param world World
---@param id number
---@param singletonName string
function Entity:awakeFromPool(world, id, singletonName)
    self.id = id
    self._world = world
    self._singletonName = singletonName

    if self._singletonName then
        self._world:addSingletonEntity(self)
    end
end

---@private
function Entity:recycleToPool()
    ---clear all components
    for k, _ in pairs(self._comps) do
        self[k] = nil
    end

    self._world = nil
    self._comps = {}
    self._singletonName = nil

    self.id = 0
end

--endregion

return Entity
