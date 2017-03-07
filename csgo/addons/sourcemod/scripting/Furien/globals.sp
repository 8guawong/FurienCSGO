#define CHAT_TAG "[\x05FURIEN\x01]"
#define MODEL_LASERBEAM "materials/sprites/laserbeam.vmt"
#define MODEL_FURIEN "models/player/custom_player/caleon1/connor/connor.mdl"
#define MODEL_FURIEN_ARMS "models/player/custom_player/caleon1/connor/connor_arms.mdl"
#define MODEL_ANTIFURIEN "models/player/custom_player/caleon1/nkpolice/nkpolice.mdl"
#define MODEL_ANTIFURIEN_ARMS "models/player/custom_player/caleon1/nkpolice/nkpolice_arms.mdl"

#define MINIMUM_PLAYERS_TO_GET_MONEY 6

#define WINNER_FURIEN_3STREAK 30
#define FURIEN_BOMB_PLANTED 30
#define FURIEN_BOMB_DEFUSED 30

enum
{
  ACC_ZERO = 0,
  ACC_VIP,
  ACC_EVIP
};
AdminFlag g_AccType[3] = {Admin_Reservation ,Admin_Custom6, Admin_Custom5};
Handle db = null;
char db_error[200];
char db_query[256];
int i_cMoney[MAXPLAYERS+1] = {0,...};

char g_sRadioCommands[][] = {"coverme", "takepoint", "holdpos", "regroup", "followme", "takingfire", "go", "fallback", "sticktog", "getinpos", "stormfront", "report", "roger", "enemyspot", "needbackup", "sectorclear",
"inposition", "reportingin", "getout", "negative","enemydown", "compliment", "thanks", "cheer"};

ConVar cV_DisableBomb;
int cVi_DisableBomb;
ConVar cV_Gravity;
float cVf_Gravity;
ConVar cV_Speed;
float cVf_Speed;
ConVar cV_FallDown;
float cVf_FallDown;
ConVar cV_Footsteps;
bool cVb_Footsteps;
ConVar cV_BombBeacon;
bool cVb_BombBeacon;
ConVar cV_BombBeacon_Delay;
float cVf_BombBeacon_Delay;
ConVar cV_BombBeacon_Radius;
float cVf_BombBeacon_Radius;
ConVar cV_BombBeacon_Life;
float cVf_BombBeacon_Life;
ConVar cV_BombBeacon_Width;
float cVf_BombBeacon_Width;
ConVar cV_BombBeacon_Color;
int cVi_BombBeacon_Color[4];
ConVar cV_BombBeacon_RandomColor;
bool cVb_BombBeacon_RandomColor;
/*ConVar cV_Invisible_Speed;
float cVf_Invisible_Speed;*/
ConVar cV_Invisible_Alpha_Reduce;
int cVi_Invisible_Alpha_Reduce;
ConVar cV_Invisible;
bool cVb_Invisible;
ConVar cV_FallDownSpeed;
bool cVb_FallDownSpeed;
ConVar cV_WallHang;
bool cVb_WallHang;
ConVar cV_DoubleJump;
bool cVb_DoubleJump;
ConVar cV_DoubleJump_MaxJump;
int cVi_DoubleJump_MaxJump;
ConVar cV_DoubleJump_JumpHeight;
float cVf_DoubleJump_JumpHeight;

// Nazev , Class , Cena, VIP ?
char g_sAntiFuriensWeps[][] =
{
  "MAG7", "weapon_mag7", "0", "0",
  "UMP45", "weapon_ump45", "0", "0",
  "AWP", "weapon_awp", "15", "0",
  "MP9", "weapon_mp9", "25", "0",
  "FAMAS", "weapon_famas", "35", "0",
  "MP7", "weapon_mp7", "25", "2",
  "M4A4", "weapon_m4a1", "35", "1",
  "AK47", "weapon_ak47", "35", "1"
};

char g_sAntiFuriensSecondaryWeps[][] =
{
  "Glock", "weapon_glock", "0", "0",
  "USP/P2000", "weapon_hkp2000", "0", "0",
  "P250", "weapon_p250", "5", "0",
  "Five-seven", "weapon_fiveseven", "7", "0",
  "Tec-9", "weapon_tec9", "15", "0",
  "Deagle", "weapon_deagle", "15", "0"
};

int g_iAntiFuriensWeaponsId[] =
{
  27,24,9,33,16,7,4,61,32,36,3,1,34,10,30
};
int g_iAntiFuriensWeaponsAmmoPrimary[] =
{
  5,25,10,30,30,30,20,12,13,13,20,7,30,25,32
};
int g_iAntiFuriensWeaponsAmmoSecondary[] =
{
  32,100,30,120,90,90,120,24,52,26,100,35,120,95,120
};
char g_sFuriensHecle[][] =
{
  "Behind you", "behindyou", "0", "0",
  "I'm Here", "imhere", "0", "0",
  "I see you", "iseeyou", "0", "2",
  "Turn around", "turnaround", "0", "0",
  "My name is Jeff", "mynameisjeff1", "0", "1"
};

float f_DisableBomb;
bool b_DisableBomb;

Handle h_BombBeacon = null;
int i_BeamIndex;
int i_ExplosionIndex;
int i_SmokeIndex;
float f_BombBeaconPos[3];

bool b_IsClientInvisible[MAXPLAYERS+1] = {false,...};
bool b_IsClientInvisiblePre[MAXPLAYERS+1] = {false,...};
bool b_ClientMovedAfterSpawn[MAXPLAYERS+1] = {false,...};
float f_ClientInvisible[MAXPLAYERS+1];

bool b_ClientWallHang[MAXPLAYERS+1] = {false,...};

int	i_dJjCount[MAXPLAYERS+1];
int	i_dJlButtons[MAXPLAYERS+1];
int	i_dJlFlags[MAXPLAYERS+1];

int i_F_RoundWinStream = 0;
bool b_F_RoundSwtichTeams = false;


int i_F_SuperKnifeBought;
int i_F_SuperKnifeAvailable;

#define HIDE_ALL 1<<2
#define HIDE_RADAR 1<<12

char s_FurienModelList[][] =
{
  "models/player/custom_player/caleon1/connor/connor.dx90.vtx",
  "models/player/custom_player/caleon1/connor/connor.mdl",
  "models/player/custom_player/caleon1/connor/connor.phy",
  "models/player/custom_player/caleon1/connor/connor.vvd",
  "models/player/custom_player/caleon1/connor/connor_arms.dx90.vtx",
  "models/player/custom_player/caleon1/connor/connor_arms.mdl",
  "models/player/custom_player/caleon1/connor/connor_arms.vvd",
  "materials/models/player/custom_player/caleon1/connor/Connor_hands.vmt",
  "materials/models/player/custom_player/caleon1/connor/Connor_hands.vtf",
  "materials/models/player/custom_player/caleon1/connor/Connor_hands_n.vtf",
  "materials/models/player/custom_player/caleon1/connor/Connor_head.vmt",
  "materials/models/player/custom_player/caleon1/connor/Connor_head.vtf",
  "materials/models/player/custom_player/caleon1/connor/Connor_head_n.vtf",
  "materials/models/player/custom_player/caleon1/connor/Connor_arm-blade.vmt",
  "materials/models/player/custom_player/caleon1/connor/Connor_arm-blade.vtf",
  "materials/models/player/custom_player/caleon1/connor/Connor_arm-blade_n.vtf",
  "materials/models/player/custom_player/caleon1/connor/Connor_clothes1.vmt",
  "materials/models/player/custom_player/caleon1/connor/Connor_clothes1.vtf",
  "materials/models/player/custom_player/caleon1/connor/Connor_clothes1_n.vtf",
  "materials/models/player/custom_player/caleon1/connor/Connor_clothes2.vmt",
  "materials/models/player/custom_player/caleon1/connor/Connor_clothes2.vtf",
  "materials/models/player/custom_player/caleon1/connor/Connor_clothes2_n.vtf",
  "materials/models/player/custom_player/caleon1/connor/Connor_clothes3.vmt",
  "materials/models/player/custom_player/caleon1/connor/Connor_clothes3.vtf",
  "materials/models/player/custom_player/caleon1/connor/Connor_clothes3_n.vtf",
  "materials/models/player/custom_player/caleon1/connor/Connor_clothes4.vmt",
  "materials/models/player/custom_player/caleon1/connor/Connor_clothes4.vtf",
  "materials/models/player/custom_player/caleon1/connor/Connor_clothes4_n.vtf",
  "materials/models/player/custom_player/caleon1/connor/Connor_eyes.vmt",
  "materials/models/player/custom_player/caleon1/connor/Connor_eyes.vtf"
};

char s_AntiFurienModelList[][] =
{
  "materials/models/player/custom_player/caleon1/nkpolice/policemap2.vtf",
  "materials/models/player/custom_player/caleon1/nkpolice/policemap2_n.vtf",
  "materials/models/player/custom_player/caleon1/nkpolice/policemap1.vmt",
  "materials/models/player/custom_player/caleon1/nkpolice/policemap1.vtf",
  "materials/models/player/custom_player/caleon1/nkpolice/policemap1_n.vtf",
  "materials/models/player/custom_player/caleon1/nkpolice/policemap2.vmt",
  "models/player/custom_player/caleon1/nkpolice/nkpolice.vvd",
  "models/player/custom_player/caleon1/nkpolice/nkpolice_arms.dx90.vtx",
  "models/player/custom_player/caleon1/nkpolice/nkpolice_arms.mdl",
  "models/player/custom_player/caleon1/nkpolice/nkpolice_arms.vvd",
  "models/player/custom_player/caleon1/nkpolice/nkpolice.dx90.vtx",
  "models/player/custom_player/caleon1/nkpolice/nkpolice.mdl",
  "models/player/custom_player/caleon1/nkpolice/nkpolice.phy"
};
bool b_SelectWepPrimary[MAXPLAYERS+1] = {false,...};
bool b_SelectWepSecondary[MAXPLAYERS+1] = {false,...};

bool b_ClientVerified[MAXPLAYERS+1] = {false,...};

enum e_AF_Shop
{
  AF_Item_Defuse,
  AF_Item_VestHelp,
  AF_Item_Lekarnicka,
  AF_Item_OdhalovaciGranat
};
int i_AF_Shop[e_AF_Shop] =
{
  /*Defusky*/10,
  /*Vesta a Helma*/60,
  /*Lekarnicka*/50,
  /*Odhalovací granát*/70
};

enum e_F_Shop
{
  F_Item_HeGrenade,
  F_Item_Lekarnicka,
  F_Item_SuperKnife,
  F_Item_ElectricGun,
  F_Item_Wallhang
};
int i_F_Shop[e_F_Shop] =
{
  /*He granat*/35,
  /*Lekarnicka*/50,
  /*Super knife*/90,
  /*Electric gun*/100,
  /*Wallhang*/50
};

enum e_ShopBought
{
  Shop_Lekarnicka,
  Shop_HeGrenade,
  Shop_SuperKnife,
  Shop_ElectricGun,
  Shop_Wallhang,
  Shop_OhdalovaciGranat,
  Shop_Count
};
int i_bShop[MAXPLAYERS+1][e_ShopBought];

enum
{
  Grenade_Default,
  Grenade_Impact,
  Grenade_Detonate,
  Grenade_ModeCount
};
char s_GrenadeType[][] =
{
  "Normální", "Nárazový", "Odpalovací"
};

int i_gClientGrenadeMode[MAXPLAYERS+1];
int i_gClientGrenadeRef[MAXPLAYERS+1][Grenade_ModeCount];
bool b_g_ClientGrenadeDetonateRdy[MAXPLAYERS+1];

float f_gInvisibleDelay[MAXPLAYERS+1];

enum
{
  Settings_ShowDmg,
  Settings_ThirdPerson,
  Settings_F_OpenMainMenu_RS,
  Settings_OpenMainMenu_onF,
  Settings_Count
};
Handle h_Settigs[Settings_Count];
int i_Settings[MAXPLAYERS+1][Settings_Count];

enum
{
  SItem_Regenerace,
  SItem_Mrstnost,
  SItem_Zmateni,
  SItem_ZaseknutiZbrane,
  SItem_MultiJump,
  SItem_DrtiveStrely,
  SItem_ChytreOko,
  SItem_DoplnovaniNaboju,
  SItem_Count
}
int i_SpecialItem[SItem_Count] =
{
  /*Regenerace*/13000,
  /*Mrstnost*/11000,
  /*Zmateni*/12000,
  /*Zaseknuti zbraně*/14000,
  /*Multi jump*/15000,
  /*Drtivé střely*/10000,
  /*Chytré oko*/14000,
  /*Doplňování nábojů*/12000
};
enum
{
  Item_None,
  Item_Regenerace,
  Item_Mrstnost,
  Item_Zmateni,
  Item_ZaseknutiZbrane,
  Item_MultiJump,
  Item_DrtiveStrely,
  Item_ChytreOko,
  Item_DoplnovaniNaboju,
  Item_Count
};

int i_ClientActiveItem[MAXPLAYERS+1];
int i_ClientBoughtItems[MAXPLAYERS+1][Item_Count];

int i_SpecialItem_RegeneraceMaxHealth[MAXPLAYERS+1];
Handle t_SpecialItem_Regenerace[MAXPLAYERS+1] = {null,...};
Handle t_SpecialItem_Zmateni[MAXPLAYERS+1] = {null,...};
Handle t_SpecialItem_DrtiveStrely[MAXPLAYERS+1] = {null,...};

int g_MainClipOffset;
int g_offsNextSecondaryAttack;

bool b_VIPDuel = false;

#define MAX_BUTTONS 25
int g_cLastButtons[MAXPLAYERS+1];
