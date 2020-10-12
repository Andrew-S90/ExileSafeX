 /*
 *
 * Author: Andrew_S90
 *
 * This work is protected by Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0). 
 *
 */
 
private ["_dialog", "_inventoryLB", "_deposit", "_withdraw", "_selectedInventoryLBIndex", "_itemClassName", "_mass", "_retardCheck", "_itemType"];
disableSerialization;

_dialog = uiNameSpace getVariable ["RscExileSafeXDialog", displayNull];
_inventoryLB = _dialog displayCtrl 4003;
_deposit = _dialog displayCtrl 4004;
_withdraw = _dialog displayCtrl 2004;

_deposit ctrlEnable false;
_deposit ctrlCommit 0;
_withdraw ctrlEnable false;
_withdraw ctrlCommit 0;

if(round ExileClientPlayerSafeXCurrent >= ExileClientPlayerSafeXLimit) exitWith
{
	["ErrorTitleAndText", ["SafeX Full!", "Your SafeX Storage is full"]] call ExileClient_gui_toaster_addTemplateToast;
};

_selectedInventoryLBIndex = lbCurSel _inventoryLB;
if !(_selectedInventoryLBIndex isEqualTo -1) then
{
	_itemClassName = _inventoryLB lbData _selectedInventoryLBIndex;
	if !(_itemClassName isEqualTo "") then
	{
		if !(ExileClientIsWaitingForServerTradeResponse) then
		{	
			_mass = 0;
			_itemType = [_itemClassName] call BIS_fnc_itemType;
			
			switch (_itemType select 0) do
			{
				case "Equipment": 
				{
					switch (_itemType select 1) do
					{
						case "Headgear": 
						{	
							_mass = getNumber(configFile >> "CfgWeapons" >> _itemClassName >> "ItemInfo" >> "mass");
						};
						case "Vest":
						{
							_mass = getNumber(configFile >> "CfgWeapons" >> _itemClassName >> "ItemInfo" >> "mass");
						};
						case "Backpack":
						{
							_mass = getNumber(configFile >> "CfgVehicles" >> _itemClassName >> "mass");
						};
						case "Uniform":
						{
							_mass = getNumber(configFile >> "CfgWeapons" >> _itemClassName >> "ItemInfo" >> "mass");
						};
					};
				};
				case "Mine": 
				{
					_mass = getNumber(configFile >> "CfgMagazines" >> _itemClassName >> "mass");
				};
				case "Item":
				{
					_mass = getNumber(configFile >> "CfgWeapons" >> _itemClassName >> "ItemInfo" >> "mass");	
				};
				case "Magazine":
				{
					_mass = getNumber(configFile >> "CfgMagazines" >> _itemClassName >> "mass");
				};
				case "Weapon":
				{
					_mass = getNumber(configFile >> "CfgWeapons" >> _itemClassName >> "WeaponSlotsInfo" >> "mass");
				};
			};
			
			if !((_mass + (round ExileClientPlayerSafeXCurrent)) >= ExileClientPlayerSafeXLimit) then
			{
				_retardCheck = player call ExileClient_util_playerCargo_list;

				if (_itemClassName in _retardCheck) then
				{
					[player, _itemClassName] call ExileClient_util_playerCargo_remove;
					ExileClientIsWaitingForServerTradeResponse = true;
					["depositItemRequest", [_itemClassName]] call ExileClient_system_network_send;
				};
			};
		};
	};
};
true