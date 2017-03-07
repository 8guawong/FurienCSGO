public Action Timer_BombBeacon(Handle timer, any index)
{
  TE_SetupBeamRingPoint(f_BombBeaconPos, 1.0, cVf_BombBeacon_Radius, i_BeamIndex, -1, 0, 32, cVf_BombBeacon_Life, cVf_BombBeacon_Width, 1.0, cVb_BombBeacon_RandomColor?Beacon_RandomColor():cVi_BombBeacon_Color, 0, 0);
  TE_SendToAll();
}
public Action Timer_CTSpawnPost(Handle timer, any client)
{
  SetEntProp(client, Prop_Send, "m_iHideHUD", GetEntProp(client, Prop_Send, "m_iHideHUD") | HIDE_RADAR);
  if(IsWarmUp() == false)
  {
    Menu_SelectWeapon(client);
  }
}
public Action Timer_TSpawnPost(Handle timer, any client)
{
  if(IsWarmUp() == false)
  {
    if(i_Settings[client][Settings_F_OpenMainMenu_RS] == 0)
    {
      Menu_FurienMain(client);
    }
  }
}
public Action Timer_CheckAdminTags(Handle timer)
{
  LoopClients(i)
  {
    if(IsClientVIP(i, g_AccType[ACC_VIP]))
    {
      CS_SetClientClanTag(i, "[VIP]");
    }
    else
    {
      CS_SetClientClanTag(i, "");
    }
  }
}
public Action Timer_SpecialItem_Zmateni(Handle timer, any userid)
{
  int client = GetClientOfUserId(userid);
  if(IsValidClient(client, true))
  {
    WipeHandle(t_SpecialItem_Zmateni[client]);
  }
  else
  {
    WipeHandle(t_SpecialItem_Zmateni[client]);
  }
  return Plugin_Continue;
}
public Action Timer_SpecialItem_Regenerace(Handle timer, any userid)
{
  int client = GetClientOfUserId(userid);
  if(IsValidClient(client, true))
  {
    int CurrentHealth = GetClientHealth(client);
    if((CurrentHealth + 2) > i_SpecialItem_RegeneraceMaxHealth[client])
    {
      SetEntityHealth(client, i_SpecialItem_RegeneraceMaxHealth[client]);
      WipeHandle(t_SpecialItem_Regenerace[client]);
    }
    else
    {
      SetEntityHealth(client, CurrentHealth + 2);
    }
  }
  else
  {
    WipeHandle(t_SpecialItem_Regenerace[client]);
    return Plugin_Stop;
  }
  return Plugin_Continue;
}
public Action Timer_SpecialItem_DrtiveStrely(Handle timer, any userid)
{
  int client = GetClientOfUserId(userid);
  if(IsValidClient(client, true))
  {
    SetEntityMoveType(client, MOVETYPE_WALK);
    WipeHandle(t_SpecialItem_DrtiveStrely[client]);
  }
  else
  {
    WipeHandle(t_SpecialItem_DrtiveStrely[client]);
  }
}
public Action Timer_CTRefillAmmo(Handle timer, any userid)
{
  int client = GetClientOfUserId(userid);
  if(IsValidClient(client, true))
  {
    if(GetClientTeam(client) == CS_TEAM_CT)
    {
      int cWeapon = GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon");
      if(IsValidEntity(cWeapon))
      {
        int iWeaponindex = GetEntProp(cWeapon, Prop_Send, "m_iItemDefinitionIndex");
        for(int i; i < sizeof(g_iAntiFuriensWeaponsId); i++)
        {
          if(iWeaponindex == g_iAntiFuriensWeaponsId[i])
          {
            SetEntProp(cWeapon, Prop_Send, "m_iPrimaryReserveAmmoCount", g_iAntiFuriensWeaponsAmmoSecondary[i]);
            break;
          }
        }
      }
    }
    else
    {
      return Plugin_Stop;
    }
  }
  else
  {
    return Plugin_Stop;
  }
  return Plugin_Continue;
}
