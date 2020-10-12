 /*
 *
 * Author: Andrew_S90
 *
 * This work is protected by Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0). 
 *
 */
 
private ["_listBox", "_index", "_dialog", "_safeXListBox"];
disableSerialization;

_listBox = _this select 0;
_index = _this select 1;
_dialog = uiNameSpace getVariable ["RscExileSafeXDialog", displayNull];
_safeXListBox = _dialog displayCtrl 2003;
_safeXListBox lbSetCurSel -1;
call ExileClient_gui_safeXDialog_updateSelection;
true