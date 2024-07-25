chaos = {}

-- Spawns lots of sheep at the player's location
function chaos.counting_sheep(player, duration)
    local function spawn_sheepies(pname)
        local p = minetest.get_player_by_name(pname)
        local pos = p:get_pos()
        for _ = 1,20 do
            mcl_mobs.spawn(pos, "mobs_mc:sheep")
        end
    end
    local split_duration = math.floor(duration / 3)
    local pname = player:get_player_name()
    spawn_sheepies(pname)
    minetest.after(split_duration, spawn_sheepies, pname)
    minetest.after(2*split_duration, spawn_sheepies, pname)
    minetest.after(3*split_duration, spawn_sheepies, pname)
end

-- Invert player gravity
function chaos.falling_up(player, duration)
    playerphysics.add_physics_factor(player, "gravity", "chaos", -0.1)
    local function remove_falling_up(pname)
        local p = minetest.get_player_by_name(pname)
        playerphysics.remove_physics_factor(player, "gravity", "chaos")
    end
    minetest.after(duration, remove_falling_up, player:get_player_name())
end

-- Spawn some skeletons near the player
function chaos.feel_it_in_your_bones(player, duration)
    local pos = player:get_pos()
    for _ = 1,math.random(1, 5) do
        mcl_mobs.spawn(pos, "mobs_mc:skeleton")
    end
end

-- Freeze the player in the current velocity
function chaos.inertia(player, duration)
    playerphysics.add_physics_factor(player, "speed", "chaos", 0)
    playerphysics.add_physics_factor(player, "jump", "chaos", 0)
    local function remove_inertia(pname)
        local p = minetest.get_player_by_name(pname)
        playerphysics.remove_physics_factor(player, "speed", "chaos")
        playerphysics.remove_physics_factor(player, "jump", "chaos")
    end
    minetest.after(duration, remove_inertia, player:get_player_name())
end

-- Block the player's screen with a phone screen shape
function chaos.mobile_games_rock(player, duration)

    -- Create a new hud element
    local hud = player:hud_add({
        hud_elem_type = "image",
        alignment = {x = 1, y = 1},
        text = "chaos_phone_screen.png",
        scale = {x = -100, y = -100},
        z_index = 1000,
    })

    -- Make sure the hud element is removed after the duration is up
    local function remove_mobile_games_rock(pname, hud)
        local player = minetest.get_player_by_name(pname)
        player:hud_remove(hud)
    end
    minetest.after(duration, remove_mobile_games_rock, player:get_player_name(), hud)
end

-- Apply every potion's maximum effect to the player
function chaos.overdose(player, duration)
    mcl_potions.healing_func(player, 20)
    mcl_potions.swiftness_func(player, 5, duration)
    mcl_potions.leaping_func(player, 5, duration)
    mcl_potions.weakness_func(player, 5, duration)
    mcl_potions.strength_func(player, 5, duration)
    mcl_potions.withering_func(player, 5, duration)
    mcl_potions.poison_func(player, 5, duration)
    mcl_potions.regeneration_func(player, 5, duration)
    mcl_potions.invisiblility_func(player, 5, duration)
    mcl_potions.water_breathing_func(player, 5, duration)
    mcl_potions.fire_resistance_func(player, 5, duration)
    mcl_potions.night_vision_func(player, 5, duration)
    mcl_potions.bad_omen_func(player, 5, duration)
end

-- Strike the player with lightning
function chaos.strike(player, duration)
    local pos = player:get_pos()
    for i = 1, 5 do
        local new_pos = {
            x = math.random(-9, 9) + pos.x,
            y = pos.y,
            z = math.random(-9, 9) + pos.z,
        }
        mcl_lightning.strike(new_pos)
    end
end

-- Spawn TNT at the player's position at regular intervals
function chaos.tnt_tracker(player, duration)

    -- Create a timer to make sure this effect is disabled after the duration is up
    local timer = duration

    -- The function that places TNT
    local function place_tnt(pname)
        local p = minetest.get_player_by_name(pname)
        local pos = p:get_pos()
        minetest.sound_play("tnt_ignite", {pos = pos, gain = 1.0, max_hear_distance = 15}, true)
        local ent = minetest.add_entity(pos, "mcl_tnt:tnt")
        if ent then
            ent:set_armor_groups({immortal = 1})
        end
        timer = timer - 1
        if timer > 0 then
            minetest.after(1, place_tnt, pname)
        end
    end

    -- Start placing TNT
    place_tnt(player:get_player_name())
end

-- Table containing all the chaos functions
chaos.chaos = {} -- table
local chaos_counting_sheep = minetest.settings:get_bool("chaos_counting_sheep", true)
local chaos_falling_up = minetest.settings:get_bool("chaos_falling_up", true)
local chaos_feel_it_in_your_bones = minetest.settings:get_bool("chaos_feel_it_in_your_bones", true)
local chaos_inertia = minetest.settings:get_bool("chaos_inertia", true)
local chaos_mobile_games_rock = minetest.settings:get_bool("chaos_mobile_games_rock", true)
local chaos_overdose = minetest.settings:get_bool("chaos_overdose", true)
local chaos_strike = minetest.settings:get_bool("chaos_strike", true)
local chaos_tnt_tracker = minetest.settings:get_bool("chaos_tnt_tracker", true)

if chaos_counting_sheep then
    table.insert(chaos.chaos, {msg = "Counting sheep!", func = chaos.counting_sheep})
end
if chaos_falling_up then
    table.insert(chaos.chaos, {msg = "Falling Up", func = chaos.falling_up})
end
if chaos_feel_it_in_your_bones then
    table.insert(chaos.chaos, {msg = "Feel it in your bones.", func = chaos.feel_it_in_your_bones})
end
if chaos_inertia then
    table.insert(chaos.chaos, {msg = "Inertia: fundamental physics!", func = chaos.inertia})
end
if chaos_mobile_games_rock then
    table.insert(chaos.chaos, {msg = "Mobile games rock!", func = chaos.mobile_games_rock})
end
if chaos_overdose then
    table.insert(chaos.chaos, {msg = "Potion overdose!", func = chaos.overdose})
end
if chaos_strike then
    table.insert(chaos.chaos, {msg = "Strike!", func = chaos.strike})
end
if chaos_tnt_tracker then
    table.insert(chaos.chaos, {msg = "TNT Tracker.", func = chaos.tnt_tracker})
end
