fx_version 'cerulean'
game 'gta5'

author 'EpicCat'
description 'Carkey Script'
version '1.0.0'
repository 'https://github.com/CptnCat/cat_carkeys'

lua54 'yes'

shared_scripts {
	'@ox_lib/init.lua',
	'@es_extended/imports.lua',
    'config.lua'
}

client_scripts {
	'@es_extended/locale.lua',
    'locales/*.lua',
    'client/function.lua',
    'client/main.lua',
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'@es_extended/locale.lua',
    'locales/*.lua',
	'server/main.lua',
}

dependencies {
    'es_extended',
    'esx_menu_default',
    'ox_lib'
}