 /*
 *
 * Author: Andrew_S90
 *
 * This work is protected by Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0). 
 *
 */
 
// [getPlayerUID(_playerObject), [_classname]] call ExileServer_system_safex_addItem;

 
private ["_playerUID", "_targetPlayerObject", "_targetSessionID", "_rewardsData", "_hasRewardsPlayer", "_targetUID", "_responseCode", "_bad"];
_parameters = _this;
_playerUID = _parameters select 0;
_playerMarXet = _parameters select 1;


try 
{	
	if (_playerUID isEqualTo "") then 
	{
		throw "_playerUID is an empty string!";
	};
	
	if (count _playerMarXet == 0) then 
	{
		throw "No item info passed.";
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
	
	{	
		if(typeName _x == "ARRAY") then 
		{
			_classname = (_x select 0);

			if(count _marXetData > 0) then 
			{
				_index = [_marXetData,_classname] call ExileServer_util_searchArray;
				if(_index != -1) then 
				{
					_current = _marXetData select _index;
					_amt = (_current select 1)+(_x select 1);
					_marXetData set [_index, [(_current select 0),_amt]];
				} 
				else 
				{
					_marXetData pushBack _x;
				};
			} 
			else 
			{
				_marXetData pushBack _x;
			};
		} 
		else 
		{
			_classname = _x;
			if(count _marXetData > 0) then 
			{
				_index = [_marXetData,_classname] call ExileServer_util_searchArray;
				if(_index != -1) then 
				{
					_current = _marXetData select _index;
					_amt = (_current select 1)+1;
					_marXetData set [_index, [(_current select 0),_amt]];
				} 
				else 
				{
					_marXetData pushBack [_x,1];
				};
			} 
			else 
			{
				_marXetData pushBack [_x,1];
			};
		};
	} forEach _playerMarXet;

	format["setMarXetStorage:%1:%2", _marXetData, _playerUID] call ExileServer_system_database_query_fireAndForget;
	
	_targetPlayerObject = _playerUID call ExileClient_util_player_objectFromPlayerUID;
	if (isNull _targetPlayerObject) then
	{
		throw "Player is not online";
	};
	_logging = getNumber(configFile >> "CfgSettings" >> "Logging" >> "traderLogging");
	_itemLogging = getNumber(configFile >> "CfgSafeX" >> "Logging" >> "itemLogging");
	if (_logging isEqualTo 1 || _itemLogging  isEqualTo 1) then
	{
		_traderLog = format ["PLAYER: ( %1 ) HAD MARXET ITEM %2 DEPOSITED TO SAFEX",getPlayerUID _targetPlayerObject,_playerMarXet];
		"extDB2" callExtension format["1:TRADING:%1",_traderLog];
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