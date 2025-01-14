spiritName = "Vital Strength of the Earth"

function doSetup(params)
    printToAll("Setting up Resilience...")
    local earth = params.spiritPanel
    if earth then
        local json = JSON.decode(earth.script_state)
        if not json.resilience then
            for _, data in pairs(json.trackEnergy) do
                data.count = math.ceil(data.count / 2)
            end
            json.resilience = true
            earth.script_state = JSON.encode(json)
            earth.setTable("trackEnergy", json.trackEnergy)
        end
    end

    local color = params.color
    for _, card in pairs(Player[color].getHandObjects(1)) do
        if card.getName() == "Rituals of Destruction" then
            local newCard = Global.call("getPowerCard", {guid="ca6b34", major=False})  -- Dark and Tangled Woods
            if newCard then
                newCard.deal(1, color)
                card.destruct()
                Global.call("giveEnergy", { color = color, energy = 1, ignoreDebt = false })
                break
            end
        end
    end
    return true
end

function onDestroy()
    local earth = Global.call("getSpirit", {name = spiritName})
    if earth then
        local json = JSON.decode(earth.script_state)
        if json.resilience then
            for i, data in pairs(json.trackEnergy) do
                data.count = data.count * 2
                if i == 2 or i == 5 then
                    -- note these indices are based on the order in script-state
                    -- which is *not* from left to right on the board itself
                    data.count = data.count - 1
                end
            end
            json.resilience = nil
            earth.script_state = JSON.encode(json)
            earth.setTable("trackEnergy", json.trackEnergy)
        end
    end
end
