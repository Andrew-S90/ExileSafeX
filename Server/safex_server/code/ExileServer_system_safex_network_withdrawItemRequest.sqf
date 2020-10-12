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
_itemClassName = _parameters select 0;
_containerType = _parameters select 1;
_containerNetID = _parameters select 2;

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
	_vehicleObject = objNull;
	if (_containerType isEqualTo 2) then 
	{
		_vehicleObject = objectFromNetID(_containerNetID);
	};
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
	_hasSafeXPlayer = format["hasSafeXPlayer:%1", _targetUID] call ExileServer_system_database_query_selectSingleField;
	
	if(_hasSafeXPlayer) then {
		_data = format["loadSafeX:%1", _targetUID] call ExileServer_system_database_query_selectSingle;
		_safeXData = (_data select 0);
		_marXetData = (_data select 1);
	} else {
		format["createSafeX:%1:%2", [], _targetUID] call ExileServer_system_database_query_fireAndForget;
		format["createSafeXMarXet:%1:%2", [], _targetUID] call ExileServer_system_database_query_fireAndForget;	
	};
	
	_index = [_safeXData,_itemClassName] call ExileServer_util_searchArray;
	
	if(_index != -1) then 
	{
		_current = _safeXData select _index;
		_amt = (_current select 1)-1;
		if(_amt <= 0) then {
			_safeXData deleteAt _index;
		} else {
			_safeXData set [_index, [(_current select 0),_amt]];
		};
		
		format["setSafeXStorage:%1:%2", _safeXData, _targetUID] call ExileServer_system_database_query_fireAndForget;
	} else {
	
		_index = [_marXetData,_itemClassName] call ExileServer_util_searchArray;
		
		if(_index != -1) then 
		{
			_current = _marXetData select _index;
			_amt = (_current select 1)-1;
			if(_amt <= 0) then {
				_marXetData deleteAt _index;
			} else {
				_marXetData set [_index, [(_current select 0),_amt]];
			};
			
			format["setMarXetStorage:%1:%2", _marXetData, _targetUID] call ExileServer_system_database_query_fireAndForget;
		};
	};
	
	if(_index == -1) then 
	{
		throw -1;
	};
	
	[_sessionID, "withdrawItemResponse", [0, _itemClassName, _containerType, _containerNetID, _safeXData, _marXetData]] call ExileServer_system_network_send_to;
	
	_logging = getNumber(configFile >> "CfgSettings" >> "Logging" >> "traderLogging");
	_itemLogging = getNumber(configFile >> "CfgSafeX" >> "Logging" >> "itemLogging");
	if (_logging isEqualTo 1 || _itemLogging  isEqualTo 1) then
	{
		_traderLog = format ["PLAYER: ( %1 ) %2 WITHDREW ITEM %3 FROM SAFEX",getPlayerUID _playerObject,_playerObject,_itemClassName];
		"extDB2" callExtension format["1:TRADING:%1",_traderLog];
	};
	if !(_vehicleObject isEqualTo objNull) then
	{
		_vehicleObject call ExileServer_object_vehicle_database_update;
	}
	else 
	{
		_playerObject call ExileServer_object_player_database_update;
	};
}
catch 
{
	_responseCode = _exception;
	[_sessionID, "withdrawItemResponse", [_responseCode, "", 0, "",[],[]]] call ExileServer_system_network_send_to;
};	
_playerObject setVariable ["ExileMutex",false];
true