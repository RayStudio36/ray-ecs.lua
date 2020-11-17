local path = ...

if string.sub(path, -5) ~= '.init' then
    path = path .. '.init'
end

local RayECS = {
    Comp = require(path:gsub('[^/.\\]+$', 'comp')),
    Entity = require(path:gsub('[^/.\\]+$', 'entity')),
    Global = require(path:gsub('[^/.\\]+$', 'global')),
    System = require(path:gsub('[^/.\\]+$', 'system')),
    World = require(path:gsub('[^/.\\]+$', 'world')),
}

return RayECS