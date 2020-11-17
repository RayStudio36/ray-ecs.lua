# Ray-ECS

A lua ECS framework base on [tiny-ecs](https://github.com/RayStudio36/tiny-ecs).

## Dependency

- [30log](https://github.com/RayStudio36/30log)
- [tiny-ecs](https://github.com/RayStudio36/tiny-ecs)
- [pool](https://github.com/RayStudio36/pool.lua)

## Example

- `init.lua`

    ```lua
    --- Dependency
    _G.Class = require("30log")
    _G.TinyECS = require("tiny-ecs")
    _G.Pool = require("pool")
    
    --- RayECS
    local RayECS = require("ray-ecs", true)
    _G.System = RayECS.System
    _G.Comp = RayECS.Comp
    _G.World = RayECS.World
    _G.Entity = RayECS.Entity
    _G.Global = RayECS.Global
    ```
  
- `tf-comp.lua`
 
    ```lua
    ---@class TfComp : Comp
    ---@field public pos Vector2
    ---@field public rotation number
    ---@field public scale Vector2
    local TfComp = Comp:extend("TfComp")
    
    function TfComp:init(pos, rotation, scale)
        self.pos = pos or Vector2.zero()
        self.rotation = rotation or 0
        self.scale = scale or Vector2.one()
    end
    
    return TfComp
    ```
   
- `tf-system.lua`
 
    ```lua
    local TfComp = require("tf-comp")
    local ViewComp = require("view-comp")
    local PhysicsComp = require("physics-comp")
    
    ---@class TfSystem : System
    local TfSystem = System:extend("TfSystem")
    
    function TfSystem:createFilter()
        return self.filter.And(
                self.filter.RequireAll(TfComp, ViewComp),
                self.filter.RejectAny(PhysicsComp)
        )
    end
    
    function TfSystem:update(entities, dt)
        for _, entity in ipairs(entities) do
            local viewObj = entity.ViewComp.viewObj
            ---@type TfComp
            local tfComp = entity.TfComp
            ViewObjUtil.SetPos(viewObj, tfComp.pos)
            ViewObjUtil.SetRot(viewObj, tfComp.rotation)
            ViewObjUtil.SetScale(viewObj, tfComp.scale)
        end
    end
    
    return TfSystem
    ```
- `main.lua`

    ```lua
    local world = nil
    
    function init()
        world = World()
        world:addSystem(TfSystem())
    
        playerEntity = world:createEntity()
        playerEntity:addComp(TfComp(pos, rotation, scale))
    end
    
    function update(dt)
        world:update(dt)
    end
    ```
 