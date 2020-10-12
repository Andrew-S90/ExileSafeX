 /*
 *
 * Author: Andrew_S90
 *
 * This work is protected by Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0). 
 *
 */

private ["_listBox", "_index", "_dialog", "_depositButton", "_itemClassName", "_canDepositItem", "_tradingResult", "_mass", "_add", "_list", "_itemType"]; 
 disableSerialization;

_listBox = _this select 0;
_index = _this select 1;
_dialog = uiNameSpace getVariable ["RscExileSafeXDialog", displayNull];
_depositButton = _dialog displayCtrl 4004;

if (_index > -1) then
{
	_itemClassName = _listBox lbData _index;
	_canDepositItem = true;
	_tradingResult = 0;
	try 
	{
		if({_x == _itemClassName} count (getArray (MissionConfigFile >> "CfgSafeX" >> "Settings" >> "BlockedItems")) > 0) then
		{
			throw 1;
		};
		
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
		if ((_mass + ExileClientPlayerSafeXCurrent) >= ExileClientPlayerSafeXLimit) then
		{
			throw 2;
		};
		
		_add = true;
		_list = [uniform player,vest player,backpack player];
		if(_itemClassName in _list) then 
		{
			switch (_itemClassName) do
			{
				case (uniform player):
				{
					if!(count ((uniformContainer player) call ExileClient_util_containerCargo_list) == 0) then {
						_add = false;
					};
				};
				case (vest player):
				{
					if!(count ((vestContainer player) call ExileClient_util_containerCargo_list) == 0) then {
						_add = false;
					};
				};
				case (backpack player):
				{
					if!(count ((backpackContainer player) call ExileClient_util_containerCargo_list) == 0) then {
						_add = false;
					};
				};
				default 
				{
					_add = false;
				};
			};
		};
		if !(_add) then
		{
			throw 3;
		};
	}
	catch
	{
		_tradingResult = _exception;
		_canDepositItem = false;
	};
	if (ExileClientIsWaitingForServerTradeResponse) then
	{
		_canDepositItem = false;
	};
	if (_canDepositItem) then 
	{
		_depositButton ctrlEnable true;
	}
	else 
	{
		_depositButton ctrlEnable false;
	};
}
else 
{
	_depositButton ctrlEnable false;
};
true