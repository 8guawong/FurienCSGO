stock void SetCvarStr(char[] scvar, char[] svalue)
{
  SetConVarString(FindConVar(scvar), svalue, true);
}
stock void SetCvarInt(char[] scvar, int svalue)
{
  SetConVarInt(FindConVar(scvar), svalue, true);
}
stock void SetCvarFloat(char[] scvar, float svalue)
{
  SetConVarFloat(FindConVar(scvar), svalue, true);
}
stock void ExplodeSteamId(const char[] steamid, char[] e_steamid,int l)
{
  char buffer[3][32];
  ExplodeString(steamid,":",buffer,sizeof(buffer),sizeof(buffer[]));
  Format(e_steamid,l,"%s",buffer[2]);
}
stock void WipeHandle(Handle &handle)
{
  if(handle != null)
  {
    CloseHandle(handle);
    handle = null;
  }
}
stock void GetConVarColor(ConVar &convar, int color[4])
{
  char buffer[32];
  char e_buffer[4][24];
  GetConVarString(convar, buffer, sizeof(buffer));
  if(ExplodeString(buffer, " ", e_buffer, sizeof(e_buffer), sizeof(e_buffer[])) == 4)
  {
    color[0] = StringToInt(e_buffer[0]);
    color[1] = StringToInt(e_buffer[1]);
    color[2] = StringToInt(e_buffer[2]);
    color[3] = StringToInt(e_buffer[3]);
  }
}
stock void CheckVIPDuel()
{
  int t_count = CountAlivePlayersInTeam(CS_TEAM_T);
  int ct_count = CountAlivePlayersInTeam(CS_TEAM_CT);
  if(t_count == 1 && ct_count == 1)
  {
    int t = GetLastPlayerOfTeam(CS_TEAM_T);
    int ct = GetLastPlayerOfTeam(CS_TEAM_CT);
    if(IsClientVIP(t, g_AccType[ACC_VIP]) && IsClientVIP(ct, g_AccType[ACC_VIP]))
    {
      PrintToChatAll("%s VIP duel byl zahájen. \x03%N\x01 hraje proti \x03%N\x01!", CHAT_TAG, ct, t);
      b_VIPDuel = true;
    }
  }
}
stock int Beacon_RandomColor()
{
  int color[4];
  color[0] = GetRandomInt(1,255);
  color[1] = GetRandomInt(1,255);
  color[2] = GetRandomInt(1,255);
  color[3] = 255;
  return color;
}
stock bool GetPlayerEyeViewPoint(int client, float pos[3])
{
  float f_Angles[3];
  float f_Origin[3];
  GetClientEyeAngles(client, f_Angles);
  GetClientEyePosition(client, f_Origin);
  Handle h_TraceFilter = TR_TraceRayFilterEx(f_Origin, f_Angles, MASK_SOLID, RayType_Infinite, TraceEntityFilterPlayer);
  if(TR_DidHit(h_TraceFilter))
  {
    TR_GetEndPosition(pos, h_TraceFilter);
    CloseHandle(h_TraceFilter);
    return true;
  }
  CloseHandle(h_TraceFilter);
  return false;
}
public bool TraceEntityFilterPlayer(int iEntity,int iContentsMask)
{
	return iEntity > MaxClients;
}
public bool TraceRayTryToHit(int entity,int mask)
{
	if(entity > 0 && entity <= MaxClients)
  {
    return false;
  }
	return true;
}
stock void F_GetEntityRenderColor(int entity,int color[4])
{
	static bool gotconfig = false;
	static char prop[32];

	if (!gotconfig) {
		Handle gc = LoadGameConfigFile("core.games");
		bool exists = GameConfGetKeyValue(gc, "m_clrRender", prop, sizeof(prop));
		CloseHandle(gc);

		if (!exists) {
			strcopy(prop, sizeof(prop), "m_clrRender");
		}

		gotconfig = true;
	}

	int offset = GetEntSendPropOffs(entity, prop);

	if (offset <= 0) {
		ThrowError("SetEntityRenderColor not supported by this mod");
	}

	for (int i=0; i < 4; i++)
	{
		color[i] = GetEntData(entity, offset + i, 1);
	}
}
stock int GetLastPlayerOfTeam(int team)
{
  int lastclient = 0;
  LoopAliveClients(i)
  {
    if(GetClientTeam(i) == team)
    {
      lastclient = i;
      break;
    }
  }
  return lastclient;
}
stock void PrecacheAndDownloadSounds()
{
  char buffer[64];
  for(int i = 1; i < sizeof(g_sFuriensHecle); i += 4)
  {
    Format(buffer, sizeof(buffer), "sound/gamesites/gs_heckle/%s.mp3", g_sFuriensHecle[i]);
    AddFileToDownloadsTable(buffer);
    ReplaceString(buffer, sizeof(buffer), "sound/", "");
    PrecacheSoundAny(buffer);
  }
}
public void PrecacheAdnDownloadModels(int client)
{
  for(int i; i < sizeof(s_FurienModelList); i++)
  {
    AddFileToDownloadsTable(s_FurienModelList[i]);
  }
  for(int i; i < sizeof(s_AntiFurienModelList); i++)
  {
    AddFileToDownloadsTable(s_AntiFurienModelList[i]);
  }
  PrecacheModel(MODEL_FURIEN);
  PrecacheModel(MODEL_FURIEN_ARMS);

  PrecacheModel(MODEL_ANTIFURIEN);
  PrecacheModel(MODEL_ANTIFURIEN_ARMS);
}
stock void ChangeTeamScore(int index, int score)
{
  CS_SetTeamScore(index, score);
  SetTeamScore(index, score);
}
stock void StripAllWeapons(int client)
{
	int ent;
	for (int i = 0; i <= 4; i++)
	{
    while ((ent = GetPlayerWeaponSlot(client, i)) != -1)
    {
			RemovePlayerItem(client, ent);
			RemoveEdict(ent);
    }
	}
}
stock void StripWeapons(int client)
{
	int wepIdx;
	for (int x = 0; x <= 5; x++)
	{
		if (x != 2 && (wepIdx = GetPlayerWeaponSlot(client, x)) != -1)
		{
			RemovePlayerItem(client, wepIdx);
			RemoveEdict(wepIdx);
		}
	}
}
stock void GetHitGroupName(int hitgroup, char[] buffer, int len)
{
  char HitGroupList[][] = {"","Hlava","Hrudník", "Břicho","Levá ruka","Pravá ruka","Levá noha", "Pravá noha"};
  Format(buffer, len, HitGroupList[hitgroup]);
}
stock void Client_LoadSettings(int client)
{
  char buffer[3];
  for(int i; i < Settings_Count; i++)
  {
    GetClientCookie(client, h_Settigs[i], buffer, sizeof(buffer));
    if(StrEqual(buffer, "") == false)
    {
      i_Settings[client][i] = StringToInt(buffer);
    }
    else
    {
      i_Settings[client][i] = 0;
    }
  }
}
stock void Client_SaveSettings(int client)
{
  char buffer[3];
  for(int i; i < Settings_Count; i++)
  {
    IntToString(i_Settings[client][i], buffer, sizeof(buffer));
    SetClientCookie(client, h_Settigs[i], buffer);
  }
}
stock bool Client_HasAnySpecialItem(int client)
{
  int count = 0;
  for (int i; i < Item_Count; i++)
  {
    if(i_ClientBoughtItems[client][Item_Count];)
  }
}
stock void RoundStartVariableUpdate(int client)
{
  //CT Spawn weapons
  b_SelectWepPrimary[client] = false;
  b_SelectWepSecondary[client] = false;

  for(int i; i < view_as<int>(e_ShopBought); i++)
  {
    i_bShop[client][i] = 0;
  }
}
stock void CheckClientViewMode(int client)
{
  bool b_ThirdPerson = view_as<bool>(i_Settings[client][Settings_ThirdPerson]);
  if(b_ThirdPerson == true)
  {
    ClientCommand(client, "thirdperson");
  }
  else
  {
    ClientCommand(client, "firstperson");
  }
}
/*stock void CheckClientViewMode(int client)
{
  Handle cvar = FindConVar("mp_forcecamera");
  bool b_ThirdPerson = view_as<bool>(i_Settings[client][Settings_ThirdPerson]);
  if(b_ThirdPerson == true)
  {
    SetEntPropEnt(client, Prop_Send, "m_hObserverTarget", 0);
    SetEntProp(client, Prop_Send, "m_iObserverMode", 1);
    SetEntProp(client, Prop_Send, "m_bDrawViewmodel", 0);
    SetEntProp(client, Prop_Send, "m_iFOV", 120);
    SendConVarValue(client, cvar, "1");
  }
  else
  {
    SetEntPropEnt(client, Prop_Send, "m_hObserverTarget", -1);
    SetEntProp(client, Prop_Send, "m_iObserverMode", 0);
    SetEntProp(client, Prop_Send, "m_bDrawViewmodel", 1);
    SetEntProp(client, Prop_Send, "m_iFOV", 90);
    char value[3];
    GetConVarString(cvar, value, sizeof(value));
    SendConVarValue(client, cvar, value);
  }
}*/
stock int CountPlayersInTeam(int team = 0)
{
  int x = 0;
  LoopClients(i)
  {
    if(team != 0)
    {
      if(GetClientTeam(i) == team)
      {
        x++;
      }
    }
    else
    {
      x++;
    }
  }
  return x;
}
stock int CountAlivePlayersInTeam(int team = 0)
{
  int x = 0;
  LoopAliveClients(i)
  {
    if(team != 0)
    {
      if(GetClientTeam(i) == team)
      {
        x++;
      }
    }
    else
    {
      x++;
    }
  }
  return x;
}
stock void RemoveSpecialItemEffects(int client)
{
  if(i_ClientActiveItem[client] == Item_Regenerace)
  {
    WipeHandle(t_SpecialItem_Regenerace[client]);
  }
}
stock bool IsWarmUp()
{
  if(GameRules_GetProp("m_bWarmupPeriod") == 1)
  {
    return true;
  }
  return false;
}
stock int GetClientDefuse(int client)
{
	return GetEntProp(client, Prop_Send, "m_bHasDefuser");
}
stock void FadeClient(int client, int r = 0, int g = 0, int b = 0, int a = 0)
{
	#define FFADE_STAYOUT 0x0008
	#define	FFADE_PURGE 0x0010
	Handle hFadeClient = StartMessageOne("Fade",client);
	if (GetUserMessageType() == UM_Protobuf)
	{
		int color[4];
		color[0] = r;
		color[1] = g;
		color[2] = b;
		color[3] = a;
		PbSetInt(hFadeClient, "duration", 0);
		PbSetInt(hFadeClient, "hold_time", 0);
		PbSetInt(hFadeClient, "flags", (FFADE_PURGE|FFADE_STAYOUT));
		PbSetColor(hFadeClient, "clr", color);
	}
	else
	{
		BfWriteShort(hFadeClient, 0);
		BfWriteShort(hFadeClient, 0);
		BfWriteShort(hFadeClient, (FFADE_PURGE|FFADE_STAYOUT));
		BfWriteByte(hFadeClient, r);
		BfWriteByte(hFadeClient, g);
		BfWriteByte(hFadeClient, b);
		BfWriteByte(hFadeClient, a);
	}
	EndMessage();
}
