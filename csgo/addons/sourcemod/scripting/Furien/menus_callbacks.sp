public int h_AF_SelectWeapon(Menu menu, MenuAction action, int client, int Position)
{
  if(IsValidClient(client, true))
  {
    if(GetClientTeam(client) == CS_TEAM_CT)
    {
      if(action == MenuAction_Select)
      {
        char Item[10];
        menu.GetItem(Position, Item, sizeof(Item));
        int index = StringToInt(Item);
        Furien_TakeClientMoney(client, StringToInt(g_sAntiFuriensWeps[index+2]));
        GivePlayerItem(client, g_sAntiFuriensWeps[index+1]);
        b_SelectWepPrimary[client] = true;
        Menu_SelectSecondaryWeapon(client);
      }
    }
  }
}
public int h_AF_SelectSecondaryWeapon(Menu menu, MenuAction action, int client, int Position)
{
  if(IsValidClient(client, true))
  {
    if(GetClientTeam(client) == CS_TEAM_CT)
    {
      if(action == MenuAction_Select)
      {
        char Item[10];
        menu.GetItem(Position, Item, sizeof(Item));
        int index = StringToInt(Item);
        Furien_TakeClientMoney(client, StringToInt(g_sAntiFuriensSecondaryWeps[index+2]));
        GivePlayerItem(client, g_sAntiFuriensSecondaryWeps[index+1]);
        b_SelectWepSecondary[client] = true;
        if(i_Settings[client][Settings_F_OpenMainMenu_RS] == 0)
        {
          Menu_FurienMain(client);
        }
      }
    }
  }
}
public int h_F_Heckle(Menu menu, MenuAction action, int client, int Position)
{
  if(IsValidClient(client, true))
  {
    if(action == MenuAction_Select)
    {
      if(GetClientTeam(client) == CS_TEAM_T)
      {
        if(b_IsClientInvisible[client] == true)
        {
          char Item[10];
          char buffer[50];
          menu.GetItem(Position, Item, sizeof(Item));
          int index = StringToInt(Item);
          Furien_TakeClientMoney(client, StringToInt(g_sFuriensHecle[index+2]));
          Format(buffer, sizeof(buffer), "gamesites/gs_heckle/%s.mp3",g_sFuriensHecle[index+1]);
          EmitSoundToAllAny(buffer, client);
          GivePlayerItem(client, g_sFuriensHecle[index+1]);
        }
        else
        {
          PrintToChat(client, "Musíš být neviditelný!");
        }
      }
    }
  }
}
public int h_F_MainMenu(Menu menu, MenuAction action, int client, int Position)
{
  if(IsValidClient(client))
  {
    if(action == MenuAction_Select)
    {
      char Item[12];
      menu.GetItem(Position, Item, sizeof(Item));
      if(StrEqual(Item, "vyberzbrane"))
      {
        if(IsPlayerAlive(client) && GetClientTeam(client) == CS_TEAM_CT)
        {
          if(b_SelectWepPrimary[client] == false)
          {
            Menu_SelectWeapon(client);
          }
          else if(b_SelectWepPrimary[client] == true && b_SelectWepSecondary[client] == false)
          {
            Menu_SelectSecondaryWeapon(client);
          }
        }
      }
      else if(StrEqual(Item, "provokovat"))
      {
        if(IsPlayerAlive(client) && GetClientTeam(client) == CS_TEAM_T)
        {
          Menu_Heckle(client);
        }
      }
      else if(StrEqual(Item, "obchod"))
      {
        if(IsPlayerAlive(client))
        {
          if(GetClientTeam(client) == CS_TEAM_CT)
          {
            Menu_AF_Shop(client);
          }
          else if(GetClientTeam(client) == CS_TEAM_T)
          {
            Menu_F_Shop(client);
          }
        }
      }
      else if(StrEqual(Item, "itemy"))
      {
        Menu_SpecialItem(client);
      }
      else if(StrEqual(Item, "aitem"))
      {
        Menu_ChooseItem(client);
      }
      else if(StrEqual(Item, "info"))
      {
        char temp[256];
        char sCountryTag[3];
        char sIP[26];
        GetClientIP(client, sIP, sizeof(sIP));
        GeoipCode2(sIP, sCountryTag);
        if(StrEqual(sCountryTag, "CZ") || StrEqual(sCountryTag, "SK"))
        {
          Format(temp, sizeof(temp), "http://fastdl.gamesites.cz/global/motd/furien/info_popishry_%s.html", sCountryTag);
          ShowMOTDPanel(client, "www.GameSites.cz", temp, MOTDPANEL_TYPE_URL);
        }
        else
        {
          ShowMOTDPanel(client, "www.GameSites.cz", "http://fastdl.gamesites.cz/global/motd/furien/info_popishry_cz.html", MOTDPANEL_TYPE_URL);
        }
      }
      else if(StrEqual(Item, "pravidla"))
      {
        char temp[256];
        char sCountryTag[3];
        char sIP[26];
        GetClientIP(client, sIP, sizeof(sIP));
        GeoipCode2(sIP, sCountryTag);
        if(StrEqual(sCountryTag, "CZ") || StrEqual(sCountryTag, "SK"))
        {
          Format(temp, sizeof(temp), "http://fastdl.gamesites.cz/global/motd/furien/info_pravidla_%s.html", sCountryTag);
          ShowMOTDPanel(client, "www.GameSites.cz", temp, MOTDPANEL_TYPE_URL);
        }
        else
        {
          ShowMOTDPanel(client, "www.GameSites.cz", "http://fastdl.gamesites.cz/global/motd/furien/info_pravidla_CZ.html", MOTDPANEL_TYPE_URL);
        }
      }
      else if(StrEqual(Item, "nastaveni"))
      {
        Menu_Settings(client);
      }
      else if(StrEqual(Item, "vip"))
      {
        char temp[128];
        int port = GetConVarInt(FindConVar("hostport"));
        Format(temp, sizeof(temp), "http://fastdl.gamesites.cz/global/motd/vip_aktivace_start_furien%i.html", port);
        ShowMOTDPanel(client, "www.GameSites.cz", temp, MOTDPANEL_TYPE_URL);
      }
    }
  }
}
public int m_AF_Shop(Menu menu, MenuAction action, int client, int Position)
{
  if(IsValidClient(client, true))
  {
    if(action == MenuAction_Select)
    {
      if(GetClientTeam(client) == CS_TEAM_CT)
      {
        char Item[20];
        menu.GetItem(Position, Item, sizeof(Item));
        if(StrEqual(Item, "defuse"))
        {
          SetEntProp(client, Prop_Send, "m_bHasDefuser", 1);
          Furien_TakeClientMoney(client, i_AF_Shop[AF_Item_Defuse]);
        }
        else if(StrEqual(Item, "vesthelp"))
        {
          SetEntProp(client, Prop_Send, "m_ArmorValue", 100);
          SetEntProp(client, Prop_Send, "m_bHasHelmet", 1);
          Furien_TakeClientMoney(client, i_AF_Shop[AF_Item_VestHelp]);
        }
        else if(StrEqual(Item, "lekarnicka"))
        {
          GivePlayerItem(client, "weapon_healthshot");
          Furien_TakeClientMoney(client, i_AF_Shop[AF_Item_Lekarnicka]);
          i_bShop[client][Shop_Lekarnicka]++;
        }
        else if(StrEqual(Item, "odhlaovaci"))
        {
          GivePlayerItem(client, "weapon_tagrenade");
          Furien_TakeClientMoney(client, i_AF_Shop[AF_Item_OdhalovaciGranat]);
          i_bShop[client][Shop_OhdalovaciGranat]++;
        }
      }
    }
  }
}
public int m_F_Shop(Menu menu, MenuAction action, int client, int Position)
{
  if(IsValidClient(client, true))
  {
    if(action == MenuAction_Select)
    {
      if(GetClientTeam(client) == CS_TEAM_T)
      {
        char Item[20];
        menu.GetItem(Position, Item, sizeof(Item));
        if(StrEqual(Item, "hegrenade"))
        {
          GivePlayerItem(client, "weapon_hegrenade");
          Furien_TakeClientMoney(client, i_F_Shop[F_Item_HeGrenade]);
          i_bShop[client][Shop_HeGrenade]++;
        }
        else if(StrEqual(Item, "lekarnicka"))
        {
          GivePlayerItem(client, "weapon_healthshot");
          Furien_TakeClientMoney(client, i_F_Shop[F_Item_Lekarnicka]);
          i_bShop[client][Shop_Lekarnicka]++;
        }
        else if(StrEqual(Item, "superknife"))
        {
          if(IsClientVIP(client, g_AccType[ACC_EVIP]))
          {
            Furien_TakeClientMoney(client, i_F_Shop[F_Item_SuperKnife]);
            i_bShop[client][Shop_SuperKnife]++;
            i_F_SuperKnifeBought++;
          }
          else if(i_F_SuperKnifeBought < i_F_SuperKnifeAvailable)
          {
            Furien_TakeClientMoney(client, i_F_Shop[F_Item_SuperKnife]);
            i_bShop[client][Shop_SuperKnife]++;
            i_F_SuperKnifeBought++;
          }
          else
          {
            PrintToChat(client, "%s Super knife momentálně nedostupný!",CHAT_TAG);
          }
        }
        else if(StrEqual(Item, "electricgun"))
        {
          GivePlayerItem(client, "weapon_taser");
          Furien_TakeClientMoney(client, i_F_Shop[F_Item_ElectricGun]);
          i_bShop[client][Shop_ElectricGun]++;
        }
        else if(StrEqual(Item, "wallhang"))
        {
          Furien_TakeClientMoney(client, i_F_Shop[F_Item_Wallhang]);
          i_bShop[client][Shop_Wallhang]++;
        }
      }
    }
  }
}
public int m_Settings(Menu menu, MenuAction action, int client, int Position)
{
  if(IsValidClient(client))
  {
    if(action == MenuAction_Select)
    {
      char Item[20];
      menu.GetItem(Position, Item, sizeof(Item));
      if(StrEqual(Item, "showdmg"))
      {
        i_Settings[client][Settings_ShowDmg] = !i_Settings[client][Settings_ShowDmg];
        Menu_Settings(client);
      }
      else if(StrEqual(Item, "thirdperson"))
      {
        i_Settings[client][Settings_ThirdPerson] = !i_Settings[client][Settings_ThirdPerson];
        CheckClientViewMode(client);
        Menu_Settings(client);
      }
      else if(StrEqual(Item, "mainmenuf"))
      {
        i_Settings[client][Settings_F_OpenMainMenu_RS] = !i_Settings[client][Settings_F_OpenMainMenu_RS];
        Menu_Settings(client);
      }
      else if(StrEqual(Item, "mainmenuonf"))
      {
        i_Settings[client][Settings_OpenMainMenu_onF] = !i_Settings[client][Settings_OpenMainMenu_onF];
        Menu_Settings(client);
      }
    }
  }
}
public int m_SpecialItem(Menu menu, MenuAction action, int client, int Position)
{
  if(IsValidClient(client))
  {
    if(action == MenuAction_Select)
    {
      char Item[20];
      menu.GetItem(Position, Item, sizeof(Item));
      if(StrEqual(Item, "regenerace"))
      {
        i_ClientBoughtItems[client][Item_Regenerace] = 1;
        Furien_TakeClientMoney(client, i_SpecialItem[SItem_Regenerace]);
      }
      else if(StrEqual(Item, "mrstnost"))
      {
        i_ClientBoughtItems[client][Item_Mrstnost] = 1;
        Furien_TakeClientMoney(client, i_SpecialItem[SItem_Mrstnost]);
      }
      else if(StrEqual(Item, "zmateni"))
      {
        i_ClientBoughtItems[client][Item_Zmateni] = 1;
        Furien_TakeClientMoney(client, i_SpecialItem[SItem_Zmateni]);
      }
      else if(StrEqual(Item, "zaseknutizbrane"))
      {
        i_ClientBoughtItems[client][Item_ZaseknutiZbrane] = 1;
        Furien_TakeClientMoney(client, i_SpecialItem[SItem_ZaseknutiZbrane]);
      }
      else if(StrEqual(Item, "multijump"))
      {
        i_ClientBoughtItems[client][Item_MultiJump] = 1;
        Furien_TakeClientMoney(client, i_SpecialItem[SItem_MultiJump]);
      }
      else if(StrEqual(Item, "drtivestrely"))
      {
        i_ClientBoughtItems[client][Item_DrtiveStrely] = 1;
        Furien_TakeClientMoney(client, i_SpecialItem[SItem_DrtiveStrely]);
      }
      else if(StrEqual(Item, "chytreoko"))
      {
        i_ClientBoughtItems[client][Item_ChytreOko] = 1;
        Furien_TakeClientMoney(client, i_SpecialItem[SItem_ChytreOko]);
      }
      else if(StrEqual(Item, "ammorefill"))
      {
        i_ClientBoughtItems[client][Item_DoplnovaniNaboju] = 1;
        Furien_TakeClientMoney(client, i_SpecialItem[SItem_DoplnovaniNaboju]);
      }
    }
  }
}
public int m_ChooseItem(Menu menu, MenuAction action, int client, int Position)
{
  if(IsValidClient(client, true))
  {
    if(action == MenuAction_Select)
    {
      char Item[20];
      menu.GetItem(Position, Item, sizeof(Item));
      RemoveSpecialItemEffects(client);
      if(StrEqual(Item, "buysome"))
      {
        Menu_SpecialItem(client);
      }
      else if(StrEqual(Item, "none"))
      {
        i_ClientActiveItem[client] = Item_None;
      }
      else if(StrEqual(Item, "regenerace"))
      {
        i_ClientActiveItem[client] = Item_Regenerace;
        if(GetClientHealth(client) < i_SpecialItem_RegeneraceMaxHealth[client])
        {
          if(t_SpecialItem_Regenerace[client] == null)
          {
            t_SpecialItem_Regenerace[client] = CreateTimer(1.0, Timer_SpecialItem_Regenerace, GetClientUserId(client), TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
          }
        }
      }
      else if(StrEqual(Item, "multijump"))
      {
        i_ClientActiveItem[client] = Item_MultiJump;
      }
      else
      {
        if(GetClientTeam(client) == CS_TEAM_CT)
        {
          if(StrEqual(Item, "drtivestrely"))
          {
            i_ClientActiveItem[client] = Item_DrtiveStrely;
          }
          else if(StrEqual(Item, "chytreoko"))
          {
            i_ClientActiveItem[client] = Item_ChytreOko;
          }
          else if(StrEqual(Item, "ammorefill"))
          {
            i_ClientActiveItem[client] = Item_DoplnovaniNaboju;
          }
        }
        else if(GetClientTeam(client) == CS_TEAM_T)
        {
          if(StrEqual(Item, "mrstnost"))
          {
            i_ClientActiveItem[client] = Item_Mrstnost;
          }
          else if(StrEqual(Item, "zmateni"))
          {
            i_ClientActiveItem[client] = Item_Zmateni;
          }
          else if(StrEqual(Item, "zaseknutizbrane"))
          {
            i_ClientActiveItem[client] = Item_ZaseknutiZbrane;
          }
        }
      }
    }
  }
}
