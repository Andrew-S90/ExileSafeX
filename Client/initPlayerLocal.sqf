
//safeX
ExileClientPlayerSafeXItems = [];
ExileClientPlayerMarXetItems = [];

private ['_code', '_function', '_file'];
{
    _code = '';
    _function = _x select 0;
    _file = _x select 1;
    _code = compileFinal (preprocessFileLineNumbers _file);
    missionNamespace setVariable [_function, _code];
}
forEach
[
	//SafeX
	['ExileClient_gui_safeXDialog_event_onDepositButtonClick','custom\SafeX\ExileClient_gui_safeXDialog_event_onDepositButtonClick.sqf'],
	['ExileClient_gui_safeXDialog_event_onDropDownSelectionChanged','custom\SafeX\ExileClient_gui_safeXDialog_event_onDropDownSelectionChanged.sqf'],
	['ExileClient_gui_safeXDialog_event_onInventoryListBoxSelectionChanged','custom\SafeX\ExileClient_gui_safeXDialog_event_onInventoryListBoxSelectionChanged.sqf'],
	['ExileClient_gui_safeXDialog_event_onListBoxSelectionChanged','custom\SafeX\ExileClient_gui_safeXDialog_event_onListBoxSelectionChanged.sqf'],
	['ExileClient_gui_safeXDialog_event_onWithdrawButtonClick','custom\SafeX\ExileClient_gui_safeXDialog_event_onWithdrawButtonClick.sqf'],
	['ExileClient_gui_safeXDialog_show','custom\SafeX\ExileClient_gui_safeXDialog_show.sqf'],
	['ExileClient_gui_safeXDialog_updateListBox','custom\SafeX\ExileClient_gui_safeXDialog_updateListBox.sqf'],
	['ExileClient_gui_safeXDialog_updateSelection','custom\SafeX\ExileClient_gui_safeXDialog_updateSelection.sqf'],
	['ExileClient_system_safeX_network_depositItemResponse','custom\SafeX\ExileClient_system_safeX_network_depositItemResponse.sqf'],
	['ExileClient_system_safeX_network_hasSafeXResponse','custom\SafeX\ExileClient_system_safeX_network_hasSafeXResponse.sqf'],
	['ExileClient_system_safeX_network_updateMarXetResponse','custom\SafeX\ExileClient_system_safeX_network_updateMarXetResponse.sqf'],
	['ExileClient_system_safeX_network_withdrawItemResponse','custom\SafeX\ExileClient_system_safeX_network_withdrawItemResponse.sqf'],
	['ExileClient_system_safeX_network_withdrawVehicleResponse','custom\SafeX\ExileClient_system_safeX_network_withdrawVehicleResponse.sqf']
];
