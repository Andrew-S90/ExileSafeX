/*
 * SafeX Server Configs and Settings
 *
 * Made by Andrew_S90
 */

class CfgPatches
{
	class safex_server
	{
		requiredVersion=0.1;
		requiredAddons[]=
		{
			"exile_client",
			"exile_assets",
			"exile_server"
		};
		units[]={};
		weapons[]={};
		magazines[]={};
		ammo[]={};
	};
};
class CfgFunctions
{
	class safex_server
	{
		class Bootstrap
		{
			file="safex_server\bootstrap";
			class preInit
			{
				preInit=1;
			};
			class postInit
			{
				postInit=1;
			};
		};
	};
};

class CfgSafeX
{
	class Logging
	{
		//If this is one it will use extDB to log to a file when someone deposits/withdraws an item
		itemLogging = 1;
	};
};