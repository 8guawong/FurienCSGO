public Action Event_OnRoundPreStart(Event event, const char[] name, bool dontBroadcast)
{
  if(b_F_RoundSwtichTeams)
  {
    int ctscore = CS_GetTeamScore(CS_TEAM_CT);
    int tscore = CS_GetTeamScore(CS_TEAM_T);
    ChangeTeamScore(CS_TEAM_T,ctscore);
    ChangeTeamScore(CS_TEAM_CT,tscore);
    i_F_RoundWinStream = 0;
    LoopClients(i)
    {
      if(IsValidClient(i))
      {
        if(GetClientTeam(i) == CS_TEAM_CT)
        {
          CS_SwitchTeam(i, CS_TEAM_T);
        }
        else if(GetClientTeam(i) == CS_TEAM_T)
        {
          CS_SwitchTeam(i, CS_TEAM_CT);
        }
      }
    }
    b_F_RoundSwtichTeams = false;
  }
  return Plugin_Continue;
}
public Action Event_OnRoundStart(Event event, const char[] name, bool dontBroadcast)
{
  i_F_SuperKnifeBought = 0;
  int cts = CountPlayersInTeam(CS_TEAM_CT);
  float temp = float(cts) / float(3);
  i_F_SuperKnifeAvailable = RoundToFloor(temp);

  SetCvarInt("sv_enablebunnyhopping", 1);
  SetCvarInt("sv_staminamax", 0);
  SetCvarInt("sv_staminajumpcost", 0);
  SetCvarInt("sv_staminalandcost", 0);
  b_VIPDuel = false;
  if(cVi_DisableBomb > -1)
  {
    int index = -1;
    while ((index = FindEntityByClassname(index, "func_bomb_target")) != -1)
    {
      AcceptEntityInput(index, "Disable");
      if(cVi_DisableBomb > 0)
      {
        f_DisableBomb = GetEngineTime();
        b_DisableBomb = true;
      }
    }
  }
  if(cVb_BombBeacon == true)
  {
    WipeHandle(h_BombBeacon);
  }
  int i_maxmoney = -1;
  char s_maxmoneyname[MAX_NAME_LENGTH];
  LoopClients(i)
  {
    int money = Furien_GetClientMoney(i);
    if(money > i_maxmoney)
    {
      Format(s_maxmoneyname, sizeof(s_maxmoneyname), "%N", i);
      i_maxmoney = money;
    }
  }
  if(i_maxmoney != -1)
  {
    PrintToChatAll("%s Nejvíce peněz na serveru má \x07%s\x01 - \x10%d\x01$", CHAT_TAG, s_maxmoneyname, i_maxmoney);
  }
  return Plugin_Continue;
}
public Action Event_OnRoundEnd(Event event, const char[] name, bool dontBroadcast)
{
  int winner = event.GetInt("winner");
  b_DisableBomb = false;
  WipeHandle(h_BombBeacon);
  if(winner == CS_TEAM_T)
  {
    i_F_RoundWinStream++;
    if(i_F_RoundWinStream <= 3)
    {
      char buffer[512];
      Format(buffer,sizeof(buffer),"	<font color='#d43556'><b>FURIENI VYHRALI</b></font>");
      Format(buffer,sizeof(buffer),"%s\n		<font color='#2cf812'><b>|%d/3|</b></font>", buffer, i_F_RoundWinStream);
      PrintHintTextToAll(buffer);
      if(i_F_RoundWinStream == 3)
      {
        Format(buffer,sizeof(buffer),"%s\n <font size='14'>Furieni vyhráli 3x v řade. Prohazuji týmy.</font>",buffer);
        PrintHintTextToAll(buffer);
        b_F_RoundSwtichTeams = true;
        int tCount = CountPlayersInTeam();
        if(IsWarmUp() == false && tCount >= MINIMUM_PLAYERS_TO_GET_MONEY)
        {
          LoopClients(i)
          {
            if(GetClientTeam(i) == CS_TEAM_T)
            {
              Furien_AddClientMoney(i, WINNER_FURIEN_3STREAK);
              PrintToChat(i, "%s Získáváš \x0F%i$\x01 za 3 vyhraná kola v řadě",CHAT_TAG, WINNER_FURIEN_3STREAK);
            }
          }
        }
      }
    }
    else b_F_RoundSwtichTeams = false;
  }
  else if(winner == CS_TEAM_CT)
  {
    char buffer[512];
    Format(buffer,sizeof(buffer),"	<font color='#0066cc' size='22'><b>ANTI-FURIENI VYHRALI</b></font>");
    Format(buffer,sizeof(buffer),"%s\n	      <font size='14'>Proběhne prohození týmu.</font>",buffer);
    PrintHintTextToAll(buffer);
    i_F_RoundWinStream = 0;
    b_F_RoundSwtichTeams = true;
  }
  return Plugin_Continue;
}
public Action Event_OnPlayerSpawn(Event event, const char[] name, bool dontBroadcast)
{
  int client = GetClientOfUserId(event.GetInt("userid"));
  if(IsValidClient(client, true))
  {
    i_gClientGrenadeMode[client] = Grenade_Default;
    RoundStartVariableUpdate(client);
    SetEntityMoveType(client, MOVETYPE_WALK);
    SetEntityRenderMode(client, RENDER_TRANSCOLOR);
    SetEntityRenderColor(client);
    b_ClientWallHang[client] = false;
    b_IsClientInvisible[client] = false;
    b_IsClientInvisiblePre[client] = false;
    b_ClientMovedAfterSpawn[client] = false;
    t_SpecialItem_Regenerace[client] = null;
    b_g_ClientGrenadeDetonateRdy[client] = false;
    i_SpecialItem_RegeneraceMaxHealth[client] = 100;
    StripWeapons(client);
    CheckClientViewMode(client);
    if(GetClientTeam(client) == CS_TEAM_CT)
    {
      CreateTimer(0.2, Timer_CTSpawnPost, client);
      CreateTimer(1.0, Timer_CTRefillAmmo, GetClientUserId(client), TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
      GivePlayerItem(client, "weapon_flashbang");
      SetEntityGravity(client, 1.0);
      SetEntPropFloat(client, Prop_Data, "m_flLaggedMovementValue", 1.0);
      if(IsClientVIP(client, g_AccType[ACC_VIP]))
      {
        SetEntityModel(client, MODEL_ANTIFURIEN);
        SetEntPropString(client, Prop_Send, "m_szArmsModel", MODEL_ANTIFURIEN_ARMS);
        SetEntProp(client, Prop_Send, "m_ArmorValue", 50);
        SetEntProp(client, Prop_Send, "m_bHasDefuser", 1);
      }
      if(IsClientVIP(client, g_AccType[ACC_EVIP]))
      {
        SetEntProp(client, Prop_Send, "m_ArmorValue", 100);
      }
      SetEntProp(client, Prop_Send, "m_bHasHelmet", 0);
    }
    else if(GetClientTeam(client) == CS_TEAM_T)
    {
      if(i_Settings[client][Settings_F_OpenMainMenu_RS] == 0)
      {
        CreateTimer(0.2, Timer_TSpawnPost, client);
      }
      SetEntProp(client, Prop_Send, "m_ArmorValue", 0);
      SetEntProp(client, Prop_Send, "m_bHasHelmet", 0);
      FadeClient(client);
      if(IsClientVIP(client, g_AccType[ACC_VIP]))
      {
        SetEntityModel(client, MODEL_FURIEN);
        SetEntPropString(client, Prop_Send, "m_szArmsModel", MODEL_FURIEN_ARMS);
        SetEntityHealth(client, 110);
        i_SpecialItem_RegeneraceMaxHealth[client] = 110;
        GivePlayerItem(client, "weapon_hegrenade");
      }
      if(IsClientVIP(client, g_AccType[ACC_EVIP]))
      {
        SetEntityHealth(client, 120);
        i_SpecialItem_RegeneraceMaxHealth[client] = 120;
      }
    }
  }
  return Plugin_Continue;
}
public Action Event_OnTaGrenadeDetonate(Event event, const char[] name, bool dontBroadcast)
{
  int client = GetClientOfUserId(event.GetInt("userid"));
  int entity = event.GetInt("entityid");
  float f_GrenadePos[3];
  float f_EnemyPos[3];
  GetEntPropVector(entity, Prop_Send, "m_vecOrigin", f_GrenadePos);
  LoopAliveClients(i)
  {
    if(GetClientTeam(i) == CS_TEAM_T && GetClientTeam(client) == CS_TEAM_CT)
    {
      GetEntPropVector(i, Prop_Send, "m_vecOrigin", f_EnemyPos);
      if(GetVectorDistance(f_GrenadePos, f_EnemyPos) < 221.0)
      {
        if(b_IsClientInvisible[i] == true)
        {
          b_IsClientInvisible[i] = false;
          b_IsClientInvisiblePre[i] = false;
          SetEntityRenderColor(i);
        }
      }
    }
  }
  return Plugin_Handled;
}
public Action Event_OnPlayerDeath(Event event, const char[] name, bool dontBroadcast)
{
  int victim = GetClientOfUserId(event.GetInt("userid"));
  int attacker = GetClientOfUserId(event.GetInt("attacker"));
  if(IsValidClient(victim))
  {
    if(i_ClientActiveItem[victim] == Item_Regenerace)
		{
			WipeHandle(t_SpecialItem_Regenerace[victim]);
		}
    t_SpecialItem_Regenerace[victim] = null;
    if(IsValidClient(attacker))
    {
      if(attacker != victim)
      {
        if(IsClientVIP(attacker, g_AccType[ACC_EVIP]))
        {
          SetEntityHealth(attacker, GetClientHealth(attacker)+3);
        }
      }
      if(i_ClientActiveItem[attacker] == Item_DoplnovaniNaboju)
      {
        int cWeapon = GetEntPropEnt(attacker, Prop_Send, "m_hActiveWeapon");
        if(IsValidEntity(cWeapon))
        {
          int iWeaponindex = GetEntProp(cWeapon, Prop_Send, "m_iItemDefinitionIndex");
          for(int i; i < sizeof(g_iAntiFuriensWeaponsId); i++)
          {
            if(iWeaponindex == g_iAntiFuriensWeaponsId[i])
            {
              SetEntData(cWeapon, g_MainClipOffset, g_iAntiFuriensWeaponsAmmoPrimary[i]+1);
              break;
            }
          }
        }
      }
      int tCount = CountPlayersInTeam();
      if(IsWarmUp() == false && tCount >= MINIMUM_PLAYERS_TO_GET_MONEY)
      {
        if(b_VIPDuel == true)
        {
          PrintToChatAll("%s %N právě ukázal %N jak se hraje Furien!", CHAT_TAG, attacker, victim);
        }
        else
        {
          CheckVIPDuel();
        }
        if(GetClientTeam(victim) != GetClientTeam(attacker))
        {
          int tempMoney = 0;
          if(GetClientTeam(victim) == CS_TEAM_T)
          {
            if(IsClientVIP(attacker, g_AccType[ACC_EVIP]))
            {
              tempMoney = 25;
            }
            else if(IsClientVIP(attacker, g_AccType[ACC_VIP]))
            {
              tempMoney = 20;
            }
            else
            {
              tempMoney = 15;
            }
          }
          else if(GetClientTeam(victim) == CS_TEAM_CT)
          {
            if(IsClientVIP(attacker, g_AccType[ACC_EVIP]))
            {
              tempMoney = 20;
            }
            else if(IsClientVIP(attacker, g_AccType[ACC_VIP]))
            {
              tempMoney = 15;
            }
            else
            {
              tempMoney = 10;
            }
          }
          PrintToChat(attacker, "%s Získáváš \x0F%i\x01$ za zabití hráče \x0F%N", CHAT_TAG, b_VIPDuel == true?tempMoney+5:tempMoney, victim);
          Furien_AddClientMoney(attacker, b_VIPDuel == true?tempMoney+5:tempMoney);
        }
      }
      else
      {
        if(IsWarmUp() == true)
        {
          PrintToChat(attacker, "%s Získávání penež je při rozehře vypnuté.", CHAT_TAG);
        }
        else if(tCount < MINIMUM_PLAYERS_TO_GET_MONEY)
        {
          PrintToChat(attacker, "%s K získávání peněz není na serveru dostatek hráčů", CHAT_TAG);
        }
      }
    }
  }
  return Plugin_Continue;
}
public Action Event_OnPlayerHurt(Event event, const char[] name, bool dontbroadcast)
{
  int victim = GetClientOfUserId(event.GetInt("userid"));
  int attacker = GetClientOfUserId(event.GetInt("attacker"));
  int hitgroup = event.GetInt("hitgroup");
  int dmg = event.GetInt("dmg_health");
  if(IsValidClient(victim))
  {
    if(IsValidClient(attacker))
    {
      if(GetClientTeam(attacker) != GetClientTeam(victim))
      {
        if(GetClientTeam(attacker) == CS_TEAM_CT)
        {
          float f_vector[3];
          GetEntPropVector(victim, Prop_Data, "m_vecVelocity", f_vector);
          NormalizeVector(f_vector, f_vector);
          ScaleVector(f_vector, 230.0);
          TeleportEntity(victim, NULL_VECTOR, NULL_VECTOR, f_vector);
          if(i_Settings[attacker][Settings_ShowDmg] == 1)
          {
            char buffer[512];
            char sHitGroup[32];
            GetHitGroupName(hitgroup, sHitGroup, sizeof(sHitGroup));
            Format(buffer, sizeof(buffer), " Zasáhnut do: <font color='#a0db8e'>%s</font>\n",sHitGroup);
            Format(buffer, sizeof(buffer), "%s Poškození: <font color='#ff4e8d'>-%i HP</font>\n", buffer, dmg);
            Format(buffer, sizeof(buffer), "%s	      <font size='14' color='#0066cc'>www.GameSites.cz</font>", buffer);
            PrintHintText(attacker, buffer);
          }
        }
      }
    }
  }
}
public Action Event_OnPlayerPreTeam(Event event, const char[] name, bool dontbroadcast)
{
  int client = GetClientOfUserId(event.GetInt("userid"));
  i_ClientActiveItem[client] = Item_None;
  dontbroadcast = true;
  return Plugin_Changed;
}
public Action Event_OnBombPlanted(Event event, const char[] name, bool dontBroadcast)
{
  int client = GetClientOfUserId(event.GetInt("userid"));
  int tCount = CountPlayersInTeam();
  if(IsWarmUp() == false && tCount >= MINIMUM_PLAYERS_TO_GET_MONEY)
  {
    PrintToChat(client, "%s Získáváš \x0F%i\x01$ za položení bomby", CHAT_TAG, FURIEN_BOMB_PLANTED);
    Furien_AddClientMoney(client, FURIEN_BOMB_PLANTED);
  }
  else
  {
    if(IsWarmUp() == true)
    {
      PrintToChat(client, "%s Získávání penež je při rozehře vypnuté.", CHAT_TAG);
    }
    else if(tCount < MINIMUM_PLAYERS_TO_GET_MONEY)
    {
      PrintToChat(client, "%s K získávání peněz není na serveru dostatek hráčů", CHAT_TAG);
    }
  }
  if(cVb_BombBeacon == true)
  {
    int index = -1;
    while ((index = FindEntityByClassname(index, "planted_c4")) != -1)
    {
      GetEntPropVector(index, Prop_Send, "m_vecOrigin", f_BombBeaconPos);
      h_BombBeacon = CreateTimer(cVf_BombBeacon_Delay, Timer_BombBeacon, index, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
    }
  }
  return Plugin_Continue;
}
public Action Event_OnBombDefused(Event event, const char[] name, bool dontBroadcast)
{
  int client = GetClientOfUserId(event.GetInt("userid"));
  int tCount = CountPlayersInTeam();
  if(IsWarmUp() == false && tCount >= MINIMUM_PLAYERS_TO_GET_MONEY)
  {
    PrintToChat(client, "%s Získáváš \x0F%i\x01$ za zneškodnění bomby", CHAT_TAG, FURIEN_BOMB_DEFUSED);
    Furien_AddClientMoney(client, FURIEN_BOMB_DEFUSED);
  }
  else
  {
    if(IsWarmUp() == true)
    {
      PrintToChat(client, "%s Získávání penež je při rozehře vypnuté.", CHAT_TAG);
    }
    else if(tCount < MINIMUM_PLAYERS_TO_GET_MONEY)
    {
      PrintToChat(client, "%s K získávání peněz není na serveru dostatek hráčů", CHAT_TAG);
    }
  }
  if(cVb_BombBeacon == true)
  {
    WipeHandle(h_BombBeacon);
  }
  return Plugin_Continue;
}
public Action Event_OnBombExploded(Event event, const char[] name, bool dontBroadcast)
{
  if(cVb_BombBeacon == true)
  {
    WipeHandle(h_BombBeacon);
  }
  return Plugin_Continue;
}
public Action Event_OnPlayerFlashed(Event event, const char[] name, bool dontBroadcast)
{
  int client = GetClientOfUserId(event.GetInt("userid"));
  if(IsValidClient(client, true))
  {
    if(IsClientVIP(client, g_AccType[ACC_EVIP]))
    {
      float fDuration = GetEntPropFloat(client, Prop_Send, "m_flFlashDuration");
      SetEntPropFloat(client, Prop_Send, "m_flFlashDuration", fDuration*0.8);
    }
  }
}
