Config = {}
Config.Language = 'en'
Config.VersionCheck = true

Config.AllowStealingKey = true -- Allow players to steal the key from vehicles by sitting as the driver?
Config.AllowCopyKey = true -- Allow vehicle owners to share keys for their owned vehicles?

Config.DeleteTempKeysAfterScriptRestart = true -- Remove stolen (temporary) keys after a script restart?
Config.MaxVehicleDistance = 15 -- Maximum distance to lock/unlock your vehicle

Config.DelaySeconds = 3 -- Seconds between unlocking/locking actions to prevent spam

Config.Animation = {
    dict = 'anim@mp_player_intmenu@key_fob@',
    anim = 'fob_click_fp',
}