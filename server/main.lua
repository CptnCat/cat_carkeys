if Config.DeleteTempKeysAfterScriptRestart == true then
    AddEventHandler('onResourceStart', function(resourceName)
        if (GetCurrentResourceName() ~= resourceName) then
            return
        end
        MySQL.Sync.execute("DELETE FROM `temp_vehicle_keys`")
    end)
end

ESX.RegisterServerCallback('cat_carkeys:getPlayersKeys', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
	local identifier = xPlayer.getIdentifier()

    local response = MySQL.query.await('SELECT * FROM `temp_vehicle_keys` WHERE `identifier` = ?', {
        identifier,
    })

    local response2 = MySQL.query.await('SELECT * FROM `owned_vehicles` WHERE `owner` = ?', {
        identifier,
    })

    if response2 and next(response2) then
        for k, resp in ipairs(response2) do
            table.insert(response, {plate = resp.plate, typelabel = TranslateCap('owned_field'), type = 'own'})
        end
    end

    if response and next(response) then
        cb(response)
    end
end)

ESX.RegisterServerCallback('cat_carkeys:checkIfPlayerHasKey', function(source, cb, plate)
    local xPlayer = ESX.GetPlayerFromId(source)
	local identifier = xPlayer.getIdentifier()

    local response = MySQL.query.await('SELECT * FROM `temp_vehicle_keys` WHERE `identifier` = ? AND `plate` = ?', {
        identifier,
        plate
    })

    local response2 = MySQL.query.await('SELECT * FROM `owned_vehicles` WHERE `owner` = ? AND `plate` = ?', {
        identifier,
        plate
    })

    if response and next(response) or response2 and next(response2) then
        cb(true)
    else
        cb(false)
    end
end)

if Config.AllowStealingKey == true then
    RegisterNetEvent('cat_carkeys:createKey')
    AddEventHandler('cat_carkeys:createKey', function(plate)
        local xPlayer = ESX.GetPlayerFromId(source)
        local identifier = xPlayer.getIdentifier()

        MySQL.Sync.execute("INSERT INTO `temp_vehicle_keys`(`identifier`, `plate`) VALUES (@identifier,@plate)", { 
            ['@identifier'] = identifier,
            ['@plate'] = plate,
        })
        xPlayer.showNotification(TranslateCap('received_key', plate))
    end)
end

if Config.AllowCopyKey == true then
    RegisterNetEvent('cat_carkeys:copyKey')
    AddEventHandler('cat_carkeys:copyKey', function(plate, target)
        local xPlayer = ESX.GetPlayerFromId(source)
        local xTarget = ESX.GetPlayerFromId(target)
        local identifier = xPlayer.getIdentifier()

        MySQL.Async.fetchAll('SELECT plate FROM owned_vehicles WHERE identifier = @identifier AND plate = @plate', {
            ['@identifier'] = identifier,
            ['@plate'] = plate
        }, function(result)
            if result[1] ~= nil then
                MySQL.Sync.execute("INSERT INTO `temp_vehicle_keys`(`identifier`, `plate`) VALUES (@targetid,@plate)", { 
                    ['@targetid'] = xTarget.identifier,
                    ['@plate'] = plate,
                })
                xPlayer.showNotification(TranslateCap('gave_copy_key', plate))
                xTarget.showNotification(TranslateCap('received_copy_key', plate))
            else
                xPlayer.showNotification(TranslateCap('not_owned_vehicle_copy'))
            end
        end)
    end)
end

RegisterNetEvent('cat_carkeys:deleteKey')
AddEventHandler('cat_carkeys:deleteKey', function(plate)
    local xPlayer = ESX.GetPlayerFromId(source)
	local identifier = xPlayer.getIdentifier()

    MySQL.Sync.execute("DELETE FROM `temp_vehicle_keys` WHERE identifier = @identifier AND plate = @plate", {
        ['@identifier'] = identifier,
        ['@plate'] = plate
    })
    xPlayer.showNotification(TranslateCap('key_removed', plate))
end)

if Config.VersionCheck == true then
    lib.versionCheck('CptnCat/cat_carkeys')
end
