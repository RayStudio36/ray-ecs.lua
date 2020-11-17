local Entity = require((...):gsub('global', 'entity'))

---@class Global
---@field private _entityPool Pool
local Global = {}

function Global:init()
    self._entityPool = Pool({
        ctor = {
            [Pool.DEFAULT_TAG] = Entity
        }
    })
end

---@param world World
---@return Entity
function Global:getEntity(world, eid, singletonName)
    return self._entityPool:get(world, eid, singletonName)
end

---@param entity Entity
function Global:recycleEntity(entity)
    self._entityPool:recycle(entity)
end

Global:init()

return Global