CreateThread(function()
    local textUIactive = false
    while true do
        local shouldDisplay = false
        local playerCoords = GetEntityCoords(cache.ped)
        local maxDistance = 2.0

        for i, elevatorGroup in pairs(Config.Elevators) do
            for _, floorInfo in ipairs(elevatorGroup) do
                local distance = #(playerCoords - floorInfo.coords)
                if distance <= maxDistance then
                    lib.showTextUI("[E] Aufzug")
                    textUIactive = true
                    shouldDisplay = true
                    break -- No need to check other floors if one is found
                end
            end
        end

        -- Wait before checking again, e.g., every second
        Wait(500)
        if textUIactive and not shouldDisplay then
            lib.hideTextUI()
        end
    end
end)

for i, elevator in pairs(Config.Elevators) do
    local elevatorOptions = {}
    for _, floor in ipairs(elevator) do
        table.insert(elevatorOptions, {
            title = floor.display,
            onSelect = function()
                DoScreenFadeOut(250)
                Wait(200)
                SetEntityCoords(cache.ped, floor.coords.x, floor.coords.y, floor.coords.z-0.85)
                Wait(200)
                DoScreenFadeIn(250)
            end
        })
        
    end
    lib.registerContext({
        id = 'snov_elevators_'..i,
        title = 'Fahrstuhl',
        options = elevatorOptions,
    })
end

RegisterKeyMapping('-sv-interact-elevators', 'Interact [E]', 'keyboard', 'e')

RegisterCommand('-sv-interact-elevators', function()
    local coords = GetEntityCoords(cache.ped)
    local closestPoint = findClosestElevatorPoint()

    if not closestPoint then return end

    -- Determine the closest interaction point within 2.0 distance
    if closestPoint.distance <= 2.0 and not IsPauseMenuActive() then
        lib.showContext('snov_elevators_'..closestPoint.elevator)
    end
end, false)

function findClosestElevatorPoint()
    local playerCoords = GetEntityCoords(cache.ped)
    local closestDistance = math.huge
    local closestPoint = nil

    for i, elevatorGroup in pairs(Config.Elevators) do
        for _, floorInfo in ipairs(elevatorGroup) do
            local distance = #(playerCoords - floorInfo.coords)
            if distance < closestDistance then
                closestDistance = distance
                closestPoint = {
                    distance = distance,
                    elevator = i,
                }
            end
        end
    end

    return closestPoint
end