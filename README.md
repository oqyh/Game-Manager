# [CSGO] Game-Manager (1.1.0)
https://forums.alliedmods.net/showthread.php?t=336242

### Game Manager ( Block Radio , Radio Start Round , Hide Radar , Money , Messages , Blood , Ping , Map Rotaion With Maplist , Restart Server Last Player Disconnect , And More )

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
//============== BLOCK/HIDE/MISC FEATURE =================
// .::[Enable Hide And Block Feature]::. || 1= Yes || 0= No
gm_enable_hide_and_block "1"
//==================================================


//-------------------------------->> .;[ MESSAGES ];. <<---------------------------------

// Hide Connect Messages (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No
gm_block_connect_message "0"

// Hide Disconnect Messages (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No
gm_block_disconnect_message "0"

// Hide Change Name Messages (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No
gm_block_changename_message "0"

// Hide Server Cvar Change Messages (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No
gm_block_cvar_message "0"

// Hide All Money Team/Player Award Messages (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No
gm_block_hidemoney_message "0"

// Hide First Time Connect Client Join Team Messages (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No
gm_block_jointeam_message "0"

// Hide Player Saved You By Player Messages (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No
gm_block_savedby_message "0"

// Hide Short-Handed Incoming Messages (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No
gm_block_shorthanded_message "0"

// Hide Team Change Messages (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No
gm_block_teamchange_message "0"

// Hide Team Mate Attack Messages (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No
gm_block_teammateattack_message "0"

// Block All Radio Text Chat (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No
gm_block_radio_chat "0"

// Hide Your Chicken Has Been Killed Messages (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No
gm_block_chicken_message "0"


//-------------------------------->> .;[ SOUNDS ];. <<---------------------------------

// Block All Radio Voice Agents (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No
gm_block_radio_voice_agents "0"

// Block Round Start Radio Sounds (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No
gm_block_radio_start_agents "0"

// Block All Radio Voice Grenades Throw (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No
gm_block_radio_voice_grenades "0"

// Block Footsteps Sounds (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No
gm_block_footsteps_sound "0"

// Block Jump Land Sounds (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No
gm_block_jumpland_sound "0"

// Block Counter/Terrorist/Draw Win Sounds (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No
gm_block_roundend_sound "0"

// Block Zero Damage Knife Sounds (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No
gm_block_zero_knife_sound "0"

// Block HeadShot Hit Sound (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No
gm_block_hsdamage_sound "0"

// Block Death Sound (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No
gm_block_death_sound "0"

// Block After Death HeadShot Sound (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No
gm_block_hsdeath_sound "0"


//-------------------------------->> .;[ MISC/OTHER ];. <<---------------------------------

// Delete/Clean Weapons Dropped (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No
gm_block_weapon_drop "0"

// Block Counter/Terrorist/Draw Win Panel  (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No
gm_block_roundend_panel "0"

// Disable Fall Damage + Fall Damage Sound (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No
gm_block_falldamage "0"

// Permanently Remove bots (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No
gm_block_bots "0"

// Permanently Remove Chickens (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No
gm_block_chicken "0"

// Remove Dead Body (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No
gm_block_deadbody "0"

// After How Much Time (In Sec) To Start Remove Dead Body (Need gm_block_deadbody 1)
gm_block_time_deadbody "2.0"

// Permanently Block Both Dynamic + Animated + Normal ClanTags (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No
gm_block_clantag "0"

// Auto Balance Every Round (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No
gm_auto_balance_every_round "0"

// Remove Auto Communication Penalties (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No
gm_block_auto_mute "0"

// Make sv_cheats 0 Automatically   (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No
gm_block_cheats "0"

// Block All Wheel + Ping (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No
gm_block_wheel "0"

// Hide Splatter Effect (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No
gm_hide_splatter "0"

// Hide Blood (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No
gm_hide_blood "0"

// Hide Kill Feed (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No
gm_hide_killfeed "0"

// Hide Money Hud (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No
gm_hide_moneyhud "0"

// Hide Chat Hud (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No
gm_hide_chathud "0"

// Hide Radar (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No
gm_hide_radar "0"



// Force End Map With Command mp_timelimit (Need To Enable gm_enable_hide_and_block) || 1= Yes || 0= No
gm_forceendmap "0"

// Show Timeleft HUD (mp_timelimit)  (Need To Enable gm_enable_hide_and_block) || 3=  || 2=  || 1=  || 0= No
//  0= No
//  1= Yes + Disable Togglable
//  2= Yes But On By First Time Then Make it Togglable
//  3= Yes But Off By First Time Then Make it Togglable
gm_show_timeleft_hud "0"

// Hud color. [R G B A] Pick Colors https://rgbacolorpicker.com/
gm_hud_colors "255 0 189 0.8"

// X-Axis Location From 0 To 1.0 Check https://github.com/oqyh/Game-Manager/blob/main/images/hud%20postions.png For Help
gm_hud_xaxis "0.00"

// Y-Axis Location From 0 To 1.0 Check https://github.com/oqyh/Game-Manager/blob/main/images/hud%20postions.png For Help
gm_hud_yaxis "0.35"




//========== RESTART LAST PLAYER DISCONNECT FEATURE ==========
// .::[Restart Server When Last Player Disconnect Feature]::. || 1= Yes || 0= No 
gm_restart_empty_enable "0"
//==================================================

// When server is empty Which Method Do You Like (Need To Enable gm_restart_empty_enable) || 1= Restart || 2= Crash If Method 1 Is Not work
gm_restart_empty_method "2"

// (in sec.) To Wait To Start gm_restart_empty_method (Need To Enable gm_restart_empty_enable)
gm_restart_empty_delay "900.0"




//================ MAP ROTATION FEATURE =================
// .::[Map Rotation Feature]::.  || 1= Yes || 0= No
gm_rotation_enable "0"
//==================================================

// (Need To Enable gm_rotation_enable) 
//  1= Use game_manager_maps.txt map list need to (Create New Line [gamemanager] + path In Sourcemod/configs/maplists.cfg) 
//  2= Sm_nextmap Or Mapcycle (Requires Nextmap.smx) 
//  3= Load Map In gm_rotation_default_map Cvar
// 0 or 4 and above = Reload Current Map
gm_rotation_mode "1"

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
(1.1.0)
-Fix Bug
-Fix [gm_block_teammateattack_message] added more to array
-Fix [gm_block_hidemoney_message] added more to array
-Fix [gm_block_cheats] better and safe way
-Fix [gm_block_radio_voice_grenades] added female 
-Fix [gm_block_death_sound] added female 
-Fix [gm_block_falldamage] Added Disable Fall damage sound
-Added [gm_show_timeleft_hud] togglable by client side
-Added [gm_block_chicken_message] remove 'Your Chicken Has Been Killed' Messages blocker
-Added [gm_block_hsdeath_sound] Sound after death headshot blocker
-Added [gm_block_deadbody] Remove Dead Body
-Added [gm_block_time_deadbody] for gm_block_deadbody delay
-Added ToggleOnTimeLeft/ToggleOffTimeLeft in Game_Manager.phrases.txt
-Change [gm_block_hurtshield_sound] To [gm_block_hsdamage_sound] Fix Hs Sound
-Change and fix [gm_block_knife_sound] to [gm_block_zero_knife_sound] remove knife sound if 0 damage 
-Toggle timeleft Hud [!timeleft/!showtimeleft/!showtime] or [timeleft/showtimeleft/showtime]
-Remove [gm_block_hurthealth_sound]

(1.0.9)
-Fix Bug
-Fix gm_block_radio_voice_grenades Incgrenade CT No Sound
-Fix gm_hide_radar Cvar Forcer
-Fix gm_hide_moneyhud Cvar Forcer
-Fix gm_block_shorthanded_message Cvar Forcer
-Fix gm_block_falldamage Cvar Forcer
-Fix gm_block_jumpland_sound Cvar Forcer
-Fix gm_block_footsteps_sound Cvar Forcer
-Fix gm_block_auto_mute Cvar Forcer
-Added gm_block_death_sound

(1.0.8)
-Fix Bug
-Fix (-1 - -1) error
-Fix gm_block_radio_voice_grenades
-Fix + Changed gm_block_zerodamge_knife To gm_block_knife_sound
-Added gm_block_radio_chat
-Added gm_hide_chathud
-Added gm_block_hurthealth_sound
-Added gm_block_hurtshield_sound
-Added gm_block_roundend_panel

(1.0.7)
-Fix Bug
-New Syntax
-Fix Invalid edict (-1 - -1) gm_block_zerodamge_knife 
-Fix Block Clan Tag To Not Block Custom Tag gm_block_clantag
-Fix Hide Radar For Spectetors gm_hide_radar
-Fix gm_rotation_mode To Default Use game_manager_maps.txt 
-Added For Sourcemod 1.10 + 1.11
-Added Hide Short-Handed gm_block_shorthanded_message
-Added Delete/Clean Weapons Dropped gm_block_weapon_drop
-Added Block Counter/Terrorist/Draw Win Sounds gm_block_roundend_sound
-Added Block Round Start Radio gm_block_radio_start_agents

(1.0.6)
-Fix Bug
-Fix Permanently Block Both Animated Or Normal ClanTags (gm_block_clantag)
-Fix gm_enable_hide_and_block After Reload / Restart Force all cvar to 1
-Fix gm_restart_empty_method (1) Restart issue
-Fix gm_rotation_enable
-Fix gm_block_zerodamge_knife Error Log

(1.0.5.Fix)
-Fix Bug
-Fix gm_enable_hide_and_block Feature
-Fix Force Radar Toggle All gm_enable_hide_and_block Feature

(1.0.5)
-Fix Bug
-Added Block Knife Sound If Its Zero Damage
-Added Permanently Block Both Animated WASD Or Normal ClanTags 
-Added Disable Fall Damage
-Added X-Axis And Y-Axis  Location Hud For Time Left
-Added Colors For Hud
-Added Multiple Language For Timer Left And Hud

(1.0.4)
-Fix Bug
-Fix Unknown command "sm_block_all_radio_messages"
-Added Remove Auto Communication Penalties
-Added Block Footsteps Sounds
-Added Block Jump Land Sounds

(1.0.3)
-Fix Bug
-Fix Map Rotation Feature
-Fix Blood + Splatter Hide
-Added Hide Change Name Message

(1.0.2)
-Fix Bug
-Fix "sm_enable_hide_and_block Feature"
-Added Hide blood
-Added Hide Blood Splash
-Added Hide Blood Splatter

(1.0.1)
-Fix Bug
-Fix Radar When its Hidden It Shows To Spectators
-Added "sorry" Radio Missing
-Added Permanently Remove bots 
-Added Force Auto Balance Team Every Round
-Added Map Rotation With Maplist Feature ( Thanks Teki, tabakhase , Stewart Anubis )
-Added Restart Server When Last Player Disconnect Feature ( Thanks Dragokas )

(1.0.0)
-Initial Release
```

## .:[ Donation ]:.

If this project help you reduce time to develop, you can give me a cup of coffee :)

[![paypal](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://paypal.me/oQYh)
