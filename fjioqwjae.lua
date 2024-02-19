-- The list of players currently in the game
local players = {}
local timer_hud

-- Checks if an item is in an array
local function is_in(item, array)
    for _, i in ipairs(array) do
        if i == item then
            return true
        end
    end
    return false
end

local function set_fov(player)
    player:set_fov(-49)
end

local function place_tnt(player)
    local pos = player:get_pos()
    minetest.sound_play("tnt_ignite", { pos = pos, gain = 1.0, max_hear_distance = 15 }, true)
    local ent = minetest.add_entity(pos, "mcl_tnt:tnt")
    if ent then
            ent:set_armor_groups({ immortal = 1 })
    end
    -- minetest.after(2, place_tnt, player)
end

local function change_hud(player)
    local sx = player:hud_get(timer_hud).scale.x
    player:hud_change(timer_hud, "scale", {x = sx - 10, y = -2})
    minetest.after(1, change_hud, player)
end

local function add_hud(player)
    timer_hud = player:hud_add({
        hud_elem_type = "image",
        alignment = {x = 1, y = 1},
        text = "chaos_progress.png",
        scale = {x = -10, y = -2},
        z_index = 1000,
    })
    minetest.after(1, change_hud, player)
end

-- If a player joins the game, add them to the list
local function on_join(player, last_login)
    local player_name = player:get_player_name()
    if not is_in(player_name, players) then
        table.insert(players, player_name)
    end
    for _, i in ipairs(players) do
        minetest.debug(i)
    end
    local pos = player:get_pos()
--    minetest.after(3, set_fov, player)
--    minetest.after(2, place_tnt, player)
--    playerphysics.add_physics_factor(player, "jump", "chaos", 0)
--    playerphysics.add_physics_factor(player, "speed", "chaos", 0)
--    minetest.after(3, mcl_potions.invisiblility_func, player, 0, 60)
    -- player:set_eye_offset({x=100, y=100, z=100}, {x=200,y=200,z=200}, {x=300,y=300,z=300})
    minetest.after(3, add_hud, player)
end

-- If a player leaves the game, remove them from the list
local function on_leave(player, timed_out)
    local player_name = player:get_player_name()
    for i, p in ipairs(players) do
        print(p)
        if p == player_name then
            table.remove(players, i)
            print("Removing player "..player_name)
            break
        end
    end
end

-- Register the functions
minetest.register_on_joinplayer(on_join)
minetest.register_on_leaveplayer(on_leave)
