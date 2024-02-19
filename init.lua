local modpath = core.get_modpath(core.get_current_modname())
dofile(modpath.."/chaos.lua")

-- Variables used throughout these functions
local TIMER_LEN = 3
local player_huds = {}
local timer = 1

-- Called when a player joins. This starts the chaos after at least one person is in the world.
local function add_player(player, last_login)

    -- Give this player a hud
    local hud = player:hud_add({
        hud_elem_type = "image",
        alignment = {x = 1, y = 1},
        text = "chaos_progress.png",
        scale = {x = -0, y = -2},
        z_index = 1000,
    })
    player_huds[player:get_player_name()] = hud
end

-- Called when a player leaves. This removes the player's hud data from player_huds.
local function remove_player(player, timed_out)
    player_huds[player:get_player_name()] = nil
end

-- Steps the timer by one second, and updates huds for all players
local function step_timer()

    -- Remove 1 second from the timer
    timer = timer + 1

    -- Update the player huds
    for pname, hud in pairs(player_huds) do
        local player = minetest.get_player_by_name(pname)
        player:hud_change(hud, "scale", {x = -((timer / TIMER_LEN)*100), y = -2})
    end

    -- If the timer has run out...
    if timer == TIMER_LEN then

        -- Choose a random chaos
        local cindex = math.random(1, #chaos.chaos)
        local chaos_to_do = chaos.chaos[cindex]
        minetest.log(chaos_to_do.msg)

        -- Loop through the players and apply the effect
        for i, player in minetest.get_connected_players() do
            chaos_to_do.func(player, TIMER_LEN)
        end

        -- Reset the timer
        timer = 1
    end

    -- Step the timer again
    minetest.after(1, step_timer)
end

-- Register callbacks
minetest.register_on_joinplayer(add_player)
minetest.register_on_leaveplayer(remove_player)
minetest.register_on_mods_loaded(step_timer)
