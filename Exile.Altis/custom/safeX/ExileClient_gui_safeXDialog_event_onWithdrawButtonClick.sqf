 /*
 *
 * Author: Andrew_S90
 *
 * This work is protected by Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0). 
 *
 */
 
private ["_dialog", "_safeXLB", "_dropdown", "_deposit", "_withdraw", "_selectedSafeXLBIndex", "_itemClassName", "_selected", "_currentContainerType", "_containerNetID"];
disableSerialization;

_dialog = uiNameSpace getVariable ["RscExileSafeXDialog", displayNull];
_safeXLB = _dialog displayCtrl 2003;
_dropdown = _dialog displayCtrl 2005;
_deposit = _dialog displayCtrl 4004;
_withdraw = _dialog displayCtrl 2004;

_deposit ctrlEnable false;
_deposit ctrlCommit 0;
_withdraw ctrlEnable false;
_withdraw ctrlCommit 0;
_dropdown ctrlEnable false;
_dropdown ctrlCommit 0;


_selectedSafeXLBIndex = lbCurSel _safeXLB;
if !(_selectedSafeXLBIndex isEqualTo -1) then
{
	_itemClassName = _safeXLB lbData _selectedSafeXLBIndex;
	if !(_itemClassName isEqualTo "") then
	{
		if !(ExileClientIsWaitingForServerTradeResponse) then
		{
			if !(_itemClassName isKindOf "AllVehicles") then 
			{
				_selected = lbCurSel _dropdown;
				_currentContainerType = _dropdown lbValue _selected;
				_containerNetID = "";
				if (_currentContainerType isEqualTo 2) then
				{
					_containerNetID = _dropdown lbData _selected;
				};
				ExileClientIsWaitingForServerTradeResponse = true;
				["withdrawItemRequest", [_itemClassName, _currentContainerType, _containerNetID]] call ExileClient_system_network_send;
			}
			else
			{
				closeDialog 0;
				ExileClientIsWaitingForServerTradeResponse = true;
				["withdrawVehicleRequest", [_itemClassName]] call ExileClient_system_network_send;
			};
		};
	};
};
true