#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>
#include <cstrike>
#include <clientprefs>
#include <multicolors>
#include <sdktools>
#include <sdkhooks>
#include <sdktools_functions>

#define CFG_NAME "Game_Manager"
#define TEAM_NONE 0
#define TEAM_SPEC 1
#define TEAM_T 2
#define TEAM_CT 3
#define HIDEHUD_CHAT ( 1<<7 )

ConVar g_enable;
ConVar g_knifesound;
ConVar g_hssound;
ConVar g_deathsound;
ConVar g_hsdeathsound;
ConVar g_blockdeadbody;
ConVar g_timedeadbody;
ConVar g_balance;
ConVar g_msgsshorthanded;
ConVar g_radar;
ConVar g_moneyhud;
ConVar g_killfeed;
ConVar g_chathud;
ConVar g_blockradioagent;
ConVar g_blockradionade;
ConVar g_blockradiochat;
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
ConVar g_msgschicken;
ConVar g_forceend;
ConVar g_blockchicken;
ConVar g_blockweapondrop;
ConVar g_showtime;
ConVar g_blockautomute;
ConVar g_blockfootsteps;
ConVar g_blockjumpland;
ConVar g_blockroundendsound;
ConVar g_blockroundendpanel;
ConVar g_blockradiostartround;
ConVar g_blockfalldamage;
ConVar Cvar_ListX;
ConVar Cvar_ListY;
ConVar Cvar_ListColor;
ConVar g_cEnableNoBlood;
ConVar g_cEnableNoSplatter;
ConVar g_ConVarEnable;
ConVar g_ConVarMethod;
ConVar g_ConVarDelay;
ConVar g_ConVarHibernate;
ConVar gcv_force = null;
ConVar gcv_force2 = null;
ConVar gcv_force3 = null;
ConVar gcv_force4 = null;
ConVar gcv_force5 = null;
ConVar gcv_force6 = null;
ConVar gcv_force7 = null;
ConVar gcv_force8 = null;
ConVar gcv_force9 = null;

Handle c_ToggleTimeHud;
Handle hPluginMe;
Handle g_Cvar_BotDelay;
Handle g_Cvar_BotDelayEnable = INVALID_HANDLE;
Handle g_Cvar_BotQuota = INVALID_HANDLE;
Handle bot_delay_timer = INVALID_HANDLE;
Handle rotation_enable = INVALID_HANDLE;
Handle rotation_client_limit = INVALID_HANDLE;
Handle rotation_include_bots = INVALID_HANDLE;
Handle rotation_time_limit = INVALID_HANDLE;
Handle rotation_mode = INVALID_HANDLE;
Handle rotation_default_map = INVALID_HANDLE;
Handle rotation_config_to_exec = INVALID_HANDLE;
Handle g_MapList = INVALID_HANDLE;

int g_MapPos;
int g_MapListSerial;
int minutesBelowClientLimit;
int g_ownerOffset;
int g_iCvarMethod;
int g_iHybernateInitial;
int g_Tcount = 0;
int g_CTcount = 0;
int g_BotTcount = 0;
int g_BotCTcount = 0;
int g_botQuota = 0;
int g_botDelay = 1;
int g_bshowtime = 0;
int g_iListColor[4];

float g_ListX;
float g_ListY;
float g_fCvarDelay;

bool rotationMapChangeOccured;
bool g_bCvarEnabled;
bool g_bStartRandomMap;
bool g_bServerStarted;
bool g_delayenable = false;
bool g_bknifesound = false;
bool g_eenable = false;
bool g_hookenabled = false;
bool g_bblockdeadbody = false;
bool g_benable = false;
bool g_bblockradionade = false;
bool g_bbalance = false;
bool g_bradar = false;
bool g_bmoneyhud = false;
bool g_bkillfeed = false;
bool g_bchathud = false;
bool g_bblockradioagent = false;
bool g_bblockradiochat = false;
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
bool g_bblockautomute = false;
bool g_bblockfootsteps = false;
bool g_bblockjumpland = false;
bool g_bblockroundendsound = false;
bool g_bblockroundendpanel = false;
bool g_bblockradiostartround = false;
bool g_bblockfalldamage = false;
bool g_bdeathsound = false;
bool g_bhsdeathsound = false;
bool g_bmsgschicken = false;
bool g_bhssound = false;
bool ToggleTimeHud[MAXPLAYERS+1];
bool g_phitted[MAXPLAYERS];

char g_sLogPath[PLATFORM_MAX_PATH];

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
	"deathcry"
};

char MoneyMessageArray[][] =
{
	"#Player_Cash_Award_Kill_Teammate",
	"#Player_Cash_Award_Killed_VIP",
	"#Player_Cash_Award_Killed_Enemy_Generic",
	"#Player_Cash_Award_Killed_Enemy",
	"#Player_Cash_Award_Bomb_Planted",
	"#Player_Cash_Award_Bomb_Defused",
	"#Player_Cash_Award_Rescued_Hostage",
	"#Player_Cash_Award_Interact_Hostage",
	"#Player_Cash_Award_Respawn",
	"#Player_Cash_Award_Get_Killed",
	"#Player_Cash_Award_Damage_Hostage",
	"#Player_Cash_Award_Kill_Hostage",
	"#Player_Point_Award_Killed_Enemy",
	"#Player_Point_Award_Killed_Enemy_Plural",
	"#Player_Point_Award_Killed_Enemy_NoWeapon",
	"#Player_Point_Award_Killed_Enemy_NoWeapon_Plural",
	"#Player_Point_Award_Assist_Enemy",
	"#Player_Point_Award_Assist_Enemy_Plural",
	"#Player_Point_Award_Picked_Up_Dogtag",
	"#Player_Point_Award_Picked_Up_Dogtag_Plural",
	"#Player_Team_Award_Killed_Enemy",
	"#Player_Team_Award_Killed_Enemy_Plural",
	"#Player_Team_Award_Bonus_Weapon",
	"#Player_Team_Award_Bonus_Weapon_Plural",
	"#Player_Team_Award_Picked_Up_Dogtag",
	"#Player_Team_Award_Picked_Up_Dogtag_Plural",
	"#Player_Team_Award_Picked_Up_Dogtag_Friendly",
	"#Player_Cash_Award_ExplainSuicide_YouGotCash",
	"#Player_Cash_Award_ExplainSuicide_TeammateGotCash",
	"#Player_Cash_Award_ExplainSuicide_EnemyGotCash",
	"#Player_Cash_Award_ExplainSuicide_Spectators",
	"#Team_Cash_Award_T_Win_Bomb",
	"#Team_Cash_Award_Elim_Hostage",
	"#Team_Cash_Award_Elim_Bomb",
	"#Team_Cash_Award_Win_Time",
	"#Team_Cash_Award_Win_Defuse_Bomb",
	"#Team_Cash_Award_Win_Hostages_Rescue",
	"#Team_Cash_Award_Win_Hostage_Rescue",
	"#Team_Cash_Award_Loser_Bonus",
	"#Team_Cash_Award_Bonus_Shorthanded",
	"#Team_Cash_Award_Loser_Bonus_Neg",
	"#Team_Cash_Award_Loser_Zero",
	"#Team_Cash_Award_Rescued_Hostage",
	"#Team_Cash_Award_Hostage_Interaction",
	"#Team_Cash_Award_Hostage_Alive",
	"#Team_Cash_Award_Planted_Bomb_But_Defused",
	"#Team_Cash_Award_Survive_GuardianMode_Wave",
	"#Team_Cash_Award_CT_VIP_Escaped",
	"#Team_Cash_Award_T_VIP_Killed",
	"#Team_Cash_Award_no_income",
	"#Team_Cash_Award_no_income_suicide",
	"#Team_Cash_Award_Generic",
	"#Team_Cash_Award_Custom"
};

char SavedbyArray[][] =
{
	"#Chat_SavePlayer_Savior",
    "#Chat_SavePlayer_Spectator",
    "#Chat_SavePlayer_Saved"
};

char TeamWarningArray[][] =
{
	"#Cstrike_TitlesTXT_Game_teammate_attack",
	"#Cstrike_TitlesTXT_Game_teammate_kills",
	"#Cstrike_TitlesTXT_Hint_careful_around_teammates",
	"#Cstrike_TitlesTXT_Hint_try_not_to_injure_teammates",
	"#Cstrike_TitlesTXT_Killed_Teammate",
	"#SFUI_Notice_Game_teammate_kills",
	"#SFUI_Notice_Hint_careful_around_teammates",
	"#SFUI_Notice_Killed_Teammate"
};

public Plugin myinfo = 
{
	name = "[CS:GO] Game Manager",
	author = "Gold KingZ",
	description = "Game Manager ( Hide radar, money, messages, ping, and more )",
	version     = "1.1.0",
	url = "https://github.com/oqyh"
}

public void OnPluginStart()
{
	LoadTranslations( "Game_Manager.phrases" );
	
	CreateTimer(1.0, Timeleft, _, TIMER_REPEAT);
	CreateTimer(1.0, Timer_Wep, 0, TIMER_REPEAT);
	
	if (GetEngineVersion() != Engine_CSGO)
	{
		SetFailState("This plugin is for CSGO Only");
		return;
	}
	
	g_enable = CreateConVar("gm_enable_hide_and_block"		  	 , "1", ".::[Enable Hide And Block Feature]::. || 1= Yes || 0= No", _, true, 0.0, true, 1.0);
	g_radar = CreateConVar("gm_hide_radar"		     , "0", "Hide Radar (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No", _, true, 0.0, true, 1.0);
	g_moneyhud = CreateConVar("gm_hide_moneyhud"		     , "0", "Hide Money Hud (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No", _, true, 0.0, true, 1.0);
	g_killfeed = CreateConVar("gm_hide_killfeed"		     , "0", "Hide Kill Feed (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No", _, true, 0.0, true, 1.0);
	g_chathud = CreateConVar("gm_hide_chathud"		     , "0", "Hide Chat Hud (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No", _, true, 0.0, true, 1.0);
	g_blockradiostartround = CreateConVar("gm_block_radio_start_agents"		     , "0", "Block Round Start Radio Sounds (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No", _, true, 0.0, true, 1.0);
	g_blockradioagent = CreateConVar("gm_block_radio_voice_agents"		     , "0", "Block All Radio Voice Agents (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No", _, true, 0.0, true, 1.0);
	g_blockradionade = CreateConVar("gm_block_radio_voice_grenades"		     , "0", "Block All Radio Voice Grenades Throw (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No", _, true, 0.0, true, 1.0);
	g_blockradiochat = CreateConVar("gm_block_radio_chat"		     , "0", "Block All Radio Text Chat (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No", _, true, 0.0, true, 1.0);
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
	g_msgschicken = CreateConVar("gm_block_chicken_message"		     , "0", "Hide Your Chicken Has Been Killed Messages (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No", _, true, 0.0, true, 1.0);

	g_forceend = CreateConVar("gm_forceendmap"		     , "0", "Force End Map With Command mp_timelimit (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No", _, true, 0.0, true, 1.0);
	g_blockchicken = CreateConVar("gm_block_chicken"		     , "0", "Permanently Remove Chickens (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No", _, true, 0.0, true, 1.0);
	g_blockdeadbody = CreateConVar("gm_block_deadbody"		     , "0", "Remove Dead Body (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No", _, true, 0.0, true, 1.0);
	g_timedeadbody = CreateConVar("gm_block_time_deadbody"		     , "2.0", "After How Much Time (In Sec) To Start Remove Dead Body (Need gm_block_deadbody 1)");
	g_blockweapondrop = CreateConVar("gm_block_weapon_drop"		     , "0", "Delete/Clean Weapons Dropped (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No", _, true, 0.0, true, 1.0);
	g_showtime = CreateConVar("gm_show_timeleft_hud"		     , "0", "Show Timeleft HUD (mp_timelimit)  (Need To Enable gm_enable_hide_and_block) || 3= Yes But Off By First Time Then Make it Togglable  || 2= Yes But On By First Time Then Make it Togglable || 1= Yes + Disable Togglable || 0= No", _, true, 0.0, true, 3.0);
	g_balance = CreateConVar("gm_auto_balance_every_round", "0", "Auto Balance Every Round (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No", _, true, 0.0, true, 1.0);
	g_Cvar_BotQuota = CreateConVar("gm_block_bots", "0", "Permanently Remove bots (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No", _, true, 0.0, true, 1.0);
	g_cEnableNoBlood = CreateConVar("gm_hide_blood"		     , "0", "Hide Blood (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No", _, true, 0.0, true, 1.0);
	g_cEnableNoSplatter = CreateConVar("gm_hide_splatter"		     , "0", "Hide Splatter Effect (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No", _, true, 0.0, true, 1.0);
	g_blockautomute = CreateConVar("gm_block_auto_mute"		     , "0", "Remove Auto Communication Penalties (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No", _, true, 0.0, true, 1.0);
	g_blockfootsteps = CreateConVar("gm_block_footsteps_sound"		     , "0", "Block Footsteps Sounds (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No", _, true, 0.0, true, 1.0);
	g_blockjumpland = CreateConVar("gm_block_jumpland_sound"		     , "0", "Block Jump Land Sounds (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No", _, true, 0.0, true, 1.0);
	g_blockroundendsound = CreateConVar("gm_block_roundend_sound"		     , "0", "Block Counter/Terrorist/Draw Win Sounds (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No", _, true, 0.0, true, 1.0);
	g_blockroundendpanel = CreateConVar("gm_block_roundend_panel"		     , "0", "Block Counter/Terrorist/Draw Win Panel  (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No", _, true, 0.0, true, 1.0);
	g_blockfalldamage = CreateConVar("gm_block_falldamage"		     , "0", "Disable Fall Damage + Fall Damage Sound (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No", _, true, 0.0, true, 1.0);
	g_knifesound = CreateConVar("gm_block_zero_knife_sound", "0", "Block Zero Damage Knife Sounds (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No", _, true, 0.0, true, 1.0);
	g_hssound = CreateConVar("gm_block_hsdamage_sound", "0", "Block HeadShot Hit Sound (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No", _, true, 0.0, true, 1.0);
	g_deathsound = CreateConVar("gm_block_death_sound", "0", "Block Death Sound (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No", _, true, 0.0, true, 1.0);
	g_hsdeathsound = CreateConVar("gm_block_hsdeath_sound", "0", "Block After Death HeadShot Sound (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No", _, true, 0.0, true, 1.0);
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


	//Command for timeleft with !vvvvv
	RegConsoleCmd("sm_showtimeleft", Command_HUD);
	RegConsoleCmd("sm_timeleft", Command_HUD);
	RegConsoleCmd("sm_showtime", Command_HUD);
	//Command for timeleft with !^^^^
	
	c_ToggleTimeHud = RegClientCookie("Game_Manager", "Client Cookie Toggle HUD ", CookieAccess_Protected);
	
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
	HookEvent("cs_win_panel_round", Event_WinPanel, EventHookMode_Pre);
	HookEvent("player_hurt", PlayerHurt_Event, EventHookMode_Pre);
	HookEvent("round_prestart", Event_PreRoundStart);
	HookEvent("player_spawn", Event_ChatHud);
	
	HookUserMessage(GetUserMessageId("RadioText"), OnRadioText, true);
	HookUserMessage(GetUserMessageId("TextMsg"), OnHookTextMsg, true);
	HookUserMessage(GetUserMessageId("TextMsg"), OnHookTextMsg2, true);
	HookUserMessage(GetUserMessageId("TextMsg"), OnHookTextMsg3, true);
	HookUserMessage(GetUserMessageId("SayText2"), OnHookTextMsg4, true);
	HookUserMessage(GetUserMessageId("TextMsg"), OnHookTextMsg5, true);
	
	HookConVarChange(g_enable, OnSettingsChanged);
	HookConVarChange(g_knifesound, OnSettingsChanged);
	HookConVarChange(g_hssound, OnSettingsChanged);
	HookConVarChange(g_deathsound, OnSettingsChanged);
	HookConVarChange(g_hsdeathsound, OnSettingsChanged);
	HookConVarChange(g_msgsshorthanded, OnSettingsChanged);
	HookConVarChange(g_radar, OnSettingsChanged);
	HookConVarChange(g_balance, OnSettingsChanged);
	HookConVarChange(g_moneyhud, OnSettingsChanged);
	HookConVarChange(g_killfeed, OnSettingsChanged);
	HookConVarChange(g_chathud, OnSettingsChanged);
	HookConVarChange(g_blockradioagent, OnSettingsChanged);
	HookConVarChange(g_blockradionade, OnSettingsChanged);
	HookConVarChange(g_blockdeadbody, OnSettingsChanged);
	HookConVarChange(g_blockradiochat, OnSettingsChanged);
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
	HookConVarChange(g_msgschicken, OnSettingsChanged);
	HookConVarChange(g_forceend, OnSettingsChanged);
	HookConVarChange(g_blockchicken, OnSettingsChanged);
	HookConVarChange(g_blockweapondrop, OnSettingsChanged);
	HookConVarChange(g_showtime, OnSettingsChanged);
	HookConVarChange(g_blockautomute, OnSettingsChanged);
	HookConVarChange(g_blockfootsteps, OnSettingsChanged);
	HookConVarChange(g_blockjumpland, OnSettingsChanged);
	HookConVarChange(g_blockroundendsound, OnSettingsChanged);
	HookConVarChange(g_blockroundendpanel, OnSettingsChanged);
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
	AddNormalSoundHook(Call_Back_Soundss);
	AddNormalSoundHook(Call_Back_Soundsss);
	AddNormalSoundHook(Call_Back_NadeSounds);
	AddNormalSoundHook(Call_Back_DeathSound);
	AddNormalSoundHook(Call_Back_Sounds);
	
	g_eenable = GetConVarBool(g_enable);
	HookConVarChange(g_enable, CvarChanged);
	
	gcv_force = FindConVar("sv_disable_radar");
	gcv_force.AddChangeHook(Onchanged);
	
	gcv_force2 = FindConVar("mp_playercashawards");
	gcv_force2.AddChangeHook(Onchanged2);
	gcv_force3 = FindConVar("mp_teamcashawards");
	gcv_force3.AddChangeHook(Onchanged2);
	
	gcv_force4 = FindConVar("cash_team_bonus_shorthanded");
	gcv_force4.AddChangeHook(Onchanged3);
	
	gcv_force5 = FindConVar("sv_falldamage_scale");
	gcv_force5.AddChangeHook(Onchanged4);
	gcv_force6 = FindConVar("sv_min_jump_landing_sound");
	gcv_force6.AddChangeHook(Onchanged5);
	gcv_force7 = FindConVar("sv_footsteps");
	gcv_force7.AddChangeHook(Onchanged6);
	gcv_force8 = FindConVar("sv_mute_players_with_social_penalties");
	gcv_force8.AddChangeHook(Onchanged7);
	
	gcv_force9 = FindConVar("sv_cheats");
	gcv_force9.AddChangeHook(Onchanged9);
	
	
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
	AddCommandListener(OnPlayerChat, "say");
	AddCommandListener(OnPlayerChat, "say_team");
	
	
	for (int i = 0; i < sizeof(RadioArray); i++)
		AddCommandListener(OnRadio, RadioArray[i]);
	
	
	g_ConVarHibernate = FindConVar("sv_hibernate_when_empty");
	g_ownerOffset = FindSendPropInfo("CBaseCombatWeapon", "m_hOwnerEntity");
	BuildPath(Path_SM, g_sLogPath, sizeof(g_sLogPath), "logs/Game_Manager.log");
	
	RemoveCrashLog();
	GetCvars();
	LoadCfg();
}

public void OnClientCookiesCached(int client)
{
	char sCookie[8];
	GetClientCookie(client,c_ToggleTimeHud, sCookie, sizeof(sCookie));
	ToggleTimeHud[client] = view_as<bool>(StringToInt(sCookie));
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

public void Onchanged(ConVar convar, const char[] oldValue, const char[] newValue)
{
	if( g_benable == true)
	{
		if(g_bradar == true)
		{
			if (StringToInt(newValue) != 1) {
			gcv_force.IntValue = 1;
			}
		}
	}
}

public void Onchanged2(ConVar convar, const char[] oldValue, const char[] newValue)
{
	if( g_benable == true)
	{
		if(g_bmoneyhud == true)
		{
			if (StringToInt(newValue) != 0) {
			gcv_force2.IntValue = 0;
			}
			
			if (StringToInt(newValue) != 0) {
			gcv_force3.IntValue = 0;
			}
		}
	}
}

public void Onchanged3(ConVar convar, const char[] oldValue, const char[] newValue)
{
	if( g_benable == true)
	{
		if (g_msgsshorthanded.IntValue == 1) 
		{
			if (StringToInt(newValue) != 0) {
			gcv_force4.IntValue = 0;
			}
		}
	}
}

public void Onchanged4(ConVar convar, const char[] oldValue, const char[] newValue)
{
	if( g_benable == true)
	{
		if( g_bblockfalldamage == true)
		{
			if (StringToInt(newValue) != 0) {
			gcv_force5.IntValue = 0;
			}
		}
	}
}

public void Onchanged5(ConVar convar, const char[] oldValue, const char[] newValue)
{
	if( g_benable == true)
	{
		if( g_bblockjumpland == true)
		{
			if (StringToInt(newValue) != 999999) {
			gcv_force6.IntValue = 999999;
			}
		}
	}
}

public void Onchanged6(ConVar convar, const char[] oldValue, const char[] newValue)
{
	if( g_benable == true)
	{
		if( g_bblockfootsteps == true)
		{
			if (StringToInt(newValue) != 0) {
			gcv_force7.IntValue = 0;
			}
		}
	}
}

public void Onchanged7(ConVar convar, const char[] oldValue, const char[] newValue)
{
	if( g_benable == true)
	{
		if( g_bblockautomute == true)
		{
			if (StringToInt(newValue) != 0) {
			gcv_force8.IntValue = 0;
			}
		}
	}
}

public void Onchanged9(ConVar convar, const char[] oldValue, const char[] newValue)
{
	if( g_benable == true)
	{
		if( g_bcheats == true)
		{
			if (StringToInt(newValue) != 0) {
			gcv_force9.IntValue = 0;
			}
		}
	}
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
	
	if (convar == g_balance )
	{
		g_bbalance   = g_balance.BoolValue;
	}
	
	if(convar == g_moneyhud)
	{
		g_bmoneyhud = g_moneyhud.BoolValue;
	}
	
	if(convar == g_killfeed)
	{
		g_bkillfeed = g_killfeed.BoolValue;
	}
	
	if(convar == g_chathud)
	{
		g_bchathud = g_chathud.BoolValue;
	}
	
	if(convar == g_knifesound)
	{
		g_bknifesound = g_knifesound.BoolValue;
	}
	
	if(convar == g_hssound)
	{
		g_bhssound = g_hssound.BoolValue;
	}

	if(convar == g_deathsound)
	{
		g_bdeathsound = g_deathsound.BoolValue;
	}
	
	if(convar == g_hsdeathsound)
	{
		g_bhsdeathsound = g_hsdeathsound.BoolValue;
	}
	
	if(convar == g_blockradioagent)
	{
		g_bblockradioagent = g_blockradioagent.BoolValue;
	}
	
	if(convar == g_blockradionade)
	{
		g_bblockradionade = g_blockradionade.BoolValue;
	}
	
	if(convar == g_blockradiochat)
	{
		g_bblockradiochat = g_blockradiochat.BoolValue;
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
	
	if(convar == g_msgschicken)
	{
		g_bmsgschicken = g_msgschicken.BoolValue;
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
		g_bshowtime = g_showtime.IntValue;
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
	
	if(convar == g_blockroundendpanel)
	{
		g_bblockroundendpanel = g_blockroundendpanel.BoolValue;
	}
	
	if(convar == g_blockdeadbody)
	{
		g_bblockdeadbody = g_blockdeadbody.BoolValue;
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

public void OnClientDisconnect_Post(int client)
{
    ToggleTimeHud[client] = false;
}

public Action Event_WinPanel(Event event, const char[] name, bool quite)
{
	if (!g_benable || !g_bblockroundendpanel) return Plugin_Continue;
	
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
	g_bknifesound = GetConVarBool(g_knifesound);
	g_bhssound = GetConVarBool(g_hssound);
	g_bdeathsound = GetConVarBool(g_deathsound);
	g_bhsdeathsound = GetConVarBool(g_hsdeathsound);
	g_bradar = GetConVarBool(g_radar);
	g_bbalance = GetConVarBool(g_balance);
	g_bmoneyhud = GetConVarBool(g_moneyhud);
	g_bkillfeed = GetConVarBool(g_killfeed);
	g_bchathud = GetConVarBool(g_chathud);
	g_bblockradioagent = GetConVarBool(g_blockradioagent);
	g_bblockradionade = GetConVarBool(g_blockradionade);
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
	g_bmsgschicken = GetConVarBool(g_msgschicken);
	g_bforceend = GetConVarBool(g_forceend);
	g_bblockchicken = GetConVarBool(g_blockchicken);
	g_bblockdeadbody = GetConVarBool(g_blockdeadbody);
	g_bblockweapondrop = GetConVarBool(g_blockweapondrop);
	g_bshowtime = GetConVarInt(g_showtime);
	g_bblockautomute = GetConVarBool(g_blockautomute);
	g_bblockfootsteps = GetConVarBool(g_blockfootsteps);
	g_bblockjumpland = GetConVarBool(g_blockjumpland);
	g_bblockroundendsound = GetConVarBool(g_blockroundendsound);
	g_bblockroundendpanel = GetConVarBool(g_blockroundendpanel);
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
		
		if( g_bradar )
		{
			ServerCommand("sv_disable_radar 1");
		}else

		if( !g_bradar )
		{
			ServerCommand("sv_disable_radar 0");
		}
		
		if( g_bcheats )
		{
			ServerCommand("sv_cheats 0");
		}else

		if( !g_cheats )
		{
			ServerCommand("sv_cheats 1");
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

		if( !g_bblockautomute || !g_benable)
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
	int client = GetClientOfUserId(GetEventInt(event, "userid"));
	
	if( g_benable )
	{
		if( g_bkillfeed )
		{
			event.BroadcastDisabled = true;
		}else if( !g_bkillfeed )
		{
			event.BroadcastDisabled = false;
		}
		
		if(g_bblockdeadbody)
		{
			if(IsClientValid(client))
			{
				CreateTimer(GetConVarFloat(g_timedeadbody), killbody, client);
			}
		}
	}
	
	return Plugin_Continue;
}

public Action killbody(Handle timer, any client)
{
	if (!g_benable || !g_bblockdeadbody)return Plugin_Continue;
	
	int ragdoll = GetEntPropEnt(client, Prop_Send, "m_hRagdoll");

	if (ragdoll<0)
	{
		return Plugin_Continue;
	}
	
	if(IsClientValid(client))
	{
		if (ragdoll && IsValidEntity(ragdoll))
		{
			AcceptEntityInput(ragdoll, "kill");
		}
	}
	return Plugin_Continue;
}

public Action Event_ChatHud(Event event, const char[] name, bool dontBroadcast)
{
	if (!g_benable || !g_bchathud) return Plugin_Continue;

	int userid = GetEventInt(event, "userid");
	CreateTimer(0.0, hide_chat, userid);

	return Plugin_Continue;
}

public Action hide_chat(Handle timer, any userid)
{
	int client = GetClientOfUserId(userid);

	if(client != 0 && IsClientInGame(client))
	{
		SetEntProp(client, Prop_Send, "m_iHideHUD", GetEntProp(client, Prop_Send, "m_iHideHUD")|HIDEHUD_CHAT);
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

public Action OnRadio(int client, const char[] command, int argc)
{
	if (!g_benable || !g_bblockradioagent) {
		return Plugin_Continue;
	} else {
		return Plugin_Handled;
	}
} 

public Action Call_Back_NadeSounds(int clients[64], int &numClients, char sample[PLATFORM_MAX_PATH], int &client, int &channel, float &volume, int &level, int &pitch, int &flags)
{
	if (!g_benable || !g_bblockradionade) return Plugin_Continue;
	
	if (StrContains(sample, "ct_decoy") != -1 || StrContains(sample, "ct_grenade") != -1 || StrContains(sample, "ct_flashbang") != -1 || StrContains(sample, "ct_molotov") != -1 || StrContains(sample, "ct_smoke") != -1 || StrContains(sample, "t_decoy") != -1 || StrContains(sample, "t_grenade") != -1 || StrContains(sample, "t_flashbang") != -1 || StrContains(sample, "t_molotov") != -1 || StrContains(sample, "t_smoke") != -1 || StrContains(sample, "throwing_decoy") != -1 || StrContains(sample, "throwing_fire") != -1 || StrContains(sample, "throwing_flashbang") != -1 || StrContains(sample, "throwing_grenade") != -1 || StrContains(sample, "throwing_molotov") != -1 || StrContains(sample, "throwing_smoke") != -1)
	{
		return Plugin_Handled;
	}
	
	return Plugin_Continue;
} 

public Action Call_Back_DeathSound(int clients[64], int &numClients, char sample[PLATFORM_MAX_PATH], int &client, int &channel, float &volume, int &level, int &pitch, int &flags)
{
	if (!g_benable || !g_bdeathsound) return Plugin_Continue;
	
	if (StrContains(sample, "death1") != -1 || StrContains(sample, "death2") != -1 || StrContains(sample, "death3") != -1 || StrContains(sample, "death4") != -1 || StrContains(sample, "death5") != -1 || StrContains(sample, "death6") != -1 || StrContains(sample, "death_fem_01") != -1 || StrContains(sample, "death_fem_02") != -1 || StrContains(sample, "death_fem_03") != -1 || StrContains(sample, "death_fem_04") != -1 || StrContains(sample, "death_fem_05") != -1 || StrContains(sample, "death_fem_06") != -1 || StrContains(sample, "death_fem_07") != -1 || StrContains(sample, "death_fem_08") != -1)
	{
		return Plugin_Handled;
	}
	
	return Plugin_Continue;
} 


public Action OnRadioText(UserMsg msg_id, Protobuf bf, const int[] players, int playersNum, bool reliable, bool init)
{
	return (g_benable && g_bblockradiochat) ?
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

	char sBuffer[PLATFORM_MAX_PATH];
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

	char sBuffer[PLATFORM_MAX_PATH];
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

	char sBuffer[PLATFORM_MAX_PATH];
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

	char buffer[PLATFORM_MAX_PATH];
	
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

public Action OnHookTextMsg5(UserMsg msg_id, Handle bf, int[] players, int playersNum, bool reliable, bool init)
{
	if (!g_benable || !g_bmsgschicken)return Plugin_Continue;

	char buffer[PLATFORM_MAX_PATH];

	PbReadString(bf, "params", buffer, sizeof(buffer), 0);

	if(StrEqual(buffer, "#Pet_Killed"))
	{
		return Plugin_Handled;
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
			PrintToServer("[Game Manager] Error - Invalid X coordinate value: %f", g_ListX);
			g_ListX = 0.17;
		}
	}
	else if(convar == Cvar_ListY)
	{
		g_ListY = StringToFloat(newValue);
		if( (g_ListY > 1.0 || g_ListY < 0) && g_ListY != -1.0)
		{
			PrintToServer("[Game Manager] Error - Invalid Y coordinate value: %f", g_ListY);
			g_ListY = 0.01;
		}
	}
	else if(convar == Cvar_ListColor)
		StrToRGBA(newValue);
}

public Action Timeleft(Handle timer)
{
	if (!g_benable || g_bshowtime == 0)return Plugin_Continue;
	
	if (g_benable)
	{
		if (g_bshowtime == 1)
		{
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
		}else if (g_bshowtime == 2)
		{
			char sTime[60];
			int iTimeleft;
			
			GetMapTimeLeft(iTimeleft);
			if(iTimeleft > 0)
			{
				FormatTime(sTime, sizeof(sTime), "%M:%S", iTimeleft);

				for(int i = 1; i <= MaxClients; i++)
				{
					if(!IsValidEntity(i)) continue;
					if(!IsClientInGame(i)) continue;
					if(ToggleTimeHud[i]) continue;
					
					char message[60];
					Format(message, sizeof(message), "%t %s", "timerhud", sTime);
					SetHudTextParams(g_ListX, g_ListY, 1.0, g_iListColor[0], g_iListColor[1], g_iListColor[2], g_iListColor[3], 0, 0.00, 0.00, 0.00);
					ShowHudText(i, -1, message);
				}
			}
		}else if (g_bshowtime == 3)
		{
			char sTime[60];
			int iTimeleft;
			
			GetMapTimeLeft(iTimeleft);
			if(iTimeleft > 0)
			{
				FormatTime(sTime, sizeof(sTime), "%M:%S", iTimeleft);

				for(int i = 1; i <= MaxClients; i++)
				{
					if(!IsValidEntity(i)) continue;
					if(!IsClientInGame(i)) continue;
					if(!ToggleTimeHud[i]) continue;
					
					char message[60];
					Format(message, sizeof(message), "%t %s", "timerhud", sTime);
					SetHudTextParams(g_ListX, g_ListY, 1.0, g_iListColor[0], g_iListColor[1], g_iListColor[2], g_iListColor[3], 0, 0.00, 0.00, 0.00);
					ShowHudText(i, -1, message);
				}
			}
		}
	}
	return Plugin_Continue;
}

public Action OnPlayerChat(int client, const char[] command, int args) 
{
	if (!g_benable || g_bshowtime == 0 || args == 0)return Plugin_Continue;

	char text[13];
	GetCmdArg(1, text, sizeof(text));
	
    //Command for timeleft without !vvvvv
	if (StrEqual(text, "showtime", false) || StrEqual(text, "timeleft", false) || StrEqual(text, "showtimeleft", false))
	{
		Command_HUD(client, args);
	}
	//Command for timeleft without !^^^^^
	return Plugin_Continue;
}

public Action Command_HUD(int client, int args)
{
	if (!g_benable || g_bshowtime == 0)return Plugin_Continue;

	ToggleTimeHud[client] = !ToggleTimeHud[client];
	char sCookie[8];
	IntToString(ToggleTimeHud[client], sCookie, sizeof(sCookie));
	SetClientCookie(client, c_ToggleTimeHud, sCookie);
	
	if (g_benable)
	{
		if (g_bshowtime == 2)
		{
			if(ToggleTimeHud[client])
			{
				CPrintToChat(client, " %t", "ToggleOffTimeLeft");
			}
			else
			{
				CPrintToChat(client, " %t", "ToggleOnTimeLeft");
			}
			return Plugin_Handled;
		}else if (g_bshowtime == 3)
		{
			if(!ToggleTimeHud[client])
			{
				CPrintToChat(client, " %t", "ToggleOffTimeLeft");
			}
			else
			{
				CPrintToChat(client, " %t", "ToggleOnTimeLeft");
			}
			return Plugin_Handled;
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
				PrintToServer("[Game Manager] Error - RGBA[%d]=%d is not in the range 0-255", i, g_iListColor[i]);
			}
		}
	}
	else
	{
		g_iListColor = {255, 255, 255, 150};
		PrintToServer("[Game Manager] Error - Invalid color format: %s", Color);
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
    
    if(!g_benable || !g_bbalance || T_Count == CT_Count || T_Count + 1 == CT_Count || CT_Count + 1 == T_Count)
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
	if (!g_benable || !g_bknifesound) return Plugin_Continue;
	
	int attacker = GetClientOfUserId(event.GetInt("attacker"));

	g_phitted[attacker] = true;

	return Plugin_Continue;
}

public Action Call_Back_Sounds(int clients[MAXPLAYERS], int& numClients, char sample[PLATFORM_MAX_PATH], int& entity, int& channel, float& volume, int& level, int& pitch, int& flags, char soundEntry[PLATFORM_MAX_PATH], int& seed)
{
	if (!g_benable || !g_bknifesound) return Plugin_Continue;
	
	if (entity == 0 || !IsValidEdict(entity) || !IsValidEntity(entity))return Plugin_Continue;

	char classname[50];
	GetEdictClassname(entity, classname, sizeof(classname));
	
	if (StrContains(sample, "flesh") != -1 || StrContains(sample, "kevlar") != -1)
	{
		CheckPlayers(clients, numClients);

		return Plugin_Changed;
	}

	int ownerknife = GetEntPropEnt(entity, Prop_Send, "m_hOwnerEntity");
	
	if(IsValidEntity(entity))
	{
		if (StrContains(classname, "knife") != -1)
		{
			if (!g_benable || !g_bknifesound || !IsValidClient(ownerknife, false) || entity == 0 || !IsValidEdict(entity) || !IsValidEntity(entity))
				return Plugin_Continue;

			if (g_phitted[ownerknife])
			{
				g_phitted[ownerknife] = false;
				return Plugin_Continue;
			}
			
			CheckPlayers(clients, numClients);
			
			g_phitted[ownerknife] = false;
			
			return Plugin_Changed;
		}
	}

	return Plugin_Continue;
}

public Action Call_Back_Soundss(int clients[MAXPLAYERS], int &numClients, char sample[PLATFORM_MAX_PATH], int &entity, int &channel, float &volume, int &level, int &pitch, int &flags, char soundEntry[PLATFORM_MAX_PATH], int &seed)
{
	if (!g_benable || !g_bhsdeathsound)return Plugin_Continue;
	
	if (StrContains(sample, "headshot1") != -1 || StrContains(sample, "headshot2") != -1)
	{
		return Plugin_Handled;
	}
	
	return Plugin_Continue;
}

public Action Call_Back_Soundsss(int clients[MAXPLAYERS], int &numClients, char sample[PLATFORM_MAX_PATH], int &entity, int &channel, float &volume, int &level, int &pitch, int &flags, char soundEntry[PLATFORM_MAX_PATH], int &seed)
{
	if (!g_benable || !g_bhssound)return Plugin_Continue;
	
	if (StrContains(sample, "bhit_helmet-1") != -1)
	{
		return Plugin_Handled;
	}
	
	return Plugin_Continue;
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

stock void CheckPlayers(int[] clients, int &numClients)
{
	for(int i = 0; i < numClients; i++)
	{
		for (int j = i; j < numClients-1; j++)
			clients[j] = clients[j+1];
		
		numClients--;
		i--;
	}
}

stock bool IsValidClient(int ownerknife, bool botcheck = true)
{
	return (1 <= ownerknife && ownerknife <= MaxClients && IsClientConnected(ownerknife) && IsClientInGame(ownerknife) && (botcheck ? !IsFakeClient(ownerknife) : true)); 
}