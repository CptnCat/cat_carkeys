local secondsRemaining = 0

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if secondsRemaining > 0 then
            Citizen.Wait(1000)
            secondsRemaining = secondsRemaining - 1
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustPressed(1, 311) then
            if secondsRemaining == 0 then
                secondsRemaining = Config.DelaySeconds
                useCarkey()
            end
        elseif IsControlJustPressed(1, 303) then
            OpenCarKeysMenu()
        end
    end
end)
