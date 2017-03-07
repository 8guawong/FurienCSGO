
#pragma semicolon 1
#include <sourcemod>
#include <cstrike>
#include <sdktools>
#include <sdkhooks>
#include <geoip>

#include <emitsoundany>
#include <clientprefs>

#pragma newdecls required

#include "Furien/globals.sp"
#include "Furien/client.sp"
#include "Furien/functions.sp"
#include "Furien/misc.sp"
#include "Furien/eventhooks.sp"
#include "Furien/commands_callbacks.sp"
#include "Furien/menus.sp"
#include "Furien/menus_callbacks.sp"
#include "Furien/mysql.sp"
#include "Furien/ongameframe.sp"
#include "Furien/sdkhooks.sp"
#include "Furien/sdkhooks_grenademode.sp"
#include "Furien/timers.sp"
#include "Furien/onplayerruncmd.sp"
#include "Furien/convarchanged.sp"

#define PLUGIN_NAME "FurienMOD for CSGO"
#define PLUGIN_AUTHOR "ESK0"
#define PLUGIN_VERSION "1.5"
#define PLUGIN_DESCRIPTION "Very famous CS 1.6 mod with very huge community for CSGO"
#define PLUGIN_URL "https://github.com/ESK0"

public Plugin myinfo =
{
  name = PLUGIN_NAME,
  author = PLUGIN_AUTHOR,
  version = PLUGIN_VERSION,
  description = PLUGIN_DESCRIPTION,
  url = PLUGIN_URL
};
public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
  if(GetEngineVersion() != Engine_CSGO)
  {
    SetFailState("[FurienGO] - Game is unsupported, Only CS:GO!");
  }
  return APLRes_Success;
}
public void OnPluginStart()
{
  HookEvent("round_prestart", Event_OnRoundPreStart);
  HookEvent("round_start", Event_OnRoundStart);
  HookEvent("round_end", Event_OnRoundEnd);
  HookEvent("player_spawn", Event_OnPlayerSpawn);
  HookEvent("player_death", Event_OnPlayerDeath);
  HookEvent("player_team", Event_OnPlayerPreTeam, EventHookMode_Pre);
  HookEvent("player_hurt", Event_OnPlayerHurt);
  HookEvent("bomb_planted", Event_OnBombPlanted);
  HookEvent("bomb_defused", Event_OnBombDefused);
  HookEvent("bomb_exploded", Event_OnBombExploded);
  HookEvent("tagrenade_detonate", Event_OnTaGrenadeDetonate, EventHookMode_Pre);
  HookEvent("player_blind", Event_OnPlayerFlashed);

  h_Settigs[Settings_ShowDmg] = RegClientCookie("gs_furien_showdmg", "", CookieAccess_Private);
  h_Settigs[Settings_ThirdPerson] = RegClientCookie("gs_furien_thirdperson", "", CookieAccess_Private);
  h_Settigs[Settings_F_OpenMainMenu_RS] = RegClientCookie("gs_furien_fopenmainmenurs", "", CookieAccess_Private);
  h_Settigs[Settings_OpenMainMenu_onF] = RegClientCookie("gs_furien_openmenu_onF", "", CookieAccess_Private);



  RegConsoleCmd("sm_furien", Command_Furien);
  RegAdminCmd("sm_furien_add", Command_Add, ADMFLAG_ROOT);
  RegAdminCmd("sm_furien_get", Command_Get, ADMFLAG_ROOT);
  RegAdminCmd("sm_furien_rem", Command_Rem, ADMFLAG_ROOT);

  AddCommandListener(Command_LookAtWeapon, "+lookatweapon");
  RegConsoleCmd("thirdperson", Command_ThirdPerson);
  RegConsoleCmd("firstperson", Command_FirstPerson);

  AddNormalSoundHook(OnNormalSoundPlayed);
  for(int i; i < sizeof(g_sRadioCommands); i++)
  {
    AddCommandListener(Command_BlockRadio, g_sRadioCommands[i]);
  }
  AddCommandListener(Command_Kill, "kill");
  g_MainClipOffset = FindSendPropInfo("CBaseCombatWeapon", "m_iClip1");
  g_offsNextSecondaryAttack = FindSendPropOffs("CBaseCombatWeapon", "m_flNextSecondaryAttack");


  cV_DisableBomb = CreateConVar("furien_disablebomb", "30", "For how many seconds after round starts will be unable to plant bomb / -1 = 'Able to plant everytime', 0 = 'Forever'");
  cVi_DisableBomb = GetConVarInt(cV_DisableBomb);
  HookConVarChange(cV_DisableBomb,OnConVarChanged);
  cV_Gravity = CreateConVar("furien_gravity", "0.1", "Furiens gravity multiplier");
  cVf_Gravity = GetConVarFloat(cV_Gravity);
  HookConVarChange(cV_Gravity,OnConVarChanged);
  cV_Speed = CreateConVar("furien_speed", "2.0", "Furiens speed multiplier");
  cVf_Speed = GetConVarFloat(cV_Speed);
  HookConVarChange(cV_Speed,OnConVarChanged);
  cV_Footsteps = CreateConVar("furien_footsteps", "1", "Disable furiens footsteps, 1 = 'Enable' 0 = 'Disable'");
  cVb_Footsteps = GetConVarBool(cV_Footsteps);
  HookConVarChange(cV_Footsteps,OnConVarChanged);
  cV_BombBeacon = CreateConVar("furien_bombbeacon", "1", "Enable beacon from bomb when planted, 1 = 'Enable' 0 = 'Disable'");
  cVb_BombBeacon = GetConVarBool(cV_BombBeacon);
  HookConVarChange(cV_BombBeacon,OnConVarChanged);
  cV_BombBeacon_Delay = CreateConVar("furien_bombbeacon_delay", "1.0", "Delay between beacons (in seconds)");
  cVf_BombBeacon_Delay = GetConVarFloat(cV_BombBeacon_Delay);
  HookConVarChange(cV_BombBeacon_Delay,OnConVarChanged);
  cV_BombBeacon_Radius = CreateConVar("furien_bombbeacon_radius", "250.0", "Beacon radius");
  cVf_BombBeacon_Radius = GetConVarFloat(cV_BombBeacon_Radius);
  HookConVarChange(cV_BombBeacon_Radius,OnConVarChanged);
  cV_BombBeacon_Life = CreateConVar("furien_bombbeacon_life", "1.5", "Beacon life");
  cVf_BombBeacon_Life = GetConVarFloat(cV_BombBeacon_Life);
  HookConVarChange(cV_BombBeacon_Life,OnConVarChanged);
  cV_BombBeacon_Width = CreateConVar("furien_bombbeacon_width", "8.0", "Beacon width");
  cVf_BombBeacon_Width = GetConVarFloat(cV_BombBeacon_Width);
  HookConVarChange(cV_BombBeacon_Width,OnConVarChanged);
  cV_BombBeacon_Color = CreateConVar("furien_bombbeacon_color", "255 0 255 255", "Beacon color [R G B A] if randomcolor = '0'");
  GetConVarColor(cV_BombBeacon_Color, cVi_BombBeacon_Color);
  HookConVarChange(cV_BombBeacon_Color,OnConVarChanged);
  cV_BombBeacon_RandomColor = CreateConVar("furien_bombbeacon_randomcolor", "0", "Beacon randomcolor");
  cVb_BombBeacon_RandomColor = GetConVarBool(cV_BombBeacon_RandomColor);
  HookConVarChange(cV_BombBeacon_RandomColor,OnConVarChanged);
  /*cV_Invisible_Speed = CreateConVar("furien_invisible_speed", "0.09", "Invisible speed, Lower = faster");
  cVf_Invisible_Speed = GetConVarFloat(cV_Invisible_Speed);
  HookConVarChange(cV_Invisible_Speed,OnConVarChanged);*/
  cV_Invisible_Alpha_Reduce = CreateConVar("furien_invisible_alpha_reduce", "26", "Your alpha will be reduced by X every [furien_invisible_speed] seconds");
  cVi_Invisible_Alpha_Reduce = GetConVarInt(cV_Invisible_Alpha_Reduce);
  HookConVarChange(cV_Invisible_Alpha_Reduce,OnConVarChanged);
  cV_Invisible = CreateConVar("furien_invisible", "1", "Enable furiens invisible, 1 = 'Enabled' 0 = 'Disabled'");
  cVb_Invisible = GetConVarBool(cV_Invisible);
  HookConVarChange(cV_Invisible,OnConVarChanged);
  cV_FallDownSpeed = CreateConVar("furien_falldownspeed", "1", "Enable furiens low falldown speed, 1 = 'Enabled' 0 = 'Disabled'");
  cVb_FallDownSpeed = GetConVarBool(cV_FallDownSpeed);
  HookConVarChange(cV_FallDownSpeed,OnConVarChanged);
  cV_WallHang = CreateConVar("furien_wallhang", "1", "Enable furiens wallhang, 1 = 'Enabled' 0 = 'Disabled'");
  cVb_WallHang = GetConVarBool(cV_WallHang);
  HookConVarChange(cV_WallHang,OnConVarChanged);
  cV_DoubleJump = CreateConVar("furien_doublejump", "1", "Enable furiens doublejump, 1 = 'Enabled' 0 = 'Disabled'");
  cVb_DoubleJump = GetConVarBool(cV_DoubleJump);
  HookConVarChange(cV_DoubleJump,OnConVarChanged);
  cV_DoubleJump_MaxJump = CreateConVar("furien_doublejump_maxjump", "1", "How many times you can jump in air");
  cVi_DoubleJump_MaxJump = GetConVarInt(cV_DoubleJump_MaxJump);
  HookConVarChange(cV_DoubleJump_MaxJump,OnConVarChanged);
  cV_DoubleJump_JumpHeight = CreateConVar("furien_doublejump_jumpheight", "250.0", "Height of doublejump");
  cVf_DoubleJump_JumpHeight = GetConVarFloat(cV_DoubleJump_JumpHeight);
  HookConVarChange(cV_DoubleJump_JumpHeight,OnConVarChanged);
  cV_FallDown = CreateConVar("furien_falldown", "1.9", "Falldown speed");
  cVf_FallDown = GetConVarFloat(cV_FallDown);
  HookConVarChange(cV_FallDown,OnConVarChanged);

  AutoExecConfig(true, "furien");
}
public void OnMapStart()
{
  i_BeamIndex = PrecacheModel(MODEL_LASERBEAM, true);
  i_ExplosionIndex = PrecacheModel("sprites/blueglow2.vmt");
  i_SmokeIndex = PrecacheModel("sprites/steam1.vmt");
  SetCvarStr("mp_teamname_1", "ANTI-FURIENS");
  SetCvarStr("mp_teamname_2", "FURIENS");
  SetCvarInt("sv_ignoregrenaderadio", 1);
  SetCvarInt("sv_disable_immunity_alpha", 1);
  SetCvarInt("mp_solid_teammates", 1);
  SetCvarInt("sv_airaccelerate", 120);
  SetCvarInt("mp_maxrounds", 30);
  SetCvarInt("mp_startmoney", 0);
  SetCvarInt("mp_playercashawards", 1);
  SetCvarFloat("mp_roundtime", 2.5);
  SetCvarFloat("mp_roundtime_defuse", 2.5);
  SetCvarInt("mp_playercashawards", 1);
  SetCvarInt("mp_teamcashawards", 0);
  SetCvarInt("mp_defuser_allocation", 0);
  SetCvarInt("mp_solid_teammates", 0);
  SetCvarInt("sv_deadtalk", 0);
  SetCvarInt("sv_alltalk", 0);
  SetCvarInt("mp_autokick", 0);
  SetCvarInt("sv_allow_thirdperson", 1);
  SetCvarInt("mp_free_armor", 0);
  SetCvarInt("mp_buytime", 0);
  MySql_Connect();
  PrecacheAndDownloadSounds();
  PrecacheAdnDownloadModels(-1);

  i_F_RoundWinStream = 0;

  CreateTimer(3.0, Timer_CheckAdminTags,_,TIMER_FLAG_NO_MAPCHANGE|TIMER_REPEAT);
  LoopAllClients(i)
  {
    WipeHandle(t_SpecialItem_Regenerace[i]);
    WipeHandle(t_SpecialItem_Zmateni[i]);
    WipeHandle(t_SpecialItem_DrtiveStrely[i]);
  }
}
public void OnMapEnd()
{
  LoopAllClients(i)
  {
    WipeHandle(t_SpecialItem_Regenerace[i]);
    WipeHandle(t_SpecialItem_Zmateni[i]);
    WipeHandle(t_SpecialItem_DrtiveStrely[i]);
  }
  WipeHandle(h_BombBeacon);
  CloseHandle(db);
}
public void OnClientPostAdminCheck(int client)
{
  if(IsValidClient(client))
  {
    if(IsClientVIP(client, g_AccType[ACC_EVIP]))
    {
      f_gInvisibleDelay[client] = 0.0509803921568627;
    }
    else if(IsClientVIP(client, g_AccType[ACC_VIP]))
    {
      f_gInvisibleDelay[client] = 0.0611764705882353;
    }
    else
    {
      f_gInvisibleDelay[client] = 0.0713725490196078;
    }
  }
}
public void OnClientPutInServer(int client)
{
  if(IsValidClient(client))
  {
    if(cVb_Footsteps == true)
    {
      SendConVarValue(client, FindConVar("sv_footsteps"), "0");
    }
    MySql_LoadClient(client);
    SDKHook(client, SDKHook_PreThink, EventSDK_OnClientThink);
    SDKHook(client, SDKHook_PostThinkPost, EventSDK_OnPostThinkPost);
    SDKHook(client, SDKHook_WeaponCanUse, EventSDK_OnWeaponCanUse);
    SDKHook(client, SDKHook_SetTransmit, EventSDK_SetTransmit);
    SDKHook(client, SDKHook_OnTakeDamage, EventSDK_OnTakeDamage);
    SDKHook(client, SDKHook_TraceAttack, EventSDK_OnTraceAttack);
    Client_LoadSettings(client);
  }
}
public void OnClientDisconnect(int client)
{
  if(IsClientInGame(client))
  {
    MySql_SaveClient(client);
    Client_SaveSettings(client);
    b_ClientVerified[client] = false;
  }
}
public void OnClientDisconnect_Post(int client)
{
  g_cLastButtons[client] = 0;
}
public void OnClientDisconnected(int client)
{
  CheckVIPDuel();
}
public Action OnNormalSoundPlayed(int clients[64], int &numClients, char sample[PLATFORM_MAX_PATH], int &entity, int &channel, float &volume, int &level, int &pitch, int &flags)
{
  if(cVb_Footsteps == true)
  {
    if(StrContains(sample, "land") != -1)
    {
      return Plugin_Stop;
    }
    if (entity && entity <= MaxClients && StrContains(sample, "footsteps") != -1)
  	{
      if(GetClientTeam(entity) == CS_TEAM_CT)
      {
        EmitSoundToAll(sample, entity, SNDCHAN_AUTO,SNDLEVEL_NORMAL,SND_NOFLAGS,0.5);
        return Plugin_Handled;
      }
      return Plugin_Handled;
    }
  }
  return Plugin_Continue;
}
public void OnEntityCreated(int entity, const char[] classname)
{
  if(IsValidEntity(entity))
  {
    if(StrEqual(classname, "hegrenade_projectile"))
    {
      SDKHook(entity, SDKHook_Spawn, SDKHook_Spawn_Main);
    }
  }
}
public void OnButtonPress(int client, int button)
{
  if(IsValidClient(client, true))
  {
    if(GetClientTeam(client) == CS_TEAM_T)
    {
      char weapon_name[32];
      GetClientWeapon(client, weapon_name, sizeof(weapon_name));
      int cWeapon = GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon");
      if(StrEqual(weapon_name, "weapon_hegrenade"))
      {
        SetEntDataFloat(cWeapon, g_offsNextSecondaryAttack, GetGameTime()+1);
      }
    }
  }
}
public void OnButtonRelease(int client, int buttons)
{
  if(IsValidClient(client, true))
  {
    if(GetClientTeam(client) == CS_TEAM_T)
    {
      char weapon_name[32];
      GetClientWeapon(client, weapon_name, sizeof(weapon_name));
      int cWeapon = GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon");
      if(buttons & IN_ATTACK2)
      {
        if(StrEqual(weapon_name, "weapon_hegrenade"))
        {
          SetEntDataFloat(cWeapon, g_offsNextSecondaryAttack, GetGameTime()+1);
          i_gClientGrenadeMode[client]++;
          if(i_gClientGrenadeMode[client] == view_as<int>(Grenade_ModeCount))
          {
            i_gClientGrenadeMode[client] = 0;
          }
          PrintHintText(client, "Mode: %s%s", s_GrenadeType[i_gClientGrenadeMode[client]], i_gClientGrenadeMode[client] == Grenade_Detonate?"\nGranát odpálíté pomocí R (+reload)":"");
        }
      }
    }
  }
}
