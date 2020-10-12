 /*
 *
 * Author: Andrew_S90
 *
 * This work is protected by Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0). 
 *
 */
 
 
private ["_sessionID", "_parameters", "_classname", "_playerObject", "_targetUID", "_safeXData", "_hasSafeXPlayer", "_index", "_current", "_amt", "_logging", "_itemLogging", "_traderLog", "_responseCode"];
_sessionID = _this select 0;
_parameters = _this select 1;
_classname = _parameters select 0;

try 
{	
	_playerObject = _sessionID call ExileServer_system_session_getPlayerObject;
	_targetUID = getPlayerUID _playerObject;
	if (_targetUID isEqualTo "") then 
	{
		throw 1;
	};
	if (_classname isEqualTo "") then 
	{
		throw 2;
	};
	_playerObject = _targetUID call ExileClient_util_player_objectFromPlayerUID;
	if (isNull _playerObject) then
	{
		throw 3;
	};
	
	_safeXData = [];
	_hasSafeXPlayer = format["hasSafeXPlayer:%1", _targetUID] call ExileServer_system_database_query_selectSingleField;
	
	if(_hasSafeXPlayer) then {
		_data = format["loadSafeX:%1", _targetUID] call ExileServer_system_database_query_selectSingle;
		_safeXData = (_data select 0);
	} else {
		format["createSafeX:%1:%2", [], _targetUID] call ExileServer_system_database_query_fireAndForget;
		format["createSafeXMarXet:%1:%2", [], _targetUID] call ExileServer_system_database_query_fireAndForget;
	};
	
	if(count _safeXData > 0) then {
		_index = [_safeXData,_classname] call ExileServer_util_searchArray;
		if(_index != -1) then {
			_current = _safeXData select _index;
			_amt = (_current select 1)+1; 
			_safeXData set [_index, [(_current select 0),_amt]];
		} else {
			_safeXData pushBack [_classname,1];
		};
	} else {
		_safeXData pushBack [_classname,1];
	};
	
	[_sessionID, "depositItemResponse", [0,_safeXData]] call ExileServer_system_network_send_to;
	
	_logging = getNumber(configFile >> "CfgSettings" >> "Logging" >> "traderLogging");
	_itemLogging = getNumber(configFile >> "CfgSafeX" >> "Logging" >> "itemLogging");
	if (_logging isEqualTo 1 || _itemLogging  isEqualTo 1) then
	{
		_traderLog = format ["PLAYER: ( %1 ) %2 DEPOSITED ITEM %3 TO SAFEX",getPlayerUID _playerObject,_playerObject,_classname];
		"extDB2" callExtension format["1:TRADING:%1",_traderLog];
	};
	
	format["setSafeXStorage:%1:%2", _safeXData, _targetUID] call ExileServer_system_database_query_fireAndForget;
}
catch
{
	_responseCode = _exception;
	[_sessionID, "depositItemResponse", [_responseCode, []]] call ExileServer_system_network_send_to;
};
true