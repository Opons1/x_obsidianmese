--[[
    X Obsidianmese. Adds obsidian and mese tools and items.
    Copyright (C) 2025 SaKeL

    This library is free software; you can redistribute it and/or
    modify it under the terms of the GNU Lesser General Public
    License as published by the Free Software Foundation; either
    version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    Lesser General Public License for more details.
--]]
x_obsidianmese = {} --[[@as XObsidianmese]]

local mod_start_time = core.get_us_time()
local path = core.get_modpath('x_obsidianmese')
function x_obsidianmese.add_effects(pos)

    if core.has_feature({ dynamic_add_media_table = true, particlespawner_tweenable = true }) then
        -- new syntax, after v5.6.0
        local particlespawner_def = {
            amount = 20,
            time = 5,
            size = {
                min = 0.5,
                max = 1.5,
            },
            exptime = 5,
            pos = {
                min = vector.new({ x = pos.x - 1.5, y = pos.y, z = pos.z - 1.5 }),
                max = vector.new({ x = pos.x + 1.5, y = pos.y + 1.5, z = pos.z + 1.5 }),
            },
            attract = {
                kind = 'point',
                strength = math.random(10, 30) / 100,
                origin = vector.new({ x = pos.x, y = pos.y, z = pos.z })
            },
            texture = {
                name = 'x_obsidianmese_chest_particle.png',
                alpha_tween = {
                    0.5, 1,
                    style = 'fwd',
                    reps = 1
                }
            },
            radius = { min = 1, max = 1.5, bias = 1 },
            glow = 6
        }

        core.add_particlespawner(particlespawner_def)
    else
        local nodes = core.find_nodes_in_area(
            vector.subtract(pos, 2),
            vector.add(pos, 2),
            { 'air' }
        )

        if #nodes == 0 then
            return
        end

        for i = 1, 10, 1 do
            local pos_random = nodes[math.random(1, #nodes)]
            local x = pos.x - pos_random.x
            local y = pos_random.y - pos.y
            local z = pos.z - pos_random.z
            local rand1 = (math.random(1, 10) / 10) * -1
            local rand2 = math.random(10, 500) / 100
            local rand3 = math.random(50, 150) / 100

            core.after(rand2, function()
                core.add_particle({
                    pos = pos_random,
                    velocity = vector.divide({ x = x, y = 1 - y, z = z }, 4),
                    acceleration = vector.divide({ x = 0, y = rand1, z = 0 }, 4),
                    expirationtime = 4.5,
                    size = rand3,
                    texture = 'x_obsidianmese_chest_particle.png',
                    glow = 6,
                    collisiondetection = true,
                    collision_removal = true
                })
            end)
        end
    end
end

dofile(path .. '/obsidianmese_chest.lua')

dofile(path .. '/crafting.lua')
