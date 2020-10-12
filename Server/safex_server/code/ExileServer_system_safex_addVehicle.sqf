 /*
 *
 * Author: Andrew_S90
 *
 * This work is protected by Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0). 
 *
 */
 
//[_requestorUID, [_classname, _id]] call ExileServer_system_safex_addVehicle;


 
private ["_playerUID", "_targetPlayerObject", "_targetSessionID", "_rewardsData", "_hasRewardsPlayer", "_targetUID", "_responseCode", "_bad"];
_parameters = _this;
_playerUID = _parameters select 0;
_vehicle = _parameters select 1;


try 
{	
	if (_playerUID isEqualTo "") then 
	{
		throw "_playerUID is an empty string!";
	};
	
	if (count _vehicle == 0) then 
	{
		throw "No vehicle info passed.";
	};
	
	_safeXData = [];
	_marXetData = [];
	_hasSafeXPlayer = format["hasSafeXPlayer:%1", _playerUID] call ExileServer_system_database_query_selectSingleField;
	
	if(_hasSafeXPlayer) then {
		_data = format["loadSafeX:%1", _playerUID] call ExileServer_system_database_query_selectSingle;
		_safeXData = (_data select 0);
		_marXetData = (_data select 1);
	} else {
		format["createSafeX:%1:%2", [], _targetUID] call ExileServer_system_database_query_fireAndForget;
		format["createSafeXMarXet:%1:%2", [], _targetUID] call ExileServer_system_database_query_fireAndForget;	
	};
	
	_marXetData pushBack [_vehicle select 0, _vehicle select 1];

	format["setMarXetStorage:%1:%2", _marXetData, _playerUID] call ExileServer_system_database_query_fireAndForget;
	
	_targetPlayerObject = _playerUID call ExileClient_util_player_objectFromPlayerUID;
	if (isNull _targetPlayerObject) then
	{
		throw "Player is not online";
	};
	
	_targetSessionID = _targetPlayerObject getVariable ["ExileSessionID", -1];
	
	[_targetSessionID, "updateMarXetResponse", [0,_marXetData]] call ExileServer_system_network_send_to;
}
catch
{
	_responseCode = _exception;
	diag_log format["ExileServer_system_safex_updatePlayer player uid: %1 is not online error: %2",_playerUID,_responseCode]; 
};
true