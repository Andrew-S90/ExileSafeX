 /*
 *
 * Author: Andrew_S90
 *
 * This work is protected by Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0). 
 *
 */
 
private ["_responseCode", "_itemClassName", "_containerType", "_containerNetID", "_vehicle", "_dialog", "_listBox"];
_responseCode = _this select 0;
_itemClassName = _this select 1;
_containerType = _this select 2;
_containerNetID = _this select 3;
ExileClientPlayerSafeXItems = _this select 4;
ExileClientPlayerMarXetItems = _this select 5;

ExileClientIsWaitingForServerTradeResponse = false;
if (_responseCode isEqualTo 0) then
{
	if(_itemClassName != "") then
	{
		switch (_containerType) do
		{
			case 1:
			{	
				[player, _itemClassName] call ExileClient_util_playerCargo_add;
			};
			case 2:
			{
				if(_containerNetID != "") then
				{
					_vehicle = objectFromNetId _containerNetID;
					[_vehicle, _itemClassName] call ExileClient_util_containerCargo_add;
				};
			};
			default
			{
			};
		};
		["SuccessTitleAndText", ["Item Withdrawn!", "You successfully withdrew your item."]] call ExileClient_gui_toaster_addTemplateToast;
		
		_dialog = uiNameSpace getVariable ["RscExileSafeXDialog", displayNull];
		if !(_dialog isEqualTo displayNull) then
		{
			call ExileClient_gui_safeXDialog_updateListBox;
			call ExileClient_gui_safeXDialog_updateSelection;
			_listBox = _dialog displayCtrl 2003;
			[_listBox, -1] call ExileClient_gui_safeXDialog_event_onListBoxSelectionChanged;
		};
	};
}
else 
{
	["ErrorTitleAndText", ["Whoops!", format ["Something went really wrong. Please tell a server admin that you have tried to withdraw an item and tell them the code '%1'. Thank you!", _responseCode]]] call ExileClient_gui_toaster_addTemplateToast;
};