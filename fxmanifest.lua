fx_version 'adamant'
games { 'gta5' }

ui_page 'html/ui.html'

author 'Henk W'
description 'Witwas script voor AMRP'

version '1.1.4'
lua54 'yes'


client_scripts {

	'@es_extended/locale.lua',
	'config.lua',
	'cl_laundry.lua',
	'notif.lua'
}

server_scripts {

	'@es_extended/locale.lua',
	'@mysql-async/lib/MySQL.lua',
	'config.lua',
	'sv_laundry.lua'
}

files {
	'html/style.css',
	'html/app.js',
	'html/ui.html',
}

escrow_ignore {
	'config.lua',
	'fxmanifest.lua'
}

shared_script '@es_extended/imports.lua'