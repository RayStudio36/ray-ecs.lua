local Filter = require((...):gsub('system', 'filter'))

---@class System
---@field protected filter Filter
---@field private _system table
---@field private _world World
local System = Class("System")

function System:init()
    self.filter = Filter

    local system = TinyECS.system()
    system.filter = self:createFilter()
    system.update = function(t, dt)
        self:update(t.entities, dt)
    end

    self._system = system
    self._world = nil
end

function System:createFilter()
end

---@param entities Entity[]
function System:update(entities, dt)
end

---@protected
---@return World
function System:getWorld()
    return self._world
end

return System
