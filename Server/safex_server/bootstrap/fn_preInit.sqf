 /*
 *
 * Author: Andrew_S90
 *
 * This work is protected by Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0). 
 *
 */
 
private ['_code', '_function', '_file', '_fileContent'];

{
    _code = '';
    _function = _x select 0;
    _file = _x select 1;

    _fileContent = preprocessFileLineNumbers _file;

    _code = compileFinal _fileContent;                    

    missionNamespace setVariable [_function, _code];
}
forEach 
[
	['ExileServer_object_vehicle_safeXSpawn', 'safex_server\code\ExileServer_object_vehicle_safeXSpawn.sqf'],
	['ExileServer_system_safex_addItem', 'safex_server\code\ExileServer_system_safex_addItem.sqf'],
	['ExileServer_system_safex_addVehicle', 'safex_server\code\ExileServer_system_safex_addVehicle.sqf'],
	['ExileServer_system_safex_network_depositItemRequest', 'safex_server\code\ExileServer_system_safex_network_depositItemRequest.sqf'],
	['ExileServer_system_safex_network_hasSafeXRequest','safex_server\code\ExileServer_system_safex_network_hasSafeXRequest.sqf'],
	['ExileServer_system_safex_network_withdrawItemRequest', 'safex_server\code\ExileServer_system_safex_network_withdrawItemRequest.sqf'],
	['ExileServer_system_safex_network_withdrawVehicleRequest', 'safex_server\code\ExileServer_system_safex_network_withdrawVehicleRequest.sqf'],
	['ExileServer_util_searchArray','safex_server\code\ExileServer_util_searchArray.sqf']
];

diag_log "SAFEX SERVER - Loaded.";

true