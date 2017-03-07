public void Menu_SelectWeapon(int client)
{
  char buffer[50];
  char temp[32];
  char ch_int[10];
  Menu menu = CreateMenu(h_AF_SelectWeapon);
  menu.SetTitle("Zvol si zbraň [%i]", Furien_GetClientMoney(client));
  for(int i; i < sizeof(g_sAntiFuriensWeps); i += 4)
  {
    bool b_viponly = false;
    int i_VIPType = StringToInt(g_sAntiFuriensWeps[i+3]);
    if(i_VIPType > 0)
    {
      b_viponly = true;
    }
    IntToString(i, ch_int, sizeof(ch_int));
    Format(temp, sizeof(temp), "[%s]",b_viponly == true?(IsClientVIP(client, g_AccType[i_VIPType])?g_sAntiFuriensWeps[i+2]:i_VIPType == ACC_VIP?"Pouze pro VIP":"Pouze pro EVIP"):g_sAntiFuriensWeps[i+2]);
    Format(buffer,sizeof(buffer), "%s %s",g_sAntiFuriensWeps[i], StringToInt(g_sAntiFuriensWeps[i+2]) > 0?temp:b_viponly == true?(IsClientVIP(client, g_AccType[i_VIPType])?"":i_VIPType == ACC_VIP?"[Pouze pro VIP]":"[Pouze pro EVIP]"):"");
    menu.AddItem(ch_int, buffer, b_viponly == true?(IsClientVIP(client, g_AccType[i_VIPType])?(Furien_GetClientMoney(client) < StringToInt(g_sAntiFuriensWeps[i+2])?ITEMDRAW_DISABLED:ITEMDRAW_DEFAULT):ITEMDRAW_DISABLED):(Furien_GetClientMoney(client) < StringToInt(g_sAntiFuriensWeps[i+2])?ITEMDRAW_DISABLED:ITEMDRAW_DEFAULT));
  }
  menu.Pagination = MENU_NO_PAGINATION;
  menu.ExitButton = true;
  menu.Display(client, MENU_TIME_FOREVER);
}
public void Menu_SelectSecondaryWeapon(int client)
{
  char buffer[50];
  char temp[32];
  char ch_int[10];
  Menu menu = CreateMenu(h_AF_SelectSecondaryWeapon);
  menu.SetTitle("Zvol si pistol [%i]", Furien_GetClientMoney(client));
  for(int i; i < sizeof(g_sAntiFuriensSecondaryWeps); i += 4)
  {
    bool b_viponly = false;
    int i_VIPType = StringToInt(g_sAntiFuriensSecondaryWeps[i+3]);
    if(i_VIPType > 0)
    {
      b_viponly = true;
    }
    IntToString(i, ch_int, sizeof(ch_int));
    Format(temp, sizeof(temp), "[%s]",b_viponly == true?(IsClientVIP(client, g_AccType[i_VIPType])?g_sAntiFuriensSecondaryWeps[i+2]:i_VIPType == ACC_VIP?"Pouze pro VIP":"Pouze pro EVIP"):g_sAntiFuriensSecondaryWeps[i+2]);
    Format(buffer,sizeof(buffer), "%s %s",g_sAntiFuriensSecondaryWeps[i], StringToInt(g_sAntiFuriensSecondaryWeps[i+2]) > 0?temp:b_viponly == true?(IsClientVIP(client, g_AccType[i_VIPType])?"":i_VIPType == ACC_VIP?"[Pouze pro VIP]":"[Pouze pro EVIP]"):"");
    menu.AddItem(ch_int, buffer, b_viponly == true?(IsClientVIP(client, g_AccType[i_VIPType])?(Furien_GetClientMoney(client) < StringToInt(g_sAntiFuriensSecondaryWeps[i+2])?ITEMDRAW_DISABLED:ITEMDRAW_DEFAULT):ITEMDRAW_DISABLED):(Furien_GetClientMoney(client) < StringToInt(g_sAntiFuriensSecondaryWeps[i+2])?ITEMDRAW_DISABLED:ITEMDRAW_DEFAULT));
  }
  menu.Display(client, MENU_TIME_FOREVER);
  menu.ExitButton = true;
}
public void Menu_Heckle(int client)
{
  char buffer[32];
  char temp[32];
  char ch_int[10];
  Menu menu = CreateMenu(h_F_Heckle);
  menu.SetTitle("- Provokovat [%i]-", Furien_GetClientMoney(client));
  for(int i; i < sizeof(g_sFuriensHecle); i += 4)
  {
    bool b_viponly = false;
    int i_VIPType = StringToInt(g_sFuriensHecle[i+3]);
    if(i_VIPType > 0)
    {
      b_viponly = true;
    }
    IntToString(i, ch_int, sizeof(ch_int));
    Format(temp, sizeof(temp), "[%s]",b_viponly == true?(IsClientVIP(client, g_AccType[i_VIPType])?g_sFuriensHecle[i+2]:i_VIPType == ACC_VIP?"Pouze pro VIP":"Pouze pro EVIP"):g_sFuriensHecle[i+2]);
    Format(buffer,sizeof(buffer), "%s %s",g_sFuriensHecle[i], StringToInt(g_sFuriensHecle[i+2]) > 0?temp:b_viponly == true?(IsClientVIP(client, g_AccType[i_VIPType])?"":i_VIPType == ACC_VIP?"[Pouze pro VIP]":"[Pouze pro EVIP]"):"");
    menu.AddItem(ch_int, buffer, b_viponly == true?(IsClientVIP(client, g_AccType[i_VIPType])?(Furien_GetClientMoney(client) < StringToInt(g_sFuriensHecle[i+2])?ITEMDRAW_DISABLED:ITEMDRAW_DEFAULT):ITEMDRAW_DISABLED):(Furien_GetClientMoney(client) < StringToInt(g_sFuriensHecle[i+2])?ITEMDRAW_DISABLED:ITEMDRAW_DEFAULT));
  }
  menu.ExitButton = true;
  menu.Display(client, MENU_TIME_FOREVER);
}
public void Menu_FurienMain(int client)
{
  Menu menu = CreateMenu(h_F_MainMenu);
  menu.SetTitle("- FurienMod -");
  if(GetClientTeam(client) == CS_TEAM_CT)
  {
    menu.AddItem("vyberzbrane", "Výběr zbraně", IsWarmUp() == true?ITEMDRAW_DISABLED:((b_SelectWepPrimary[client] == true && b_SelectWepSecondary[client] == true)?ITEMDRAW_DISABLED:IsPlayerAlive(client)?ITEMDRAW_DEFAULT:ITEMDRAW_DISABLED));
  }
  else if(GetClientTeam(client) == CS_TEAM_T)
  {
    menu.AddItem("provokovat", "Provokovat", IsWarmUp() == true?ITEMDRAW_DISABLED:(IsPlayerAlive(client)?ITEMDRAW_DEFAULT:ITEMDRAW_DISABLED));
  }
  menu.AddItem("obchod", "Obchod", IsWarmUp() == true?ITEMDRAW_DISABLED:(IsPlayerAlive(client)?ITEMDRAW_DEFAULT:ITEMDRAW_DISABLED));
  menu.AddItem("aitem", "Aktivovat speciální item", IsWarmUp() == true?ITEMDRAW_DISABLED:(IsPlayerAlive(client)?ITEMDRAW_DEFAULT:ITEMDRAW_DISABLED));
  menu.AddItem("itemy", "Zakoupit speciální item");
  menu.AddItem("info", "Nápověda");
  menu.AddItem("pravidla", "Pravidla");
  menu.AddItem("nastaveni", "Nastavení");
  menu.AddItem("vip", "Aktivovat VIP/EVIP");
  menu.Pagination = 0;
  menu.ExitButton = true;
  menu.Display(client, MENU_TIME_FOREVER);
}
public void Menu_AF_Shop(int client)
{
  char buffer[64];
  char temp[32];
  int i_Money = Furien_GetClientMoney(client);

  Menu menu = CreateMenu(m_AF_Shop);
  menu.SetTitle("- Anti-Furien obchod [%i] -", i_Money);
  Format(buffer, sizeof(buffer), "Defusky [%i]", i_AF_Shop[AF_Item_Defuse]);
  menu.AddItem("defuse", buffer, (GetClientDefuse(client) != 1 && i_Money >= i_AF_Shop[AF_Item_Defuse])?ITEMDRAW_DEFAULT:ITEMDRAW_DISABLED);
  Format(buffer, sizeof(buffer), "+100 Vesty+Helma [%i]", i_AF_Shop[AF_Item_VestHelp]);
  menu.AddItem("vesthelp", buffer,(GetClientArmor(client) != 100 && i_Money >= i_AF_Shop[AF_Item_VestHelp])?ITEMDRAW_DEFAULT:ITEMDRAW_DISABLED);
  Format(buffer, sizeof(buffer), "Lékarnička [%i]", i_AF_Shop[AF_Item_Lekarnicka]);
  menu.AddItem("lekarnicka", buffer, (i_bShop[client][Shop_Lekarnicka] < 1 && i_Money >= i_AF_Shop[AF_Item_Lekarnicka])?ITEMDRAW_DEFAULT:ITEMDRAW_DISABLED);

  Format(temp, sizeof(temp), "%i",i_AF_Shop[AF_Item_OdhalovaciGranat]);
  Format(buffer, sizeof(buffer), "Odhalovací granát [%s]", IsClientVIP(client, g_AccType[ACC_EVIP])?temp:"Pouze pro EVIP");
  menu.AddItem("odhlaovaci", buffer, (IsClientVIP(client, g_AccType[ACC_EVIP]))?(i_bShop[client][Shop_OhdalovaciGranat] < 4 && i_Money >= i_AF_Shop[AF_Item_OdhalovaciGranat]?ITEMDRAW_DEFAULT:ITEMDRAW_DISABLED):ITEMDRAW_DISABLED);
  menu.ExitButton = true;
  menu.Display(client, MENU_TIME_FOREVER);
}
public void Menu_F_Shop(int client)
{
  char buffer[64];
  char temp[32];
  int i_Money = Furien_GetClientMoney(client);

  Menu menu = CreateMenu(m_F_Shop);
  menu.SetTitle("- Furien obchod [%i] -", i_Money);
  Format(buffer, sizeof(buffer), "HE granát [%i]", i_F_Shop[F_Item_HeGrenade]);
  menu.AddItem("hegrenade", buffer, (i_bShop[client][Shop_HeGrenade] < 1 && i_Money >= i_F_Shop[F_Item_HeGrenade])?ITEMDRAW_DEFAULT:ITEMDRAW_DISABLED);
  Format(buffer, sizeof(buffer), "Lékarnička  [%i]", i_F_Shop[F_Item_Lekarnicka]);
  menu.AddItem("lekarnicka", buffer, (i_bShop[client][Shop_Lekarnicka] < 1 && i_Money >= i_F_Shop[F_Item_Lekarnicka])?ITEMDRAW_DEFAULT:ITEMDRAW_DISABLED);
  Format(buffer, sizeof(buffer), "Super Nůž [%i]", i_F_Shop[F_Item_SuperKnife]);
  menu.AddItem("superknife", buffer, (i_bShop[client][Shop_SuperKnife] < 1 && i_Money >= i_F_Shop[F_Item_SuperKnife])?(IsClientVIP(client, g_AccType[ACC_EVIP])?ITEMDRAW_DEFAULT:(i_F_SuperKnifeBought < i_F_SuperKnifeAvailable?ITEMDRAW_DEFAULT:ITEMDRAW_DISABLED)):ITEMDRAW_DISABLED);
  Format(buffer, sizeof(buffer), "Electric Gun [%i]", i_F_Shop[F_Item_ElectricGun]);
  menu.AddItem("electricgun", buffer, (i_bShop[client][Shop_ElectricGun] < 1 && i_Money >= i_F_Shop[F_Item_ElectricGun])?ITEMDRAW_DEFAULT:ITEMDRAW_DISABLED);
  if(IsClientVIP(client, g_AccType[ACC_EVIP]) == false)
  {
    Format(temp, sizeof(temp), "%i",i_F_Shop[F_Item_Wallhang]);
    Format(buffer, sizeof(buffer), "WallHang [%s]", IsClientVIP(client, g_AccType[ACC_VIP])?temp:"Pouze pro VIP");
    menu.AddItem("wallhang", buffer, (IsClientVIP(client, g_AccType[ACC_VIP]))?(i_bShop[client][Shop_Wallhang] < 1 && i_Money >= i_F_Shop[F_Item_Wallhang]?ITEMDRAW_DEFAULT:ITEMDRAW_DISABLED):ITEMDRAW_DISABLED);
  }
  menu.ExitButton = true;
  menu.Display(client, MENU_TIME_FOREVER);
}
public void Menu_Settings(int client)
{
  char temp[64];
  Menu menu = CreateMenu(m_Settings);
  menu.SetTitle("- Nastavení - ");
  Format(temp, sizeof(temp), "Ukazatel poškození 'AF' [%s]",IsClientVIP(client, g_AccType[ACC_VIP])?(i_Settings[client][Settings_ShowDmg] == 1?"Vypnout":"Zapnout"):"Pouze pro VIP");
  menu.AddItem("showdmg", temp, IsClientVIP(client, g_AccType[ACC_VIP])?ITEMDRAW_DEFAULT:ITEMDRAW_DISABLED);
  Format(temp, sizeof(temp), "Pohled z třetí osoby [%s]",i_Settings[client][Settings_ThirdPerson] == 1?"Vypnout":"Zapnout");
  menu.AddItem("thirdperson", temp);
  Format(temp, sizeof(temp), "Hl. Menu na začátku kola 'F' [%s]",i_Settings[client][Settings_F_OpenMainMenu_RS] == 0?"Vypnout":"Zapnout");
  menu.AddItem("mainmenuf", temp);
  Format(temp, sizeof(temp), "Otevírat Hl. Menu pomocí F (+lookatweapon) [%s]",i_Settings[client][Settings_OpenMainMenu_onF] == 1?"Vypnout":"Zapnout");
  menu.AddItem("mainmenuonf", temp);
  menu.ExitButton = true;
  menu.Display(client, MENU_TIME_FOREVER);
}
public void Menu_SpecialItem(int client)
{
  char temp[40];
  char value[10];
  int i_Money = Furien_GetClientMoney(client);
  Menu menu = CreateMenu(m_SpecialItem);
  menu.SetTitle("- Speciální Itemy [%i] -", i_Money);
  IntToString(i_SpecialItem[SItem_Regenerace], value, sizeof(value));
  Format(temp, sizeof(temp), "Regenerace 'AF/F' [%s]", i_ClientBoughtItems[client][Item_Regenerace] == 1?"Zakoupeno":value);
  menu.AddItem("regenerace", temp, i_ClientBoughtItems[client][Item_Regenerace] == 1?ITEMDRAW_DISABLED:(i_Money >= i_SpecialItem[SItem_Regenerace]?ITEMDRAW_DEFAULT:ITEMDRAW_DISABLED));

  IntToString(i_SpecialItem[SItem_Mrstnost], value, sizeof(value));
  Format(temp, sizeof(temp), "Mrštnost 'F' [%s]", i_ClientBoughtItems[client][Item_Mrstnost] == 1?"Zakoupeno":value);
  menu.AddItem("mrstnost", temp, i_ClientBoughtItems[client][Item_Mrstnost] == 1?ITEMDRAW_DISABLED:(i_Money >= i_SpecialItem[SItem_Mrstnost]?ITEMDRAW_DEFAULT:ITEMDRAW_DISABLED));

  IntToString(i_SpecialItem[SItem_Zmateni], value, sizeof(value));
  Format(temp, sizeof(temp), "Zmatení 'F' [%s]", IsClientVIP(client, g_AccType[ACC_VIP])?(i_ClientBoughtItems[client][Item_Zmateni] == 1?"Zakoupeno":value):"Pouze pro VIP");
  menu.AddItem("zmateni", temp, IsClientVIP(client, g_AccType[ACC_VIP])?(i_ClientBoughtItems[client][Item_Zmateni] == 1?ITEMDRAW_DISABLED:(i_Money >= i_SpecialItem[SItem_Zmateni]?ITEMDRAW_DEFAULT:ITEMDRAW_DISABLED)):ITEMDRAW_DISABLED);

  IntToString(i_SpecialItem[SItem_ZaseknutiZbrane], value, sizeof(value));
  Format(temp, sizeof(temp), "Zaseknutí zbraně 'F' [%s]", IsClientVIP(client, g_AccType[ACC_EVIP])?(i_ClientBoughtItems[client][Item_ZaseknutiZbrane] == 1?"Zakoupeno":value):"Pouze pro EVIP");
  menu.AddItem("zaseknutizbrane", temp, IsClientVIP(client, g_AccType[ACC_EVIP])?(i_ClientBoughtItems[client][Item_ZaseknutiZbrane] == 1?ITEMDRAW_DISABLED:(i_Money >= i_SpecialItem[SItem_ZaseknutiZbrane]?ITEMDRAW_DEFAULT:ITEMDRAW_DISABLED)):ITEMDRAW_DISABLED);

  IntToString(i_SpecialItem[SItem_MultiJump], value, sizeof(value));
  Format(temp, sizeof(temp), "Multi-Jump 'AF/F' [%s]", IsClientVIP(client, g_AccType[ACC_EVIP])?(i_ClientBoughtItems[client][Item_MultiJump] == 1?"Zakoupeno":value):"Pouze pro EVIP");
  menu.AddItem("multijump", temp, IsClientVIP(client, g_AccType[ACC_EVIP])?(i_ClientBoughtItems[client][Item_MultiJump] == 1?ITEMDRAW_DISABLED:(i_Money >= i_SpecialItem[SItem_MultiJump]?ITEMDRAW_DEFAULT:ITEMDRAW_DISABLED)):ITEMDRAW_DISABLED);

  IntToString(i_SpecialItem[SItem_DrtiveStrely], value, sizeof(value));
  Format(temp, sizeof(temp), "Drtivé střely 'AF' [%s]", i_ClientBoughtItems[client][Item_DrtiveStrely] == 1?"Zakoupeno":value);
  menu.AddItem("drtivestrely", temp, i_ClientBoughtItems[client][Item_DrtiveStrely] == 1?ITEMDRAW_DISABLED:(i_Money >= i_SpecialItem[SItem_DrtiveStrely]?ITEMDRAW_DEFAULT:ITEMDRAW_DISABLED));

  IntToString(i_SpecialItem[SItem_ChytreOko], value, sizeof(value));
  Format(temp, sizeof(temp), "Chytré oko 'AF' [%s]", IsClientVIP(client, g_AccType[ACC_VIP])?(i_ClientBoughtItems[client][Item_ChytreOko] == 1?"Zakoupeno":value):"Pouze pro EVIP");
  menu.AddItem("chytreoko", temp, IsClientVIP(client, g_AccType[ACC_VIP])?(i_ClientBoughtItems[client][Item_ChytreOko] == 1?ITEMDRAW_DISABLED:(i_Money >= i_SpecialItem[SItem_ChytreOko]?ITEMDRAW_DEFAULT:ITEMDRAW_DISABLED)):ITEMDRAW_DISABLED);

  IntToString(i_SpecialItem[SItem_DoplnovaniNaboju], value, sizeof(value));
  Format(temp, sizeof(temp), "Doplňování nábojů 'AF' [%s]", IsClientVIP(client, g_AccType[ACC_EVIP])?(i_ClientBoughtItems[client][Item_DoplnovaniNaboju] == 1?"Zakoupeno":value):"Pouze pro EVIP");
  menu.AddItem("ammorefill", temp, IsClientVIP(client, g_AccType[ACC_EVIP])?(i_ClientBoughtItems[client][Item_DoplnovaniNaboju] == 1?ITEMDRAW_DISABLED:(i_Money >= i_SpecialItem[SItem_DoplnovaniNaboju]?ITEMDRAW_DEFAULT:ITEMDRAW_DISABLED)):ITEMDRAW_DISABLED);
  menu.Pagination = MENU_NO_PAGINATION;
  menu.ExitButton = true;
  menu.Display(client, MENU_TIME_FOREVER);
}
public void Menu_ChooseItem(int client)
{
  int ItemCount = 0;
  Menu menu = CreateMenu(m_ChooseItem);
  menu.SetTitle("- Aktivovat Item -");
  menu.AddItem("none", "Žádný item",i_ClientActiveItem[client] == Item_None?ITEMDRAW_DISABLED:ITEMDRAW_DEFAULT);
  if(i_ClientBoughtItems[client][Item_Regenerace] == 1)
  {
    ItemCount++;
    menu.AddItem("regenerace", i_ClientActiveItem[client] == Item_Regenerace?"Regenerace [Aktivní]":"Regenerace",i_ClientActiveItem[client] == Item_Regenerace?ITEMDRAW_DISABLED:ITEMDRAW_DEFAULT);
  }
  if(i_ClientBoughtItems[client][Item_MultiJump] == 1)
  {
    ItemCount++;
    menu.AddItem("multijump", i_ClientActiveItem[client] == Item_MultiJump?"Multi-Jump [Aktivní]":"Multi-Jump",i_ClientActiveItem[client] == Item_MultiJump?ITEMDRAW_DISABLED:ITEMDRAW_DEFAULT);
  }

  if(GetClientTeam(client) == CS_TEAM_CT)
  {
    if(i_ClientBoughtItems[client][Item_DrtiveStrely] == 1)
    {
      ItemCount++;
      menu.AddItem("drtivestrely", i_ClientActiveItem[client] == Item_DrtiveStrely?"Drtivé střely [Aktivní]":"Drtivé střely",i_ClientActiveItem[client] == Item_DrtiveStrely?ITEMDRAW_DISABLED:ITEMDRAW_DEFAULT);
    }
    if(i_ClientBoughtItems[client][Item_ChytreOko] == 1)
    {
      ItemCount++;
      menu.AddItem("chytreoko", i_ClientActiveItem[client] == Item_ChytreOko?"Chytré oko [Aktivní]":"Chytré oko",i_ClientActiveItem[client] == Item_ChytreOko?ITEMDRAW_DISABLED:ITEMDRAW_DEFAULT);
    }
    if(i_ClientBoughtItems[client][Item_DoplnovaniNaboju] == 1)
    {
      ItemCount++;
      menu.AddItem("ammorefill", i_ClientActiveItem[client] == Item_DoplnovaniNaboju?"Doplňování nábojů [Aktivní]":"Doplňování nábojů",i_ClientActiveItem[client] == Item_DoplnovaniNaboju?ITEMDRAW_DISABLED:ITEMDRAW_DEFAULT);
    }
  }
  else if(GetClientTeam(client) == CS_TEAM_T)
  {

    if(i_ClientBoughtItems[client][Item_Mrstnost] == 1)
    {
      ItemCount++;
      menu.AddItem("mrstnost", i_ClientActiveItem[client] == Item_Mrstnost?"Mrštnost [Aktivní]":"Mrštnost",i_ClientActiveItem[client] == Item_Mrstnost?ITEMDRAW_DISABLED:ITEMDRAW_DEFAULT);
    }
    if(i_ClientBoughtItems[client][Item_Zmateni] == 1)
    {
      ItemCount++;
      menu.AddItem("zmateni", i_ClientActiveItem[client] == Item_Zmateni?"Zmatení [Aktivní]":"Zmatení",i_ClientActiveItem[client] == Item_Zmateni?ITEMDRAW_DISABLED:ITEMDRAW_DEFAULT);
    }
    if(i_ClientBoughtItems[client][Item_ZaseknutiZbrane] == 1)
    {
      ItemCount++;
      menu.AddItem("zaseknutizbrane", i_ClientActiveItem[client] == Item_ZaseknutiZbrane?"Zaseknutí zbraně [Aktivní]":"Zaseknutí zbraně",i_ClientActiveItem[client] == Item_ZaseknutiZbrane?ITEMDRAW_DISABLED:ITEMDRAW_DEFAULT);
    }
  }
  if(ItemCount == 0)
  {
    menu.AddItem("buysome", "Zakoupit Speciální item");
  }
  menu.Pagination = MENU_NO_PAGINATION;
  menu.ExitButton = true;
  menu.Display(client, MENU_TIME_FOREVER);
}
