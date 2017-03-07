public void OnConVarChanged(ConVar convar, const char[] oldValue, const char[] newValue)
{
  if(convar == cV_DisableBomb)
  {
    cVi_DisableBomb = GetConVarInt(cV_DisableBomb);
  }
  else if(convar == cV_Gravity)
  {
    cVf_Gravity = GetConVarFloat(cV_Gravity);
  }
  else if(convar == cV_Speed)
  {
    cVf_Speed = GetConVarFloat(cV_Speed);
  }
  else if(convar == cV_Footsteps)
  {
    cVb_Footsteps = GetConVarBool(cV_Footsteps);
  }
  else if(convar == cV_BombBeacon)
  {
    cVb_BombBeacon = GetConVarBool(cV_BombBeacon);
  }
  else if(convar == cV_BombBeacon_Delay)
  {
    cVf_BombBeacon_Delay = GetConVarFloat(cV_BombBeacon_Delay);
  }
  else if(convar == cV_BombBeacon_Radius)
  {
    cVf_BombBeacon_Radius = GetConVarFloat(cV_BombBeacon_Radius);
  }
  else if(convar == cV_BombBeacon_Life)
  {
    cVf_BombBeacon_Life = GetConVarFloat(cV_BombBeacon_Life);
  }
  else if(convar == cV_BombBeacon_Width)
  {
    cVf_BombBeacon_Width = GetConVarFloat(cV_BombBeacon_Width);
  }
  else if(convar == cV_BombBeacon_Color)
  {
    GetConVarColor(cV_BombBeacon_Color, cVi_BombBeacon_Color);
  }
  else if(convar == cV_BombBeacon_RandomColor)
  {
    cVb_BombBeacon_RandomColor = GetConVarBool(cV_BombBeacon_RandomColor);
  }
  /*else if(convar == cV_Invisible_Speed)
  {
    cVf_Invisible_Speed = GetConVarFloat(cV_Invisible_Speed);
  }*/
  else if(convar == cV_Invisible_Alpha_Reduce)
  {
    cVi_Invisible_Alpha_Reduce = GetConVarInt(cV_Invisible_Alpha_Reduce);
  }
  else if(convar == cV_Invisible)
  {
    cVb_Invisible = GetConVarBool(cV_Invisible);
  }
  else if(convar == cV_FallDownSpeed)
  {
    cVb_FallDownSpeed = GetConVarBool(cV_FallDownSpeed);
  }
  else if(convar == cV_WallHang)
  {
    cVb_WallHang = GetConVarBool(cV_WallHang);
  }
  else if(convar == cV_DoubleJump)
  {
    cVb_DoubleJump = GetConVarBool(cV_DoubleJump);
  }
  else if(convar == cV_DoubleJump_MaxJump)
  {
    cVi_DoubleJump_MaxJump = GetConVarInt(cV_DoubleJump_MaxJump);
  }
  else if(convar == cV_DoubleJump_JumpHeight)
  {
    cVf_DoubleJump_JumpHeight = GetConVarFloat(cV_DoubleJump_JumpHeight);
  }
  else if(convar == cV_FallDown)
  {
    cVf_FallDown = GetConVarFloat(cV_FallDown);
  }
}
