/*
 * ExileClient_gui_safeXDialog_show
 *
 * Rewards Client - Made by Andrew_S90
 *
 * Derived from ExileMod Code
 *
 * Exile Mod
 * www.exilemod.com
 * © 2015 Exile Mod Team
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. 
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.
 */

private ["_dialog", "_dropdown", "_claim", "_limits", "_limit", "_index", "_nearVehicles"];
disableSerialization;

createDialog "RscExileSafeXDialog";
waitUntil { !isNull findDisplay 57347 };
_dialog = uiNameSpace getVariable ["RscExileSafeXDialog", displayNull];

_dropdown = _dialog displayCtrl 2005;
_claim = _dialog displayCtrl 2004;

_limits = getArray (MissionConfigFile >> "CfgSafeX" >> "Respect" >> "StorageLevels");
ExileClientPlayerSafeXLimit = 0;

if(ExileClientPlayerScore < 0) then 
{
	ExileClientPlayerSafeXLimit = (_limits select 0) select 1;
} else {
	reverse _limits;
	_limit = true;
	{
		if(ExileClientPlayerScore >= (_x select 0) && _limit) then
		{
			ExileClientPlayerSafeXLimit = (_x select 1);
			_limit = false;
		};
	} forEach _limits;
};

lbClear _dropdown;
_index = _dropdown lbAdd "Player";
_dropdown lbSetValue [_index, 1];
_dropdown lbSetCurSel 0;
_nearVehicles = nearestObjects [player, ["LandVehicle", "Air", "Ship"], 80];
{
	if (local _x) then
	{
		if (alive _x) then
		{
			_index = _dropdown lbAdd getText(configFile >> "CfgVehicles" >> (typeOf _x) >> "displayName");
			_dropdown lbSetData [_index, netId _x];
			_dropdown lbSetValue [_index, 2];
		};
	};
}
forEach _nearVehicles;

_dropdown ctrlEnable false;
_claim ctrlEnable false;
_dropdown ctrlCommit 0;
_claim ctrlCommit 0;

//REQUEST ONCE FROM SERVER ON OPEN - Then only update if a player has added items
if(isNil "OpenedSafeX") then {
	ExileClientPlayerSafeXCurrent = 0;
	["hasSafeXRequest"] call ExileClient_system_network_send;
	OpenedSafeX = true;
};

true call ExileClient_gui_postProcessing_toggleDialogBackgroundBlur;
call ExileClient_gui_safeXDialog_updateListBox;
true