public void MySql_Connect()
{
  db = SQL_Connect("furiengo",true, db_error, sizeof(db_error));
  if(db == null)
  {
    SQL_GetError(db, db_error, sizeof(db_error));
    SetFailState("\n\n\n[FurienGO] Cannot connect to the DB: %s\n\n\n", db_error);
  }
  /* CREATE TABLE IF NOT EXISTS furien_users (id INT(32) NOT NULL DEFAULT NULL AUTO_INCREMENT, steamid VARCHAR(128) NOT NULL, money INT(32) DEFAULT 0 ,Item_Regenerace INT(2) DEFAULT 0, Item_Mrstnost INT(2) DEFAULT 0,
   Item_Zmateni INT(2) DEFAULT 0, Item_Zaseknutizbrane INT(2) DEFAULT 0, Item_Multijump INT(2) DEFAULT 0, Item_Drtivestrely INT(2) DEFAULT 0, Item_Chytreoko INT(2) DEFAULT 0,Item_Doplnovaninaboju INT(2) DEFAULT 0 PRIMARY KEY(id))*/
  SQL_Query(db, "SET CHARACTER SET utf8");
  PrintToServer("[FurienGO] Connected to MySQL successfuly!");
}
public void MySql_LoadClient(int client)
{
  i_cMoney[client] = 0;
  for(int i; i < Item_Count; i++)
  {
    i_ClientBoughtItems[client][i] = 0;
  }
  char steamid[32];
  char e_steamid[32];
  GetClientAuthId(client, AuthId_Engine, steamid, sizeof(steamid));
  ExplodeSteamId(steamid,e_steamid,sizeof(e_steamid));
  Format (db_query, sizeof(db_query), "SELECT * FROM furien_users WHERE steamid='%s'", e_steamid);
  SQL_TQuery(db, MySql_OnLoadPlayer, db_query, client);
}
public void MySql_OnLoadPlayer(Handle owner, Handle query, const char[] error, any client)
{
  if(query == INVALID_HANDLE)
  {
    LogError("[FurienGO] MySql-Query failed! Error: %s\n\n\n", error);
  }
  else
  {
    b_ClientVerified[client] = false;
    char steamid[32];
    char e_steamid[32];
    GetClientAuthId(client, AuthId_Engine, steamid, sizeof(steamid));
    ExplodeSteamId(steamid,e_steamid,sizeof(e_steamid));
    if(!SQL_FetchRow(query))
    {
      Format(db_query, sizeof(db_query), "INSERT INTO furien_users (steamid,money) VALUES ('%s','0')",e_steamid);
      SQL_TQuery(db, MySql_OnInsertPlayerToDB, db_query, client);
    }
    else
    {
      Format (db_query, sizeof(db_query), "SELECT * FROM furien_users WHERE steamid='%s'", e_steamid);
      SQL_TQuery(db, MySql_OnLoadPlayerPost, db_query, client);
    }
  }
  CloseHandle(query);
}

public void MySql_OnInsertPlayerToDB(Handle owner, Handle query, const char[] error, any client)
{
  if(query == INVALID_HANDLE)
  {
    LogError("[FurienGO] MySql-Query failed! Error: %s\n\n\n", error);
  }
  b_ClientVerified[client] = true;
  CloseHandle(query);
}
public void MySql_OnLoadPlayerPost(Handle owner, Handle query, const char[] error, any client)
{
  if(query == INVALID_HANDLE)
  {
    LogError("[FurienGO] MySql-Query failed! Error: %s\n\n\n", error);
  }
  else
  {
    if(SQL_FetchRow(query))
    {
      i_cMoney[client] = SQL_FetchInt(query, 2);
      i_ClientBoughtItems[client][Item_Regenerace] = SQL_FetchInt(query, 3);
      i_ClientBoughtItems[client][Item_Mrstnost] = SQL_FetchInt(query, 4);
      i_ClientBoughtItems[client][Item_Zmateni] = SQL_FetchInt(query, 5);
      i_ClientBoughtItems[client][Item_ZaseknutiZbrane] = SQL_FetchInt(query, 6);
      i_ClientBoughtItems[client][Item_MultiJump] = SQL_FetchInt(query, 7);
      i_ClientBoughtItems[client][Item_DrtiveStrely] = SQL_FetchInt(query, 8);
      i_ClientBoughtItems[client][Item_ChytreOko] = SQL_FetchInt(query, 9);
      i_ClientBoughtItems[client][Item_DoplnovaniNaboju] = SQL_FetchInt(query, 10);
      b_ClientVerified[client] = true;
    }
  }
  CloseHandle(query);
}
stock void MySql_SaveClient(int client)
{
  if(b_ClientVerified[client] == true)
  {
    char steamid[32];
    char e_steamid[32];
    GetClientAuthId(client, AuthId_Engine, steamid, sizeof(steamid));
    ExplodeSteamId(steamid,e_steamid,sizeof(e_steamid));
    Handle datapack = CreateDataPack();
    WritePackString(datapack, e_steamid);
    WritePackCell(datapack, Furien_GetClientMoney(client));
    WritePackCell(datapack, i_ClientBoughtItems[client][Item_Regenerace]);
    WritePackCell(datapack, i_ClientBoughtItems[client][Item_Mrstnost]);
    WritePackCell(datapack, i_ClientBoughtItems[client][Item_Zmateni]);
    WritePackCell(datapack, i_ClientBoughtItems[client][Item_ZaseknutiZbrane]);
    WritePackCell(datapack, i_ClientBoughtItems[client][Item_MultiJump]);
    WritePackCell(datapack, i_ClientBoughtItems[client][Item_DrtiveStrely]);
    WritePackCell(datapack, i_ClientBoughtItems[client][Item_ChytreOko]);
    WritePackCell(datapack, i_ClientBoughtItems[client][Item_DoplnovaniNaboju]);
    Format (db_query, sizeof(db_query), "SELECT * FROM furien_users WHERE steamid='%s'", e_steamid);
    if(db != null)
    {
      SQL_TQuery(db, MySql_OnSaveClientPre, db_query, datapack);
    }
  }
}

public void MySql_OnSaveClientPre(Handle owner, Handle query, const char[] error, any datapack)
{
  if(query == INVALID_HANDLE)
  {
    LogError("[FurienGO] MySql-Query failed! Error: %s\n\n\n", error);
  }
  else
  {
    char e_steamid[32];
    ResetPack(datapack);
    ReadPackString(datapack, e_steamid, sizeof(e_steamid));
    int temp_money = ReadPackCell(datapack);
    int temp_regenerace = ReadPackCell(datapack);
    int temp_mrstnost = ReadPackCell(datapack);
    int temp_zmateni = ReadPackCell(datapack);
    int temp_zaseknutizbrane = ReadPackCell(datapack);
    int temp_multijump = ReadPackCell(datapack);
    int temp_drtivestrely = ReadPackCell(datapack);
    int temp_chytreoko = ReadPackCell(datapack);
    int temp_doplnovaninaboju = ReadPackCell(datapack);
    if(SQL_FetchRow(query))
    {
      Format(db_query, sizeof(db_query), "UPDATE furien_users SET money='%i', Item_Regenerace='%i', Item_Mrstnost='%i', Item_Zmateni='%i', Item_Zaseknutizbrane='%i', Item_Multijump='%i', Item_Drtivestrely='%i', Item_Chytreoko='%i', Item_Doplnovaninaboju='%i' WHERE steamid='%s'",temp_money, temp_regenerace, temp_mrstnost, temp_zmateni, temp_zaseknutizbrane, temp_multijump, temp_drtivestrely, temp_chytreoko, temp_doplnovaninaboju, e_steamid);
      SQL_TQuery(db, MySql_OnSaveClient, db_query, temp_money);
    }
  }
  CloseHandle(query);
}
public void MySql_OnSaveClient(Handle owner, Handle query, const char[] error, any money)
{
  if(query == INVALID_HANDLE)
  {
    LogError("[FurienGO] MySql-Query failed! Error: %s\n\n\n", error);
  }
  CloseHandle(query);
}
