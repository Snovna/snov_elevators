-----------------------------------------------------------
-- Version Check
-----------------------------------------------------------

function checkVersion(initial)
    PerformHttpRequest('https://raw.githubusercontent.com/Snovna/fivem_updates/main/updates.json', function(statusCode, responseText, headers)
        local resourceName = GetCurrentResourceName()
        local fxVersion = GetResourceMetadata(resourceName, 'version', 0)
        local gitResponse = json.decode(responseText)

        if statusCode ~= 200 then print('^3version check failed, response error code '..statusCode..'^0') return end
        if not gitResponse then print('^3version check failed^0') return end
        if not gitResponse[resourceName] then print('^3version check failed, did you rename this resource?^0') return end

        if fxVersion ~= gitResponse[resourceName].currentVersion then
            print('^3'..resourceName..' is outdated (your version: '..fxVersion..' - current version: '..gitResponse[resourceName].currentVersion..')^0')
            if gitResponse[resourceName].updateNotes then
                print('^3'..gitResponse[resourceName].updateNotes..'^0')
            end
            if gitResponse[resourceName].updateUrl then
                print('^3update it now from: '..gitResponse[resourceName].updateUrl..'^0')
            else
                print('^3update it now from your Keymaster^0')
            end
        else
            if not initial then return end
            print('^2'..resourceName .. ' is up to date ('..fxVersion..')^0')
        end
    end, 'GET')
end

CreateThread(function()
    Wait(15 * 1000)
    checkVersion(true)
    while true do
        Wait(30 * 60 * 1000)
        checkVersion(false)
    end
end)
