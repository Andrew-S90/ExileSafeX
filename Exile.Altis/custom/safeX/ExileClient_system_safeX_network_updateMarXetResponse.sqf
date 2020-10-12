 /*
 *
 * Author: Andrew_S90
 *
 * This work is protected by Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0). 
 *
 */
 
private ["_responseCode", "_data", "_dialog", "_listBox"];
_responseCode = _this select 0;
_data = _this select 1;


ExileClientIsWaitingForServerTradeResponse = false;
if (_responseCode isEqualTo 0) then
{

	ExileClientPlayerMarXetItems = _data;
	if(count ExileClientPlayerMarXetItems != 0) then {
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