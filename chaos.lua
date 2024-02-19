chaos = {}

-- Invert player gravity
function chaos.falling_up(player, duration)
    playerphysics.add_physics_factor(player, "gravity", "chaos", -0.5)
    local function remove_falling_up(pname)
        local p = minetest.get_player_by_name(pname)
        playerphysics.remove_physics_factor(player, "gravity", "chaos")
    end
    minetest.after(duration, remove_falling_up, player:get_player_name())
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

-- Spawn some vexes near the player
function chaos.victory_for_vexes(player, duration)
    local pos = player:get_pos()
    for _ = 1,math.random(1, 5) do
        mcl_mobs.spawn(pos, "mobs_mc:vex")
    end
end

-- Table containing all the chaos functions
chaos.chaos = {
    {msg = "Falling Up", func = chaos.falling_up},
    {msg = "Inertia: fundamental physics!", func = chaos.inertia},
    {msg = "Mobile games rock!", func = chaos.mobile_games_rock},
    {msg = "Potion overdose!", func = chaos.overdose},
    {msg = "TNT Tracker.", func = chaos.tnt_tracker},
    {msg = "Victory for vexes!", func = chaos.victory_for_vexes},
}
