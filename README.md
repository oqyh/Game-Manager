# [CSGO] Game-Manager (1.0.2)
https://forums.alliedmods.net/showthread.php?t=336242

### Game Manager ( Hide radar, money, messages, ping, Map Rotaion With Maplist, Restart Server Last Player Disconnect, and More )

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

// Block All Radio Voice Agents (Need To Enable sm_enable_hide_and_block) || 1= Yes || 0= No
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

// Hide All Radio Messages  (Need To Enable sm_enable_hide_and_block) || 1= Yes || 0= No
// -
// Default: "0"
// Minimum: "0.000000"
// Maximum: "1.000000"
sm_block_all_radio_messages "0"

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

// Hide blood (Need To Enable sm_enable_hide_and_block) || 1= Yes || 0= No
// -
// Default: "0"
// Minimum: "0.000000"
// Maximum: "1.000000"
sm_hide_blood "0"

// Hide Blood Splash (Need To Enable sm_enable_hide_and_block) || 1= Yes || 0= No
// -
// Default: "0"
// Minimum: "0.000000"
// Maximum: "1.000000"
sm_hide_blood_splash "0"

// Hide Blood Splatter (Need To Enable sm_enable_hide_and_block) || 1= Yes || 0= No
// -
// Default: "0"
// Minimum: "0.000000"
// Maximum: "1.000000"
sm_hide_blood_splatter "0"

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
// .::[Map Rotation Feature]::.  || 1= Yes || 0= No
// -
// Default: "0"
sm_enable_rotation "0"

// Number Of Players Needed To Cancel sm_rotation_timelimit Changing The Map (Need To Enable sm_enable_rotation)
// -
// Default: "1"
sm_rotation_player_quota "1"

// Time (in minutes) To Start Rotation When sm_rotation_player_quota Not Reach The Players Needed (Need To Enable sm_enable_rotation)
// -
// Default: "20"
sm_rotation_timelimit "20"

//  Make Rotation Specific File Maplist (Need To Enable sm_enable_rotation) || 1= Yes || 0= No
// -
// Default: "1"
sm_rotation_maplist_enabled "1"

// Location Maplist File (Need To Enable sm_enable_rotation)
// -
// Default: "addons/sourcemod/configs/game_manager_maps.txt"
sm_rotation_maplist "addons/sourcemod/configs/game_manager_maps.txt"

// How Would You Like It The Map Order (Need To Enable sm_enable_rotation) || 1= Random || 0= Linear
// -
// Default: "1"
sm_rotation_maplist_order "1"

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
```


## .:[ Change Log ]:.
```
(1.0.2)
- Fix Bug
- Fix "sm_enable_hide_and_block Feature"
- Added Hide blood
- Added Hide Blood Splash
- Added Blood Splatter

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
