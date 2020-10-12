class CfgSafeX
{
	class Settings
	{
		BlockedItems[] = 
		{
			"DemoCharge_Remote_Mag",
			"SatchelCharge_Remote_Mag",
			"Exile_Item_MobilePhone",
			"Exile_Item_BreachingCharge_Wood",
			"Exile_Item_BreachingCharge_Metal",
			"Exile_Item_BreachingCharge_BigMomma"
		};
	};
	
	class Respect
	{
		StorageLevels[] =
		{
			//Respect Needed, Storage Size
			{0,1000},
			{10000,1500},
			{15000,2000},
			{30000,2500},
			{45000,3000},
			{60000,3500},
			{75000,4000},
			{90000,5000}
		};
	};
};  
 
class CfgNetworkMessages
{
	/* ~~ SafeX Start ~~ */
	class depositItemRequest
	{
		module="system_safex";
		parameters[]=
		{
			"STRING"
		};
	};
	class depositItemResponse
	{
		module="system_safex";
		parameters[]=
		{
			"SCALAR",
			"ARRAY"
		};
	};
	class withdrawItemRequest
	{
		module="system_safex";
		parameters[]=
		{
			"STRING",
			"SCALAR",
			"STRING"
		};
	};
	class withdrawItemResponse
	{
		module="system_safex";
		parameters[]=
		{
			"SCALAR",
			"STRING",
			"SCALAR",
			"STRING",
			"ARRAY",
			"ARRAY"
		};
	};
	class hasSafeXRequest
	{
		module="system_safex";
		parameters[]={};
	};
	class hasSafeXResponse
	{
		module="system_safex";
		parameters[]=
		{
			"SCALAR",
			"ARRAY",
			"ARRAY"
		};
	};	
	class updateMarXetResponse
	{
		module="system_safex";
		parameters[]=
		{
			"SCALAR",
			"ARRAY"
		};
	};	
	class withdrawVehicleRequest
	{
		module="system_safex";
		parameters[]=
		{
			"STRING"
		};
	};
	class withdrawVehicleResponse
	{
		module="system_safex";
		parameters[]=
		{
			"SCALAR",
			"STRING",
			"ARRAY",
			"ARRAY"
		};
	};
	
	/* ~~ SafeX End ~~ */
};	


//*********

	class Locker
	{
	   targetType = 2;
	   target = "Exile_Locker";
		class Actions
		{
			class SafeX
			{
				title = "SafeX Storage";
				condition = "player call ExileClient_util_world_isInTraderZone";
				action = "[] call ExileClient_gui_safeXDialog_show;";
			};
		};
	};