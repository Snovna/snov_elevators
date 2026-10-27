ESX = exports['es_extended']:getSharedObject()
local playerJob = nil
local playerGrade = 0

AddEventHandler('onClientResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    while ESX.GetPlayerData().job == nil do
		Wait(100)
	end
    playerJob = ESX.GetPlayerData().job.name
	playerGrade = ESX.GetPlayerData().job.grade
end)

RegisterNetEvent('esx:playerLoaded', function()
    while ESX.GetPlayerData().job == nil do
		Wait(100)
	end
    playerJob = ESX.GetPlayerData().job.name
	playerGrade = ESX.GetPlayerData().job.grade
end)

RegisterNetEvent('esx:setJob', function(job, lastJob)
    playerJob = job.name
	playerGrade = job.grade
end)

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

local function isJobAllowed(jobs)
    return jobs == nil or lib.table.contains(jobs, playerJob)
end

local function openElevatorMenu(elevatorName)
    local elevatorOptions = {}
    for _, floor in ipairs(Config.Elevators[elevatorName]) do
        local canExit = isJobAllowed(floor.exitJobs)
        table.insert(elevatorOptions, {
            title = floor.display,
            disabled = not canExit,
            description = not canExit and 'Kein Zugang' or nil,
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
        id = 'snov_elevators_'..elevatorName,
        title = 'Fahrstuhl',
        options = elevatorOptions,
    })
    lib.showContext('snov_elevators_'..elevatorName)
end

RegisterKeyMapping('-sv-interact-elevators', 'Interact [E]', 'keyboard', 'e')

RegisterCommand('-sv-interact-elevators', function()
    local coords = GetEntityCoords(cache.ped)
    local closestPoint = findClosestElevatorPoint()

    if not closestPoint then return end

    -- Determine the closest interaction point within 2.0 distance
    if closestPoint.distance <= 2.0 and not IsPauseMenuActive() then
        if Config.Elevators[closestPoint.elevator].locked then
            lib.notify({
                title = 'Fahrstuhl',
                description = 'Dieser Fahrstuhl ist außer Betrieb.',
                type = 'error'
            })
        elseif isJobAllowed(closestPoint.allowedJobs) then
            openElevatorMenu(closestPoint.elevator)
        else
            lib.notify({
                title = 'Fahrstuhl',
                description = 'Du kannst diesen Fahrstuhl nicht benutzen.',
                type = 'error'
            })
        end
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
                    allowedJobs = floorInfo.allowedJobs,
                }
            end
        end
    end

    return closestPoint
end