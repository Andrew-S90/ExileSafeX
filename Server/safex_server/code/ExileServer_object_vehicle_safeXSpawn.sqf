 /*
 *
 * Author: Andrew_S90
 *
 * This work is protected by Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0). 
 *
 */
 
private["_vehicleID", "_data", "_position", "_vectorDirection", "_vectorUp", "_pinCode", "_texture", "_vehicleObject", "_lock", "_unlockInSafeZonesAfterRestart", "_isLocked", "_hitpoints", "_cargoContainers"];
_vehicleID = (_this select 1);
_position = (_this select 2);
_data = format ["loadVehicle:%1", _vehicleID] call ExileServer_system_database_query_selectSingle;
//_position = [_data select 8, _data select 9, _data select 10];
_vectorDirection = [_data select 11, _data select 12, _data select 13];
_vectorUp = [_data select 14, _data select 15, _data select 16];
_pinCode = _data select 20;
_texture = _data select 21;
_marxetStatus = _data select 24;

try 
{
	if !((vectorMagnitude _vectorUp) isEqualTo 1) then 
	{
		throw true;
	};
	if ((_vectorUp select 0) > 0.95) then 
	{
		throw true;
	};
	if ((_vectorUp select 1) > 0.95) then 
	{
		throw true;
	};
	if ((_vectorUp select 2) isEqualTo 0) then 
	{
		throw true;
	};
}
catch
{
	_vectorUp = [0, 0, 1];
};
_vehicleObject = [(_data select 1), _position, [_vectorDirection, _vectorUp], true,_pinCode] call ExileServer_object_vehicle_createPersistentVehicle;
_vehicleObject setVariable ["ExileDatabaseID", _vehicleID];
_vehicleObject setVariable ["ExileOwnerUID", (_data select 3)];
_vehicleObject setVariable ["ExileMoney", (_data select 23), true];

_vehicleObject setVariable ["ExileIsLocked", 0];
_vehicleObject lock 0;
_vehicleObject enableRopeAttach true;

_vehicleObject setFuel (_data select 5);
_vehicleObject setDamage (_data select 6);
_hitpoints = _data select 7;
if ((typeName _hitpoints) isEqualTo "ARRAY") then 
{
	{
		_vehicleObject setHitPointDamage [_x select 0, _x select 1];
	}
	forEach _hitpoints;
};
[_vehicleObject, (_data select 17)] call ExileServer_util_fill_fillItems;
[_vehicleObject, (_data select 18)] call ExileServer_util_fill_fillMagazines;
[_vehicleObject, (_data select 19)] call ExileServer_util_fill_fillWeapons;
_cargoContainers = format ["loadVehicleContainer:%1", _vehicleID] call ExileServer_system_database_query_selectSingle;
if ((typeName _cargoContainers) isEqualTo "ARRAY") then 
{
	if !(_cargoContainers isEqualTo []) then
	{
		[_vehicleObject, (_cargoContainers select 0)] call ExileServer_util_fill_fillContainers;
	};
};
if !(_texture isEqualTo "") then
{
	if !((_texture select 0) isEqualType "") then
	{
		{
			_vehicleObject setObjectTextureGlobal _x;
			true
		} count _texture;
	}
	else
	{
		{
			_vehicleObject setObjectTextureGlobal [_forEachIndex, _x];
		} forEach _texture;
	};
};	

_vehicleObject enableSimulationGlobal false;
_vehicleObject call ExileServer_system_simulationMonitor_addVehicle;
if (_vehicleObject call ExileClient_util_world_isInTraderZone) then 
{
	_vehicleObject allowDamage false;
};

format["setMarXetLock:%1:%2", "", _vehicleID] call ExileServer_system_database_query_fireAndForget;

_vehicleObject
