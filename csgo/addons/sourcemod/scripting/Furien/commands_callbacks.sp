public Action Command_BlockRadio(int client, const char[] command,int  args)
{
	return Plugin_Handled;
}
public Action Command_Kill(int client, const char[] command,int  args)
{
	return Plugin_Handled;
}
public Action Command_Add(int client, int args)
{
	char arg[10];
	GetCmdArg(1, arg, sizeof(arg));
	int value = StringToInt(arg);
	Furien_AddClientMoney(client, value);
	return Plugin_Handled;

}
public Action Command_Get(int client, int args)
{
	PrintToChat(client, "%i", Furien_GetClientMoney(client));
	return Plugin_Handled;

}
public Action Command_Rem(int client, int args)
{
	char arg[10];
	GetCmdArg(1, arg, sizeof(arg));
	int value = StringToInt(arg);
	Furien_TakeClientMoney(client, value);
	return Plugin_Handled;
}
public Action Command_Furien(int client, int args)
{
	if(IsValidClient(client))
	{
		if(GetClientTeam(client) != CS_TEAM_SPECTATOR)
		{
			Menu_FurienMain(client);
		}
	}
}
public Action Command_LookAtWeapon(int client, const char[] command, int argc)
{
  if(IsValidClient(client))
  {
		if(i_Settings[client][Settings_OpenMainMenu_onF] == 1)
		{
			Menu_FurienMain(client);
			return Plugin_Handled;
		}
  }
  return Plugin_Continue;
}
public Action Command_ThirdPerson(int client,  int args)
{
	PrintToChatAll("%N", client);
	if(IsValidClient(client))
	{
		i_Settings[client][Settings_ThirdPerson] = 1;
	}
	return Plugin_Handled;
}
public Action Command_FirstPerson(int client, int args)
{
	PrintToChatAll("%N", client);
	if(IsValidClient(client))
	{
		i_Settings[client][Settings_ThirdPerson] = 0;
	}
	return Plugin_Handled;
}
