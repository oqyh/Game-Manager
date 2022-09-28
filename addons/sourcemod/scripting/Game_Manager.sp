#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>
#include <cstrike>
#include <multicolors>
#include <sdktools>
#include <sdkhooks>
#include <sdktools_functions>

#define CFG_NAME "Game_Manager"
#define TEAM_NONE 0
#define TEAM_SPEC 1
#define TEAM_T 2
#define TEAM_CT 3

ConVar g_enable;
ConVar g_msgsshorthanded;
ConVar g_radar;
ConVar g_moneyhud;
ConVar g_killfeed;
ConVar g_blockradioagent;
ConVar g_blockradionade;
ConVar g_blockwhell;
ConVar g_blockclantag;
ConVar g_cheats;
ConVar g_msgconnect;
ConVar g_msgdisconnect;
ConVar g_msgjointeam;
ConVar g_msgchangeteam;
ConVar g_msgcvar;
ConVar g_msgmoney;
ConVar g_msgsavedby;
ConVar g_msgteamattack;
ConVar g_msgchangename;
ConVar g_forceend;
ConVar g_blockchicken;
ConVar g_blockweapondrop;
ConVar g_showtime;
ConVar g_blockautomute;
ConVar g_blockfootsteps;
ConVar g_blockjumpland;
ConVar g_blockroundendsound;
ConVar g_blockradiostartround;
ConVar g_blockfalldamage;
ConVar g_knifesound;
ConVar Cvar_ListX;
ConVar Cvar_ListY;
ConVar Cvar_ListColor;
ConVar g_cEnableNoBlood;
ConVar g_cEnableNoSplatter;
ConVar g_ConVarEnable;
ConVar g_ConVarMethod;
ConVar g_ConVarDelay;
ConVar g_ConVarHibernate;

int g_MapPos;
int g_MapListSerial;
int minutesBelowClientLimit;
int g_ownerOffset;
bool rotationMapChangeOccured;

Handle g_balance;
Handle hPluginMe;
Handle g_Cvar_BotDelayEnable = INVALID_HANDLE;
Handle g_Cvar_BotQuota = INVALID_HANDLE;
Handle g_Cvar_BotDelay;
Handle bot_delay_timer = INVALID_HANDLE;
bool g_delayenable = false;
bool g_eenable = false;
int g_Tcount = 0;
int g_CTcount = 0;
int g_BotTcount = 0;
int g_BotCTcount = 0;
int g_botQuota = 0;
int g_botDelay = 1;
bool g_hookenabled = false;
Handle rotation_enable = INVALID_HANDLE;
Handle rotation_client_limit = INVALID_HANDLE;
Handle rotation_include_bots = INVALID_HANDLE;
Handle rotation_time_limit = INVALID_HANDLE;
Handle rotation_mode = INVALID_HANDLE;
Handle rotation_default_map = INVALID_HANDLE;
Handle rotation_config_to_exec = INVALID_HANDLE;
Handle g_MapList = INVALID_HANDLE;

bool g_benable = false;
bool g_bradar = false;
bool g_bmoneyhud = false;
bool g_bkillfeed = false;
bool g_bblockradioagent = false;
bool g_bblockwhell = false;
bool g_bblockclantag = false;
bool g_bcheats = false;
bool g_bmsgconnect = false;
bool g_bmsgdisconnect = false;
bool g_bmsgjointeam = false;
bool g_bmsgchangeteam = false;
bool g_bmsgcvar = false;
bool g_bmsgmoney = false;
bool g_bmsgsavedby = false;
bool g_bmsgteamattack = false;
bool g_bmsgchangename = false;
bool g_bforceend = false;
bool g_bblockchicken = false;
bool g_bblockweapondrop = false;
bool g_bshowtime = false;
bool g_bblockautomute = false;
bool g_bblockfootsteps = false;
bool g_bblockjumpland = false;
bool g_bblockroundendsound = false;
bool g_bblockradiostartround = false;
bool g_bblockfalldamage = false;

float g_ListX;
float g_ListY;
float g_fCvarDelay;

bool g_phitted[MAXPLAYERS];
bool g_bCvarEnabled;
bool g_bStartRandomMap;
bool g_bServerStarted;

int g_iCvarMethod;
int g_iHybernateInitial;
int g_iListColor[4];

char g_sLogPath[PLATFORM_MAX_PATH];

Handle
	Cheats 				 = null;

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

public Plugin myinfo = 
{
	name = "[CS:GO] Game Manager",
	author = "Gold_KingZ",
	description = "Game Manager ( Hide radar, money, messages, ping, and more )",
	version     = "1.0.7",
	url = "https://steamcommunity.com/id/oQYh"
}

public void OnPluginStart()
{
	LoadTranslations( "Game_Manager.phrases" );
	
	CreateTimer(1.0, Timeleft, _, TIMER_REPEAT);
	CreateTimer(1.0, Timer_Wep, 0, TIMER_REPEAT);
	if (GetEngineVersion() != Engine_CSGO)
	{
		SetFailState("This plugin is for game use only. CS:GO");
		return;
	}
	
	g_enable = CreateConVar("gm_enable_hide_and_block"		  	 , "1", ".::[Enable Hide And Block Feature]::. || 1= Yes || 0= No", _, true, 0.0, true, 1.0);
	g_radar = CreateConVar("gm_hide_radar"		     , "0", "Hide Radar (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No", _, true, 0.0, true, 1.0);
	g_moneyhud = CreateConVar("gm_hide_moneyhud"		     , "0", "Hide Money Hud (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No", _, true, 0.0, true, 1.0);
	g_killfeed = CreateConVar("gm_hide_killfeed"		     , "0", "Hide Kill Feed (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No", _, true, 0.0, true, 1.0);
	g_blockradioagent = CreateConVar("gm_block_radio_voice_agents"		     , "0", "Block All Radio Voice Agents (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No", _, true, 0.0, true, 1.0);
	g_blockradionade = CreateConVar("gm_block_radio_voice_grenades"		     , "0", "Block All Radio Voice Grenades Throw (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No", _, true, 0.0, true, 1.0);
	g_blockwhell = CreateConVar("gm_block_wheel"		     , "0", "Block All Wheel + Ping (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No", _, true, 0.0, true, 1.0);
	g_blockclantag = CreateConVar("gm_block_clantag"		     , "0", "Permanently Block Both Dynamic + Animated + Normal ClanTags (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No", _, true, 0.0, true, 1.0);
	g_cheats = CreateConVar("gm_block_cheats"		     , "0", "Make sv_cheats 0 Automatically   (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No", _, true, 0.0, true, 1.0);
	g_msgconnect = CreateConVar("gm_block_connect_message"		     , "0", "Hide Connect Messages (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No", _, true, 0.0, true, 1.0);
	g_msgdisconnect = CreateConVar("gm_block_disconnect_message"		     , "0", "Hide Disconnect Messages (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No", _, true, 0.0, true, 1.0);
	g_msgjointeam = CreateConVar("gm_block_jointeam_message"		     , "0", "Hide First Time Connect Client Join Team Messages (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No", _, true, 0.0, true, 1.0);
	g_msgchangeteam = CreateConVar("gm_block_teamchange_message"		     , "0", "Hide Team Change Messages (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No", _, true, 0.0, true, 1.0);
	g_msgcvar = CreateConVar("gm_block_cvar_message"		     , "0", "Hide Server Cvar Change Messages (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No", _, true, 0.0, true, 1.0);
	g_msgmoney = CreateConVar("gm_block_hidemoney_message"		     , "0", "Hide All Money Team/Player Award Messages (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No", _, true, 0.0, true, 1.0);
	g_msgsavedby = CreateConVar("gm_block_savedby_message"		     , "0", "Hide Player Saved You By Player Messages (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No", _, true, 0.0, true, 1.0);
	g_msgteamattack = CreateConVar("gm_block_teammateattack_message"		     , "0", "Hide Team Mate Attack Messages (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No", _, true, 0.0, true, 1.0);
	g_msgchangename = CreateConVar("gm_block_changename_message"		     , "0", "Hide Change Name Messages (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No", _, true, 0.0, true, 1.0);
	g_msgsshorthanded = CreateConVar("gm_block_shorthanded_message"		     , "0", "Hide Short-Handed Incoming Messages (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No", _, true, 0.0, true, 1.0);

	g_forceend = CreateConVar("gm_forceendmap"		     , "0", "Force End Map With Command mp_timelimit (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No", _, true, 0.0, true, 1.0);
	g_blockchicken = CreateConVar("gm_block_chicken"		     , "0", "Permanently Remove Chickens (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No", _, true, 0.0, true, 1.0);
	g_blockweapondrop = CreateConVar("gm_block_weapon_drop"		     , "0", "Delete/Clean Weapons Dropped (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No", _, true, 0.0, true, 1.0);
	g_showtime = CreateConVar("gm_show_timeleft_hud"		     , "0", "Show Timeleft HUD (mp_timelimit)  (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No", _, true, 0.0, true, 1.0);
	g_balance = CreateConVar("gm_auto_balance_every_round", "0", "Auto Balance Every Round (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No", _, true, 0.0, true, 1.0);
	g_Cvar_BotQuota = CreateConVar("gm_block_bots", "0", "Permanently Remove bots (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No", _, true, 0.0, true, 1.0);
	g_cEnableNoBlood = CreateConVar("gm_hide_blood"		     , "0", "Hide Blood (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No", _, true, 0.0, true, 1.0);
	g_cEnableNoSplatter = CreateConVar("gm_hide_splatter"		     , "0", "Hide Splatter Effect (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No", _, true, 0.0, true, 1.0);
	g_blockautomute = CreateConVar("gm_block_auto_mute"		     , "0", "Remove Auto Communication Penalties (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No", _, true, 0.0, true, 1.0);
	g_blockfootsteps = CreateConVar("gm_block_footsteps_sound"		     , "0", "Block Footsteps Sounds (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No", _, true, 0.0, true, 1.0);
	g_blockjumpland = CreateConVar("gm_block_jumpland_sound"		     , "0", "Block Jump Land Sounds (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No", _, true, 0.0, true, 1.0);
	g_blockroundendsound = CreateConVar("gm_block_roundend_sound"		     , "0", "Block Counter/Terrorist/Draw Win Sounds (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No", _, true, 0.0, true, 1.0);
	g_blockradiostartround = CreateConVar("gm_block_radio_start_agents"		     , "0", "Block Round Start Radio Sounds (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No", _, true, 0.0, true, 1.0);
	g_blockfalldamage = CreateConVar("gm_block_falldamage"		     , "0", "Disable Fall Damage (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No", _, true, 0.0, true, 1.0);
	g_knifesound = CreateConVar("gm_block_zerodamge_knife", "0", "Block Knife Sound If Its Zero Damage (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No", _, true, 0.0, true, 1.0);
	Cvar_ListX = CreateConVar("gm_hud_xaxis"		     , "0.00", "X-Axis Location From 0 To 1.0 Check https://github.com/oqyh/Game-Manager/blob/main/images/hud%20postions.png For Help");
	Cvar_ListY = CreateConVar("gm_hud_yaxis"		     , "0.35", "Y-Axis Location From 0 To 1.0 Check https://github.com/oqyh/Game-Manager/blob/main/images/hud%20postions.png For Help");
	Cvar_ListColor = CreateConVar("gm_hud_colors"		     , "255 0 189 0.8", "Hud color. [R G B A] Pick Colors https://rgbacolorpicker.com/");

	( g_ConVarEnable 	= CreateConVar("gm_restart_empty_enable", 					"0", 	".::[Restart Server When Last Player Disconnect Feature]::. || 1= Yes || 0= No ")).AddChangeHook(OnCvarChanged);
	( g_ConVarMethod 	= CreateConVar("gm_restart_empty_method", 					"2", 	"When server is empty Which Method Do You Like (Need To Enable gm_restart_empty_enable) || 1= Restart || 2= Crash If Method 1 Is Not work")).AddChangeHook(OnCvarChanged);
	( g_ConVarDelay 	= CreateConVar("gm_restart_empty_delay", 					"900.0", 	"(in sec.) To Wait To Start gm_restart_empty_method (Need To Enable gm_restart_empty_enable)")).AddChangeHook(OnCvarChanged);
	
	rotation_enable = CreateConVar("gm_rotation_enable", "0", ".::[Map Rotation Feature]::.  || 1= Yes || 0= No", _, true, 0.0, true, 1.0);
	rotation_client_limit = CreateConVar("gm_rotation_client_limit", "1", "Number Of Clients That Must Be Connected To Disable Map Rotation Feature (Need To Enable gm_rotation_enable)", _, true, 0.0, false, 0.0);
	rotation_include_bots = CreateConVar("gm_rotation_include_bots", "0", "Include Bots In Number Of Clients in gm_rotation_client_limit (Remember, Sourcetv Counts As A Bot) (Need To Enable gm_rotation_enable)", _, true, 0.0, true, 1.0);
	rotation_time_limit = CreateConVar("gm_rotation_time_limit", "5", "(in min.) Pass While The Client Limit Has Not Been Reached For Rotation Feature To Occur (Need To Enable gm_rotation_enable)", _, true, 0.0, false, 0.0);
	rotation_mode = CreateConVar("gm_rotation_mode", "1", "(Need To Enable gm_rotation_enable) \n 1= Use game_manager_maps.txt map list need to (Create New Line [gamemanager] + path In Sourcemod/configs/maplists.cfg) \n 2= Sm_nextmap Or Mapcycle (Requires Nextmap.smx) \n 3= Load Map In gm_rotation_default_map Cvar \n 0 or 4 and above = Reload Current Map", _, true, 0.0, true, 3.0);
	rotation_default_map = CreateConVar("gm_rotation_default_map", "", "Map To Load If (gm_rotation_mode Is Set To 2) (Need To Enable gm_rotation_enable)");
	rotation_config_to_exec = CreateConVar("gm_rotation_config_to_exec", "", "Config To Exec When An Rotation Feature Occurs, If Desired.  Executes After The Map Loads And Server.cfg And Sourcemod Plugin Configs Are Exec'd (Need To Enable gm_rotation_enable)");


	g_ListX				= GetConVarFloat(Cvar_ListX);
	g_ListY				= GetConVarFloat(Cvar_ListY);
	
	char buffer[16];
	GetConVarString(Cvar_ListColor, buffer, sizeof(buffer));
	StrToRGBA(buffer);
	
	g_MapList = CreateArray(32);

	g_MapPos = -1;
	g_MapListSerial = -1;
	minutesBelowClientLimit = 0;
	rotationMapChangeOccured = false;
	
	AutoExecConfig(true, CFG_NAME);
	

	HookEvent("server_cvar", OnServerCvar  , EventHookMode_Pre);
	HookEvent("player_death", Event_PlayerDeath, EventHookMode_Pre);
	HookEvent("player_connect", 	OnPlayerConnect, 	EventHookMode_Pre);
	HookEvent("player_disconnect", 	OnPlayerDisconnect, EventHookMode_Pre);
	HookEvent("player_team",  		OnPlayerTeam, 		EventHookMode_Pre);
	HookEvent("round_end", Event_RoundEnd, EventHookMode_Pre);
	HookEvent("round_prestart", Event_PreRoundStart);
	
	HookUserMessage(GetUserMessageId("RadioText"), OnRadioText, true);
	HookUserMessage(GetUserMessageId("TextMsg"), OnHookTextMsg, true);
	HookUserMessage(GetUserMessageId("TextMsg"), OnHookTextMsg2, true);
	HookUserMessage(GetUserMessageId("TextMsg"), OnHookTextMsg3, true);
	HookUserMessage(GetUserMessageId("SayText2"), OnHookTextMsg4, true);
	
	HookConVarChange(g_enable, OnSettingsChanged);
	HookConVarChange(g_msgsshorthanded, OnSettingsChanged);
	HookConVarChange(g_radar, OnSettingsChanged);
	HookConVarChange(g_moneyhud, OnSettingsChanged);
	HookConVarChange(g_killfeed, OnSettingsChanged);
	HookConVarChange(g_blockradioagent, OnSettingsChanged);
	HookConVarChange(g_blockradionade, OnSettingsChanged);
	HookConVarChange(g_blockwhell, OnSettingsChanged);
	HookConVarChange(g_blockclantag, OnSettingsChanged);
	HookConVarChange(g_cheats, OnSettingsChanged);
	HookConVarChange(g_msgconnect, OnSettingsChanged);
	HookConVarChange(g_msgdisconnect, OnSettingsChanged);
	HookConVarChange(g_msgjointeam, OnSettingsChanged);
	HookConVarChange(g_msgchangeteam, OnSettingsChanged);
	HookConVarChange(g_msgcvar, OnSettingsChanged);
	HookConVarChange(g_msgmoney, OnSettingsChanged);
	HookConVarChange(g_msgsavedby, OnSettingsChanged);
	HookConVarChange(g_msgteamattack, OnSettingsChanged);
	HookConVarChange(g_msgchangename, OnSettingsChanged);
	HookConVarChange(g_forceend, OnSettingsChanged);
	HookConVarChange(g_blockchicken, OnSettingsChanged);
	HookConVarChange(g_blockweapondrop, OnSettingsChanged);
	HookConVarChange(g_showtime, OnSettingsChanged);
	HookConVarChange(g_blockautomute, OnSettingsChanged);
	HookConVarChange(g_blockfootsteps, OnSettingsChanged);
	HookConVarChange(g_blockjumpland, OnSettingsChanged);
	HookConVarChange(g_blockroundendsound, OnSettingsChanged);
	HookConVarChange(g_blockradiostartround, OnSettingsChanged);
	HookConVarChange(g_blockfalldamage, OnSettingsChanged);
	HookConVarChange(Cvar_ListX, OnConVarChange);	
	HookConVarChange(Cvar_ListY, OnConVarChange);	
	HookConVarChange(Cvar_ListColor, OnConVarChange);
	AddTempEntHook("Blood Sprite", TE_OnWorldDecal);
	AddTempEntHook("Entity Decal", TE_OnWorldDecal);
	AddTempEntHook("EffectDispatch", TE_OnEffectDispatch);
	AddTempEntHook("World Decal", TE_OnWorldDecal);
	AddTempEntHook("Impact", TE_OnWorldDecal);
	
	AddNormalSoundHook(Call_Back_Radio);
	AddNormalSoundHook(Call_Back_Sound);
	HookEvent("player_hurt", PlayerHurt_Event, EventHookMode_Pre);
	
	g_eenable = GetConVarBool(g_enable);
	HookConVarChange(g_enable, CvarChanged);
	
	
	g_botQuota = GetConVarInt(g_Cvar_BotQuota);
	HookConVarChange(g_Cvar_BotQuota, CvarChanged);
	
	if (!g_delayenable && g_hookenabled == false) {
	HookEvent("player_team", Event_PlayerTeam);
	g_hookenabled = true;
	}
	
	AddCommandListener(Command_Ping, "chatwheel_ping");
	AddCommandListener(Command_Ping, "player_ping");
	AddCommandListener(Command_Ping, "playerradio");
	AddCommandListener(Command_Ping, "playerchatwheel");
	
	Cheats 	   = FindConVar("sv_cheats");
	
	if (Cheats != null)
	{
		SetConVarBool(Cheats, false, true, false);
		HookConVarChange(Cheats, CCheats);
	}
	
	
	for (int i = 0; i < sizeof(RadioArray); i++)
		AddCommandListener(OnRadio, RadioArray[i]);
	
	
	g_ConVarHibernate = FindConVar("sv_hibernate_when_empty");
	g_ownerOffset = FindSendPropInfo("CBaseCombatWeapon", "m_hOwnerEntity");
	BuildPath(Path_SM, g_sLogPath, sizeof(g_sLogPath), "logs/Game_Manager.log");
	
	RemoveCrashLog();
	GetCvars();
	LoadCfg();
}

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
	hPluginMe = myself;
	if( late )
	{
		g_bServerStarted = true;
	}
	return APLRes_Success;
}


public int OnSettingsChanged(Handle convar, const char[] oldValue, const char[] newValue)
{
	if(convar == g_enable)
	{
		g_benable = g_enable.BoolValue;
	}

	if (convar == g_radar )
	{
		g_bradar   = g_radar.BoolValue;
	}
	
	if(convar == g_moneyhud)
	{
		g_bmoneyhud = g_moneyhud.BoolValue;
	}
	
	if(convar == g_killfeed)
	{
		g_bkillfeed = g_killfeed.BoolValue;
	}
	
	if(convar == g_blockradioagent)
	{
		g_bblockradioagent = g_blockradioagent.BoolValue;
	}
	
	if(convar == g_blockwhell)
	{
		g_bblockwhell = g_blockwhell.BoolValue;
	}
	
	if(convar == g_blockclantag)
	{
		g_bblockclantag = g_blockclantag.BoolValue;
	}
	
	if(convar == g_cheats)
	{
		g_bcheats = g_cheats.BoolValue;
	}
	
	if(convar == g_msgconnect)
	{
		g_bmsgconnect = g_msgconnect.BoolValue;
	}
	
	if(convar == g_msgdisconnect)
	{
		g_bmsgdisconnect = g_msgdisconnect.BoolValue;
	}
	
	if(convar == g_msgjointeam)
	{
		g_bmsgjointeam = g_msgjointeam.BoolValue;
	}
	
	if(convar == g_msgchangeteam)
	{
		g_bmsgchangeteam = g_msgchangeteam.BoolValue;
	}
	
	if(convar == g_msgcvar)
	{
		g_bmsgcvar = g_msgcvar.BoolValue;
	}
	
	if(convar == g_msgmoney)
	{
		g_bmsgmoney = g_msgmoney.BoolValue;
	}
	
	if(convar == g_msgsavedby)
	{
		g_bmsgsavedby = g_msgsavedby.BoolValue;
	}
	
	if(convar == g_msgteamattack)
	{
		g_bmsgteamattack = g_msgteamattack.BoolValue;
	}
	
	if(convar == g_msgchangename)
	{
		g_bmsgchangename = g_msgchangename.BoolValue;
	}
	
	if(convar == g_forceend)
	{
		g_bforceend = g_forceend.BoolValue;
	}
	
	if(convar == g_blockchicken)
	{
		g_bblockchicken = g_blockchicken.BoolValue;
	}
	
	if(convar == g_blockweapondrop)
	{
		g_bblockweapondrop = g_blockweapondrop.BoolValue;
	}
	
	if(convar == g_showtime)
	{
		g_bshowtime = g_showtime.BoolValue;
	}
	
	if(convar == g_blockautomute)
	{
		g_bblockautomute = g_blockautomute.BoolValue;
	}
	
	if(convar == g_blockfootsteps)
	{
		g_bblockfootsteps = g_blockfootsteps.BoolValue;
	}
	
	if(convar == g_blockjumpland)
	{
		g_bblockjumpland = g_blockjumpland.BoolValue;
	}
	
	if(convar == g_blockroundendsound)
	{
		g_bblockroundendsound = g_blockroundendsound.BoolValue;
	}
	
	if(convar == g_blockradiostartround)
	{
		g_bblockradiostartround = g_blockradiostartround.BoolValue;
	}
	
	if(convar == g_blockfalldamage)
	{
		g_bblockfalldamage = g_blockfalldamage.BoolValue;
	}
	
	LoadCfg();
	
	return 0;
}


public Action Event_RoundStart(Event event, const char[] name, bool quite)
{
	if (!g_benable || !g_bblockroundendsound) return Plugin_Continue;
	
	if (!quite) 
	{ 
		SetEventBroadcast(event, true); 
	}
	return Plugin_Changed;
}


public Action Event_RoundEnd(Event event, const char[] name, bool quite)
{
	if (!g_benable || !g_bblockroundendsound) return Plugin_Continue;
	
	if (!quite) 
	{ 
		SetEventBroadcast(event, true); 
	}
	return Plugin_Changed;
}

public void OnConfigsExecuted()
{

	g_benable = GetConVarBool(g_enable);
	g_bradar = GetConVarBool(g_radar);
	g_bmoneyhud = GetConVarBool(g_moneyhud);
	g_bkillfeed = GetConVarBool(g_killfeed);
	g_bblockradioagent = GetConVarBool(g_blockradioagent);
	g_bblockwhell = GetConVarBool(g_blockwhell);
	g_bblockclantag = GetConVarBool(g_blockclantag);
	g_bcheats = GetConVarBool(g_cheats);
	g_bmsgconnect = GetConVarBool(g_msgconnect);
	g_bmsgdisconnect = GetConVarBool(g_msgdisconnect);
	g_bmsgjointeam = GetConVarBool(g_msgjointeam);
	g_bmsgchangeteam = GetConVarBool(g_msgchangeteam);
	g_bmsgcvar = GetConVarBool(g_msgcvar);
	g_bmsgmoney = GetConVarBool(g_msgmoney);
	g_bmsgsavedby = GetConVarBool(g_msgsavedby);
	g_bmsgteamattack = GetConVarBool(g_msgteamattack);
	g_bmsgchangename = GetConVarBool(g_msgchangename);
	g_bforceend = GetConVarBool(g_forceend);
	g_bblockchicken = GetConVarBool(g_blockchicken);
	g_bblockweapondrop = GetConVarBool(g_blockweapondrop);
	g_bshowtime = GetConVarBool(g_showtime);
	g_bblockautomute = GetConVarBool(g_blockautomute);
	g_bblockfootsteps = GetConVarBool(g_blockfootsteps);
	g_bblockjumpland = GetConVarBool(g_blockjumpland);
	g_bblockroundendsound = GetConVarBool(g_blockroundendsound);
	g_bblockradiostartround = GetConVarBool(g_blockradiostartround);
	g_bblockfalldamage = GetConVarBool(g_blockfalldamage);
	
	char acmConfigToExecValue[32];
	GetConVarString(rotation_config_to_exec, acmConfigToExecValue, sizeof(acmConfigToExecValue));
	if (rotationMapChangeOccured && strcmp(acmConfigToExecValue, "") != 0)
	{
		PrintToServer("Game_Manager : Exec'ing %s.", acmConfigToExecValue);
		ServerCommand("exec %s", acmConfigToExecValue);
	}

	minutesBelowClientLimit = 0;
	rotationMapChangeOccured = false;

	CreateTimer(60.0, CheckPlayerCount, _, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
	

	if( g_bStartRandomMap && !g_bServerStarted)
	{
		g_bServerStarted = true;
		ChangeMap("Server is restarted");
	}
	if( g_ConVarHibernate != null )
	{
		g_iHybernateInitial = g_ConVarHibernate.IntValue;
		g_ConVarHibernate.SetInt(0);
	}
	
	LoadCfg();
}

void ChangeMap(char[] reason)
{
	char sMap[64];
	SetRandomSeed(GetTime());
	
	ArrayList al = new ArrayList(ByteCountToCells(sizeof(sMap)));
	
	delete al;
	LogToFileEx(g_sLogPath, "Changing map to: %s... Reason: %s", sMap, reason);
	if( CommandExists("sm_map") )
	{
		ServerCommand("sm_map %s", sMap);
	}
	else {
		ForceChangeLevel(sMap, reason);
	}
}


void LoadCfg()
{
	if( g_benable )
	{
		if( g_bmoneyhud )
		{
			SetConVarInt(FindConVar("mp_playercashawards"), 0);
			SetConVarInt(FindConVar("mp_teamcashawards"), 0);
		}else
		
		if( !g_bmoneyhud )
		{
			SetConVarInt(FindConVar("mp_playercashawards"), 1);
			SetConVarInt(FindConVar("mp_teamcashawards"), 1);
		}

		if (g_msgsshorthanded.IntValue == 0) 
		{
			ServerCommand("cash_team_bonus_shorthanded 1");
		}else
		
		if (g_msgsshorthanded.IntValue == 1) 
		{
			ServerCommand("cash_team_bonus_shorthanded 0");
		}
		
		if (g_blockradionade.IntValue == 0) 
		{
			ServerCommand("sv_ignoregrenaderadio 0");
		}else
		
		if (g_blockradionade.IntValue == 1)
		{
			ServerCommand("sv_ignoregrenaderadio 1");
		}
		
		if( g_bradar )
		{
			ServerCommand("sv_disable_radar 1");
		}else

		if( !g_bradar )
		{
			ServerCommand("sv_disable_radar 0");
		}
		
		if( g_bblockfalldamage )
		{
			ServerCommand("sv_falldamage_scale 0");
		}else

		if( !g_bblockfalldamage )
		{
			ServerCommand("sv_falldamage_scale 1");
		}

		if( g_bblockjumpland )
		{
			ServerCommand("sv_min_jump_landing_sound 999999");
		}else

		if( !g_bblockjumpland )
		{
			ServerCommand("sv_min_jump_landing_sound 260");
		}

		if( g_bblockfootsteps )
		{
			ServerCommand("sm_cvar sv_footsteps 0");
		}else

		if( !g_bblockfootsteps )
		{
			ServerCommand("sm_cvar sv_footsteps 1");
		}

		if( g_bblockautomute )
		{
			ServerCommand("sm_cvar sv_mute_players_with_social_penalties 0");
		}else

		if( !g_bblockautomute )
		{
			ServerCommand("sm_cvar sv_mute_players_with_social_penalties 1");
		}
	}
}

public void OnMapStart()
{
	if (g_delayenable && g_hookenabled == false) {
		g_botDelay = GetConVarInt(g_Cvar_BotDelay);
		bot_delay_timer = CreateTimer(g_botDelay * 1.0, Timer_BotDelay);
	}
	
	CreateTimer(1.0, CheckRemainingTime, INVALID_HANDLE, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
}

public void OnMapEnd() {
	if (g_delayenable && g_hookenabled == true) {
		UnhookEvent("player_team", Event_PlayerTeam);
		g_hookenabled = false;
	}

	if(bot_delay_timer != INVALID_HANDLE) {
		KillTimer(bot_delay_timer);
		bot_delay_timer = INVALID_HANDLE;
	}
}

public Action Event_PlayerDeath(Event event, const char[] name, bool dontBroadcast)
{

	if( g_benable )
	{
		if( g_bkillfeed )
		{
			event.BroadcastDisabled = true;
		}
	} else {
		if( !g_bkillfeed )
		{
			event.BroadcastDisabled = false;
		}
	}
	
	return Plugin_Continue;
}

public Action Timer_Wep(Handle timer)
{
	int maxEntities;
	maxEntities = GetMaxEntities();
	char classx[20];
	if (!g_benable || !g_bblockweapondrop) return Plugin_Continue;

	int j;
	for (j = MaxClients + 1; j < maxEntities; j++)
	{
		if (IsValidEdict(j) && (GetEntDataEnt2(j, g_ownerOffset) == -1))
		{
			GetEdictClassname(j, classx, sizeof(classx));
			if ((StrContains(classx, "weapon_") != -1) || (StrContains(classx, "item_") != -1))
			{
				AcceptEntityInput(j, "Kill");
			}
		}
	}
	return Plugin_Continue;
}

public Action OnRadio(int client, const char[] command, int args)
{
	return (g_benable &&  g_bblockradioagent) ?
		Plugin_Handled : 
		Plugin_Continue;
}

public Action OnRadioText(UserMsg msg_id, Protobuf bf, const int[] players, int playersNum, bool reliable, bool init)
{
	return (g_benable &&  g_bblockradioagent) ?
		Plugin_Handled : 
		Plugin_Continue;
}

public Action Command_Ping(int iClient, char[] command, int args)
{
	return (g_benable && g_bblockwhell) ?
		Plugin_Handled : 
		Plugin_Continue;
}


public Action OnClientCommandKeyValues(int client, KeyValues kv)
{
	if (!g_benable || !g_bblockclantag)return Plugin_Continue;
	
	char sSection[16];
	if (kv.GetSectionName(sSection, sizeof(sSection)) && StrEqual(sSection, "ClanTagChanged"))
		return Plugin_Handled;

	return Plugin_Continue;
}

public int CCheats(Handle cvar, char[] oldValue, char[] newValue)
{
	bool Status;
	if ((g_benable && g_bcheats) && (Status = GetConVarBool(Cheats)))
		CreateTimer(0.1, CCheats_Delay, !Status);
	return 0;
}

public Action CCheats_Delay(Handle hTimer, any NewStatus)
{
	SetConVarBool(Cheats, NewStatus, true, false);
	return Plugin_Continue;
}

public Action OnPlayerConnect(Handle hEvent, const char[] name, bool dontBroadcast) 
{
	return (g_benable && g_bmsgconnect) ? 
		Plugin_Handled :
		Plugin_Continue;
}

public Action OnPlayerDisconnect(Handle hEvent, const char[] name, bool dontBroadcast) 
{
	return (g_benable && g_bmsgdisconnect) ? 
		Plugin_Handled :
		Plugin_Continue;
}

public Action OnPlayerTeam(Handle hEvent, const char[] name, bool dontBroadcast) 
{
	if (!GetEventBool(hEvent, "disconnect") && g_benable)
	{
		int iOldTeam = GetEventInt(hEvent, "oldteam");
		
		if ((g_bmsgjointeam && iOldTeam == 0)
			|| (g_bmsgchangeteam && iOldTeam != 0))
				SetEventBool(hEvent, "silent", true);
	}
	
	return Plugin_Continue;
}

public Action OnServerCvar(Handle hEvent, const char[] name, bool dontBroadcast)
{
	return (g_benable && g_bmsgcvar) ? 
		Plugin_Handled :
		Plugin_Continue;
}

public Action OnHookTextMsg(UserMsg msg_id, Handle bf, int[] players, int playersNum, bool reliable, bool init)
{
	if (!g_benable || !g_bmsgmoney)return Plugin_Continue;

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
	if (!g_benable || !g_bmsgsavedby)return Plugin_Continue;

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
	if (!g_benable || !g_bmsgteamattack)return Plugin_Continue;

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
	if (!g_benable || !g_bmsgchangename)return Plugin_Continue;

	char buffer[25];
	
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

public Action CheckRemainingTime(Handle timer)
{
	if (!g_benable || !g_bforceend)return Plugin_Continue;
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
			case 1800: 	CPrintToChatAll("%t","min30");
			case 1200: 	CPrintToChatAll("%t","min20");
			case 600: 	CPrintToChatAll("%t","min10");
			case 300: 	CPrintToChatAll("%t","min5");
			case 120: 	CPrintToChatAll("%t","min2");
			case 60: 	CPrintToChatAll("%t","60sec");
			case 30: 	CPrintToChatAll("%t","30sec");
			case 15: 	CPrintToChatAll("%t","15sec");
			case -1: 	CPrintToChatAll("%t","3sec");
			case -2: 	CPrintToChatAll("%t","2sec");
			case -3: 	CPrintToChatAll("%t","1sec");
		}
		
		if(timeleft < -3)
			CS_TerminateRound(0.0, CSRoundEnd_Draw, true);
	}
	
	return Plugin_Continue;
}

public Action CS_OnTerminateRound(float &fDelay, CSRoundEndReason &iReason)
{
	if (!g_benable || !g_bforceend)return Plugin_Continue;
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
	if (!g_benable || !g_bblockchicken)return Plugin_Continue;
	if (!IsValidEntity(entity))
	{
		return Plugin_Continue;
	}
	
	RequestFrame(Frame_RemoveEntity, EntIndexToEntRef(entity));
	return Plugin_Continue;
}

public Action SDK_OnMapParametersSpawn(int entity)
{
	if (!g_benable || !g_bblockchicken)return Plugin_Continue;
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

public void OnConVarChange(Handle convar, const char[] oldValue, const char[] newValue)
{
	if(convar == Cvar_ListX)
	{
		g_ListX = StringToFloat(newValue);
		if( (g_ListX > 1.0 || g_ListX < 0) && g_ListX != -1.0)
		{
			PrintToServer("[Speclist] Error - Invalid X coordinate value: %f", g_ListX);
			g_ListX = 0.17;
		}
	}
	else if(convar == Cvar_ListY)
	{
		g_ListY = StringToFloat(newValue);
		if( (g_ListY > 1.0 || g_ListY < 0) && g_ListY != -1.0)
		{
			PrintToServer("[Speclist] Error - Invalid Y coordinate value: %f", g_ListY);
			g_ListY = 0.01;
		}
	}
	else if(convar == Cvar_ListColor)
		StrToRGBA(newValue);
}

public Action Timeleft(Handle timer)
{
	if (!g_benable || !g_bshowtime)return Plugin_Continue;
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
				Format(message, sizeof(message), "%t %s", "timerhud", sTime);
				SetHudTextParams(g_ListX, g_ListY, 1.0, g_iListColor[0], g_iListColor[1], g_iListColor[2], g_iListColor[3], 0, 0.00, 0.00, 0.00);
				ShowHudText(i, -1, message);
			}
		}
	}
	return Plugin_Continue;
}
void StrToRGBA(const char[] Color)
{
	char buffer[4][16];

	if(ExplodeString(Color, " ", buffer, sizeof(buffer), sizeof(buffer[])) > 3)
	{
		for(int i = 0; i < 4; i++)
		{
			g_iListColor[i] = StringToInt(buffer[i], 10);
			if(g_iListColor[i] > 255 || g_iListColor[i] < 0)
			{
				g_iListColor[i] = 255;
				PrintToServer("[Speclist] Error - RGBA[%d]=%d is not in the range 0-255", i, g_iListColor[i]);
			}
		}
	}
	else
	{
		g_iListColor = {255, 255, 255, 150};
		PrintToServer("[Speclist] Error - Invalid color format: %s", Color);
	}
}

public Action Call_Back_Radio(int clients[MAXPLAYERS], int &numClients, char sample[PLATFORM_MAX_PATH], int &entity, int &channel, float &volume, int &level, int &pitch, int &flags, char soundEntry[PLATFORM_MAX_PATH], int &seed)
{
	if (IsValidEdict(entity) && IsValidEntity(entity))
    {
		if (g_benable)
		{
			if (g_bblockradiostartround)
			{
				if (StrContains(sample, "request_move") != -1 || StrContains(sample, "round_start") != -1|| StrContains(sample, "radiobotstart") != -1 || StrContains(sample, "letsgo") != -1 || StrContains(sample, "locknload") != -1)
				{
					return Plugin_Handled;
				}
			}
		}
	}
	return Plugin_Continue;
}

public Action Event_PreRoundStart(Handle event, const char[] name, bool dontBroadcast)
{
    int T_Count = GetTeamClientCount(CS_TEAM_T);
    int CT_Count = GetTeamClientCount(CS_TEAM_CT);
    
    if(!g_benable || !GetConVarBool(g_balance) || T_Count == CT_Count || T_Count + 1 == CT_Count || CT_Count + 1 == T_Count)
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

public void CvarChanged(Handle cvar, const char[] oldValue, const char[] newValue){
	if (cvar == g_enable) {
		g_eenable = GetConVarBool(g_enable);
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

public Action Timer_BotDelay(Handle timer) {
	RecalcTeamCount();
	CheckBalance();
	HookEvent("player_team", Event_PlayerTeam);
	g_hookenabled = true;

	bot_delay_timer = INVALID_HANDLE;
	return Plugin_Continue;
}

void RecalcTeamCount() {
	g_Tcount = 0;
	g_CTcount = 0;
	g_BotTcount = 0;
	g_BotCTcount = 0;
	for( int i = 1; i <= MaxClients; i++ ) {
		if (IsClientInGame(i)) {
			ChangeTeamCount(GetClientTeam(i), 1, IsFakeClient(i));
		}
	}
}

void ChangeTeamCount(int team, int diff, bool isBot) {
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
public void Event_PlayerTeam(Event event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(GetEventInt(event, "userid"));
	int oldTeam = GetEventInt(event, "oldteam");
	int newTeam = GetEventInt(event, "team");
	bool disconnect = GetEventBool(event, "disconnect");

	if (!disconnect) {
		ChangeTeamCount(oldTeam, -1, IsFakeClient(client));
		ChangeTeamCount(newTeam, 1, IsFakeClient(client));
	} else {
		RecalcTeamCount();
	}

	CheckBalance();
}

void CheckBalance() {
	if (!g_eenable || (g_botQuota <= 0)) {
		return;
	}

	int bots = g_BotTcount + g_BotCTcount;
	int humans = g_Tcount + g_CTcount;

	if (bots > 0 && humans == 0) {
		ServerCommand("bot_kick all");
	} else if (humans >= g_botQuota && bots > 0) {
		ServerCommand("bot_kick");
	} else if (humans < g_botQuota) {
		int botQuota = g_botQuota - humans;
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

public Action TE_OnEffectDispatch(const char[] te_name, const int[] Players, int numClients, float delay)
{
	if (!g_benable || !g_cEnableNoSplatter.BoolValue) return Plugin_Continue;

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

public Action TE_OnWorldDecal(const char[] te_name, const int[] Players, int numClients, float delay)
{
	if (!g_benable || !g_cEnableNoBlood.BoolValue) return Plugin_Continue;

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

public Action PlayerHurt_Event(Event event, const char[] name, bool dontBroadcast)
{
	int attacker = GetClientOfUserId(event.GetInt("attacker"));
	
	g_phitted[attacker] = true;
	
	return Plugin_Continue;
}

public Action Call_Back_Sound(int clients[MAXPLAYERS], int &numClients, char sample[PLATFORM_MAX_PATH], int &entity, int &channel, float &volume, int &level, int &pitch, int &flags, char soundEntry[PLATFORM_MAX_PATH], int &seed)
{
	char classname[64];
	GetEdictClassname(entity, classname, sizeof(classname));
	
	if (IsValidEdict(entity) && IsValidEntity(entity))
    {
		if(StrContains(sample, "flesh") != -1 || StrContains(sample, "kevlar") != -1)
		{
		if (GetConVarBool(g_enable))
			{
		if (GetConVarBool(g_knifesound))
			{
			numClients = 0;
			
			return Plugin_Changed;
			}
		}
		}
		
		if(StrContains(classname, "knife") != -1)
		{
			int client = GetEntPropEnt(entity, Prop_Send, "m_hOwnerEntity");
			
			if(!IsValidClient(client, false))
				return Plugin_Continue;
			
			if(g_phitted[client])
			{
				g_phitted[client] = false;
				return Plugin_Continue;
			}
			
			if (GetConVarBool(g_enable))
			{
			if (GetConVarBool(g_knifesound))
			{
			numClients = 0;
			
			g_phitted[client] = false;
			}
			}
			return Plugin_Changed;
		}
	}
	return Plugin_Continue;
}

stock bool IsValidClient(int client, bool botcheck = true)
{
	return (1 <= client && client <= MaxClients && IsClientConnected(client) && IsClientInGame(client) && (botcheck ? !IsFakeClient(client) : true)); 
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

public Action CheckPlayerCount(Handle timer)
{
	int acmClientLimitValue = GetConVarInt(rotation_client_limit);
	
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
	if(GetConVarBool(rotation_enable))
	{
		if (minutesBelowClientLimit >= GetConVarInt(rotation_time_limit))
		{
			SetMap();
		}
	}
	
	return Plugin_Continue;
}

void SetMap()
{

	int acmModeValue = GetConVarInt(rotation_mode);
	char nextmap[32];

	switch(acmModeValue)
	{
		case 1:
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
			
			int mapCount = GetArraySize(g_MapList);
			
			if (g_MapPos == -1)
			{
				char current[64];
				GetCurrentMap(current, 64);
				
				for (int i = 0; i < mapCount; i++)
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
		
		case 2:
		{
			Handle h_sm_nextmap = FindConVar("sm_nextmap");

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

		case 3:
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
	Handle nextmapPack;
	CreateDataTimer(5.0, ChangeMapp, nextmapPack, TIMER_FLAG_NO_MAPCHANGE);
	WritePackString(nextmapPack, nextmap);
	PrintToChatAll("Game_Manager : Changing map to %s.", nextmap);
	
}

public Action ChangeMapp(Handle timer, Handle mapPack)
{
	char map[32];
	ResetPack(mapPack);
	ReadPackString(mapPack, map, sizeof(map));
	rotationMapChangeOccured = true;
	ServerCommand("changelevel %s", map);
	return Plugin_Continue;
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
