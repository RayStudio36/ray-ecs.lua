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
 
 ## Document
 
 TODO
 
 ## License
 
 Copyright 2020 RayStudio9236
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.