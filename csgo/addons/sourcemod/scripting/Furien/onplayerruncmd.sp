public Action OnPlayerRunCmd(int client, int &buttons, int &impulse, float vel[3], float angles[3], int &weapon, int &subtype, int &cmdnum, int &tickcount, int &seed, int mouse[2])
{
  if(IsValidClient(client))
  {
    if(IsPlayerAlive(client))
    {
      char weapon_name[32];
      int cFlags = GetEntityFlags(client);
      int cButtons = GetClientButtons(client);
      GetClientWeapon(client, weapon_name, sizeof(weapon_name));
      //int cWeapon = GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon");
      if(GetClientTeam(client) == CS_TEAM_CT)
      {

      }
      else if(GetClientTeam(client) == CS_TEAM_T)
      {
        if(b_ClientMovedAfterSpawn[client] == false)
        {
          if(buttons & IN_FORWARD	|| buttons & IN_BACK || buttons & IN_LEFT || buttons & IN_RIGHT)
          {
            b_ClientMovedAfterSpawn[client] = true;
          }
        }
        if(buttons & IN_RELOAD)
        {
          if(b_g_ClientGrenadeDetonateRdy[client] == true)
          {
            int ent = EntRefToEntIndex(i_gClientGrenadeRef[client][Grenade_Detonate]);
            if(IsValidEntity(ent))
            {
              float f_VecOrg[3];
              GetEntPropVector(ent, Prop_Send, "m_vecOrigin", f_VecOrg);
              SetEntityMoveType(ent, MOVETYPE_FLYGRAVITY);
              SetEntProp(ent, Prop_Data, "m_nNextThinkTick", 1);
              SetEntProp(ent, Prop_Data, "m_takedamage", 2);
              SetEntProp(ent, Prop_Data, "m_iHealth", 1);
              SDKHooks_TakeDamage(ent, 0, 0, 1.0);

              TE_SetupExplosion(f_VecOrg, i_ExplosionIndex, 5.0, 1, 0, 50, 40, view_as<float>({0.0, 0.0, 1.0}));
              TE_SendToAll();
              TE_SetupSmoke(f_VecOrg, i_SmokeIndex, 10.0, 3);
              TE_SendToAll();
              b_g_ClientGrenadeDetonateRdy[client] = false;
            }
          }
        }
        //FallDown speed
        if(cVb_FallDownSpeed == true)
        {
          if(IsClientInAir(client, cFlags))
          {
            float vVel[3];
            GetEntPropVector(client, Prop_Data, "m_vecVelocity", vVel);
            //PrintToChat(client,"%0.3f", vVel[2]);
            if(vVel[2] < -1.0)
            {
              vVel[2] += cVf_FallDown;
              SetEntPropVector(client, Prop_Data, "m_vecVelocity", vVel);
              TeleportEntity(client, NULL_VECTOR,NULL_VECTOR,vVel);
            }
            else if(vVel[2] > 200.0)
            {
              vVel[2] -= 20.0;
              SetEntPropVector(client, Prop_Data, "m_vecVelocity", vVel);
              TeleportEntity(client, NULL_VECTOR,NULL_VECTOR,vVel);
            }
          }
        }
        // Invisible
        if(cVb_Invisible == true)
        {
          char wepname[32];
          GetClientWeapon(client, wepname, sizeof(wepname));
          bool b_CanBeInvisible = IsClientNotMoving(buttons) && !IsClientInAir(client, cFlags) && StrEqual(wepname, "weapon_knife") && b_ClientMovedAfterSpawn[client] == true;
          if(b_CanBeInvisible == true)
          {
            if(b_IsClientInvisible[client] == false)
            {
              if(b_IsClientInvisiblePre[client] == false)
              {
                f_ClientInvisible[client] = GetGameTime();
                b_IsClientInvisiblePre[client] = true;
              }
              else if(b_IsClientInvisiblePre[client] && b_IsClientInvisible[client] == false)
              {
                int i_ClientRenderColor[MAXPLAYERS+1][4];

                GetEntityRenderColor(client, i_ClientRenderColor[client]);
                float f_InvisTimeLeft[MAXPLAYERS+1];
                f_InvisTimeLeft[client] = f_ClientInvisible[client] - GetGameTime() + f_gInvisibleDelay[client];
                if(f_InvisTimeLeft[client] < 0.01 && (i_ClientRenderColor[client][3]-cVi_Invisible_Alpha_Reduce) <= 0)
                {
                  SetEntityRenderColor(client,255,255,255,0);
                  FadeClient(client, 35,0,130,30);
                  b_IsClientInvisible[client] = true;

                }
                else if(f_InvisTimeLeft[client] < 0.01 && i_ClientRenderColor[client][3] > 1)
                {
                  SetEntityRenderColor(client,255,255,255,i_ClientRenderColor[client][3]-cVi_Invisible_Alpha_Reduce);
                  f_ClientInvisible[client] = GetGameTime();
                }
              }
            }
          }
          else
          {
            SetEntityRenderColor(client);
            b_IsClientInvisiblePre[client] = false;
            b_IsClientInvisible[client] = false;
            FadeClient(client);
          }
        }
        //Wallhang
        if(cVb_WallHang == true)
        {
          if(IsClientVIP(client, g_AccType[ACC_EVIP]) || i_bShop[client][Shop_Wallhang] == 1)
          {
            if(buttons & IN_USE && b_ClientWallHang[client] == false)
            {
              float f_FinallVector[3];
              float f_EyePosition[3];
              float f_EyeViewPoint[3];
              GetClientEyePosition(client, f_EyePosition);
              GetPlayerEyeViewPoint(client, f_EyeViewPoint);
              MakeVectorFromPoints(f_EyeViewPoint, f_EyePosition, f_FinallVector);
              if(GetVectorLength(f_FinallVector) < 30)
              {
                b_ClientWallHang[client] = true;
              }
            }
            else if(buttons & IN_JUMP && b_ClientWallHang[client] == true)
            {
              SetEntityMoveType(client, MOVETYPE_WALK);

              float f_cLoc[3];
              float f_cAng[3];
              float f_cEndPos[3];
              float f_vector[3];
              GetClientEyePosition(client, f_cLoc);
              GetClientEyeAngles(client, f_cAng);
              TR_TraceRayFilter(f_cLoc, f_cAng, MASK_ALL, RayType_Infinite, TraceRayTryToHit);
              TR_GetEndPosition(f_cEndPos);
              MakeVectorFromPoints(f_cLoc, f_cEndPos, f_vector);
              NormalizeVector(f_vector, f_vector);
              ScaleVector(f_vector, 320.0);
              TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, f_vector);
              b_ClientWallHang[client] = false;
            }
            if(b_ClientWallHang[client] == true)
            {
              SetEntityMoveType(client, MOVETYPE_NONE);
              float f_Velocity[3] = {0.0, 0.0, 0.0};
              TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, f_Velocity);
            }
          }
        }
      }
      // DoubleJump
      if(cVb_DoubleJump == true)
      {
        if(b_ClientWallHang[client] == false)
        {
          if (i_dJlFlags[client] & FL_ONGROUND)
          {
            if (!(cFlags & FL_ONGROUND) && !(i_dJlButtons[client] & IN_JUMP) && cButtons & IN_JUMP)
            {
              i_dJjCount[client]++;
            }
          }
          else if (cFlags & FL_ONGROUND)
          {
            i_dJjCount[client] = 0;
          }
          else if (!(i_dJlButtons[client] & IN_JUMP) && cButtons & IN_JUMP)
          {
            if ( 1 <= i_dJjCount[client] <= (i_ClientActiveItem[client] == Item_MultiJump?cVi_DoubleJump_MaxJump+1:cVi_DoubleJump_MaxJump))
            {
              i_dJjCount[client]++;
              float vVel[3];
              GetEntPropVector(client, Prop_Data, "m_vecVelocity", vVel);
              vVel[2] = cVf_DoubleJump_JumpHeight;
              TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, vVel);
            }
          }
          i_dJlFlags[client]	= cFlags;
          i_dJlButtons[client]	= cButtons;
        }
      }
      // KeyPress Detect
      for (int i = 0; i < MAX_BUTTONS; i++)
      {
        int button = (1 << i);
        if ((buttons & button))
        {
          if (!(g_cLastButtons[client] & button))
          {
            OnButtonPress(client, button);
          }
        }
        else if ((g_cLastButtons[client] & button))
        {
          OnButtonRelease(client, button);
        }
      }
      g_cLastButtons[client] = buttons;
    }
  }
  return Plugin_Continue;
}
