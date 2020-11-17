local Global = require((...):gsub('world', 'global'))
local Entity = require((...):gsub('world', 'entity'))

---@class World
---@field private _world table
---@field private _eid number
---@field private _singletonEntity table<string, Entity>
---@field private _changedEntityCache Entity
local World = Class("World")

function World:init()
    self._world = TinyECS.world()
    self._eid = 0
    self._singletonEntity = {}

    self._changedEntityCache = nil
end

--region Public

---@public
---@param dt number
function World:update(dt)
    if self._changedEntityCache then
        self._changedEntityCache = nil
    end

    self._world:update(dt)
end

---@public
---@param system System
function World:addSystem(system)
    self._world:addSystem(system._system)
    system._world = self
end

---@public
---@param system System
function World:removeSystem(system)
    self._world:removeSystem(system._system)
    system._world = nil
end

---@public
---@return Entity
function World:createEntity()
    local e = Global:getEntity(self, self:getEid())
    self:addEntity(e)
    return e
end

---@public
---@param name string SingletonEntity Identifier
---@return Entity
function World:createSingletonEntity(name)
    if self._singletonEntity[name] then
        return self._singletonEntity[name]
    end

    local e = Global:getEntity(self, self:getEid(), name)
    self:addEntity(e)
    return e
end

---@public
---@param entity Entity
function World:removeEntity(entity)
    if entity._singletonName then
        self:removeSingletonEntity(entity)
    end

    self._world:removeEntity(entity)

    if self._changedEntityCache == entity then
        self._changedEntityCache = nil
    end

    Global:recycleEntity(entity)
end

---@public
---@param singletonName string
---@return Entity
function World:getSingletonEntity(singletonName)
    return self._singletonEntity[singletonName]
end

--endregion

--region Private

---@private
function World:getEid()
    self._eid = self._eid + 1
    return self._eid
end

---@private
---@param entity Entity
function World:addEntity(entity)
    if entity ~= self._changedEntityCache then
        self._changedEntityCache = entity
        self._world:addEntity(entity)
    end
end

---@private
---@param entity Entity
function World:addSingletonEntity(entity)
    if self._singletonEntity[entity._singletonName] then
        Log.error(string.format("Singleton entity %s already in this world"), entity._singletonName)
        return
    end

    self._singletonEntity[entity._singletonName] = entity
end

---@private
---@param entity Entity | string
function World:removeSingletonEntity(entity)
    local singletonName = entity
    if not type(entity) == "string" then
        singletonName = entity._singletonName
    end

    if not self._singletonEntity[singletonName] then
        Log.error(string.format("Entity %s isn't a singleton"), singletonName)
        return
    end

    self._singletonEntity[singletonName] = nil
end

--endregion

return World
