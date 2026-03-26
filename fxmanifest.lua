fx_version 'cerulean'
games { 'gta5' }

version '1.1'
description 'Aufzug halt.'
author 'Snov'
lua54 'yes'

client_scripts {
    'client.lua',
}
server_scripts {
    'server.lua',
}
shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
}