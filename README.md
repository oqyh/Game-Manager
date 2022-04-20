# [CSGO] Game-Manager (1.0.4)
https://forums.alliedmods.net/showthread.php?t=336242

### Game Manager ( Hide Radar, Money, Messages, Blood, Ping, Map Rotaion With Maplist, Restart Server Last Player Disconnect, And More )

![alt text](https://github.com/oqyh/Game_Manager/blob/main/images/8.png?raw=true)

![alt text](https://github.com/oqyh/Game_Manager/blob/main/images/5.png?raw=true)

![alt text](https://github.com/oqyh/Game_Manager/blob/main/images/7.png?raw=true)

![alt text](https://github.com/oqyh/Game_Manager/blob/main/images/2.png?raw=true)

![alt text](https://github.com/oqyh/Game_Manager/blob/main/images/1.png?raw=true)
![alt text](https://github.com/oqyh/Game_Manager/blob/main/images/3.png?raw=true)
![alt text](https://github.com/oqyh/Game_Manager/blob/main/images/4.png?raw=true)
![alt text](https://github.com/oqyh/Game_Manager/blob/main/images/6.png?raw=true)
![alt text](https://github.com/oqyh/Game_Manager/blob/main/images/9.png?raw=true)


## .:[ ConVars ]:.
  ```
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// .::[Enable Hide And Block Feature]::. || 1= Yes || 0= No
// -
// Default: "1"
// Minimum: "0.000000"
// Maximum: "1.000000"
sm_enable_hide_and_block "1"

// Auto Balance Every Round (Need To Enable sm_enable_hide_and_block) || 1= Yes || 0= No
// -
// Default: "0"
// Minimum: "0.000000"
// Maximum: "1.000000"
sm_auto_balance_every_round "0"

// Block All Radio Voice Agents + Messages (Need To Enable sm_enable_hide_and_block) || 1= Yes || 0= No
// -
// Default: "0"
// Minimum: "0.000000"
// Maximum: "1.000000"
sm_block_radio_voice_agents "0"

// Block All Radio Voice Grenades Throw (Need To Enable sm_enable_hide_and_block) || 1= Yes || 0= No
// -
// Default: "0"
// Minimum: "0.000000"
// Maximum: "1.000000"
sm_block_radio_voice_grenades "0"

// Block All Wheel + Ping (Need To Enable sm_enable_hide_and_block) || 1= Yes || 0= No
// -
// Default: "0"
// Minimum: "0.000000"
// Maximum: "1.000000"
sm_block_wheel "0"

// Hide Connect Messages (Need To Enable sm_enable_hide_and_block) || 1= Yes || 0= No
// -
// Default: "0"
// Minimum: "0.000000"
// Maximum: "1.000000"
sm_block_connect_message "0"

// Hide Cvar Change Messages (Need To Enable sm_enable_hide_and_block) || 1= Yes || 0= No
// -
// Default: "0"
// Minimum: "0.000000"
// Maximum: "1.000000"
sm_block_cvar_message "0"

// Hide Disconnect Messages (Need To Enable sm_enable_hide_and_block) || 1= Yes || 0= No
// -
// Default: "0"
// Minimum: "0.000000"
// Maximum: "1.000000"
sm_block_disconnect_message "0"

// Hide All Money Team/Player Award Messages (Need To Enable sm_enable_hide_and_block) || 1= Yes || 0= No
// -
// Default: "0"
// Minimum: "0.000000"
// Maximum: "1.000000"
sm_block_hidemoney_message "0"

// Hide Join Team Messages (Need To Enable sm_enable_hide_and_block) || 1= Yes || 0= No
// -
// Default: "0"
// Minimum: "0.000000"
// Maximum: "1.000000"
sm_block_jointeam_message "0"

// Hide Change Name Messages (Need To Enable sm_enable_hide_and_block) || 1= Yes || 0= No
// -
// Default: "1"
// Minimum: "0.000000"
// Maximum: "1.000000"
sm_block_changename_message "0"

// Hide Player Saved You By Player Messages (Need To Enable sm_enable_hide_and_block) || 1= Yes || 0= No
// -
// Default: "0"
// Minimum: "0.000000"
// Maximum: "1.000000"
sm_block_savedby_message "0"

// Hide Team Change Messages (Need To Enable sm_enable_hide_and_block) || 1= Yes || 0= No
// -
// Default: "0"
// Minimum: "0.000000"
// Maximum: "1.000000"
sm_block_teamchange_message "0"

// Hide Team Mate Attack Messages (Need To Enable sm_enable_hide_and_block) || 1= Yes || 0= No
// -
// Default: "0"
// Minimum: "0.000000"
// Maximum: "1.000000"
sm_block_teammateattack_message "0"

// Hide Kill Feed (Need To Enable sm_enable_hide_and_block) || 1= Yes || 0= No
// -
// Default: "0"
// Minimum: "0.000000"
// Maximum: "1.000000"
sm_hide_killfeed "0"

// Hide Money Hud (Need To Enable sm_enable_hide_and_block) || 1= Yes || 0= No
// -
// Default: "0"
// Minimum: "0.000000"
// Maximum: "1.000000"
sm_hide_moneyhud "0"

// Hide Radar (Need To Enable sm_enable_hide_and_block) || 1= Yes || 0= No
// -
// Default: "0"
// Minimum: "0.000000"
// Maximum: "1.000000"
sm_hide_radar "0"

// Remove Blood (Need To Enable sm_enable_hide_and_block) || 1= Yes || 0= No
// -
// Default: "1"
// Minimum: "0.000000"
// Maximum: "1.000000"
sm_hide_blood "0"

// Remove Splatter Effect (Need To Enable sm_enable_hide_and_block) || 1= Yes || 0= No
// -
// Default: "1"
// Minimum: "0.000000"
// Maximum: "1.000000"
sm_hide_splatter "0"

// Permanently Remove bots (Need To Enable sm_enable_hide_and_block) || 1= Yes || 0= No
// -
// Default: "0"
sm_block_bots "0"

// Make sv_cheats 0 Automatically   (Need To Enable sm_enable_hide_and_block) || 1= Yes || 0= No
// -
// Default: "0"
// Minimum: "0.000000"
// Maximum: "1.000000"
sm_block_cheats "0"

// Remove Chickens (Need To Enable sm_enable_hide_and_block) || 1= Yes || 0= No
// -
// Default: "0"
// Minimum: "0.000000"
// Maximum: "1.000000"
sm_block_chicken "0"

// Remove Auto Communication Penalties (Need To Enable sm_enable_hide_and_block) || 1= Yes || 0= No
// -
// Default: "1"
// Minimum: "0.000000"
// Maximum: "1.000000"
sm_block_auto_mute "0"

// Block Footsteps Sounds (Need To Enable sm_enable_hide_and_block) || 1= Yes || 0= No
// -
// Default: "1"
// Minimum: "0.000000"
// Maximum: "1.000000"
sm_block_footsteps_sound "0"

// Block Jump Land Sounds (Need To Enable sm_enable_hide_and_block) || 1= Yes || 0= No
// -
// Default: "1"
// Minimum: "0.000000"
// Maximum: "1.000000"
sm_block_jumpland_sound "0"

// Show Timeleft HUD (mp_timelimit) At Bottom  (Need To Enable sm_enable_hide_and_block) || 1= Yes || 0= No
// -
// Default: "0"
// Minimum: "0.000000"
// Maximum: "1.000000"
sm_show_timeleft_hud "0"

// Force End Map With Command mp_timelimit (Need To Enable sm_enable_hide_and_block) || 1= Yes || 0= No
// -
// Default: "0"
// Minimum: "0.000000"
// Maximum: "1.000000"
sm_forceendmap "0"
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// .::[Map Rotation Feature]::.  || 1= Yes || 0= No
// -
// Default: "0"
// Minimum: "0.000000"
// Maximum: "1.000000"
sm_rotation_enable "0"

// (Need To Enable sm_rotation_enable) || 0= Custom Maplist (Create New Line [gamemanager] + path In Sourcemod/configs/maplists.cfg) || 1= Sm_nextmap Or Mapcycle (Requires Nextmap.smx) || 2= Load Map In sm_rotation_default_map Cvar || 3= Reload Current Map
// -
// Default: "0"
// Minimum: "0.000000"
// Maximum: "3.000000"
sm_rotation_mode "0"

// (in min.) Pass While The Client Limit Has Not Been Reached For Rotation Feature To Occur (Need To Enable sm_rotation_enable)
// -
// Default: "5"
// Minimum: "0.000000"
sm_rotation_time_limit "5"

// Number Of Clients That Must Be Connected To Disable Map Rotation Feature (Need To Enable sm_rotation_enable)
// -
// Default: "1"
// Minimum: "0.000000"
sm_rotation_client_limit "1"

// Include Bots In The Client Count (Remember, Sourcetv Counts As A Bot) (Need To Enable sm_rotation_enable)
// -
// Default: "0"
// Minimum: "0.000000"
// Maximum: "1.000000"
sm_rotation_include_bots "0"

// Map To Load If (sm_rotation_mode Is Set To 2) (Need To Enable sm_rotation_enable)
// -
// Default: ""
sm_rotation_default_map ""

// Config To Exec When An Rotation Feature Occurs, If Desired.  Executes After The Map Loads And Server.cfg And Sourcemod Plugin Configs Are Exec'd (Need To Enable sm_rotation_enable)
// -
// Default: ""
sm_rotation_config_to_exec ""
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// .::[Restart Server When Last Player Disconnect Feature]::. || 1= Yes || 0= No 
// -
// Default: "0"
sm_restart_empty_enable "0"

// (in sec.) To Wait To Start sm_restart_empty_method (Need To Enable sm_restart_empty_enable)
// -
// Default: "60.0"
sm_restart_empty_delay "60.0"

// When server is empty Which Method Do You Like (Need To Enable sm_restart_empty_enable) || 1= Restart || 2= Crash If Method 1 Is Not work
// -
// Default: "2"
sm_restart_empty_method "2"
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
```


## .:[ Change Log ]:.
```
(1.0.4)
- Fix Bug
- Fix Unknown command "sm_block_all_radio_messages"
- Added Remove Auto Communication Penalties
- Added Block Footsteps Sounds
- Added Block Jump Land Sounds

(1.0.3)
- Fix Bug
- Fix Map Rotation Feature
- Fix Blood + Splatter Hide
- Added Hide Change Name Message

(1.0.2)
- Fix Bug
- Fix "sm_enable_hide_and_block Feature"
- Added Hide blood
- Added Hide Blood Splash
- Added Hide Blood Splatter

(1.0.1)
- Fix Bug
- Fix Radar When its Hidden It Shows To Spectators
- Added "sorry" Radio Missing
- Added Permanently Remove bots 
- Added Force Auto Balance Team Every Round
- Added Map Rotation With Maplist Feature ( Thanks Teki, tabakhase , Stewart Anubis )
- Added Restart Server When Last Player Disconnect Feature ( Thanks Dragokas )

(1.0.0)
- Initial Release
```
