--                                     Licensed under                                     --
-- Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International Public License --

client_script "shared/rpc.lua"
client_script "lib.lua"

server_script "shared/rpc.lua"
server_script "lib.lua"

games { 'rdr3'}

fx_version 'adamant'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

export "CallRemoteMethod"
export "RegisterMethod"

server_export "CallRemoteMethod"
server_export "RegisterMethod"

