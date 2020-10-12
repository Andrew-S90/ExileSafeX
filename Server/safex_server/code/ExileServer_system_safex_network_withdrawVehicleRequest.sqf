 /*
 *
 * Author: Andrew_S90
 *
 * This work is protected by Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0). 
 *
 */

private ["_sessionID", "_targetUID", "_hasSafeXPlayer", "_parameters", "_itemClassName", "_containerType", "_containerNetID", "_playerObject", "_vehicleObject", "_safeXData", "_index", "_current", "_amt", "_playerUID", "_logging", "_itemLogging", "_traderLog", "_responseCode"];
_sessionID = _this select 0;
_parameters = _this select 1;
_vehicleClassName = _parameters select 0;

try 
{
	_playerObject = _sessionID call ExileServer_system_session_getPlayerObject;
	_targetUID = getPlayerUID _playerObject;
	if (_targetUID isEqualTo "") then 
	{
		throw 5;
	};
	if (_playerObject getVariable ["ExileMutex",false]) then
	{
		throw 12;
	};
	_playerObject setVariable ["ExileMutex",true];

	if (isNull _playerObject) then
	{
		throw 1;
	};
	if !(alive _playerObject) then
	{
		throw 2;
	};
	
	_safeXData = [];
	_marXetData = [];
	_vehicleObject = objNull;
	_hasSafeXPlayer = format["hasSafeXPlayer:%1", _targetUID] call ExileServer_system_database_query_selectSingleField;
	
	if(_hasSafeXPlayer) then {
		_data = format["loadSafeX:%1", _targetUID] call ExileServer_system_database_query_selectSingle;
		_safeXData = (_data select 0);
		_marXetData = (_data select 1);
	} else {
		format["createSafeX:%1:%2", [], _targetUID] call ExileServer_system_database_query_fireAndForget;
		format["createSafeXMarXet:%1:%2", [], _targetUID] call ExileServer_system_database_query_fireAndForget;	
	};
	
	_index = [_marXetData,_vehicleClassName] call ExileServer_util_searchArray;
	
	if(_index != -1) then 
	{
		_current = _marXetData select _index;
		_marXetData deleteAt _index;
		_position = [];
		
		if (_vehicleClassName isKindOf "Ship") then 
		{
			_position = [(getPosATL _playerObject), 100, 20] call ExileClient_util_world_findWaterPosition;
		} else {
			_position = (getPos _playerObject) findEmptyPosition [10, 250, _vehicleClassName];
		};
		
		if (_position isEqualTo []) then 
		{
			throw 13;
		};
		
		_vehicleObject = [(_current select 0),(_current select 1),_position] call ExileServer_object_vehicle_safeXSpawn;
		
		format["setMarXetStorage:%1:%2", _marXetData, _targetUID] call ExileServer_system_database_query_fireAndForget;

	};

	
	if(_index == -1) then 
	{
		throw -1;
	};
	
	[_sessionID, "withdrawVehicleResponse", [0, netId _vehicleObject, _safeXData, _marXetData]] call ExileServer_system_network_send_to;
	
	_logging = getNumber(configFile >> "CfgSettings" >> "Logging" >> "traderLogging");
	_itemLogging = getNumber(configFile >> "CfgSafeX" >> "Logging" >> "itemLogging");
	if (_logging isEqualTo 1 || _itemLogging  isEqualTo 1) then
	{
		_traderLog = format ["PLAYER: ( %1 ) %2 WITHDREW VEHICLE %3 FROM SAFEX",getPlayerUID _playerObject,_playerObject,_vehicleClassName];
		"extDB2" callExtension format["1:TRADING:%1",_traderLog];
	};

	_vehicleObject call ExileServer_object_vehicle_database_update;
}
catch 
{
	_responseCode = _exception;
	[_sessionID, "withdrawVehicleResponse", [_responseCode, "", [], []]] call ExileServer_system_network_send_to;
};	
_playerObject setVariable ["ExileMutex",false];
true