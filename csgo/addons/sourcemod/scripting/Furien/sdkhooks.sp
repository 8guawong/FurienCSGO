public void EventSDK_OnClientThink(int client)
{
	if(IsValidClient(client))
	{
		if(IsPlayerAlive(client))
		{
			if(GetClientTeam(client) == CS_TEAM_T)
			{
				SetEntityGravity(client, cVf_Gravity);
				SetEntPropFloat(client, Prop_Data, "m_flLaggedMovementValue", cVf_Speed);
			}
		}
	}
}
public void EventSDK_OnPostThinkPost(int client)
{
	if(IsValidClient(client, true))
	{
		SetEntProp(client, Prop_Send, "m_bInBuyZone", 0);
		SetEntProp(client, Prop_Send, "m_iAccount", Furien_GetClientMoney(client));
		if(GetClientTeam(client) == CS_TEAM_T)
		{
			SetEntProp(client, Prop_Send, "m_iAddonBits", 0);
		}
		else if(GetClientTeam(client) == CS_TEAM_CT)
		{
			SetEntProp(client, Prop_Send, "m_iAddonBits", 1);
		}
	}
}
public Action EventSDK_OnWeaponCanUse(int client, int weapon)
{
	if(IsValidClient(client, true))
	{
		if(GetClientTeam(client) == CS_TEAM_T)
		{
			if(IsValidEntity(weapon))
			{
				char s_weapon[128];
				GetEntityClassname(weapon, s_weapon, sizeof(s_weapon));
				if(StrEqual(s_weapon, "weapon_knife"))
				{
					return Plugin_Continue;
				}
				else if(StrEqual(s_weapon, "weapon_hegrenade"))
				{
					return Plugin_Continue;
				}
				else if(StrEqual(s_weapon, "weapon_c4"))
				{
					return Plugin_Continue;
				}
				else if(StrEqual(s_weapon, "weapon_taser"))
				{
					return Plugin_Continue;
				}
				else if(StrEqual(s_weapon, "weapon_healthshot"))
				{
					return Plugin_Continue;
				}
				else return Plugin_Handled;
			}
		}
		else if(GetClientTeam(client) == CS_TEAM_CT)
		{
			if(IsValidEntity(weapon))
			{
				char s_weapon[128];
				GetEntityClassname(weapon, s_weapon, sizeof(s_weapon));
				if(StrEqual(s_weapon, "weapon_hegrenade"))
				{
					return Plugin_Handled;
				}
				else return Plugin_Continue;
			}
		}
	}
	return Plugin_Continue;
}
public Action EventSDK_SetTransmit(int entity, int client)
{
	if(IsValidClient(entity, true))
	{
		if (client != entity && b_IsClientInvisible[entity])
		{
			return Plugin_Handled;
		}
	}
	return Plugin_Continue;
}
public Action EventSDK_OnTraceAttack(int victim, int &attacker, int &inflictor, float &damage, int &damagetype, int &ammotype, int hitbox, int hitgroup)
{
	if(IsValidClient(victim) && IsValidClient(attacker))
	{
		if(GetClientTeam(attacker) == CS_TEAM_CT && GetClientTeam(victim) == CS_TEAM_T)
		{
			int i_Weapon = GetEntPropEnt(attacker, Prop_Send, "m_hActiveWeapon");
			char wepname[128];
			if(IsValidEntity(i_Weapon))
			{
				GetEntityClassname(i_Weapon, wepname, sizeof(wepname));
			}
			if(StrEqual(wepname, "weapon_mag7"))
			{
				//PrintToChatAll("Modify: %0.2f | %0.2f",damage ,damage*0.4);
				damage *= 0.4;
				return Plugin_Changed;
			}
			else if(StrEqual(wepname, "weapon_ump45"))
			{
				//PrintToChatAll("Modify: %0.2f | %0.2f",damage ,damage*0.6);
				damage *= 0.6;
				return Plugin_Changed;
			}
			else if(StrEqual(wepname, "weapon_famas"))
			{
				//PrintToChatAll("Modify: %0.2f | %0.2f",damage ,damage*0.6);
				damage *= 0.65;
				return Plugin_Changed;
			}
			else if(StrEqual(wepname, "weapon_mp9"))
			{
				//PrintToChatAll("Modify: %0.2f | %0.2f",damage ,damage*0.6);
				damage *= 0.75;
				return Plugin_Changed;
			}
			else if(StrEqual(wepname, "weapon_awp"))
			{
				//PrintToChatAll("Modify: %0.2f | %0.2f",damage ,damage*0.9);
				damage *= 0.9;
				return Plugin_Changed;
			}
			else if(StrEqual(wepname, "weapon_mp7"))
			{
				//PrintToChatAll("Modify: %0.2f | %0.2f",damage ,damage*1.2);
				damage *= 1.2;
				return Plugin_Changed;
			}
			else if(StrEqual(wepname, "weapon_m4a1"))
			{
				//PrintToChatAll("Modify: %0.2f | %0.2f",damage ,damage*0.9);
				damage *= 0.9;
				return Plugin_Changed;
			}
			else if(StrEqual(wepname, "weapon_ak47"))
			{
				//PrintToChatAll("Modify: %0.2f | %0.2f",damage ,damage*0.9);
				damage *= 0.9;
				return Plugin_Changed;
			}
			else if(StrEqual(wepname, "weapon_glock"))
			{
				//PrintToChatAll("Modify: %0.2f | %0.2f",damage ,damage*0.9);
				damage *= 0.9;
				return Plugin_Changed;
			}
			else if(StrEqual(wepname, "weapon_hkp2000"))
			{
				//PrintToChatAll("Modify: %0.2f | %0.2f",damage ,damage*0.8);
				damage *= 0.8;
				return Plugin_Changed;
			}
			else if(StrEqual(wepname, "weapon_usp"))
			{
				//PrintToChatAll("Modify: %0.2f | %0.2f",damage ,damage*0.7);
				damage *= 0.7;
				return Plugin_Changed;
			}
			else if(StrEqual(wepname, "weapon_p250"))
			{
				//PrintToChatAll("Modify: %0.2f | %0.2f",damage ,damage*0.7);
				damage *= 0.7;
				return Plugin_Changed;
			}
			else if(StrEqual(wepname, "weapon_fiveseven"))
			{
				//PrintToChatAll("Modify: %0.2f | %0.2f",damage ,damage*0.6);
				damage *= 0.6;
				return Plugin_Changed;
			}
		}
	}
	return Plugin_Continue;
}
public Action EventSDK_OnTakeDamage(int victim,int &attacker,int &inflictor, float &damage,int &damagetype,int &weapon, float damageForce[3], float damagePosition[3])
{
	if(IsValidClient(victim))
	{
		if(i_ClientActiveItem[victim] == Item_Regenerace)
		{
			if(t_SpecialItem_Regenerace[victim] == null)
			{
				t_SpecialItem_Regenerace[victim] = CreateTimer(1.0, Timer_SpecialItem_Regenerace, GetClientUserId(victim), TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
			}
		}
		char wepname[128];
		if(IsValidEntity(weapon))
		{
			GetEntityClassname(weapon, wepname, sizeof(wepname));
		}
		if(IsValidClient(attacker))
		{
			if(GetClientTeam(victim) == CS_TEAM_T && GetClientTeam(attacker) == CS_TEAM_CT)
			{
				// Drtivé střely
				if(i_ClientActiveItem[attacker] == Item_DrtiveStrely)
				{
					float fChance = GetRandomFloat(0.0, 100.0);
					if(fChance <= 10.0)
					{
						if(t_SpecialItem_DrtiveStrely[victim] == null)
						{
							SetEntityMoveType(victim, MOVETYPE_NONE);
							t_SpecialItem_DrtiveStrely[victim] = CreateTimer(0.5, Timer_SpecialItem_DrtiveStrely, GetClientUserId(victim), TIMER_FLAG_NO_MAPCHANGE);
						}
					}
				}
				// Chytré oko
				if(i_ClientActiveItem[attacker] == Item_ChytreOko)
				{
					if(b_IsClientInvisible[victim] == true)
					{
						b_IsClientInvisible[victim] = false;
						b_IsClientInvisiblePre[victim] = false;
						SetEntityRenderColor(victim);
					}
				}
				// Zmateni
				if(t_SpecialItem_Zmateni[attacker] != null)
				{
					damage *= 0.8;
					return Plugin_Changed;
				}
				// Mrstnost
				if(i_ClientActiveItem[victim] == Item_Mrstnost)
				{
					float fChance = GetRandomFloat(0.0, 100.0);
					if(fChance <= 20.0)
					{
						return Plugin_Handled;
					}
				}
			}
			else if(GetClientTeam(attacker) == CS_TEAM_T && GetClientTeam(victim) == CS_TEAM_CT)
			{
				// Otočíš se je to v piči
				if(i_ClientActiveItem[attacker] == Item_ZaseknutiZbrane)
				{
					float fChance = GetRandomFloat(0.0, 100.0);
					if(fChance <= 12.0)
					{
						int i_Weapon = GetEntPropEnt(victim, Prop_Send, "m_hActiveWeapon");
						int iCurrentMainAmmo = GetEntData(i_Weapon, g_MainClipOffset);
						if(iCurrentMainAmmo > 0)
						{
							int iCurrentSecAmmo =  GetEntProp(i_Weapon, Prop_Send, "m_iPrimaryReserveAmmoCount");
							SetEntProp(i_Weapon, Prop_Send, "m_iPrimaryReserveAmmoCount", iCurrentSecAmmo+(iCurrentMainAmmo-1));
							SetEntData(i_Weapon, g_MainClipOffset, iCurrentMainAmmo-(iCurrentMainAmmo-1));
							PrintToChat(victim, "%s %N tě zasáhnul a zaseknul ti zbraň. Přebij si!", CHAT_TAG, attacker);
						}
					}
				}
				// Zmateni
				if(i_ClientActiveItem[attacker] == Item_Zmateni)
				{
					if(t_SpecialItem_Zmateni[victim] != null)
					{
						WipeHandle(t_SpecialItem_Zmateni[victim]);
					}
					t_SpecialItem_Zmateni[victim] = CreateTimer(3.0, Timer_SpecialItem_Zmateni, GetClientUserId(victim), TIMER_FLAG_NO_MAPCHANGE);
				}
				//superknife
				if(i_bShop[attacker][Shop_SuperKnife] == 1)
				{
					if(StrEqual(wepname, "weapon_knife") && GetClientButtons(attacker) & IN_ATTACK2)
					{
						damage = 400.0;
						return Plugin_Changed;
					}
				}
			}
		}
	}
	return Plugin_Continue;
}
