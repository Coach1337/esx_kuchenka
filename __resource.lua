resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937' 


description 'esx_kuchenka'


server_scripts {


    '@es_extended/locale.lua',

    'server/server.lua',

    'config.lua' 
}

client_scripts {


    '@es_extended/locale.lua',

    'config.lua',

    'client/main.lua'
}

