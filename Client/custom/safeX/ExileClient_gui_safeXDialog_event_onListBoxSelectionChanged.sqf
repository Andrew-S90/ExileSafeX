 /*
 *
 * Author: Andrew_S90
 *
 * This work is protected by Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0). 
 *
 */
 
private ["_listBox", "_index", "_dialog", "_withdrawButton", "_itemClassName", "_withdrawDropdown", "_selectedInventoryDropdownIndex", "_currentContainerType", "_canWithdrawItem", "_tradingResult", "_containerNetID", "_containerVehicle"];
disableSerialization;

_listBox = _this select 0;
_index = _this select 1;
_dialog = uiNameSpace getVariable ["RscExileSafeXDialog", displayNull];
_withdrawButton = _dialog displayCtrl 2004;

if (_index > -1) then
{
	_itemClassName = _listBox lbData _index;
	_withdrawDropdown = _dialog displayCtrl 2005;
	_selectedInventoryDropdownIndex = lbCurSel _withdrawDropdown;
	_currentContainerType = _withdrawDropdown lbValue _selectedInventoryDropdownIndex;
	_canWithdrawItem = true;
	_tradingResult = 0;
	try 
	{
		_withdrawDropdown ctrlEnable true;
		if !(_itemClassName isKindOf "AllVehicles") then 
		{
			switch (_currentContainerType) do
			{
				case 1:
				{
					if !([player, _itemClassName] call ExileClient_util_playerCargo_canAdd) then
					{
						throw 9;
					};
				};
				default 
				{
					_containerNetID = _withdrawDropdown lbData _selectedInventoryDropdownIndex;
					_containerVehicle = objectFromNetId _containerNetID;
					if (_containerVehicle isEqualTo objNull) then 
					{
						throw 8;
					};
					if !([_containerVehicle, _itemClassName] call ExileClient_util_containerCargo_canAdd) then 
					{
						throw 9;
					};
				};
			};
		};
	}
	catch
	{
		_tradingResult = _exception;
		_canWithdrawItem = false;
	};
	if (ExileClientIsWaitingForServerTradeResponse) then
	{
		_canWithdrawItem = false;
	};
	if (_canWithdrawItem) then 
	{
		_withdrawButton ctrlEnable true;
	}
	else 
	{
		_withdrawButton ctrlEnable false;
	};
}
else 
{
	_withdrawButton ctrlEnable false;
};
true