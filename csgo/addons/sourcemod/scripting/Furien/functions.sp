stock void Furien_TakeClientMoney(int client, int amount)
{
    if(amount > 0)
    {
      i_cMoney[client] -= amount;
    }
}
stock int Furien_GetClientMoney(int client)
{
  return i_cMoney[client];
}
stock void Furien_AddClientMoney(int client, int amount)
{
  i_cMoney[client] += amount;
}
