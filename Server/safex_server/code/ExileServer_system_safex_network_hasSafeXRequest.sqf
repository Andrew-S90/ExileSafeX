 /*
 *
 * Author: Andrew_S90
 *
 * This work is protected by Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0). 
 *
 */
 
private ["_sessionID", "_playerObject", "_safeXData", "_hasSafeXPlayer", "_responseCode", "_targetUID"];
_sessionID = _this select 0;

try 
{
	_playerObject = _sessionID call ExileServer_system_session_getPlayerObject;
	if (isNull _playerObject) then
	{
		throw 1;
	};
	_targetUID = getPlayerUID _playerObject;
	if (isNil "_targetUID") then 
	{
		throw 2;
	};
	if (_targetUID isEqualTo "") then 
	{
		throw 3;
	};
	
	_safeXData = [];
	_marXetData = [];
	_hasSafeXPlayer = format["hasSafeXPlayer:%1", _targetUID] call ExileServer_system_database_query_selectSingleField;
	
	if(_hasSafeXPlayer) then {
		_data = format["loadSafeX:%1", _targetUID] call ExileServer_system_database_query_selectSingle;
		_safeXData = (_data select 0);
		_marXetData = (_data select 1);
	} else {
		format["createSafeXMarXet:%1:%2:%3", _targetUID, [], []] call ExileServer_system_database_query_fireAndForget;	
	};
	
	[_sessionID, "hasSafeXResponse", [0,_safeXData, _marXetData]] call ExileServer_system_network_send_to;
}
catch
{
	_responseCode = _exception;
	[_sessionID, "hasSafeXResponse", [_responseCode, [], []]] call ExileServer_system_network_send_to;
};
true