fx_version 'cerulean'
game 'gta5'

shared_scripts {
    "shared/*lua"
}

client_scripts {
    "RageUI/RMenu.lua",
    "RageUI/menu/RageUI.lua",
    "RageUI/menu/Menu.lua",
    "RageUI/menu/MenuController.lua",
    "RageUI/components/*.lua",
    "RageUI/menu/**/*.lua",
    "client/*lua"
}

server_scripts {
    "server/*lua",
    '@mysql-async/lib/MySQL.lua'
}

files {
    'nui/index.html',
    'nui/style.css',
    'nui/script.js'
}

ui_page 'nui/index.html'