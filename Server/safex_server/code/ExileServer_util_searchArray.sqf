 /*
 *
 * Author: Andrew_S90
 *
 * This work is protected by Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0). 
 *
 */
 
private ["_data", "_classname", "_index", "_i"];
 
_data = (_this select 0);
_classname = (_this select 1); 
_index = -1;

for "_i" from 0 to (count _data - 1) do {
	if ( ((_data select _i) select 0) isEqualTo _classname) exitWith {
		_index = _i;
	};
};
_index