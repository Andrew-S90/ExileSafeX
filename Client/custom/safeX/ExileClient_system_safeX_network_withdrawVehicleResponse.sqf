 /*
 *
 * Author: Andrew_S90
 *
 * This work is protected by Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0). 
 *
 */
 
private ["_responseCode", "_itemClassName", "_containerType", "_containerNetID", "_vehicle", "_dialog", "_listBox"];
_responseCode = _this select 0;
_vehicleNetID = _this select 1;
ExileClientPlayerSafeXItems = _this select 2;
ExileClientPlayerMarXetItems = _this select 3;

ExileClientIsWaitingForServerTradeResponse = false;
if (_responseCode isEqualTo 0) then
{
	_vehicleObject = objectFromNetId _vehicleNetID;
	player moveInDriver _vehicleObject;
	["SuccessTitleAndText", ["Vehicle Withdrawn!", "Your vehicle has been successfully claimed"]] call ExileClient_gui_toaster_addTemplateToast;
}
else 
{
	["ErrorTitleAndText", ["Whoops!", format ["Something went really wrong. Please tell a server admin that you have tried to withdraw a vehicle and tell them the code '%1'. Thank you!", _responseCode]]] call ExileClient_gui_toaster_addTemplateToast;
};
