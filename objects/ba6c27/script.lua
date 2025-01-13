-- Replace original spirits with patched content on load

TRASH_TARGET = Vector(105.3, 1.2, 7.6)

function onLoad()
    for _, object_table in ipairs(self.getObjects()) do
        replaceAsset(object_table)
    end
end

function replaceAsset(object_table)
    local target_name = object_table.name
    local target_bag = getObjectFromGUID(object_table.gm_notes)
    if target_bag == nil then
        printToAll("Unable to find replacement target " .. target_bag .. " for " .. target_name,
                   Color.Red)
        return
    end

    local drop_location = target_bag.getPosition() + Vector(0, 2, 0)
    local replaced_object = nil
    for _, object in ipairs(target_bag.getObjects()) do
        if object.name == target_name then
            replaced_object = target_bag.takeObject({
                    position = TRASH_TARGET, rotation = Vector(0, 180, 180), guid = object.guid })
            -- TODO: Delete these afterward?
            break
        end
    end
    if replaced_object == nil then
        printToAll("Unable to find replacement target for " .. target_name .. " in " .. target_bag)
    end

    local replacement = self.takeObject({
            position = drop_location, rotation = Vector(0, 180, 180), guid = object_table.guid })
    if replacement == nil then
        printToAll("Failed to spawn object " .. guid .. "?!")
    end
end
