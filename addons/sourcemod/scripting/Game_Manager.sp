#pragma semicolon 1
#pragma newdecls required

#define PluginName "[CS:GO] Game Manager"
#define PluginDesc "Game Manager ( Hide radar, money, messages, ping, and more )"

#define PluginAuthor "Gold_KingZ + MrQout"
#define PluginVersion "1.0.3"

#define PluginSite "https://steamcommunity.com/id/oQYh"

#define CFG_NAME "Game_Manager"

#define DefaultValue "1"
#define CVAR_FLAGS			FCVAR_NOTIFY
#define TEAM_NONE 0
#define TEAM_SPEC 1
#define TEAM_T 2
#define TEAM_CT 3

#include <sourcemod>
#include <cstrike>
#include <multicolors>
#include <sdktools>
#include <sdkhooks>
#include <sdktools_functions>

new Handle:rotation_client_limit = INVALID_HANDLE;
new Handle:rotation_include_bots = INVALID_HANDLE;
new Handle:rotation_time_limit = INVALID_HANDLE;
new Handle:rotation_mode = INVALID_HANDLE;
new Handle:rotation_default_map = INVALID_HANDLE;
new Handle:rotation_config_to_exec = INVALID_HANDLE;

new Handle:g_MapList = INVALID_HANDLE;

new g_MapPos;
new g_MapListSerial;
new minutesBelowClientLimit;
new bool:rotationMapChangeOccured;



ConVar g_ConVarEnable;
ConVar g_ConVarMethod;
ConVar g_ConVarDelay;
ConVar g_ConVarHibernate;
ConVar g_cEnableNoBlood;
ConVar g_cEnableNoSplatter;


bool g_bCvarEnabled;

int g_iCvarMethod;
int g_iHybernateInitial;



char g_sLogPath[PLATFORM_MAX_PATH];
char CfgFile[PLATFORM_MAX_PATH];


float g_fCvarDelay;
Handle h_bEnable;
Handle hPluginMe;


new Handle: g_Cvar_BotDelayEnable = INVALID_HANDLE;
new Handle:g_Cvar_BotQuota = INVALID_HANDLE;
new Handle:g_Cvar_BotDelay;
new Handle:bot_delay_timer = INVALID_HANDLE;
new bool:g_delayenable = false;
new bool:g_enable = false;
new g_Tcount = 0;
new g_CTcount = 0;
new g_BotTcount = 0;
new g_BotCTcount = 0;
new g_botQuota = 0;
new g_botDelay = 1;
new bool:g_hookenabled = false;

public Plugin myinfo = 
{
    name 		= PluginName,
    author 		= PluginAuthor,
    description = PluginDesc,
    version     = PluginVersion,
    url 		= PluginSite
};





Handle
	HRadar				 = null,
	MoneyHud 	 		 = null,
	Ignorenade 	 		 = null,
	Cheats 				 = null;
	

Handle CvarHandles[] =
{
	null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null
};


bool CvarEnables[] =
{
	false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false
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
	"sorry",
	"cheer",
	"compliment",
	"thanks",
	"go_a",
	"go_b",
	"needrop",
	"deathcry",
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
	
	
	HookConVarChange((CvarHandles[0] = CreateConVar("sm_enable_hide_and_block"		  	 , DefaultValue, ".::[Enable Hide And Block Feature]::. || 1= Yes || 0= No"						  , _, true, 0.0, true, 1.0)), ConVarChanged);
	HookConVarChange((CvarHandles[1] = CreateConVar("sm_hide_radar"		     , DefaultValue, "Hide Radar (Need To Enable sm_enable_hide_and_block) || 1= Yes || 0= No"							  , _, true, 0.0, true, 1.0)), ConVarChanged);
	HookConVarChange((CvarHandles[2] = CreateConVar("sm_hide_moneyhud"		     , DefaultValue, "Hide Money Hud (Need To Enable sm_enable_hide_and_block) || 1= Yes || 0= No"							  , _, true, 0.0, true, 1.0)), ConVarChanged);
	HookConVarChange((CvarHandles[3] = CreateConVar("sm_hide_killfeed"		     , DefaultValue, "Hide Kill Feed (Need To Enable sm_enable_hide_and_block) || 1= Yes || 0= No", _, true, 0.0, true, 1.0)), ConVarChanged);
	HookConVarChange((CvarHandles[4] = CreateConVar("sm_block_radio_voice_agents"		     , DefaultValue, "Block All Radio Voice Agents (Need To Enable sm_enable_hide_and_block) || 1= Yes || 0= No"				  , _, true, 0.0, true, 1.0)), ConVarChanged);
	HookConVarChange((CvarHandles[5] = CreateConVar("sm_block_radio_voice_grenades" , DefaultValue, "Block All Radio Voice Grenades Throw (Need To Enable sm_enable_hide_and_block) || 1= Yes || 0= No"				  , _, true, 0.0, true, 1.0)), ConVarChanged);
	HookConVarChange((CvarHandles[6] = CreateConVar("sm_block_wheel"	 			 , DefaultValue, "Block All Wheel + Ping (Need To Enable sm_enable_hide_and_block) || 1= Yes || 0= No"	  , _, true, 0.0, true, 1.0)), ConVarChanged);
	HookConVarChange((CvarHandles[7] = CreateConVar("sm_block_all_radio_messages "		 , DefaultValue, "Hide All Radio Messages  (Need To Enable sm_enable_hide_and_block) || 1= Yes || 0= No"			  , _, true, 0.0, true, 1.0)), ConVarChanged);
	HookConVarChange((CvarHandles[8] = CreateConVar("sm_block_cheats"			 , DefaultValue, "Make sv_cheats 0 Automatically   (Need To Enable sm_enable_hide_and_block) || 1= Yes || 0= No"			  , _, true, 0.0, true, 1.0)), ConVarChanged);
	HookConVarChange((CvarHandles[9]  = CreateConVar("sm_block_connect_message"	 , DefaultValue, "Hide Connect Messages (Need To Enable sm_enable_hide_and_block) || 1= Yes || 0= No"	      , _, true, 0.0, true, 1.0)), ConVarChanged);
	HookConVarChange((CvarHandles[10] = CreateConVar("sm_block_disconnect_message", DefaultValue, "Hide Disconnect Messages (Need To Enable sm_enable_hide_and_block) || 1= Yes || 0= No"	  , _, true, 0.0, true, 1.0)), ConVarChanged);
	HookConVarChange((CvarHandles[11] = CreateConVar("sm_block_jointeam_message"	 , DefaultValue, "Hide Join Team Messages (Need To Enable sm_enable_hide_and_block) || 1= Yes || 0= No"			  , _, true, 0.0, true, 1.0)), ConVarChanged);
	HookConVarChange((CvarHandles[12] = CreateConVar("sm_block_teamchange_message", DefaultValue, "Hide Team Change Messages (Need To Enable sm_enable_hide_and_block) || 1= Yes || 0= No"			  , _, true, 0.0, true, 1.0)), ConVarChanged);
	HookConVarChange((CvarHandles[13] = CreateConVar("sm_block_cvar_message" , DefaultValue, "Hide Cvar Change Messages (Need To Enable sm_enable_hide_and_block) || 1= Yes || 0= No"			  , _, true, 0.0, true, 1.0)), ConVarChanged);
	HookConVarChange((CvarHandles[14] = CreateConVar("sm_block_hidemoney_message" , DefaultValue, "Hide All Money Team/Player Award Messages (Need To Enable sm_enable_hide_and_block) || 1= Yes || 0= No", _, true, 0.0, true, 1.0)), ConVarChanged);
	HookConVarChange((CvarHandles[15] = CreateConVar("sm_block_savedby_message" , DefaultValue, "Hide Player Saved You By Player Messages (Need To Enable sm_enable_hide_and_block) || 1= Yes || 0= No", _, true, 0.0, true, 1.0)), ConVarChanged);
	HookConVarChange((CvarHandles[16] = CreateConVar("sm_block_teammateattack_message" , DefaultValue, "Hide Team Mate Attack Messages (Need To Enable sm_enable_hide_and_block) || 1= Yes || 0= No", _, true, 0.0, true, 1.0)), ConVarChanged);
	HookConVarChange((CvarHandles[17] = CreateConVar("sm_forceendmap" , DefaultValue, "Force End Map With Command mp_timelimit (Need To Enable sm_enable_hide_and_block) || 1= Yes || 0= No", _, true, 0.0, true, 1.0)), ConVarChanged);
	HookConVarChange((CvarHandles[18] = CreateConVar("sm_block_chicken" , DefaultValue, "Remove Chickens (Need To Enable sm_enable_hide_and_block) || 1= Yes || 0= No", _, true, 0.0, true, 1.0)), ConVarChanged);
	HookConVarChange((CvarHandles[19] = CreateConVar("sm_show_timeleft_hud" , DefaultValue, "Show Timeleft HUD (mp_timelimit) At Bottom  (Need To Enable sm_enable_hide_and_block) || 1= Yes || 0= No", _, true, 0.0, true, 1.0)), ConVarChanged);
	HookConVarChange((CvarHandles[20] = CreateConVar("sm_block_changename_message" , DefaultValue, "Hide Change Name Messages (Need To Enable sm_enable_hide_and_block) || 1= Yes || 0= No", _, true, 0.0, true, 1.0)), ConVarChanged);
	HookConVarChange((CvarHandles[21] = CreateConVar("sm_rotation_enable" , "0", ".::[Map Rotation Feature]::.  || 1= Yes || 0= No", _, true, 0.0, true, 1.0)), ConVarChanged);
	h_bEnable = CreateConVar("sm_auto_balance_every_round", DefaultValue, "Auto Balance Every Round (Need To Enable sm_enable_hide_and_block) || 1= Yes || 0= No", _, true, 0.0, true, 1.0);
	g_Cvar_BotQuota = CreateConVar("sm_block_bots", DefaultValue, "Permanently Remove bots (Need To Enable sm_enable_hide_and_block) || 1= Yes || 0= No");
	g_cEnableNoBlood = CreateConVar("sm_hide_blood", DefaultValue, "Remove Blood (Need To Enable sm_enable_hide_and_block) || 1= Yes || 0= No", _, true, 0.0, true, 1.0);
	g_cEnableNoSplatter  = CreateConVar("sm_hide_splatter", DefaultValue, "Remove Splatter Effect (Need To Enable sm_enable_hide_and_block) || 1= Yes || 0= No", _, true, 0.0, true, 1.0);
	
	( g_ConVarEnable 	= CreateConVar("sm_restart_empty_enable", 					"0", 	".::[Restart Server When Last Player Disconnect Feature]::. || 1= Yes || 0= No ", CVAR_FLAGS)).AddChangeHook(OnCvarChanged);
	( g_ConVarMethod 	= CreateConVar("sm_restart_empty_method", 					"2", 	"When server is empty Which Method Do You Like (Need To Enable sm_restart_empty_enable) || 1= Restart || 2= Crash If Method 1 Is Not work", CVAR_FLAGS)).AddChangeHook(OnCvarChanged);
	( g_ConVarDelay 	= CreateConVar("sm_restart_empty_delay", 					"60.0", 	"(in sec.) To Wait To Start sm_restart_empty_method (Need To Enable sm_restart_empty_enable)", CVAR_FLAGS)).AddChangeHook(OnCvarChanged);
		
	rotation_client_limit = CreateConVar("sm_rotation_client_limit", "1", "Number Of Clients That Must Be Connected To Disable Map Rotation Feature (Need To Enable sm_rotation_enable)", _, true, 0.0, false, 0.0);
	rotation_include_bots = CreateConVar("sm_rotation_include_bots", "0", "Include Bots In The Client Count (Remember, Sourcetv Counts As A Bot) (Need To Enable sm_rotation_enable)", _, true, 0.0, true, 1.0);
	rotation_time_limit = CreateConVar("sm_rotation_time_limit", "5", "(in min.) Pass While The Client Limit Has Not Been Reached For Rotation Feature To Occur (Need To Enable sm_rotation_enable)", _, true, 0.0, false, 0.0);
	rotation_mode = CreateConVar("sm_rotation_mode", "0", "Method (Need To Enable sm_rotation_enable)  || 0= Custom Maplist (Create New Line [gamemanager] + path In Sourcemod/configs/maplists.cfg) || 1= Sm_nextmap Or Mapcycle (Requires Nextmap.smx) || 2= Load Map In sm_rotation_default_map Cvar || 3= Reload Current Map", _, true, 0.0, true, 3.0);
	rotation_default_map = CreateConVar("sm_rotation_default_map", "", "Map To Load If (sm_rotation_mode Is Set To 2) (Need To Enable sm_rotation_enable)");
	rotation_config_to_exec = CreateConVar("sm_rotation_config_to_exec", "", "Config To Exec When An Rotation Feature Occurs, If Desired.  Executes After The Map Loads And Server.cfg And Sourcemod Plugin Configs Are Exec'd (Need To Enable sm_rotation_enable)");
	
	g_MapList = CreateArray(32);

	g_MapPos = -1;
	g_MapListSerial = -1;
	minutesBelowClientLimit = 0;
	rotationMapChangeOccured = false;
	
	g_enable = GetConVarBool(CvarHandles[0]);
	HookConVarChange(CvarHandles[0], CvarChanged);
	
	
	g_botQuota = GetConVarInt(g_Cvar_BotQuota);
	HookConVarChange(g_Cvar_BotQuota, CvarChanged);
	
	if (!g_delayenable && g_hookenabled == false) {
	HookEvent("player_team", Event_PlayerTeam);
	g_hookenabled = true;
	}
	
	g_ConVarHibernate = FindConVar("sv_hibernate_when_empty");
	
	BuildPath(Path_SM, g_sLogPath, sizeof(g_sLogPath), "logs/Game_Manager.log");
	
	RemoveCrashLog();
	
	GetCvars();
	
	LoadCfg();
	

	
	HRadar 	   = FindConVar("sv_disable_radar");
	MoneyHud   = FindConVar("mp_maxmoney");
	Ignorenade = FindConVar("sv_ignoregrenaderadio");
	Cheats 	   = FindConVar("sv_cheats");
	
	
	HookEvent("server_cvar", OnServerCvar  , EventHookMode_Pre);
	
	
	HookEvent("player_death", OnPlayerDeath, EventHookMode_Pre);
	
	
	HookEvent("player_spawn", OnPlayerSpawn);
	HookEvent("player_blind", OnPlayerBlind);
	HookEvent("round_prestart", Event_PreRoundStart);
	HookEvent("round_end", Event_PreRoundStart);
	HookEvent("player_team",  		OnPlayerTeam, 		EventHookMode_Pre);
	HookEvent("player_connect", 	OnPlayerConnect, 	EventHookMode_Pre);
	HookEvent("player_disconnect", 	OnPlayerDisconnect, EventHookMode_Pre);
	AddTempEntHook("Blood Sprite", TE_OnWorldDecal);
	AddTempEntHook("Entity Decal", TE_OnWorldDecal);
	AddTempEntHook("EffectDispatch", TE_OnEffectDispatch);
	AddTempEntHook("World Decal", TE_OnWorldDecal);
	AddTempEntHook("Impact", TE_OnWorldDecal);
	
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
	HookUserMessage(GetUserMessageId("SayText2"), OnHookTextMsg4, true);
	
	HookUserMessage(GetUserMessageId("RadioText"), OnRadioText, true);
	AddCommandListener(Command_Ping, "chatwheel_ping");
	AddCommandListener(Command_Ping, "player_ping");
	AddCommandListener(Command_Ping, "playerradio");
	AddCommandListener(Command_Ping, "playerchatwheel");
	

	for (int i = 0; i < sizeof(RadioArray); i++)
		AddCommandListener(OnRadio, RadioArray[i]);
	
	
	
	RegConsoleCmd("sm_game_manager_reload", Command_Reload, "Reload Config");
}


public void OnPluginEnd()
{

	UnhookEvent("player_death", OnPlayerDeath, EventHookMode_Pre);
	

	UnhookEvent("player_spawn", OnPlayerSpawn);
	UnhookEvent("player_blind", OnPlayerBlind);
	
}

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

public Action OnHookTextMsg4(UserMsg msg_id, Handle bf, int[] players, int playersNum, bool reliable, bool init)
{
	if (!CvarEnables[0] || !CvarEnables[20])return Plugin_Continue;

	new String:buffer[25];
	
	if(GetUserMessageType() == UM_Protobuf)
    {
        PbReadString(bf, "msg_name", buffer, sizeof(buffer));

        if(StrEqual(buffer, "#Cstrike_Name_Change"))
        {
            return Plugin_Handled;
        }
    }
	return Plugin_Continue;
}

public void OnMapStart()
{
	if (g_delayenable && g_hookenabled == false) {
		g_botDelay = GetConVarInt(g_Cvar_BotDelay);
		bot_delay_timer = CreateTimer(g_botDelay * 1.0, Timer_BotDelay);
	}
	
	CreateTimer(1.0, CheckRemainingTime, INVALID_HANDLE, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
}

public Action TE_OnEffectDispatch(const char[] te_name, const Players[], int numClients, float delay)
{
	if (!CvarEnables[0] || !g_cEnableNoSplatter.BoolValue) return Plugin_Continue;

	int iEffectIndex = TE_ReadNum("m_iEffectName");
	int nHitBox = TE_ReadNum("m_nHitBox");
	char sEffectName[64];

	GetEffectName(iEffectIndex, sEffectName, sizeof(sEffectName));

	if (StrEqual(sEffectName, "csblood")|| StrEqual(sEffectName, "Impact"))
	{	
		return Plugin_Handled;
	}

	if (StrEqual(sEffectName, "ParticleEffect"))
	{
		char sParticleEffectName[64];
		GetParticleEffectName(nHitBox, sParticleEffectName, sizeof(sParticleEffectName));
		if(StrEqual(sParticleEffectName, "impact_helmet_headshot"))
		{
			return Plugin_Handled;
		}
	}
	return Plugin_Continue;
}

public Action TE_OnWorldDecal(const char[] te_name, const Players[], int numClients, float delay)
{
	if (!CvarEnables[0] || !g_cEnableNoBlood.BoolValue) return Plugin_Continue;

	float vecOrigin[3];
	int nIndex = TE_ReadNum("m_nIndex");
	char sDecalName[64];

	TE_ReadVector("m_vecOrigin", vecOrigin);
	GetDecalName(nIndex, sDecalName, sizeof(sDecalName));

	if (StrContains(sDecalName, "decals/blood") == 0 && StrContains(sDecalName, "_subrect") != -1)
	{
		return Plugin_Handled;
	}
	return Plugin_Continue;
}

stock int GetParticleEffectName(int index, char[] sEffectName, int maxlen)
{
	int table = INVALID_STRING_TABLE;

	if (table == INVALID_STRING_TABLE)
	{
		table = FindStringTable("ParticleEffectNames");
	}

	return ReadStringTable(table, index, sEffectName, maxlen);
}

stock int GetEffectName(int index, char[] sEffectName, int maxlen)
{
	int table = INVALID_STRING_TABLE;

	if (table == INVALID_STRING_TABLE)
	{
		table = FindStringTable("EffectDispatch");
	}

	return ReadStringTable(table, index, sEffectName, maxlen);
}

stock int GetDecalName(int index, char[] sDecalName, int maxlen)
{
	int table = INVALID_STRING_TABLE;

	if (table == INVALID_STRING_TABLE)
	{
		table = FindStringTable("decalprecache");
	}

	return ReadStringTable(table, index, sDecalName, maxlen);
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
	new userid = GetEventInt(hEvent, "userid");
	new client = GetClientOfUserId(userid);
	
	if (CvarEnables[0] && CvarEnables[1])
	{
		int iClient = GetClientOfUserId(GetEventInt(hEvent, "userid"));
		CreateTimer(GetEntPropFloat(iClient, Prop_Send, "m_flFlashDuration"), Timer_RemoveRadar_Delay, iClient);
		
		if (client && GetClientTeam(client) == CS_TEAM_SPECTATOR)
		{
		new Float:fDuration = GetEntPropFloat(client, Prop_Send, "m_flFlashDuration");
		CreateTimer(fDuration, Timer_RemoveRadar_Delay, client);
		}
    }
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
	new String:acmConfigToExecValue[32];
	GetConVarString(rotation_config_to_exec, acmConfigToExecValue, sizeof(acmConfigToExecValue));
	if (rotationMapChangeOccured && strcmp(acmConfigToExecValue, "") != 0)
	{
		PrintToServer("Game_Manager : Exec'ing %s.", acmConfigToExecValue);
		ServerCommand("exec %s", acmConfigToExecValue);
	}

	minutesBelowClientLimit = 0;
	rotationMapChangeOccured = false;

	CreateTimer(60.0, CheckPlayerCount, _, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
	

	
	if( g_ConVarHibernate != null )
	{
		g_iHybernateInitial = g_ConVarHibernate.IntValue;
		g_ConVarHibernate.SetInt(0);
	}
	
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

public Action Event_PreRoundStart(Handle event, const char[] name, bool dontBroadcast)
{
    int T_Count = GetTeamClientCount(CS_TEAM_T);
    int CT_Count = GetTeamClientCount(CS_TEAM_CT);
    
    if(!CvarEnables[0] || !GetConVarBool(h_bEnable) || T_Count == CT_Count || T_Count + 1 == CT_Count || CT_Count + 1 == T_Count)
        return Plugin_Continue;
        
    while(T_Count > CT_Count && T_Count != CT_Count + 1)
    {
        int client = GetRandomPlayer(CS_TEAM_T);
        CS_SwitchTeam(client, CS_TEAM_CT);
        T_Count--;
        CT_Count++;
    }
    while(T_Count < CT_Count && CT_Count != T_Count + 1)
    {
        int client = GetRandomPlayer(CS_TEAM_CT);
        CS_SwitchTeam(client, CS_TEAM_T);
        CT_Count--;
        T_Count++;
    }
    return Plugin_Continue;
}

stock int GetRandomPlayer(int team) 
{ 
    int[] clients = new int[MaxClients]; 
    int clientCount;
    for (int i = 1; i <= MaxClients; i++) 
    {
        if (IsClientInGame(i) && GetClientTeam(i) == team)
        { 
            clients[clientCount++] = i; 
        } 
    }
    return (clientCount == 0) ? -1 : clients[GetRandomInt(0, clientCount - 1)];
}
public CvarChanged(Handle:cvar, const String:oldValue[], const String:newValue[]) {
	if (cvar == CvarHandles[0]) {
		g_enable = GetConVarBool(CvarHandles[0]);
		CheckBalance();
		return;
	}
	if (cvar == g_Cvar_BotQuota) {
		g_botQuota = GetConVarInt(g_Cvar_BotQuota);
		CheckBalance();
		return;
	}
	if (cvar == g_Cvar_BotDelayEnable) {
		g_delayenable = GetConVarBool(g_Cvar_BotDelayEnable);
		CheckBalance();
		return;
	}
	if (cvar == g_Cvar_BotDelay) {
		g_botDelay = GetConVarInt(g_Cvar_BotDelay);
		CheckBalance();
		return;
	}
}

public Action:Timer_BotDelay(Handle:timer) {
	RecalcTeamCount();
	CheckBalance();
	HookEvent("player_team", Event_PlayerTeam);
	g_hookenabled = true;

	bot_delay_timer = INVALID_HANDLE;
}

RecalcTeamCount() {
	g_Tcount = 0;
	g_CTcount = 0;
	g_BotTcount = 0;
	g_BotCTcount = 0;
	for (new i = 1; i <= MaxClients; i++) {
		if (IsClientInGame(i)) {
			ChangeTeamCount(GetClientTeam(i), 1, IsFakeClient(i));
		}
	}
}

ChangeTeamCount(team, diff, bool:isBot) {
	switch (team) {
		case TEAM_T: {
			if (isBot) {
				g_BotTcount += diff;
			} else {
				g_Tcount += diff;
			}
		}
		case TEAM_CT: {
			if (isBot) {
				g_BotCTcount += diff;
			} else {
				g_CTcount += diff;
			}
		}
	}
}

public Event_PlayerTeam(Handle:event, const String:name[], bool:dontBroadcast) {
	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	new oldTeam = GetEventInt(event, "oldteam");
	new newTeam = GetEventInt(event, "team");
	new bool:disconnect = GetEventBool(event, "disconnect");

	if (!disconnect) {
		ChangeTeamCount(oldTeam, -1, IsFakeClient(client));
		ChangeTeamCount(newTeam, 1, IsFakeClient(client));
	} else {
		RecalcTeamCount();
	}

	CheckBalance();
}

CheckBalance() {
	if (!g_enable || (g_botQuota <= 0)) {
		return;
	}

	new bots = g_BotTcount + g_BotCTcount;
	new humans = g_Tcount + g_CTcount;

	if (bots > 0 && humans == 0) {
		ServerCommand("bot_kick all");
	} else if (humans >= g_botQuota && bots > 0) {
		ServerCommand("bot_kick");
	} else if (humans < g_botQuota) {
		new botQuota = g_botQuota - humans;
		if (humans < 3) {
			botQuota = botQuota - 2;
		}
		if (bots > botQuota) {
			ServerCommand("bot_kick %s", (g_BotCTcount > g_BotTcount) ? "ct" : "t");
		} else if (bots < botQuota) {
			ServerCommand("bot_add %s", (g_BotCTcount + g_CTcount <= g_BotTcount + g_Tcount) ? "ct" : "t");
		}
	}
}

public OnMapEnd() {
	if (g_delayenable && g_hookenabled == true) {
		UnhookEvent("player_team", Event_PlayerTeam);
		g_hookenabled = false;
	}

	if(bot_delay_timer != INVALID_HANDLE) {
		KillTimer(bot_delay_timer);
		bot_delay_timer = INVALID_HANDLE;
	}
}

public Action CmdTime(int client, int args)
{
	char s[16];
	ReplyToCommand(client, s);
	return Plugin_Handled;
}

public void OnCvarChanged(ConVar convar, const char[] oldValue, const char[] newValue)
{
	GetCvars();
}

void GetCvars()
{
	g_bCvarEnabled = g_ConVarEnable.BoolValue;
	g_iCvarMethod = g_ConVarMethod.IntValue;
	g_fCvarDelay = g_ConVarDelay.FloatValue;
	InitHook();
}

void InitHook()
{
	static bool bHooked;
	
	if( g_bCvarEnabled )
	{
		if( !bHooked )
		{
			HookEvent("player_disconnect", Event_PlayerDisconnect, EventHookMode_Pre);	
			bHooked = true;
		}
	} else {
		if( bHooked )
		{
			UnhookEvent("player_disconnect", Event_PlayerDisconnect, EventHookMode_Pre);	
			bHooked = false;
		}
	}
}

public Action Event_PlayerDisconnect(Event event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(event.GetInt("userid"));
	
	if( client == 0 || !IsFakeClient(client) )
	{
		if( !RealPlayerExist(client) )
		{
				if( g_ConVarHibernate != null )
				{
					g_ConVarHibernate.SetInt(0);
				}
				CreateTimer(g_fCvarDelay, Timer_CheckPlayers);
				return Plugin_Continue;
		}
	}
	return Plugin_Continue;
}



public Action Timer_CheckPlayers(Handle timer, int UserId)
{
	if( !RealPlayerExist() )
	{
		StartRebootSequence();
	}
	return Plugin_Continue;
}

void StartRebootSequence()
{
	if( g_iCvarMethod != 2 )
	{
		UnloadPluginsExcludeMe();
		KickAll();
	}
	CreateTimer(0.1, Timer_RestartServer);
}

public Action Timer_RestartServer(Handle timer)
{
	RestartServer();
	return Plugin_Continue;
}

void RestartServer()
{
	switch( g_iCvarMethod )
	{
		case 1: {
			LogToFileEx(g_sLogPath, "Sending '_restart'... Reason: %s", RealPlayerExist() ? "Scheduled time" : "Empty Server");
			ServerCommand("_restart");
		}
		case 2: {
			LogToFileEx(g_sLogPath, "Sending 'crash'... Reason: %s", RealPlayerExist() ? "Scheduled time" : "Empty Server");
			SetCommandFlags("crash", GetCommandFlags("crash") &~ FCVAR_CHEAT);
			ServerCommand("crash");
		}
	}
}

void KickAll()
{
	for( int i = 1; i <= MaxClients; i++ )
	{
		if( IsClientInGame(i) )
		{
			KickClient(i, "Server Restarts");
		}
	}
}

void UnloadPluginsExcludeMe()
{
	char name[64];
	Handle hPlugin;
	Handle hIter = GetPluginIterator();
	
	if( hIter )
	{
		while( MorePlugins(hIter) )
		{
			hPlugin = ReadPlugin(hIter);
			
			if( hPlugin != hPluginMe && hPlugin != INVALID_HANDLE )
			{
				GetPluginFilename(hPlugin, name, sizeof(name));
				ServerCommand("sm plugins unload \"%s\"", name);
				ServerExecute();
			}
		}
		CloseHandle(hIter);
	}
}


public Action Timer_DoHybernate(Handle timer)
{
	if ( !RealPlayerExist() )
	{
		g_ConVarHibernate.SetInt(g_iHybernateInitial);
	}
	return Plugin_Continue;
}

public Action:CheckPlayerCount(Handle:timer)
{
	new acmClientLimitValue = GetConVarInt(rotation_client_limit);
	
	if (GetConVarInt(rotation_include_bots) == 0)
	{
		int players;
		for (int i = 1; i <= MaxClients; i++)
		{
			if (IsClientConnected(i) && !IsFakeClient(i))
			{
				players ++;
				}
		}
		if (players < acmClientLimitValue)
		{
			minutesBelowClientLimit++;
		}
		else
		{
			minutesBelowClientLimit = 0;
		}
	}
	else
	{
		if (GetClientCount() < acmClientLimitValue)
		{
			minutesBelowClientLimit++;
		}
		else
		{
			minutesBelowClientLimit = 0;
		}
	}
	if(GetConVarBool(CvarHandles[21]))
	{
		if (minutesBelowClientLimit >= GetConVarInt(rotation_time_limit))
		{
			SetMap();
		}
	}
	
	return Plugin_Continue;
}

SetMap()
{

	new acmModeValue = GetConVarInt(rotation_mode);
	new String:nextmap[32];

	switch(acmModeValue)
	{
		case 0:
		{
			if (ReadMapList(g_MapList, 
					g_MapListSerial, 
					"gamemanager", 
					MAPLIST_FLAG_CLEARARRAY|MAPLIST_FLAG_NO_DEFAULT)
					== INVALID_HANDLE)
			{
				if (g_MapListSerial == -1)
				{
					LogError("FATAL: Cannot load map cycle.");
					SetFailState("Mapcycle Not Found");
				}
			}
			
			new mapCount = GetArraySize(g_MapList);
			
			if (g_MapPos == -1)
			{
				decl String:current[64];
				GetCurrentMap(current, 64);
				
				for (new i = 0; i < mapCount; i++)
				{
					GetArrayString(g_MapList, i, nextmap, sizeof(nextmap));
					if (strcmp(current, nextmap, false) == 0)
					{
						g_MapPos = i;
						break;
					}
				}
				
				if (g_MapPos == -1)
				{
					g_MapPos = 0;
				}
			}
			
			g_MapPos++;
			if (g_MapPos >= mapCount)
			{
				g_MapPos = 0;
			}
			
			GetArrayString(g_MapList, g_MapPos, nextmap, sizeof(nextmap));
			if (!IsMapValid(nextmap))
			{
				PrintToServer("Game_Manager : invalid map name ('%s') found in mapcycle.  Reloading current map...", nextmap);
				GetCurrentMap(nextmap, sizeof(nextmap));
			}
			
		}
		
		case 1:
		{
			new Handle:h_sm_nextmap = FindConVar("sm_nextmap");

			if (h_sm_nextmap == INVALID_HANDLE)
			{	
				LogError("FATAL: Cannot find sm_nextmap cvar.");
				SetFailState("sm_nextmap not found");
			}
			
			GetConVarString(h_sm_nextmap, nextmap, sizeof(nextmap));
			if (!IsMapValid(nextmap))
			{
				PrintToServer("Game_Manager : sm_nextmap ('%s') does not contain valid map name.  Reloading current map...", nextmap);
				GetCurrentMap(nextmap, sizeof(nextmap));
				SetConVarString(h_sm_nextmap, nextmap);
			}
			CloseHandle(h_sm_nextmap);
		}

		case 2:
		{
			GetConVarString(rotation_default_map, nextmap, sizeof(nextmap));

			if (!IsMapValid(nextmap))
			{
				PrintToServer("Game_Manager : Game_Manager_default_map ('%s') does not contain valid map name.  Reloading current map...", nextmap);
				GetCurrentMap(nextmap, sizeof(nextmap));
			}
			
		}

		default:
		{
			GetCurrentMap(nextmap, sizeof(nextmap));
		}
	}
	new Handle:nextmapPack;
	CreateDataTimer(5.0, ChangeMapp, nextmapPack, TIMER_FLAG_NO_MAPCHANGE);
	WritePackString(nextmapPack, nextmap);
	PrintToChatAll("Game_Manager : Changing map to %s.", nextmap);
	
}

public Action:ChangeMapp(Handle:timer, Handle:mapPack)
{
	new String:map[32];
	ResetPack(mapPack);
	ReadPackString(mapPack, map, sizeof(map));
	rotationMapChangeOccured = true;
	ServerCommand("changelevel %s", map);

}

bool RealPlayerExist(int iExclude = 0)
{
	for( int client = 1; client <= MaxClients; client++ )
	{
		if( client != iExclude && IsClientConnected(client) )
		{
			if( !IsFakeClient(client) )
			{
				return true;
			}
		}
	}
	return false;
}

void RemoveCrashLog()
{
	if( !FileExists(g_sLogPath) )
	{
		return;
	}

	char sFile[PLATFORM_MAX_PATH];
	int ft, ftReport = GetFileTime(g_sLogPath, FileTime_LastChange);
	
	if( DirExists("CRASH") )
	{
		DirectoryListing hDir = OpenDirectory("CRASH");
		if( hDir != null )
		{
			while( hDir.GetNext(sFile, sizeof(sFile)) )
			{
				TrimString(sFile);
				if( StrContains(sFile, "crash-") != -1 )
				{
					Format(sFile, sizeof(sFile), "CRASH/%s", sFile);
					ft = GetFileTime(sFile, FileTime_Created);
					
					if( 0 <= ft - ftReport < 10 )
					{
						DeleteFile(sFile);
					}
				}
			}
			delete hDir;
		}
	}
}

stock bool IsClientValid(int client)
{
	if(client > 0 && client <= MaxClients && IsClientInGame(client))
		return true;
	return false;
}
