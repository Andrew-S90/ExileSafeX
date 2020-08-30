/*
 * ExileClient_system_safeX_network_hasSafeXResponse
 *
 * SafeX Client - Made by Andrew_S90
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
 
private ["_responseCode", "_data", "_dialog", "_listBox", "_dataM"];
_responseCode = _this select 0;
_data = _this select 1;
_dataM = _this select 2;


ExileClientIsWaitingForServerTradeResponse = false;
if (_responseCode isEqualTo 0) then
{

	ExileClientPlayerSafeXItems = _data;
	ExileClientPlayerMarXetItems = _dataM;
	if((count ExileClientPlayerSafeXItems != 0) || (count ExileClientPlayerMarXetItems != 0)) then {
		["SuccessTitleAndText", ["SafeX Updated!", "Your SafeX has been updated!"]] call ExileClient_gui_toaster_addTemplateToast;
	};
	_dialog = uiNameSpace getVariable ["RscExileSafeXDialog", displayNull];
	if !(_dialog isEqualTo displayNull) then
	{
		call ExileClient_gui_safeXDialog_updateListBox;
		call ExileClient_gui_safeXDialog_updateSelection;
		_listBox = _dialog displayCtrl 2003;
		[_listBox, lbCurSel _listBox] call ExileClient_gui_safeXDialog_event_onListBoxSelectionChanged;
	};
}
else 
{
	["ErrorTitleAndText", ["Whoops!", format ["Something went really wrong. Please tell a server admin that you got your SafeX items updated and tell them the code '%1'. Thank you!", _responseCode]]] call ExileClient_gui_toaster_addTemplateToast;
};