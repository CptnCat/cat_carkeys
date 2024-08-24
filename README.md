# 🤖 Discord
If you need assistance with the script, join my discord and I will help you. Please report any bugs on my discord.
[Discord](https://discord.gg/wPCTtQP7UT)

# ✍️ Description
This FiveM script is a complete carlock system with a wide range of features and extensive configurable settings.

# ⭐ Features
- Steal keys from other vehicles.
- Grant a key to another player for your owned vehicle.
- Players can throw away a stolen key (configurable).
- Configure whether stolen keys reset after a script restart.
- Lock/unlock your vehicle (integrated carlock system).
- Lock/unlock spam protection.
- Lock/unlock sounds (as GTA sounds).
- Numerous configurable settings available in the `config.lua`.

# 📹 Preview
Click [HERE](https://streamable.com/8h77ce) to watch the preview.

# 💻 How to install?
- Download the script below
- Add the unziped folder **cat_carkeys** to your resources folder.
- Execute `cat_carkeys.sql` to your database.
- Add `start cat_carkeys` to your **server.cfg**.
- Restart your server.

# 💾 Database
For the script to work, you have to insert the following SQL into your database.
```
CREATE TABLE IF NOT EXISTS `temp_vehicle_keys` (
  `identifier` varchar(255) DEFAULT NULL,
  `plate` varchar(12) NOT NULL,
  PRIMARY KEY (`plate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
```

## 🔗 Dependencies
- [es_extended](https://github.com/esx-framework/esx_core/releases)
- esx_menu_default
- [ox_lib](https://github.com/overextended/ox_lib)
