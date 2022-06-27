# [CSGO] Game-Manager (1.0.6)
https://forums.alliedmods.net/showthread.php?t=336242

### Game Manager ( Hide Radar, Money, Messages, Blood, Ping, Map Rotaion With Maplist, Restart Server Last Player Disconnect, And More )

![alt text](https://github.com/oqyh/Game_Manager/blob/main/images/hud%20postions.png?raw=true)

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
/||||||||||||||||||||||||||||||| BLOCK/HIDE/MISC FEATURE |||||||||||||||||||||||||||||||||||||||||||||
// .::[Enable Hide And Block Feature]::. || 1= Yes || 0= No
gm_enable_hide_and_block "1"
/|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//////////////////////>>                MESSAGES                <<////////////////////////////////////

// Hide Connect Messages (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No
gm_block_connect_message "0"

// Hide Disconnect Messages (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No
gm_block_disconnect_message "0"

// Hide Cvar Change Messages (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No
gm_block_cvar_message "0"

// Hide Join Team Messages (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No
gm_block_jointeam_message "0"

// Hide Change Name Messages (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No
gm_block_changename_message "0"

// Hide All Money Team/Player Award Messages (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No
gm_block_hidemoney_message "0"

// Hide Player Saved You By Player Messages (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No
gm_block_savedby_message "0"

// Hide Team Change Messages (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No
gm_block_teamchange_message "0"

// Hide Team Mate Attack Messages (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No
gm_block_teammateattack_message "0"


//////////////////////>>               BLOCK/HIDE                <<///////////////////////////////////

// Permanently Remove bots (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No
gm_block_bots "0"

// Permanently Remove Chickens (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No
gm_block_chicken "0"

// Permanently Block Both Animated Or Normal ClanTags (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No
gm_block_clantag "0"



// Hide Kill Feed (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No
gm_hide_killfeed "0"

// Hide Money Hud (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No
gm_hide_moneyhud "0"

// Hide Radar (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No
gm_hide_radar "0"



// Block All Radio Voice Agents + Messages (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No
gm_block_radio_voice_agents "0"

// Block All Radio Voice Grenades Throw (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No
gm_block_radio_voice_grenades "0"

// Block All Wheel + Ping (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No
gm_block_wheel "0"

// Block Footsteps Sounds (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No
gm_block_footsteps_sound "0"

// Block Jump Land Sounds (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No
gm_block_jumpland_sound "0"

// Block Knife Sound If Its Zero Damage (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No
gm_block_zerodamge_knife "0"


////////////////////////>>               MISC                <<//////////////////////////////////////

// Hide Blood (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No
gm_hide_blood "0"

// Hide Splatter Effect (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No
gm_hide_splatter "0"

// Disable Fall Damage (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No
gm_block_falldamage "0"

// Remove Auto Communication Penalties (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No
gm_block_auto_mute "0"

// Make sv_cheats 0 Automatically   (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No
gm_block_cheats "0"

// Auto Balance Every Round (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No
gm_auto_balance_every_round "0"

// Force End Map With Command mp_timelimit (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No
gm_forceendmap "0"



// Show Timeleft HUD (mp_timelimit) At Bottom  (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No
gm_show_timeleft_hud "0"

// Hud color. [R G B A] Pick Colors https://rgbacolorpicker.com/
gm_hud_colors "255 0 189 0.8"

// X-Axis Location From 0 To 1.0 Check https://github.com/oqyh/Game-Manager/blob/main/images/hud%20postions.png For Help
gm_hud_xaxis "0.00"

// Y-Axis Location From 0 To 1.0 Check https://github.com/oqyh/Game-Manager/blob/main/images/hud%20postions.png For Help
gm_hud_yaxis "0.40"


/|||||||||||||||||||||||||||||| RESTART LAST PLAYER DISCONNECT FEATURE ||||||||||||||||||||||||||||||
// .::[Restart Server When Last Player Disconnect Feature]::. || 1= Yes || 0= No 
gm_restart_empty_enable "0"
/||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

// When server is empty Which Method Do You Like (Need To Enable gm_restart_empty_enable) || 1= Restart || 2= Crash If Method 1 Is Not work
gm_restart_empty_method "2"

// (in sec.) To Wait To Start gm_restart_empty_method (Need To Enable gm_restart_empty_enable)
gm_restart_empty_delay "900.0"


/||||||||||||||||||||||||||||||||||||||| MAP ROTATION FEATURE |||||||||||||||||||||||||||||||||||||||
// .::[Map Rotation Feature]::.  || 1= Yes || 0= No
gm_rotation_enable "0"
/||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

// (Need To Enable gm_rotation_enable) || 0= Custom Maplist (Create New Line [gamemanager] + path In Sourcemod/configs/maplists.cfg) || 1= Sm_nextmap Or Mapcycle (Requires Nextmap.smx) || 2= Load Map In gm_rotation_default_map Cvar || 3= Reload Current Map
gm_rotation_mode "0"

// Number Of Clients That Must Be Connected To Disable Map Rotation Feature (Need To Enable gm_rotation_enable)
gm_rotation_client_limit "1"

// Include Bots In Number Of Clients in gm_rotation_client_limit (Remember, Sourcetv Counts As A Bot) (Need To Enable gm_rotation_enable)
gm_rotation_include_bots "0"

// (in min.) Pass While The Client Limit Has Not Been Reached For Rotation Feature To Occur (Need To Enable gm_rotation_enable)
gm_rotation_time_limit "5"

// Map To Load If (gm_rotation_mode Is Set To 2) (Need To Enable gm_rotation_enable)
gm_rotation_default_map ""

// Config To Exec When An Rotation Feature Occurs, If Desired.  Executes After The Map Loads And Server.cfg And Sourcemod Plugin Configs Are Exec'd (Need To Enable gm_rotation_enable)
gm_rotation_config_to_exec ""
```


## .:[ Change Log ]:.
```
(1.0.6)
-Fix Bug
-Fix Permanently Block Both Animated Or Normal ClanTags (gm_block_clantag)
-Fix gm_enable_hide_and_block After Reload / Restart Force all cvar to 1
-Fix gm_restart_empty_method (1) Restart issue
-Fix gm_rotation_enable
-Fix gm_block_zerodamge_knife Error Log

(1.0.5.Fix)
- Fix Bug
- Fix gm_enable_hide_and_block Feature
- Fix Force Radar Toggle All gm_enable_hide_and_block Feature

(1.0.5)
- Fix Bug
- Added Block Knife Sound If Its Zero Damage
- Added Permanently Block Both Animated WASD Or Normal ClanTags 
- Added Disable Fall Damage
- Added X-Axis And Y-Axis  Location Hud For Time Left
- Added Colors For Hud
- Added Multiple Language For Timer Left And Hud

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

## .:[ Donation ]:.

If this project help you reduce time to develop, you can give me a cup of coffee :)

[![paypal](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://paypal.me/oQYh)
