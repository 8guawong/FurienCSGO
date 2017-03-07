public void OnGameFrame()
{
  float f_EngineTime = GetEngineTime();
  if(b_DisableBomb == true)
  {
    float timeleft = f_DisableBomb - f_EngineTime + float(cVi_DisableBomb);
    if(timeleft < 0.01)
    {
      int index = -1;
      while ((index = FindEntityByClassname(index, "func_bomb_target")) != -1)
      {
        AcceptEntityInput(index, "Enable");
      }
      b_DisableBomb = false;
    }
  }
}
