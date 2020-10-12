 /*
 *
 * Author: Andrew_S90
 *
 * This work is protected by Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0). 
 *
 */
 
private ["_dialog", "_currentLoad", "_itemClassName", "_itemQuantity", "_loadProgress", "_loadValue", "_currentLoadInv", "_maximumLoadInv", "_loadProgressInv", "_loadValueInv", "_itemType"];
disableSerialization;
_dialog = uiNameSpace getVariable ["RscExileSafeXDialog", displayNull];
_currentLoad = 0;
	
if(count (ExileClientPlayerSafeXItems+ExileClientPlayerMarXetItems) == 0) then 
{
	_currentLoad = 0;
} else {
	{
		_itemClassName = _x select 0;
		_itemQuantity = _x select 1;
		
		if !(_itemClassName isKindOf "AllVehicles") then 
		{
			_itemType = [_itemClassName] call BIS_fnc_itemType;
				
			switch (_itemType select 0) do
			{
				case "Equipment": 
				{
					switch (_itemType select 1) do
					{
						case "Headgear": 
						{	
							_currentLoad = _currentLoad + (getNumber(configFile >> "CfgWeapons" >> _itemClassName >> "ItemInfo" >> "mass") * _itemQuantity);
						};
						case "Vest":
						{
							_currentLoad = _currentLoad + (getNumber(configFile >> "CfgWeapons" >> _itemClassName >> "ItemInfo" >> "mass") * _itemQuantity);
						};
						case "Backpack":
						{
							_currentLoad = _currentLoad + (getNumber(configFile >> "CfgVehicles" >> _itemClassName >> "mass") * _itemQuantity);
						};
						case "Uniform":
						{
							_currentLoad = _currentLoad + (getNumber(configFile >> "CfgWeapons" >> _itemClassName >> "ItemInfo" >> "mass") * _itemQuantity);
						};
					};
				};
				case "Mine": 
				{
					_currentLoad = _currentLoad + (getNumber(configFile >> "CfgMagazines" >> _itemClassName >> "mass") * _itemQuantity);
				};
				case "Item":
				{
					_currentLoad = _currentLoad + (getNumber(configFile >> "CfgWeapons" >> _itemClassName >> "ItemInfo" >> "mass") * _itemQuantity);	
				};
				case "Magazine":
				{
					_currentLoad = _currentLoad + (getNumber(configFile >> "CfgMagazines" >> _itemClassName >> "mass") * _itemQuantity);
				};
				case "Weapon":
				{
					_currentLoad = _currentLoad + (getNumber(configFile >> "CfgWeapons" >> _itemClassName >> "WeaponSlotsInfo" >> "mass") * _itemQuantity);
				};
			};
		};
	} forEach (ExileClientPlayerSafeXItems+ExileClientPlayerMarXetItems);
		
	ExileClientPlayerSafeXCurrent = _currentLoad;
};
	
_loadProgress = _dialog displayCtrl 2007;
_loadProgress progressSetPosition (_currentLoad / (ExileClientPlayerSafeXLimit max 1));
_loadValue = _dialog displayCtrl 2008;
_loadValue ctrlSetStructuredText (parseText format["<t size='1' color='#A0DF3B' font='puristaMedium' align='right'>SafeX Load: %1/%2</t>", round(_currentLoad), ExileClientPlayerSafeXLimit]);

_currentLoadInv = (loadAbs player);
_maximumLoadInv = getNumber(configfile >> "CfgInventoryGlobalVariable" >> "maxSoldierLoad");
_loadProgressInv = _dialog displayCtrl 4007;
_loadProgressInv progressSetPosition (_currentLoadInv / (_maximumLoadInv max 1));
_loadValueInv = _dialog displayCtrl 4008;
_loadValueInv ctrlSetStructuredText (parseText format["<t size='1' color='#A0DF3B' font='puristaMedium' align='right'>Load: %1/%2</t>", round(_currentLoadInv), _maximumLoadInv]);

true