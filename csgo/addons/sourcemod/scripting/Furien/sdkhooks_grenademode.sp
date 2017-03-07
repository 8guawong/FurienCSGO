public void SDKHook_Spawn_Main(int entity)
{
  SDKUnhook(entity, SDKHook_Spawn, SDKHook_Spawn_Main);
  int ent = EntIndexToEntRef(entity);
  CreateTimer(0.0, Timer_OnGrenadeCreated, ent);
}
public Action Timer_OnGrenadeCreated(Handle timer, any ent)
{
  int entity = EntRefToEntIndex(ent);
  if (entity != INVALID_ENT_REFERENCE)
  {
    int client = GetEntPropEnt(entity, Prop_Send, "m_hOwnerEntity");
    if(IsValidClient(client, true))
    {
      if(GetClientTeam(client) == CS_TEAM_T)
      {
        if(i_gClientGrenadeMode[client] == Grenade_Impact)
        {
          i_gClientGrenadeRef[client][Grenade_Impact] = EntIndexToEntRef(entity);
          SetEntProp(entity, Prop_Data, "m_nNextThinkTick", -1);
          SDKHook(entity, SDKHook_StartTouch, SDKHook_StartTouch_Impact);
        }
        else if(i_gClientGrenadeMode[client] == Grenade_Detonate)
        {
          int iOldDetonate = EntRefToEntIndex(i_gClientGrenadeRef[client][Grenade_Detonate]);
          if(IsValidEntity(iOldDetonate))
          {
            SetEntProp(iOldDetonate, Prop_Data, "m_nNextThinkTick", 1);
            SDKHooks_TakeDamage(iOldDetonate, 0, 0, 1.0);
          }
          i_gClientGrenadeRef[client][Grenade_Detonate] = EntIndexToEntRef(entity);
          SetEntProp(entity, Prop_Data, "m_nNextThinkTick", -1);
          SDKHook(entity, SDKHook_StartTouch, SDKHook_StartTouch_Detonate);
        }
      }
    }
  }
}
public void SDKHook_StartTouch_Detonate(int entity, int client)
{
  if(IsValidEntity(entity))
  {
    int owner = GetEntPropEnt(entity, Prop_Send, "m_hOwnerEntity");
    int ent = EntRefToEntIndex(i_gClientGrenadeRef[owner][Grenade_Detonate]);
    if(IsValidEntity(ent))
    {
      if(ent == entity)
      {
        if(IsValidClient(owner))
        {
          if(GetClientTeam(owner) == CS_TEAM_T)
          {
            if(IsValidClient(client) == false)
            {
              SetEntityMoveType(entity, MOVETYPE_NONE);
              b_g_ClientGrenadeDetonateRdy[owner] = true;
            }
          }
        }
      }
    }
  }
}
public void SDKHook_StartTouch_Impact(int entity, int client)
{
  if(IsValidEntity(entity))
  {
    int owner = GetEntPropEnt(entity, Prop_Send, "m_hOwnerEntity");
    int ent = EntRefToEntIndex(i_gClientGrenadeRef[owner][Grenade_Impact]);
    if(IsValidEntity(ent))
    {
      if(ent == entity)
      {
        if(IsValidClient(owner))
        {
          if(GetClientTeam(owner) == CS_TEAM_T)
          {
            SetEntProp(entity, Prop_Data, "m_nNextThinkTick", 1);
            SetEntProp(entity, Prop_Data, "m_takedamage", 2);
            SetEntProp(entity, Prop_Data, "m_iHealth", 1);
            SDKHooks_TakeDamage(entity, 0, 0, 1.0);
          }
        }
      }
    }
  }
}
