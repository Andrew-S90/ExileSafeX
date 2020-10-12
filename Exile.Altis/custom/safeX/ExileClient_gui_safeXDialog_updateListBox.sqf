 /*
 *
 * Author: Andrew_S90
 *
 * This work is protected by Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0). 
 *
 */
 
private ["_dialog", "_rewardsListBox", "_withdraw", "_dropdown", "_inventoryListBox", "_deposit", "_itemClassName", "_itemQuantity", "_indexEntryIndex", "_configName", "_qualityColor", "_popTabColor", "_imageColor", "_list", "_add", "_blocked"];
disableSerialization;
_dialog = uiNameSpace getVariable ["RscExileSafeXDialog", displayNull];

_rewardsListBox = _dialog displayCtrl 2003;
_withdraw = _dialog displayCtrl 2004;
_dropdown = _dialog displayCtrl 2005;

_inventoryListBox = _dialog displayCtrl 4003;
_deposit = _dialog displayCtrl 4006;

lbClear _rewardsListBox;
lbClear _inventoryListBox;


if(count (ExileClientPlayerSafeXItems+ExileClientPlayerMarXetItems) != 0) then 
{
	{
		_itemClassName = (_x select 0);
		_itemQuantity = (_x select 1);
		_indexEntryIndex = 1;
	
		_configName = _itemClassName call ExileClient_util_gear_getConfigNameByClassName;
		_indexEntryIndex = _rewardsListBox lbAdd getText(configFile >> _configName >> _itemClassName >> "displayName");
		_rewardsListBox lbSetPicture [_indexEntryIndex, getText(configFile >> _configName >> _itemClassName >> "picture")];
					
		_qualityColor = [1, 1, 1, 1];
		_popTabColor = [1, 1, 1, 1];
		_imageColor = [1, 1, 1, 1];
					
		_rewardsListBox lbSetData [_indexEntryIndex, _itemClassName];
		_rewardsListBox lbSetColor [_indexEntryIndex, _qualityColor];
					
		_rewardsListBox lbSetPictureColor [_indexEntryIndex, _imageColor];
		if !(_itemClassName isKindOf "AllVehicles") then 
		{
			_rewardsListBox lbSetTextRight [_indexEntryIndex, format["%1", _itemQuantity]];
			_rewardsListBox lbSetColorRight [_indexEntryIndex, _popTabColor];
			_rewardsListBox lbSetPictureRightColor [_indexEntryIndex, _popTabColor];
		};

	} forEach (ExileClientPlayerSafeXItems+ExileClientPlayerMarXetItems);
	
	_dropdown ctrlEnable true;
	_withdraw ctrlEnable true;
	_dropdown ctrlCommit 0;
	_withdraw ctrlCommit 0;
} else {
	_dropdown ctrlEnable false;
	_withdraw ctrlEnable false;
	_dropdown ctrlCommit 0;
	_withdraw ctrlCommit 0;
};


_list = [uniform player,vest player,backpack player];

{
	_itemClassName = _x;
	if (!((_itemClassName splitString "_") select ((count (_itemClassName splitString "_"))-1) == "secondary")) then
	{
		_indexEntryIndex = 1;
		_add = true;
		_blocked = false;
		
		if({_x == _itemClassName} count (getArray (MissionConfigFile >> "CfgSafeX" >> "Settings" >> "BlockedItems")) > 0) then
		{
			_blocked = true;
		};
		
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
		
		
		_configName = _itemClassName call ExileClient_util_gear_getConfigNameByClassName;
		_indexEntryIndex = _inventoryListBox lbAdd getText(configFile >> _configName >> _itemClassName >> "displayName");
		_inventoryListBox lbSetPicture [_indexEntryIndex, getText(configFile >> _configName >> _itemClassName >> "picture")];
					
		_qualityColor = [1, 1, 1, 1];
		_popTabColor = [1, 1, 1, 1];
		_imageColor = [1, 1, 1, 1];
					
		_inventoryListBox lbSetData [_indexEntryIndex, _itemClassName];
		_inventoryListBox lbSetColor [_indexEntryIndex, _qualityColor];
					
		_inventoryListBox lbSetPictureColor [_indexEntryIndex, _imageColor];
		_inventoryListBox lbSetColorRight [_indexEntryIndex, _popTabColor];
		_inventoryListBox lbSetPictureRightColor [_indexEntryIndex, _popTabColor];
		
		if !(_add) then 
		{
			_inventoryListBox lbSetColorRight [_indexEntryIndex, [0.7,0.7,0.7,1]];
			_inventoryListBox lbSetTextRight [_indexEntryIndex, "(Empty me)"];
		};
		
		if(_blocked) then
		{
			_inventoryListBox lbSetColorRight [_indexEntryIndex, [1,0,0,1]];
			_inventoryListBox lbSetColor [_indexEntryIndex, [1,0,0,1]];
			_inventoryListBox lbSetTextRight [_indexEntryIndex, "(Blacklisted)"];
		};
	};
} forEach (player call ExileClient_util_playerCargo_list);

_deposit ctrlEnable false;
_deposit ctrlCommit 0;

