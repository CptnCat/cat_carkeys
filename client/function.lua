local function toggleLights(vehicle)
    SetVehicleLights(vehicle, 2)
    Wait(150)
    SetVehicleLights(vehicle, 0)
    Wait(150)
    SetVehicleLights(vehicle, 2)
    Wait(150)
    SetVehicleLights(vehicle, 0)
end

local function shutDoors(vehicle)
    SetVehicleDoorShut(vehicle, 0, false)
    SetVehicleDoorShut(vehicle, 1, false)
    SetVehicleDoorShut(vehicle, 2, false)
    SetVehicleDoorShut(vehicle, 3, false)
end

function useCarkey()
    local coords = GetEntityCoords(PlayerPedId())
    local closestVehicle, closestDistance = ESX.Game.GetClosestVehicle(coords)

    if closestVehicle ~= -1 and closestDistance <= Config.MaxVehicleDistance then
        local plate = ESX.Math.Trim(GetVehicleNumberPlateText(closestVehicle))

        ESX.TriggerServerCallback('cat_carkeys:checkIfPlayerHasKey', function(haskey)
            if haskey then
                local lockstatus = GetVehicleDoorLockStatus(closestVehicle)

                if lockstatus ~= nil then
                    lockstatus = GetVehicleDoorLockStatus(closestVehicle)

                    lib.requestAnimDict(Config.Animation.dict)
                    TaskPlayAnim(PlayerPedId(), Config.Animation.dict, Config.Animation.anim, 8.0, 8.0, -1, 48, 1, false, false, false)

                    if lockstatus == 0 or lockstatus == 1 then
                        PlaySoundFrontend(-1, "Remote_Control_Fob", "PI_Menu_Sounds", 1)

                        toggleLights(closestVehicle)
                        shutDoors(closestVehicle)
                        SetVehicleDoorsLocked(closestVehicle, 2)
                        SetVehicleDoorsLockedForAllPlayers(closestVehicle, true)
                        ESX.ShowNotification(TranslateCap('vehicle_locked'))
                    elseif lockstatus == 2 then
                        PlaySoundFrontend(-1, "Remote_Control_Fob", "PI_Menu_Sounds", 1)

                        toggleLights(closestVehicle)

                        SetVehicleDoorsLocked(closestVehicle, 1)
                        SetVehicleDoorsLockedForAllPlayers(closestVehicle, false)
                        ESX.ShowNotification(TranslateCap('vehicle_unlocked'))
                    end
                end
            else
                ESX.ShowNotification(TranslateCap('no_keys'))
            end
        end, plate)
    else
        ESX.ShowNotification(TranslateCap('no_vehicles_neraby'))
    end
end

function OpenCarKeysMenu()
    ESX.UI.Menu.CloseAll()
    local elements = {}

    table.insert(elements, {label = TranslateCap('carkey_manage'), value = 'manage'})

    if Config.AllowStealingKey == true then
        table.insert(elements, {label = TranslateCap('steal_keys'), value = 'steal'})
    end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'Carkeys_Home', {
        title = TranslateCap('carkeymenu_header'),
        algin = 'top-left',
        elements = elements,
    }, function(data, menu)
        if data.current.value == 'manage' then
            ESX.TriggerServerCallback('cat_carkeys:getPlayersKeys', function(keys)
                local elements = {}

                for k, key in ipairs(keys) do
                    if key.type ~= 'own' then
                        table.insert(elements, {label = '#'..k..' ['.. key.plate..']', plate = key.plate, type = 'tempkey'})
                    else
                        table.insert(elements, {label = '#'..k..' ['.. key.plate..']-'..key.typelabel, plate = key.plate, type = key.type})
                    end
                end

                ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'Carkeys_Manage', {
                    title = TranslateCap('carkey_manage_header'),
                    algin = 'top-left',
                    elements = elements
                }, function(data2, menu)
                    OpenKeyActionMenu(data2.current.plate, data2.current.type)
                end, function(data2, menu)
                    menu.close()
                end)
            end)
        elseif data.current.value == 'steal' then
            if IsPedInAnyVehicle(PlayerPedId(), false) then
                local currentVehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                local plate = ESX.Math.Trim(GetVehicleNumberPlateText(currentVehicle))

                ESX.TriggerServerCallback('cat_carkeys:checkIfPlayerHasKey', function(hasAlready)
                    if GetPedInVehicleSeat(currentVehicle, -1) == PlayerPedId() then
                        if hasAlready == false then
                            TriggerServerEvent('cat_carkeys:createKey', plate)
                        else
                            ESX.ShowNotification(TranslateCap('already_own_key'))
                        end
                    else
                        ESX.ShowNotification(TranslateCap('wrong_seat'))
                    end
                end, plate)
            else
                ESX.ShowNotification(TranslateCap('no_vehicle_sit'))
            end
        end
    end, function(data, menu)
        menu.close()
    end)
end

function OpenKeyActionMenu(plate, type)
    local elements = {}
    local inserted = false

    if type == 'own' then
        if Config.AllowCopyKey == true then
            table.insert(elements, {label = TranslateCap('copy_key'), value = 'copyKey'})
            inserted = true
        end
    else
        table.insert(elements, {label = TranslateCap('delete_key'), value = 'deleteKey'})
        inserted = true
    end

    if inserted then
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'Carkeys_Manage_Detail', {
            title = TranslateCap('carkey_manage_header'),
            algin = 'top-left',
            elements = elements
        }, function(data, menu)
                if data.current.value == 'copyKey' then
                    local target, distance = ESX.Game.GetClosestPlayer()
                    if target == -1 or distance > 1.2 then
                        ESX.ShowNotification(TranslateCap('no_person_nearby'))
                    else
                        if type ~= 'own' then
                            ESX.ShowNotification(TranslateCap('not_owned_vehicle_copy'))
                        else
                            TriggerServerEvent('cat_carkeys:copyKey', plate, GetPlayerServerId(target))
                        end
                    end
                elseif data.current.value == 'deleteKey' then
                    TriggerServerEvent('cat_carkeys:deleteKey', plate)
                    ESX.UI.Menu.CloseAll()
                end
        end, function(data, menu)
            menu.close()
        end)
    end
end
