chaos = {}

-- Block the player's screen with a phone screen shape
function chaos.mobile_games_rock(player, duration)
end

-- Spawn TNT at the player's position at regular intervals
function chaos.tnt_tracker(player, duration)
end

-- Table containing all the chaos functions
chaos.chaos = {
    {msg = "Mobile games rock!", func = chaos.mobile_games_rock},
    {msg = "TNT Tracker...", func = chaos.tnt_tracker},
}
