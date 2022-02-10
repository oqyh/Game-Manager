#pragma semicolon 1
#pragma newdecls required

#define PluginName "[CS:GO] Game Manager"
#define PluginDesc "Game Manager ( Hide radar, money, messages, ping, and more )"

#define PluginAuthor "Gold_KingZ + MrQout"
#define PluginVersion "1.0.0"

#define PluginSite "https://steamcommunity.com/id/oQYh"

#define CFG_NAME "Game_Manager"

#define DefaultValue "0"

#include <sourcemod>
#include <cstrike>
#include <multicolors>
#include <sdktools>
#include <sdkhooks>

public Plugin myinfo = 
{
    name 		= PluginName,
    author 		= PluginAuthor,
    description = PluginDesc,
    version     = PluginVersion,
    url 		= PluginSite
};


char CfgFile[PLATFORM_MAX_PATH];


Handle
	HRadar				 = null,
	MoneyHud 	 		 = null,
	Ignorenade 	 		 = null,
	Cheats 				 = null;
	

Handle CvarHandles[] =
{
	null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null
};


bool CvarEnables[] =
{
	false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false
};



char RadioArray[][] = 
{
	"coverme",
	"takepoint",
	"holdpos",
	"regroup",
	"followme",
	"takingfire",
	"go",
	"fallback",
	"sticktog",
	"getinpos",
	"stormfront",
	"report",
	"roger",
	"enemyspot",
	"needbackup",
	"sectorclear",
	"inposition",
	"reportingin",
	"getout",
	"negative",
	"enemydown",
	"reportingin	",
	"cheer",
	"compliment",
	"thanks",
	"go_a",
	"go_b",
	"needrop",
	"deathcry"
};

char MoneyMessageArray[][] =
{
	"#Player_Cash_Award_Kill_Hostage",
    "#Player_Cash_Award_Damage_Hostage",
    "#Player_Cash_Award_Get_Killed",
    "#Player_Cash_Award_Respawn",
    "#Player_Cash_Award_Interact_Hostage",
    "#Player_Cash_Award_Killed_Enemy",
    "#Player_Cash_Award_Rescued_Hostage",
    "#Player_Cash_Award_Bomb_Defused",
    "#Player_Cash_Award_Bomb_Planted",
    "#Player_Cash_Award_Killed_Enemy_Generic",
    "#Player_Cash_Award_Killed_VIP",
    "#Player_Cash_Award_Kill_Teammate",
    "#Player_Cash_Award_ExplainSuicide_YouGotCash",
    "#Player_Cash_Award_ExplainSuicide_TeammateGotCash",
    "#Player_Cash_Award_ExplainSuicide_EnemyGotCash",
    "#Player_Cash_Award_ExplainSuicide_Spectators",
    "#Team_Cash_Award_Win_Hostages_Rescue",
    "#Team_Cash_Award_Win_Defuse_Bomb",
    "#Team_Cash_Award_Win_Time",
    "#Team_Cash_Award_Elim_Bomb",
    "#Team_Cash_Award_Elim_Hostage",
    "#Team_Cash_Award_T_Win_Bomb",
    "#Team_Cash_Award_Win_Hostage_Rescue",
    "#Team_Cash_Award_Loser_Bonus",
    "#Team_Cash_Award_Loser_Zero",
    "#Team_Cash_Award_Rescued_Hostage",
    "#Team_Cash_Award_Hostage_Interaction",
    "#Team_Cash_Award_Hostage_Alive",
    "#Team_Cash_Award_Planted_Bomb_But_Defused",
    "#Team_Cash_Award_CT_VIP_Escaped",
    "#Team_Cash_Award_T_VIP_Killed",
    "#Team_Cash_Award_no_income",
    "#Team_Cash_Award_Generic",
    "#Team_Cash_Award_Custom",
    "#Team_Cash_Award_no_income_suicide",
};

char SavedbyArray[][] =
{
	"#Chat_SavePlayer_Savior",
    "#Chat_SavePlayer_Spectator",
    "#Chat_SavePlayer_Saved",
};

char TeamWarningArray[][] =
{
	"#Game_teammate_attack",
    "#SFUI_Notice_Killed_Teammate",
    "#Cstrike_TitlesTXT_Game_teammate_attack",
	"#Hint_try_not_to_injure_teammates",
};

public void OnPluginStart() 
{
	CreateTimer(1.0, Timeleft, _, TIMER_REPEAT);
	if (GetEngineVersion() != Engine_CSGO)
	{
		SetFailState("This plugin is for game use only. CS:GO");
		return;
	}
	
	
	Format(CfgFile, sizeof(CfgFile), "sourcemod/%s.cfg", CFG_NAME);
	
	
	for (int i = 0; i < sizeof(CvarEnables); i++)
		CvarEnables[i] = view_as<bool>(StringToInt(DefaultValue));
	
	
	HookConVarChange((CvarHandles[0] = CreateConVar("sm_game_manager_enable"		  	 , DefaultValue, "Enable Plugin || 1= Yes || 0= No"						  , _, true, 0.0, true, 1.0)), ConVarChanged);
	HookConVarChange((CvarHandles[1] = CreateConVar("sm_hide_radar"		     , DefaultValue, "Hide Radar || 1= Yes || 0= No"							  , _, true, 0.0, true, 1.0)), ConVarChanged);
	HookConVarChange((CvarHandles[2] = CreateConVar("sm_hide_moneyhud"		     , DefaultValue, "Hide Money Hud || 1= Yes || 0= No"							  , _, true, 0.0, true, 1.0)), ConVarChanged);
	HookConVarChange((CvarHandles[3] = CreateConVar("sm_hide_killfeed"		     , DefaultValue, "Hide Kill Feed || 1= Yes || 0= No", _, true, 0.0, true, 1.0)), ConVarChanged);
	HookConVarChange((CvarHandles[4] = CreateConVar("sm_block_radio_voice_agents"		     , DefaultValue, "Block All Radio Voice Agents || 1= Yes || 0= No"				  , _, true, 0.0, true, 1.0)), ConVarChanged);
	HookConVarChange((CvarHandles[5] = CreateConVar("sm_block_radio_voice_grenades" , DefaultValue, "Block All Radio Voice Grenades Throw || 1= Yes || 0= No"				  , _, true, 0.0, true, 1.0)), ConVarChanged);
	HookConVarChange((CvarHandles[6] = CreateConVar("sm_block_wheel"	 			 , DefaultValue, "Block All Wheel + Ping || 1= Yes || 0= No"	  , _, true, 0.0, true, 1.0)), ConVarChanged);
	HookConVarChange((CvarHandles[7] = CreateConVar("sm_hide_all_radio_messages"		 , DefaultValue, "Hide All Radio Messages  || 1= Yes || 0= No"			  , _, true, 0.0, true, 1.0)), ConVarChanged);
	HookConVarChange((CvarHandles[8] = CreateConVar("sm_block_cheats"			 , DefaultValue, "Make sv_cheats 0 Automatically   || 1= Yes || 0= No"			  , _, true, 0.0, true, 1.0)), ConVarChanged);
	
	
	HookConVarChange((CvarHandles[9]  = CreateConVar("sm_hide_connect_message"	 , DefaultValue, "Hide Connect Messages || 1= Yes || 0= No"	      , _, true, 0.0, true, 1.0)), ConVarChanged);
	HookConVarChange((CvarHandles[10] = CreateConVar("sm_hide_disconnect_message", DefaultValue, "Hide Disconnect Messages || 1= Yes || 0= No"	  , _, true, 0.0, true, 1.0)), ConVarChanged);
	HookConVarChange((CvarHandles[11] = CreateConVar("sm_hide_jointeam_message"	 , DefaultValue, "Hide Join Team Messages || 1= Yes || 0= No"			  , _, true, 0.0, true, 1.0)), ConVarChanged);
	HookConVarChange((CvarHandles[12] = CreateConVar("sm_hide_teamchange_message", DefaultValue, "Hide Team Change Messages || 1= Yes || 0= No"			  , _, true, 0.0, true, 1.0)), ConVarChanged);
	HookConVarChange((CvarHandles[13] = CreateConVar("sm_hide_cvar_message" , DefaultValue, "Hide Cvar Change Messages || 1= Yes || 0= No"			  , _, true, 0.0, true, 1.0)), ConVarChanged);
	
	HookConVarChange((CvarHandles[14] = CreateConVar("sm_hide_hidemoney_message" , DefaultValue, "Hide All Money Team/Player Award Messages || 1= Yes || 0= No", _, true, 0.0, true, 1.0)), ConVarChanged);
	
	HookConVarChange((CvarHandles[15] = CreateConVar("sm_hide_savedby_message" , DefaultValue, "Hide Player Saved You By Player Messages || 1= Yes || 0= No", _, true, 0.0, true, 1.0)), ConVarChanged);
	
	HookConVarChange((CvarHandles[16] = CreateConVar("sm_hide_teammateattack_message" , DefaultValue, "Hide Team Mate Attack Messages || 1= Yes || 0= No", _, true, 0.0, true, 1.0)), ConVarChanged);

	HookConVarChange((CvarHandles[17] = CreateConVar("sm_forceendmap" , DefaultValue, "Force End Map With Command (mp_timelimit) || 1= Yes || 0= No", _, true, 0.0, true, 1.0)), ConVarChanged);

	HookConVarChange((CvarHandles[18] = CreateConVar("sm_no_chicken" , DefaultValue, "No Chicken || 1= Yes || 0= No ", _, true, 0.0, true, 1.0)), ConVarChanged);

	HookConVarChange((CvarHandles[19] = CreateConVar("sm_show_timeleft_hud" , DefaultValue, "Show Timeleft HUD (mp_timelimit) At Bottom  || 1= Yes || 0= No", _, true, 0.0, true, 1.0)), ConVarChanged);

	
	LoadCfg();
	
	
	
	
	HRadar 	   = FindConVar("sv_disable_radar");
	MoneyHud   = FindConVar("mp_maxmoney");
	Ignorenade = FindConVar("sv_ignoregrenaderadio");
	Cheats 	   = FindConVar("sv_cheats");
	
	
	HookEvent("server_cvar", OnServerCvar  , EventHookMode_Pre);
	
	
	HookEvent("player_death", OnPlayerDeath, EventHookMode_Pre);
	
	
	HookEvent("player_spawn", OnPlayerSpawn);
	HookEvent("player_blind", OnPlayerBlind);
	
	
	HookEvent("player_team",  		OnPlayerTeam, 		EventHookMode_Pre);
	HookEvent("player_connect", 	OnPlayerConnect, 	EventHookMode_Pre);
	HookEvent("player_disconnect", 	OnPlayerDisconnect, EventHookMode_Pre);
	
	
	
	
	if (HRadar != null)
	{
		SetConVarBool(HRadar, true, true, false);
		HookConVarChange(HRadar, CHRadar);
	}
	
	
	if (MoneyHud != null)
	{
		SetConVarInt(MoneyHud, 0, true, false);
		HookConVarChange(MoneyHud, CMoneyHud);
	}
	
	
	if (Ignorenade != null)
	{
		SetConVarBool(Ignorenade, true, true, false);
		HookConVarChange(Ignorenade, CIgnorenade);
	}
	
	if (Cheats != null)
	{
		SetConVarBool(Cheats, false, true, false);
		HookConVarChange(Cheats, CCheats);
	}
	
	HookUserMessage(GetUserMessageId("TextMsg"), OnHookTextMsg, true);
	HookUserMessage(GetUserMessageId("TextMsg"), OnHookTextMsg2, true);
	HookUserMessage(GetUserMessageId("TextMsg"), OnHookTextMsg3, true);
	
	HookUserMessage(GetUserMessageId("RadioText"), OnRadioText, true);
	AddCommandListener(Command_Ping, "chatwheel_ping");
	AddCommandListener(Command_Ping, "player_ping");
	AddCommandListener(Command_Ping, "playerradio");
	AddCommandListener(Command_Ping, "playerchatwheel");
	

	for (int i = 0; i < sizeof(RadioArray); i++)
		AddCommandListener(OnRadio, RadioArray[i]);
	
	
	
	RegConsoleCmd("sm_game_manager_reload", Command_Reload, "Reload Config");
}

/*
public void OnPluginEnd()
{

	UnhookEvent("player_death", OnPlayerDeath, EventHookMode_Pre);
	

	UnhookEvent("player_spawn", OnPlayerSpawn);
	UnhookEvent("player_blind", OnPlayerBlind);
}*/

public int ConVarChanged(Handle cvar, char[] oldValue, char[] newValue)
{
	for (int i = 0; i < sizeof(CvarHandles); i++)
		if (cvar == CvarHandles[i])SetConVarInt(CvarHandles[i], (CvarEnables[i] = GetConVarBool(cvar)));
}

public Action OnHookTextMsg(UserMsg msg_id, Handle bf, int[] players, int playersNum, bool reliable, bool init)
{
	if (!CvarEnables[0] || !CvarEnables[14])return Plugin_Continue;

	char sBuffer[64];
	PbReadString(bf, "params", sBuffer, sizeof(sBuffer), 0);
	
	for (int i = 0; i < sizeof(MoneyMessageArray); i++)
	{
		if (!strcmp(sBuffer, MoneyMessageArray[i], false))return Plugin_Handled;
	}
	
	return Plugin_Continue;
}

public Action OnHookTextMsg2(UserMsg msg_id, Handle bf, int[] players, int playersNum, bool reliable, bool init)
{
	if (!CvarEnables[0] || !CvarEnables[15])return Plugin_Continue;

	char sBuffer[64];
	PbReadString(bf, "params", sBuffer, sizeof(sBuffer), 0);
	
	for (int i = 0; i < sizeof(SavedbyArray); i++)
	{
		if (!strcmp(sBuffer, SavedbyArray[i], false))return Plugin_Handled;
	}
	
	return Plugin_Continue;
}

public Action OnHookTextMsg3(UserMsg msg_id, Handle bf, int[] players, int playersNum, bool reliable, bool init)
{
	if (!CvarEnables[0] || !CvarEnables[16])return Plugin_Continue;

	char sBuffer[64];
	PbReadString(bf, "params", sBuffer, sizeof(sBuffer), 0);
	
	for (int i = 0; i < sizeof(TeamWarningArray); i++)
	{
		if (!strcmp(sBuffer, TeamWarningArray[i], false))return Plugin_Handled;
	}
	
	return Plugin_Continue;
}

public void OnMapStart()
{
	CreateTimer(1.0, CheckRemainingTime, INVALID_HANDLE, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
}

public Action CheckRemainingTime(Handle timer)
{
	if (!CvarEnables[0] || !CvarEnables[17])return Plugin_Continue;
	Handle hTmp;	
	hTmp = FindConVar("mp_timelimit");
	int iTimeLimit = GetConVarInt(hTmp);			
	if (hTmp != INVALID_HANDLE)
		CloseHandle(hTmp);	
	if (iTimeLimit > 0)
	{
		int timeleft;
		GetMapTimeLeft(timeleft);
		
		switch(timeleft)
		{
			case 1800: 	CPrintToChatAll("{lightred}Timeleft: 30 minutes");
			case 1200: 	CPrintToChatAll("{lightred}Timeleft: 20 minutes");
			case 600: 	CPrintToChatAll("{lightred}Timeleft: 10 minutes");
			case 300: 	CPrintToChatAll("{lightred}Timeleft: 5 minutes");
			case 120: 	CPrintToChatAll("{lightred}Timeleft: 2 minutes");
			case 60: 	CPrintToChatAll("{lightred}Timeleft: 60 seconds");
			case 30: 	CPrintToChatAll("{lightred}Timeleft: 30 seconds");
			case 15: 	CPrintToChatAll("{lightred}Timeleft: 15 seconds");
			case -1: 	CPrintToChatAll("{lightred}Timeleft: 3..");
			case -2: 	CPrintToChatAll("{lightred}Timeleft: 2..");
			case -3: 	CPrintToChatAll("{lightred}Timeleft: 1..");
		}
		
		if(timeleft < -3)
			CS_TerminateRound(0.0, CSRoundEnd_Draw, true);
	}
	
	return Plugin_Continue;
}

public Action CS_OnTerminateRound(float &fDelay, CSRoundEndReason &iReason)
{
	if (!CvarEnables[0] || !CvarEnables[17])return Plugin_Continue;
	return Plugin_Continue;
}

public void OnEntityCreated(int entity, const char[] classname)
{
	if (classname[0] == 'c')
	{
		if (StrEqual(classname, "chicken", true))
		{
			SDKHook(entity, SDKHook_Spawn, SDK_OnChickenSpawn);
		}
	}
	else if (classname[0] == 'i')
	{
		if (StrEqual(classname, "info_map_parameters", true))
		{
			SDKHook(entity, SDKHook_Spawn, SDK_OnMapParametersSpawn);
		}
	}
}

public Action SDK_OnChickenSpawn(int entity)
{
	if (!CvarEnables[0] || !CvarEnables[18])return Plugin_Continue;
	if (!IsValidEntity(entity))
	{
		return Plugin_Continue;
	}
	
	RequestFrame(Frame_RemoveEntity, EntIndexToEntRef(entity));
	return Plugin_Continue;
}

public Action SDK_OnMapParametersSpawn(int entity)
{
	if (!CvarEnables[0] || !CvarEnables[18])return Plugin_Continue;
	if (!IsValidEntity(entity))
	{
		return Plugin_Continue;
	}
	
	SetEntProp(entity, Prop_Data, "m_iPetPopulation", 0);
	return Plugin_Continue;
}

public void Frame_RemoveEntity(int reference)
{
	int entity = EntRefToEntIndex(reference);
	if (entity == INVALID_ENT_REFERENCE)
	{
		return;
	}
	
	AcceptEntityInput(entity, "Kill");
}


public Action Timeleft(Handle timer)
{
	if (!CvarEnables[0] || !CvarEnables[19])return Plugin_Continue;
	char sTime[60];
	int iTimeleft;

	GetMapTimeLeft(iTimeleft);
	if(iTimeleft > 0)
	{
		FormatTime(sTime, sizeof(sTime), "%M:%S", iTimeleft);

		for(int i = 1; i <= MaxClients; i++)
		{
			if(IsClientInGame(i) && !IsFakeClient(i))
			{
				char message[60];
				Format(message, sizeof(message), "Timeleft: %s", sTime);
				SetHudTextParams(-1.0, 1.00, 1.0, 4, 180, 255, 255, 0, 0.00, 0.00, 0.00);
				ShowHudText(i, -1, message);
			}
		}
	}
	return Plugin_Continue;
}


public Action OnServerCvar(Handle hEvent, const char[] name, bool dontBroadcast)
{
	return (CvarEnables[0] && CvarEnables[13]) ? 
		Plugin_Handled :
		Plugin_Continue;
}

public Action OnPlayerDeath(Handle hEvent, const char[] name, bool dontBroadcast)
{
	return (((CvarEnables[0] && CvarEnables[3]) && !dontBroadcast) ? Plugin_Handled : Plugin_Continue);
}

public Action OnPlayerConnect(Handle hEvent, const char[] name, bool dontBroadcast) 
{
	return (CvarEnables[0] && CvarEnables[9]) ? 
		Plugin_Handled :
		Plugin_Continue;
}

public Action OnPlayerDisconnect(Handle hEvent, const char[] name, bool dontBroadcast) 
{
	return (CvarEnables[0] && CvarEnables[10]) ? 
		Plugin_Handled :
		Plugin_Continue;
}

public Action OnPlayerTeam(Handle hEvent, const char[] name, bool dontBroadcast) 
{
	if (!GetEventBool(hEvent, "disconnect") && CvarEnables[0])
	{
		int iOldTeam = GetEventInt(hEvent, "oldteam");
		
		if ((CvarEnables[11] && iOldTeam == 0)
			|| (CvarEnables[12] && iOldTeam != 0))
				SetEventBool(hEvent, "silent", true);
	}
	
	return Plugin_Continue;
}

public Action OnPlayerSpawn(Handle hEvent, const char[] name, bool dontBroadcast) 
{
	if (CvarEnables[0] && CvarEnables[1])
		CreateTimer(0.0, Timer_RemoveRadar_Delay, GetClientOfUserId(GetEventInt(hEvent, "userid")));
}

public Action OnPlayerBlind(Handle hEvent, const char[] name, bool dontBroadcast)  
{
	if (CvarEnables[0] && CvarEnables[1])
	{
		int iClient = GetClientOfUserId(GetEventInt(hEvent, "userid"));
		CreateTimer(GetEntPropFloat(iClient, Prop_Send, "m_flFlashDuration"), Timer_RemoveRadar_Delay, iClient);
    }
}

public Action Timer_RemoveRadar_Delay(Handle hTimer, any iClient)
{
	if (IsValidPlayer(iClient, false))
		SetEntProp(iClient, Prop_Send, "m_iHideHUD", (1 << 12));
}

public int CHRadar(Handle cvar, char[] oldValue, char[] newValue)
{
	if (CvarEnables[0] && CvarEnables[1] && !GetConVarBool(HRadar))
		SetConVarBool(HRadar, true, true, false);
}

public int CMoneyHud(Handle cvar, char[] oldValue, char[] newValue)
{
	if (CvarEnables[0] && CvarEnables[2] && GetConVarInt(MoneyHud) != 0)
		SetConVarInt(MoneyHud, 0, true, false);
}

public int CIgnorenade(Handle cvar, char[] oldValue, char[] newValue)
{
	if (CvarEnables[0] && CvarEnables[5] && !GetConVarBool(Ignorenade))
		SetConVarBool(Ignorenade, true, true, false);
}

public int CAllRadio(Handle cvar, char[] oldValue, char[] newValue)
{
	if (CvarEnables[0] && CvarEnables[6] && !GetConVarBool(Ignorenade))
		SetConVarBool(Ignorenade, true, true, false);
}

public Action Command_Ping(int iClient, char[] command, int args)
{
	return (CvarEnables[0] && CvarEnables[6]) ?
		Plugin_Handled : 
		Plugin_Continue;
}

public Action OnRadioText(UserMsg msg_id, Protobuf bf, const int[] players, int playersNum, bool reliable, bool init)
{
	return (CvarEnables[0] &&  CvarEnables[7]) ?
		Plugin_Handled : 
		Plugin_Continue;
}

public int CCheats(Handle cvar, char[] oldValue, char[] newValue)
{
	bool Status;
	if ((CvarEnables[0] && CvarEnables[8]) && (Status = GetConVarBool(Cheats)))
		CreateTimer(0.1, CCheats_Delay, !Status);
}

public Action CCheats_Delay(Handle hTimer, any NewStatus)
{
	SetConVarBool(Cheats, NewStatus, true, false);
}

public Action OnRadio(int client, const char[] command, int args)
{
	return ((CvarEnables[0] && CvarEnables[4]) ? Plugin_Handled : Plugin_Continue);
}

public Action Command_Reload(int client, int args)
{
	if ((GetUserFlagBits(client) & ADMFLAG_ROOT))
	{
		
		ServerCommand("exec %s", CfgFile);
		
		if (IsValidPlayer(client, false))
			PrintToConsole(client, "Configuration reloaded successfully!");
	}
	
	return Plugin_Handled;
}

public void OnConfigsExecuted()
{
	LoadCfg();
}

void LoadCfg()
{
	
	AutoExecConfig(true, CFG_NAME);
}

bool IsValidPlayer(int iClient, bool team = true, bool alive = false)
{
	
	return (
		iClient > 0 && iClient <= MaxClients
		&& IsClientConnected(iClient) && IsClientInGame(iClient)
		&& (!team || GetClientTeam(iClient) > 1)
		&& (!alive || IsPlayerAlive(iClient)));
}